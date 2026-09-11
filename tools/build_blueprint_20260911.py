"""Build the review PDF from editable project-local Markdown and candidate assets.

This is a document renderer, not a Godot screenshot or a raster art generator.
"""
from pathlib import Path
import hashlib
import json
import re
from html import escape
from PIL import Image
from reportlab.pdfgen import canvas
from reportlab import rl_config
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.colors import HexColor, Color
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import Paragraph, Table, TableStyle
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / '.asset-vault/blueprint-20260911'
ASE = ROOT / '.asset-vault/aseprite-candidates/blueprint-20260911'
OUT = ROOT / 'output/pdf'
OUT.mkdir(parents=True, exist_ok=True)
PDF = OUT / 'URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_OPTIMIZED.pdf'
# Binary Flate streams preserve original pixels; ASCII85 adds transport overhead.
rl_config.useA85 = False
pdfmetrics.registerFont(TTFont('KR', 'C:/Windows/Fonts/malgun.ttf'))
pdfmetrics.registerFont(TTFont('KRB', 'C:/Windows/Fonts/malgunbd.ttf'))
W, H = 1080, 720
INK = HexColor('#202a2d')
PAPER = HexColor('#f5f0e5')
GOLD = HexColor('#a1834b')
TEAL = HexColor('#326c6c')
STYLE = ParagraphStyle('body', fontName='KR', fontSize=14, leading=22,
                       textColor=INK, wordWrap='CJK', spaceAfter=10)
CELL = ParagraphStyle('cell', parent=STYLE, fontSize=11.5, leading=17)
SMALL = ParagraphStyle('small', parent=STYLE, fontSize=10, leading=14)
c = canvas.Canvas(str(PDF), pagesize=(W,H), pageCompression=1)
c.setTitle('괴이기록국: 잔향 보고서 | 사람용 블루프린트 검토판')
c.setAuthor('Urban Legend project / design review')
page = 0
toc = []
checks = []
y = 0
section = ''

def clean(t):
    t = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'\1 (\2)', t)
    return escape(t.replace('**','').replace('`','').replace('−','-'))

def txt(t,x,y,size=12,color=INK,font='KR'):
    c.setFillColor(color); c.setFont(font,size); c.drawString(x,y,t)

def newpage(title, continued=False):
    global page,y,section
    if page: c.showPage()
    page += 1; section = title
    c.setFillColor(PAPER); c.rect(0,0,W,H,fill=1,stroke=0)
    c.setFillColor(INK); c.rect(0,H-104,W,104,fill=1,stroke=0)
    txt('괴이기록국: 잔향 보고서  /  HUMAN BLUEPRINT',40,H-31,12,HexColor('#d7c69f'))
    txt(title + (' · 계속' if continued else ''),40,H-77,25,HexColor('#f8f0de'),'KRB')
    c.setStrokeColor(GOLD); c.line(40,43,W-40,43)
    txt('2026-09-11  |  설계·자산 후보 / 최종 승인 전  |  실제 실행 화면과 구분',40,24,9)
    txt(f'{page:02d}',W-66,24,12)
    y=H-128
    if not continued:
        toc.append({'page':page,'title':title})
        c.bookmarkPage(f'p{page}');c.addOutlineEntry(title,f'p{page}',0)

def room(h):
    if h>y-62:newpage(section,True)

def para(t,style=STYLE):
    global y
    p=Paragraph(clean(t),style); _,h=p.wrap(W-80,H)
    if h>H-195: raise ValueError('Paragraph larger than a page: '+t[:70])
    room(h+12);p.drawOn(c,40,y-h); y-=h+12
    checks.append({'page':page,'kind':'text','bottom':round(y,2)})

def table(rows):
    global y
    n=len(rows[0]); widths=[(W-80)/n]*n
    def make(rs):
        pad=8 if 'M01 —' in section else 9
        data=[[Paragraph(clean(x),CELL) for x in row] for row in rs]
        t=Table(data,colWidths=widths)
        t.setStyle(TableStyle([
            ('BACKGROUND',(0,0),(-1,0),HexColor('#ded4be')),
            ('ROWBACKGROUNDS',(0,1),(-1,-1),[HexColor('#fcfaf5'),HexColor('#eee9de')]),
            ('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),10),
            ('RIGHTPADDING',(0,0),(-1,-1),10),('TOPPADDING',(0,0),(-1,-1),pad),
            ('BOTTOMPADDING',(0,0),(-1,-1),pad),('LINEBELOW',(0,0),(-1,0),1,GOLD),
            ('LINEBELOW',(0,1),(-1,-1),0.3,HexColor('#c4bba8'))]))
        return t
    remaining=rows[1:]
    while remaining:
        selected=[]
        for row in remaining:
            trial=make([rows[0]]+selected+[row]);_,h=trial.wrap(W-80,H)
            if h>y-68:break
            selected.append(row)
        if not selected:
            if y<H-129:newpage(section,True);continue
            raise ValueError('Table row too tall')
        t=make([rows[0]]+selected);_,h=t.wrap(W-80,H)
        t.drawOn(c,40,y-h);y-=h+16
        checks.append({'page':page,'kind':'table','bottom':round(y,2)})
        remaining=remaining[len(selected):]
        if remaining:newpage(section,True)

def img(path,x,yy,w,h):
    c.drawImage(str(path),x,yy,width=w,height=h,preserveAspectRatio=True,
                anchor='c',mask='auto')

def region_img(path,region,x,yy,w,h):
    """Document clipping of a real atlas; no raster creation or source editing."""
    rx,ry,rw,rh=region; iw,ih=Image.open(path).size
    c.saveState();clip=c.beginPath();clip.rect(x,yy,w,h);c.clipPath(clip,stroke=0)
    c.drawImage(str(path),x-rx*w/rw,yy-(ih-ry-rh)*h/rh,
                width=iw*w/rw,height=ih*h/rh,mask='auto');c.restoreState()

def screen(kind,x,yy,w,h):
    """Text-native wireframe placed over candidate art; never a claimed screenshot."""
    if kind in ('records','map') or kind.startswith(('recovery','manual')):
        detailed_screen(kind,x,yy,w,h)
        return
    c.saveState();c.translate(x,yy);c.scale(w/960,h/540)
    bg='bureau' if kind in ('main','daily','preparation') else 'station'
    img(ASSETS/(bg+'.png'),0,0,960,540)
    c.setFillColor(Color(.02,.03,.04,.88));c.rect(0,492,960,48,fill=1,stroke=0)
    txt('괴이기록국: 잔향 보고서',20,510,15,HexColor('#e5d3a4'))
    def box(xx,yy,ww,hh,title,body=''):
        c.setFillColor(Color(.03,.045,.045,.94));c.setStrokeColor(GOLD)
        c.roundRect(xx,yy,ww,hh,5,fill=1,stroke=1)
        txt(title,xx+10,yy+hh-24,15,HexColor('#e5d3a4'))
        if body:txt(body,xx+10,yy+14,10,HexColor('#bec9c5'))
    if kind=='main':
        img(ASSETS/'wordmark.png',22,282,306,190)
        txt('숨은 규칙을 기록하고, 현장에서 살아남는다',28,263,11,HexColor('#dcc28b'))
        for by,bh,title,body in [(362,80,'본편 시작','새로운 사건을 조사합니다'),(284,66,'이어 하기','이전 기록에서 계속합니다'),(188,70,'Validation','검증되지 않은 기록'),(129,50,'기록 보관실',''),(73,50,'설정',''),(17,50,'종료','')]:
            region=(800,702,704,230) if title=='본편 시작' else (32,65,704,230)
            region_img(ASSETS/'ui-button-states.png',region,355,by,300,bh)
            txt(title,374,by+bh/2,20,HexColor('#f1e3c4'),'KRB')
            if body:txt(body,375,by+bh/2-20,10,HexColor('#c7bb9f'))
        box(687,262,245,194,'현재 사건 · 저승역','실제 저장 상태를 표시')
        box(687,51,245,192,'최근 기록 · 저장 슬롯','빈 슬롯은 비어 있음으로 표시')
    elif kind=='manual':
        c.setFillColor(HexColor('#0b1112'));c.rect(12,18,936,458,fill=1,stroke=0)
        box(24,34,172,426,'괴이 매뉴얼 INDEX')
        for i,s in enumerate(['발생 조건','피해자 연결','금지 행동','구출 절차','회수 대응']):box(34,357-i*67,152,55,s)
        box(210,34,426,426,'제1장 · 발생 조건')
        lines=['원본 안내방송의 목적지 구간에는','① [                 ] 이 남아 있다.','','같은 순간 서로 다른 목적지가 기록된다.','개인이 들은 말과 원본을 대조한다.','','현재 초안: 미확정 가설','선택한 후보의 출처를 다시 열 수 있다.']
        for i,s in enumerate(lines):txt(s,227,390-i*34,15,HexColor('#dac99f'))
        box(650,245,286,215,'후보 키워드')
        for i,s in enumerate(['방송의 공백','목적지 이름 안내','동시간대 목적지 불일치','공통 목적지']):box(661,367-i*37,264,30,s)
        box(650,34,286,196,'기록 보조 · 루메')
        img(ASSETS/'lume.png',656,40,103,149)
        txt('원본 기록을',768,140,13,HexColor('#e1d1ab'));txt('다시 열 수 있어요.',768,116,13,HexColor('#e1d1ab'))
    elif kind=='recovery':
        box(20,350,230,122,'위험 2 / 6','활성 현장 시간에 증가')
        box(706,350,234,122,'안정화 3 / 8','유효한 현장 대응으로 증가')
        img(ASSETS/'oh-hyeon.png',270,107,155,322)
        img(ASSETS/'kang-ijun.png',499,92,155,337)
        box(20,125,225,87,'보호 상태 · 안정','위험 전조를 관측 중')
        box(20,24,688,84,'현재 전조 · 목적지 합창','방법 → 대상 → 시점으로 대응을 확정합니다')
        box(730,24,210,84,'괴이 매뉴얼','열람 중 현장 정지')
    elif kind=='result':
        for i,s in enumerate(['피해자 · 안전 귀환','괴이 · 부분 억제','기록 · 미해결 모순','자원 · 확정 내역']):box(68+i%2*435,257-i//2*183,390,164,s,'결과 축을 독립 보존')
    elif kind=='daily':
        img(ASSETS/'narae.png',285,103,190,350)
        box(20,358,230,110,'일상 · 기록국','일정 / 행동력 제한 없음')
        for i,s in enumerate(['직원과 대화','기록 보관실','장비 확인']):box(665,342-i*88,270,68,s)
        box(20,24,612,100,'권나래 · 사건 사이의 기록','대화는 선택 사항. 필수 진실을 잠그지 않습니다.')
        box(656,24,279,100,'사건 준비로','일상을 건너뛰고 진행 가능')
    elif kind=='preparation':
        box(20,322,300,146,'사건 선택 · 저승역','확보 기록 / 현재 진행 상태')
        box(20,174,300,130,'지원 요원','필수 3인 편성 아님')
        for i,s in enumerate(['분광경 · 비교 프리셋','청음기 · 재생 프리셋','고정핀 · 피해 완충','응급 지혈부 · 회복']):box(340+i%2*300,276-i//2*104,280,88,s)
        box(20,24,611,107,'준비 내용 확인','구매품과 필수 기록 접근을 구분합니다.')
        box(656,24,279,107,'현장으로','실제 접근 조건만 확인')
    elif kind=='investigation':
        for xx,yy,label in [(335,330,'방송 원본'),(558,285,'역 식별 표지'),(402,176,'승차권 기록')]:box(xx,yy,164,55,label)
        box(20,315,251,157,'현장 조사 · 승강장','관측 지점은 키보드로도 선택')
        box(20,24,685,115,'원본 기록 · 방송의 공백','출처 / 시각 / 전사 구분 · 원본 재생')
        box(729,24,208,115,'괴이 매뉴얼','획득 기록에서 가설 작성')
    elif kind=='rescue':
        box(20,337,267,130,'구출 · 공식 귀환 경로','피해자와 함께 이동')
        for i,s in enumerate(['현재 역 식별','공식 경로/표','동행 하차']):box(318+i*203,270,185,115,s,'기록 대조')
        box(20,24,685,120,'경로 복원 · 선택한 연결을 확인','검은 표는 증거이며 귀환용 공식 표와 구분')
        box(729,24,208,120,'괴이 매뉴얼','읽기 정지')
    elif kind=='minigame':
        box(20,304,282,164,'경로 복원 · 조작 학습','3 × 3 / 본 검증 4 × 4')
        for row in range(3):
            for col in range(3):box(335+col*108,162+row*102,94,88,f'{row*3+col+1}','연결 조각')
        box(697,256,240,212,'선택한 경로','입력 기록과 실제 결과를 보존')
        box(20,24,648,112,'판단 근거를 실제 연결에 적용','연습은 조작만 안내; 사건 정답은 시연하지 않음')
        box(697,24,240,112,'괴이 매뉴얼','읽기 정지')
    else:
        name={'daily':'일상 · 기록국','preparation':'사건 준비','investigation':'현장 조사','rescue':'구출 경로','minigame':'규칙 적용 · 미니게임'}.get(kind,kind)
        box(20,363,244,103,name,'관측·선택·결과를 연결')
        box(20,24,675,109,'확보 기록 / 현재 상황','실제 관측한 정보만 표시')
        box(720,24,220,109,'괴이 매뉴얼','출처 대조 / 초안 작성')
    c.restoreState()

def special(line):
    global y
    if line=='@atlas':
        kinds=['main','daily','preparation','investigation','records','map','manual','rescue','recovery','minigame','result']
        names=['01 메인','02 일상','03 준비','04 현장 조사','05 기록','06 지도','07 매뉴얼','08 구출','09 회수','10 미니게임','11 결과']
        for i,(k,label) in enumerate(zip(kinds,names)):
            xx=40+(i%4)*252;yy=86+(2-i//4)*175
            screen(k,xx,yy,235,132.2);txt(label,xx,yy-14,10)
        txt('신규 자산 + 편집 가능한 화면 설계 / 실제 Godot 실행 캡처 아님',40,61,9)
        y=55
    elif line.startswith('@screen'):
        if line.split()[1] in ('main','records','map') or line.split()[1].startswith(('recovery','manual')):
            room(516);screen(line.split()[1],100,y-495,880,495)
            txt('상호작용 배치 명세 / 텍스트 네이티브 UI + 신규 후보 / 실제 실행 캡처 아님',100,y-511,9)
            y-=528
            return
        room(236);screen(line.split()[1],40,y-222,395,222)
        p=Paragraph('설계 합성 뷰<br/>신규 배경 + 편집 가능한 UI<br/><br/>실제 엔진 캡처가 아닙니다.<br/>아래 설명은 입력·상태·복귀 계약입니다.',STYLE)
        _,hh=p.wrap(510,220);p.drawOn(c,475,y-hh-20);y-=236
    elif line=='@flow':
        labels=['일상·준비','조사·매뉴얼','구출/현장검증','회수·억제','결과·환류']
        for i,label in enumerate(labels):
            x=40+i*201;c.setFillColor(INK);c.roundRect(x,y-66,183,54,5,fill=1,stroke=0)
            txt(label,x+12,y-44,16,HexColor('#e9d9b5'))
            if i<4:txt('→',x+186,y-44,15)
        y-=88
    elif line=='@backgrounds':
        room(265)
        for i,name in enumerate(['bureau','station','alley','broadcast']):
            xx=40+(i%2)*505;yy=y-122-(i//2)*133
            img(ASSETS/(name+'.png'),xx,yy,216,121)
            txt(name+'.png',xx+232,yy+52,13)
        y-=281
    elif line=='@staff':
        room(240);img(ASE/'staff-atlas-clean.png',40,y-235,990,235);y-=250
    elif line=='@lume':
        room(290)
        for i,name in enumerate(['lume.png','lume-m04-sd.png','lume-m07.png']):
            img(ASSETS/name,40+i*335,y-262,310,262)
            txt(['저승역','빨간 우산 골목','폐주파수 방송국'][i],145+i*335,y-278,11)
        y-=302
    elif line.startswith('@image'):
        name=line.split()[1];room(278)
        img(ASSETS/name,40,y-264,1000,264);y-=282

def detailed_screen(kind,x,yy,w,h):
    """Editable information architecture, not painted art or a runtime capture."""
    c.saveState();c.translate(x,yy);c.scale(w/960,h/540)
    cream=HexColor('#dfcda3');muted=HexColor('#aca58f');red=HexColor('#d17257')
    c.setFillColor(HexColor('#090e0e'));c.rect(0,0,960,540,fill=1,stroke=0)
    case=kind.rsplit('_',1)[-1] if '_' in kind else 'm01'
    if kind.startswith('manual_'):kind='manual'
    case_info={
        'm01':('station','m01-attendant','CASE-01 저승역','이하린','목적지 합창','겹치는 방송 / 목적지 구간 변화','방송 장치 조작','방송 원본의 공백','서로 다른 목적지',0),
        'm04':('alley','m04-umbrella','M04 빨간 우산','귀가하지 못한 목격자','빗소리 반복','관측된 빗소리 / 물웅덩이 흐름','경로 고정 조작','빗소리와 역류','귀가 흔적 기록',1),
        'm07':('broadcast-recovery','m07-presenter','M07 폐주파수 방송국','응답한 청취자','호출 음성 반복','호출 기록 / 수신 반응 변화','릴 접합부 조작','호출 대본','청취자 녹음',2),
    }[case]
    recovering=kind.startswith('recovery')
    if recovering:img(ASSETS/(case_info[0]+'.png'),0,0,960,540)
    def panel(xx,yy,ww,hh):
        c.setFillColor(Color(.025,.034,.034,.95));c.setStrokeColor(GOLD);c.setLineWidth(.7)
        c.rect(xx,yy,ww,hh,fill=1,stroke=1)
        c.setStrokeColor(HexColor('#403b2b'));c.rect(xx+3,yy+3,ww-6,hh-6,fill=0,stroke=1)
    def label(t,xx,yy,size=13,color=cream):txt(t,xx,yy,size,color)
    def button(t,xx,yy,ww,hh=33,selected=False):
        panel(xx,yy,ww,hh)
        if selected:
            c.setFillColor(Color(.52,.40,.16,.25));c.rect(xx+3,yy+3,ww-6,hh-6,fill=1,stroke=0)
        label(t,xx+9,yy+hh/2-4,12)
    def lines(items,xx,top,size=13,step=25,color=cream):
        for i,t in enumerate(items):label(t,xx,top-i*step,size,color)
    panel(8,492,944,40);label('怪  괴이기록국',22,507,17)
    label(case_info[2],187,508,12)
    if not recovering:
        for i,(k,t) in enumerate([('records','기록'),('manual','괴이 매뉴얼'),('map','지도'),('log','로그')]):
            button(t,386+i*103,500,97,25,k==kind)
        button('현장 복귀',812,500,129,25)
    if kind=='manual':
        panel(12,17,171,459);label('괴이 매뉴얼 INDEX',25,449,14)
        chapters=['1. 호출 기록','2. 송출 구간','3. 청취자 녹음'] if case=='m07' else ['1. 발생 조건','2. 경계 변화','3. 귀환 절차']
        for i,t in enumerate(chapters):button(t,24,375-i*62,147,49,i==0)
        lines(['현재 초안 · 작성 중','정답 여부는 표시하지 않음','','괴이기록국 공식 문서','미관측 사실은 기록하지 않음'],26,110,9,17,muted)
        panel(196,17,439,459);label('제1장 · '+('호출 기록' if case=='m07' else '발생 조건'),212,446,23)
        label('추리문 01',213,410,14)
        if case=='m07':
            lines(['보존된 대본과 송출 기록에는 같은 이름이','서로 다른 순서로 나타난다. 대본의 빈칸을','채운 입력은 ① [                     ]이며,','이름이 기록된 시점은','② [                     ]로 추정한다.','','따라서 현장에서 호출을 받았을 때는','③ [                     ]라는 가설을','실행해 그 뒤 방송에 무엇이 남는지 관측한다.','','이름이 들렸다는 사실만으로 방송이 그 사람을','미리 알고 있었다고 단정하지 않는다.'],213,373,14,24)
        else:
            lines(['안내방송 원본의 목적지 구간에는','① [                         ] 가 남아 있다.','','피해자가 들은 장소는','② [                         ] 와 연결되어 있다.','','동시간대 기록은','③ [                         ] 를 남긴다.','','공식 운행 기록은','④ [                         ] 를 확인한다.'],213,373,16,24)
        label('선택한 빈칸에 후보 배치 · 출처는 다시 열기',213,50,12,muted)
        panel(648,251,300,225);label('후보 키워드',663,446,17)
        candidates=['응답한 목소리','응답 직후','녹음하되 응답하지 않기','응답 직전','이름이 빈 대본'] if case=='m07' else ['방송의 공백','개인 목적지 기억','공통 목적지','목적지 이름 안내','동시간대 불일치','공식 노선 부재']
        for i,t in enumerate(candidates):
            if case=='m07':button(t,660,405-i*29,276,25)
            else:button(t,660+(i%2)*141,388-(i//2)*43,135,35)
        label('획득 후보만 표시 · 출처 열기',662,273,12,muted)
        panel(648,17,300,221);label('기록 보조',662,212,15)
        img(ASSETS/('lume-m07.png' if case=='m07' else 'lume.png'),655,30,131,178)
        lines(['루메','원본을 다시 열어','비교할 수 있어요.'],794,146,13,24)
    elif kind=='records':
        panel(12,17,126,459);label('기록 ARCHIVE',24,448,13)
        for i,t in enumerate(['전체 기록','현장 기록','증거 자료','인터뷰','분석 메모','위험 사례']):button(t,22,382-i*54,106,42,i==1)
        panel(150,17,238,459);label('현장 기록',163,447,18)
        for i,t in enumerate(['방송 원본','피해자 목적지 기록','동시간대 비교 기록','공식 운행 기록']):
            button(t,161,364-i*78,216,64,i==0)
            label('확보한 원본 / 출처 유지',171,375-i*78,10,muted)
        panel(400,17,352,459);label('방송 원본 · 목적지 구간',414,446,17)
        lines(['종류  현장 녹음 / 원본','관련 장소  현재 조사한 승강장'],416,411,12,25,muted)
        button('원문 기록',414,326,155,32,True);button('조사관 메모',578,326,158,32)
        lines(['방송 원본의 목적지 구간에','공백이 남아 있다.','','원본 재생과 전사 내용을','같은 위치에서 대조한다.'],417,296,16,28)
        button('원본 재생 / 자막',415,102,320,36)
        label('관련 키워드  방송의 공백',417,73,12)
        label('표시 문구는 원본 요약 · 인용문 아님',417,40,10,muted)
        panel(764,17,184,459);label('기록 보조 · 루메',777,446,14)
        img(ASSETS/'lume.png',773,193,167,228)
        lines(['선택한 기록의','원본을 다시','확인할 수 있어요.'],791,156,14,26)
    elif kind=='map':
        panel(12,17,160,459);label('조사 지도',27,446,18)
        for i,t in enumerate(['전체 조사 지점','방송 기록 지점','승차권 확인 지점','표지 확인 지점']):button(t,23,362-i*60,138,48,i==0)
        lines(['현재 위치  ●','방문  ○','조사 가능  !','접근 제한  잠금'],28,140,12,25)
        panel(186,17,505,459);label('저승역 · 조사 지점 구조',204,445,19)
        label('지리·층수 확정 도면 아님',204,418,11,muted)
        # Text-native graph only; no illustration made from primitives.
        c.setStrokeColor(GOLD);c.setLineWidth(2)
        c.line(442,315,315,221);c.line(442,315,573,221)
        button('현재 조사 구역',368,298,154,58,True)
        button('방송 기록',235,178,157,70);button('승차권 / 표지',485,178,165,70)
        label('실제 조사 지점 ID / 이동 조건으로 연결',244,108,13,muted)
        panel(705,17,243,459);label('선택 장소 정보',721,446,18)
        img(ASSETS/'station.png',719,272,216,122)
        lines(['관측된 기록','방송 원본의 공백','','미발견 단서 위치는','미리 표시하지 않습니다.'],721,247,13,24)
        button('장소 확인',719,59,214,40)
        label('허용된 조사 상태에서만 이동',721,33,10,muted)
    elif recovering:
        label('회수 대응',388,507,18)
        for cx,filled,total,col,title in [(737,2,6,red,'위험'),(849,3,8,HexColor('#85b9b0'),'안정화')]:
            for tick in range(total):
                c.setStrokeColor(col if tick<filled else HexColor('#454843'));c.setLineWidth(4)
                c.arc(cx-12,501,cx+12,525,startAng=90-tick*360/total,extent=-(360/total-7))
            label(title+' '+str(filled)+'/'+str(total),cx+17,508,10)
        panel(12,103,165,375);label('사건 목표',25,452,15)
        lines(['피해자 보호','잔향 안정화','','선택 기록 요약',case_info[7],case_info[8],'','기록 더 보기'],25,411,12,27)
        panel(190,397,496,81);label('현재 관측 전조 · '+case_info[4],206,451,18)
        label(case_info[5],206,419,12,muted)
        if case=='m07':
            c.saveState();c.setFillAlpha(.78)
            img(ASSETS/(case_info[1]+'.png'),300,216,300,178)
            c.restoreState()
        else:img(ASSETS/(case_info[1]+'.png'),260,109,350,282)
        panel(702,347,246,131);label('보호 대상 · '+case_info[3],716,451,12)
        region_img(ASSETS/'victims-atlas-anime.png',(case_info[9]*724,0,724,724),714,359,75,75)
        lines(['동행 보호','위험 변화 별도 기록','초상은 외형 후보'],800,418,10,23)
        panel(702,103,246,231);label('상황 대응',716,304,18)
        for i,t in enumerate([case_info[6],'피해자 동행 보호','현재 전조 관찰']):button(t,714,242-i*53,222,42)
        label('정답 추천이 아닌 가능한 조작',716,116,10,muted)
        panel(12,12,674,78)
        for i,t in enumerate(['관찰','보호','장비']):button(t,25+i*123,43,111,34)
        label('직원 상태  지시 / 억제 / 보호 · 실제 수행 때 컷인',27,24,11,muted)
        button('괴이 매뉴얼 열기',702,12,246,78)
        label('열람 중 현장 정지',735,29,11,muted)
    c.restoreState()

def markdown(path,prefix=''):
    lines=path.read_text(encoding='utf-8').splitlines();i=0;started=False
    while i<len(lines):
        line=lines[i].strip()
        if line.startswith('## '):
            started=True;newpage(prefix+line[3:])
        elif not started:
            i+=1;continue
        elif line.startswith('@'):special(line)
        elif line.startswith('|'):
            rows=[]
            while i<len(lines) and lines[i].strip().startswith('|'):
                raw=lines[i].strip()
                if not re.fullmatch(r'[| :\-]+',raw):rows.append([v.strip() for v in raw.strip('|').split('|')])
                i+=1
            table(rows);continue
        elif line and not line.startswith('#'):
            if not page:
                i+=1
                continue
            para(line.lstrip('> '))
        i+=1

markdown(ROOT/'docs/design/BLUEPRINT_20260911.md')
markdown(ROOT/'docs/design/blueprint-20260911-case-appendix.md','부록 / ')
toc_items=list(toc)
newpage('찾아보기 · 실제 페이지 위치')
for i,item in enumerate(toc_items):
    if i and i%48==0:newpage('찾아보기 · 실제 페이지 위치',True)
    column=(i%48)//24;row=i%24
    p=Paragraph(clean(f"{item['page']:02d}  {item['title']}"),SMALL)
    _,hh=p.wrap(475,28);p.drawOn(c,40+column*505,H-136-row*21-hh)
c.save()
assets=[]
provenance = {
 'bureau.png':('exec-4d5512b2-7508-4a2a-a34e-d110abd488fb.png','Main menu and daily archive background'),
 'station.png':('exec-fee500f8-6ca5-4663-80b0-9a3fc8aaa0ed.png','M01 investigation / rescue / recovery background'),
 'alley.png':('exec-b13a636b-3726-46b2-8f0c-3e5029105af8.png','M04 investigation / recovery background'),
 'broadcast.png':('exec-9d72824a-facc-428b-a1f9-e0cecf327070.png','M07 investigation / recovery background'),
 'broadcast-recovery.png':('exec-cd7315d2-3281-4025-a578-f9db823370c1.png','M07 recovery empty booth plate; original broadcast background is style reference'),
 'narae.png':('exec-e82f7e4c-78e0-4899-b95f-12c0d6b5b04a.png','Staff portrait / selected action pose candidate'),
 'oh-hyeon.png':('exec-5e266e50-a19c-4728-9847-eb554adbb4cb.png','Staff portrait / selected action pose candidate'),
 'kang-ijun.png':('exec-712d45a1-9cad-486b-ac6e-5fc91de34b83.png','Staff portrait / selected action pose candidate'),
 'lume.png':('exec-6089fe90-214d-48f3-b3f3-969dbfcfa79c.png','M01 manual guide costume candidate'),
 'lume-m04.png':('exec-6a8cb2b2-c34d-4065-bc84-e75129bbf97c.png','M04 manual guide costume candidate'),
 'lume-m04-red.png':('exec-a8d75902-9765-4ce7-b615-dd33321225b3.png','M04 red raincoat and umbrella guide costume candidate'),
 'm01-attendant.png':('exec-ffb49dd5-c707-4084-82fa-0fb6965abf62.png','M01 recovery anonymous railway attendant manifestation candidate'),
 'lume-m07.png':('exec-56716a39-368a-473a-9bc8-f378870cd94c.png','M07 manual guide costume candidate'),
 'ui-panel.png':('exec-4c71a602-0700-4d25-903b-26c66b846824.png','Record / menu group panel; Aseprite crop y140 h744'),
 'lume-m04-sd.png':('exec-70b03374-f540-4f4c-a866-1f945db435af.png','M04 revised short-body guide; identity final approval pending'),
 'm04-umbrella.png':('exec-523f88d0-a6cd-4290-a093-7e1e93633613.png','M04 adult female apparition, not victim or Lume'),
 'm07-presenter.png':('exec-5def0585-ee75-4658-9390-480f4feeb292.png','M07 presenter silhouette behind control booth glass'),
 'victims-atlas.png':('exec-655b2d45-7e45-4f2a-a2f3-c70a573c96fa.png','Three civilian portrait proposals; not approved age or identity canon'),
 'victims-atlas-anime.png':('exec-f0e6bdde-7fd5-45dd-b062-a1d1595a6791.png','Replacement anime civilian portrait atlas; candidate pending user selection'),
 'ui-button-states.png':('exec-395005a9-f7f5-49e5-822c-88a4539a7ab9.png','Six button state texture candidates; exact slicing still requires QA'),
 'wordmark.png':('exec-c9fd67ad-6191-4ec4-8e1c-74344bc5af05.png','New title wordmark candidate; prior approved logo preserved'),
}
for p in sorted(ASSETS.glob('*.png')):
    im=Image.open(p)
    origin,purpose=provenance[p.name]
    assets.append({'path':str(p.relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'size':im.size,'mode':im.mode,'alpha_range':im.getchannel('A').getextrema() if im.mode=='RGBA' else None,'status':'GENERATED_CANDIDATE','runtime_applied':False,'origin_generation_filename':origin,'generator':'host image model','created':'2026-09-11','planned_consumer':purpose,'approved':False,'rights_review':'NOT_RUN','remote_source_bytes':'LOCAL_VAULT_ONLY','state_family':'STATIC_ONLY','visual_caveat':'Pose, silhouette, alpha-edge compositing and identity consistency require final review'})
decision_path=ROOT/'docs/design/BLUEPRINT_20260911_IMAGE_DECISIONS.json'
decisions=json.loads(decision_path.read_text(encoding='utf-8'))
sources=[ROOT/'docs/design/BLUEPRINT_20260911.md',ROOT/'docs/design/blueprint-20260911-case-appendix.md',ASSETS/'case-preparation-review/PROMPTS.md',decision_path,Path(__file__)]
receipt={'pdf':str(PDF.relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256(PDF.read_bytes()).hexdigest(),'pages':len(PdfReader(PDF).pages),'baseline_main':'c82291101bf0a2bb4d821a12bca9f14070ee2886','sources':{str(p.relative_to(ROOT)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},'assets':assets,'atlas':{'image':str((ASE/'staff-atlas-clean.png').relative_to(ROOT)).replace('\\','/'),'metadata':str((ASE/'staff-atlas-clean.json').relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256((ASE/'staff-atlas-clean.png').read_bytes()).hexdigest(),'animation':False},'toc':toc,'layout_checks':checks,'runtime':'NOT_RUN','human':'NOT_RUN','final_approval':'PENDING','visual_review':'PENDING'}
receipt['superseded_asset_paths']=['.asset-vault/blueprint-20260911/lume-m04.png','.asset-vault/blueprint-20260911/lume-m04-red.png']
receipt['lume_atlas']={name:str((ROOT/'.asset-vault/aseprite-candidates/blueprint-completion-20260911'/file).relative_to(ROOT)).replace('\\','/') for name,file in [('image','lume-sheet.png'),('metadata','lume-sheet.json'),('source','lume-costumes.aseprite')]}
receipt['lume_atlas']['animation']=False
receipt['lume_atlas']['identity_alignment']='ALPHA_BOTTOM_ALIGNED_ART_IDENTITY_REVIEW_PENDING'
receipt['lume_atlas']['sha256']=hashlib.sha256((ROOT/receipt['lume_atlas']['image']).read_bytes()).hexdigest()
receipt['lume_atlas']['status']='STATIC_COSTUME_ATLAS_CANDIDATE'
receipt['lume_atlas']['placements']=[{'frame':1,'x':128,'y':16},{'frame':2,'x':13,'y':316},{'frame':3,'x':128,'y':34}]
receipt['anomaly_atlas']={name:str((ROOT/'.asset-vault/aseprite-candidates/blueprint-completion-20260911'/file).relative_to(ROOT)).replace('\\','/') for name,file in [('image','anomaly-sheet.png'),('metadata','anomaly-sheet.json'),('source','anomalies.aseprite')]}
receipt['anomaly_atlas']['sha256']=hashlib.sha256((ROOT/receipt['anomaly_atlas']['image']).read_bytes()).hexdigest()
receipt['anomaly_atlas']['animation']=False
receipt['reference_inputs']={str(p.relative_to(ROOT)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in (ASSETS/'reference-revision').glob('*.png') if not p.name.startswith('page-')}
receipt['reference_inputs']['.asset-vault/blueprint-20260911/reference-revision/PROMPTS.md']=hashlib.sha256((ASSETS/'reference-revision/PROMPTS.md').read_bytes()).hexdigest()
for asset in assets:
    if asset['path'] in receipt['superseded_asset_paths']:asset['status']='SUPERSEDED_CANDIDATE'
    matching=next((d for d in decisions['assets'] if d['path']==asset['path']),None)
    if matching:
        assert matching['sha256']==asset['sha256'], 'Approval must bind exact bytes'
        asset['status']=matching['status']
        asset['approved']=matching['status']=='USER_APPROVED_VISUAL'
        asset['approval_scope']='Visual selection only; not production canon, rights or runtime'
receipt['rejected_asset_paths']=['.asset-vault/blueprint-20260911/victims-atlas.png']
receipt['encoding_optimization']={'method':'BINARY_FLATE_NO_ASCII85','raster_downsampling':False,'lossy_reencoding':False}
(OUT/'BLUEPRINT_20260911_OPTIMIZED_RECEIPT.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
assert all(v['bottom']>=48 for v in checks), 'Content crossed footer'
print(json.dumps({'pdf':str(PDF),'pages':receipt['pages'],'sha256':receipt['sha256'],'assets':len(assets)},ensure_ascii=False))
