# Tang 文档网站

这是 Tang 分子科学计算平台的 Sphinx 文档源文件，界面采用 Read the Docs 风格。

## 标准目录结构

```text
Website/
├─ source/          # 文档源文件、conf.py、图片和样式
├─ build/           # 生成的网站文件
├─ Makefile         # Linux/macOS 构建入口
├─ make.bat         # Windows 构建入口
├─ preview.bat      # Windows 一键构建并预览
└─ requirements.txt # 网站依赖
```

## 本地预览（独立虚拟环境）

网站使用项目目录中的 `sphinx_env`，不会修改 Conda 的 `base` 环境，也不会修改
Windows、WSL 或 Tang 后端中的 Python 解释器。

最简单的方法是在项目根目录双击 `preview.bat`。脚本会检查依赖、生成网页，
然后打开首页。如果依赖尚未安装，它会安装 `requirements.txt` 中的依赖。

也可以在 Windows PowerShell 中手动运行：

```powershell
cd D:\CODEX\Website
& ".\sphinx_env\Scripts\python.exe" -m pip install -r .\requirements.txt
.\make.bat html
Start-Process .\build\html\index.html
```

以后重新构建，只需运行 `.\make.bat html` 或双击 `preview.bat`，不需要执行
`conda activate`。在 Linux 或 macOS 中可运行 `make html`。

## 发布

- Read the Docs：把整个目录上传到 GitHub，然后在 Read the Docs 导入仓库。
- GitHub Pages：仓库中的工作流会自动构建并发布文档。

文档源文件位于 `source/`，修改 Markdown 后重新构建即可。
