import { MapContainer, TileLayer, LayersControl, ScaleControl, useMap } from 'react-leaflet'
import { useEffect } from 'react'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

const { BaseLayer } = LayersControl

interface BaseMapProps {
    center: [number, number]
    zoom: number
    children?: React.ReactNode
    style?: React.CSSProperties
}

// Component to add measure control
function MeasureControl() {
    const map = useMap()

    useEffect(() => {
        // Add measurement tools (simplified - would need leaflet-draw or similar plugin)
        // For now, just adding a minimap
        if ((L.Control as any).MiniMap) {
            const miniMap = new (L.Control as any).MiniMap(
                L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'),
                {
                    toggleDisplay: true,
                    minimized: false,
                    position: 'bottomleft'
                }
            )
            map.addControl(miniMap)
        }
    }, [map])

    return null
}

export const BaseMap = ({ center, zoom, children, style }: BaseMapProps) => {
    return (
        <MapContainer
            center={center}
            zoom={zoom}
            style={style || { height: '600px', width: '100%' }}
            scrollWheelZoom={true}
        >
            <LayersControl position="topleft">
                <BaseLayer checked name="İDARİ SINIRLAR">
                    <TileLayer
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                        url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}"
                    />
                </BaseLayer>
                <BaseLayer name="UYDU GÖRÜNTÜSÜ">
                    <TileLayer
                        attribution='&copy; Esri'
                        url="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
                    />
                </BaseLayer>
            </LayersControl>

            <ScaleControl position="bottomleft" />
            <MeasureControl />

            {children}
        </MapContainer>
    )
}
