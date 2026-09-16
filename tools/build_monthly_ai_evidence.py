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


def merge_records(previous, added):
    records = {row["sha"]: row for row in added}
    records.update({row["sha"]: row for row in previous})
    return sorted(records.values(), key=lambda row: (row["commit_date"], row["sha"]))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True)
    parser.add_argument("--revision", default="v1.0")
    args = parser.parse_args()
    out = Path(args.output).resolve()
    now = datetime.now().astimezone()
    issued = now.isoformat(timespec="seconds")
    evidence = ROOT / "docs/evidence/2026-09"
    if not args.revision.replace(".", "").isalnum():
        raise SystemExit("Invalid revision")
    index_path = evidence / ("evidence-index-" + args.revision + ".json")
    previous = json.loads(index_path.read_text(encoding="utf-8")) if index_path.exists() else {}
    evidence.mkdir(parents=True, exist_ok=True)
    out.parent.mkdir(parents=True, exist_ok=True)
    rows = []
    revision_range = previous.get("source_head", "")
    history = [revision_range + "..HEAD"] if revision_range else ["-10"]
    for line in git("log", *history, "--format=%H|%aI|%cI|%s").splitlines():
        if not line:
            continue
        sha, author_date, commit_date, subject = line.split("|", 3)
        rows.append(dict(sha=sha, author_date=author_date, commit_date=commit_date, subject=subject))
    rows = merge_records(previous.get("commits", []), rows)
    source_paths = ["docs/CURRENT_HANDOFF.md", "docs/CURRENT_DECISION_OVERLAY.md",
                    "docs/superpowers/specs/2026-09-14-remaining-implementation-contract.md"]
    visuals = [
        ("조사 화면 - 교정 전 관측", "w03-investigation-after-cctv.png", "단서 3/3 상태. 이 캡처는 후속 UI 교정 전 화면이며 현재 최종 디자인으로 제시하지 않습니다."),
        ("매뉴얼 문장 배치 - 교정 후", "manual-wrap-1280x720.png", "실제 Godot 렌더, 1280×720. 부분 단서를 가진 자동 검증 fixture입니다. 실제 플레이 전체나 사용자 최종 승인 증거가 아닙니다."),
        ("회수 결과 - 실제 입력 기록", "w03-recovery-result.png", "회수 화면에서 실제 대응 버튼 입력 후 결과 6/6을 확인한 캡처입니다. 초안 전체를 정답으로 인증하지 않는 안내를 포함합니다."),
        ("9월 16일 - 장면과 읽기 영역 분리", "narrative-latest-1280x720.png", "실제 Godot 1280×720 자동 검증 실행 캡처. 장면 전체를 비율 유지하여 위쪽에 표시하고 선택지/지문은 아래에 배치했습니다. 선택지 스크롤, 대사/결과 순차 읽기, 문자 무손실을 검사했습니다. 사용자 최종 UX 승인이나 무중단 전체 플레이 증거는 아닙니다."),
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
    manifest["update_history"] = previous.get("update_history", []) + ([{
        "previous_issued_at": previous.get("issued_at"), "previous_pdf": previous.get("pdf"),
        "reason": "User requested cumulative updates to the same monthly document; prior records retained."
    }] if previous else [])
    manifest["daily_summaries"] = previous.get("daily_summaries", {})
    manifest["daily_summaries"].update({
        "2026-09-13": "CCTV 관측 입력과 회수 위험 시계 연결. 저장소 기록 기준 사후 요약이며 전체 월간 작업은 아님.",
        "2026-09-14": "조사-미니게임-매뉴얼 연결, 서사 UI와 시전 컷인·입력/정지 경계 보완. 크로마키 후보 생성 뒤 배경제거 출력은 실제 alpha가 없어 기각. 최종 아트 승인 및 Human QA 미완료.",
        "2026-09-16": "장면과 지문 영역 분리, 도입/후속 대사와 장문 결과의 순차 읽기 연결. 기존 월간 작업일지를 날짜별 누적 갱신하도록 수정. 검증 상세와 GitHub 동기화 상태는 CURRENT_HANDOFF 및 정확한 커밋을 참조."
    })
    pdfmetrics.registerFont(TTFont("Korean", "C:/Windows/Fonts/malgun.ttf"))
    pdfmetrics.registerFont(TTFont("KoreanBold", "C:/Windows/Fonts/malgunbd.ttf"))
    pending = out.with_suffix(".pdf.pending")
    c = canvas.Canvas(str(pending), pagesize=A4)
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
            page("작업 기록 | 계속")
        if y - h < 48:
            raise RuntimeError(f"Page {page_no} overflow: {value[:50]}")
        p.drawOn(c, 38, y - h)
        y -= h + gap

    page("AI 활용 작업일지·증빙집")
    text(TITLE, 23, True, 20)
    text("수록 범위: 기존 9월 기록 및 이후 확인된 추가 작업의 날짜별 누적\n작성 방식: 저장소 기록과 검증 결과의 사후 정리\n기록 갱신일·PDF 출력일: " + issued, 11)
    text("문서의 역할", 13, True)
    text("블루프린트는 게임 기획과 현재 모습을 설명합니다. 이 문서는 어떤 변경을 하고 어떻게 확인했는지 원본 근거와 연결하는 월별 파생 보고서입니다. 지정 정산 양식이나 영수증을 대체하지 않습니다.")
    text("증거 상한", 13, True)
    text("Git 작성자·커밋 시각은 저장소에 기록된 시각입니다. 실제 작업 시작·종료 또는 독립적인 날짜 인증을 뜻하지 않습니다. 파일 수정 시각 역시 캡처 시점의 보조 정보이며 변경 가능성이 있습니다. 이번 발행일에 과거 작업을 수행한 것으로 소급 기재하지 않았습니다.")
    text("사용 AI: Codex 및 이미지 생성 도구. 계정 식별·정확한 실행 모델·결제 자료는 미확보입니다. 9월 14일 컷인 후보 생성/배경제거 시도는 handoff에 기록되어 있으며 실제 alpha 실패로 게임에 반영하지 않았습니다. 아래 수록 이미지는 게임 실행 캡처입니다.")
    text("제출 준비 상태: 보완 필요", 13, True)
    text("원본 프롬프트 화면, 계정별 식별 정보, 결제 영수증 및 협회 지정 양식을 추가 대조해야 합니다. 사용자 제공 협약서 요약은 참고일 뿐, 이 작성자가 원문을 열람·법률 검토·서명한 사실은 없습니다.")
    page("01 | 날짜별 변경 기록")
    for day, summary in sorted(manifest["daily_summaries"].items()):
        text(day, 12, True)
        text(summary, 10)
    page("변경 근거 | 누적 커밋 목록")
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
    page("제출 전 보완·원본 찾아보기")
    text("서비스·계정별 찾아보기", 12, True)
    text("Codex: UL-0914-01~03 및 누적 변경 목록. 이미지 생성 도구: 9월 14일 컷인 후보와 배경제거 실패 검수. 상세 원본 위치와 hash는 CURRENT_HANDOFF가 연결한 자산 검수 기록을 참조합니다. 계정 식별은 미확보입니다.")
    text("미확보 자료와 확인 사항", 12, True)
    for item in ["원본 프롬프트·결과 대화 캡처: 개별 작업과 연결 필요", "계정 식별·월 구독 결제 영수증: 비공개 원본으로 보관 후 제출용 사본 연결", "비용 인정 기간·추가 크레딧 인정·AI 표시 방법: 협회 원문과 안내로 확인 필요", "지정 월간 정산 양식: 별도 제출물이며 본 PDF가 대체하지 않음", "최종 사용자 검수·배포·권리 검증: 완료로 기재하지 않음"]:
        text("• " + item, 9, gap=6)
    text("원본 기준", 12, True)
    text("저장소: https://github.com/alsdmlals4-eng/urban-legend\n기준 HEAD: " + manifest["source_head"] + "\n브랜치: " + manifest["branch"] + "\nmain 통합 여부는 별도 검증 대상입니다.", 8)
    for source in sources[:3]:
        text(source["path"] + "\nSHA-256: " + source["sha256"], 8, gap=7)
    text("기계 판독 목록: docs/evidence/2026-09/" + index_path.name + "\n같은 월간 PDF와 index를 갱신하며 기존 기록은 유지합니다. 이전 출력 hash와 갱신 사유는 index의 update_history에 남깁니다. 해시는 외부 날짜 인증이 아닙니다.", 8)
    c.save()
    reader = PdfReader(pending)
    assert len(reader.pages) >= 7
    assert all(len(p.extract_text()) > 100 for p in reader.pages)
    pending.replace(out)
    manifest["pdf"] = dict(path=str(out), sha256=digest(out), pages=len(reader.pages))
    index_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(manifest["pdf"], ensure_ascii=False))


if __name__ == "__main__":
    main()
