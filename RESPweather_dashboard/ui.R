library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(DT)

# load data
RESP_weather <- readRDS("RESP_weather.RDS")

# UI
ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Weather-Respiratory Diseases Correlation Explorer",
                  titleWidth = 450),
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "about", icon = icon("info-circle")),
    menuItem(
      "Weekly Rates",
      tabName = "weekly_rates",
      icon = icon("chart-line")
    ),
    menuItem(
      "Weather Explorer",
      tabName = "weather_explorer",
      icon = icon("cloud-sun")
    )
  )),
  dashboardBody(
    tabItems(
    # ------
    # Tab 1: Introduction Page
    tabItem(tabName = "about",
            fluidPage(
             uiOutput("about")
            )),
    # ------
    # Tab 2: Weekly Rates Page
    tabItem(tabName = "weekly_rates", fluidRow(

      # box: epi week view hospitalization data
      box(
        title = "Hospitalization Rate (Epidemiological Week View)",
        width = 6,
        selectInput(
          "state",
          "Select State:",
          choices = unique(RESP_weather$site),
          selected = unique(RESP_weather$site)[8]
        ),
        selectInput(
          "year",
          "Select Year:",
          choices = unique(RESP_weather$year),
          selected = unique(RESP_weather$year)[1],
          multiple = TRUE
        ),
        selectInput(
          "pathogen",
          "Select Pathogen:",
          choices = unique(RESP_weather$pathogen),
          selected = unique(RESP_weather$pathogen)[1],
          multiple = TRUE
        ),
        plotOutput("rsvPlot", height = "600px")
      ),

      # box: time-series view hospitalization data
      box(
        title = "Hospitalization Rate (Time-Series View)",
        width = 6,
        selectInput(
          "state2",
          "Select State:",
          choices = unique(RESP_weather$site),
          selected = unique(RESP_weather$site)[8]
        ),
        selectInput(
          "pathogen2",
          "Select Pathogen:",
          choices = unique(RESP_weather$pathogen),
          selected = unique(RESP_weather$pathogen)[1],
          multiple = TRUE
        ),
        dateRangeInput(
          "date_range",
          "Select Date Range:",
          start = min(RESP_weather$date),
          end = max(RESP_weather$date),
          min = min(RESP_weather$date),
          max = max(RESP_weather$date)
        ),
        plotOutput("time_series_plot", height = "600px")
      )
    ), fluidRow(
      # box: data summary
      box(title = "Summary of Weekly Hospitalization Rate and Environmental Parameters", width = 12, DTOutput("weekly_table"))
    ))
    ,
    # ------
    # Tab 3: Weather Explorer Page
    tabItem(tabName = "weather_explorer", fluidRow(
      box(
        title = "Filters",
        width = 3,
        solidHeader = FALSE,
        status = "primary",
        selectInput(
          "state2",
          "Select State",
          choices = unique(RESP_weather$site),
          selected = "Maryland"
        ),
        selectInput(
          "pathogen2",
          "Select Pathogen",
          choices = unique(RESP_weather$pathogen),
          selected = "RSV"
        ),
        sliderInput(
          "year_range",
          "Select Year Range",
          min = min(RESP_weather$year),
          max = max(RESP_weather$year),
          value = c(2018, 2024)
        ),
        selectInput(
          "weather_var",
          "Select Weather Variable",
          choices = c(
            "Maximum Temperature" = "temp_max",
            "Minimum Temperature" = "temp_min",
            "Precipitation" = "precip_sum",
            "Sunshine" = "sunshine",
            "Daylight" = "daylight",
            "Maximum Wind Speed" = "wind_speed_max"
          ),
          selected = "temp_max"
        ),
        checkboxInput("show_trend", "Show Trend Line", value = TRUE)
      ),
      box(
        title = "Pathogen & Weather Relationship Explorer",
        width = 9,
        plotOutput("scatter_plot")
      )
    ))
  ))
)
