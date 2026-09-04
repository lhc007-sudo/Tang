# 故障排查

## 找不到发行版

运行：

```powershell
wsl -l -v
```

把 GUI 顶部“计算环境”改为列表中的准确名称。`Ubuntu`、`Ubuntu-22.04` 和 `TangQC` 是不同的发行版。

## WSL 启动超时

```powershell
wsl --shutdown
wsl --update
```

重启 Windows 后再试。如果仍然出现 `HCS_E_CONNECTION_TIMEOUT`，检查虚拟化是否启用、WSL 服务状态和系统更新。

## PYGAMD 显示 CUDA 不可用

依次检查：

```powershell
wsl -d TangQC -u root -- ls -l /dev/dxg
wsl -d TangQC -u root -- ls -l /usr/lib/wsl/lib/libcuda.so.1
wsl -d TangQC -u root -- /usr/lib/wsl/lib/nvidia-smi
```

这些路径由 WSL 启动时注入。缺少它们通常不是 rootfs 打包问题，而是新电脑没有正确安装 WSL2 或支持 WSL 的 NVIDIA Windows 驱动。

## NVIDIA-SMI 可用但 PYGAMD 失败

```powershell
wsl -d TangQC -u root -- pygamd-python -c "from numba import cuda; print(cuda.is_available())"
```

若输出为 `False`，检查 `/usr/local/bin/pygamd-python` 是否设置：

```sh
LD_LIBRARY_PATH=/usr/lib/wsl/lib
NUMBA_CUDA_DRIVER=/usr/lib/wsl/lib/libcuda.so.1
```

## 计算失败

打开结果目录中的 `run.log` 和 `result.json`。先查看 `return_code`，再从日志末尾向上定位第一条明确错误。GUI 弹出的“计算失败”只是汇总提示，具体原因以日志为准。

## 中文乱码

网页源文件统一保存为 UTF-8。GUI 使用中文时，Windows 建议选择“Microsoft YaHei UI”；Linux GUI 需要安装 Noto CJK 字体。字体缺失与字符串被写成 `\\uXXXX` 文本是两类不同问题。
