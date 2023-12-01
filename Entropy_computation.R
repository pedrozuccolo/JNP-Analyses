library(tidyr)
library(tidyverse)

# Long format data frame
long_df <- data.frame(subject = c(rep("A", 100), rep("B", 100), rep("C", 100)),
                      time = c(1:100, 1:100, 1:100),
                      value = rnorm(300))

glimpse(long_df)


# Reshape data into wide format
wide_df <- long_df %>%
  pivot_wider(names_from = subject, values_from = value)

