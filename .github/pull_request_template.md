## 변경 이유

- 해결할 플레이어 가치·개발 문제:
- 연결 Issue/Goal:
- Work Mode / 주 프로젝트 Skill / Base 지원 Skill / Mode:
- 선택 이유:

## 코어·범위·보존 계약

- [ ] `docs/PROJECT_CORE.md` 영향과 재승인 필요 여부를 판정했다.
- [ ] 포함·제외·완료 기준·영향 파일·rollback을 적었다.
- [ ] 저장·ID·Schema·보호 경로·사용자 변경을 보존한다.
- [ ] 구조 개선과 의도적 기능 변경을 분리했다.

## 구조 개선 판정

- 가지치기: `KEEP / MERGE / MOVE_TO_REFERENCE / STUB / ARCHIVE / DELETE / UNVERIFIED`
- 간소화: 본문 유지 계약 / 이동 reference / 발견성 검증:
- 리팩토링 baseline / 보존 인터페이스·출력·Schema:

## 적대적 검토

- 실패 가정·공격 렌즈:
- `MUST_FIX`:
- 승인한 `SHOULD_FIX`:
- `DEFER / REJECT / UNVERIFIED`:
- regression-recheck 결과:

## 구현 내용

-

## Base·Skill·정본 확인

- [ ] `docs/BASE_RULES_VERSION.md`의 pin과 Registry·Index·Adapter가 일치한다.
- [ ] Base 25개·18책임 Coverage와 프로젝트 Skill 10개가 누락 없이 연결된다.
- [ ] 전체 Skill을 기본 로드하거나 공용 본문을 불필요하게 복제하지 않았다.
- [ ] 통합·이름·경로 변경에 Alias·역참조·생성기·테스트 갱신이 있다.
- [ ] 책임 원본과 실제 파일·파생본 상태가 일치한다.

## 검증

- 자동·정적:
- Godot·런타임:
- 저장·회귀:
- 수동 UI·해상도·입력:
- GitHub Actions:
- `NOT_RUN / UNVERIFIED`:

## Changed-file·PR 감사

- [ ] 변경 파일을 전수 확인했다.
- [ ] 삭제·rename·바이너리·보호 경로를 별도로 확인했다.
- [ ] stacked PR의 차단 finding을 상속하지 않는다.
- [ ] PR 설명·실제 CI·테스트 결과가 일치한다.

## 결과

- 보존한 기능·코어·장점:
- 실제 변경·감소한 중복:
- 남은 위험·다음 trigger:
- 상태: `PASS | PARTIAL | FAIL | UNVERIFIED`
