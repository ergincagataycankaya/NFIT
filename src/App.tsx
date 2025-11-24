import { useEffect } from 'react'
import Lenis from 'lenis'
import { CanvasContainer } from './components/CanvasContainer'
import { Hero } from './components/Hero'
import { Projects } from './components/Projects'
import { Thesis } from './components/Thesis'
import { Dashboard } from './components/Dashboard'
import { LanguageProvider } from './contexts/LanguageContext'
import { LanguageToggle } from './components/LanguageToggle'
import { useData } from './hooks/useData'
import './App.css'

function AppContent() {
    const { loading } = useData()

    useEffect(() => {
        const lenis = new Lenis()

        function raf(time: number) {
            lenis.raf(time)
            requestAnimationFrame(raf)
        }

        requestAnimationFrame(raf)
    }, [])

    if (loading) {
        return (
            <div style={{
                height: '100vh',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                background: '#101010',
                color: 'white',
                fontSize: '1.5rem'
            }}>
                Loading Data...
            </div>
        )
    }

    return (
        <main>
            <LanguageToggle />
            <CanvasContainer />
            <Hero />
            <Thesis />
            <Dashboard />
            <Projects />
            <div style={{ height: '50vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <p>More coming soon...</p>
            </div>
        </main>
    )
}

function App() {
    return (
        <LanguageProvider>
            <AppContent />
        </LanguageProvider>
    )
}

export default App
