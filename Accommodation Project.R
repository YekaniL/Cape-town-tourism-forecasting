setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Libraries ####
# Load necessary packages
library(fpp3)
library(readxl) 
library(reshape2) 
library(forecast)

# Reading Data ####
accomodation  <- read_excel("All Data - updated August 2023.xlsx", 
                            sheet = "New Accommodation Data") %>%
  mutate("Month" = yearmonth(Month),
         "Occupancy_Rate"  = Occupancy_Rate * 100) %>%
           as_tsibble(index = Month)


str(accomodation)

# Accommodation metrics (Liezy)  
colours <- c("Average Room Rate" = "red",
             "Occupancy Rate" = "blue")
accomodation %>% na.omit %>% ggplot(aes(x = Month)) +
  scale_y_continuous(name = "Average Room Rate (Rand)",
                     sec.axis = sec_axis(name = "Occupancy Rate (%)",
                                         trans=~./30)) +
  geom_line(aes(y = Average_Room, color = "Average Room Rate")) +
  geom_line(aes(y = Occupancy_Rate * 30, color = "Occupancy Rate")) +
  labs(x = "Month", title = "Seasonality of the Accommodation data") +
  scale_colour_manual(values = colours) + 
  theme(legend.position = "bottom", 
        axis.title.y.right = element_text(angle = 90)) + 
  guides(colour = guide_legend(title = "Accommodation Metric:"))

# imputation of missing values.
missing_rows <- which(!complete.cases(accomodation))
missing_rows
accomodation <- accomodation[-c(103,104, 105, 106,107, 108),] 
#removing the last null values since they skew data heavily when imputed with 0

accomodation$Occupancy_Rate <- ifelse(is.na(accomodation$Occupancy_Rate) == T,
                                      0, accomodation$Occupancy_Rate)
accomodation$Average_Room   <- ifelse(is.na(accomodation$Average_Room) == T,
                                      0, accomodation$Average_Room)
accomodation$RevPar         <- ifelse(is.na(accomodation$RevPar) == T, 0,
                                      accomodation$RevPar)

# Holt-Winters Method ####

arr_fit <- accomodation %>%
  model(
    additive = ETS(Average_Room ~ error("A") + trend("A") +
                     season("A")),
    multiplicative = ETS(Average_Room ~ error("M") + trend("A") +
                           season("M")),
    `Seasonal naïve` = SNAIVE(Average_Room)
  )
arr_fc <- arr_fit %>% forecast(h = 11)
arr_fc %>%
  autoplot(accomodation, level = NULL) +
  labs(title="AverageRoomRate forecasts from 2023 July -2024 June",
       y="Average Room Rate") +
  guides(colour = guide_legend(title = "Forecast"))

accuracy(arr_fit)

or_fit <-accomodation %>%
  model(
    additive = ETS(Occupancy_Rate ~ error("A") + trend("A") +
                     season("A")),
    multiplicative = ETS(Occupancy_Rate ~ error("M") + trend("A") +
                           season("M")),
    `Seasonal naïve` = SNAIVE(Occupancy_Rate)
  )
or_fc <- or_fit %>% forecast(h = 11)
or_fc %>%
  autoplot(accomodation, level = NULL) +
  labs(title="Occupancy Rate forecasts from 2023 July To 2024 June)",
       y="Average Room Rate") +
  guides(colour = guide_legend(title = "Forecast"))

accuracy(or_fit)

# Arima Model ####

arr_arima <- accomodation[,c("Average_Room")]
or_arima <- accomodation[,c("Occupancy_Rate")]

# Avergae Room Rate

ts_data <- ts(arr_arima, start = c(2015,1), frequency = 12)

plot(ts_data, main = "Average Room Rate")

# Fitting the ARIMA Model

arima_model <- arima(ts_data, order = c(1,1,1))

summary(arima_model)

forecast_values <- forecast(arima_model, h = 12)

# Plot the forecast
autoplot(forecast_values) +
  labs(title = "ARIMA Forecast of the Average Room Rate",
       x = "Time",
       y = "Observed/Forecasted Values")

summary(forecast_values)

# Occupancy Rate

ts_data_ <- ts(or_arima, start = c(2015,1), frequency = 12)

plot(ts_data, main = "Occupancy Rate")

# Fitting the ARIMA Model

arima_model_ <- arima(ts_data_, order = c(1,1,1))

summary(arima_model)

forecast_values <- forecast(arima_model_, h = 12)

# Plot the forecast
autoplot(forecast_values) +
  labs(title = "ARIMA Forecast of the Occupancy Rate",
       x = "Time",
       y = "Observed/Forecasted Values")

summary(forecast_values)
