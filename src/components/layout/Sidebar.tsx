import { NavLink } from 'react-router-dom'
import { useLanguage } from '../../contexts/LanguageContext'

export const Sidebar = () => {
    const { t } = useLanguage()

    return (
        <aside className="nfit-sidebar">
            <nav className="sidebar-nav">
                <NavLink to="/" className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}>
                    <i className="fas fa-home"></i>
                    <span>{t('home')}</span>
                </NavLink>

                <NavLink to="/plot" className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}>
                    <i className="fas fa-map"></i>
                    <span>{t('plotInfo')}</span>
                </NavLink>

                <div className="nav-category">
                    <div className="nav-category-title">
                        <i className="fas fa-tree"></i>
                        <span>{t('treeData')}</span>
                    </div>
                    <div className="nav-submenu">
                        <NavLink to="/tree/spatial">{t('spatial')}</NavLink>
                        <NavLink to="/tree/numerical">{t('numerical')}</NavLink>
                        <NavLink to="/tree/graphical">{t('graphical')}</NavLink>
                        <NavLink to="/tree/overview">{t('overview')}</NavLink>
                        <NavLink to="/tree/distribution">{t('treeDistribution')}</NavLink>
                    </div>
                </div>

                <div className="nav-category">
                    <div className="nav-category-title">
                        <i className="fas fa-cannabis"></i>
                        <span>{t('deadWood')}</span>
                    </div>
                    <div className="nav-submenu">
                        <NavLink to="/olu/spatial">{t('spatial')}</NavLink>
                        <NavLink to="/olu/numerical">{t('numerical')}</NavLink>
                        <NavLink to="/olu/graphical">{t('graphical')}</NavLink>
                        <NavLink to="/olu/overview">{t('overview')}</NavLink>
                    </div>
                </div>

                <div className="nav-category">
                    <div className="nav-category-title">
                        <i className="fas fa-envira"></i>
                        <span>{t('groundCover')}</span>
                    </div>
                    <div className="nav-submenu">
                        <NavLink to="/diri/spatial">{t('spatial')}</NavLink>
                        <NavLink to="/diri/numerical">{t('numerical')}</NavLink>
                        <NavLink to="/diri/graphical">{t('graphical')}</NavLink>
                        <NavLink to="/diri/overview">{t('overview')}</NavLink>
                    </div>
                </div>

                <div className="nav-category">
                    <div className="nav-category-title">
                        <i className="fas fa-solar-panel"></i>
                        <span>{t('soilData')}</span>
                    </div>
                    <div className="nav-submenu">
                        <NavLink to="/toprak/spatial">{t('spatial')}</NavLink>
                        <NavLink to="/toprak/numerical">{t('numerical')}</NavLink>
                        <NavLink to="/toprak/graphical">{t('graphical')}</NavLink>
                        <NavLink to="/toprak/overview">{t('overview')}</NavLink>
                    </div>
                </div>

                <div className="nav-category">
                    <div className="nav-category-title">
                        <i className="fas fa-pagelines"></i>
                        <span>{t('carbonBalance')}</span>
                    </div>
                    <div className="nav-submenu">
                        <NavLink to="/karbon/spatial">{t('spatial')}</NavLink>
                        <NavLink to="/karbon/numerical">{t('numerical')}</NavLink>
                        <NavLink to="/karbon/graphical">{t('graphical')}</NavLink>
                        <NavLink to="/karbon/overview">{t('overview')}</NavLink>
                    </div>
                </div>

                <div className="nav-category">
                    <div className="nav-category-title">
                        <i className="fas fa-tint"></i>
                        <span>{t('waterBalance')}</span>
                    </div>
                    <div className="nav-submenu">
                        <NavLink to="/su/spatial">{t('spatial')}</NavLink>
                        <NavLink to="/su/numerical">{t('numerical')}</NavLink>
                        <NavLink to="/su/graphical">{t('graphical')}</NavLink>
                        <NavLink to="/su/overview">{t('overview')}</NavLink>
                    </div>
                </div>

                <NavLink to="/versions" className={({ isActive }) => isActive ? "nav-item active" : "nav-item"}>
                    <i className="fas fa-tasks"></i>
                    <span>{t('versions')}</span>
                </NavLink>
            </nav>

            <div className="sidebar-footer">
                <div className="social-links">
                    <a href="https://tr-tr.facebook.com/OGMgovtr" target="_blank" rel="noopener noreferrer">
                        <i className="fab fa-facebook-square"></i>
                    </a>
                    <a href="https://www.youtube.com/channel/UC9UlnBFzP3lQ2ZBc5oO6Yiw" target="_blank" rel="noopener noreferrer">
                        <i className="fab fa-youtube"></i>
                    </a>
                    <a href="https://twitter.com/ogmgovtr?lang=tr" target="_blank" rel="noopener noreferrer">
                        <i className="fab fa-twitter"></i>
                    </a>
                    <a href="https://www.instagram.com/ogmgovtr/?hl=tr" target="_blank" rel="noopener noreferrer">
                        <i className="fab fa-instagram"></i>
                    </a>
                </div>
                <p className="copyright">
                    © {new Date().getFullYear()} - <a href="https://www.linkedin.com/in/Ergincagataycankaya/" target="_blank" rel="noopener noreferrer">Ergin Çağatay ÇANKAYA</a>
                </p>
            </div>
        </aside>
    )
}
