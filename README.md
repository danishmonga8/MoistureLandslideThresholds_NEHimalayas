# LandslideThresholdAnalysis_NERIHimalayas

## Author
- **Danish Monga** (Primary Developer)
- **Dr. Poulomi Ganguli** (Collaborator, Indian Institute of Technology Kharagpur)

## Overview

This repository contains MATLAB code and data for analyzing moisture-driven landslide thresholds in the Northeastern Himalayan region (NERI). The study focuses on establishing empirical rainfall thresholds that can trigger landslides, particularly in the context of developing effective Landslide Early Warning Systems (LEWS). The code integrates environmental and hydrometeorological factors to explain the spatial variability in landslide triggers, providing a robust framework for landslide risk management and disaster preparedness in the NERI region.

## Features

- **Data Reconstruction:** Implements the Regularized Expectation-Maximization (RegEM) method to reconstruct daily rainfall time series, addressing gaps in gauge-based observations.
- **Lag-Time Analysis:** Estimates optimal lag times for antecedent moisture content (AMC) to better understand its role in landslide genesis.
- **Threshold Derivation:** Uses non-crossing quantile regression to derive moisture Event-Duration (ED) thresholds, ensuring accurate and monotonic quantile estimates.
- **Spatial Variability Analysis:** Explores the relationship between rainfall thresholds and environmental controls like Land Use/Land Cover (LULC), slope, Topographic Wetness Index (TWI), and Channel Network Distance (CND) to explain regional differences in landslide susceptibility.

## Repository Structure

- `data/`: Contains input datasets, including station-based and gridded rainfall data.
- `scripts/`: Directory with MATLAB scripts for data processing, analysis, and visualization.
- `results/`: Directory where output files, figures, and threshold maps are saved.
- `README.md`: Provides an overview of the project, instructions for usage, and information on data sources.
- `LICENSE`: Details the licensing of the repository.

## Data Sources

- **Station-based daily rainfall time series**: Retrieved from the India Meteorological Department (IMD)’s Data Supply Portal: [IMD Data Supply Portal](https://dsp.imdpune.gov.in/).
- **Gridded rainfall time series for the Neri region**: Obtained from the archived gridded records of IMD, available at: [IMD Gridded Data](https://www.imdpune.gov.in/Clim_Pred_LRF_New/Grided_Data_Download.html).
- **Historical landslide inventory**: Sourced from:
  - [NASA Cooperative Open Online Landslide Repository (COOLR)](https://catalog.data.gov/dataset/global-landslide-catalog-export)
  - [Geological Survey of India’s Bhukosh portal](https://bhukosh.gsi.gov.in/Bhukosh/)

## Requirements

To run the code, ensure you have the following:

- MATLAB R2020a or later
- Required MATLAB toolboxes:
  - Statistics and Machine Learning Toolbox
  - Curve Fitting Toolbox
  - Optimization Toolbox

## Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/danishmonga8/LandslideThresholdAnalysis_NERIHimalayas.git
