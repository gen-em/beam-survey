create_likert_5_table <- function(filtered_data, selected_columns, column_names, labels) {
  # Create initial subset and prepare labels
  filtered_data_subset <- filtered_data %>%
    dplyr::select(all_of(selected_columns)) %>%
    setNames(column_names)
  
  labels_reversed <- setNames(names(labels), labels)
  
  # Generate and transform table
  filtered_data_subset %>%
    pivot_longer(
      cols = everything(),
      names_to = "Abfrage",
      values_to = "rating"
    ) %>%
    filter(!is.na(rating), rating %in% 1:5) %>%  # Remove NAs and ensure only values 1-5
    count(Abfrage, rating) %>%
    complete(
      Abfrage,
      rating = 1:5,
      fill = list(n = 0)
    ) %>%
    pivot_wider(
      names_from = rating,
      values_from = n,
      values_fill = 0
    ) %>%
    mutate(across(everything(), ~replace_na(., 0))) %>%
    rename_with(~labels[.x], matches("^[1-5]$"))
}

create_likert_5_plot <- function(filtered_data, selected_columns, column_names, plot_title, 
                                 brewer_palette, minimum_label_percentage, labels, show_y_labels = TRUE) {
  # Data Preparation
  filtered_data_subset <- filtered_data %>%
    dplyr::select(all_of(selected_columns)) %>%
    setNames(column_names)
  
  # Transform data for plotting, excluding NAs
  filtered_data_long <- filtered_data_subset %>%
    pivot_longer(
      cols = everything(),
      names_to = "Category",
      values_to = "Response"
    ) %>%
    filter(!is.na(Response), Response %in% 1:5)  # Remove NAs and ensure only values 1-5
  
  # Calculate Response Percentages
  response_summary <- filtered_data_long %>%
    group_by(Category) %>%
    mutate(Total = n()) %>%
    group_by(Category, Response) %>%
    summarise(
      Count = n(),
      Total = first(Total),
      Percentage = (Count / Total) * 100,
      .groups = "drop"
    ) %>%
    ungroup()
  
  # Color and Label Setup
  brewer_colors <- brewer.pal(n = 9, name = brewer_palette)
  cols <- setNames(brewer_colors[2:6], as.character(1:5))
  
  custom_labels <- function(labels, colors) {
    sapply(1:length(labels), function(i) {
      paste0("<span style='color:", colors[i], ";'>", labels[i], "</span>")
    })
  }
  
  formatted_labels <- custom_labels(
    labels = labels[as.character(1:5)],  # Use original label order
    colors = cols[as.character(1:5)]     # Use matching colors
  )
  
  # Sort categories by total percentage of highest ratings (5)
  category_order <- response_summary %>%
    filter(Response == 5) %>%
    arrange(desc(Percentage)) %>%
    pull(Category)
  
  # Data Processing
  df_responses <- response_summary %>%
    group_by(Category) %>%
    mutate(
      Category = factor(Category, levels = category_order),
      Response = factor(Response, levels = 1:5),
      Cumulative = cumsum(Percentage),
      MidPoint = Cumulative - Percentage/2,
      Label = ifelse(
        Percentage >= minimum_label_percentage,
        paste0(round(Percentage, 1), "%"),
        ""
      )
    ) %>%
    ungroup()
  
  # Create Plot
  ggplot(df_responses, 
         aes(x = Category, 
             y = Percentage,
             fill = Response)) +
    geom_col(position = position_stack(reverse = TRUE), width = 0.7) +
    geom_text(aes(y = MidPoint,
                  label = Label),
              size = 3.5) +
    scale_fill_manual(values = cols,
                      labels = formatted_labels,
                      drop = TRUE) +
    guides(fill = guide_legend(title = NULL, 
                               nrow = 1,
                               byrow = FALSE,
                               reverse = FALSE,
                               override.aes = list(fill = NA))) +
    scale_y_continuous(limits = c(0, 100),
                       expand = c(0, 0),
                       labels = ~paste0(.x, "%")) +
    theme_bw() +
    theme(
      panel.grid.major.y = element_blank(),
      legend.text = element_markdown(size = 10, face = "bold"),
      legend.position = "top",
      axis.title = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = if(show_y_labels) element_text(size = 10) else element_blank(),
      axis.ticks.y = if(show_y_labels) element_line() else element_blank(),
      plot.title = element_text(
        hjust = 0.5,
        vjust = 1,
        size = 12,
        face = "bold"
      )
    ) +
    ggtitle(plot_title) +
    coord_flip()  # Flip the axes for horizontal orientation
}