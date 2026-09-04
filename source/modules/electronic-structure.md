# 电子结构理论

电子结构模块根据 GUI 选择的方法写入明确的 `engine` 字段，而不是仅凭扩展名猜测任务。所有任务由 WSL 调度器建立独立工作目录。

## SUHF / pyphf

- 输入：由 XYZ 结构和界面参数生成的 `.py` 脚本；
- 环境：`/opt/mokit_env/bin/python3`；
- Python 路径：`/app/ExSCF-dev` 与 `/app/pyAutoMR-master`。

界面应提供结构文件、基组、电荷、自旋以及 SUHF 方法选项。

## PySCF 与 NEB

- 输入：`.py`；
- 环境：`/opt/mokit_env/bin/python3`；
- NEB 界面应保留反应物、产物、镜像数、基组、电荷、自旋和计算方法等设置。

NEB 通常至少需要起点与终点结构。附加结构或参数文件会与入口脚本一并提交。

## ZZQ

- 输入：`.inp`；
- 程序：`/app/zzq_qc_yby/zzq_qc`；
- 运行库：`/app/zzq_qc_yby/my_libs`。

ZZQ 需要在固定程序目录中执行。调度器使用文件锁串行运行任务，完成后回收 `.out`、`.dat`、`.bmo` 和 `output.log`。

## POM / SRDSE

- 输入：文件名必须为 `input`；
- 程序：`/app/srdse/examples/srdse`；
- 界面应保留 POM 所需的专用参数，而不是只有通用文件选择框。

SRDSE 同样使用固定程序目录，调度器会在结束后回收 `.out`、`.dat`、`.xyz` 和 `.log`。

## 支持

徐昕 · 苏忠明 · 曲泽星
