import { useState } from 'react'
import { PlotView } from './PlotView'
import { TreeView } from './TreeView'

export const Dashboard = () => {
    const [activeTab, setActiveTab] = useState<'plot' | 'tree'>('plot')

    return (
        <section style={{ padding: '4rem 2rem', minHeight: '100vh', background: '#1a1a1a' }}>
            <h2 style={{ fontSize: '3rem', textAlign: 'center', marginBottom: '2rem' }}>Forest Inventory Dashboard</h2>

            <div style={{ display: 'flex', justifyContent: 'center', gap: '1rem', marginBottom: '2rem' }}>
                <button
                    onClick={() => setActiveTab('plot')}
                    style={{
                        padding: '0.5rem 1.5rem',
                        background: activeTab === 'plot' ? '#646cff' : '#333',
                        border: 'none',
                        borderRadius: '8px',
                        color: 'white',
                        cursor: 'pointer'
                    }}
                >
                    Plot Data
                </button>
                <button
                    onClick={() => setActiveTab('tree')}
                    style={{
                        padding: '0.5rem 1.5rem',
                        background: activeTab === 'tree' ? '#646cff' : '#333',
                        border: 'none',
                        borderRadius: '8px',
                        color: 'white',
                        cursor: 'pointer'
                    }}
                >
                    Tree Data
                </button>
            </div>

            <div style={{ background: '#242424', padding: '2rem', borderRadius: '16px' }}>
                {activeTab === 'plot' && <PlotView />}
                {activeTab === 'tree' && <TreeView />}
            </div>
        </section>
    )
}
