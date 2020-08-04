library(plumber)
library(promises)
library(future)

future::plan("multiprocess")

#* @apiTitle Async Plumber


#' On Success
#'
#' @param data the return value
#'
#' @details used in conjunction with `promises::then()`
#'
#' @return
#' @export
on_success <- function(data) {
  list(
    status = jsonlite::unbox(200),
    data = data
  )
}

#' On Failure
#'
#' @param error an error e.g. `stop()`
#'
#' @details used in conjunction with `promises::then()`
#'
#' @return
#' @export
on_failure <- function(error) {
  list(
    status = jsonlite::unbox(500),
    error = jsonlite::unbox(error$message)
  )
}


sleepy_time <- function(x = 3) {
  s <- Sys.time()
  Sys.sleep(x)
  paste0(
    "finished at: ", Sys.time(),
    "; time taken: ", as.numeric(round(Sys.time() - s, 2)),
    "; pid: ", Sys.getpid()
  )
}

#* Block for X seconds
#* @param x time in seconds to block
#* @get /block-async
function(x = 3) {
  future::future({
    sleepy_time(x)  
  }) %>%
    promises::then(
      onFulfilled = on_success,
      onRejected = on_failure
    )
}

#* Block for X seconds
#* @param x time in seconds to block
#* @get /block
function(x = 3) {
  sleepy_time(x)  
}