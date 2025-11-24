import { useLanguage } from '../contexts/LanguageContext'

export const LanguageToggle = () => {
    const { language, toggleLanguage } = useLanguage()

    return (
        <button
            onClick={toggleLanguage}
            style={{
                position: 'fixed',
                top: '2rem',
                right: '2rem',
                zIndex: 100,
                padding: '0.5rem 1rem',
                background: 'rgba(255, 255, 255, 0.1)',
                backdropFilter: 'blur(10px)',
                border: '1px solid rgba(255, 255, 255, 0.2)',
                borderRadius: '20px',
                color: 'white',
                cursor: 'pointer',
                fontWeight: 'bold',
                transition: 'all 0.3s ease'
            }}
            onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(255, 255, 255, 0.2)'}
            onMouseLeave={(e) => e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)'}
        >
            {language === 'en' ? 'TR' : 'EN'}
        </button>
    )
}
