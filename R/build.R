#' render Rmarkdown
#'
#' @export
render <- function(fp, out="doc") {
  rmarkdown::render(fp, output_format = "all", output_dir = out)
}

#' build all reports
#'
#' @export
report <- function() {
  fps <- list.files("reports", pattern="*.Rmd", full.names=T)
  for (fp in fps) render(fp)
}

#' build vignettes with either devtools or bookdown
#'
#' @export
build <- function(type="vignette", move=T, pkg="vgnttr") {
  if(type == "vignette") {
    # ==> doc.(pdf|tex|R|Rmd)
    devtools::build_vignettes(quiet=F, install=F, clean=F)
    if(move) {
        success <- post_vignette()
        if(success) cat(paste("all done!\n")) else cat(paste("something went wrong!\n"))
    }
  }
  if (type == "bookdown") {
    # ==> doc.(pdf|tex)
    parent <- getwd()
    vignettes <- system.file("vignettes", package=pkg)
    setwd(vignettes)
    bookdown::render_book("main.Rmd")
    setwd(parent)
  }
  if (type != "vignette" & type != "bookdown") {
      cat("failed to build bsc document!\n")
      cat("need to specify type: 'vignette' or 'bookdown'\n")
  }
}

post_vignette <- function() {
    # check if out dir exists
    if (!dir.exists("inst/book")) {
      cat("create dir inst/book...\n")
      dir.create("inst/book", recursive=T)
    }
    # we assume the build was successfull
    done <- T
    # move .pdf file to inst/book
    if(!file.copy("doc/main.pdf","inst/book/doc.pdf", overwrite=T)) done <- F
    if(done) {
        rmv <- file.remove("doc/main.pdf")
        if (rmv) cat(paste("Moved main.pdf to inst/book/ as doc.pdf\n")) else done <- F
    }
    # move .R file to inst/book
    if(!file.copy("doc/main.R","inst/book/doc.R", overwrite=T)) done <- F
    if(done){
      rmv <- file.remove("doc/main.R")
      if(rmv) cat(paste("Moved main.R to inst/book/ as doc.R\n")) else done <- F
    }
    # move .Rmd file to inst/book
    if(!file.copy("doc/main.Rmd","inst/book/doc.Rmd", overwrite=T)) done <- F
    if(done) {
        rmv <- file.remove("doc/main.Rmd")
        if (rmv) cat(paste("Moved main.Rmd to inst/book/ as doc.Rmd\n")) else done <- F
    }
    # move .tex file to inst/book
    if(!file.copy("vignettes/main.tex","inst/book/doc.tex", overwrite=T)) done <- F
    if(done) {
        rmv <- file.remove("vignettes/main.tex")
        if (rmv) cat(paste("Moved main.tex to inst/book/ as doc.tex\n")) else done <- F
    }
    if(!done) {
      # something went wrong...
      cat("could not fully move vignette output!\n")
      F
    } else {
      # clean up if everything is done
      # unlink("doc/", recursive=T)
      unlink("vignettes/main_files/", recursive=T)
      T
    }
}
