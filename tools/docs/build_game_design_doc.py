#!/usr/bin/env python3
"""Build and verify the decorated DOCX mirror of the living game design document."""

from __future__ import annotations

import argparse
import hashlib
import io
import re
import sys
from pathlib import Path

from PIL import Image
from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "docs" / "GAME_DESIGN_DOCUMENT.md"
OUTPUT = ROOT / "docs" / "URBAN_LEGEND_GAME_DESIGN.docx"
DEFAULT_REFERENCE = Path.home() / "Downloads" / "룰렛바운드_게임기획서_v0.7.docx"
FORMAT_VERSION = "urban-legend-gdd-docx-v1"
HASH_PREFIX = "gdd-source-sha256="

FONT_BODY = "NanumSquare"
FONT_MONO = "Noto Sans Mono CJK KR"
NAVY = "1F2A44"
BLUE = "2E75B6"
TEAL = "2F6F6D"
GOLD = "C89423"
TEXT = "222222"
MUTED = "666666"
LIGHT = "F7F8FA"
PALE_BLUE = "DCE6F1"


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser(description=__doc__)
	mode = parser.add_mutually_exclusive_group(required=True)
	mode.add_argument("--build", action="store_true", help="Build the DOCX mirror")
	mode.add_argument("--check", action="store_true", help="Check whether the DOCX mirror is current")
	parser.add_argument("--template", type=Path, help="Reference DOCX for the first build")
	return parser.parse_args()


def extract_image_paths(markdown: str) -> list[Path]:
	paths: list[Path] = []
	for raw in re.findall(r"!\[[^\]]*\]\(([^)]+)\)", markdown):
		path = (SOURCE.parent / raw).resolve()
		if path not in paths:
			paths.append(path)
	return paths


def source_hash(markdown: str) -> str:
	digest = hashlib.sha256()
	digest.update(FORMAT_VERSION.encode("utf-8"))
	digest.update(markdown.encode("utf-8"))
	for path in extract_image_paths(markdown):
		digest.update(path.relative_to(ROOT).as_posix().encode("utf-8"))
		digest.update(path.read_bytes())
	return digest.hexdigest()


def document_version(markdown: str) -> str:
	match = re.search(r"^\|\s*문서 버전\s*\|\s*([^|]+?)\s*\|", markdown, re.MULTILINE)
	return match.group(1).strip() if match else "v0.1"


def clean_inline(text: str) -> str:
	text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
	text = text.replace("**", "").replace("__", "").replace("`", "")
	if text.startswith("*") and text.endswith("*"):
		text = text[1:-1]
	return text.strip()


def remove_body_content(doc: Document) -> None:
	body = doc._element.body
	for child in list(body):
		if child.tag != qn("w:sectPr"):
			body.remove(child)


def set_run_font(run, name: str = FONT_BODY, size: float | None = None, color: str | None = None, bold: bool | None = None) -> None:
	run.font.name = name
	run._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), name)
	if size is not None:
		run.font.size = Pt(size)
	if color:
		run.font.color.rgb = RGBColor.from_string(color)
	if bold is not None:
		run.bold = bold


def configure_document(doc: Document, build_hash: str, version: str) -> None:
	section = doc.sections[0]
	section.page_width = Inches(8.5)
	section.page_height = Inches(11)
	section.left_margin = Inches(0.70)
	section.right_margin = Inches(0.70)
	section.top_margin = Inches(0.65)
	section.bottom_margin = Inches(0.65)
	section.header_distance = Inches(0.25)
	section.footer_distance = Inches(0.25)

	styles = doc.styles
	for name, size, color, bold, before, after in (
		("Normal", 9.0, TEXT, False, 0, 5),
		("Heading 1", 17.0, NAVY, True, 16, 7),
		("Heading 2", 12.5, BLUE, True, 11, 5),
		("Heading 3", 10.5, TEAL, True, 8, 4),
		("List Bullet", 9.0, TEXT, False, 0, 3),
		("List Number", 9.0, TEXT, False, 0, 3),
	):
		style = styles[name]
		style.font.name = FONT_BODY
		style._element.get_or_add_rPr().get_or_add_rFonts().set(qn("w:eastAsia"), FONT_BODY)
		style.font.size = Pt(size)
		style.font.color.rgb = RGBColor.from_string(color)
		style.font.bold = bold
		style.paragraph_format.space_before = Pt(before)
		style.paragraph_format.space_after = Pt(after)
		style.paragraph_format.line_spacing = 1.12
		if name.startswith("Heading"):
			style.paragraph_format.keep_with_next = True

	doc.core_properties.title = "괴담기록국 게임기획서"
	doc.core_properties.subject = "MVP-040 기준 살아 있는 게임 설계"
	doc.core_properties.author = "괴담기록국 프로젝트"
	doc.core_properties.keywords = f"{HASH_PREFIX}{build_hash}"
	doc.core_properties.comments = "편집 원본: docs/GAME_DESIGN_DOCUMENT.md"

	header = section.header
	header.is_linked_to_previous = False
	hp = header.paragraphs[0]
	hp.clear()
	hp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
	hr = hp.add_run("괴담기록국  ·  GAME DESIGN DOCUMENT  ·  %s" % version)
	set_run_font(hr, size=7.5, color=MUTED, bold=True)

	footer = section.footer
	footer.is_linked_to_previous = False
	fp = footer.paragraphs[0]
	fp.clear()
	fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
	fr = fp.add_run("MVP-040  |  Ver 4.0  |  ")
	set_run_font(fr, size=7.5, color=MUTED)
	field = OxmlElement("w:fldSimple")
	field.set(qn("w:instr"), "PAGE")
	fp._p.append(field)


def shade_cell(cell, fill: str) -> None:
	tc_pr = cell._tc.get_or_add_tcPr()
	shd = tc_pr.find(qn("w:shd"))
	if shd is None:
		shd = OxmlElement("w:shd")
		tc_pr.append(shd)
	shd.set(qn("w:fill"), fill)


def set_cell_margins(cell, top: int = 90, start: int = 120, bottom: int = 90, end: int = 120) -> None:
	tc = cell._tc
	tc_pr = tc.get_or_add_tcPr()
	tc_mar = tc_pr.first_child_found_in("w:tcMar")
	if tc_mar is None:
		tc_mar = OxmlElement("w:tcMar")
		tc_pr.append(tc_mar)
	for key, value in (("top", top), ("start", start), ("bottom", bottom), ("end", end)):
		node = tc_mar.find(qn(f"w:{key}"))
		if node is None:
			node = OxmlElement(f"w:{key}")
			tc_mar.append(node)
		node.set(qn("w:w"), str(value))
		node.set(qn("w:type"), "dxa")


def set_table_geometry(table, rows: list[list[str]], usable_dxa: int = 10080) -> None:
	cols = len(rows[0])
	weights: list[int] = []
	for index in range(cols):
		longest = max(len(row[index]) if index < len(row) else 0 for row in rows)
		weights.append(max(8, min(42, longest)))
	total_weight = sum(weights)
	widths = [max(900, int(usable_dxa * weight / total_weight)) for weight in weights]
	widths[-1] += usable_dxa - sum(widths)
	table.autofit = False
	tbl_pr = table._tbl.tblPr
	for tag in ("w:tblW", "w:tblInd"):
		node = tbl_pr.find(qn(tag))
		if node is None:
			node = OxmlElement(tag)
			tbl_pr.append(node)
		node.set(qn("w:type"), "dxa")
		node.set(qn("w:w"), str(usable_dxa if tag == "w:tblW" else 120))
	grid = table._tbl.tblGrid
	for child in list(grid):
		grid.remove(child)
	for width in widths:
		col = OxmlElement("w:gridCol")
		col.set(qn("w:w"), str(width))
		grid.append(col)
	for row in table.rows:
		for index, cell in enumerate(row.cells):
			tc_pr = cell._tc.get_or_add_tcPr()
			tc_w = tc_pr.find(qn("w:tcW"))
			if tc_w is None:
				tc_w = OxmlElement("w:tcW")
				tc_pr.append(tc_w)
			tc_w.set(qn("w:type"), "dxa")
			tc_w.set(qn("w:w"), str(widths[index]))
			set_cell_margins(cell)


def add_table(doc: Document, rows: list[list[str]]) -> None:
	if not rows:
		return
	column_count = max(len(row) for row in rows)
	rows = [row + [""] * (column_count - len(row)) for row in rows]
	table = doc.add_table(rows=len(rows), cols=column_count)
	set_table_geometry(table, rows)
	for row_index, values in enumerate(rows):
		for col_index, value in enumerate(values):
			cell = table.cell(row_index, col_index)
			cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
			shade_cell(cell, NAVY if row_index == 0 else (LIGHT if row_index % 2 else "FFFFFF"))
			paragraph = cell.paragraphs[0]
			paragraph.paragraph_format.space_after = Pt(0)
			paragraph.paragraph_format.line_spacing = 1.05
			run = paragraph.add_run(clean_inline(value))
			set_run_font(run, size=8.0, color="FFFFFF" if row_index == 0 else TEXT, bold=row_index == 0)
		if row_index == 0:
			tr_pr = table.rows[0]._tr.get_or_add_trPr()
			repeat = OxmlElement("w:tblHeader")
			repeat.set(qn("w:val"), "true")
			tr_pr.append(repeat)
	doc.add_paragraph().paragraph_format.space_after = Pt(1)


def add_callout(doc: Document, text: str) -> None:
	table = doc.add_table(rows=1, cols=1)
	set_table_geometry(table, [[text]])
	tr_pr = table.rows[0]._tr.get_or_add_trPr()
	repeat = OxmlElement("w:tblHeader")
	repeat.set(qn("w:val"), "true")
	tr_pr.append(repeat)
	cell = table.cell(0, 0)
	shade_cell(cell, PALE_BLUE)
	paragraph = cell.paragraphs[0]
	paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
	run = paragraph.add_run(clean_inline(text))
	set_run_font(run, size=9.5, color=NAVY, bold=True)
	doc.add_paragraph().paragraph_format.space_after = Pt(1)


def add_picture(doc: Document, path: Path, alt: str, width: float = 7.0) -> None:
	paragraph = doc.add_paragraph()
	paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
	run = paragraph.add_run()
	shape = run.add_picture(str(path), width=Inches(width))
	doc_pr = shape._inline.docPr
	doc_pr.set("title", alt)
	doc_pr.set("descr", alt)
	paragraph.paragraph_format.space_after = Pt(4)


def agent_composite(paths: list[Path]) -> io.BytesIO:
	panels: list[Image.Image] = []
	for path in paths:
		image = Image.open(path).convert("RGB")
		panel = image.crop((0, 0, image.width // 3, image.height))
		panels.append(panel)
	height = 900
	resized = [panel.resize((int(panel.width * height / panel.height), height), Image.Resampling.LANCZOS) for panel in panels]
	canvas = Image.new("RGB", (sum(panel.width for panel in resized), height), (31, 42, 68))
	x = 0
	for panel in resized:
		canvas.paste(panel, (x, 0))
		x += panel.width
	buffer = io.BytesIO()
	canvas.save(buffer, format="PNG", optimize=True)
	buffer.seek(0)
	return buffer


def add_agent_composite(doc: Document, paths: list[Path]) -> None:
	paragraph = doc.add_paragraph()
	paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
	shape = paragraph.add_run().add_picture(agent_composite(paths), width=Inches(7.0))
	shape._inline.docPr.set("title", "괴담기록국 요원 3명")
	shape._inline.docPr.set("descr", "강이준, 권나래, 오현의 현재 프로젝트 표현 시트에서 만든 요원 구성 이미지")
	paragraph.paragraph_format.space_after = Pt(4)


def add_code_block(doc: Document, lines: list[str]) -> None:
	table = doc.add_table(rows=1, cols=1)
	set_table_geometry(table, [["\n".join(lines)]])
	tr_pr = table.rows[0]._tr.get_or_add_trPr()
	repeat = OxmlElement("w:tblHeader")
	repeat.set(qn("w:val"), "true")
	tr_pr.append(repeat)
	cell = table.cell(0, 0)
	shade_cell(cell, LIGHT)
	paragraph = cell.paragraphs[0]
	paragraph.paragraph_format.line_spacing = 1.0
	run = paragraph.add_run("\n".join(lines))
	set_run_font(run, name=FONT_MONO, size=7.8, color=TEXT)
	doc.add_paragraph().paragraph_format.space_after = Pt(1)


def render_markdown(doc: Document, markdown: str) -> None:
	lines = markdown.splitlines()
	i = 0
	while i < len(lines):
		line = lines[i].rstrip()
		if not line:
			i += 1
			continue
		if line.startswith("```"):
			block: list[str] = []
			i += 1
			while i < len(lines) and not lines[i].startswith("```"):
				block.append(lines[i])
				i += 1
			add_code_block(doc, block)
			i += 1
			continue
		if line.startswith("|") and i + 1 < len(lines) and re.match(r"^\|?\s*:?-+", lines[i + 1].strip(" |")):
			rows: list[list[str]] = []
			while i < len(lines) and lines[i].strip().startswith("|"):
				parts = [part.strip() for part in lines[i].strip().strip("|").split("|")]
				if not all(re.fullmatch(r":?-+:?", part.replace(" ", "")) for part in parts):
					rows.append(parts)
				i += 1
			add_table(doc, rows)
			continue
		image_match = re.fullmatch(r"!\[([^\]]*)\]\(([^)]+)\)", line)
		if image_match:
			agent_paths: list[Path] = []
			j = i
			while j < len(lines) and len(agent_paths) < 3:
				candidate = lines[j].strip()
				if not candidate:
					j += 1
					continue
				match = re.fullmatch(r"!\[([^\]]*)\]\(([^)]+)\)", candidate)
				if not match or "assets/agents/" not in match.group(2).replace("\\", "/"):
					break
				agent_paths.append((SOURCE.parent / match.group(2)).resolve())
				j += 1
			if len(agent_paths) == 3:
				add_agent_composite(doc, agent_paths)
				i = j
				continue
			add_picture(doc, (SOURCE.parent / image_match.group(2)).resolve(), image_match.group(1))
			i += 1
			continue
		if line.startswith("# "):
			paragraph = doc.add_paragraph()
			paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
			paragraph.paragraph_format.space_before = Pt(10)
			paragraph.paragraph_format.space_after = Pt(4)
			run = paragraph.add_run(clean_inline(line[2:]))
			set_run_font(run, size=30, color=NAVY, bold=True)
			i += 1
			continue
		if line.startswith("## "):
			doc.add_paragraph(clean_inline(line[3:]), style="Heading 1")
			i += 1
			continue
		if line.startswith("### "):
			doc.add_paragraph(clean_inline(line[4:]), style="Heading 2")
			i += 1
			continue
		if line.startswith("> "):
			parts = [line[2:]]
			i += 1
			while i < len(lines) and lines[i].startswith("> "):
				parts.append(lines[i][2:])
				i += 1
			add_callout(doc, "\n".join(parts))
			continue
		if re.match(r"^- ", line):
			doc.add_paragraph(clean_inline(line[2:]), style="List Bullet")
			i += 1
			continue
		if re.match(r"^\d+\. ", line):
			doc.add_paragraph(clean_inline(re.sub(r"^\d+\.\s+", "", line)), style="List Number")
			i += 1
			continue
		paragraph_lines = [line]
		i += 1
		while i < len(lines) and lines[i].strip() and not re.match(r"^(#|>|- |\d+\. |```|\||!\[)", lines[i].strip()):
			paragraph_lines.append(lines[i].strip())
			i += 1
		paragraph = doc.add_paragraph()
		if line.startswith("*") and line.endswith("*"):
			paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
		run = paragraph.add_run(clean_inline(" ".join(paragraph_lines)))
		set_run_font(run, size=8.5 if paragraph.alignment == WD_ALIGN_PARAGRAPH.CENTER else 9.0, color=MUTED if paragraph.alignment == WD_ALIGN_PARAGRAPH.CENTER else TEXT)


def build(template: Path | None) -> None:
	markdown = SOURCE.read_text(encoding="utf-8")
	for path in extract_image_paths(markdown):
		if not path.is_file():
			raise FileNotFoundError(f"Missing referenced image: {path}")
	build_hash = source_hash(markdown)
	base = template
	if base is None and OUTPUT.exists():
		base = OUTPUT
	if base is None and DEFAULT_REFERENCE.exists():
		base = DEFAULT_REFERENCE
	if base is not None:
		doc = Document(str(base.resolve()))
		remove_body_content(doc)
	else:
		doc = Document()
	configure_document(doc, build_hash, document_version(markdown))
	render_markdown(doc, markdown)
	OUTPUT.parent.mkdir(parents=True, exist_ok=True)
	doc.save(OUTPUT)
	print(f"BUILT {OUTPUT}")
	print(f"SOURCE_HASH {build_hash}")


def check() -> None:
	if not OUTPUT.is_file():
		raise FileNotFoundError(f"Missing generated DOCX: {OUTPUT}")
	markdown = SOURCE.read_text(encoding="utf-8")
	expected = source_hash(markdown)
	doc = Document(str(OUTPUT))
	actual = (doc.core_properties.keywords or "").removeprefix(HASH_PREFIX)
	if actual != expected:
		raise RuntimeError(f"DOCX is stale: expected {expected}, found {actual or '<missing>'}")
	if len(doc.paragraphs) < 80 or len(doc.tables) < 15 or len(doc.inline_shapes) < 4:
		raise RuntimeError("DOCX structural sanity check failed")
	print(f"CURRENT {OUTPUT}")
	print(f"SOURCE_HASH {expected}")
	print(f"STRUCTURE paragraphs={len(doc.paragraphs)} tables={len(doc.tables)} images={len(doc.inline_shapes)}")


def main() -> int:
	args = parse_args()
	try:
		if args.build:
			build(args.template)
		else:
			check()
	except Exception as exc:
		print(f"ERROR: {exc}", file=sys.stderr)
		return 1
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
