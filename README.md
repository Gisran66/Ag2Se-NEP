# Ag2Se NEP potential and training data

[中文说明](README_zh.md)

Ag–Se neuroevolution potential (NEP) and the associated training archive, organized following the [GPUMD `examples/nep_train`](https://github.com/brucefan1983/GPUMD/tree/master/examples/nep_train) layout.

**Download the fitted potential: [`nep_train/nep.txt`](nep_train/nep.txt).** To download everything, use **Code → Download ZIP**, or clone this repository.

## Files

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

`nep.txt` is the fitted potential; `nep.in` contains the training settings; `train.xyz` contains the labeled training structures; `nep.restart` is the saved training state. The `.out` files contain the training loss and NEP/reference comparisons. These nine scientific files are preserved byte-for-byte from the original training directory. `plot_results.m` is a new plotting helper for this archive, with data-dependent axis limits.

Existing figure previews are retained in [`figures/`](figures): [training summary](figures/training_summary.png) and [training parity](figures/training_parity.png).

## Use the potential

Copy `nep_train/nep.txt` into your GPUMD simulation directory and reference it in `run.in`:

```text
potential nep.txt
```

The model is NEP4 with ZBL and declares the elements `Ag Se`. The training input specifies radial/angular cutoffs of 6/4 Å and 150,000 generations. Consult [`nep.in`](nep_train/nep.in) for the complete settings and the [GPUMD documentation](https://gpumd.org/) for simulation inputs. Applicability to new structures or conditions must be assessed separately.

## Plot the training results

In MATLAB, change the current folder to `nep_train` and run:

```matlab
metrics = plot_results;
```

Optionally save the figure:

```matlab
metrics = plot_results('training_results.png');
```

The helper plots energy, force, virial, stress, and training losses, and reports MAE, RMSE, and R². Metrics use all valid components; dense parity panels display a deterministic subset of at most 100,000 points. No extra MATLAB toolboxes are required. Do not rerun training in this archive without making a separate copy, because training can overwrite the supplied potential and outputs.

## Training archive

- 1,720 labeled structures and 296,739 atom instances (Ag: 197,823; Se: 98,916).
- 1,718 exact unique structures: one structure occurs three times and is intentionally retained to preserve the actual training set.
- Training-set RMSE: **4.130 meV/atom** for energy, **59.346 meV/Å** for force components, and **0.0910 GPa** for stress components.
- **No independent test set is included. These metrics describe the training fit, not holdout accuracy.**

## Integrity and reference

`SHA256SUMS.txt` records file checksums. Git preserves the original bytes of the scientific files, including the historical line endings in `train.xyz`.

Repository: https://github.com/Gisran66/Ag2Se-NEP. When referring to a particular model version, record the repository commit as well as the URL.

The files are provided for public inspection and download. No explicit reuse license is included.
