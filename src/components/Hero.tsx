import { useLanguage } from '../contexts/LanguageContext'

export const Hero = () => {
    const { t } = useLanguage()

    return (
        <section style={{
            height: '100vh',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            color: 'white',
            pointerEvents: 'none',
            padding: '0 1rem'
        }}>
            <h1 style={{ fontSize: 'var(--font-size-h1)', margin: 0, pointerEvents: 'auto', textAlign: 'center', lineHeight: 1.1 }}>{t('creativeDev')}</h1>
            <p style={{ fontSize: 'var(--font-size-h3)', pointerEvents: 'auto', textAlign: 'center', marginTop: '1rem' }}>{t('buildingExp')}</p>
        </section>
    )
}
