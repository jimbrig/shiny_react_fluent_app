filters <- Stack(
  tokens = list(childrenGap = 10),
  Stack(
    horizontal = TRUE,
    tokens = list(childrenGap = 10),
    DatePicker("fromDate", value = as.Date('2020/01/01'), label = "From date"),
    DatePicker("toDate", value = as.Date('2020/12/31'), label = "To date")
  ),
  Label("Filter by sales reps", className = "my_class"),
  NormalPeoplePicker(
    "selectedPeople",
    className = "my_class",
    options = fluent_people,
    pickerSuggestionsProps = list(
      suggestionsHeaderText = 'Matching people',
      mostRecentlyUsedHeaderText = 'Sales reps',
      noResultsFoundText = 'No results found',
      showRemoveButtons = TRUE
    )
  ),
  Slider("slider",
         0,
         min = 0,
         max = 1000000,
         label = "Minimum amount",
         step = 100000,
         valueFormat = JS("function(x) { return '$' + x}"),
         snapToStep = TRUE),
  Toggle("closedOnly", value = TRUE, label = "Include closed deals only?")
)
