# 安装与导入

## 系统要求

- Windows 10 22H2 或 Windows 11；
- 已启用 WSL2 和虚拟机平台；
- 电子结构计算可使用 CPU；
- PYGAMD 需要受 WSL 支持的 NVIDIA GPU 和较新的 Windows NVIDIA 驱动；
- 建议预留至少 15 GB 磁盘空间。

## 1. 安装 WSL2

以管理员身份打开 PowerShell：

```powershell
wsl --install
```

按提示重启 Windows，随后检查：

```powershell
wsl --status
wsl -l -v
```

## 2. 导入 Tang 后端

下面以发行版名称 `TangQC`、安装目录 `D:\TangQC\Backend` 为例：

```powershell
New-Item -ItemType Directory -Force D:\TangQC\Backend
wsl --import TangQC `
  D:\TangQC\Backend `
  D:\TangQC\TangQC-rootfs-pygamd-1.4.8.tar `
  --version 2
```

发行版名称可以自定义，但必须与 Tang GUI 顶部的“计算环境”一致。安装目录放在哪个磁盘不会改变发行版名称。

## 3. 检查后端

```powershell
wsl -d TangQC -u root -- /opt/tangqc/dispatch_task.py --self-check
```

查看 WSL 是否识别 GPU：

```powershell
wsl -d TangQC -u root -- /usr/lib/wsl/lib/nvidia-smi
```

`/dev/dxg` 和 `/usr/lib/wsl/lib` 由 WSL 在发行版启动时根据 Windows 主机动态提供，不需要把 Windows 显卡驱动打进 rootfs。

## 4. 启动 Windows 客户端

如果收到的是 `Tang.exe`，直接双击即可。首次打开后把“计算环境”设置为导入时使用的名称，例如 `TangQC`，然后点击“检查环境”。

```{note}
没有 NVIDIA GPU 的电脑仍可运行不依赖 CUDA 的电子结构任务，但不能运行当前的 PYGAMD GPU 任务。
```
