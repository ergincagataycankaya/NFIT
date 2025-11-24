import { useEffect, useState } from 'react'
import { GeoJSON } from 'react-leaflet'
import type { GeoJsonObject } from 'geojson'

interface BoundaryLayersProps {
    showOBM?: boolean
    showOIM?: boolean
    showSeflik?: boolean
    showEcoregions?: boolean
}

// Color palettes matching app.R
const OBM_COLOR = '#1f78b4'
const SPECTRAL_COLORS = [
    '#9e0142', '#d53e4f', '#f46d43', '#fdae61', '#fee08b',
    '#ffffbf', '#e6f598', '#abdda4', '#66c2a5', '#3288bd', '#5e4fa2'
]

export const BoundaryLayers = ({
    showOBM = false,
    showOIM = false,
    showSeflik = false,
    showEcoregions = false
}: BoundaryLayersProps) => {
    const [obmData, setObmData] = useState<GeoJsonObject | null>(null)
    const [oimData, setOimData] = useState<GeoJsonObject | null>(null)
    const [seflikData, setSeflikData] = useState<GeoJsonObject | null>(null)
    const [ecoregionsData, setEcoregionsData] = useState<GeoJsonObject | null>(null)

    useEffect(() => {
        // Load GeoJSON files
        if (showOBM) {
            fetch('/data/ISTANBUL_OBM.geojson')
                .then(res => res.json())
                .then(data => setObmData(data))
                .catch(err => console.log('OBM layer not available:', err))
        }

        if (showOIM) {
            fetch('/data/ISTANBUL_OIM.geojson')
                .then(res => res.json())
                .then(data => setOimData(data))
                .catch(err => console.log('OIM layer not available:', err))
        }

        if (showSeflik) {
            fetch('/data/seflik.geojson')
                .then(res => res.json())
                .then(data => setSeflikData(data))
                .catch(err => console.log('Seflik layer not available:', err))
        }

        if (showEcoregions) {
            fetch('/data/ecoregions.geojson')
                .then(res => res.json())
                .then(data => setEcoregionsData(data))
                .catch(err => console.log('Ecoregions layer not available:', err))
        }
    }, [showOBM, showOIM, showSeflik, showEcoregions])

    return (
        <>
            {obmData && (
                <GeoJSON
                    data={obmData}
                    style={{
                        fillColor: OBM_COLOR,
                        fillOpacity: 0.1,
                        color: 'black',
                        weight: 2
                    }}
                    onEachFeature={(feature, layer) => {
                        if (feature.properties?.ADI) {
                            layer.bindPopup(`<strong>OBM:</strong> ${feature.properties.ADI}`)
                        }
                    }}
                />
            )}

            {oimData && (
                <GeoJSON
                    data={oimData}
                    style={(feature) => {
                        const index = feature?.properties?.ISLETME_MD ?
                            Math.abs(feature.properties.ISLETME_MD.charCodeAt(0)) % SPECTRAL_COLORS.length : 0
                        return {
                            fillColor: SPECTRAL_COLORS[index],
                            fillOpacity: 0.1,
                            color: 'yellow',
                            weight: 1
                        }
                    }}
                    onEachFeature={(feature, layer) => {
                        if (feature.properties?.ISLETME_MD) {
                            layer.bindPopup(`<strong>OİM:</strong> ${feature.properties.ISLETME_MD}`)
                        }
                    }}
                />
            )}

            {seflikData && (
                <GeoJSON
                    data={seflikData}
                    style={(feature) => {
                        const index = feature?.properties?.SEFLIK_ADI ?
                            Math.abs(feature.properties.SEFLIK_ADI.charCodeAt(0)) % SPECTRAL_COLORS.length : 0
                        return {
                            fillColor: SPECTRAL_COLORS[index],
                            fillOpacity: 0.1,
                            color: 'red',
                            weight: 1
                        }
                    }}
                    onEachFeature={(feature, layer) => {
                        if (feature.properties?.SEFLIK_ADI) {
                            layer.bindPopup(`<strong>OİŞ:</strong> ${feature.properties.SEFLIK_ADI}`)
                        }
                    }}
                />
            )}

            {ecoregionsData && (
                <GeoJSON
                    data={ecoregionsData}
                    style={(feature) => {
                        const index = feature?.properties?.IKLIM_TIP ?
                            Math.abs(feature.properties.IKLIM_TIP.charCodeAt(0)) % SPECTRAL_COLORS.length : 0
                        return {
                            fillColor: SPECTRAL_COLORS[index],
                            fillOpacity: 0.1,
                            color: 'blue',
                            weight: 1
                        }
                    }}
                    onEachFeature={(feature, layer) => {
                        if (feature.properties?.IKLIM_TIP) {
                            layer.bindPopup(`<strong>İklim Tipi:</strong> ${feature.properties.IKLIM_TIP}`)
                        }
                    }}
                />
            )}
        </>
    )
}
