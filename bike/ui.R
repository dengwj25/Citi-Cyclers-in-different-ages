shinyUI(dashboardPage(skin = "black",
                      
                      
  dashboardHeader(title = "Citi Bikers in Differnt Ages",titleWidth = 450),

  
  dashboardSidebar(
    dashboardSidebar(
      sidebarUserPanel("Weijie Deng",
                       image =  "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
    
      sidebarMenu(
        menuItem("Hour", tabName = "bar", icon = icon("bar-chart")),
        menuItem("Week", tabName = "2DHistogram", icon = icon("area-chart")),
        menuItem("Month", tabName = "year", icon = icon("calendar")),
        menuItem("Locations", tabName = "InteractiveMap", icon = icon("map"))
                 )
      
      )),
  
  dashboardBody(
    tabItems(
      #Bar
      tabItem(tabName = "bar",
              h2("Percentage of  each Age Group Hourly"),
              fluidPage(plotOutput("bar1", height = 670))
      ),
      # 2D histogram
      tabItem(tabName = "2DHistogram",
        h2("Weekly Age Group Layout "),
        fluidPage(plotlyOutput("week", height = 670))
                      ),
      #Scatter
      tabItem(tabName = "year",
        h2("Monthly Age Group Layout"),
        fluidPage(plotlyOutput("year", height = 670))
      ),
      
      #Map
      tabItem(tabName = "InteractiveMap",
              h2("Interactive Map"),
              leafletOutput("map", height = 670),
              #add panel to filter data
              absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                            draggable = FALSE, top = 125, right = 20,bottom = "auto",
                            width = 360, height = '100%'
                    ,
                    selectInput("age.group", "Select age group",choices =  Age.Group, selected = '15-25')
                    ,
                    checkboxGroupInput("user.type", label = h4("User Type"),
                                       choices = c("Subscriber", 'Customer'),selected = 'Subscriber')
                    ,
                    checkboxGroupInput("gender", label = h4("Gender"),
                                       choices = c("Male",'Female'),selected = 'Male')
                    ,
                    dateRangeInput("dates", label = h4("Date range")
                                   ,start= "2016-01-01",end= "2016-12-31"))
              )
      
      ))
  ))       
