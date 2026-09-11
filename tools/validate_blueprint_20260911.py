"""Bounded document/asset checks. Never reports runtime or human acceptance."""
from pathlib import Path
import hashlib
import json
import re
from PIL import Image
from pypdf import PdfReader

root=Path(__file__).resolve().parents[1]
receipt=json.loads((root/'output/pdf/BLUEPRINT_20260911_CASE_PREPARATION_RECEIPT.json').read_text(encoding='utf-8'))
pdf=root/receipt['pdf']
assert hashlib.sha256(pdf.read_bytes()).hexdigest()==receipt['sha256']
reader=PdfReader(pdf)
assert len(reader.pages)==receipt['pages']
text='\n'.join(p.extract_text() or '' for p in reader.pages)
for term in ['화면 아틀라스','SWOT','TOWS','이중 시계','정지·재개','미니게임','직원 정적 아틀라스','루메','데이터 책임','구현 순서','인수 시험','준비 상태','M01','M04','M07','gear_resonance_prism','USER_FINAL_APPROVAL_PENDING']:
    # Intro status is in editable appendix even when omitted from PDF layout.
    searchable=text+(root/'docs/design/blueprint-20260911-case-appendix.md').read_text(encoding='utf-8')
    assert term in searchable,term
assert '-16' in text and '-14' in text, 'Negative effect signs must survive rendering'
for path,digest in receipt['sources'].items():
    assert hashlib.sha256((root/path).read_bytes()).hexdigest()==digest,path
assert len(receipt['assets'])==20
appendix=(root/'docs/design/blueprint-20260911-case-appendix.md').read_text(encoding='utf-8')
assert len(set(re.findall(r'draft_m07_kw_[a-z_]+',appendix)))==15
assert len(set(re.findall(r'draft_m07_page_[a-z_]+',appendix)))==3
assert len(set(re.findall(r'\| (?:call|interval|voice) / ([a-z_]+) \|',appendix)))==9
episode=json.loads((root/'data/episodes/episode_003_dead_frequency_station.json').read_text(encoding='utf-8-sig'))
assert {c['id'] for c in episode['clues']} <= set(re.findall(r'clue_dead_frequency_[a-z_]+',appendix))
for term in ['빨간 비옷','빨간 우산','조사 기록: 분류','조사 지도:','상황 대응','HP·레벨·턴']:
    assert term in text,term
for asset in receipt['assets']:
    path=root/asset['path'];assert path.is_relative_to(root)
    assert hashlib.sha256(path.read_bytes()).hexdigest()==asset['sha256']
    image=Image.open(path)
    assert list(image.size)==asset['size']
    if asset['path'].split('/')[-1] in ['narae.png','oh-hyeon.png','kang-ijun.png','lume.png','lume-m04.png','lume-m04-red.png','lume-m07.png','m01-attendant.png','lume-m04-sd.png','m04-umbrella.png','m07-presenter.png','wordmark.png']:
        assert image.mode=='RGBA',path
        assert image.getchannel('A').getextrema()[0]==0,path
        assert image.getpixel((0,0))[3]==0,path
    assert not asset['approved'] and not asset['runtime_applied']
atlas=json.loads((root/receipt['atlas']['metadata']).read_text(encoding='utf-8'))
assert atlas['meta']['size']=={'w':3076,'h':1536}
assert len(atlas['frames'])==3
for i,frame in enumerate(atlas['frames']):
    assert frame['frame']=={'x':i*1026,'y':0,'w':1024,'h':1536}
assert hashlib.sha256((root/receipt['atlas']['image']).read_bytes()).hexdigest()==receipt['atlas']['sha256']
lume_atlas=json.loads((root/receipt['lume_atlas']['metadata']).read_text(encoding='utf-8'))
assert len(lume_atlas['frames'])==3 and not receipt['lume_atlas']['animation']
assert lume_atlas['meta']['size']=={'w':3844,'h':1568}
for i,frame in enumerate(lume_atlas['frames']):
    assert frame['frame']=={'x':i*1282,'y':0,'w':1280,'h':1568}
assert hashlib.sha256((root/receipt['lume_atlas']['image']).read_bytes()).hexdigest()==receipt['lume_atlas']['sha256']
anomaly=json.loads((root/receipt['anomaly_atlas']['metadata']).read_text(encoding='utf-8'))
assert anomaly['meta']['size']=={'w':3844,'h':1536} and len(anomaly['frames'])==3
for i,frame in enumerate(anomaly['frames']):
    assert frame['frame']=={'x':i*1282,'y':0,'w':1280,'h':1536}
assert hashlib.sha256((root/receipt['anomaly_atlas']['image']).read_bytes()).hexdigest()==receipt['anomaly_atlas']['sha256']
assert Image.open(root/'.asset-vault/blueprint-20260911/victims-atlas.png').size==(2172,724)
for path,digest in receipt['reference_inputs'].items():
    assert hashlib.sha256((root/path).read_bytes()).hexdigest()==digest,path
assert len(receipt['reference_inputs'])==5
assert all(item['bottom']>=48 for item in receipt['layout_checks'])
assert receipt['runtime']=='NOT_RUN' and receipt['human']=='NOT_RUN'
print(json.dumps({'document_hash_and_coverage':'PASS','asset_paths_hashes_alpha':'PASS','atlas_regions':'PASS','layout_bounds':'PASS','pages':len(reader.pages),'candidate_images':len(receipt['assets']),'runtime':'NOT_RUN','human':'NOT_RUN','full_production_readiness':'NOT_COMPLETE'},ensure_ascii=False))
