run_descriptives <- function(data, output_dir = "results") {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  obesity_by_state <- data |>
    dplyr::group_by(state) |>
    dplyr::summarise(
      total_individuals = dplyr::n(),
      obese_individuals = sum(obesity_status == "Obese"),
      obesity_rate = mean(obesity_status == "Obese"),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(obesity_rate))

  utils::write.csv(obesity_by_state, file.path(output_dir, "obesity_by_state.csv"), row.names = FALSE)

  p_income <- ggplot2::ggplot(data, ggplot2::aes(x = income_group)) +
    ggplot2::geom_bar() +
    ggplot2::labs(title = "Distribution of income groups", x = NULL, y = "Count") +
    ggplot2::theme_minimal()
  ggplot2::ggsave(file.path(output_dir, "income_distribution.png"), p_income, width = 7, height = 5)

  map_data <- maps::map_data("state")
  state_rates <- obesity_by_state
  state_rates$region <- tolower(as.character(state_rates$state))
  map_joined <- dplyr::left_join(map_data, state_rates, by = "region")

  p_map <- ggplot2::ggplot(
    map_joined,
    ggplot2::aes(x = long, y = lat, group = group, fill = obesity_rate)
  ) +
    ggplot2::geom_polygon(linewidth = 0.2) +
    ggplot2::coord_fixed(1.3) +
    ggplot2::labs(title = "Observed obesity rate by state", fill = "Obesity rate") +
    ggplot2::theme_void()
  ggplot2::ggsave(file.path(output_dir, "obesity_rate_map.png"), p_map, width = 9, height = 6)

  list(
    obesity_by_state = obesity_by_state,
    joint_sex = prop.table(table(data$obesity_status, data$sex)),
    conditional_sex = prop.table(table(data$obesity_status, data$sex), 2),
    joint_age = prop.table(table(data$obesity_status, data$age5cat)),
    conditional_age = prop.table(table(data$obesity_status, data$age5cat), 2),
    joint_income = prop.table(table(data$obesity_status, data$income_group)),
    conditional_income = prop.table(table(data$obesity_status, data$income_group), 2)
  )
}
