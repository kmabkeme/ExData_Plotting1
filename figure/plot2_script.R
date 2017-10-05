## Script for reading in and processing household_power_consumption.txt
## And creating plot 2 for the R assignment #1

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
## so for Plot 2, we subset for the places where values in the Global_active_power column
## do not have that value
dataInDateRange <- dataInDateRange[which(dataInDateRange$Global_active_power != "?"),]

## We need to convert the Global_active_power column from character to numeric values for plotting
dataInDateRange$Global_active_power <- as.numeric(dataInDateRange$Global_active_power)

## Plot as plot2.png with the specified dimensions
png("plot2.png", width = 480, height = 480)

## Set type = "l" to use a line to draw the plot without symbols
with(dataInDateRange, plot(DateTime, Global_active_power, type="l", xlab = "", ylab="Global Active Power (kilowatts)"))

dev.off()


