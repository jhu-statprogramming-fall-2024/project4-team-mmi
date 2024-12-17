#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinyEffects)
library(here)
library(tidyverse)

# load data
RESP_weather <- readRDS(here("data", "RESP_weather.RDS"))

# Define weather variable labels
weather_labels <- c(
    "temp_max" = "Maximum Temperature",
    "temp_min" = "Minimum Temperature",
    "precip_sum" = "Precipitation",
    "sunshine" = "Sunshine",
    "daylight" = "Daylight",
    "wind_speed_max" = "Maximum Wind Speed"
)

# Define UI
ui <- dashboardPage(
    dashboardHeader(title = "Weather-Respiratory Diseases Correlation Explorer"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("About", tabName = "about", icon = icon("info-circle")),
            menuItem("Weekly Rates", tabName = "weekly_rates", icon = icon("chart-line")),
            menuItem("Weather Explorer", tabName = "weather_explorer", icon = icon("cloud-sun"))
        )
    ),
    dashboardBody(
        tabItems(
            # Tab 1: Introduction Page
            tabItem(
                tabName = "about",
                fluidRow(
                    box(
                        title = "About", width = 12, solidHeader = TRUE, status = "primary",
                        includeMarkdown("about.qmd") # Renders content from the .md file
                    )
                )
            ),
            # Tab 2: Weekly Rates Page
            tabItem(
                tabName = "weekly_rates",
                fluidRow(
                    box(
                        title = "Filters", width = 3, solidHeader = TRUE, status = "primary",
                        selectInput("state", "Select State:",
                                    choices = unique(RESP_weather$site),
                                    selected = unique(RESP_weather$site)[1]),
                        selectInput("year", "Select Year:",
                                    choices = unique(RESP_weather$year),
                                    selected = unique(RESP_weather$year)[1],
                                    multiple = TRUE),
                        selectInput("pathogen", "Select Pathogen:",
                                    choices = unique(RESP_weather$pathogen),
                                    selected = unique(RESP_weather$pathogen)[1],
                                    multiple = TRUE)
                    ),
                    box(
                        title = "Weekly Rates of Respiratory Virus Infection-Associated Hospitalizations",
                        width = 9,
                        plotOutput("rsvPlot", height = "600px")
                    )
                )
            ),
            # Tab 3: Weather Explorer Page
            tabItem(
                tabName = "weather_explorer",
                fluidRow(
                    box(
                        title = "Filters", width = 3, solidHeader = TRUE, status = "primary",
                        selectInput("state2", "Select State", choices = unique(RESP_weather$site), selected = "California"),
                        selectInput("pathogen2", "Select Pathogen", choices = unique(RESP_weather$pathogen), selected = "RSV"),
                        sliderInput("year_range", "Select Year Range",
                                    min = min(RESP_weather$year), max = max(RESP_weather$year), value = c(2018, 2024)),
                        selectInput("weather_var", "Select Weather Variable",
                                    choices = c("Maximum Temperature" = "temp_max",
                                                "Minimum Temperature" = "temp_min",
                                                "Precipitation" = "precip_sum",
                                                "Sunshine" = "sunshine",
                                                "Daylight" = "daylight",
                                                "Maximum Wind Speed" = "wind_speed_max"),
                                    selected = "temp_max"),
                        checkboxInput("show_trend", "Show Trend Line", value = TRUE)
                    ),
                    box(
                        title = "Pathogen & Weather Relationship Explorer",
                        width = 9,
                        plotOutput("scatter_plot")
                    )
                )
            )
        )
    )
)

# Define Server
server <- function(input, output, session) {

    # -------------------
    # Tab 1: Weekly Rates
    # -------------------
    filtered_data1 <- reactive({
        RESP_weather %>%
            filter(site == input$state,
                   year %in% input$year,
                   pathogen %in% input$pathogen)
    })

    output$rsvPlot <- renderPlot({
        ggplot(filtered_data1(), aes(x = week, y = weekly_rate,
                                     color = as.character(year), shape = pathogen, linetype = pathogen)) +
            geom_rect(aes(xmin = -Inf, xmax = 20, ymin = -Inf, ymax = Inf),
                      inherit.aes = FALSE, fill = "#eeeeee", alpha = 1) +
            geom_rect(aes(xmin = 40, xmax = Inf, ymin = -Inf, ymax = Inf),
                      inherit.aes = FALSE, fill = "#eeeeee", alpha = 1) +
            facet_wrap(~site) +
            geom_point() +
            geom_line() +
            scale_color_brewer(palette = 'Set2') +
            labs(
                subtitle = 'Data Source: CDC RESP-NET',
                caption = 'Biostats 140.777 Project 4, Team MMI',
                y = 'Hospitalization rate per 100,000',
                x = 'Epidemiology Week',
                color = 'Year'
            ) +
            theme_minimal()
    })

    # -------------------------
    # Tab 2: Weather Explorer
    # -------------------------
    filtered_data2 <- reactive({
        RESP_weather %>%
            filter(
                site == input$state2,
                pathogen == input$pathogen2,
                year >= input$year_range[1],
                year <= input$year_range[2],
                !is.na(get(input$weather_var)),
                !is.na(weekly_rate)
            )
    })

    output$scatter_plot <- renderPlot({
        data <- filtered_data2()
        if (nrow(data) == 0) return(NULL)
        model <- lm(weekly_rate ~ get(input$weather_var), data = data)
        r_squared <- summary(model)$r.squared

        p <- ggplot(data, aes(x = get(input$weather_var), y = weekly_rate)) +
            geom_point(alpha = 0.7, color = "#3498db", size = 3) +
            labs(
                x = weather_labels[input$weather_var],
                y = "Weekly Rate",
                title = paste("Relationship Between", input$pathogen2, "and", weather_labels[input$weather_var], "in", input$state2)
            ) +
            theme_minimal(base_size = 15) +
            theme(plot.title = element_text(hjust = 0.5, size = 18, color = "#2c3e50"))

        if (input$show_trend) {
            p <- p + geom_smooth(method = "lm", color = "#e74c3c", size = 1)
        }
        p + annotate("text",
                     x = 0.8 * max(data[[input$weather_var]], na.rm = TRUE),
                     y = 0.9 * max(data$weekly_rate, na.rm = TRUE),
                     label = paste("R² =", round(r_squared, 2)),
                     color = "#2c3e50", size = 5)
    })
}

# Run the App
shinyApp(ui, server)
