import { NumericalView } from '../data-views/NumericalView'
import { useData } from '../../hooks/useData'

export const TreeNumerical = () => {
    const { treeData, loading } = useData()

    if (loading) {
        return <div className="loading-container">Loading data...</div>
    }

    if (!treeData || treeData.length === 0) {
        return <div className="loading-container">No tree data available</div>
    }

    return <NumericalView data={treeData} title="TREE INVENTORY - Numerical Data" />
}
