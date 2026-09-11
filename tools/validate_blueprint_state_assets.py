"""Read-only validation of the bounded Blueprint state/motion candidate pack."""
import hashlib
import json
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PACK = ROOT / '.asset-vault/aseprite-candidates/ui-motion-20260911'
SOURCE = ROOT / '.asset-vault/blueprint-20260911'


def same(a, b):
    return a.size == b.size and a.convert('RGBA').tobytes() == b.convert('RGBA').tobytes()


def main():
    board = Image.open(SOURCE / 'ui-button-states.png')
    assert same(board, Image.open(PACK / 'button-board.png'))
    atlas = Image.open(PACK / 'button-atlas.png')
    frames = json.loads((PACK / 'button-atlas.json').read_text())['frames']
    names = ['normal', 'hover', 'pressed', 'focus', 'disabled', 'selected']
    assert len(frames) == 6 and atlas.size == (704, 1390)
    for i, name in enumerate(names):
        x, y = (32, 800)[i % 2], (65, 383, 702)[i // 2]
        expected = board.crop((x, y, x + 704, y + 230))
        assert same(expected, Image.open(PACK / f'button-{name}.png')), name
        assert frames[i]['frame'] == dict(x=0, y=i * 232, w=704, h=230)
        assert same(expected, atlas.crop((0, i * 232, 704, i * 232 + 230))), name
    opened = Image.open(SOURCE / 'lume-m04-sd.png')
    closed = Image.open(PACK / 'lume-blink.png')
    assert same(opened, Image.open(PACK / 'lume-open.png'))
    assert closed.size == opened.size == (1254, 1254)
    assert closed.mode == 'RGBA' and closed.getchannel('A').getextrema() == (0, 255)
    motion = Image.open(PACK / 'lume-blink-atlas.png')
    motion_frames = json.loads((PACK / 'lume-blink-atlas.json').read_text())['frames']
    assert len(motion_frames) == 3 and motion.size == (3766, 1254)
    assert [f['duration'] for f in motion_frames] == [2600, 120, 280]
    for i, expected in enumerate([opened, closed, opened]):
        assert motion_frames[i]['frame'] == dict(x=i * 1256, y=0, w=1254, h=1254)
        assert same(expected, motion.crop((i * 1256, 0, i * 1256 + 1254, 1254)))
    print(json.dumps({
        'structural_validation': 'PASS', 'button_states': 6,
        'source_crop_pixels': 'EXACT', 'motion_frames': 3,
        'motion_visual_review': 'REVISION_REQUIRED_NON_EYE_COLOR_DRIFT',
        'runtime': 'NOT_RUN', 'human_approval': 'NOT_REQUESTED_FOR_FAILED_MOTION',
        'sha256': {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                   for p in sorted(PACK.iterdir()) if p.is_file()},
    }, indent=2))


if __name__ == '__main__':
    main()
