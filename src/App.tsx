import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { LanguageProvider } from './contexts/LanguageContext'
import { MainLayout } from './components/layout/MainLayout'
import { HomePage } from './components/home/HomePage'
import { PlotSpatial } from './components/categories/PlotSpatial'
import { PlotNumerical } from './components/categories/PlotNumerical'
import { TreeNumerical } from './components/categories/TreeNumerical'
import { TreeOverview } from './components/categories/TreeOverview'
import { GraphicalView } from './components/data-views/GraphicalView'
import './styles/dashboard.css'
import './index.css'

// Placeholder component for pages under construction
const UnderConstruction = ({ title }: { title: string }) => (
    <div className="content-box">
        <div className="content-box-header">
            <h3 className="content-box-title">{title}</h3>
        </div>
        <div className="content-box-body">
            <div style={{ padding: '40px', textAlign: 'center', color: '#666' }}>
                <i className="fas fa-tools" style={{ fontSize: '64px', marginBottom: '20px', display: 'block', color: '#00a65a' }}></i>
                <h3>Under Construction</h3>
                <p>This feature is being developed and will be available soon.</p>
            </div>
        </div>
    </div>
)

function App() {
    return (
        <LanguageProvider>
            <BrowserRouter>
                <MainLayout>
                    <Routes>
                        {/* Home */}
                        <Route path="/" element={<HomePage />} />

                        {/* PLOT Routes */}
                        <Route path="/plot" element={<PlotSpatial />} />

                        {/* TREE Routes */}
                        <Route path="/tree/spatial" element={<UnderConstruction title="Tree Inventory - Spatial View" />} />
                        <Route path="/tree/numerical" element={<TreeNumerical />} />
                        <Route path="/tree/graphical" element={<GraphicalView />} />
                        <Route path="/tree/overview" element={<TreeOverview />} />
                        <Route path="/tree/distribution" element={<UnderConstruction title="Tree Distribution" />} />

                        {/* OLU Routes */}
                        <Route path="/olu/spatial" element={<UnderConstruction title="Dead Wood - Spatial View" />} />
                        <Route path="/olu/numerical" element={<UnderConstruction title="Dead Wood - Numerical Data" />} />
                        <Route path="/olu/graphical" element={<GraphicalView />} />
                        <Route path="/olu/overview" element={<UnderConstruction title="Dead Wood - Overview" />} />

                        {/* DIRI Routes */}
                        <Route path="/diri/spatial" element={<UnderConstruction title="Ground Cover - Spatial View" />} />
                        <Route path="/diri/numerical" element={<UnderConstruction title="Ground Cover - Numerical Data" />} />
                        <Route path="/diri/graphical" element={<GraphicalView />} />
                        <Route path="/diri/overview" element={<UnderConstruction title="Ground Cover - Overview" />} />

                        {/* TOPRAK Routes */}
                        <Route path="/toprak/spatial" element={<UnderConstruction title="Soil - Spatial View" />} />
                        <Route path="/toprak/numerical" element={<UnderConstruction title="Soil - Numerical Data" />} />
                        <Route path="/toprak/graphical" element={<GraphicalView />} />
                        <Route path="/toprak/overview" element={<UnderConstruction title="Soil - Overview" />} />

                        {/* KARBON Routes */}
                        <Route path="/karbon/spatial" element={<UnderConstruction title="Carbon Balance - Spatial View" />} />
                        <Route path="/karbon/numerical" element={<UnderConstruction title="Carbon Balance - Numerical Data" />} />
                        <Route path="/karbon/graphical" element={<GraphicalView />} />
                        <Route path="/karbon/overview" element={<UnderConstruction title="Carbon Balance - Overview" />} />

                        {/* SU Routes */}
                        <Route path="/su/spatial" element={<UnderConstruction title="Water Balance - Spatial View" />} />
                        <Route path="/su/numerical" element={<UnderConstruction title="Water Balance - Numerical Data" />} />
                        <Route path="/su/graphical" element={<GraphicalView />} />
                        <Route path="/su/overview" element={<UnderConstruction title="Water Balance - Overview" />} />

                        {/* Versions */}
                        <Route path="/versions" element={<UnderConstruction title="Version History" />} />

                        {/* Catch-all */}
                        <Route path="*" element={<UnderConstruction title="Page Not Found" />} />
                    </Routes>
                </MainLayout>
            </BrowserRouter>
        </LanguageProvider>
    )
}

export default App
