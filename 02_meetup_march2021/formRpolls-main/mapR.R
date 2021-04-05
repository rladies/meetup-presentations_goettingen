# to debug
# peoplecities<-c("Paris", "Berlin", "Madrid", "Gottingen", "Gottingen", "Gottingen", "Munchen")
# peoplecountries<-c("France", "Germany", "Spain", "Germany", "Germany", "Germany", "Germany")


wherepeopleare <- function(peoplecities = "",
                           # vector of cities that should be plotted
                           peoplecountries = "",
                           # countries (as some city names are the duplicate)
                           countcities = T,
                           # adjust point size of cities based on number of people
                           markbase = c("Germany", "Augsburg"),
                           # reference point which is highlighted
                           wholeworld = T,
                           # always plot whole world not only a subset
                           interactive = T,
                           # use plotly to be able to zoom?
                           pointcol = '#cc0099') {
  # check whether there is anything to map?
  if(length(peoplecities)== 0){
    return(cat("here' s nothing to map. check data"))
  }else{
  #devtools::install_github("dkahle/ggmap")
  require(mapdata)
  require(maps)
  require(ggmap)
  require(ggplot2)
  require(plotly)
  
  markident <- paste0(markbase, collapse = "")
  
  peoplecities <-
    trimws(peoplecities,
           which = c("both", "left", "right"),
           whitespace = "[ \t\r\n]")
  peoplecountries <-
    trimws(
      peoplecountries,
      which = c("both", "left", "right"),
      whitespace = "[ \t\r\n]"
    )
  cityident <-
    paste0(peoplecountries, peoplecities)  # to exclude arbitrary cities
  cityfreq <- as.data.frame(table(cityident)) # count how many of each
  subworld <-
    world.cities[world.cities$country.etc %in% c(peoplecountries, markbase[1]), ]
  subworld$cityident <- paste0(subworld$country.etc, subworld$name)
  selectedcities <-
    subworld[subworld$cityident %in% c(cityident, markident), ] # those are the points to plot
  selectedcities <-
    merge(selectedcities, cityfreq, by = "cityident", all.x = T) # now with frequencies
  
  #subset of countries
  if (wholeworld == F) {
    subworldmap <-
      subset(map_data("world"), region %in% subworld$country.etc)
    plotmap <-
      ggplot() + geom_polygon(data = subset(map_data("world"), lat >= -50),
                              aes(x = long, y = lat, group = group)) +
      coord_fixed(1.3,
                  xlim = c(min(subworldmap$long), max(subworldmap$long)),
                  ylim = c(min(subworldmap$lat), max(subworldmap$lat))) +
      theme_minimal() +
      geom_point(
        data = selectedcities,
        aes(x = long, y = lat, size = Freq) ,
        col = pointcol,
        shape = 16,
        alpha = 0.8
      ) +
      geom_point(
        data = subset(selectedcities, name == markbase[2]),
        aes(x = long, y = lat) ,
        col = "green",
        size = 2,
        shape = 3
      ) +   theme(legend.position = "none") +
      scale_size_continuous(breaks = seq.int(1, to = max(selectedcities$Freq, na.rm = T)))
  }
  
  #world
  if (wholeworld == T) {
    plotmap <-
      ggplot() + geom_polygon(data = subset(map_data("world"), lat >= -50) ,
                              aes(x = long, y = lat, group = group)) +
      coord_fixed(1.3) + theme_minimal() +
      geom_point(
        data = selectedcities,
        aes(x = long, y = lat, size = Freq) ,
        col = pointcol,
        shape = 16,
        alpha = 0.8
      ) +
      geom_point(
        data = subset(selectedcities, name == markbase[2]),
        aes(x = long, y = lat) ,
        col = "green",
        size = 2,
        shape = 3
      ) +   theme(legend.position = "none") +
      scale_size_continuous(breaks = seq.int(1, to = max(selectedcities$Freq, na.rm = T)))
  }
  
  if (interactive == T) {
    plotmap <- plotmap +
      geom_point(
        data = selectedcities,
        aes(
          x = long,
          y = lat,
          size = Freq,
          text = name
        ) ,
        col = pointcol,
        shape = 16,
        alpha = 0.8
      )
    plotmap <- ggplotly(p = plotmap, tooltip = c("text", "size"))
    htmlwidgets::saveWidget(plotmap, file = "intplotmap.html")
  }
  return(plotmap)
  }
}