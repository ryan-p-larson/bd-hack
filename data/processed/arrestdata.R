arrest.data <- read.csv("arrest-loc-inc.csv", header=FALSE, na.strings=c(""," ","NA"))
colnames(arrest.data) <- c("name","dob","pstreet","pcity","arrtime","arrdate","arrstreet","arrstatus","charge")

arrest.data$name <- tolower(as.character(arrest.data$name))
arrest.data$pstreet <- tolower(as.character(arrest.data$pstreet))
arrest.data$pcity <- tolower(as.character(arrest.data$pcity))
arrest.data$arrstreet <- tolower(as.character(arrest.data$arrstreet))
levels(arrest.data$arrstatus) <- tolower(levels(arrest.data$arrstatus))
levels(arrest.data$charge) <- tolower(levels(arrest.data$charge))

better.dates <- as.Date(arrest.data$dob, format = "%m/%d/%y")
better.dates2 <- as.Date(arrest.data$arrdate, format = "%m/%d/%y")

correct.century <- as.Date(ifelse(better.dates > Sys.Date(),
                      format(better.dates, "19%y-%m-%d"),
                      format(better.dates)))

correct.century2 <- as.Date(ifelse(better.dates2 > Sys.Date(),
                                  format(better.dates2, "19%y-%m-%d"),
                                  format(better.dates2)))

arrest.data$dob <- correct.century
arrest.data$arrdate <- correct.century2

age <- difftime(arrest.data$arrdate, arrest.data$dob, units = "weeks")
arrest.data$age <- as.numeric(age/52)
arrest.data$driving <- 0

traffic.data <- read.csv("citation.csv", header=FALSE, na.strings=c(""," ","NA"))
colnames(traffic.data) <- c("lname","fname","pstreet","pcity","dob","arrtime","charge","arrstreet","arrdate")

traffic.data$lname <- tolower(as.character(traffic.data$lname))
traffic.data$fname <- tolower(as.character(traffic.data$fname))
traffic.data$pstreet <- tolower(as.character(traffic.data$pstreet))
traffic.data$pcity <- tolower(as.character(traffic.data$pcity))
levels(traffic.data$charge) <- tolower(levels(traffic.data$charge))
traffic.data$arrstreet <- tolower(as.character(traffic.data$arrstreet))

better.dates3 <- as.Date(traffic.data$dob, format = "%m/%d/%Y")
better.dates4 <- as.Date(traffic.data$arrdate, format = "%m/%d/%y")

correct.century3 <- as.Date(ifelse(better.dates3 > Sys.Date(),
                                  format(better.dates3, "19%y-%m-%d"),
                                  format(better.dates3)))

correct.century4 <- as.Date(ifelse(better.dates4 > Sys.Date(),
                                   format(better.dates4, "19%y-%m-%d"),
                                   format(better.dates4)))

traffic.data$dob <- correct.century3
traffic.data$arrdate <- correct.century4
age <- difftime(traffic.data$arrdate, traffic.data$dob, units = "weeks")
traffic.data$age <- as.numeric(age/52)
traffic.data$driving <- 1

traffic.data <- traffic.data[!(traffic.data$lname == ""),]
traffic.data <- traffic.data[!(is.na(traffic.data$lname)),]

arrest.data <- subset(arrest.data, select=-c(name))
traffic.data <- subset(traffic.data, select=-c(lname, fname))
traffic.data$arrstatus <- NA

all.data <- rbind(arrest.data, traffic.data)
all.data$arryear <- format(all.data$arrdate, "%Y")

all.data$arrtime <- (((as.numeric(all.data$arrtime))-(as.numeric(all.data$arryear)*1000000))/60) %% 24
no.missing.vals.data <- all.data[complete.cases(all.data),]

write.csv(all.data, "alldata.csv")
write.csv(no.missing.vals.data, "nomissingvalues.csv")
