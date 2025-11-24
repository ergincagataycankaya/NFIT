import { useState, useEffect } from 'react'
import { dataManager } from '../services/DataManager'
import type { TreeData, PlotData, OluData, DiriData, ToprakData, SuData, KarbonData } from '../types/DataTypes'

interface DataState {
    loading: boolean
    treeData: TreeData[]
    plotData: PlotData[]
    oluData: OluData[]
    diriData: DiriData[]
    toprakData: ToprakData[]
    suData: SuData[]
    karbonData: KarbonData[]
}

export const useData = () => {
    const [state, setState] = useState<DataState>({
        loading: true,
        treeData: [],
        plotData: [],
        oluData: [],
        diriData: [],
        toprakData: [],
        suData: [],
        karbonData: []
    })

    useEffect(() => {
        const loadData = async () => {
            await dataManager.loadAllData()
            setState({
                loading: false,
                treeData: dataManager.treeData,
                plotData: dataManager.plotData,
                oluData: dataManager.oluData,
                diriData: dataManager.diriData,
                toprakData: dataManager.toprakData,
                suData: dataManager.suData,
                karbonData: dataManager.karbonData
            })
        }

        loadData()
    }, [])

    return state
}
