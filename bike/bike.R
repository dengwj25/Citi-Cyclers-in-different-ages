library(dplyr)
library(ggplot2)
library(tidyr)
library(data.table)

filename=list.files(pattern = '*.csv')

handle_each = function(x){
  x=paste0('C:/Users/dengw/Downloads/bike/',x)
  temp = fread(input = x,
               head = TRUE,
               col.names=c('trip.dur','start.T','stop.T','start.stat.id',
                           'start.stat.name','start.stat.la','start.stat.lo',
                           'end.stat.id','end.stat.name','end.stat.la',
                           'end.stat.lo','bike.id','user.type','birth.year','sex'))
  return(temp)
}

bike=do.call(rbind,lapply(filename,handle_each))


data = bike[,c('date', 'start.time'):=tstrsplit(start.T, ' ',fixed=TRUE)][]
data[,c('stop.date', 'stop.time'):=tstrsplit(stop.T, ' ',fixed=TRUE)][]
data[,c('age') := 2018 - as.numeric(birth.year)]
data[,gender:= 'M' ][sex == 2,gender:='F'][sex == 0, gender := "U"][]
data[,c('start.T','stop.T','birth.year','sex','stop.date') := NULL]


