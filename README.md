# Project

This [**Weather-Respiratory Diseases Correlation Explorer**](https://yunyiru.shinyapps.io/RESPweather_dashboard/) R shinydashboard aims to investigate the relationship between climate and weather-related conditions and outbreaks of two respiratory viruses, **influenza** and **respiratory syncytial virus (RSV)**.

Influenza is an RNA virus from the *Orthomyxoviridae* family that frequently mutates, causing seasonal epidemics, while RSV is an RNA virus from the *Paramyxoviridae* family that primarily affects young children and the elderly, often leading to severe lower respiratory infections. Both viruses pose significant public health challenges due to their widespread transmission and potential for severe disease.

Climate and weather conditions can influence the activity and spread of both viruses. Studies have suggested that factors like **cold temperatures**, **low indoor humidity**, **limited sunlight**, and **rapid weather changes** may increase the risk of disease outbreaks.

# Features

- **Weekly Rates**: This dashboard uses [CDC RESP-NET data](https://data.cdc.gov/Public-Health-Surveillance/Rates-of-Laboratory-Confirmed-RSV-COVID-19-and-Flu/kvib-3txy/about_data) to give an overview of influenza and rsv hospitalization rates of each state from 2018 to 2024. The user can select year, state, and pathogen of interest using the interactive filters. 

- **Weather Explorer**: This dashboard integrates [environmental parameter data](https://open-meteo.com/) from openmeteo API and respiratory virus-associated hospitalization rate data to perform regression analysis. The user can select year, state, weather variable and pathogen of interest using the interactive filters. 

# Data

- **Respiratory Virus Related Hospitalization Rate**: Disease rate data were scrapped from  [CDC RESP-NET](https://data.cdc.gov/Public-Health-Surveillance/Rates-of-Laboratory-Confirmed-RSV-COVID-19-and-Flu/kvib-3txy/about_data).

- **Environmental Parameters**: Weather data were scrapped from [Openmeteo API](https://open-meteo.com/).

# Repo Navigation

See data analysis codes in `index.qmd`; rshinydashboard codes in `RESPweather_dashboard`; project final write up in `final_write_up.pdf`; project proposal in `proposal`; raw data in `data`.

------

# About Us

**Team MMI** are **Yunyi Ru** (email: yru3@jh.edu; GitHub: https://github.com/yunyi-ru) and **Juanyu Zhang** (jzhan398@jh.edu; GitHub: https://github.com/JuYZhang). 

For source code, please see our [github repository](https://github.com/jhu-statprogramming-fall-2024/project4-team-mmi).

- Last maintained: 2024-12-19

- CDC data update: 2024-11-30

*This is a class project of Johns Hopkins University [Biostatistics 140.777 Statistical Programming Paradigms](https://www.stephaniehicks.com/jhustatprogramming2024/) course*.
