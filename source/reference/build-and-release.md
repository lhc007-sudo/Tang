# 构建与发布文档

## 本地生成

在网站项目根目录执行：

```powershell
py -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m sphinx -b html docs docs\_build\html
Start-Process .\docs\_build\html\index.html
```

也可以直接双击 `preview.bat`。

## 发布到 Read the Docs

1. 在 GitHub 新建仓库；
2. 把网站目录全部提交并推送；
3. 登录 Read the Docs，选择 **Import a Project**；
4. 连接并选择该仓库；
5. 构建配置会自动读取 `.readthedocs.yaml`。

完成后，每次推送到 GitHub 都可以自动重新构建网站。

## 发布到 GitHub Pages

项目已包含 `.github/workflows/docs.yml`。在 GitHub 仓库的 **Settings → Pages** 中把 Source 设为 **GitHub Actions**，然后推送到 `main` 分支。

## 文档维护

- 页面正文：`docs/**/*.md`；
- 左侧目录：`docs/index.rst` 中的 `toctree`；
- 网站标题和主题：`docs/conf.py`；
- 颜色与版式：`docs/_static/custom.css`；
- Logo：`docs/_static/logo.png` 与 `favicon.ico`。
