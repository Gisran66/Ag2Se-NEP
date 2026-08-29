# Ag2Se NEP training example and fitted potential

> **Release-candidate status:** the scientific files and checksums are locally verified. Repository URL, visibility, authors/citation, license, and the exact production GPUMD build remain pending before publication.

[中文说明](README_zh.md)

This package follows the single-folder layout of the official [GPUMD `examples/nep_train`](https://github.com/brucefan1983/GPUMD/tree/master/examples/nep_train) example. All files required to inspect the archived training run or reuse the fitted Ag--Se potential are grouped in `nep_train/`.

## Folder layout

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

The official example uses `plot_results.m`. This package uses the project's actual Python plotting script as `plot_results.py` because it dynamically covers the Ag2Se energy/force ranges and includes the archived stress output. Reusing the PbTe-specific MATLAB script unchanged would impose inappropriate fixed plot ranges.

Additional compact provenance and integrity files are in `metadata/`; preview figures are in `figures/`.

## Dataset and provenance

`nep_train/train.xyz` is the exact training archive used for the fitted model:

- 1,720 labeled records and 296,739 atom instances;
- 197,823 Ag and 98,916 Se atom instances;
- 143--288 atoms per record;
- lattice, periodic-boundary flags, total energy, forces, and nine-component virial in every record;
- 1,718 exact unique records.

One 168-atom selected-interface record occurs three times at one-based record indices 796, 830, and 898. It is retained to reproduce the actual fit. The final file is the byte-exact concatenation of `train-cubic.xyz`, `train-low.xyz`, `train-jm.xyz`, and `train-old.xyz` in that order; the four component files are not duplicated here.

The associated V10 manuscript/SI records VASP/PAW/PBEsol training labels with a 450 eV plane-wave cutoff, `EDIFF=1e-6 eV`, `ISMEAR=0`, `SIGMA=0.05 eV`, Gamma-centered meshes from `KSPACING=0.2 A^-1`, `PREC=Normal`, `LREAL=Auto`, `LASPH=.TRUE.`, and `ADDGRID=.TRUE.`. Original per-calculation training inputs are not included, so these remain manuscript-recorded metadata rather than a repository-level raw-input audit. Licensed VASP PAW files are not redistributed.

## Model and training

The archived log records GPUMD 5.5 and a completed 150,000-generation fit. The exact source tag/commit, local modification status, compiler/CUDA settings, and executable SHA-256 are **[PENDING]**.

`nep.in` defines an Ag/Se NEP4-ZBL model with 6/4 A radial/angular cutoffs, `n_max=4/4`, basis size 12/12, `l_max=4/2/0`, 50 hidden neurons, batch size 2,000, and energy/force/virial weights 1.0/1.0/0.1.

Training-record metrics:

| Quantity | MAE | RMSE | R2 | Points |
| --- | ---: | ---: | ---: | ---: |
| Energy | 3.155 meV/atom | 4.130 meV/atom | 0.9932 | 1,720 |
| Force | 44.175 meV/A | 59.346 meV/A | 0.9755 | 890,217 |
| Stress | 0.0606 GPa | 0.0910 GPa | 0.9974 | 10,320 |

**No independent `test.xyz` is present. These values and parity plots are training-set diagnostics, not holdout accuracy.**

## Use

Run from inside `nep_train/` with the exact NEP-capable executable appropriate to a verified GPUMD installation:

```text
path/to/nep
```

This will start or continue training according to `nep.in`; preserve `nep.restart` before any continuation that may overwrite outputs. To regenerate the archived summary plot after installing NumPy and Matplotlib:

```text
python plot_results.py save
```

For GPUMD deployment, copy `nep_train/nep.txt` into a clean simulation directory and add:

```text
potential nep.txt
```

Preserve the element order `Ag Se`. A successful load is not scientific validation; new phases, temperatures, defects, interfaces, or transport calculations require short-run stability checks and target-state validation.

## Integrity, citation, and license

Verify all published files against `SHA256SUMS.txt`. `.gitattributes` disables Git line-ending normalization for the archived scientific artifacts, including the historically mixed-line-ending `train.xyz`, so a fresh cross-platform clone retains the recorded bytes. Core fingerprints:

- `nep_train/train.xyz`: `FB9B3AE6C4352EDEF07AAF2E26B072617C736E2B21BB16460521CFEA4511896C`
- `nep_train/nep.in`: `35ED458D7C77A4B61EDCB619A9F9F8B3F974F1081B1F586DEF974EB117EF2CA6`
- `nep_train/nep.txt`: `92E43F46A96D048075BCA60C61CA4886ED523EC65A31CB8680446ECEAF38B26F`

Authors, paper/DOI, recommended citation, and licenses are **[PENDING]**. Repository visibility alone does not grant reuse permission.
