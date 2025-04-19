##
# Generates boxplot of performance comparsion results
#
# The plots are not directly saved because there was a problem with the pdf output causing the plots to be distorted. Thus, the have to
# be exported manually
# 
# dataset - dataset for one heap size loaded into R from a corresponding CSV file
# heap - heap size specification. Used only for plot title
# withTitle - whether the plot title should be rendered
##
performance_boxplot <- function(dataset, heap, withTitle) {
  y_step <- 5000
  y_max <- max(dataset$time, na.rm = TRUE)
  dataset$operation_f <- factor(dataset$operation, levels = c('OP1 - Retrieve', 'OP2 - Retrieve all'))
  # Round up to the closest multiple of y_step
  y_max <- y_step * (y_max %% y_step + as.logical(y_max %% y_step))
  if (withTitle) {
    # Appendix plots have plot title specifying heap size.
    ggplot(data=dataset, aes(y=time, x=provider)) + geom_boxplot(outlier.shape = 3) +
      facet_grid(. ~ dataset$operation_f) + scale_fill_grey() + theme_bw() + scale_x_discrete(name='Transaction mode') + 
      scale_y_continuous(name='Time (ms)', breaks = seq(0, y_max, 100)) + 
      theme(text = element_text(size = 16), plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle=-70, hjust=0)) +
      ggtitle(paste("Heap size", heap, sep=' - '))
  } else {
    # Main text plot does not need title, it is specified in text.
    ggplot(data=dataset, aes(y=time, x=provider)) + geom_boxplot(outlier.shape = 3) + 
      facet_grid(. ~ dataset$operation_f) + scale_fill_grey() + theme_bw() + scale_x_discrete(name='Transaction mode') + 
      scale_y_continuous(name='Time (ms)', breaks = seq(0, y_max, 100)) + 
      theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle=-70, hjust=0))
  }
}


install.packages("ggplot2")  # Run this once if you haven't installed it
library(ggplot2)

dataset <- read.csv("general-cache.csv")

performance_boxplot(dataset, '1G', TRUE)
