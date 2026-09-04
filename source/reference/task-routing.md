# 任务识别与路由

GUI 会生成 UTF-8 编码的 `task.json`。一个简化示例如下：

```json
{
  "job_id": "job_20260904_103000_12345",
  "category": "molecular_dynamics",
  "engine": "pygamd",
  "entry_file": "simulation.py",
  "input_dir": "/mnt/d/Tang/workspace/submissions/job_x/input",
  "output_dir": "/mnt/d/Tang/results/job_x"
}
```

## 路由表

| category | engine | 入口 | 执行程序 |
|---|---|---|---|
| `electronic_structure` | `mokit` / `pyscf` / `suhf` | `.py` | `/opt/mokit_env/bin/python3` |
| `electronic_structure` | `zzq` | `.inp` | `/app/zzq_qc_yby/zzq_qc` |
| `electronic_structure` | `srdse` | `input` | `/app/srdse/examples/srdse` |
| `molecular_dynamics` | `pygamd` | `.py` | `/usr/local/bin/pygamd-python` |
| `nuclear_motion` | — | — | 尚未启用 |

同为 `.py` 的 MOKIT 和 PYGAMD 不能只靠扩展名区分，因此必须由 GUI 写入 `category` 和 `engine`。

## 手动自检

```powershell
wsl -d TangQC -u root -- /opt/tangqc/dispatch_task.py --self-check
```
