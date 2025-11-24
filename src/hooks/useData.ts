import { useState, useEffect } from 'react'
import { dataManager } from '../services/DataManager'
import { TreeData, PlotData } from '../types/DataTypes'

export const useData = () => {
    const [loading, setLoading] = useState(true)
    const [treeData, setTreeData] = useState<TreeData[]>([])
    const [plotData, setPlotData] = useState<PlotData[]>([])

    useEffect(() => {
        const load = async () => {
            if (dataManager.treeData.length === 0) {
                await dataManager.loadAllData()
            }
            setTreeData(dataManager.treeData)
            setPlotData(dataManager.plotData)
            setLoading(false)
        }
        load()
    }, [])

    return { loading, treeData, plotData }
}
