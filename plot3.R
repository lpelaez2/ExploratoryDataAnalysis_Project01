#--------------------------------------------------------------------------------------------
# plot3.R
# Draw the third plot reqired on project assignment #1
#
# Steps:
#   *  Download file
#   *  Unzip downloaded file
#   *  Charge data to R
#   *  Subset data for required dates
#   *  Create plot and insert lines for sub metering
#   *  Save plot as a PNG file
#--------------------------------------------------------------------------------------------
# NOTE:
# Because I'm spanish speaker and my machine is in spanish, on plot2.PNG I've shared (in github) 
# the x axis are in spanish.
# Note those equivalences:
#   * jue --> Thu 
#   * vie --> Fri 
#   * sab --> Sat
#--------------------------------------------------------------------------------------------

# libraries required
library(data.table)

# set several variables
sourceFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
targetFile <- "./data.zip"
dataFile   <- "./household_power_consumption.txt"

# download compressed file using mode wb to preserve as binary type
download.file( sourceFile, 
               destfile=targetFile, 
               method="auto", 
               mode="wb"
)       

# uncompress file
unzip( targetFile, 
       exdir = ".", 
       overwrite = TRUE 
)

# Charge data into R using fread for performance 
completeData <- fread( dataFile,
                       header = "auto",
                       sep = ";",
                       na.strings = "?",
                       verbose= FALSE,
                       colClasses = c("character", "character", "character", "character", "character", "character", "character", "character", "character" )
                )

# Select only required data for 2007/02/01 and 2007/02/02
selectedData <- rbind( subset(completeData, Date=="1/2/2007"), 
                       subset(completeData, Date=="2/2/2007")
                )

xaxis <- strptime( paste(selectedData$Date,selectedData$Time), 
                   format="%d/%m/%Y %H:%M:%S", 
                   tz="GMT"
         )

# Draw required (metering lines) and save as PNG
par(mfrow = c(1,1))

plot( xaxis,
      selectedData$Sub_metering_1,
      type = "l",
      xlab = "",
      ylab = "Energy sub metering"     
)

lines( xaxis,
       selectedData$Sub_metering_2,
       col = "red"
)

lines( xaxis,
       selectedData$Sub_metering_3,
       col = "blue"
)

legend( "topright", 
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        lty = 1,
        col = c("black","red","blue"),
)


dev.copy( png, file ="./plot3.png", width = 480, height = 480)
dev.off()

