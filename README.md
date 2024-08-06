# LandslideThresholdAnalysis_NERIHimalayas
## Author
Danish Monga (primary developer)
Dr. Poulomi Ganguli, Indian Institute of Technology Kharagpur (collaborator)
## Overview

This repository contains MATLAB code for analyzing moisture-driven landslide thresholds in the Northeastern Himalayan region (NERI). The code integrates environmental and hydrometeorological controls to explain the spatial variability in landslide triggers, contributing to the development of region-specific Landslide Early Warning Systems (LEWS).

## Features

- **Data Reconstruction:** Implements the Regularized Expectation-Maximization (RegEM) method for reconstructing daily rainfall time series.
- **Lag-Time Analysis:** Uses a quantitative approach to estimate optimal lag-times for antecedent moisture content (AMC) in landslide genesis.
- **Threshold Derivation:** Employs non-crossing quantile regression to derive moisture Event-Duration (ED) thresholds.
- **Spatial Variability:** Links rainfall thresholds with environmental controls like Land Use/Land Cover (LULC), slope, Topographic Wetness Index (TWI), and Channel Network Distance (CND).

## Code Structure

- `data/`: Directory containing input datasets.
- `scripts/`: Directory with the main MATLAB scripts.
- `results/`: Directory where output files and figures are saved.
- `README.md`: This file, providing an overview and instructions.

## Data Sources

- **Station-based daily rainfall time series** is retrieved from the India Meteorological Department (IMD)’s Data Supply Portal: [IMD Data Supply Portal](https://dsp.imdpune.gov.in/).
- **Gridded rainfall time series for the Neri region** is obtained from the archived gridded records of IMD, available at: [IMD Gridded Data](https://www.imdpune.gov.in/Clim_Pred_LRF_New/Grided_Data_Download.html).
- **Historical landslide inventory** was obtained from:
  - [NASA Cooperative Open Online Landslide Repository (COOLR)](https://catalog.data.gov/dataset/global-landslide-catalog-export).
  - [Geological Survey of India’s Bhukosh portal](https://bhukosh.gsi.gov.in/Bhukosh/).


## Requirements

To run this code, ensure you have the following:

- MATLAB R2020a or later
- Required MATLAB toolboxes:
  - Statistics and Machine Learning Toolbox
  - Curve Fitting Toolbox
  - Optimization Toolbox

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/danishmonga8/LandslideThresholdAnalysis_NERIHimalayas.git

