import type { ReactNode } from 'react'
import { Header } from './Header'
import { Sidebar } from './Sidebar'

interface MainLayoutProps {
    children: ReactNode
}

export const MainLayout = ({ children }: MainLayoutProps) => {
    return (
        <div className="dashboard-container">
            <Header />
            <div className="dashboard-body">
                <Sidebar />
                <main className="dashboard-main">
                    {children}
                </main>
            </div>
        </div>
    )
}
