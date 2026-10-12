# UAV Cyber-Physical Intrusion Detection System

A complete MATLAB-based machine learning pipeline for detecting cyber and physical attacks on Unmanned Aerial Vehicles (UAVs).

## Project Overview

This project implements a **Cyber-Physical Intrusion Detection System** that classifies network (cyber) and sensor (physical) data from UAVs to detect:

| Class        | Description                  |
|--------------|------------------------------|
| Benign       | Normal / non-attack traffic  |
| DoS attack   | Denial-of-Service            |
| Replay       | Replay attack                |
| Evil Twin    | Evil Twin attack             |
| FDI          | False Data Injection         |

### Key Features

- **Domain Classification**: Cyber vs Physical (100% accuracy)
- **Single-stage multi-class classification** (Benign + 4 attacks)
- **Attack-only classification** (Benign removed)
- **Feature ranking & elimination**
- **Ensemble methods** (Majority Vote of tree models)
- **15-iteration stability analysis**
- **Sample-level Actual vs Predicted Excel reports** with model weighting
- Confusion matrices, accuracy bar graphs, and variation plots

## Dataset

- **Source**: `Dataset_T-ITS.csv` (Cyber-Physical UAV IDS dataset)
- Contains both **cyber** (network/packet) and **physical** (sensor) features
- Row ranges define Cyber/Physical splits and attack types

Place the original dataset in the `data/` folder:

```
data/
├── Dataset_T-ITS.csv
├── Cyber_Data.csv          (optional – generated)
├── Physical_Data.csv       (optional – generated)
├── Cyber_Train_70.csv
├── Cyber_Test_30.csv
├── Physical_Train_70.csv
└── Physical_Test_30.csv
```

## Project Structure

```
UAV-Cyber-Physical-IDS/
├── README.md
├── .gitignore
├── LICENSE
├── code/
│   ├── 01_split_cyber_physical.m
│   ├── 02_split_70_30.m
│   ├── 03_cyber_single_stage.m
│   ├── 04_cyber_attack_only.m
│   ├── 05_physical_single_stage.m
│   ├── 06_ensemble_majority_vote.m
│   ├── 07_15_iterations.m
│   └── 08_export_sample_level_excel.m
├── data/                   # Place CSV files here
├── results/                # Output Excel & figures
└── docs/
    └── project_summary.md
```

## Requirements

- MATLAB R2020a or later (tested with R2026a concepts)
- Statistics and Machine Learning Toolbox
- (Optional) Parallel Computing Toolbox for faster iterations

## How to Run

1. Place `Dataset_T-ITS.csv` in the `data/` folder.
2. Open MATLAB and set the current folder to the project root.
3. Run the scripts in order (or run individual analysis scripts):

```matlab
cd code
run('01_split_cyber_physical.m')
run('02_split_70_30.m')
run('03_cyber_single_stage.m')
```

### Main Results (Cyber Data)

| Model                    | Accuracy (approx.) |
|--------------------------|--------------------|
| Bagged Trees             | ~99.55%            |
| Random Forest            | ~99.54%            |
| Decision Tree            | ~99.41%            |
| Majority Vote Ensemble   | ~99.55%            |
| KNN (K=5)                | ~92–97%            |
| SVM (RBF)                | ~75–90%            |

Cyber vs Physical domain separation: **100%**

## Models Used

- Decision Tree (`fitctree`)
- Random Forest (`TreeBagger`)
- Bagged Trees (`fitcensemble` – Bag)
- k-Nearest Neighbors (`fitcknn`)
- Support Vector Machine – ECOC with RBF / Linear / Polynomial kernels (`fitcecoc`)
- Majority Vote Ensemble of the three tree-based models

## Evaluation

- Stratified 70% Train / 30% Test split
- Accuracy, Error rate
- Confusion matrices (row & column normalized)
- 15 independent iterations with mean / std / min / max accuracy
- Sample-level Actual vs Predicted export with model weights

## Author

Developed as part of research / academic work on UAV Cyber-Physical Security.

## License

This project is released under the MIT License. See `LICENSE` for details.

## References

- Related paper: *Cyber-Physical Intrusion Detection System for Unmanned Aerial Vehicles* (see `docs/` or attached PDF)
