import { useData } from '../../hooks/useData'
import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from 'recharts'

const COLORS = ['#FFEB3B', '#4CAF50', '#F44336', '#2196F3', '#9C27B0']

export const YearPieChart = () => {
    const { plotData } = useData()

    if (!plotData || plotData.length === 0) {
        return <div className="loading-container">Loading chart data...</div>
    }

    // Count samples by year
    const yearCounts: Record<string, number> = {}
    plotData.forEach(plot => {
        const year = String(plot.ENVANTER_TARIHI).substring(0, 4)
        yearCounts[year] = (yearCounts[year] || 0) + 1
    })

    const chartData = Object.entries(yearCounts)
        .map(([year, count]) => ({
            name: year,
            value: count
        }))
        .sort((a, b) => a.name.localeCompare(b.name))

    return (
        <ResponsiveContainer width="100%" height={400}>
            <PieChart>
                <Pie
                    data={chartData}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, percent }) => `${name}: ${percent ? (percent * 100).toFixed(0) : 0}%`}
                    outerRadius={120}
                    fill="#8884d8"
                    dataKey="value"
                >
                    {chartData.map((_, index) => (
                        <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                    ))}
                </Pie>
                <Tooltip />
                <Legend />
            </PieChart>
        </ResponsiveContainer>
    )
}
