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

numGlobal <- as.numeric(as.character(data$Global_active_power))

## first plot
png(file = paste(fileUrl, "plot1.png", sep = "\\"), width = 480, height = 480)
hist(as.numeric(numGlobal), col = "red", main = "Gobal Active Power", xlab = "Global Active Power (kilowatts)", axes = TRUE)
dev.off()