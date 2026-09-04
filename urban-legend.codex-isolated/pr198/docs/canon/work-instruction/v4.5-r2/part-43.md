| v4.4 Vertical Slice 완료 기준 | 35.1 | `PASS` |
| v4.4 GPT 역할 분리·객관 증거 | 28.2 | `PASS` |
| v4.4 로컬 접근 불가 행동 | 35.2 | `PASS` |

의도적으로 복원하지 않은 것은 Base current canon의 장문 복제·과거 Action SHA·고정 Skill 수처럼 Thin Adapter 원칙과 충돌하는 내용뿐이다.
그 항목들은 **누락이 아니라 current Base 재조회로 대체**한다.

---

## 44. 최종 원칙

```text
이 지시문을 업데이트하는 요청에서는 지시 범위를 넘어 실제 프로젝트 작업을 실행하지 않는다.
Base는 매번 current main에서 다시 읽는다.
이 파일은 Base의 복제 정본이 아니라 프로젝트 Thin Adapter다.
GPT 채팅에서 기획을 모두 닫고 사용자가 “기획 완료”를 선언한 뒤 최종 검수를 끝내기 전에는 PowerShell/Codex/Godot BUILD를 시작하지 않는다.
상세 데이터 수치는 GPT 권장안+범위+벤치마킹으로 진행하되 기획 충돌은 Grill Me 승인 없이는 확정하지 않는다.
Grill Me는 10건을 최대 배치로 하고 고위험·세션 종료·정본 영향이 크면 조기 체크포인트를 허용한다.
