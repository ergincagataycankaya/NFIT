import Papa from 'papaparse'
import { TreeData, PlotData, OluData, DiriData, ToprakData, SuData, KarbonData } from '../types/DataTypes'

class DataManager {
    private static instance: DataManager

    public treeData: TreeData[] = []
    public plotData: PlotData[] = []
    public oluData: OluData[] = []
    public diriData: DiriData[] = []
    public toprakData: ToprakData[] = []
    public suData: SuData[] = []
    public karbonData: KarbonData[] = []

    private constructor() { }

    public static getInstance(): DataManager {
        if (!DataManager.instance) {
            DataManager.instance = new DataManager()
        }
        return DataManager.instance
    }

    public async loadAllData(): Promise<void> {
        try {
            const [tree, plot, olu, diri, toprak, su, karbon] = await Promise.all([
                this.fetchCsv<TreeData>('/data/TREE.csv'),
                this.fetchCsv<PlotData>('/data/PLOT.csv'),
                this.fetchCsv<OluData>('/data/OLU.csv'),
                this.fetchCsv<DiriData>('/data/DIRI.csv'),
                this.fetchCsv<ToprakData>('/data/TOPRAK.csv'),
                this.fetchCsv<SuData>('/data/SU.csv'),
                this.fetchCsv<KarbonData>('/data/KARBON.csv'),
            ])

            this.treeData = tree
            this.plotData = plot
            this.oluData = olu
            this.diriData = diri
            this.toprakData = toprak
            this.suData = su
            this.karbonData = karbon

            console.log('All data loaded successfully')
        } catch (error) {
            console.error('Error loading data:', error)
        }
    }

    private fetchCsv<T>(url: string): Promise<T[]> {
        return new Promise((resolve, reject) => {
            Papa.parse(url, {
                download: true,
                header: true,
                dynamicTyping: true,
                skipEmptyLines: true,
                complete: (results) => {
                    resolve(results.data as T[])
                },
                error: (error) => {
                    reject(error)
                }
            })
        })
    }
}

export const dataManager = DataManager.getInstance()
