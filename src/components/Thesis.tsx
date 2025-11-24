import { useLanguage } from '../contexts/LanguageContext'

export const Thesis = () => {
    const { t } = useLanguage()

    return (
        <section style={{
            padding: '6rem 1rem',
            position: 'relative',
            zIndex: 1,
            background: 'linear-gradient(180deg, rgba(0,0,0,0) 0%, rgba(0,0,0,0.5) 100%)'
        }}>
            <div style={{
                maxWidth: '1000px',
                margin: '0 auto',
                background: 'rgba(255, 255, 255, 0.03)',
                backdropFilter: 'blur(20px)',
                borderRadius: '24px',
                padding: '2rem',
                border: '1px solid rgba(255, 255, 255, 0.1)',
                boxShadow: '0 20px 40px rgba(0,0,0,0.3)'
            }}>
                <div style={{
                    display: 'inline-block',
                    padding: '0.5rem 1rem',
                    background: 'rgba(100, 108, 255, 0.2)',
                    color: '#646cff',
                    borderRadius: '20px',
                    fontSize: '0.9rem',
                    fontWeight: 'bold',
                    marginBottom: '1.5rem'
                }}>
                    {t('degree')}
                </div>

                <h2 style={{
                    fontSize: 'var(--font-size-h2)',
                    marginBottom: '1rem',
                    background: 'linear-gradient(90deg, #fff, #aaa)',
                    WebkitBackgroundClip: 'text',
                    WebkitTextFillColor: 'transparent',
                    lineHeight: 1.2
                }}>
                    {t('thesisTitle')}
                </h2>

                <h3 style={{
                    fontSize: 'var(--font-size-h3)',
                    color: 'rgba(255,255,255,0.7)',
                    marginBottom: '2rem',
                    fontWeight: 'normal',
                    lineHeight: 1.4
                }}>
                    {t('thesisSubtitle')}
                </h3>

                <div style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
                    gap: '1.5rem',
                    borderTop: '1px solid rgba(255,255,255,0.1)',
                    paddingTop: '2rem'
                }}>
                    <div>
                        <div style={{ fontSize: '0.8rem', color: 'rgba(255,255,255,0.5)', marginBottom: '0.5rem' }}>AUTHOR</div>
                        <div style={{ fontSize: '1rem', fontWeight: '500' }}>{t('author')}</div>
                    </div>
                    <div>
                        <div style={{ fontSize: '0.8rem', color: 'rgba(255,255,255,0.5)', marginBottom: '0.5rem' }}>UNIVERSITY</div>
                        <div style={{ fontSize: '1rem', fontWeight: '500' }}>{t('university')}</div>
                    </div>
                    <div>
                        <div style={{ fontSize: '0.8rem', color: 'rgba(255,255,255,0.5)', marginBottom: '0.5rem' }}>DEPARTMENT</div>
                        <div style={{ fontSize: '1rem', fontWeight: '500' }}>{t('department')}</div>
                    </div>
                    <div>
                        <div style={{ fontSize: '0.8rem', color: 'rgba(255,255,255,0.5)', marginBottom: '0.5rem' }}>YEAR</div>
                        <div style={{ fontSize: '1rem', fontWeight: '500' }}>{t('year')}</div>
                    </div>
                </div>
            </div>
        </section>
    )
}
