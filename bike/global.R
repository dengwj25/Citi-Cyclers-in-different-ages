library(dplyr)
library(ggplot2)
library(tidyr)
library(data.table)
library(shiny)
library(leaflet)
library(plotly)
library(shinydashboard)
library(rgdal)


#load dataset to R
filename=list.files('./bike/',pattern = '*.csv')
handle_each = function(x){
  x=paste0('./bike/',x)
  temp = fread(input = x,
               head = TRUE,
               col.names=c('trip.dur','T','stop.T','id',
                           'name','lat','lng',
                           'end.id','end.name','end.lat',
                           'end.lng','bike.id','user.type','birth.year','sex'))
  return(temp)
}
bike=do.call(rbind,lapply(filename,handle_each))

#clean up the data
data=bike
data[,c('age') := 2018 - as.numeric(birth.year)]
data[,gender:= 'Male' ][sex == 2,gender:='Female'][sex == 0, gender := "Unknow"][]
data = bike[,c('date', 'time'):=tstrsplit(T, ' ',fixed=TRUE)][]
data[,c('stop.date', 'stop.time'):=tstrsplit(stop.T, ' ',fixed=TRUE)][]
data = data[,c('year','mon','day'):=tstrsplit(date,'-',fixed=TRUE)][]
data = data[,c('hr','min','sec'):=tstrsplit(time,':',fixed=TRUE)][]
data[,c('T','stop.T','birth.year','sex','min','sec','year') := NULL]
data$week =weekdays(as.Date(data$date,'%Y-%d-%m'))
data[age >=15 & age <25,group := '15-25'][age >=25 & age <35, group:='25-35'][age >= 35 & age<45, group:='35-45'][age >=45 & age <55,group := '45-55'][age >=55 & age <65, group :='55-65'][age >=65 & age <75,group := '65-75']
data$group= factor(data$group, levels=c("15-25","25-35","35-45","45-55","55-65","65-75"))
data$week = factor(data$week,levels=c('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'))
data$mon = as.numeric(data$mon)
data$day = as.numeric(data$day)
data$hr = as.numeric(data$hr)
setDF(data)
data$date = as.POSIXct(data$date)
#select list
Gender = unique(data$gender)
User.Type = unique(data$user.type)
Age.Group=sort(unique(data$group))



#week - 2D Histo
HistoCnt = data.frame(with(data, table(week, group)))
HistoCnt$group = sort(HistoCnt$group)

#year - Scatter
DensGra = data.frame(with(data, table(date, group)))
DensGra$group = sort(as.character(DensGra$group))
DensGra$date = as.POSIXct(DensGra$date)

#hour -Bar
Bar = data.frame(with(data, table(hr, group)))
Bar$group = sort(as.character(Bar$group))



