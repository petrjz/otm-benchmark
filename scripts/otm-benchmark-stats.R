##
# Outputs basic runtime statistic (mean, standard deviation, 95% confidence interval) for the specified combination of operation,
# heap size, and OTM provider.
#
# baseDir - base directory containing benchmark results (ending with a '/')
# operation - name of the operation corresponding to the pattern used in file names, i.e., one of create, create-batch, retrieve, retrieve-all, update, delete
# provider - provider name corresponding to the pattern used in file names, i.e., lowercase
# heap - heap size corresponding to the directory naming pattern, e.g., 32m, 1g
performance_stats <- function(baseDir, operation, provider, heap) {
  file <- paste(baseDir, sprintf("%s/%s-benchmark-%s.data", heap, provider, operation), sep='')
  print(file)
  tryres <- try(read.table(file, quote="\"", comment.char=""), silent = TRUE)
  if (class(tryres) == "try-error") {
    result <- list()
    result$mean <- NA
    return(result)
  }
  data <- read.table(file, quote="\"", comment.char="")
  result <- list()
  result$mean <- mean(data$V1)
  result$sd <- sd(data$V1)
  result$ci_lower <- result$mean - qnorm(0.975)*(result$sd/sqrt(300))
  result$ci_upper <- result$mean + qnorm(0.975)*(result$sd/sqrt(300))
  return(result)
}

# TODO: for each heap: for each operation
# heap: 32m, 64m, 128m, 512m, 1g
# operation: retrieve, read-only_retrieve, retrieve-all, read-only_retrieve-all
result <- performance_stats("/home/petrjz/ownCloud/master/codes/forks/otm-benchmark/data-new/", "read-only_retrieve-all" , "jopa", "1g")

print(result)
