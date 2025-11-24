import { useEffect } from 'react'
import Lenis from 'lenis'
import { CanvasContainer } from './components/CanvasContainer'
import { Hero } from './components/Hero'
import { Projects } from './components/Projects'
import { Thesis } from './components/Thesis'
import { LanguageProvider } from './contexts/LanguageContext'
import { LanguageToggle } from './components/LanguageToggle'
import './App.css'

function AppContent() {
  useEffect(() => {
    const lenis = new Lenis()

    function raf(time: number) {
      lenis.raf(time)
      requestAnimationFrame(raf)
    }

    requestAnimationFrame(raf)
  }, [])

  return (
    <main>
      <LanguageToggle />
      <CanvasContainer />
      <Hero />
      <Thesis />
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
