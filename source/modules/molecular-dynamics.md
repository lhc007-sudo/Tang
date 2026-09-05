# 分子动力学 · PYGAMD

PYGAMD v1 是一个以 Python/Numba 为接口、面向 GPU 加速的分子动力学（MD）引擎。计算由一个简洁的 Python 脚本组织：读取 MST 初始构型，建立 `application.dynamics`，加入势函数、积分器和输出对象，最后调用 `app.run(N)`。本模块适合 Lennard–Jones（LJ）、DPD 以及带键、角和二面角的粗粒化体系。

## 计算流程

一个最小的 PYGAMD 作业包含四步：

1. 准备 MST 格式的粒子、盒子和拓扑信息；
2. 读取快照并设置时间步长 `dt`；
3. 添加非键相互作用、温度控制和轨迹输出；
4. 运行指定步数并检查能量、温度和结构是否稳定。

```{note}
脚本和 MST 文件应放在同一个作业目录中，并使用相对文件名。这样作业可以在本地、WSL 或集群之间迁移，而不依赖某台机器的绝对路径。
```

## 约化单位

PYGAMD 通常使用 Lennard–Jones 约化单位。选定长度 σ、能量 ε 和质量 m 后，有

$$T^* = \frac{k_\mathrm{B}T}{\epsilon},\qquad \tau = \sqrt{\frac{m\sigma^2}{\epsilon}},\qquad P^* = \frac{P\sigma^3}{\epsilon}.$$

因此脚本中的 `temperature=1.0` 表示 kBT=ε，`dt=0.005` 表示每一步为 0.005τ。若要映射到物理单位，可令 σ 用 nm、ε 用 kJ/mol、m 用 amu，此时 τ 的单位为 ps；必须同时换算温度、时间步长和势参数，不能只替换坐标数值。

## MST 初始构型

MST 是 PYGAMD 的文本快照格式。最重要的字段如下：

| 字段 | 作用 | 备注 |
|---|---|---|
| `mst_version` | 文件版本 | 通常为 `1.0` |
| `num_particles` | 粒子数 | 必须与后续数据行一致 |
| `timestep` | 初始步数 | 新作业通常为 `0` |
| `dimension` | 维数 | 三维体系设为 `3` |
| `box` | 周期盒长度 | 例如 `10 10 10` |
| `position` | 粒子坐标 | 每行三个坐标 |
| `velocity` | 初速度 | 可设为零，但正式 NVT 作业建议给定合理初速度 |
| `type` | 粒子类型 | 用于匹配势参数 |
| `mass` | 粒子质量 | 影响积分和温度 |
| `bond/angle/dihedral` | 拓扑 | 仅在体系含有相应内部相互作用时提供 |
| `mst_end` | 文件结束标记 | 不应省略 |

一个四粒子 LJ 快照可以写成：

```text
mst_version 1.0
    num_particles
        4
    timestep
        0
    dimension
        3
    box
        10.0 10.0 10.0
    position
        0.0 0.0 0.0
        1.5 0.0 0.0
        0.0 1.5 0.0
        0.0 0.0 1.5
    velocity
        0.0 0.0 0.0
        0.0 0.0 0.0
        0.0 0.0 0.0
        0.0 0.0 0.0
    type
        A
        A
        A
        A
    mass
        1.0
        1.0
        1.0
        1.0
mst_end
```

## 重要参数

| 参数 | 含义 | 选择建议 |
|---|---|---|
| `dt` | 积分时间步长 | LJ 体系可从 `0.001–0.005` 试起；键振动较快时应减小 |
| `N` | 运行步数 | 总模拟时间为 N×dt；应分为平衡段和生产段 |
| `rcut` | 全局截断半径 | LJ 常用 `2.5–3.0`；必须小于盒长的一半 |
| `epsilon` | 势阱深度 | 控制能量尺度 |
| `sigma` | 碰撞直径 | 控制长度尺度 |
| `alpha` | LJ 吸引项系数 | 标准 LJ 取 `1.0` |
| `group` | 积分或输出的粒子组 | 全体系使用 `'all'`，按类型输出可用类型列表 |
| `method`、`tau`、`temperature` | NVT 控温方法、耦合时间和目标温度 | Nose–Hoover 例：`method="nh"`、`tau=1.0` |
| `period` | 输出间隔 | 太小会产生大量文件，太大则不利于诊断 |
| `sort` | 邻居表前的粒子排序 | 默认开启；大体系通常有利于性能 |
| `--gpu` | GPU 编号 | 例如 `--gpu=0`；多卡作业按调度器分配 |

## 示例：LJ 体系的 NVT 计算

下面脚本与上面的 `lj.mst` 放在同一目录。`force.nonbonded` 的 `func='lj'` 表示 Lennard–Jones 势；参数列表依次为 ε、σ、α、rcut。NVT 接口使用 Nose–Hoover 方法，轨迹以 MST 格式周期性写出。

```python
import pygamd

mst = pygamd.snapshot.read("lj.mst")
app = pygamd.application.dynamics(info=mst, dt=0.005)

lj = pygamd.force.nonbonded(info=mst, rcut=2.5, func="lj")
lj.setParams(type_i="A", type_j="A", param=[1.0, 1.0, 1.0, 2.5])
app.add(lj)

nvt = pygamd.integration.nvt(
    info=mst, group="all", method="nh", tau=1.0, temperature=1.0
)
app.add(nvt)

traj = pygamd.dump.mst(info=mst, group="all", file="lj_traj.mst", period=100)
app.add(traj)

app.run(10000)
```

运行时将 GPU 编号作为命令行参数传给脚本，并把屏幕输出保存到日志：

```bash
python3 run_lj.py --gpu=0 > lj.log 2>&1
```

示例仅用于验证输入、势函数和输出链路。四个粒子不足以代表热力学极限；实际研究应增加粒子数，先用较短的平衡段，再延长生产段并计算平均性质。

## 输出与结果检查

- `lj.log`：确认 MST 读取成功、势参数已设置、计算没有出现 NaN 或 CUDA 错误。
- 温度和总能量：平衡后应围绕目标值波动；持续漂移通常说明 `dt` 过大、截断设置不当或体系尚未平衡。
- `lj_traj.mst`：检查周期边界下的结构、密度和径向分布函数；不要把跨盒边界的直接坐标跳变误判为粒子飞散。
- 收敛性：至少改变 `dt`、`rcut`、粒子数和输出间隔做敏感性测试，并报告平均值及统计误差。

## 常见问题

```{warning}
如果 `rcut` 大于盒长最短边的一半，最小镜像约定会失效；如果 `dt` 太大，LJ 排斥壁会导致能量爆炸。遇到温度异常时，先减小 `dt`、检查质量和初速度，再检查势参数和盒子尺寸。
```

- **类型未匹配**：`setParams` 中的 `type_i/type_j` 必须与 MST 的 `type` 字段完全一致（包括大小写）。
- **初速度不合理**：全零速度可以启动计算，但达到目标温度需要一段平衡时间；给定速度时应去除整体平动，并检查温度定义。
- **拓扑缺失**：聚合物或分子体系必须在 MST 中提供 `bond`、`angle`、`dihedral`，并在脚本中加入相应的力对象。
- **输出过密**：`period` 太小会显著增加 I/O；生产计算通常使用比诊断计算更大的输出间隔。

## 参考文献与文档

1. Zhu, Y.-L.; Lu, Z.-Y. *PYGAMD v1 documentation*. [项目主页](https://github.com/youliangzhu/pygamd-v1)；[使用说明](https://pygamd-v1.readthedocs.io/en/latest/usage.html)。
2. Verlet, L. Computer “Experiments” on Classical Fluids. I. Thermodynamical Properties of Lennard–Jones Molecules. *Phys. Rev.* **159**, 98–103 (1967). DOI: [10.1103/PhysRev.159.98](https://doi.org/10.1103/PhysRev.159.98)。
3. Allen, M. P.; Tildesley, D. J. *Computer Simulation of Liquids*, 2nd ed.; Oxford University Press, 2017。
4. Groot, R. D.; Warren, P. B. Dissipative particle dynamics: Bridging the gap between atomistic and mesoscopic simulation. *J. Chem. Phys.* **107**, 4423 (1997). DOI: [10.1063/1.474784](https://doi.org/10.1063/1.474784)。
