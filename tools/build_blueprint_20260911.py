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
PDF = OUT / 'URBAN_LEGEND_HUMAN_BLUEPRINT_20260911_REVIEW.pdf'
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

def screen(kind,x,yy,w,h):
    """Text-native wireframe placed over candidate art; never a claimed screenshot."""
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
        txt('괴이기록국',28,362,42,HexColor('#f2ead8'),'KRB')
        txt('잔향 보고서',32,325,24,HexColor('#dcc28b'))
        for yy,hh,title,body in [(362,94,'본편 시작','새로운 사건을 조사합니다'),(280,70,'이어 하기','이전 기록에서 계속합니다'),(181,76,'Validation','검증되지 않은 기록'),(112,53,'기록 보관실',''),(51,53,'설정 · 종료','')]:box(355,yy,300,hh,title,body)
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
        kinds=['main','daily','preparation','investigation','manual','rescue','recovery','minigame','result']
        names=['01 메인','02 일상','03 준비','04 조사','05 매뉴얼','06 구출','07 회수','08 미니게임','09 결과']
        for i,(k,label) in enumerate(zip(kinds,names)):
            xx=40+(i%3)*338;yy=86+(2-i//3)*175
            screen(k,xx,yy,280,157.5);txt(label,xx,yy-14,10)
        txt('신규 자산 + 편집 가능한 화면 설계 / 실제 Godot 실행 캡처 아님',40,61,9)
        y=55
    elif line.startswith('@screen'):
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
        for i,name in enumerate(['lume.png','lume-m04.png','lume-m07.png']):
            img(ASSETS/name,40+i*335,y-262,310,262)
            txt(['저승역','빨간 우산 골목','폐주파수 방송국'][i],145+i*335,y-278,11)
        y-=302
    elif line.startswith('@image'):
        name=line.split()[1];room(278)
        img(ASSETS/name,40,y-264,1000,264);y-=282

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
newpage('찾아보기 · 실제 페이지 위치')
for i,item in enumerate(list(toc[:-1])):
    column=i//22;row=i%22
    p=Paragraph(clean(f"{item['page']:02d}  {item['title']}"),SMALL)
    _,hh=p.wrap(475,28);p.drawOn(c,40+column*505,H-136-row*23-hh)
c.save()
assets=[]
provenance = {
 'bureau.png':('exec-4d5512b2-7508-4a2a-a34e-d110abd488fb.png','Main menu and daily archive background'),
 'station.png':('exec-fee500f8-6ca5-4663-80b0-9a3fc8aaa0ed.png','M01 investigation / rescue / recovery background'),
 'alley.png':('exec-b13a636b-3726-46b2-8f0c-3e5029105af8.png','M04 investigation / recovery background'),
 'broadcast.png':('exec-9d72824a-facc-428b-a1f9-e0cecf327070.png','M07 investigation / recovery background'),
 'narae.png':('exec-e82f7e4c-78e0-4899-b95f-12c0d6b5b04a.png','Staff portrait / selected action pose candidate'),
 'oh-hyeon.png':('exec-5e266e50-a19c-4728-9847-eb554adbb4cb.png','Staff portrait / selected action pose candidate'),
 'kang-ijun.png':('exec-712d45a1-9cad-486b-ac6e-5fc91de34b83.png','Staff portrait / selected action pose candidate'),
 'lume.png':('exec-6089fe90-214d-48f3-b3f3-969dbfcfa79c.png','M01 manual guide costume candidate'),
 'lume-m04.png':('exec-6a8cb2b2-c34d-4065-bc84-e75129bbf97c.png','M04 manual guide costume candidate'),
 'lume-m07.png':('exec-56716a39-368a-473a-9bc8-f378870cd94c.png','M07 manual guide costume candidate'),
 'ui-panel.png':('exec-4c71a602-0700-4d25-903b-26c66b846824.png','Record / menu group panel; Aseprite crop y140 h744'),
}
for p in sorted(ASSETS.glob('*.png')):
    im=Image.open(p)
    origin,purpose=provenance[p.name]
    assets.append({'path':str(p.relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'size':im.size,'mode':im.mode,'alpha_range':im.getchannel('A').getextrema() if im.mode=='RGBA' else None,'status':'GENERATED_CANDIDATE','runtime_applied':False,'origin_generation_filename':origin,'generator':'host image model','created':'2026-09-11','planned_consumer':purpose,'approved':False,'rights_review':'NOT_RUN','remote_source_bytes':'LOCAL_VAULT_ONLY','state_family':'STATIC_ONLY','visual_caveat':'Pose, silhouette, alpha-edge compositing and identity consistency require final review'})
sources=[ROOT/'docs/design/BLUEPRINT_20260911.md',ROOT/'docs/design/blueprint-20260911-case-appendix.md',Path(__file__)]
receipt={'pdf':str(PDF.relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256(PDF.read_bytes()).hexdigest(),'pages':len(PdfReader(PDF).pages),'baseline_main':'c82291101bf0a2bb4d821a12bca9f14070ee2886','sources':{str(p.relative_to(ROOT)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},'assets':assets,'atlas':{'image':str((ASE/'staff-atlas-clean.png').relative_to(ROOT)).replace('\\','/'),'metadata':str((ASE/'staff-atlas-clean.json').relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256((ASE/'staff-atlas-clean.png').read_bytes()).hexdigest(),'animation':False},'toc':toc,'layout_checks':checks,'runtime':'NOT_RUN','human':'NOT_RUN','final_approval':'PENDING','visual_review':'PENDING'}
(OUT/'BLUEPRINT_20260911_RECEIPT.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2),encoding='utf-8')
assert all(v['bottom']>=48 for v in checks), 'Content crossed footer'
print(json.dumps({'pdf':str(PDF),'pages':receipt['pages'],'sha256':receipt['sha256'],'assets':len(assets)},ensure_ascii=False))
