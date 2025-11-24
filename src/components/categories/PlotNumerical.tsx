import { NumericalView } from '../data-views/NumericalView'
import { useData } from '../../hooks/useData'

export const PlotNumerical = () => {
    const { plotData, loading } = useData()

    if (loading) {
        return <div className="loading-container">Loading data...</div>
    }

    if (!plotData || plotData.length === 0) {
        return <div className="loading-container">No plot data available</div>
    }

    return <NumericalView data={plotData} title="PLOT INFORMATION - Numerical Data" />
}
