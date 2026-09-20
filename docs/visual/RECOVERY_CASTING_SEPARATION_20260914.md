# Recovery casting separation brief

Status: GENERATED_CANDIDATE / REVISION_REQUIRED; production promotion not granted.
Consumer: battle scene `RecoveryCastingCutIn/CastImage`, live caption/skip controls.
W07 owner: `docs/superpowers/specs/2026-09-14-remaining-implementation-contract.md`.

## Evidence and decisions

User GIF SHA-256: `51da2ec05f18cff7f8bad2b6af38e6a97ab7f06e9c962d55ea01e0874418a75e`.
All 172 frames were decoded for duration (6880 ms); 12 evenly distributed frames
were visually inspected, not every transition frame. It is a montage: initial
caster/shield, a different actor with slash effect, ordinary battle UI, then
firearm casting/effect shots. Do not copy characters, combat rules, flash intensity,
damage numbers, pixel treatment, or the full montage duration.

- ADOPT: recognizable actor and action pose before the scene effect.
- ADAPT: restrained local protection/containment effect with existing rule-based
  support, no new attack/kill system; preserve telegraph and protected-target HUD.
- REJECT: full-screen video with baked UI, wholesale GIF copying, anonymous
  representative actor, or stretching the existing opaque scene illustration.
- Existing native 1.2-second component remains the timing/input owner for now;
  effect timing refinement cannot reapply support effects or consume field time.

The existing Kang Ijun recovery support PNG was visually inspected. It includes
station scenery and a protective field, so it is reference input, not a separated
runtime sprite. Root-manifest promotion/rights for this MVP043 collection was not
confirmed. Preserve it without silently granting final approval.

Sources read: [Aseprite sprite sheets](https://www.aseprite.org/docs/sprite-sheet/)
for layer/frame export and [Godot AnimationPlayer](https://docs.godotengine.org/en/stable/classes/class_animationplayer.html)
for future coordinated property timing. ADAPT existing native timing now; TEST
AnimationPlayer for a multi-track effect only when approved layer consumers exist.
No new plugin or paid path. GIF exceeds the restricted Aseprite aggregate pixel
budget, so its inspection uses a read-only source decoder, not a bypassed export.

## Candidate A: Kang Ijun casting figure

- Reference: `assets/characters/mvp043/agents/kang_ijun/recovery_support.png`.
- Preserve young adult male face, tousled dark hair, black modern tactical jacket,
  practical gear/straps, gloved open hand extended toward screen left, restrained
  anime-noir ink rendering. No new costume, weapon, insignia, text or actor.
- Separate the actor only. No station, shield dome, particles, victim, ground,
  frame or caption. Effects belong to a subsequent field layer, not the figure.
- Target source 1536×1024 landscape, head/torso/hand fully inside, safe margin 5%.
- Flat chromakey green background, no green spill/gradient/shadow; subsequently
  remove background and inspect real alpha, edge color and complete silhouette.
- Pose is one casting hold, not a multi-frame animation. Native short entrance/
  hold/exit may animate this pose; do not claim articulated motion.
- Store candidate under project-local `.asset-vault`, preserve both chroma and
  alpha outputs, hash/provenance, and never replace the catalog path before lock.

## Subsequent work, not completed by this candidate

Separate protection field with target anchor and onset/hold/retire states; actual
victim/phenomenon spatial binding; motion-strength setting; all actor coverage;
720/1080/F2 occlusion and pause/skip regression; rights and final visual lock.

## Consumer-semantic correction after candidate inspection

The actual M01/M04 episode records identify Kang Ijun as an eastern talisman
specialist, but his active recovery supports are `support_kang_pattern_observation`
and `support_kang_rain_pattern`, both observation/pattern prediction. Thus the
old protective-dome illustration cannot authorize a new protective mechanical
effect. The generic separation candidate does **not** satisfy the final role/
equipment brief. Its current use is extraction/identity comparison only.

For these two supports, field feedback must indicate the authored observation
without revealing an unobserved correct action. Reserve protective effects for
an actual protective support owner. Do not change episode roles or support data
to justify a convenient old illustration. This supersedes the broad protection
effect wording above for Kang's M01/M04 consumers.

## Candidate receipt and rejection

Built-in image tool, 2026-09-14, identity-preserve prompt: keep the same face,
hair, tactical clothing and open-hand pose; remove station/shield/particles/UI;
single figure, 1536×1024, flat #00FF00, no spill. Source reference SHA-256:
`42ed1050456faa8855ef58ec594e80b6dec4714d3cc1702574672797d70a6138`.

Project-local files in `.asset-vault/aseprite-candidates/recovery-casting-20260914/`:

| File | SHA-256 | Measured/result state |
| --- | --- | --- |
| kang-ijun-casting-chroma.png | 433d06cff247ad51920598040a1bdc64e189240f828dd378482a2c4baaa9e519 | RGB1536×1024, chroma intermediate; no alpha expected |
| kang-ijun-background-removal-attempt.png | 939e7bf1d323c76dd57473571cce9ff5d0cf9ffd4e93fc10525f9ccf9d6b7ef3 | RGB1536×1024, no alpha; baked checkerboard, REJECTED |

The removal prompt explicitly requested RGBA transparency and no checkerboard,
with identical silhouette/style/canvas. Actual pixels contradict that request.
Do not label the result transparent or place it into the runtime catalog. The
model also altered shading, so it is not a pixel-identical mask operation.
The chroma figure's hand anatomy and bottom crop require final visual review.
Both original attempts remain local for traceability; no canonical art replaced.

Restricted project Aseprite copy/metadata readback is used to preserve the chroma
candidate as one editable still. This is not alpha cleanup or motion completion.
