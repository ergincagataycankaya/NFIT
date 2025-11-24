import { useLanguage } from '../../contexts/LanguageContext'

export const Header = () => {
    const { language, toggleLanguage, t } = useLanguage()

    return (
        <header className="nfit-header">
            <div className="header-content">
                <div className="header-left">
                    <img
                        src="https://resmim.net/cdn/2022/02/22/NSEtc.png"
                        alt="OGM Logo"
                        className="header-logo"
                    />
                    <h1 className="header-title">{t('mainTitle')}</h1>
                </div>

                <div className="header-right">
                    <button
                        className="lang-toggle"
                        onClick={toggleLanguage}
                        aria-label="Toggle language"
                    >
                        {language === 'tr' ? 'EN' : 'TR'}
                    </button>

                    <button
                        className="info-button"
                        onClick={() => {
                            alert(t('appInfo'))
                        }}
                        aria-label="Information"
                    >
                        <i className="fas fa-info-circle"></i>
                    </button>
                </div>
            </div>
        </header>
    )
}
