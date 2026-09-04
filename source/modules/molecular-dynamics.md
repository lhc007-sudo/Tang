# 分子动力学 · PYGAMD

分子动力学模块运行 PYGAMD Python 脚本，并允许附加 XML、MST、数据表或其他脚本需要的文件。

## 执行环境

- 入口脚本：一个 `.py` 文件；
- 启动器：`/usr/local/bin/pygamd-python`；
- Python 环境：`/opt/pygamd_env`；
- CUDA 驱动入口：`/usr/lib/wsl/lib/libcuda.so.1`；
- WSL GPU 设备：`/dev/dxg`。

启动器会设置 Numba 所需的 CUDA 驱动路径，然后执行用户脚本。Windows NVIDIA 驱动由宿主机提供，rootfs 中只保存 Python 包和用户态运行环境。

## GPU 检查

```powershell
wsl -d TangQC -u root -- /usr/lib/wsl/lib/nvidia-smi
wsl -d TangQC -u root -- pygamd-python -c "from numba import cuda; print(cuda.is_available())"
```

第二条命令输出 `True` 才表示 Numba CUDA 可以使用。

## 提交任务

1. 在 GUI 中选择 PYGAMD 主脚本；
2. 添加脚本引用的数据或配置文件；
3. 选择结果目录；
4. 开始计算并观察日志。

脚本不应依赖 Windows 上的绝对路径。引用附加文件时，使用相对于脚本工作目录的文件名。

## 支持

朱有亮 · 吕中元
