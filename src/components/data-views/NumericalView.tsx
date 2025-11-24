import { useState, useMemo } from 'react'
import { useLanguage } from '../../contexts/LanguageContext'

interface NumericalViewProps<T> {
    data: T[]
    title: string
    onDownload?: () => void
}

export function NumericalView<T extends Record<string, any>>({ data, title, onDownload }: NumericalViewProps<T>) {
    const { t } = useLanguage()
    const [currentPage, setCurrentPage] = useState(0)
    const [searchTerm, setSearchTerm] = useState('')
    const rowsPerPage = 50

    // Filter data based on search
    const filteredData = useMemo(() => {
        if (!searchTerm) return data

        return data.filter(row =>
            Object.values(row).some(val =>
                String(val).toLowerCase().includes(searchTerm.toLowerCase())
            )
        )
    }, [data, searchTerm])

    const totalPages = Math.ceil(filteredData.length / rowsPerPage)
    const currentData = filteredData.slice(currentPage * rowsPerPage, (currentPage + 1) * rowsPerPage)

    if (!data || data.length === 0) {
        return <div className="loading-container">No data available</div>
    }

    const columns = Object.keys(data[0])

    const downloadCSV = () => {
        const headers = columns.join(',')
        const rows = data.map(row =>
            columns.map(col => {
                const val = row[col]
                return typeof val === 'string' && val.includes(',') ? `"${val}"` : val
            }).join(',')
        )

        const csv = [headers, ...rows].join('\n')
        const blob = new Blob([csv], { type: 'text/csv' })
        const url = URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = `${title.replace(/\s+/g, '_')}.csv`
        a.click()
        URL.revokeObjectURL(url)
    }

    return (
        <div className="numerical-view">
            <div className="content-box">
                <div className="content-box-header">
                    <h3 className="content-box-title">{title}</h3>
                </div>
                <div className="content-box-body">
                    <div style={{ marginBottom: '15px', display: 'flex', gap: '10px', alignItems: 'center', flexWrap: 'wrap' }}>
                        <input
                            type="text"
                            placeholder="Search..."
                            className="form-control"
                            style={{ maxWidth: '300px' }}
                            value={searchTerm}
                            onChange={(e) => {
                                setSearchTerm(e.target.value)
                                setCurrentPage(0)
                            }}
                        />

                        <button className="btn btn-success" onClick={onDownload || downloadCSV}>
                            <i className="fas fa-download"></i> {t('downloadCSV')}
                        </button>

                        <div style={{ marginLeft: 'auto' }}>
                            Showing {currentPage * rowsPerPage + 1} to {Math.min((currentPage + 1) * rowsPerPage, filteredData.length)} of {filteredData.length} entries
                        </div>
                    </div>

                    <div style={{ overflowX: 'auto' }}>
                        <table style={{ width: '100%', borderCollapse: 'collapse', fontSize: '13px' }}>
                            <thead>
                                <tr style={{ background: '#f4f4f4', borderBottom: '2px solid #ddd' }}>
                                    {columns.map(col => (
                                        <th key={col} style={{ padding: '8px', textAlign: 'left', whiteSpace: 'nowrap' }}>
                                            {col}
                                        </th>
                                    ))}
                                </tr>
                            </thead>
                            <tbody>
                                {currentData.map((row, idx) => (
                                    <tr key={idx} style={{ borderBottom: '1px solid #eee' }}>
                                        {columns.map(col => (
                                            <td key={col} style={{ padding: '6px', whiteSpace: 'nowrap' }}>
                                                {typeof row[col] === 'number' ? row[col].toFixed(2) : row[col]}
                                            </td>
                                        ))}
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    <div style={{ marginTop: '15px', display: 'flex', gap: '10px', justifyContent: 'center', alignItems: 'center' }}>
                        <button
                            className="btn btn-info"
                            onClick={() => setCurrentPage(0)}
                            disabled={currentPage === 0}
                        >
                            First
                        </button>
                        <button
                            className="btn btn-info"
                            onClick={() => setCurrentPage(prev => Math.max(0, prev - 1))}
                            disabled={currentPage === 0}
                        >
                            Previous
                        </button>
                        <span>
                            Page {currentPage + 1} of {totalPages || 1}
                        </span>
                        <button
                            className="btn btn-info"
                            onClick={() => setCurrentPage(prev => Math.min(totalPages - 1, prev + 1))}
                            disabled={currentPage >= totalPages - 1}
                        >
                            Next
                        </button>
                        <button
                            className="btn btn-info"
                            onClick={() => setCurrentPage(totalPages - 1)}
                            disabled={currentPage >= totalPages - 1}
                        >
                            Last
                        </button>
                    </div>
                </div>
            </div>
        </div>
    )
}
