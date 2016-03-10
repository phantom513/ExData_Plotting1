url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Check if file is already downloaded/unzipped
if(!file.exists("exdata-data-household_power_consumption.zip")){
  download.file(url, destfile = "exdata-data-household_power_consumption.zip")
  unzip("exdata-data-household_power_consumption.zip")
}

## Load the data
mydata <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
mydata$Date <- as.Date(mydata$Date, format = "%d/%m/%Y")

## apply the limits of days
lowerLimit <- as.Date("2007-02-01")
upperLimit <- as.Date("2007-02-02") ## or "2007-02-03"? They want a two day period

## subset for the two day period
data <- subset(mydata, subset = mydata$Date <= upperLimit & mydata$Date >= lowerLimit)


fileUrl <- getwd()

## combine date times and reformat
new <- paste(data$Date, data$Time, sep = " ")	## paste the date and time together
fin <- strptime(new, "%Y-%m-%d %H:%M:%S")

## x-axis and y-axis
xdata <- as.numeric(fin)
ydata <- as.numeric(data$Global_active_power)

## new data with better date/time
data <- cbind(data, fin)

png(file = paste(fileUrl, "plot2.png", sep = "\\"), width = 480, height = 480)
plot(xdata, ydata, type = "l", axes = FALSE, ylab = "Global Active Power (kilowatts)", xlab = "")
axis(1, c(min(xdata), floor(mean(xdata)), max(xdata)), c("Thu", "Fri", "Sat"))	## first arg = 1 implies x-axis
axis(2, at = 0:3 * 1000, c(0,2,4,6))
box(lty = "solid")
dev.off()