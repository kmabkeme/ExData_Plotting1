## Script for reading in and processing household_power_consumption.txt
## and printing the composite plots in plot 4

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
## so for all of the plots in Plot 4, we subset for the places where character values 
## in the columns do not have that value (Sub_metering_3 column is already
## numeric, so it doesn't need this check).
dataInDateRange <- dataInDateRange[which(dataInDateRange$Global_active_power != "?"),]
dataInDateRange <- dataInDateRange[which(dataInDateRange$Sub_metering_1 != "?"),]
dataInDateRange <- dataInDateRange[which(dataInDateRange$Sub_metering_2 != "?"),]
dataInDateRange <- dataInDateRange[which(dataInDateRange$Global_reactive_power != "?"),]
dataInDateRange <- dataInDateRange[which(dataInDateRange$Voltage != "?"),]

## For the plot which repeats plot2, we need to convert the Global_active_power column to numbers
## We need to convert the two Sub_metering_X columns from character to numeric values for plotting
## And for the two new tables, we also need to convert Voltage and Global_reactive_power to numbers.
dataInDateRange$Global_active_power <- as.numeric(dataInDateRange$Global_active_power)
dataInDateRange$Sub_metering_1 <- as.numeric(dataInDateRange$Sub_metering_1)
dataInDateRange$Sub_metering_2 <- as.numeric(dataInDateRange$Sub_metering_2)
dataInDateRange$Global_reactive_power <- as.numeric(dataInDateRange$Global_reactive_power)
dataInDateRange$Voltage <- as.numeric(dataInDateRange$Voltage)

## Plot as plot4.png with the specified dimensions
png("plot4.png", width = 480, height = 480)

## Now, we set it up so that we will create a composite plot of 2 x 2 plots
par(mfrow=c(2,2))

## First, we replot what we did in plot2 as the plot in the upper left-hand corner
with(dataInDateRange, plot(DateTime, Global_active_power, type="l", xlab = "", ylab="Global Active Power (kilowatts)"))

## Next, we make the plot that goes in the upper right-hand corner
with(dataInDateRange, plot(DateTime, Voltage, type="l", xlab = "datetime", ylab="Voltage"))

## Third, we recreate plot3 in the lower left-hand corner
## Set type = "l" to use a line to draw the plot without symbols
with(dataInDateRange, plot(DateTime, Sub_metering_1, type="l", xlab = "", ylab="Energy sub metering"))
with(dataInDateRange, lines(DateTime, Sub_metering_2, col ="red"))
with(dataInDateRange, lines(DateTime, Sub_metering_3, col ="blue"))

## Add the legend to correlate the line plot colors with their respective column names
legend('topright', c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c('black', 'red', 'blue',' brown'), bty='o')

## Finally, the plot in the lower right-hand corner
with(dataInDateRange, plot(DateTime, Global_reactive_power, type="l", xlab = "datetime", ylab="Global_reactive_power"))

dev.off()


