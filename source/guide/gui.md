# Windows 图形界面

## 首页

首页包含电子结构理论、核运动理论和分子动力学三个入口。顶部“计算环境”不是安装路径，而是 `wsl -l -v` 显示的发行版名称。

## 输入与输出

GUI 不会把某台电脑的用户名、桌面路径或盘符固定写入后端。提交任务时，它会：

1. 在 Windows 工作区生成输入和 `task.json`；
2. 使用 `wslpath` 把 Windows 路径转换为 WSL 路径；
3. 调用 `/opt/tangqc/dispatch_task.py`；
4. 把结果复制到用户选择的 Windows 文件夹。

因此换电脑后通常只需要导入 WSL 后端、启动 GUI，并填写正确的发行版名称。

## 任务日志乱码

如果日志中出现异常字符，优先确认程序输出编码。GUI 与调度器应使用 UTF-8；Windows 子进程输出可按 UTF-8 解码并在失败时采用替代字符。中文界面字体建议使用“Microsoft YaHei UI”。

## 打包为 EXE

在 Windows 项目目录中运行：

```powershell
py -m pip install pyinstaller
py -m PyInstaller --noconfirm --clean --onefile --windowed `
  --name Tang --icon tang.ico --add-data "tang.ico;." gui.py
```

生成文件位于 `dist\Tang.exe`。
