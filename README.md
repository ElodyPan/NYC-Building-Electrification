# NYC Building Electrification Analysis

This repository contains the R script and data files used to analyze the progress of New York City's building electrification initiative. The analysis focuses on changes in energy consumption and their impact on greenhouse gas (GHG) emissions from CY 2010 to CY 2022.

## Project Description

Building electrification involves replacing fossil fuels used for heating, cooling, and other building operations with electricity, ideally sourced from renewable energy. This shift is crucial for reducing GHG emissions and achieving NYC's climate goals. The city's policies, including LL84 of 2009, LL133 of 2016, LL97 of 2016, and LL154 of 2021, support this transition by setting benchmarks, expanding requirements, and prohibiting onsite fuel combustion in new buildings.

This project uses data from the NYC Greenhouse Gas Emissions Inventory to evaluate the progress of building electrification. The analysis examines energy consumption patterns and GHG emissions across different building categories: Residential, Commercial and Institutional, and Manufacturing and Construction.

## Running the Analysis

### Step 1 - Installing Required Programs

To replicate this analysis, you will need:

- **R and RStudio**: For data cleaning, processing, and visualization.
- **ggplot2 package**: For creating visualizations.

### Step 2 - Downloading Data

Download the following datasets to your local computer:

- [NYC Greenhouse Gas Emissions Inventory](https://data.cityofnewyork.us/Environment/NYC-Greenhouse-Gas-Emissions-Inventory/wq7q-htne)

### Step 3 - Running the R Script

Run the `script-final.R` in RStudio. Ensure that all data files are located in your working directory. The script performs the following tasks:

1. **Data Import**: Imports raw data from the NYC Greenhouse Gas Emissions Inventory.
2. **Data Filtering**: Focuses on Stationary Energy sectors, excluding fugitive natural gas due to its distinct emission characteristics.
3. **Data Aggregation**: Aggregates data to calculate total energy consumption and GHG emissions for each category and energy source.
4. **Energy Consumption Analysis**: Analyzes changes in energy consumption, focusing on the shift from fuel oil to electricity and natural gas.
5. **GHG Emissions Analysis**: Calculates percentage changes in GHG emissions for each energy source, comparing 2010 and 2022.
6. **Data Visualization**: Generates visualizations using `ggplot2` to illustrate energy consumption and GHG emissions trends.

## Questions about the data or analysis?

Feel Free to contact at yp2563@gmail.com
