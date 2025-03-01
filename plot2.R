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
plot(usage_df$Global_active_power ~ usage_df$DateTime, type = 'l', 
     ylab = 'Global Active Power (kilowatts)', xlab = '')

dev.copy(png, file = 'plot2.png', height = 480, width = 480)
dev.off()