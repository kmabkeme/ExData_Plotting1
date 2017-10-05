## Script for reading in and processing household_power_consumption.txt
## And creating plot 3

setwd("/Users/kristinabkemeier/DataScience/Exploratory Data Analysis - Assignment 1")

dataset <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE )

## Need dplyr for processing the columns
library(dplyr)

## Subset the dates - specify the bounds that I want first
DATE1 <- as.Date("2007-02-01")
DATE2 <- as.Date("2007-02-02")

## The format of the dates in the dataset is different from usual, so need to specify
## the format in the as.Date() conversion
dataInDateRange <- dataset[as.Date(dataset$Date, "%d/%m/%Y") >= DATE1 & 
                             as.Date(dataset$Date, "%d/%m/%Y") <= DATE2,]

## Remove the original dataset to free up memory
rm(dataset)

## Missing values are coded as "?" in this data set, per the instructions.
## We've already subsetted for only the dates that fall within the desired date range
## Now we need to check that all of the times are valid
dataInDateRange <- dataInDateRange[which(dataInDateRange$Time != "?"),]

## Concatenate the date and time for future time series plots, and then convert to POSIXlt type
## so that we can use the data for plotting
dataInDateRange$DateTime <- paste(as.Date(dataInDateRange$Date, "%d/%m/%Y"), dataInDateRange$Time, sep=" ")
dataInDateRange$DateTime <- strptime(dataInDateRange$DateTime, format="%Y-%m-%d %T")

## Missing values are coded as "?" in this data set, per the instructions,
## so for Plot 3, we subset for the places where values in the Sub_metering_1
## and Sub_metering_2 columns do not have that value (Sub_metering_3 column is already
## numeric, so it doesn't need this check)
dataInDateRange <- dataInDateRange[which(dataInDateRange$Sub_metering_1 != "?"),]
dataInDateRange <- dataInDateRange[which(dataInDateRange$Sub_metering_2 != "?"),]

## We need to convert the two Sub_metering_X columns from character to numeric values for plotting
dataInDateRange$Sub_metering_1 <- as.numeric(dataInDateRange$Sub_metering_1)
dataInDateRange$Sub_metering_2 <- as.numeric(dataInDateRange$Sub_metering_2)

## Plot as plot3.png with the specified dimensions
png("plot3.png", width = 480, height = 480)

## Set type = "l" to use a line to draw the plot without symbols
with(dataInDateRange, plot(DateTime, Sub_metering_1, type="l", xlab = "", ylab="Energy sub metering"))
with(dataInDateRange, lines(DateTime, Sub_metering_2, col ="red"))
with(dataInDateRange, lines(DateTime, Sub_metering_3, col ="blue"))

## Add the legend to correlate the line plot colors with their respective column names
legend('topright', c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c('black', 'red', 'blue',' brown'), bty='o')

dev.off()


