# D-2026-08-11-CASE01-FIELD-INVESTIGATION-SURFACE-CONTRACT

> 상태: `USER_APPROVED_RECOMMENDED_FLOW / FIELD_VS_DEVICE_RESPONSIBILITY_SEPARATED / PLANNING_ONLY / IMPLEMENTATION_NOT_AUTHORIZED`
> 승인 시각: 2026-08-11 KST
> 적용 범위: CASE-01 현장 조사 화면과 InvestigativeDeviceShell의 책임 분리
> Human/UI 검증: `NOT_RUN`

## 1. 목적

CASE-01의 현장 조사 화면은 플레이어가 **현재 장소에서 보고, 읽고, 조사하고, 선택하는 주 플레이 Surface**로 유지한다.

기록·괴이 매뉴얼·지도는 현장 화면에 각각 중복 구현하지 않고 공통 `InvestigativeDeviceShell`에서 제공한다.

```text
LocationInvestigationSurface
├─ LocationVisual
├─ FieldNarrative
├─ InvestigationPoint / Method
├─ TeamStatus
├─ FieldProgress / Result feedback
├─ Device entry controls
├─ [이동]
└─ Lume call indicator (contextual only)

InvestigativeDeviceShell
├─ [기록]
├─ [괴이 매뉴얼]
└─ [지도]
```

실제 클래스명은 구현 단계에서 정하며 위 이름은 책임 구분용이다.

## 2. 현장 조사 Surface의 소유 범위

현장 화면이 소유하는 플레이어-facing 의미는 다음이다.

- 현재 장소의 배경/현장 시각 정보
- 현재 장면의 화자·대화·서술
- 현장 선택지
- 조사 가능한 포인트
- 선택한 조사 포인트에 대한 조사 방법/행동
- 조사 행동 직후 결과 피드백
- 팀 상태의 간결한 확인
- 현재 사건 진행/대응 진입에 필요한 기존 진행 피드백
- `[이동]` 진입
- 공통 조사 디바이스 진입
- 새 비정답성 루메 코멘트가 있을 때의 소형 호출 표시

## 3. 현장 화면이 소유하지 않는 범위

다음은 현장 화면에 별도 사본을 만들지 않는다.

- 기록 아카이브 전체 열람 UI
- 괴이 매뉴얼 전체 편집 UI
- 전체 지도 및 장소 상세 UI
- 독립 `[로그]`/`AI 로그` UI
- 루메 전용 전체 화면
- 지도와 별개의 현장 전용 이동 규칙

기존 구현에 존재하는 기록 drawer·매뉴얼 panel·로그 관련 요소는 CASE-01 새 UI 정본에서 그대로 유지해야 하는 정보구조 권위가 아니다. 제품 변환 방식은 구현 계획에서 안전하게 정한다.

## 4. 공통 디바이스 진입 계약

현장 조사에서 플레이어는 `[기록]`, `[괴이 매뉴얼]`, `[지도]` 기능에 접근할 수 있어야 한다.

권장 UX:

- 현장 utility 영역에서 원하는 기능을 직접 선택하면 `InvestigativeDeviceShell`이 해당 탭으로 열린다.
- Shell 상단에는 항상 `[기록] [괴이 매뉴얼] [지도]`와 `[현장으로 돌아가기]`가 있다.
- Shell을 연 것만으로 대화·조사 진행·시간·판정이 진행되지 않는다.
- `[현장으로 돌아가기]`로 닫으면 기존 현장 대화/조사 포인트/방법 선택 문맥을 복구한다.
- 다시 Shell을 일반 재개할 경우 마지막 사용 탭 상태 보존 계약을 따른다.

## 5. 현장 조사 행동 계약

현장 조사 흐름은 UI 컴포넌트가 정답 판정을 직접 소유하지 않는다.

```text
investigation point selected
→ available method/action presentation
→ action requested
→ domain/runtime result
→ result feedback
→ updated field state render
```

UI는 `point_selected`, `method_selected`, `action_requested`와 같은 사용자 의도를 전달하는 역할로 제한한다. 실제 signal/API 이름은 구현 단계에서 current code와 맞춰 결정한다.

필수 진실/진행 규칙, 능력 판정, 비용, 결과 데이터의 권위는 기존 도메인 계약을 따른다.

## 6. [이동] 계약

현장 `[이동]`은 `D-2026-08-11-CASE01-SHARED-LOCATION-TRAVEL-CONTRACT`를 사용한다.

```text
현장 [이동]
→ 장소 선택
→ 장소 상세/상태 확인
→ [이동]
→ shared travel request
→ 성공 시 새 장소 LocationInvestigationSurface
```

지도 탭과 다른 장소 ID·잠금 조건·이동 성공 판정을 만들지 않는다.

## 7. 루메 계약

현장에서는 루메 본체를 상시 표시하지 않는다.

- 새 비정답성 코멘트가 있을 때만 작은 호출 표시를 노출한다.
- 호출을 열면 짧은 코멘트만 확인한다.
- 대화, 선택지, 조사 행동, 장소 시각을 가리지 않는다.
- 정답 행동·정답 장소·정답 키워드·미획득 단서를 알려주지 않는다.

## 8. 오버레이/입력 우선권

InvestigativeDeviceShell 또는 장소 선택 UI가 열려 있을 때 그 위에서 의도한 interactive control만 입력을 소유해야 한다.

- 뒤의 현장 조사 버튼이 오작동으로 눌리지 않는다.
- 비인터랙티브 장식/투명 영역이 불필요하게 포인터를 가로채지 않는다.
- 닫기/취소 시 가장 위에 열린 UI부터 닫고 현장으로 복귀한다.

이는 기존 조사 화면 포인터 blocker 회귀를 다시 만들지 않기 위한 설계 경계다.

## 9. 플랫폼 계약

PC·태블릿·휴대폰 가로 모두 같은 화면 구성과 의미를 사용한다.

- 마우스 클릭
- 터치 탭
- 키보드/게임패드 포커스 + 결정

중 어느 입력으로도 핵심 조사와 utility 진입을 완결할 수 있어야 한다.

## 10. 구현 경계

이 Decision은 현장 Surface의 **책임과 흐름**만 승인한다.

아직 승인하지 않는 항목:

- `investigation_scene.gd` 또는 `.tscn` 실제 수정
- 노드 트리/Container/Anchor의 최종 구조
- 버튼 위치·픽셀·폰트 크기
- 기존 record/manual/log UI 제거 방식
- InputMap의 실제 action 이름
- save schema 변경
- 새로운 조사 규칙/비용/진행 판정

다음 단계에서 CASE-01 전체 UI 분리 명세를 하나의 Spec으로 묶고 최종 설계 검수를 거친다.
