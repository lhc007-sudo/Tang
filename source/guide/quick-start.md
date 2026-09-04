# 快速开始

## 第一次运行

1. 启动 `Tang.exe`。
2. 在顶部“计算环境”中填写 WSL 发行版名称，例如 `TangQC`。
3. 点击“检查环境”。
4. 选择一个计算模块。
5. 选择输入文件并设置参数。
6. 选择 Windows 结果保存位置。
7. 点击开始计算，并在界面底部查看实时日志。

## 查看结果

每次任务都会生成独立的任务编号。结果目录通常包括：

```text
run.log       计算过程的完整日志
result.json   任务类型、返回码和耗时
*.out         程序输出
*.dat         数据文件
其他文件      由具体计算程序生成
```

`result.json` 中的 `return_code` 为 `0` 表示程序正常结束；非零值应结合 `run.log` 判断原因。

## PowerShell 快速检查

```powershell
wsl -l -v
wsl -d TangQC -u root -- /opt/tangqc/dispatch_task.py --self-check
```
