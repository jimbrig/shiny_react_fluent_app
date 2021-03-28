make_page <- function(title, subtitle, contents) {
  tagList(
    div(
      class = "page-title",
      span(
        title,
        class = "ms-fontSize-32 ms-fontWeight-semibold",
        style = "color: #323130"
      ),
      span(
        subtitle,
        class = "ms-fontSize-14 ms-fontWeight-regular",
        style = "color: #605E5C; margin: 14px;"
      )
    ),
    contents
  )
}
