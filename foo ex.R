foo <- data.frame(
  x = c(1, NA, 3, 4, NA),
  y = c(NA, 22, 33, 44, 55),
  z = c(100, 200, 300, NA, NA)
)
foo

is.na(foo)
sum(!is.na(foo))
