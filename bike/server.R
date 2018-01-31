function(input, output) { 
  # 2D histogram -week
  output$week <- renderPlotly({
    x <- list(
      title = "Week")
    y <- list(
      title = "Age Group")
    plot_ly(data, x = ~week, y = ~group, z=~HistoCnt) %>% 
      add_histogram2d()%>%
      layout(xaxis = x, yaxis = y)
})
  #Scatter -month
  output$year <- renderPlotly({
    x <- list(
      title = "Date")
    y <- list(
      title = "Age Group")
    plot_ly(DensGra, x = ~date, y = ~Freq, color = ~group ,
            colors = c("blue","red"),  
            marker=list( size=7, opacity=0.5))%>%
      layout(xaxis = x, yaxis = y)
    
}) 
  #Bar - hour
  output$bar1 <- renderPlot({
    ggplot(Bar, aes(fill=group, y=Freq, x=hr)) +
      geom_bar( stat="identity", position="fill") +    
      scale_fill_brewer(palette = "Set3")+
      labs(title='Hourly', x= 'Hours', y = 'Frequence')
      })
    
   
#Interactive Map

  #filter a map
f_data = reactive({
     data %>% filter(group == input$age.group) %>%
     filter(gender == input$gender) %>%
     filter(user.type  == input$user.type) %>% 
     filter(date >= as.POSIXct(input$dates[1])& date <= as.POSIXct(input$dates[2]))%>%  
     group_by(name) %>% summarise(Freq = n()) %>%
     inner_join(.,data %>% select(name,lat,lng)) %>% unique()
   })

  #basic map 
output$map <- renderLeaflet({

  leaflet() %>% addTiles(
    urlTemplate = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}.png',
    attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>') %>%
    setView(lng = -74.05, lat = 40.72, zoom = 14)
})

  #observe the change, and add popup
observe({
   r = f_data()  %>% mutate(radius =  Freq/247584 * 10000)
   
  leafletProxy("map", data = r) %>%
     clearMarkers() %>%
     addCircleMarkers(~lng, ~lat, radius= ~radius,
     color= "orange",fillOpacity=0.4,stroke=FALSE,
     label = paste('Detail'),
     popup = paste('Location:  ',r$name, "<br>",
                   'Num of people:  ',r$Freq))
})

}