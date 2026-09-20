# Blueprint 후속 상태 자산 준비 — 2026-09-11

기획/시안 준비 계약의 후속 검수 기록이다. 기존 69쪽 OPTIMIZED PDF는 그대로 보존하며 **이 후속 실험을 포함하지 않는다**. 이 문서는 새 기획 정본이나 runtime 승인 대체물이 아니다. 최종 Blueprint 통합 전 남은 준비 항목으로 읽는다.

## 비교와 채택

| 대안 | 판정 | 근거와 영향 |
| --- | --- | --- |
| 승인된 6상태 보드를 버튼마다 통째로 늘리기 | REJECT | 다른 상태가 함께 보이고 모서리 비율이 변한다. |
| 승인된 보드에서 상태별로 분리하고 엔진의 테두리 보존 기능 사용 | ADAPT | 승인 외형을 보존하며 실제 버튼 상태에 대응할 수 있다. Godot의 StyleBoxTexture region/texture margin 구조를 활용한다. |
| 새 버튼을 전부 다시 생성 | REJECT | 현재 승인 선택을 불필요하게 흔들며 일관성 검수 비용이 늘어난다. |

근거: [Godot StyleBoxTexture 공식 문서](https://docs.godotengine.org/en/stable/classes/class_styleboxtexture.html), [Aseprite animation 공식 문서](https://www.aseprite.org/docs/animation/), 승인 원본 `ui-button-states.png`와 `lume-m04-sd.png`. 외부 문서는 엔진/제작 구조 참고이며 프로젝트 외형의 정본이 아니다. benchmark/reuse preflight는 기존 승인 원본 재사용 + 공식 구조 ADAPT다.

## 버튼: 분리 완료, 엔진 연결 전

프로젝트 내부 후보 폴더: `.asset-vault/aseprite-candidates/ui-motion-20260911/`.

| 상태/프레임 | 원본 crop x,y,w,h | atlas x,y,w,h |
| --- | --- | --- |
| normal / 1 | 32,65,704,230 | 0,0,704,230 |
| hover / 2 | 800,65,704,230 | 0,232,704,230 |
| pressed / 3 | 32,383,704,230 | 0,464,704,230 |
| focus / 4 | 800,383,704,230 | 0,696,704,230 |
| disabled / 5 | 32,702,704,230 | 0,928,704,230 |
| selected / 6 | 800,702,704,230 | 0,1160,704,230 |

`button-states.aseprite`가 편집 가능한 분리본, `button-atlas.png/json`이 704×1390/2px 간격의 파생 후보다. PNG 6개도 개별 출력했다. 프레임 duration 100ms는 Aseprite 기본값일 뿐 **재생 애니메이션이 아니다**. 실제 UI 상태로 프레임을 선택한다. 원본 crop와 내보낸 픽셀의 동일성은 검증기로 확인한다.

예정 소비자는 `scripts/ui/main_menu.gd`의 버튼 표현 계층이다. 소비자 파일 존재와 적용 가능성은 확인했으나 이번 작업에서 연결하지 않았다. focus는 색만 바꾸지 않고 별도 네이티브 윤곽으로도 표시한다. disabled는 비활성 이유를 텍스트로 설명한다. 메뉴 그룹 간 여백/버튼 간 간격은 레이아웃이 소유한다.

`preview.html`은 분리 상태를 비교하는 로컬 검수 초안이다. source slice 48px와 CSS destination border 16px는 **웹 미리보기의 시험값**이며 Godot 확정값이 아니다. 엔진 적용 시 실제 source/destination margin, 최소 높이, 글자 영역, 1280/1920 화면에서 잘림을 검증한 뒤 확정한다. 브라우저 실행 QA 및 Godot QA는 아직 NOT_RUN이다.

## 루메: 3프레임 시험, 외형 검수 불합격

`lume-blink-sequence.aseprite` 및 `lume-blink-atlas.png/json`: 1254×1254 동일 캔버스, atlas 3766×1254, x=0/1256/2512, duration=2600/120/280ms, 열린 눈→감은 눈→열린 눈. 투명 RGBA와 frame1=frame3 원본 동일성은 기계 검사한다. 원본의 귀여운 SD 비율과 M04 빨간 우산/비옷은 유지 대상이다.

**REVISION_REQUIRED_NON_EYE_COLOR_DRIFT**: 이미지 모델이 눈 이외 우산과 비옷 색도 바꿔 반복 시 색상 깜박임이 생긴다. 캔버스가 같다는 사실은 인물/색/피벗 연속성 합격이 아니다. 생성 단계의 RGB 가짜 투명 배경은 제외하고 RGBA 수정본만 시험했으나 이것도 production asset으로 승격하지 않는다.

눈 사각형만 원본에 붙이는 국소 복원도 시험했지만 피부 경계와 눈썹 잔상이 보여 기각했다. 해당 실패 중간물은 활성 consumer가 없으며 원본/전체 생성 프레임으로 재현 가능해 제거한다. 다음 시도는 얼굴 영역의 연속성을 보존하는 이미지 모델 편집이어야 한다. 생성 확대 전에 단일 눈깜박임의 눈 이외 불변 영역과 실제 재생을 통과해야 한다. 실패 시 승인된 정지 원본을 기본값으로 유지한다.

## 증거와 남은 작업

- `tools/validate_blueprint_state_assets.py`: 원본 보존, 6개 crop, atlas region/pixel, alpha, 3개 frame/time 검사. 출력에 파일별 SHA-256을 포함한다.
- 버튼 상태는 `DERIVED_FROM_USER_APPROVED_VISUAL`; 파생 엔진 결과의 승인/런타임 검증은 별개다.
- 애니풍 피해자 교체 초상은 계속 후보다. 일반적인 진행 승인을 개별 외형 최종 승인으로 해석하지 않는다.
- 시안 구조 검사 PASS와 모션 외형 실패를 동시에 기록한다. 전체 ASSET_READY / RUNTIME_VERIFIED / USER_APPROVED는 선언하지 않는다.
- 남은 필수 작업: 루메 연속성 교정 → 나머지 필요 모션/전조 상태 → 엔진용 margin/상태 계약과 atlas 검수 → 최종 Blueprint 통합/렌더 → 사용자 최종 기획 승인 → 구현.
- Base 환류: 전체 프레임 동일 크기 검사만으로 모션을 승인하면 색 드리프트를 놓친다는 프로젝트 교훈. 검증 사례가 한 건이므로 공용 강제 규칙 승격은 보류한다.
- 보호 대상: 기존 runtime dirty 변경, 승인 원본, 이전 PDF, unrelated PR. 롤백은 이번 파생 후보/후속 기록만 제외하며 원본에 영향을 주지 않는다.
