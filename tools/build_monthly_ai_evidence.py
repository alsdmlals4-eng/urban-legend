"""Repository-derived monthly evidence packet; never an invoice or date attestation."""
import argparse
import hashlib
import json
import subprocess
from datetime import datetime
from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.utils import ImageReader
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
TITLE = "괴이기록국: 잔향 보고서"


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True, encoding="utf-8").strip()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True)
    parser.add_argument("--revision", default="v1.0")
    args = parser.parse_args()
    out = Path(args.output).resolve()
    if out.exists():
        raise SystemExit("Refusing to overwrite an issued evidence PDF; use a new revision.")
    now = datetime.now().astimezone()
    issued = now.isoformat(timespec="seconds")
    evidence = ROOT / "docs/evidence/2026-09"
    if not args.revision.replace(".", "").isalnum():
        raise SystemExit("Invalid revision")
    index_path = evidence / ("evidence-index-" + args.revision + ".json")
    if index_path.exists():
        raise SystemExit("Refusing to overwrite an issued evidence index; use a new revision.")
    evidence.mkdir(parents=True, exist_ok=True)
    out.parent.mkdir(parents=True, exist_ok=True)
    rows = []
    for line in git("log", "-10", "--format=%H|%aI|%cI|%s").splitlines():
        sha, author_date, commit_date, subject = line.split("|", 3)
        rows.append(dict(sha=sha, author_date=author_date, commit_date=commit_date, subject=subject))
    rows.reverse()
    source_paths = ["docs/CURRENT_HANDOFF.md", "docs/CURRENT_DECISION_OVERLAY.md",
                    "docs/superpowers/specs/2026-09-14-remaining-implementation-contract.md"]
    visuals = [
        ("조사 화면 - 교정 전 관측", "w03-investigation-after-cctv.png", "단서 3/3 상태. 이 캡처는 후속 UI 교정 전 화면이며 현재 최종 디자인으로 제시하지 않습니다."),
        ("매뉴얼 문장 배치 - 교정 후", "manual-wrap-1280x720.png", "실제 Godot 렌더, 1280×720. 부분 단서를 가진 자동 검증 fixture입니다. 실제 플레이 전체나 사용자 최종 승인 증거가 아닙니다."),
        ("회수 결과 - 실제 입력 기록", "w03-recovery-result.png", "회수 화면에서 실제 대응 버튼 입력 후 결과 6/6을 확인한 캡처입니다. 초안 전체를 정답으로 인증하지 않는 안내를 포함합니다."),
    ]
    sources = []
    for rel in source_paths + [".artifacts/daily-case-20260912/" + item[1] for item in visuals]:
        p = ROOT / rel
        sources.append(dict(path=rel, sha256=digest(p), filesystem_modified=datetime.fromtimestamp(p.stat().st_mtime).astimezone().isoformat()))
    manifest = dict(project=TITLE, month="2026-09", scope="Selected verified records; not exhaustive monthly history",
                    issued_at=issued, source_head=git("rev-parse", "HEAD"), branch=git("branch", "--show-current"),
                    retrospective=True, commits=rows, sources=sources,
                    missing=["Original prompt screenshots", "Account identification", "Payment receipts", "Association template and original agreement review"],
                    input_excerpt="작업재개,그리고 앞으로 이미지 생성시 크로마키 배경으로 만든 후 배경제거해.",
                    input_evidence_type="User message excerpt transcribed from current conversation; not a screenshot or timestamp attestation")
    pdfmetrics.registerFont(TTFont("Korean", "C:/Windows/Fonts/malgun.ttf"))
    pdfmetrics.registerFont(TTFont("KoreanBold", "C:/Windows/Fonts/malgunbd.ttf"))
    c = canvas.Canvas(str(out), pagesize=A4)
    c.setTitle(TITLE + " | AI 활용 작업일지·증빙집 | 2026-09 " + args.revision)
    c.setAuthor("프로젝트 작업 기록 기반 / Codex 작성")
    width, height = A4
    page_no = 0
    y = 0

    def page(title):
        nonlocal page_no, y
        if page_no:
            c.showPage()
        page_no += 1
        c.setFillColorRGB(.07, .13, .18)
        c.rect(0, height - 86, width, 86, fill=1, stroke=0)
        c.setFillColorRGB(1, 1, 1)
        c.setFont("KoreanBold", 17)
        c.drawString(38, height - 43, title)
        c.setFont("Korean", 8)
        c.drawString(38, height - 64, TITLE + "  /  2026년 9월  /  " + args.revision + " 사후 정리본")
        c.setFillColorRGB(.25, .3, .34)
        c.setFont("Korean", 8)
        c.drawString(38, 24, "AI 활용 작업일지·증빙집 | 제출 전 보완 필요 | 날짜 인증 문서 아님")
        c.drawRightString(width - 38, 24, str(page_no))
        y = height - 110

    def text(value, size=10, bold=False, gap=10):
        nonlocal y
        style = ParagraphStyle("body", fontName="KoreanBold" if bold else "Korean", fontSize=size,
                               leading=size * 1.6, wordWrap="CJK", textColor="#263746")
        p = Paragraph(escape(value).replace("\n", "<br/>"), style)
        _, h = p.wrap(width - 76, height)
        if y - h < 48:
            raise RuntimeError(f"Page {page_no} overflow: {value[:50]}")
        p.drawOn(c, 38, y - h)
        y -= h + gap

    page("AI 활용 작업일지·증빙집")
    text(TITLE, 23, True, 20)
    text("수록 범위: 확인 가능한 2026년 9월 13~14일 일부 작업\n작성 방식: 저장소 기록과 현재 검증 결과의 사후 정리\n기록 작성일·PDF 발행일: " + issued, 11)
    text("문서의 역할", 13, True)
    text("블루프린트는 게임 기획과 현재 모습을 설명합니다. 이 문서는 어떤 변경을 하고 어떻게 확인했는지 원본 근거와 연결하는 월별 파생 보고서입니다. 지정 정산 양식이나 영수증을 대체하지 않습니다.")
    text("증거 상한", 13, True)
    text("Git 작성자·커밋 시각은 저장소에 기록된 시각입니다. 실제 작업 시작·종료 또는 독립적인 날짜 인증을 뜻하지 않습니다. 파일 수정 시각 역시 캡처 시점의 보조 정보이며 변경 가능성이 있습니다. 이번 발행일에 과거 작업을 수행한 것으로 소급 기재하지 않았습니다.")
    text("사용 AI: Codex. 계정 식별·정확한 실행 모델·결제 자료는 미확보입니다. 이미지 생성은 이번 증빙 구간에서 새로 수행하지 않았으며, 수록 이미지는 게임 실행 캡처입니다.")
    text("제출 준비 상태: 보완 필요", 13, True)
    text("원본 프롬프트 화면, 계정별 식별 정보, 결제 영수증 및 협회 지정 양식을 추가 대조해야 합니다. 사용자 제공 협약서 요약은 참고일 뿐, 이 작성자가 원문을 열람·법률 검토·서명한 사실은 없습니다.")
    page("01 | 날짜별 변경 기록")
    text("정렬 기준은 저장소 커밋 기록입니다. 각 SHA로 실제 변경 파일을 재확인할 수 있습니다. 아래 목록은 선택된 최신 기록이며 9월 전체 작업을 망라하지 않습니다.", 9)
    for row in rows:
        text(row["commit_date"] + "  |  " + row["sha"][:12], 9, True, 2)
        text(row["subject"], 9, gap=9)
    text("세부 원본: 저장소 Git 이력 및 docs/CURRENT_HANDOFF.md. 과거 작업의 정확한 AI 입력 시각은 원본 프롬프트 증빙 확보 전 미확인입니다.", 9)
    page("02 | 수행 내용·반영·검수")
    entries = [
        ("UL-0914-01 / 조사와 회수 연결", "메인 준비 진입 함수 부재, 기록 버튼 무반응, 숨겨진 회수 진입과 조사 목록 미갱신을 수정했습니다. 기존 장면·조건·확인창을 재사용했습니다. 실제 클릭으로 조사 단서 획득, CCTV 실패 복귀, 초안 작성, 회수 성공, 준비실 귀환을 확인했습니다. 재시작을 포함한 누적 경로이며 단일 무중단 플레이는 아닙니다."),
        ("UL-0914-02 / 매뉴얼 표시", "사건 모델 갱신 후 기본 CASE-01 표제가 남는 문제와 본문 글자 기둥·빈칸 세로 확장을 교정했습니다. 720p/1080p 프레임을 렌더해 직접 확인했습니다. 부분 단서 fixture이며 최종 아트·모든 페이지 승인은 아닙니다."),
        ("UL-0914-03 / 오디오 종료 검증", "검사가 오디오 객체 해제보다 먼저 끝나는 사례를 관측했습니다. 음소거 없이 실제 해제를 기다리며 제한시간 내 남으면 실패시키는 검사를 적용했습니다. 7개 검사 2회, Vulkan 회수 fixture, Python490 및 GUT28 통과 기록이 handoff에 있습니다. 엔진 전체 누수나 청감 검수 완료가 아닙니다."),
    ]
    for title, body in entries:
        text(title, 12, True)
        text(body)
    text("입력 증빙의 현재 상태", 12, True)
    text("이번 요청 원문 일부(대화에서 전사): “" + manifest["input_excerpt"] + "”\n원본 화면 캡처가 아닙니다. 이전 개별 변경의 원본 프롬프트 화면은 미확보이며, 작업 설명을 프롬프트 원문처럼 재구성하지 않았습니다.", 9)
    for i, (title, filename, caption) in enumerate(visuals, 3):
        page(f"0{i} | {title}")
        text(caption, 11)
        path = ROOT / ".artifacts/daily-case-20260912" / filename
        im = ImageReader(str(path))
        iw, ih = im.getSize()
        dw = width - 76
        dh = dw * ih / iw
        c.drawImage(im, 38, y - dh, width=dw, height=dh, preserveAspectRatio=True)
        y -= dh + 20
        source = next(s for s in sources if s["path"].endswith(filename))
        text("캡처 파일 수정 시각: " + source["filesystem_modified"] + "\n독립적으로 인증된 캡처 시각 아님. 문서 발행 시 원본 파일의 SHA-256을 계산했습니다.", 9)
        text("원본: " + source["path"], 8)
        text("SHA-256: " + source["sha256"], 8)
    page("06 | 제출 전 보완·원본 찾아보기")
    text("서비스·계정별 찾아보기", 12, True)
    text("Codex: UL-0914-01~03 및 변경 목록 전체. 계정 식별은 미확보입니다. ChatGPT 이미지 생성 등 다른 서비스의 실제 사용을 이번 기록만으로 확정하지 않습니다.")
    text("미확보 자료와 확인 사항", 12, True)
    for item in ["원본 프롬프트·결과 대화 캡처: 개별 작업과 연결 필요", "계정 식별·월 구독 결제 영수증: 비공개 원본으로 보관 후 제출용 사본 연결", "비용 인정 기간·추가 크레딧 인정·AI 표시 방법: 협회 원문과 안내로 확인 필요", "지정 월간 정산 양식: 별도 제출물이며 본 PDF가 대체하지 않음", "최종 사용자 검수·배포·권리 검증: 완료로 기재하지 않음"]:
        text("• " + item, 9, gap=6)
    text("원본 기준", 12, True)
    text("저장소: https://github.com/alsdmlals4-eng/urban-legend\n기준 HEAD: " + manifest["source_head"] + "\n브랜치: " + manifest["branch"] + "\nmain 통합 여부는 별도 검증 대상입니다.", 8)
    for source in sources[:3]:
        text(source["path"] + "\nSHA-256: " + source["sha256"], 8, gap=7)
    text("기계 판독 목록: docs/evidence/2026-09/" + index_path.name + "\n해시는 내용 동일성 확인용이며 작성 시점의 외부 인증은 아닙니다. 정정 시 새 버전과 사유를 남기고 기존 발행본을 덮어쓰지 않습니다.", 8)
    c.save()
    reader = PdfReader(out)
    assert len(reader.pages) == 7
    assert all(len(p.extract_text()) > 100 for p in reader.pages)
    manifest["pdf"] = dict(path=str(out), sha256=digest(out), pages=len(reader.pages))
    index_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(manifest["pdf"], ensure_ascii=False))


if __name__ == "__main__":
    main()
