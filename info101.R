library(ggplot2)
library(marinecs100b)


# Questionable organization choices ---------------------------------------

# P1 Call the function dir() at the console. This lists the files in your
# project's directory. Do you see woa.csv in the list? (If you don't, move it to
# the right place before proceeding.)
dir()
# I didn't initially see it, added to the directory for info101. Now I see it.

# P2 Critique the organization of woa.csv according to the characteristics of
# tidy data. The data is not in a rectangle, so it is going to be hard for the
# computer to read. Honestly, it's difficult for me to read as a human. I don't
# know what the "and values at depths" even refers to, and the title of the
# columns to the right are numbers. It's killing my brain.


# Importing data ----------------------------------------------------------

# P3 P3 Call read.csv() on woa.csv. What error message do you get? What do you
# think that means?
read.csv("woa.csv")
# Error in read.table((file = file, header = header, sep = sep, quote = quote, :
# more columns than column names) I think it means that the computer can't work
# with the data because it is not organized in a tidy way that it can read. ie,
# there are more columns than names, because the title of some of the columns
# are numbers.

# P4 Re-write the call to read.csv() to avoid the error in P3.
# Installing new stuff for the day
remotes::install_github("MarineCS-100B/marinecs100b")
#Now time for the problem
woa_wide <- read.csv("woa.csv", skip = 1)

# Fix the column names ----------------------------------------------------

# P5 Fill in the blanks below to create a vector of the depth values.

depths <- c(
  seq(0, 100, by = 5),
  seq(125, 500, by = 25),
  seq(550, 2000, by = 50),
  seq(2100, 5500, by = 100)
)

?seq()

# P6 Create a vector called woa_colnames with clean names for all 104 columns.
# Make them the column names of your WOA data frame.
woa_colnames <- c("latitude", "longitude", paste0("depth_", depths))

colnames(woa_wide) <- woa_colnames

#Example
foo <- data.frame(a = 1, b = 2, c = 3)
colnames(foo) <- c("x", "y", "z")
foo

#Example
paste0("dog", c("cat", "tiger", "lion"))

# Analyzing wide-format data ----------------------------------------------

# P7 What is the mean water temperature globally in the twilight zone (200-1000m
# depth)?
twilight_rows <- woa_wide[ , 27:49]
sum_twilight_rows <- sum(twilight_rows, na.rm = TRUE)
twilight_non_na <- sum(!is.na(twilight_rows))
mean_temp <- sum_twilight_rows / twilight_non_na
#6.57
# need to pull out temperature values from depth_200 to depth_1000 and take the
# average of those
# pull the rows from the column numbers
# sum the rows
# divide by number of values -- 49-27
# get the avg temp

"depth_200" <= "depth_1000"
?mean
nrow(twilight_rows)
# 40564
ncol(twilight_rows)
# 23

# Analyzing long-format data ----------------------------------------------

# P8 Using woa_long, find the mean water temperature globally in the twilight zone.
View(woa_long)
# get on track: find rows and columns needed (this pulls values at all of the
# columns where the depth values match, not just temp_c! (I think) so gotta
# filter at some point)
twilight_temps_long <- woa_long[woa_long$depth_m >= 200 & woa_long$depth_m <= 1000, "temp_c"]
mean(twilight_temps_long)

#6.57

# P9 Compare and contrast your solutions to P7 and P8. The answers are the same
# but the methodology was much more intuitive on P8 and used less code.

# P10 Create a variable called mariana_temps. Filter woa_long to the rows in the
# location nearest to the coordinates listed in the in-class instructions.
# Converting latitude/longitude from degrees to decimal: add minutes (2nd
# number) / 60
# Change to 0.5 in decimal place because this is the closest to the data
mariana_temps <- woa_long[woa_long$latitude == 11.5 & woa_long$longitude == 142.5, ]

# P11 Interpret your temperature-depth profile. What's the temperature at the
# surface? How about in the deepest parts? Over what depth range does
# temperature change the most?

# The temperature at the surface is 28 degrees Celsius and at the deepest point
# it's about 2 degrees Celsius. The largest temperature chance is from 0 to 1000
# meters of depth.

# ggplot is a tool for making figures, you'll learn its details in COMM101
ggplot(mariana_temps, aes(temp_c, depth_m)) +
  geom_path() +
  scale_y_reverse()
