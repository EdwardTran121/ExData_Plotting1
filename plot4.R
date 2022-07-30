# set up packages
library('lubridate')
library('dplyr')

# get the link for zip file
link_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file <- 'electric_data_household_power_consumption.zip'

# check zip file existence and download
if(!file.exists(zip_file)){
  download.file(link_url, zip_file, mode = 'wb')
}

# check file existence and unzip
data_path = 'household_power_consumption'
if(!file.exists(data_path)){
  unzip(zip_file)
}

# read data
power_df <- read.table(file.path('household_power_consumption.txt'), sep = ';', header = TRUE, na.strings = '?')

# change format of data
power_df$Date <- strptime(power_df$Date, "%d/%m/%Y")

# filter data
usage_df <- power_df %>% 
  filter((Date >= '2007-02-01') & (Date < '2007-02-03')) %>% 
  mutate(DateTime = as.POSIXct(paste(Date, Time), format = "%Y-%m-%d %H:%M:%S"))

# make plot
par(mfrow = c(2,2))
with(usage_df, {
  plot(usage_df$Global_active_power ~ usage_df$DateTime, type = 'l', 
       ylab = 'Global Active Power (kilowatts)', xlab = '')
  
  plot(Voltage ~ DateTime, type = 'l', xlab = 'datetime')
  
  plot(Sub_metering_1 ~ DateTime, type = 'l', 
       ylab = 'Energy sub metering', xlab = '')
  lines(Sub_metering_2 ~ DateTime, col = 'red')
  lines(Sub_metering_3 ~ DateTime, col = 'blue')
  legend('topright', col = c('black', 'red', 'blue'), lwd = 1, cex = 0.8, bty = 'n',
         legend = c('Sub_metering_1', 'Sub_metering_2','Sub_metering_3'))
  
  plot(Global_reactive_power ~ DateTime, type = 'l', xlab = 'datetime')
})

# add legend


dev.copy(png, file = 'plot4.png', height = 480, width = 480)
dev.off()