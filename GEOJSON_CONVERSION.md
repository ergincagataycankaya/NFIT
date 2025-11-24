# Converting RDS Files to GeoJSON

To enable the boundary layers on the maps, you need to convert the RDS files to GeoJSON format.

## Files to Convert

Located in `public/data/`:
- `seflik.rds` → `seflik.geojson` (District boundaries)
- `ecoregions.rds` → `ecoregions.geojson` (Climate zones)
- `ISTANBUL_OBM.rds` → `ISTANBUL_OBM.geojson` (Regional boundary)
- `ISTANBUL_OIM.rds` → `ISTANBUL_OIM.geojson` (Management units)

## Conversion Script

Run the provided R script `convert_rds_to_geojson.R`:

```r
# In R or RStudio
source("convert_rds_to_geojson.R")
```

This will create 4 GeoJSON files in the `public/data/` folder.

## Alternative: Manual Conversion

If you don't have R installed:

1. Install R from https://cloud.r-project.org/
2. Install required packages:
   ```r
   install.packages(c("sf", "geojsonsf"))
   ```
3. Run the conversion script

## After Conversion

Once the GeoJSON files are in place, the boundary layers will automatically appear on the maps with toggleable overlays:

- **OİM SINIRLARI** - Management unit boundaries (yellow borders)
- **OİŞ SINIRLARI** - District boundaries (red borders, 89 units)
- **İKLİM TİPLERİ** - Climate zones (blue borders)  
- **OBM Boundary** - Regional outer boundary (always shown)

The layers use the same color schemes as the original app.R Shiny dashboard.

## Implementation Details

The `BoundaryLayers` component:
- Loads GeoJSON files dynamically
- Applies color palettes matching app.R
- Adds interactive popups with boundary names
- Integrates with Leaflet LayersControl for toggle functionality
