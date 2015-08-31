##Suggested citation:
#Dasgupta S. (2014)  R code to calculate travel parameters between origin and destination points using Google Maps API.  Programs, Research, and Innovations in Sexual Minority Health (PRISM), Emory University.  Accessed [insert date].  



#installing necessary R packages to run analyses
install.packages("RJSONIO")
require(RJSONIO)

install.packages("jsonlite")
require("jsonlite")

install.packages("RCurl")
require(RCurl)

install.packages("ggmap")
require(ggmap)


#insert the file path for your csv input file in the quotes below
input_file <- read.csv(file = "...")

#gets rid of all rows with N/A values
input_file <- na.omit(input_file)

#here, we create an empty matrix with 9 columns - we'll fill in the matrix in the loop below
#insert the number of columns in your input file (ncol = 9)
traveloutput <- matrix(data = NA, nrow = nrow(input_file), ncol = 9) 

#loop through all observations in input file to calculate travel parameters based on Google maps API (ggmap R package)
for (i in 1:nrow(input_file)){
  #startTime <- Sys.time()
  
  #extracting the origin and destination coordinates
  #below, variables for origin and destination coordinates have been temporarily inputted as "origin_lat," "origin_long," "dest_lat," and "dest_long"
  #replace these variables with the variables corresponding to origin/destination xy coordinates in your dataset
  O <- paste(input_file$origin_lat[i], " ", input_file$origin_long[i])
  D <- paste(input_file$dest_lat[i], " ", input_file$dest_long[i])

  #here's where I ping the Google maps API using ggmaps (mapdist function)
  output <- mapdist(from = O, to = D, mode = "driving",override_limit = TRUE)
  
  #in addition to saving the outputs for travel parameters, let's also save the origin/destination points from the original input file.
  #below, I pull from the input dataset to obtain data on:
  #origin name, origin x, origin y, destination name, destination x, destination y, mode of travel
  #the last 2 variables [i,8] and [i,9] correspond to the travel parameters outputted from Google maps - distance and time
  #user should input the column number from input_file for first 6 lines below
  traveloutput[i,1] <- as.character(input_file[i,...]) #insert location of origin name
  traveloutput[i,2] <- input_file[i,...] #insert location of origin x
  traveloutput[i,3] <- input_file[i,...] #insert location of origin y
  traveloutput[i,4] <- as.character(input_file[i,...]) #insert location of destination name
  traveloutput[i,5] <- input_file[i,...] #insert location of destination x
  traveloutput[i,6] <- input_file[i,...] #insert location of destination y
  traveloutput[i,7] <- "driving" #insert mode of transit
  traveloutput[i,8] <- output$miles #distance in miles
  traveloutput[i,9] <- output$minutes #commmute time in minutes

  #keep track of the progress of the request...
  print(i)
  
}
output
  
#exporting matrix to a data table
colnames(traveloutput) <- c("origin", "origin_x", "origin_y", "destination", "destination_x", "destination_y", "travel_mode", "distance", "time")

#exporting data table to a csv output file
#input file path and name in quotes below
write.csv(traveloutput, file = "...", row.names = FALSE)
