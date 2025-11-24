import { CircleMarker, Popup } from 'react-leaflet'
import type { PlotData } from '../../types/DataTypes'

interface PlotMarkersProps {
    data: PlotData[]
    selectedId?: number
    onSelect?: (id: number) => void
}

const YEAR_COLORS: Record<string, string> = {
    '2019': '#FFEB3B',
    '2020': '#4CAF50',
    '2021': '#F44336',
    '2022': '#2196F3',
    '2023': '#9C27B0'
}

export const PlotMarkers = ({ data, selectedId, onSelect }: PlotMarkersProps) => {
    return (
        <>
            {data.map((plot) => {
                if (!plot.ENLEM || !plot.BOYLAM) return null

                const year = String(plot.ENVANTER_TARIHI).substring(0, 4)
                const color = YEAR_COLORS[year] || '#888'

                return (
                    <CircleMarker
                        key={plot.ORNEK_NO}
                        center={[plot.ENLEM, plot.BOYLAM]}
                        radius={plot.ORNEK_NO === selectedId ? 15 : 10}
                        pathOptions={{
                            fillColor: color,
                            color: '#000',
                            weight: 1,
                            opacity: 1,
                            fillOpacity: 0.8
                        }}
                        eventHandlers={{
                            click: () => onSelect?.(plot.ORNEK_NO)
                        }}
                    >
                        <Popup>
                            <div style={{ minWidth: '200px' }}>
                                <strong>ÖRNEK NOKTA NO:</strong> {plot.ORNEK_NO}<br />
                                <strong>OBM ADI:</strong> {plot.BOLGE_ADI}<br />
                                <strong>OİM ADI:</strong> {plot.MUDURLUK_ADI}<br />
                                <strong>OİŞ ADI:</strong> {plot.SEFLIK_ADI}<br />
                                <strong>ENVANTER YILI:</strong> {plot.ENVANTER_TARIHI}<br />
                                <strong>AKTÜEL MEŞÇERE TİPİ:</strong> {plot.AKTUEL_MES_TIP}<br />
                                <strong>EĞİM:</strong> {plot.EGIM}<br />
                                <strong>RAKIM:</strong> {plot.RAKIM}<br />
                                <strong>BAKI:</strong> {plot.BAKI}
                            </div>
                        </Popup>
                    </CircleMarker>
                )
            })}
        </>
    )
}
