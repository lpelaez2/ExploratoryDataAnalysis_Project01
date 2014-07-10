#--------------------------------------------------------------------------------------------
# plot1.R
# Draw the first plot reqired on project assignment #1
#
# Steps:
#   *  Download file
#   *  Unzip downloaded file
#   *  Charge data to R
#   *  Subset data for required dates
#   *  Create histogram
#   *  Save plot as a PNG file
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

# Select only required data as numeric
#  For rows: 2007/02/01 and 2007/02/02
#  For columns: Global_active_power

selectedData <- as.numeric( rbind( subset(completeData, Date=="1/2/2007"), 
                                   subset(completeData, Date=="2/2/2007")
                                 )$Global_active_power
                          )
                    

# Draw required histogram and save as PNG
hist( selectedData, 
      col  = "red", 
      main = "Global Active Power", 
      xlab = "Global Active Power (kilowatts)"
    )

dev.copy( png,
          file ="./plot1.png")
dev.off()

