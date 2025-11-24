import { useLanguage } from '../../contexts/LanguageContext'
import { YearPieChart } from './YearPieChart'

export const HomePage = () => {
    const { t } = useLanguage()

    return (
        <div className="home-page">
            <div className="content-box">
                <div className="content-box-header">
                    <h3 className="content-box-title">{t('welcome')}</h3>
                </div>
                <div className="content-box-body">
                    <div className="welcome-content">
                        <div className="nfit-intro">
                            <img
                                src="https://resmim.net/cdn/2022/02/22/NSEtc.png"
                                alt="OGM Logo"
                                style={{ display: 'block', margin: '0 auto 20px', width: '200px' }}
                            />

                            <h2 style={{ textAlign: 'center', color: '#00a65a', marginBottom: '20px' }}>
                                {t('mainTitle')}
                            </h2>

                            <div className="thesis-info" style={{ marginBottom: '30px' }}>
                                <h3 style={{ color: '#444', marginBottom: '10px' }}>{t('thesisTitle')}</h3>
                                <p style={{ fontSize: '16px', color: '#666', marginBottom: '5px' }}>{t('thesisSubtitle')}</p>
                                <p style={{ fontSize: '14px', color: '#888' }}>
                                    <strong>{t('author')}</strong> - {t('year')}<br />
                                    {t('university')}<br />
                                    {t('department')}<br />
                                    {t('degree')}
                                </p>
                            </div>

                            <div className="app-description" style={{ marginBottom: '30px', lineHeight: '1.8' }}>
                                <p>{t('appInfo')}</p>
                            </div>

                            <div className="instructions-section" style={{ background: '#f4f4f4', padding: '20px', borderRadius: '8px', marginBottom: '30px' }}>
                                <h4 style={{ marginTop: 0 }}>{t('instructions')}</h4>
                                <ul style={{ lineHeight: '1.8' }}>
                                    <li>Use the sidebar menu to navigate between different data categories</li>
                                    <li>Select sample points from dropdown menus to view detailed information</li>
                                    <li>Toggle between spatial maps, data tables, graphs, and overview dashboards</li>
                                    <li>Switch language between Turkish and English using the language toggle</li>
                                    <li>Download data as CSV files from numerical view sections</li>
                                </ul>
                            </div>

                            <div className="video-tutorials" style={{ marginBottom: '30px' }}>
                                <h4>Tutorial Videos</h4>
                                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '20px', marginTop: '15px' }}>
                                    <div style={{ position: 'relative', paddingBottom: '56.25%', height: 0, overflow: 'hidden' }}>
                                        <iframe
                                            src="https://www.youtube.com/embed/UlwetFrA6ic"
                                            style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%', border: 0 }}
                                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                            allowFullScreen
                                            title="Tutorial Video 1"
                                        />
                                    </div>
                                    <div style={{ position: 'relative', paddingBottom: '56.25%', height: 0, overflow: 'hidden' }}>
                                        <iframe
                                            src="https://www.youtube.com/embed/qp-jazAirE4"
                                            style={{ position: 'absolute', top: 0, left: 0, width: '100%', height: '100%', border: 0 }}
                                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                            allowFullScreen
                                            title="Tutorial Video 2"
                                        />
                                    </div>
                                </div>
                            </div>

                            <div className="contact-section" style={{ marginTop: '30px', borderTop: '2px solid #eee', paddingTop: '20px' }}>
                                <h4>{t('contact')}</h4>
                                <p>
                                    <strong>Author:</strong> <a href="https://www.linkedin.com/in/Ergincagataycankaya/" target="_blank" rel="noopener noreferrer">Ergin Çağatay ÇANKAYA</a><br />
                                    <strong>Thesis Advisor:</strong> <a href="https://sayfam.btu.edu.tr/turan.sonmez" target="_blank" rel="noopener noreferrer">Prof. Dr. Turan SÖNMEZ</a><br />
                                    <strong>Special Thanks:</strong> <a href="https://www.ogm.gov.tr/tr/kurulusumuz-sitesi/Pages/orman-idaresi-ve-planlama-dairesi-baskanligi.aspx" target="_blank" rel="noopener noreferrer">Orman İdaresi ve Planlama Dairesi Başkanlığı</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div className="content-box">
                <div className="content-box-header">
                    <h3 className="content-box-title">Sample Point Distribution by Year</h3>
                </div>
                <div className="content-box-body">
                    <YearPieChart />
                </div>
            </div>
        </div>
    )
}
