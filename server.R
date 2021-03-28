server <- function(input, output, session) {

  router$server(input, output, session)

  filtered_deals <- reactive({
    if (!is.null(input$selectedPeople) && input$selectedPeople != "") {
      selectedPeopleKeys <- input$selectedPeople
    } else {
      selectedPeopleKeys <- list()
    }
    if (length(selectedPeopleKeys) == 0) {
      selectedPeopleKeys <- fluent_people$key
    }
    minClosedVal <- if (input$closedOnly == TRUE)
      1
    else
      0
    filtered_deals <- fluent_sales_deals %>%
      filter(
        rep_id %in% selectedPeopleKeys,
        date >= input$fromDate,
        date <= input$toDate,
        deal_amount >= input$slider,
        is_closed >= minClosedVal
      ) %>%
      mutate(is_closed = ifelse(is_closed == 1, "Yes", "No"))
  })

  output$map <- renderLeaflet({
    points <- cbind(filtered_deals()$LONGITUDE, filtered_deals()$LATITUDE)

    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite, options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(data = points)
  })

  output$plot <- renderPlotly({

    p <- ggplot(filtered_deals(), aes(x = rep_name)) +
      geom_bar(fill = unique(filtered_deals()$color)) +
      ylab("Number of deals") +
      xlab("Sales rep") +
      theme_light()

    ggplotly(p, height = 300)

  })

  output$analysis <- renderUI({
    items_list <- if (nrow(filtered_deals()) > 0) {
      DetailsList(items = filtered_deals(), columns = details_list_columns)
    } else {
      p("No matching transactions.")
    }

    withReact(
      Stack(
        tokens = list(childrenGap = 10),
        horizontal = TRUE,
        make_card(
          "Top results",
          div(style = "max-height: 500px; overflow: auto", items_list)
        ),
        make_card("Map", leafletOutput("map"))
      )
    )
  })
}
