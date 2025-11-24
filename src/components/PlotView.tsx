import { useData } from '../hooks/useData'
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet'
import 'leaflet/dist/leaflet.css'
import L from 'leaflet'

// Fix Leaflet icon issue
import icon from 'leaflet/dist/images/marker-icon.png'
import iconShadow from 'leaflet/dist/images/marker-shadow.png'

let DefaultIcon = L.icon({
    iconUrl: icon,
    shadowUrl: iconShadow,
    iconSize: [25, 41],
    iconAnchor: [12, 41]
});

L.Marker.prototype.options.icon = DefaultIcon;

export const PlotView = () => {
    const { plotData } = useData()

    // Filter out invalid coordinates if any
    const validPlots = plotData.filter(p => p.ENLEM && p.BOYLAM)

    return (
        <div>
            <h3 style={{ marginBottom: '1rem' }}>Plot Locations</h3>
            <div style={{ height: '400px', marginBottom: '2rem', borderRadius: '8px', overflow: 'hidden' }}>
                <MapContainer center={[41.0, 29.0]} zoom={9} style={{ height: '100%', width: '100%' }}>
                    <TileLayer
                        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                    />
                    {validPlots.map((plot) => (
                        <Marker key={plot.ORNEK_NO} position={[plot.ENLEM || 0, plot.BOYLAM || 0]}>
                            <Popup>
                                <strong>Plot No: {plot.ORNEK_NO}</strong><br />
                                Region: {plot.BOLGE_ADI}<br />
                                Slope: {plot.EGIM}%
                            </Popup>
                        </Marker>
                    ))}
                </MapContainer>
            </div>

            <h3>Plot Details</h3>
            <div style={{ overflowX: 'auto' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                    <thead>
                        <tr style={{ borderBottom: '1px solid #444' }}>
                            <th style={{ padding: '1rem' }}>No</th>
                            <th style={{ padding: '1rem' }}>Region</th>
                            <th style={{ padding: '1rem' }}>Directorate</th>
                            <th style={{ padding: '1rem' }}>Chiefdom</th>
                            <th style={{ padding: '1rem' }}>Date</th>
                            <th style={{ padding: '1rem' }}>Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        {plotData.slice(0, 10).map((plot) => (
                            <tr key={plot.ORNEK_NO} style={{ borderBottom: '1px solid #333' }}>
                                <td style={{ padding: '1rem' }}>{plot.ORNEK_NO}</td>
                                <td style={{ padding: '1rem' }}>{plot.BOLGE_ADI}</td>
                                <td style={{ padding: '1rem' }}>{plot.MUDURLUK_ADI}</td>
                                <td style={{ padding: '1rem' }}>{plot.SEFLIK_ADI}</td>
                                <td style={{ padding: '1rem' }}>{plot.ENVANTER_TARIHI}</td>
                                <td style={{ padding: '1rem' }}>{plot.AKTUEL_MES_TIP}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    )
}
