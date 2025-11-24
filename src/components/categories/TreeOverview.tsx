import { useState, useMemo } from 'react'
import { useLanguage } from '../../contexts/LanguageContext'
import { useData } from '../../hooks/useData'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts'

export const TreeOverview = () => {
    const { t } = useLanguage()
    const { treeData, loading } = useData()
    const [selectedSpecies, setSelectedSpecies] = useState('Kayın')

    const species = useMemo(() => {
        if (!treeData) return []
        return Array.from(new Set(treeData.map(t => t.AGAC_ADI))).sort()
    }, [treeData])

    const chartData = useMemo(() => {
        if (!treeData || !selectedSpecies) return []

        const filteredData = treeData.filter(t => t.AGAC_ADI === selectedSpecies)
        const grouped: Record<string, { totalHacim: number, totalArtim: number, count: number }> = {}

        filteredData.forEach(tree => {
            const mgmt = tree.MUDURLUK_ADI || 'Unknown'
            if (!grouped[mgmt]) {
                grouped[mgmt] = { totalHacim: 0, totalArtim: 0, count: 0 }
            }
            grouped[mgmt].totalHacim += tree.HACIM || 0
            grouped[mgmt].totalArtim += tree.ARTIM || 0
            grouped[mgmt].count += 1
        })

        return Object.entries(grouped).map(([name, data]) => ({
            name,
            avgHacim: data.totalHacim / data.count,
            avgArtim: data.totalArtim / data.count
        }))
    }, [treeData, selectedSpecies])

    if (loading) {
        return <div className="loading-container">{t('loading')}</div>
    }

    return (
        <div className="tree-overview">
            <div className="content-box">
                <div className="content-box-header">
                    <h3 className="content-box-title">TREE INVENTORY - Overview</h3>
                </div>
                <div className="content-box-body">
                    <div className="form-group" style={{ maxWidth: '400px', margin: '0 auto 30px' }}>
                        <label className="form-label">{t('selectSpecies')}</label>
                        <select
                            className="form-control"
                            value={selectedSpecies}
                            onChange={(e) => setSelectedSpecies(e.target.value)}
                        >
                            {species.map(sp => (
                                <option key={sp} value={sp}>{sp}</option>
                            ))}
                        </select>
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(500px, 1fr))', gap: '20px' }}>
                        <div className="content-box">
                            <div className="content-box-header">
                                <h4 className="content-box-title">Average Volume (m³/ha)</h4>
                            </div>
                            <div className="content-box-body">
                                <ResponsiveContainer width="100%" height={300}>
                                    <BarChart data={chartData}>
                                        <CartesianGrid strokeDasharray="3 3" />
                                        <XAxis dataKey="name" angle={-45} textAnchor="end" height={100} />
                                        <YAxis />
                                        <Tooltip />
                                        <Legend />
                                        <Bar dataKey="avgHacim" fill="#00a65a" name="Avg Volume" />
                                    </BarChart>
                                </ResponsiveContainer>
                            </div>
                        </div>

                        <div className="content-box">
                            <div className="content-box-header">
                                <h4 className="content-box-title">Average Increment (m³/ha)</h4>
                            </div>
                            <div className="content-box-body">
                                <ResponsiveContainer width="100%" height={300}>
                                    <BarChart data={chartData}>
                                        <CartesianGrid strokeDasharray="3 3" />
                                        <XAxis dataKey="name" angle={-45} textAnchor="end" height={100} />
                                        <YAxis />
                                        <Tooltip />
                                        <Legend />
                                        <Bar dataKey="avgArtim" fill="#f39c12" name="Avg Increment" />
                                    </BarChart>
                                </ResponsiveContainer>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}
