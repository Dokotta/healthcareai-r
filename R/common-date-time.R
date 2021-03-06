#' @title
#' Convert datetime column into dummy columns
#'
#' @description
#' Convert datetime column into dummy columns of day, hour, etc, such that one
#' can use daily and seasonal patterns in their model building.
#'
#' @param df A data frame. Indicates the datetime column.
#' @param dateTimeCol A string. Column name in df that will be converted
#' into several columns.
#' @param depth A string. Specifies the depth with which to expand extra columns
#' (starting with a year column). 'd' expands to day, 'h' expands to hour
#' (default), m' expands to minute, and 's' expands to second.
#' @param returnDtCol A boolean. Return the original dateTimeCol with
#' the modified data frame?
#' @return A data frame which now includes several columns based on time
#' rather than just one datetime column
#'
#' @export
#' @references \url{http://healthcare.ai}
#' @seealso \code{\link{healthcareai}}
#' @examples
#' dtCol <- c('2001-06-09 12:45:05','2002-01-29 09:30:05','2002-02-02 07:36:50',
#'           '2002-03-04 16:45:01','2002-11-13 20:00:10','2003-01-29 07:31:43',
#'           '2003-07-07 17:30:02','2003-09-28 01:03:20')
#' y1 <- c(.5,1,3,6,8,13,14,1)
#' y2 <- c(.8,1,1.2,1.2,1.2,1.3,1.3,1)
#' df <- data.frame(dtCol,y1,y2)
#'
#' df <- convertDateTimeColToDummies(df, 'dtCol')
#' head(df)
convertDateTimeColToDummies <- function(df, dateTimeCol, depth = "h", returnDtCol = FALSE) {
  if (depth == "d") {
    df[[dateTimeCol]] <- as.POSIXct(df[[dateTimeCol]])
    df$year <- as.POSIXlt(df[[dateTimeCol]])$year + 1900
    df$month <- as.POSIXlt(df[[dateTimeCol]])$mo + 1
    df$weekOfYear <- strftime(df[[dateTimeCol]], format = "%W")
    df$dayOfMonth <- as.POSIXlt(df[[dateTimeCol]])$mday
    df$dayOfWeek <- as.POSIXlt(df[[dateTimeCol]])$wday + 1
    
  } else if (depth == "h") {
    df[[dateTimeCol]] <- as.POSIXct(df[[dateTimeCol]])
    df$year <- as.POSIXlt(df[[dateTimeCol]])$year + 1900
    df$month <- as.POSIXlt(df[[dateTimeCol]])$mo + 1
    df$weekOfYear <- strftime(df[[dateTimeCol]], format = "%W")
    df$dayOfMonth <- as.POSIXlt(df[[dateTimeCol]])$mday
    df$dayOfWeek <- as.POSIXlt(df[[dateTimeCol]])$wday + 1
    df$hour <- as.POSIXlt(df[[dateTimeCol]])$hour
    
  } else if (depth == "m") {
    df[[dateTimeCol]] <- as.POSIXct(df[[dateTimeCol]])
    df$year <- as.POSIXlt(df[[dateTimeCol]])$year + 1900
    df$month <- as.POSIXlt(df[[dateTimeCol]])$mo + 1
    df$weekOfYear <- strftime(df[[dateTimeCol]], format = "%W")
    df$dayOfMonth <- as.POSIXlt(df[[dateTimeCol]])$mday
    df$dayOfWeek <- as.POSIXlt(df[[dateTimeCol]])$wday + 1
    df$hour <- as.POSIXlt(df[[dateTimeCol]])$hour
    df$min <- as.POSIXlt(df[[dateTimeCol]])$min
    
  } else if (depth == "s") {
    df[[dateTimeCol]] <- as.POSIXct(df[[dateTimeCol]])
    df$year <- as.POSIXlt(df[[dateTimeCol]])$year + 1900
    df$month <- as.POSIXlt(df[[dateTimeCol]])$mo + 1
    df$weekOfYear <- strftime(df[[dateTimeCol]], format = "%W")
    df$dayOfMonth <- as.POSIXlt(df[[dateTimeCol]])$mday
    df$dayOfWeek <- as.POSIXlt(df[[dateTimeCol]])$wday + 1
    df$hour <- as.POSIXlt(df[[dateTimeCol]])$hour
    df$min <- as.POSIXlt(df[[dateTimeCol]])$min
    df$Sec <- as.POSIXlt(df[[dateTimeCol]])$sec
  }
  
  if (isTRUE(!returnDtCol)) {
    df[[dateTimeCol]] <- NULL
  }
  df
}

#' @title
#' Creates column based on days since first date
#'
#' @description Adds a new column to the data frame, which shows days since
#' first day in input column
#' @param df A data frame
#' @param dtCol A string denoting the date-time column of interest
#' @param returnDtCol A boolean. Return the original dtCol with the modified
#' data frame?
#' @return A data frame that now has a new column
#'
#' @export
#' @references \url{http://healthcare.ai}
#' @seealso \code{\link{healthcareai}}
#' @examples
#' dtCol = c('2001-06-09 12:45:05','2002-01-29 09:30:05','2002-02-02 07:36:50',
#' '2002-03-04 16:45:01','2002-11-13 20:00:10','2003-01-29 07:31:43',
#' '2003-07-07 17:30:02','2003-09-28 01:03:20')
#' y1 <- c(.5,1,3,6,8,13,14,1) # Not being used at all
#' df <- data.frame(dtCol, y1)
#' head(df)
#' dfResult <- countDaysSinceFirstDate(df, 'dtCol')
#' head(dfResult)
countDaysSinceFirstDate <- function(df, dtCol, returnDtCol = FALSE) {
  # Find first date in date list
  earliest <- df[[dtCol]][order(format(as.Date(df[[dtCol]]), "%y%m%d"))[1]]
  # Find diff between each date and first date
  dayDiff <- as.numeric(difftime(df[[dtCol]], earliest, units = "days"))
  # Make output col name include input name (in case of multiple uses)
  combinedName <- paste0(dtCol, "DaysSinceFirstDate")
  df[[combinedName]] <- dayDiff
  
  if (isTRUE(!returnDtCol)) {
    df[[dtCol]] <- NULL
  }
  df
}