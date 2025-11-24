import { createContext, useContext, useState, type ReactNode } from 'react'

type Language = 'en' | 'tr'

interface LanguageContextType {
    language: Language
    toggleLanguage: () => void
    t: (key: string) => string
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export const translations = {
    en: {
        thesisTitle: "Development of national forest inventory model using artificial intelligence algorithms",
        thesisSubtitle: "A case study of Istanbul Regional Directorate of Forestry",
        university: "Bursa Technical University",
        department: "Forestry and Forest Engineering",
        degree: "PhD Thesis",
        author: "ERGİN ÇAĞATAY ÇANKAYA",
        year: "2025",
        viewDetails: "View Details",
        moreComing: "More content coming soon...",
        scrollDown: "Scroll down to explore",
        creativeDev: "Creative Developer",
        buildingExp: "Building digital experiences",
        selectedWorks: "Selected Works",
        project: "Project"
    },
    tr: {
        thesisTitle: "Yapay zekâ algoritmaları ile ulusal orman envanteri modelinin geliştirilmesi",
        thesisSubtitle: "İstanbul Orman Bölge Müdürlüğü örneği",
        university: "Bursa Teknik Üniversitesi",
        department: "Ormancılık ve Orman Mühendisliği",
        degree: "Doktora Tezi",
        author: "ERGİN ÇAĞATAY ÇANKAYA",
        year: "2025",
        viewDetails: "Detayları Gör",
        moreComing: "Daha fazlası yakında...",
        scrollDown: "Keşfetmek için aşağı kaydırın",
        creativeDev: "Yaratıcı Geliştirici",
        buildingExp: "Dijital deneyimler inşa ediyor",
        selectedWorks: "Seçilmiş İşler",
        project: "Proje"
    }
}

export const LanguageProvider = ({ children }: { children: ReactNode }) => {
    const [language, setLanguage] = useState<Language>('en')

    const toggleLanguage = () => {
        setLanguage(prev => prev === 'en' ? 'tr' : 'en')
    }

    const t = (key: string) => {
        // @ts-ignore
        return translations[language][key] || key
    }

    return (
        <LanguageContext.Provider value={{ language, toggleLanguage, t }}>
            {children}
        </LanguageContext.Provider>
    )
}

export const useLanguage = () => {
    const context = useContext(LanguageContext)
    if (!context) {
        throw new Error('useLanguage must be used within a LanguageProvider')
    }
    return context
}
