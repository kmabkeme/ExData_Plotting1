## Script for reading in and processing household_power_consumption.txt
## And creating plot 1

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

## Missing values are coded as "?" in this data set, per the instructions,
## so for Plot 1, we subset for the places where values in the Global_active_power column
## do not have that value
dataInDateRange <- dataInDateRange[which(dataInDateRange$Global_active_power != "?"),]

## We need to convert the column from character to numeric values for plotting
dataInDateRange$Global_active_power <- as.numeric(dataInDateRange$Global_active_power)

## Plot as plot1.png with the specified dimensions
png("plot1.png", width = 480, height = 480)
hist(dataInDateRange$Global_active_power, col="red", main="Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.off()


