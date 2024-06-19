# COVID-19 Data Analysis



## Problem Statement

This repository contains SQL queries and analysis related to COVID-19 cases, deaths, and vaccinations. The data is sourced from the Covid_Portfolio_Project database. This project aims to give intricate details about how Covid affected the world and how it affected various countries.

# Insights

### [1] COVID-19 Cases and Deaths by Location

Retrieved data on total cases, new cases, total deaths, and population for various locations.

Calculated the death percentage (total deaths divided by total cases) for each location.

Focused on Canada and analyzed the death percentage there.

### [2] Cases vs. Population

Compared total cases to the population in both Canada and globally.

Calculated the case percentage (total cases divided by population) for each location.

### [3] Highest Infection Rate
Identified countries with the highest infection rates relative to their population.

Used the maximum case percentage to determine this.

### [4] Total Deaths by Location and Continent:
Obtained the total deaths for each location and continent.

### [5] Global Numbers:
Summarized global data, including total cases, total deaths, and death percentage over time.

### [6] Vaccinations:
Looked at new vaccinations based on location.

Calculated the rolling vaccination count (cumulative vaccinations).

### [7] Percentage Vaccinated per Population:

Used a Common Table Expression (CTE) to find the percentage of vaccinated people relative to the population.

### [8] Percentage of People Vaccinated vs. Population:
Created a temporary table to calculate the same percentage.
Stored the result in a view called “PercentPopulationVaccinated.”
