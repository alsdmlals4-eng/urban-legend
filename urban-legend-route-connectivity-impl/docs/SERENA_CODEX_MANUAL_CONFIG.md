# Serena Codex Manual Config Guide

이 문서는 Windows에서 `serena setup codex`가 실패했을 때, Codex 설정 파일에 Serena MCP 서버를 수동으로 추가하는 방법을 정리한다.

## 전제

- Serena 설치가 끝나 있어야 한다.
- `serena start-mcp-server --context=codex --project-from-cwd` 또는 유사 명령이 PowerShell에서 실행되는 것을 먼저 확인한다.
- Godot/GDScript 프로젝트에서는 Godot 에디터를 열어둔 상태에서 Serena를 사용하는 것이 좋다.
- 저장소에는 `.serena/project.yml`이 있어야 한다.

## 자원 사용 원칙

- Serena는 기본 비활성화한다. 문서 정리, 기획, 단순 파일 확인에는 실행하지 않는다.
- GDScript 심볼, 호출 관계, 여러 파일에 걸친 코드 흐름을 탐색할 때만 활성화한다.
- Serena를 활성화한 동안에는 같은 프로젝트의 Codex 구현 작업을 하나만 진행한다.
- 탐색이 끝나면 결과를 작업 문서나 Active Context에 요약하고 Serena를 다시 비활성화한다.

## 1. Codex 설정 파일 백업

수정 전 반드시 `C:\Users\user\.codex\config.toml`을 복사해 백업한다.

추천 백업 파일명:

```text
C:\Users\user\.codex\config.toml.backup-serena
```

## 2. Serena 실행 파일 경로 확인

PowerShell에서 다음을 실행한다.

```powershell
Get-Command serena | Select-Object -ExpandProperty Source
```

예상 결과 예시:

```text
C:\Users\user\.local\bin\serena.exe
```

이 경로가 다르면, 아래 설정의 `command` 값을 실제 출력값으로 바꾼다.

## 3. config.toml 맨 아래에 추가할 블록

기존 내용은 건드리지 말고 파일 맨 아래에 다음 블록만 추가한다.

```toml
[mcp_servers.serena]
enabled = false
startup_timeout_sec = 120
command = 'C:\Users\user\.local\bin\serena.exe'
args = ['start-mcp-server', '--context=codex', '--project', 'C:\Users\user\Documents\GitHub\urban-legend']
```

주의:

- 기존 `[mcp_servers.node_repl]` 블록을 수정하지 않는다.
- 기존 `[mcp_servers.agentmemory]` 블록을 수정하지 않는다.
- 기존 `[features]` 블록을 삭제하지 않는다.
- `notify`, `plugins`, `marketplaces`, `desktop`, `projects`, `windows`, `apps` 설정을 수정하지 않는다.

## 4. 필요할 때만 활성화

Codex 데스크톱 앱에서는 `Settings → MCP servers`에서 Serena를 활성화한 뒤 앱을 재시작한다. 작업이 끝나면 같은 화면에서 비활성화하고 다시 시작한다.

CLI에서 한 세션에만 활성화할 때는 다음처럼 실행한다.

```powershell
codex --config mcp_servers.serena.enabled=true
```

## 5. 저장 후 Codex 재시작

설정 파일을 저장한 뒤 Codex 앱을 완전히 종료하고 다시 실행한다.

Codex에서 확인:

```text
/mcp
```

기본 상태에서는 `serena`가 비활성화로 표시되어야 한다. 활성화한 작업에서는 연결된 서버로 표시되는지 확인한다.

## 6. Codex 첫 메시지 권장문

Serena를 활성화한 코드 탐색 세션에서만 다음 문장을 먼저 보낸다.

```text
Serena를 사용할 수 있으면 현재 프로젝트를 활성화하고 initial instructions를 읽어줘.
그다음 AGENTS.md, docs/AI_WORKFLOW_RULES.md, README.md, 현재 Issue 본문을 확인한 뒤 작업 범위를 정리해줘.
```

## 7. 실패 시 확인할 것

### serena 명령을 찾을 수 없음

`command` 값을 `serena`가 아니라 전체 경로로 둔다.

예시:

```toml
command = 'C:\Users\user\.local\bin\serena.exe'
```

### 프로젝트를 못 찾음

`--project` 뒤 경로가 실제 GitHub 저장소 경로와 같은지 확인한다.

예시:

```toml
args = ['start-mcp-server', '--context=codex', '--project', 'C:\Users\user\Documents\GitHub\urban-legend']
```

### GDScript 심볼 분석이 약함

Godot 에디터에서 프로젝트를 열어둔다.

확인 위치:

```text
Editor → Editor Settings → Network → Language Server
```

권장:

```text
Use Language Server = On
Port = 6008
```
