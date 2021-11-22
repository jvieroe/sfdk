
url <- "https://services.datafordeler.dk/DAR/DAR/1/REST/postnummer?"

post <- read_sf(url)


url <- "https://api.dataforsyningen.dk/sogne"
url <- "https://api.dataforsyningen.dk/sogne?format=geojson"

sogne <- read_sf(url)


url <- "https://api.dataforsyningen.dk/kommuner?format=geojson"

test <- read_sf(url)
class(test)
class(test$geometry)

test2 <- test %>%
  filter(navn != "Christiansø")

tmap_mode("view")
tm_shape(test2) +
  tm_polygons(col = "yellow", alpha = .5)
