HiGodot은 채택된 프로젝트에서 persistent Godot authoring의 단일 권위다.
GUT은 deterministic GDScript test 권위이며 production을 저작하지 않는다.
Hera는 live QA/observability만 수행하고 tracked source delta를 남기지 않는다.
Windows와 Android는 하나의 게임 로직·데이터 코어를 공유한다.
public repo의 standard GitHub-hosted Actions는 예산 0이어도 REMOTE_CI 기본이다.
Actions는 reviewed full-length SHA와 least privilege를 사용한다.
검증 중 main이 움직이면 이전 GREEN을 재사용하지 않고 current base에서 재검증한다.
Required ci-gate와 unresolved thread, strict up-to-date를 우회하지 않는다.
병합 성공은 new main readback으로 확인한다.
사용자 로컬 전달은 Fetch origin→Pull origin 중심으로 유지한다.
실행하지 않은 조사·Skill·test·Godot·기기·사람 검증을 실행했다고 말하지 않는다.
```
