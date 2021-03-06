#' R + mermaid.js
#'
#' Make diagrams in R using \href{https://github.com/knsv/mermaid/wiki}{mermaid.js}
#' with infrastructure provided by \href{http://www.htmlwidgets.org/}{htmlwidgets}.
#' 
#' @param diagram string diagram in mermaid markdown-like language.
#' If no diagram is provided \code{diagram = ""} then the function will assume that
#' a diagram will be provided by \code{\link[htmltools]{tags}} and
#' \code{DiagrammeR} is just being used for dependency injection.
#' @return An object of class \code{htmlwidget} that will
#' intelligently print itself into HTML in a variety of contexts
#' including the R console, within R Markdown documents,
#' and within Shiny output bindings.
#' @examples 
#' # note the whitespace is not important
#' DiagrammeR("
#'   graph LR;
#'     A-->B;
#'     A-->C;
#'     C-->E;
#'     B-->D;
#'     C-->D;
#'     D-->F;
#'     E-->F;
#' ")
#' 
#' DiagrammeR("
#'    graph TB;
#'    A-->B;
#'    A-->C;
#'    C-->E;
#'    B-->D;
#'    C-->D;
#'    D-->F;
#'    E-->F;
#' ")
#' 
#' DiagrammeR("graph LR;A(Rounded)-->B[Squared];B-->C{A Decision};
#'  C-->D[Square One];C-->E[Square Two];
#'  style A fill:#E5E25F;  style B fill:#87AB51; style C fill:#3C8937;
#'  style D fill:#23772C;  style E fill:#B6E6E6;"
#' )
#' 
#' # Load in the 'mtcars' dataset
#' data(mtcars)
#' connections <- sapply(
#'  1:ncol(mtcars)
#'   ,function(i){
#'      paste0(
#'         i
#'       ,"(",colnames(mtcars)[i],")---"
#'       ,i,"-stats("
#'       ,paste0(
#'         names(summary(mtcars[,i]))
#'         ,": "
#'         ,unname(summary(mtcars[,i]))
#'         ,collapse="<br/>"
#'       )
#'       ,")"
#'    )
#'  }
#' )
#' 
#' DiagrammeR(
#'    paste0(
#'      "graph TD;", "\n",
#'      paste(connections, collapse = "\n"),"\n",
#'      "classDef column fill:#0001CC, stroke:#0D3FF3, stroke-width:1px;" ,"\n",
#'      "class ", paste0(1:length(connections), collapse = ","), " column;"
#'    )
#'  )
#'
#' # also with DiagrammeR() you can use tags from htmltools
#' # just make sure to use class = "mermaid"
#' library(htmltools)
#' diagramSpec = "
#' graph LR;
#'   id1(Start)-->id2(Stop);
#'   style id1 fill:#f9f,stroke:#333,stroke-width:4px;
#'   style id2 fill:#ccf,stroke:#f66,stroke-width:2px,stroke-dasharray: 5, 5;
#' "
#' html_print(tagList(
#'   tags$h1("R + mermaid.js = Something Special")
#'   ,tags$pre(diagramSpec)
#'   ,tags$div(class="mermaid",diagramSpec)
#'   ,DiagrammeR()
#' ))
#'  
#' @import htmlwidgets
#'
#' @export
DiagrammeR <- function(diagram = "", width = NULL, height = NULL) {

  # forward options using x
  x = list(
    diagram = diagram
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'DiagrammeR',
    x,
    width = width,
    height = height,
    package = 'DiagrammeR'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
DiagrammeROutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'DiagrammeR', width, height, package = 'DiagrammeR')
}

#' Widget render function for use in Shiny
#'
#' @export
renderDiagrammeR <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, DiagrammeROutput, env, quoted = TRUE)
}
