# 괴이기록국 · Visual Direction Lock Packet · 2026-08-28

> Role: `VISUAL_DIRECTION_LOCK_PACKET`
> Decision: `D-2026-08-28-URBAN-NOIR-HYBRID-VISUAL-DIRECTION`
> Status: `USER_APPROVED / PLANNING_CANON`
> Selected candidate: `A — 현실적 한국 도시 누아르 환경 + 애니풍 인물·괴이 + 손그림 기록물 UI`
> Owner: Project repository + Notion `03 · Direction` / `04 · Visual · UX · Assets`
> Scope: visual grammar and planning visualization only; no runtime asset, Scene, UI implementation, Human QA, or Player Experience PASS is implied.

## 1. Selection and reason

The user approved candidate A on 2026-08-28 after the current canon, actual M04 Investigation background, M04 B/C anomaly cutout, and the approved CASE-01 UI style reference were read together. It retains the project’s already locked `SOFT_ANIME_NOIR_LOCKED` treatment and `DOSSIER_HYBRID_IS_PRESENTATION_LANGUAGE_NOT_MEDIUM` invariant while making the layer split explicit:

```text
grounded Korean urban-noir place
  + soft-anime player / anomaly identity
  + hand-drawn institutional dossier UI
  = one readable investigation-and-recording game
```

This is an `ADAPT` decision, not a replacement of existing approved product assets. The actual M04 `red_crossroads.png` and the M04 B/C cutout are evidence for the environment/anomaly split; the CASE-01 approved UI reference is evidence for the dossier layer.

## 2. Adopted and rejected elements

### Adopted

- Modern Korean alley, station, office, and closed-shop geography grounded in wet surfaces, modest practical light, and readable evidence placement.
- Environment value hierarchy first: dark neutral mass, restrained warm practical light, then a small red anomaly accent. Red is danger/phenomenon emphasis, not a universal reward or answer marker.
- Kwon Narae remains the fixed female player protagonist. Character presentation may be one notch more anime-like than place/UI, without turning routine investigation into a character poster.
- Anomalies may carry the strongest silhouette and color interruption; their identity must remain legible at gameplay scale.
- Manual, evidence record, and result surfaces use worn paper, ink, pins, stamps, linework, and hand-drawn institutional framing as UI language.
- Pixel/dot language remains subordinate observation language for logs, CCTV, sensors, map markers, or interference.
- Investigation surfaces preserve evidence-first composition; Recovery preserves phenomenon → telegraph → protected target → rule → contextual response priority.

### Rejected / superseded as a current direction

- A uniformly anime-painted world where places, UI, and characters share the same illustration density.
- A fully photographic or pure realistic-noir treatment that removes the project’s character/anomaly expressiveness and dossier language.
- A pixel-only or neon-glass HUD treatment.
- Generated-board pseudo-text, decorative map routes, badges, cards, or icons as a source of truth for new systems, buttons, rewards, or state.

## 3. Layer anchors

| Layer | Confirmed anchor |
| --- | --- |
| Character | Soft-anime noir rendering, practical modern field silhouette, small routine exposure, short high-meaning Cut-in only. |
| Environment | Grounded Korean urban occult location; evidence and navigable negative space outrank decoration. |
| Anomaly | Strong but bounded silhouette/color disturbance; never hide relevant clue or telegraph. |
| UI | Hand-drawn dossier/institutional record language; live Godot text and controls retain semantic ownership. |
| VFX | Rain, reflection, CCTV/sensor interference, and restrained red phenomenon accents; VFX must not create a false answer signal. |

## 4. Global style anchor

- **Mood and emotion:** a quiet, rain-heavy urban unease that turns into careful responsibility, not spectacle-first horror.
- **Rendering language:** environment material is grounded/painterly-real; characters and anomalies are softer anime-noir; UI is tactile archival illustration.
- **Palette/value/material/light:** charcoal/blue-black foundation, aged paper secondary plane, limited warm lamps, anomaly red as controlled contrast; wet concrete, faded paper, matte practical fabric.
- **Shape/silhouette/proportion:** ordinary city geometry and institutional rectangles; characters remain compact and readable; anomaly silhouette must differ from civilian silhouette.
- **Camera/framing/density:** environment-wide investigation framing, close record surfaces for deduction, no dense decorative layer over clue/action zones.

## 5. Keep / Avoid / Do Not Drift / allowed variation

| Rule | Direction |
| --- | --- |
| Keep | Korean urban specificity, evidence-first readability, fixed protagonist Kwon Narae, restrained occult red, dossier hierarchy. |
| Avoid | Generic cyberpunk signage, glossy sci-fi panels, full-screen permanent portraits, poster-like character poses in ordinary investigation, answer-coded color. |
| Do Not Drift | Do not turn the project into full pixel art, photoreal thriller, generic anime fantasy, or an unrelated franchise-like visual identity. |
| Allowed variation | District, faction, weather, time, and anomaly state may alter texture/value/accent density only while keeping the shared grammar and gameplay-scale readability. |

## 6. Provenance and rights boundary

- Planning board: `docs/visual/boards/PROJECT_CORE_SCENE_VISUAL_BOARD_2026-08-28.png`.
- Receipt: generated in the current Codex session from the current project’s actual M04 background/cutout and approved CASE-01 UI reference as style/context inputs; corrected after an initial protagonist-gender mismatch.
- SHA-256: `8ce0fc336b2ef874ed6243ec815a3ef4071bed972690a1568e6e8c4307b3545b`.
- Classification: `GENERATED_EXPLORATION / PROJECT_UNDERSTANDING_VISUALIZATION / NOT_PROJECT_ASSET / NOT_RUNTIME_ASSET / NOT_GODOT_IMPLEMENTATION`.
- This packet neither grants third-party rights nor converts any generated composition, pseudo-text, icon, or visual motif into a release asset. Any future runtime asset follows the existing runtime-consumer-first, provenance, resolution, and Human QA gates.

## 7. Consequences

Future planning visuals must follow this packet. Production asset batches and Godot/UI implementation remain out of scope until their consumer-specific brief, approved task, promotion gate, and actual runtime validation are separately complete.
