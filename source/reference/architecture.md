# 系统架构

```text
Windows
┌──────────────────────────────────────┐
│ Tang.exe / gui.py                    │
│  ├─ 选择结构与参数                   │
│  ├─ 生成任务输入与 task.json         │
│  └─ 选择 Windows 结果目录            │
└──────────────────┬───────────────────┘
                   │ wsl.exe + wslpath
WSL2               ▼
┌──────────────────────────────────────┐
│ /opt/tangqc/dispatch_task.py         │
│  ├─ 校验任务清单                     │
│  ├─ 建立 /var/lib/tangqc/jobs/<id>   │
│  ├─ 选择计算环境与程序               │
│  └─ 回收日志和结果                   │
└──────┬─────────┬──────────┬──────────┘
       │         │          │
  mokit_env   ZZQ/SRDSE  pygamd_env
```

## 为什么采用双层结构

Tkinter GUI 在 Windows 原生 Python 中运行，文件选择和窗口显示更稳定；科学程序保留在 Linux rootfs 内，避免逐个移植。两层之间只交换任务清单、输入文件、日志和结果。

## 任务目录

每次提交建立：

```text
/var/lib/tangqc/jobs/<job_id>/work/
```

MOKIT、PySCF 和 PYGAMD 直接在独立目录执行。ZZQ 和 SRDSE 因为依赖固定目录，采用互斥锁暂存输入并回收本次变化的结果文件。
