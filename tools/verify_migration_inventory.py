#!/usr/bin/env python3
"""Report whether every baseline Urban Legend payload remains present after moves."""
from __future__ import annotations
import argparse,hashlib,json,os,subprocess
from pathlib import Path
TEXT={'.md','.txt','.json','.yml','.yaml','.gd','.tscn','.tres','.cfg','.html','.ps1','.py','.import','.uid','.godot',''}
UPDATED_BY_CONTRACT={
 '.github/pull_request_template.md',
 'tests/test_account_handoff_contract.ps1',
 'tests/test_dialogue_workflow_contract.ps1',
 'tests/test_multimodel_workflow_contract.ps1',
 'tests/test_workflow_context.ps1',
}
SKIPPED_PARTS={'.git','node_modules','__pycache__','.godot','.import'}
def d(data,suffix): return hashlib.sha256(data.replace(b'\r\n',b'\n') if suffix in TEXT else data).hexdigest()
def main():
 p=argparse.ArgumentParser();p.add_argument('--before',required=True);p.add_argument('--after',required=True);p.add_argument('--source-ref',default='dd3c9a8776eb938eeeeb2f1319af6bfc4a135202');a=p.parse_args();root=Path.cwd();before=json.loads(Path(a.before).read_text(encoding='utf8'))['files']; hashes={}
 for directory, names, files in os.walk(root):
  names[:]=[name for name in names if name not in SKIPPED_PARTS]
  for name in files:
   f=Path(directory,name)
   hashes.setdefault(d(f.read_bytes(),f.suffix.lower()),[]).append(f.relative_to(root).as_posix())
 tree=subprocess.run(['git','ls-tree','-r',a.source_ref],capture_output=True,text=True,check=True).stdout
 blobs={line.split('\t',1)[1]:line.split()[2] for line in tree.splitlines() if '\t' in line}
 rows=[]
 for x in before:
  if x['git_state']=='TRACKED': raw=subprocess.run(['git','cat-file','-p',blobs[x['path']]],capture_output=True,check=True).stdout; expected=d(raw,x['suffix'])
  else: expected=x['sha256']
  found=hashes.get(expected,[])
  if found:
   state='PRESERVED'
  elif x['disposition']=='[제거]':
   state='REMOVED_BY_CONTRACT'
  elif x['path']=='.gitignore' or x['path'] in UPDATED_BY_CONTRACT:
   state='UPDATED_BY_CONTRACT'
  elif x['path']=='.superpowers/brainstorm/1995-1783902369/state/server.pid':
   state='REMOVED_BY_CONTRACT'
  else:
   state='MISSING'
  rows.append({'source_path':x['path'],'git_state':x['git_state'],'disposition':x['disposition'],'preserved_paths':found,'state':state})
 missing=[r for r in rows if r['state']=='MISSING']; Path(a.after).write_text(json.dumps({'baseline_files':len(rows),'missing':missing,'rows':rows},ensure_ascii=False,indent=2)+'\n',encoding='utf8');print(f'preserved={len(rows)-len(missing)} missing={len(missing)}');return bool(missing)
if __name__=='__main__':raise SystemExit(main())
