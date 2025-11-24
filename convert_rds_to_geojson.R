# Convert RDS files to GeoJSON for React-Leaflet

# This R script converts the spatial RDS files to GeoJSON format
# Run this script in R to generate GeoJSON files

library(sf)
library(geojsonsf)

# Set working directory to data folder
setwd("d:/PhD/github/NFIT/public/data")

# Load RDS files
seflik <- readRDS("seflik.rds")
ecoregions <- readRDS("ecoregions.rds")
ISTANBUL_OBM <- readRDS("ISTANBUL_OBM.rds")
ISTANBUL_OIM <- readRDS("ISTANBUL_OIM.rds")

# Convert to sf objects if they aren't already
if (!inherits(seflik, "sf")) {
  seflik <- st_as_sf(seflik)
}
if (!inherits(ecoregions, "sf")) {
  ecoregions <- st_as_sf(ecoregions)
}
if (!inherits(ISTANBUL_OBM, "sf")) {
  ISTANBUL_OBM <- st_as_sf(ISTANBUL_OBM)
}
if (!inherits(ISTANBUL_OIM, "sf")) {
  ISTANBUL_OIM <- st_as_sf(ISTANBUL_OIM)
}

# Write to GeoJSON
st_write(seflik, "seflik.geojson", delete_dsn = TRUE)
st_write(ecoregions, "ecoregions.geojson", delete_dsn = TRUE)
st_write(ISTANBUL_OBM, "ISTANBUL_OBM.geojson", delete_dsn = TRUE)
st_write(ISTANBUL_OIM, "ISTANBUL_OIM.geojson", delete_dsn = TRUE)

print("GeoJSON files created successfully!")
print(paste("seflik features:", nrow(seflik)))
print(paste("ecoregions features:", nrow(ecoregions)))
print(paste("ISTANBUL_OBM features:", nrow(ISTANBUL_OBM)))
print(paste("ISTANBUL_OIM features:", nrow(ISTANBUL_OIM)))
