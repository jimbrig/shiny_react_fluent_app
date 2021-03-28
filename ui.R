header <- tagList(
  img(src = "images/placeholder_company_logo.jpg", class = "logo"),
  div(Text(variant = "xLarge", "Sales Reps Analysis"), class = "title"),
  CommandBar(
    items = list(
      CommandBarItem("New", "Add", subitems = list(
        CommandBarItem("Email message", "Mail", key = "emailMessage", href = "mailto:me@example.com"),
        CommandBarItem("Calendar event", "Calendar", key = "calendarEvent")
      )),
      CommandBarItem("Upload sales plan", "Upload"),
      CommandBarItem("Share analysis", "Share"),
      CommandBarItem("Download report", "Download")
    ),
    farItems = list(
      CommandBarItem("Grid view", "Tiles", iconOnly = TRUE),
      CommandBarItem("Info", "Info", iconOnly = TRUE)
    ),
    style = list(width = "100%")
  )
)

navigation <- Nav(
  groups = list(
    list(
      links = list(
        list(
          name = 'Home',
          url = '#!/',
          key = 'home',
          icon = 'Home'
        ),
        list(
          name = 'Analysis',
          url = '#!/other',
          key = 'analysis',
          icon = 'AnalyticsReport'
        ),
        list(
          name = 'shiny.fluent',
          url = 'http://github.com/Appsilon/shiny.fluent',
          key = 'repo',
          icon = 'GitGraph'
        ),
        list(
          name = 'shiny.react',
          url = 'http://github.com/Appsilon/shiny.react',
          key = 'shinyreact',
          icon = 'GitGraph'
        ),
        list(
          name = 'Appsilon',
          url = 'http://appsilon.com',
          key = 'appsilon',
          icon = 'WebAppBuilderFragment'
        )
      )
    )
  ),
  initialSelectedKey = 'home',
  styles = list(
    root = list(
      height = '100%',
      boxSizing = 'border-box',
      overflowY = 'auto'
    )
  )
)

footer <- Stack(
  horizontal = TRUE,
  horizontalAlign = 'space-between',
  tokens = list(childrenGap = 20),
  Text(variant = "medium", "Built by Jimmy Briggs 2021", block = TRUE),
  Text(variant = "medium", nowrap = FALSE, "If you'd like to learn more, reach out to me at jimbrig2011@outlook.com"),
  Text(variant = "medium", nowrap = FALSE, "All rights reserved.")
)


layout <- function(mainUI) {
  div(class = "grid-container",
      div(class = "header", header),
      div(class = "sidenav", navigation),
      div(class = "main", mainUI),
      div(class = "footer", footer)
  )
}

card1 <- make_card(
  "Welcome to shiny.fluent demo!",
  div(
    Text("shiny.fluent is a package that allows you to build Shiny apps using Microsoft's Fluent UI."),
    Text("Use the menu on the left to explore live demos of all available components.")
  ))

card2 <- make_card(
  "shiny.react makes it easy to use React libraries in Shiny apps.",
  div(
    Text("To make a React library convenient to use from Shiny, we need to write an R package that wraps it - for example, a shiny.fluent package for Microsoft's Fluent UI, or shiny.blueprint for Palantir's Blueprint.js."),
    Text("Communication and other issues in integrating Shiny and React are solved and standardized in shiny.react package."),
    Text("shiny.react strives to do as much as possible automatically, but there's no free lunch here, so in all cases except trivial ones you'll need to do some amount of manual work. The more work you put into a wrapper package, the less work your users will have to do while using it.")
  ))

home_page <- make_page(
  "This is a Fluent UI app built in Shiny",
  "shiny.react + Fluent UI = shiny.fluent",
  div(card1, card2)
)

analysis_page <- make_page(
  "Sales representatives",
  "Best performing reps",
  div(
    Stack(
      horizontal = TRUE,
      tokens = list(childrenGap = 10),
      make_card("Filters", filters, size = 4, style = "max-height: 320px"),
      make_card("Deals count", plotlyOutput("plot"), size = 8, style = "max-height: 320px")
    ),
    uiOutput("analysis")
  )
)

# router ------------------------------------------------------------------

router <- make_router(
  route("/", home_page),
  route("other", analysis_page)
)


# add shiny.router dependencies manually ----------------------------------
# they ar not picked up because they are added in a non-standard way
# Add shiny.router dependencies manually: they are not picked up because they're added in a non-standard way.
shiny::addResourcePath("shiny.router", system.file("www", package = "shiny.router"))
shiny_router_js_src <- file.path("shiny.router", "shiny.router.js")
shiny_router_script_tag <- shiny::tags$script(type = "text/javascript", src = shiny_router_js_src)


ui <- fluentPage(
  tags$head(
    tags$link(href = "styles.css", rel = "stylesheet", type = "text/css"),
    shiny_router_script_tag
  ),
  withReact(layout(router$ui))
)

