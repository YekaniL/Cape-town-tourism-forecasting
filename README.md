# Cape Town Tourism – Time Series Forecasting Project

This project analyses and forecasts key accommodation performance metrics for Cape Town Tourism using advanced time-series methods in R. The goal is to understand seasonal patterns and predict future trends for strategic planning in the tourism sector.

## 📊 Project Overview
The analysis focuses on three core tourism metrics:
- **Average Room Rate (ARR)**
- **Occupancy Rate**
- **Revenue per Available Room (RevPAR)**

The dataset (2015–2023) was cleaned, transformed, and converted into a time-series structure to explore trends and seasonality before building forecasting models.

## 🧹 Data Preparation
- Loaded and cleaned Excel data using `readxl` and `dplyr`
- Converted the Month column to a `yearmonth` format  
- Removed heavily incomplete rows  
- Imputed missing values for Occupancy Rate, Average Room Rate, and RevPAR  
- Created time-series plots using `ggplot2`

## 🔍 Exploratory Analysis
- Visualised seasonality of ARR and Occupancy with dual-axis line plots  
- Examined accommodation performance across all months from 2015–2023  
- Identified seasonal peaks and troughs in Cape Town tourism

## 🔮 Forecasting Methods
### **ETS (Holt-Winters) Models**
Built additive and multiplicative ETS models for:
- **Average Room Rate**
- **Occupancy Rate**

Compared performance with:
- **Seasonal Naïve (SNAIVE)** model  
- Forecast horizon: **11 months**

### **ARIMA Models**
- Fitted ARIMA(1,1,1) models for ARR and Occupancy  
- Forecast horizon: **12 months**  
- Plotted and summarised forecast results  
- Evaluated model accuracy using standard metrics

## 🛠️ Tools & Libraries Used
- **R**
- `fpp3`
- `forecast`
- `ggplot2`
- `readxl`
- `dplyr`
- `tsibble`

## 📈 Key Skills Demonstrated
- Time-series modelling (ETS, ARIMA)
- Forecasting and trend analysis
- Data cleaning and preparation
- Visualisation and storytelling with R
- Tourism analytics

## 📁 Files in This Repository
- `accommodation_analysis.R` – Full script with cleaning, modelling, forecasting, and plots  
- `README.md` – Project documentation  


---

Feel free to clone or fork the project. Feedback and improvements are welcome!
