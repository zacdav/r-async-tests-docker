library(future)
library(promises)
library(microbenchmark)
plan(multiprocess)

# sleep function
sleepy_time <- function(x = 3) {
    s <- Sys.time()
    Sys.sleep(x)
    as.numeric(round(Sys.time() - s, 2))
}

# different scenarios
sequential_test <- function(n) {
    for (i in sequence(n)) sleepy_time()
    1
}

async_test <- function(n) {
    # all in same thread
    calls <- list()
    for (i in sequence(n)) {
        calls[[i]] <- future(sleepy_time())
    }
    lapply(calls, resolve)
    1
}

# compare
microbenchmark(
    "sequential" = sequential_test(10),
    "async" = async_test(10),
    times = 1
)




