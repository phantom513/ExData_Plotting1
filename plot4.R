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

## new data with better date/time
data <- cbind(data, fin)

## translating to numerics for sub metering 1
numSub1 <- as.numeric(as.character(data$Sub_metering_1))
numSub2 <- as.numeric(as.character(data$Sub_metering_2))
numSub3 <- as.numeric(as.character(data$Sub_metering_3))

## translating to numerics the voltage
numVolt <- as.numeric(as.character(data$Voltage))

## [ 1,1 1,2]
## [ 2,1 2,2]

png(file = paste(fileUrl, "plot4.png", sep = "\\"), width = 480, height = 480)
## open the graphics device
par(mfrow = c(2,2), bg = "white")

## plot (1,1)
plot(xdata, ydata, type = "l", axes = FALSE, ylab = "Global Active Power (kilowatts)", xlab = "")
axis(1, c(min(xdata), floor(mean(xdata)), max(xdata)), c("Thu", "Fri", "Sat"))	## first arg = 1 implies x-axis
axis(2, at = 0:3 * 1000, c(0,2,4,6))
box(lty = "solid")

## plot (1,2)
plot(xdata, as.numeric(numVolt), type = "l", ylab = "Voltage", xlab = "datetime", axes = FALSE)
axis(1, c(min(xdata), floor(mean(xdata)), max(xdata)), c("Thu", "Fri", "Sat"))
axis(2)
box(lty ="solid")

## plot (2,1)
plot(xdata, as.numeric(numSub1), type= "l", axes = FALSE, ylab = "Energy sub metering", xlab = "")
lines(xdata, as.numeric(numSub2), col = "red")	## or strSub2
lines(xdata, as.numeric(numSub3), col = "blue")
axis(1, c(min(xdata), floor(mean(xdata)), max(xdata)), c("Thu", "Fri", "Sat"))	## first arg = 1 implies x-axis
axis(2)
legend("topright",c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"), lty = c(1,1,1), lwd = c(2,2,2) ,col = c("black", "red","blue"))
box(lty = "solid")

# plot (2,2)
numReactive <- as.numeric(as.character(data$Global_reactive_power))
plot(xdata, as.numeric(numReactive), type = "l", axes = FALSE, ylab = "Global_reactive_power", xlab = "datetime")
axis(1, c(min(xdata), floor(mean(xdata)), max(xdata)), c("Thu", "Fri", "Sat"))
axis(2)
box(lty = "solid")
#dev.copy(png, file = paste(fileUrl, "plot4.png", sep ="\\"), height = 480, width = 480)
dev.off()