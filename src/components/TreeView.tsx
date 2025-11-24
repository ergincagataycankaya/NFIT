import { useData } from '../hooks/useData'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts'

export const TreeView = () => {
    const { treeData } = useData()

    // Aggregate data for chart
    const speciesCount = treeData.reduce((acc, curr) => {
        acc[curr.AGAC_ADI] = (acc[curr.AGAC_ADI] || 0) + 1
        return acc
    }, {} as Record<string, number>)

    const chartData = Object.entries(speciesCount).map(([name, count]) => ({
        name,
        count
    }))

    return (
        <div>
            <h3 style={{ marginBottom: '1rem' }}>Tree Species Distribution</h3>
            <div style={{ height: '400px', marginBottom: '2rem' }}>
                <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={chartData}>
                        <CartesianGrid strokeDasharray="3 3" stroke="#444" />
                        <XAxis dataKey="name" stroke="#888" />
                        <YAxis stroke="#888" />
                        <Tooltip contentStyle={{ backgroundColor: '#333', border: 'none' }} />
                        <Legend />
                        <Bar dataKey="count" fill="#82ca9d" name="Count" />
                    </BarChart>
                </ResponsiveContainer>
            </div>
        </div>
    )
}
