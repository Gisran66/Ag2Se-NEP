# Ag2Se NEP 势函数与训练数据

[English README](README.md)

本仓库公开 Ag–Se 神经演化势（NEP）及其训练数据，采用 [GPUMD `examples/nep_train`](https://github.com/brucefan1983/GPUMD/tree/master/examples/nep_train) 的目录形式，供论文读者查看和下载。

**最终势函数：[`nep_train/nep.txt`](nep_train/nep.txt)。** 下载全部文件可点击 **Code → Download ZIP**，或克隆仓库。

## 文件结构

```text
nep_train/
├── energy_train.out
├── force_train.out
├── loss.out
├── nep.in
├── nep.restart
├── nep.txt
├── plot_results.m
├── stress_train.out
├── train.xyz
└── virial_train.out
```

`nep.txt` 为最终势函数，`nep.in` 为训练参数，`train.xyz` 为带标签的训练结构，`nep.restart` 为训练重启状态；各 `.out` 文件保存训练损失及 NEP 与参考值的比较。以上 9 个科学文件均与原始训练目录逐字节一致。`plot_results.m` 是为本归档新编写的绘图辅助文件，坐标范围随数据自动调整。

已有图片保留在 [`figures/`](figures)：[训练汇总图](figures/training_summary.png)和[训练拟合对比图](figures/training_parity.png)。

## 使用势函数

将 `nep_train/nep.txt` 复制到自己的 GPUMD 模拟目录，并在 `run.in` 中引用：

```text
potential nep.txt
```

模型为带 ZBL 的 NEP4，声明的元素顺序为 `Ag Se`。训练输入中的径向/角向截断半径为 6/4 Å，训练代数为 150,000。完整参数见 [`nep.in`](nep_train/nep.in)，模拟输入规则见 [GPUMD 文档](https://gpumd.org/)。对新结构或新工况的适用性需另行验证。

## 绘制训练结果

在 MATLAB 中将当前目录切换到 `nep_train`，运行：

```matlab
metrics = plot_results;
```

也可以保存图片：

```matlab
metrics = plot_results('training_results.png');
```

程序绘制能量、力、virial、应力和训练损失，并输出 MAE、RMSE、R²。指标使用全部有效分量；点数较多的比较图最多显示确定性抽样的 100,000 个点。不需要额外 MATLAB 工具箱。重新训练前请另建副本，以免覆盖归档中的势函数和训练结果。

## 训练归档说明

- 1,720 个带标签结构，共 296,739 个原子实例，其中 Ag 为 197,823，Se 为 98,916。
- 精确唯一结构为 1,718 个；其中一个结构出现三次，为保留实际训练集而未事后去重。
- 训练集 RMSE：能量 **4.130 meV/atom**，力分量 **59.346 meV/Å**，应力分量 **0.0910 GPa**。
- **未提供独立测试集。上述指标是训练拟合误差，不代表独立测试精度。**

## 完整性与引用

`SHA256SUMS.txt` 提供文件校验值。科学文件保留原始字节内容，包括 `train.xyz` 的历史行尾格式。

仓库地址：https://github.com/Gisran66/Ag2Se-NEP 。引用特定模型版本时，建议同时记录仓库提交编号。

文件公开供查看和下载；当前未附加明确的复用许可证。
