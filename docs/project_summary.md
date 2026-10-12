# Project Summary – UAV Cyber-Physical IDS

## Objective
Build a robust intrusion detection system that can:
1. Distinguish Cyber vs Physical data streams from a UAV.
2. Detect whether traffic is benign or malicious.
3. Identify the specific attack type (DoS, Replay, Evil Twin, FDI).

## Methodology
- Data cleaning and stratified 70/30 splits
- Feature normalization and zero-variance filtering
- Multiple classical ML models + ensemble
- Single-stage multi-class classification
- Attack-only (benign removed) analysis
- Stability testing over 15 iterations

## Main Achievements
- Cyber vs Physical separation: **100% accuracy**
- Cyber 4-attack classification: up to **99.55%** (Bagged Trees / Ensemble)
- Physical data classification with robust preprocessing
- Full sample-level reporting and weighted model comparison

## Tools
- MATLAB (Statistics and Machine Learning Toolbox)
- Excel export for sample-level Actual vs Predicted analysis
