import { useState } from 'react'
import { useLanguage } from '../../contexts/LanguageContext'
import { BaseMap } from '../maps/BaseMap'
import { PlotMarkers } from '../maps/PlotMarkers'
import { useData } from '../../hooks/useData'

interface SpatialViewProps {
    title: string
}

export const SpatialView = ({ title }: SpatialViewProps) => {
    const { t } = useLanguage()
    const data = useData()
    const [selectedSample, setSelectedSample] = useState<number | undefined>()

    const plotData = data.plotData || []
    const samples = Array.from(new Set(plotData.map(p => p.ORNEK_NO))).sort((a, b) => a - b)

    if (data.loading) {
        return <div className="loading-container">{t('loading')}</div>
    }

    return (
        <div className="spatial-view">
            <div className="content-box">
                <div className="content-box-header">
                    <h3 className="content-box-title">{title}</h3>
                </div>
                <div className="content-box-body">
                    <div className="form-group" style={{ maxWidth: '400px', margin: '0 auto 20px' }}>
                        <label className="form-label">{t('selectSample')}</label>
                        <select
                            className="form-control"
                            value={selectedSample || ''}
                            onChange={(e) => setSelectedSample(Number(e.target.value))}
                        >
                            <option value="">Select a sample point...</option>
                            {samples.map(sample => (
                                <option key={sample} value={sample}>{sample}</option>
                            ))}
                        </select>
                    </div>

                    <BaseMap
                        center={[41.0, 29.5]}
                        zoom={9}
                        style={{ height: '700px', width: '100%' }}
                    >
                        <PlotMarkers
                            data={plotData}
                            selectedId={selectedSample}
                            onSelect={setSelectedSample}
                        />
                    </BaseMap>
                </div>
            </div>
        </div>
    )
}
