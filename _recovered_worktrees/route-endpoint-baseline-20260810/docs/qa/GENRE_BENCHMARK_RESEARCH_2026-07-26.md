# 유사 장르 벤치마크 연구 QA

> 날짜: 2026-07-26  
> Issue: #86  
> 상태: `RESEARCH_COMPLETE / CI_PENDING`

## 조사 범위

- 시간 예산과 일정 선택
- 성장·관계의 기능적 환류
- 추리 보드와 정답 확인
- 도시 공포 압박과 마감
- 실패 전진과 기록 축적
- 장기 플레이 반복 UX

## 공식 출처 우선 사용

- Persona 5 Royal 공식 사이트
- I Was a Teenage Exocolonist 공식 사이트 및 Nintendo 소개
- Citizen Sleeper 공식 상점·프레스킷
- WORLD OF HORROR 공식 사이트
- The Case of the Golden Idol 공식 상점 및 개발자 인터뷰
- Return of the Obra Dinn 공식 사이트
- PARANORMASIGHT 공식 사이트·Square Enix 소개
- Strange Horticulture 공식 사이트
- Long Live the Queen 공식 상점

## 보조 출처 사용 범위

커뮤니티 위키는 공식 페이지에서 확인하기 어려운 다음 세부 기계만 보조 확인에 사용했다.

- Long Live the Queen의 주간 수업·기분·기술 판정 구조
- Return of the Obra Dinn의 신원·사인 기록과 묶음 확인
- PARANORMASIGHT의 Story Chart 내비게이션

보조 출처에서 얻은 세부 사항은 보고서에서 `보조 출처`로 명시했다.

## 결론 감사

- 현재 4주×7일 구조 유지
- 기존 위험 0/15/30 유지
- 권나래 고정 유지
- CORE 추리 공정성 유지
- 기존 save·ID·보호 경로 유지
- 벤치마크 개선안은 `RECOMMENDED_FOR_REVIEW`
- 구현 승인 없음
- 사람 QA·신규 플레이어 검증 없음
- `POC_PASSED` 미선언
- 제작 확대 미승인

## P0 권장 후보

1. 일정 결과 미리보기
2. 사건 징후 시계
3. 관측·가설·반박 보드
4. 주간 인과 요약
5. 반복 편성 도구
6. 동료 지원 투명성
7. 연구·매뉴얼 상호 링크

## 제외 패턴

- 핵심 단서 무작위화
- 전체 캠페인 초기화
- 주사위 중심 행동 성패
- 반복 선물·방문 관계
- 회차 기억 전용 필수 정답
- 숨은 임계치 즉사
- 동료 자동 정답 제공

## 자동 계약

`tests/test_genre_benchmark_contract.py`가 다음을 검증한다.

- 비교 대상 9개 유지
- 고정 계약 유지
- P0 7개 유지
- 제외 패턴 7개 유지
- 결정 로그 연결
- `TBD`·`TODO` 부재
