### ~~~~~ 1. Preliminary work (getting & cleaning data) ~~~~~ ###

setwd("C:\\R\\exploratory data project")
power_cons <- read.table(file=".\\household_power_consumption.txt", 
                         header=FALSE, sep=";", skip=1, 
                         col.names=c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", 
                                     "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#search "?" and it replace into NA. The replacement method didn't work for factors, 
#so I have had to set all variables in data frame as characters.
power_cons[] <- lapply(power_cons, as.character)
power_cons[power_cons=="?"]<-NA

#modify variable Date into date class

power_cons[,1] <- as.Date(power_cons[,1], format="%d/%m/%Y")

#subset to following dates: 2007-02-01 and 2007-02-02
power <- subset(power_cons, Date == "2007-02-01"| Date == "2007-02-02")
str(power)
head(power)

#modify 7 variables (Global_active_power, Global_reactive_power, Voltage, Global_intensity, Sub_metering_1, 
#Sub_metering_2, Sub_metering_3) into numeric class

for (i in 3:9) {
  power_cons[,i] <- as.numeric(power_cons[,i])
}

#add variable that contains date and time
d <- as.character(power[,1])
t1 <- paste(d, power$Time)
power$date_time <- strptime(t1, format="%Y-%m-%d %H:%M:%S", tz= "GMT")
str(power)

#I need following code line, because otherwise the week days will be written in my native
#language, not in English. The function might not work for other systems then Windows.
Sys.setlocale("LC_TIME", "English")

### ~~~~~ 2. Plot 4 preparation ~~~~~ ###

png(file="plot4.png")
par(mfcol=c(2,2))
par(col="black")

#1st
with(power, plot(date_time, Global_active_power, type="l", ylab="Global Active Power", xlab=""))
#2nd
with(power, plot(date_time, Sub_metering_1, type="l", ylab="Energy sub metering",
                 xlab=""))
par(col="red")
with(power, lines(date_time, Sub_metering_2))
par(col="blue")
with(power, lines(date_time, Sub_metering_3))
legend("topright", cex =0.5, lty=c(1,1,1), col=c("black", "red", "blue"),
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

par(col="black")

#3rd
with(power, plot(date_time, Voltage, type="l", ylab="Voltage",
                 xlab="datetime"))

#4th
with(power, plot(date_time, Global_reactive_power, type="l", ylab="Global_reactive_power",
                 xlab="datetime"))

dev.off()