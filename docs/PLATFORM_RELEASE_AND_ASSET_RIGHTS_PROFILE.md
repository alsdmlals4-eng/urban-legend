# 괴이 기록국 플랫폼 출시·에셋 권리 Profile

> Base 정본: `alsdmlals4-eng/Base/docs/knowledge/game-development/PLATFORM_REVIEW_ASSET_RIGHTS_AND_REFERENCE_PRODUCTION_GUIDE.md`
> 기준 main: `55721e905bf24fc3deb0de061a529ecb992aee80`

## 전략

```yaml
rating_strategy: LOWEST_VIABLE_RATING
adult_only_avoidance: AVOID_ADULTS_ONLY
content_rating_target: UNASSIGNED_PENDING_REPRESENTATIVE_BUILD
rating_candidate_range: AGE_12_OR_15_CANDIDATE
target_audience: TEEN_AND_ADULT_MYSTERY_STRATEGY_PLAYERS_PENDING_VALIDATION
children_in_target_audience: false
platforms:
  PC: PRIMARY
  Steam: PRIMARY_RELEASE_CANDIDATE
  STOVE: EVALUATION_CANDIDATE
  Google_Play: NOT_CURRENT_SCOPE_PC_VALIDATION_FIRST
```

괴이·공포의 핵심 정체성을 훼손하면서 전체이용가를 강제하지 않는다. 청소년이용불가·18+는 기본적으로 피하되 실제 공포·폭력·범죄·언어 표현을 숨기지 않고 대표 빌드 기준으로 12세 또는 15세 후보를 검토한다.

## 콘텐츠 위험 초안

| Risk | 현재 관찰 | 출시 전 확인 |
|---|---|---|
| horror | 괴이 규칙·불안·위험 사례·안정화 과정 | 공포 강도, 반복 빈도, 갑작스러운 연출, 신체 훼손 |
| violence | 처치가 아닌 안정화이지만 위협·피해·실패 묘사 존재 가능 | 유혈·상처·사망·피해 결과 |
| crime | 사건 조사·불법 행위 맥락 가능 | 모방 가능성·보상 여부 |
| language / drugs / sexual content | 정본만으로 전수 판정 불가 | 모든 대사·일러스트·이벤트 |
| gambling/simulated gambling / ads/IAP | 출시 모델 미확정 | 유료 재화·확률·광고 |
| UGC/online interaction | 현행 범위에 없음 | 실제 출시 기능 |
| AI-generated/live-generated content | 이미지·텍스트·음향별 증빙 필요 | 모델·서비스·버전·입력 권리·약관·Steam disclosure |

## 자산·참조 기반 독립 제작

음악·효과음, 폰트, 캐릭터·일러스트·표정·컷인·UI, 3D·애니메이션, 플러그인·에셋, OSS, AI 출력·약관, 외주, 성우·작곡·번역 계약을 자산별로 관리한다.

```text
합법적인 reference source
→ 기능·정보 위계·공포 리듬·일반 제작 원리
→ 식별 가능한 forbidden_expression
→ 괴이 기록국 고유 reference_brief
→ 독립 working files·final_asset_record
→ similarity and rights review
```

실존 괴담·사진·작품·작가 스타일·특정 성우·캐릭터를 식별 가능하게 복제하거나 원본을 AI로 변환하는 방식은 독립 제작으로 인정하지 않는다.

## Gate

권리·조건 이행·OSS 고지·AI 입력 권리·Steam/STOVE 설문·build/store/trailer 일치·민감 계약 보안 중 하나라도 미확인이면 `RELEASE_BLOCKED_UNVERIFIED`다.

```text
RUNTIME_ASSET_USE_CHECKED: NOT_RUN
BUILD_STORE_CONSISTENCY_CHECKED: NOT_RUN
STEAM_SUBMISSION: PLATFORM_SUBMISSION_NOT_RUN
STOVE_SUBMISSION: PLATFORM_SUBMISSION_NOT_RUN
FINAL_RATING: NOT_ASSIGNED
LEGAL_REVIEW_NOT_PERFORMED
```
