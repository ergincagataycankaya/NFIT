import { MapContainer, TileLayer, LayersControl, ScaleControl } from 'react-leaflet'
import { BoundaryLayers } from './BoundaryLayers'
import type { ReactNode } from 'react'
import 'leaflet/dist/leaflet.css'

const { BaseLayer, Overlay } = LayersControl

interface BaseMapProps {
    center: [number, number]
    zoom: number
    children?: ReactNode
    style?: React.CSSProperties
    showBoundaries?: boolean
}

export const BaseMap = ({ center, zoom, children, style, showBoundaries = true }: BaseMapProps) => {
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

                {showBoundaries && (
                    <>
                        <Overlay name="OİM SINIRLARI">
                            <BoundaryLayers showOIM={true} />
                        </Overlay>

                        <Overlay name="OİŞ SINIRLARI">
                            <BoundaryLayers showSeflik={true} />
                        </Overlay>

                        <Overlay name="İKLİM TİPLERİ">
                            <BoundaryLayers showEcoregions={true} />
                        </Overlay>
                    </>
                )}
            </LayersControl>

            <ScaleControl position="bottomleft" />

            {/* Main OBM boundary always shown */}
            {showBoundaries && <BoundaryLayers showOBM={true} />}

            {children}
        </MapContainer>
    )
}
