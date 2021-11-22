# ---------------------------------------------------------------------------------------------------------------------
# Download data: Sogne + postnumre
# ---------------------------------------------------------------------------------------------------------------------
getwd()


# ---------- 1.0 Hent baggrundsdata --------------------------------------------------------------------------------------------

# ----- 1.1 Dansk ADMIN data -----
dk <- read_sf("3. Potentialeanalyse/4. Geografisk ADMIN data/DK_AdministrativeUnit_GML_UTM32-EUREF89/DK_AdministrativeUnit.gml")

dk <- dk %>%
  st_transform(., crs = 4326) %>%
  filter(LocalisedCharacterString == "Region") %>%
  st_union()

st_crs(dk)

# ---------- 2.0 Hent data --------------------------------------------------------------------------------------------

# url <- "https://services.datafordeler.dk/DAR/DAR/1/REST/postnummer?"
# post <- read_sf(url)


# Kilde: https://dawadocs.dataforsyningen.dk/dok/dagi

# ---------- 2.1 Sogne ----------
# url <- "https://api.dataforsyningen.dk/sogne"
url_sogne <- "https://api.dataforsyningen.dk/sogne?format=geojson"

sogne <- read_sf(url_sogne)

table(st_is_valid(sogne))
table(st_is_empty(sogne))

sogne <- sogne %>%
  st_intersection(.,
                  dk)

sogne <- sogne %>%
  clean_names() %>%
  mutate(aendret = as.character(aendret),
         geo_aendret = as.character(geo_aendret))

sogne <- sogne %>%
  rename(cent_x = visueltcenter_x,
         cent_y = visueltcenter_y,
         edit = aendret,
         geo_edit = geo_aendret,
         geo_ver = geo_version)

temp <- sogne %>%
  tibble() %>%
  select(-geometry)

# ---------- 2.2 Postnumre ----------
url_post <- "https://api.dataforsyningen.dk/postnumre?format=geojson"

post <- read_sf(url_post)

table(st_is_valid(post))
table(st_is_empty(post))

post <- post %>%
  st_intersection(.,
                  dk)

post <- post %>%
  clean_names() %>%
  mutate(aendret = as.character(aendret),
         geo_aendret = as.character(geo_aendret))

post <- post %>%
  rename(cent_x = visueltcenter_x,
         cent_y = visueltcenter_y,
         edit = aendret,
         geo_edit = geo_aendret,
         geo_ver = geo_version) %>%
  select(-stormodtager)

temp <- post %>%
  tibble() %>%
  select(-geometry)


tmap_mode("view")
tm_shape(post) +
  tm_polygons(col = "yellow", alpha = .5)



# url <- "https://api.dataforsyningen.dk/kommuner?format=geojson"
#
# test <- read_sf(url)
# class(test)
# class(test$geometry)
#
# test2 <- test %>%
#   filter(navn != "Christiansø")


# ---------- 3.0 Eksporter data --------------------------------------------------------------------------------------------

# ---------- 3.1 Sogne ----------
st_write(sogne,
         dsn = "3. Potentialeanalyse/4. Geografisk ADMIN data/sogne",
         layer = "sogne",
         encoding = "UTF-8",
         factorsAsCharacter = FALSE,
         delete_layer = TRUE,
         driver = "ESRI Shapefile")



# ---------- 3.2 Postnumre ----------
st_write(post,
         dsn = "3. Potentialeanalyse/4. Geografisk ADMIN data/postnumre",
         layer = "postnumre",
         encoding = "UTF-8",
         factorsAsCharacter = FALSE,
         delete_layer = TRUE,
         driver = "ESRI Shapefile")


