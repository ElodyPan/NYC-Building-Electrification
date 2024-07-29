setwd("/Users/ypan/R/my-r-project")

library(tidyverse)
library(janitor)
library(readr)

# Read and clean the data from CSV
GHG <- read.csv(file = "/Users/ypan/R/my-r-project/data/NYC_Greenhouse_Gas_Emissions_Inventory.csv") %>% 
  clean_names()

# Filter the dataset to include only GPC and Stationary Energy, and relevant categories
GHG_filtered <- GHG %>%
  filter(inventory_type == "GPC" & sectors_sector == "Stationary Energy" & 
           category_label %in% c("Residential", 
                                 "Commercial and Institutional", 
                                 "Manufacturing and Construction")) %>%
  select(source_full, category_label, cy_2010_consumed, cy_2022_consumed, cy_2010_t_co2e, cy_2022_t_co2e)

# Define energy source categories
GHG_filtered <- GHG_filtered %>%
  mutate(energy_source = case_when(
    source_full %in% c("#2 fuel oil", "#4 fuel oil", "#6 fuel oil") ~ "Fuel oil",
    source_full == "Natural gas" ~ "Natural gas",
    source_full == "Electricity" ~ "Electricity",
    source_full == "Steam" ~ "Steam",
    TRUE ~ "Other"
  ))

# Exclude "Other" energy sources
GHG_filtered <- GHG_filtered %>%
  filter(energy_source != "Other")

# Calculate the percentage change for energy consumption
GHG_filtered <- GHG_filtered %>%
  mutate(percentage_change_consumed = (cy_2022_consumed / cy_2010_consumed - 1) * 100)

# Calculate the percentage change for GHG emissions
GHG_filtered <- GHG_filtered %>%
  mutate(percentage_change_t_co2e = (cy_2022_t_co2e / cy_2010_t_co2e - 1) * 100)

# Calculate the overall percentage change for energy consumption
total_consumed_2010 <- sum(GHG_filtered$cy_2010_consumed, na.rm = TRUE)
total_consumed_2022 <- sum(GHG_filtered$cy_2022_consumed, na.rm = TRUE)
overall_percentage_change_consumed <- (total_consumed_2022 / total_consumed_2010 - 1) * 100

# Calculate the overall percentage change for GHG emissions
total_t_co2e_2010 <- sum(GHG_filtered$cy_2010_t_co2e, na.rm = TRUE)
total_t_co2e_2022 <- sum(GHG_filtered$cy_2022_t_co2e, na.rm = TRUE)
overall_percentage_change_t_co2e <- (total_t_co2e_2022 / total_t_co2e_2010 - 1) * 100

# Define custom colors
custom_colors <- c("Electricity" = "#600092", "Fuel oil" = "#dec9e8", "Natural gas" = "#f6e6ff", "Steam" = "#92a1cf")

# Plotting the energy consumption in 2010 and 2022
GHG_long <- GHG_filtered %>%
  select(energy_source, cy_2010_consumed, cy_2022_consumed) %>%
  pivot_longer(cols = starts_with("cy_"), names_to = "year", values_to = "consumed") %>%
  mutate(year = recode(year, "cy_2010_consumed" = "2010", "cy_2022_consumed" = "2022"))

ggplot(GHG_long, aes(x = energy_source, y = consumed, fill = year)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("2010" = "#600092", "2022" = "#dec9e8")) +
  labs(title = "Energy Consumption Comparison (2010 vs 2022)",
       x = "Energy Source", y = "Energy Consumption (MMBtu)", fill = "Year") +
  scale_y_continuous(labels = scales::unit_format(unit = "B", scale = 1e-9)) +
  theme_minimal()

# Plotting the GHG emissions in 2010 and 2022
GHG_long_emissions <- GHG_filtered %>%
  select(energy_source, cy_2010_t_co2e, cy_2022_t_co2e) %>%
  pivot_longer(cols = starts_with("cy_"), names_to = "year", values_to = "emissions") %>%
  mutate(year = recode(year, "cy_2010_t_co2e" = "2010", "cy_2022_t_co2e" = "2022"))

ggplot(GHG_long_emissions, aes(x = energy_source, y = emissions, fill = year)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("2010" = "#600092", "2022" = "#dec9e8")) +
  labs(title = "GHG Emissions Comparison (2010 vs 2022)",
       x = "Energy Source", y = "GHG Emissions (tCO2e)", fill = "Year") +
  scale_y_continuous(labels = scales::unit_format(unit = "M", scale = 1e-6)) +
  theme_minimal()

# Plotting the percentage change in consumed data
ggplot(GHG_filtered, aes(x = energy_source, y = percentage_change_consumed, fill = energy_source)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = overall_percentage_change_consumed, linetype = "dashed", color = "red") +
  scale_fill_manual(values = custom_colors) +
  labs(title = "Percentage Change in Energy Consumption (2010-2022)",
       x = "Energy Source", y = "Percentage Change (%)") +
  theme_minimal()

# Plotting the percentage change in tCO2e data
ggplot(GHG_filtered, aes(x = energy_source, y = percentage_change_t_co2e, fill = energy_source)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = overall_percentage_change_t_co2e, linetype = "dashed", color = "red") +
  scale_fill_manual(values = custom_colors) +
  labs(title = "Percentage Change in GHG Emissions (2010-2022)",
       x = "Energy Source", y = "Percentage Change (%)") +
  theme_minimal()

# [2022]Plotting the stacked bar chart for GHG emissions by category and source
GHG_stacked <- GHG_filtered %>%
  select(category_label, energy_source, cy_2022_t_co2e) %>%
  group_by(category_label, energy_source) %>%
  summarize(total_emissions = sum(cy_2022_t_co2e, na.rm = TRUE)) %>%
  ungroup()


ggplot(GHG_stacked, aes(x = category_label, y = total_emissions, fill = energy_source)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = custom_colors) +
  labs(title = "GHG Emissions by Category and Source (2022)",
       x = "", y = "Tons of carbon dioxide", fill = "Energy Source") +
  scale_y_continuous(labels = scales::unit_format(unit = "M", scale = 1e-6)) +
  theme_minimal()

# [2010]Plotting the stacked bar chart for GHG emissions by category and source
GHG_stacked <- GHG_filtered %>%
  select(category_label, energy_source, cy_2010_t_co2e) %>%
  group_by(category_label, energy_source) %>%
  summarize(total_emissions = sum(cy_2010_t_co2e, na.rm = TRUE)) %>%
  ungroup()


ggplot(GHG_stacked, aes(x = category_label, y = total_emissions, fill = energy_source)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = custom_colors) +
  labs(title = "GHG Emissions by Category and Source (2010)",
       x = "", y = "Tons of carbon dioxide", fill = "Energy Source") +
  scale_y_continuous(labels = scales::unit_format(unit = "M", scale = 1e-6)) +
  theme_minimal()

# Function to create percentage change plot for a specific category
create_percentage_change_plot <- function(category_name) {
  GHG_category <- GHG_filtered %>% filter(category_label == category_name)
  
ggplot(GHG_category, aes(x = energy_source, y = percentage_change_t_co2e, fill = energy_source)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = custom_colors) +
    labs(title = paste("Percentage Change in GHG Emissions (2010-2022) -", category_name),
         x = "Energy Source", y = "Percentage Change (%)") +
    theme_minimal()
}

# Create and save plots for each category
categories <- c("Residential", "Commercial and Institutional", "Manufacturing and Construction")

for (category in categories) {
  plot <- create_percentage_change_plot(category)
  ggsave(paste0("Percentage_Change_GHG_Emissions_", gsub(" ", "_", category), ".png"), plot = plot, device = "png")
}
