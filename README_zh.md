# Ag2Se NEP 训练示例与最终势函数

> **发布候选状态：** 科学文件与哈希已在本地验证；目标仓库、可见性、作者/引用、许可和生产 GPUMD 精确构建仍需确认。

[English README](README.md)

本发布候选直接采用 GPUMD 官方 [`examples/nep_train`](https://github.com/brucefan1983/GPUMD/tree/master/examples/nep_train) 的单文件夹思路，把训练数据、最终势、续训状态、损失和全部训练输出放入 `nep_train/`：

```text
nep_train/
├── energy_train.out
├── force_train.out
├── loss.out
├── nep.in
├── nep.restart
├── nep.txt
├── plot_results.py
├── stress_train.out
├── train.xyz
└── virial_train.out
```

官方 PbTe 示例使用 `plot_results.m`。这里保留项目实际使用的 Python 绘图脚本并命名为 `plot_results.py`，因为它会按 Ag2Se 数据动态设置坐标范围并绘制 stress；若直接复制官方 MATLAB 脚本，其中固定的 PbTe 能量和力范围并不适合本数据。

## 数据和模型事实

- `train.xyz` 含 1,720 条标注记录、296,739 个原子实例；Ag 197,823，Se 98,916。
- 每帧均有晶格、周期边界、总能、原子力和 9 分量 virial；extxyz 训练模式验证通过。
- 共有 1,718 条精确唯一记录；同一 168 原子界面记录在第 796、830、898 帧出现三次。为复现真实训练，未做事后去重。
- 最终数据由 `train-cubic.xyz`、`train-low.xyz`、`train-jm.xyz`、`train-old.xyz` 按此顺序字节级拼接；本包不重复放入四个分块。
- 训练日志记录 GPUMD 5.5、150,000 代正常完成；精确 tag/commit、源码修改状态、编译器/CUDA 和可执行文件哈希仍为 **[待补充]**。
- 训练集能量 MAE/RMSE 为 3.155/4.130 meV/atom，力为 44.175/59.346 meV/A，应力为 0.0606/0.0910 GPa。

**目录中没有独立 `test.xyz`；以上指标和 parity 图只是训练集诊断，不是模型泛化精度。**

关联 V10 主文/SI 记录的训练标签设置为 VASP、PAW、PBEsol、450 eV、`EDIFF=1e-6 eV`、`ISMEAR=0`、`SIGMA=0.05 eV`、`KSPACING=0.2 A^-1`，并记录 `PREC=Normal`、`LREAL=Auto`、`LASPH=.TRUE.`、`ADDGRID=.TRUE.`。原始训练单点输入尚未随包提供，因此这些目前属于稿件元数据，不是仓库内逐任务原始输入核验结果。VASP PAW 授权文件不再分发。

## 使用

在 `nep_train/` 内运行已经核验的、支持 NEP 的 GPUMD 可执行文件，例如 `path/to/nep`。因为目录包含 `nep.restart`，再次训练前要先备份现有结果，避免覆盖最终模型和输出。

安装 NumPy 和 Matplotlib 后，可重画训练汇总：

```text
python plot_results.py save
```

用于 GPUMD 时，把 `nep.txt` 复制到干净的模拟目录，并在 `run.in` 中写：

```text
potential nep.txt
```

所有下游结构必须保持元素顺序 `Ag Se`。能加载势函数不等于通过科学验证；新的相、温度、缺陷、界面和输运条件仍要做短时稳定性及目标物理量验证。

## 完整性、引用和许可

用 `SHA256SUMS.txt` 校验全部文件。`.gitattributes` 已禁止 Git 对归档科学文件执行行尾归一化；这对历史上混合行尾的 `train.xyz` 尤其必要，可以保证跨平台重新 clone 后仍保持记录的字节内容。核心 SHA-256：

- `nep_train/train.xyz`: `FB9B3AE6C4352EDEF07AAF2E26B072617C736E2B21BB16460521CFEA4511896C`
- `nep_train/nep.in`: `35ED458D7C77A4B61EDCB619A9F9F8B3F974F1081B1F586DEF974EB117EF2CA6`
- `nep_train/nep.txt`: `92E43F46A96D048075BCA60C61CA4886ED523EC65A31CB8680446ECEAF38B26F`

作者、论文/DOI、推荐引用和许可均为 **[待补充]**。仓库公开本身不能替代明确许可。
