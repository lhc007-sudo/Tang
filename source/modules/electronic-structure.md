# 电子结构理论

电子结构理论以量子力学为基础，研究分子中电子的波函数、电子密度、能量及其随分子构型变化的规律。它既可以用于计算稳定结构和电子态，也可以用于分析化学键、反应路径与电子相关效应，并为材料设计和实验解释提供微观依据。

TANG 将常用电子结构任务集中到统一的 Windows 图形界面中。用户只需选择结构文件并设置方法、基组、电荷、自旋等参数，平台便会生成对应的输入文件，将任务交给 WSL2 后端执行，并把日志与结果文件返回到 Windows 指定目录。

## 功能概览

| 功能 | 主要用途 | 
| --- | --- | 
| RHF / UHF | 单参考平均场计算 |
| SUHF 及扩展方法 | 处理自旋对称性破缺与静态相关 |
| NEB | 搜索反应物和产物之间的最小能量路径 |
| POM / SRDSE | 生成和计算多金属氧酸盐相关模型 |

目前电子结构模块主要支持：

- 上传或选择 `.xyz` 分子结构；
- 设置基组、电荷、自旋或自旋多重度；
- 选择 RHF、UHF、SUHF 及其扩展方法；
- 配置 NEB 的反应物、产物、镜像数和计算方法；
- 配置 POM / SRDSE 专用参数；
- 自动生成计算输入文件；
- 自动选择相应的 Linux 环境和计算程序；
- 保存运行日志并将结果导出到 Windows 文件夹。

## 通用计算流程

1. 在 TANG 主界面进入“电子结构理论”模块。
2. 选择所需的计算类型。
3. 上传结构文件，或在专用界面中设置任务参数。
4. 选择 Windows 结果保存位置。
5. 点击“开始计算”。
6. 平台生成输入文件并提交到 WSL2 后端。
7. 计算结束后，在结果目录中查看 `run_log.txt` 以及生成的 `.out`、`.dat`、`.bmo`、`.xyz` 或 `.log` 文件。


## RHF 计算

RHF（Restricted Hartree–Fock，限制性 Hartree–Fock）是一种自洽场方法。在闭壳层体系中，每个空间轨道由一对自旋相反的电子占据。RHF 计算成本较低，常作为后续相关计算的参考波函数，但它通常不适合显著开壳层或强静态相关体系 [1,2]。

### RHF 界面设置示例

以基态 H₂ 为例，可在界面中设置：

| 参数 | 示例值 |
| --- | --- |
| 结构文件 | `H2.xyz` |
| 方法 | `RHF` |
| 基组 | `sto-3g` |
| 电荷 | `0` |
| 自旋多重度 | `1` |

`H2.xyz` 的内容为：

```text
2
H2 molecule
H  0.00000000  0.00000000  0.00000000
H  0.00000000  0.00000000  0.74000000
```

### RHF 输入文件

TANG 将上述设置转换为 ZZQ 计算程序所需的 `.inp` 文件：

```text
rhf sto-3g
2 0 1
H  0.00000000  0.00000000  0.00000000
H  0.00000000  0.00000000  0.74000000
```

各行含义如下：

- 第一行：计算方法和基组；
- 第二行：原子数、电荷和自旋多重度；
- 后续各行：元素符号及其笛卡尔坐标，坐标单位为 Å。

点击“开始计算”后，并自动回收输出文件。

## SUHF 计算

SUHF（Spin-projected Unrestricted Hartree–Fock，自旋投影非限制性 Hartree–Fock）先优化一个允许自旋对称性破缺的 UHF 行列式 $|\Phi_0\rangle$，再通过自旋投影算符 $\hat{P}$ 恢复目标总自旋。该方法能够以接近平均场方法的成本描述部分静态相关，适用于键解离、双自由基及其他多参考特征明显的体系 [3–9]。

TANG 还可按后端实际支持情况提供 TDSUHF、SUHF-DFT 和 SUHF-EMP2 等扩展方法。

### SUHF 界面设置示例

以三重态 O₂ 为例：

| 参数 | 示例值 |
| --- | --- |
| 结构文件 | `O2.xyz` |
| 方法 | `SUHF` |
| 基组 | `sto-3g` |
| 电荷 | `0` |
| 自旋多重度 | `3` |
| PySCF `spin` | `2` |
| 最大内存 | `20000 MB` |
| CPU 线程数 | `1` |

`O2.xyz` 的内容为：

```text
2
Triplet O2
O  -4.71337596  0.92356687  0.00000000
O  -5.87497596  0.92356687  0.00000000
```

### SUHF 输入文件

SUHF 任务生成可直接执行的 Python 脚本，例如 `suhf_job.py`：

```python
import time

from pyphf import guess, suscf
from pyscf import gto, lib

lib.num_threads(1)

xyz = """
O  -4.71337596  0.92356687  0.00000000
O  -5.87497596  0.92356687  0.00000000
"""

basis = "sto-3g"
charge = 0
spin = 2
max_memory = 20000

mol = gto.M(
    atom=xyz,
    basis=basis,
    charge=charge,
    spin=spin,
    unit="Angstrom",
    verbose=4,
    max_memory=max_memory,
)

mf = guess.gen(xyz, basis, charge=charge, spin=spin, conv="tight")
mf.max_memory = max_memory

start = time.perf_counter()
suhf = suscf.SUHF(mf)
suhf.max_memory = max_memory
suhf.kernel()

print(f"SUHF completed in {time.perf_counter() - start:.2f} s")
```


## NEB 计算

NEB（Nudged Elastic Band，弹性带方法）用于寻找反应物与产物之间的最小能量路径，并估计过渡区域。一个完整任务至少需要原子顺序一致的反应物和产物结构，同时需要设置中间镜像数、电子结构方法、基组、电荷和自旋等参数 [8]。

### NEB 界面设置示例

以 HCN → HNC 的示意性异构化路径为例：

| 参数 | 示例值 |
| --- | --- |
| 反应物结构 | `reactant.xyz` |
| 产物结构 | `product.xyz` |
| 镜像数 | `8` |
| 方法 | `RHF` |
| 基组 | `sto-3g` |
| 电荷 | `0` |
| 自旋多重度 | `1` |
| 最大优化循环数 | `150` |
| 梯度收敛阈值 | `4.5e-4` |
| 能量收敛阈值 | `1.0e-6` |

```{warning}
反应物与产物文件必须含有相同数量的原子，而且原子排列顺序必须一一对应。下面坐标仅用于说明输入格式，不代表经过优化的可靠反应路径。
```

`reactant.xyz`：

```text
3
HCN reactant
H  0.000000  0.000000  0.000000
C  1.060000  0.000000  0.000000
N  2.220000  0.000000  0.000000
```

`product.xyz`：

```text
3
HNC product (same atom order: H C N)
H  0.000000  0.000000  0.000000
C  2.170000  0.000000  0.000000
N  1.000000  0.000000  0.000000
```

### NEB 输入文件

NEB 页面生成一个 Python 入口脚本，并将两份 `.xyz` 结构作为附加输入一并提交。入口脚本的结构例如：

```python
from ash import DLFIND_optimizer, Fragment, PySCFTheory

charge = 0
multiplicity = 1

reactant = Fragment(
    xyzfile="reactant.xyz",
    charge=charge,
    mult=multiplicity,
)
product = Fragment(
    xyzfile="product.xyz",
    charge=charge,
    mult=multiplicity,
)

theory = PySCFTheory(
    scf_type="RHF",
    basis="sto-3g",
    conv_tol=1.0e-9,
    scf_maxiter=100,
    printsetting=False,
    printlevel=0,
)

DLFIND_optimizer(
    theory=theory,
    fragment=reactant,
    fragment2=product,
    charge=charge,
    mult=multiplicity,
    jobtype="neb",
    maxcycle=150,
    nimage=8,
    tolerance=4.5e-4,
    tolerance_e=1.0e-6,
    printlevel=2,
)
```

```{note}
该脚本直接调用 ASH 的 `Fragment`、`PySCFTheory` 和 `DLFIND_optimizer`，不需要 `tang_neb.py`，也不需要自行编写 ASE 计算器。这里展示的是 RHF：应设置 `scf_type="RHF"`，并省略 `functional`。若执行闭壳层 DFT，可改为 `scf_type="RKS"` 并设置实际泛函，例如 `functional="PBE0"`。ASH 的 `mult` 表示自旋多重度 $2S+1$；它不同于 PySCF 原生接口中的 `spin=2S`。
```

后端使用包含 ASH、PySCF 和 DL-FIND 的计算环境执行入口脚本，并将运行日志以及 ASH/DL-FIND 生成的路径、能量和结构文件返回 Windows 结果目录。

## POM / SRDSE 计算

POM 模块面向多金属氧酸盐相关结构的生成与计算。与 RHF、SUHF 和 NEB 不同，SRDSE 使用固定名称 `input` 作为入口文件，并在固定目录 `/app/srdse/examples/` 中运行。

### POM 界面设置示例

不同版本的 SRDSE 可能提供不同的专用参数。下面以一个示意任务说明输入组织方式：

| 参数 | 示例值 |
| --- | --- |
| 任务名称 | `pom_demo` |
| 体系类型 | `POM` |
| 金属元素 | `W` |
| 杂原子 | `P` |
| 对称性 | `Td` |
| 电荷 | `-3` |
| 输出前缀 | `pom_demo` |

### POM 输入文件

TANG 根据 POM 专用界面的参数生成一个没有扩展名、文件名严格为 `input` 的文本文件：

```text
task_name = pom_demo
system_type = POM
metal = W
heteroatom = P
symmetry = Td
charge = -3
output_prefix = pom_demo
```

点击“开始计算”后，调度器执行以下逻辑：

1. 将 Windows 生成的 `input` 文件复制到 `/app/srdse/examples/input`；
2. 在 `/app/srdse/examples/` 中运行 `srdse`；
3. 将标准输出和错误信息写入 `run_log.txt`；
4. 回收 `.out`、`.dat`、`.xyz` 和 `.log` 等结果文件；
5. 删除工作目录中的临时 `input` 文件，避免影响下一次任务。


## 参考文献

1. Levine, I. N. *Quantum Chemistry*, 7th ed.; Pearson: Boston, 2014. ISBN 978-0-321-80345-0.
2. Szabo, A.; Ostlund, N. S. *Modern Quantum Chemistry: Introduction to Advanced Electronic Structure Theory*; Dover Publications: Mineola, NY, 1996. ISBN 978-0-486-69186-2.
3. Jiménez-Hoyos, C. A.; Henderson, T. M.; Tsuchimochi, T.; Scuseria, G. E. Projected Hartree–Fock Theory. *J. Chem. Phys.* **2012**, *136*, 164109. <https://doi.org/10.1063/1.4705280>
4. Lestrange, P. J.; Williams-Young, D. B.; Petrone, A.; Jiménez-Hoyos, C. A.; Li, X. Efficient Implementation of Variation after Projection Generalized Hartree–Fock. *J. Chem. Theory Comput.* **2018**, *14*, 588–596. <https://doi.org/10.1021/acs.jctc.7b00925>
5. Ghassemi Tabrizi, S.; Arbuznikov, A. V.; Jiménez-Hoyos, C. A.; Kaupp, M. Hyperfine-Coupling Tensors from Projected Hartree–Fock Theory. *J. Chem. Theory Comput.* **2020**, *16*, 6222–6235. <https://doi.org/10.1021/acs.jctc.0c00531>
6. Wang, S.; Xu, X. Pair-Density Functional Theory Based on the Spin-Projected Unrestricted Hartree–Fock Method. *J. Chem. Theory Comput.* **2025**, *21*, 5965–5972.
7. Wang, S.; Xu, X. Pair-Density Functional Theory Based on Spin-Projected Unrestricted Hartree–Fock Method: A Density-Corrected Version. *J. Comput. Chem.* **2026**, *47*, e70398.
8. Henkelman, G.; Uberuaga, B. P.; Jónsson, H. A Climbing Image Nudged Elastic Band Method for Finding Saddle Points and Minimum Energy Paths. *J. Chem. Phys.* **2000**, *113*, 9901–9904. <https://doi.org/10.1063/1.1329672>
9. Wang, S., https://github.com/jeanwsr/ExSCF.