# TANG（唐）— 智能科学计算平台

**TANG（唐）** — Theory of AI<sup>+</sup> Electronic Structure, Nuclear Motion, and Giant Macromolecules

TANG 是一款面向计算化学与分子模拟的一体化智能科学计算平台，以 Windows 为统一交互入口，依托便携式 WSL 科学计算环境，实现电子结构与分子动力学计算引擎的智能调度、任务执行及结果回传。通过简洁直观的操作界面与跨环境无缝协同，让复杂的科学计算更加高效、便捷。

```{image} _static/hero-science.svg
:alt: TANG(唐)分子科学计算平台示意图，包含电子轨道、原子核振动和分子动力学元素
:class: tang-hero-image
:align: center
```

## 计算模块

<div class="module-grid">
  <a class="module-card blue" href="modules/electronic-structure.html">
    <img src="_static/1-1.png" alt="电子结构理论图标">
    <strong>JiFT-CHEM</strong>
    <span>AI<sup>+</sup>量子化学</span>
	<span>多酸/分子筛</span>
	<span>激发态/光化学</span>
    <small>Support · 曲泽星 · 苏忠民 · 徐昕</small>
  </a>
  <a class="module-card violet" href="modules/nuclear-motion.html">
    <img src="_static/1-2.png" alt="核运动理论图标">
    <strong>JLN-CHEM</strong>
    <span>全量子高分辨光谱</span>
    <small>Support · 李辉</small>
  </a>
  <a class="module-card green" href="modules/molecular-dynamics.html">
    <img src="_static/1-3.png" alt="分子动力学图标">
    <strong>PYGAMD</strong>
    <span>分子动力学模拟</span>
	<span>超分子自组装</span>
    <small>Support · 朱有亮 · 吕中元</small>
  </a>
</div>

## 从这里开始

- 第一次使用请先阅读[安装指南](guide/installation.md)。
- 已经安装完成，可以直接查看[快速开始](guide/quick-start.md)。
- 遇到问题时，请查看[故障排查](reference/troubleshooting.md)。

```{toctree}
:hidden:
:maxdepth: 2
:caption: 开始使用

guide/introduction
guide/installation
guide/quick-start
```

```{toctree}
:hidden:
:maxdepth: 2
:caption: 计算模块

modules/electronic-structure
modules/nuclear-motion
modules/molecular-dynamics
```

```{toctree}
:hidden:
:maxdepth: 2
:caption: 系统与维护

reference/architecture
reference/task-routing
reference/troubleshooting
reference/build-and-release
```

```{toctree}
:hidden:
:maxdepth: 1
:caption: 关于

about/support
about/cite
about/license
```
