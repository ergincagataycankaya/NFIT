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
        mainTitle: "NATIONAL FOREST INVENTORY",
        home: "HOME",
        plotInfo: "PLOT INFORMATION",
        treeData: "TREE INVENTORY & BIOMASS",
        deadWood: "DEAD WOOD INFORMATION",
        groundCover: "LIVING GROUND COVER",
        soilData: "SOIL INFORMATION",
        carbonBalance: "CARBON BALANCE",
        waterBalance: "WATER BALANCE",
        versions: "VERSIONS",
        spatial: "Spatial",
        numerical: "Numerical",
        graphical: "Graphical",
        overview: "Overview",
        treeDistribution: "Tree Distribution",
        appInfo: "This application was designed as a reporting interface for the doctoral thesis 'Development of National Forest Inventory Model Using Artificial Intelligence Algorithms: A Case Study of Istanbul Regional Directorate of Forestry' by Ergin Çağatay ÇANKAYA.",
        thesisTitle: "Development of national forest inventory model using artificial intelligence algorithms",
        thesisSubtitle: "A case study of Istanbul Regional Directorate of Forestry",
        university: "Bursa Technical University",
        department: "Forestry and Forest Engineering",
        degree: "PhD Thesis",
        author: "ERGİN ÇAĞATAY ÇANKAYA",
        year: "2025",
        viewDetails: "View Details",
        selectSample: "SELECT SAMPLE POINT:",
        selectSpecies: "Select Tree Species:",
        selectYear: "Select Year:",
        selectHorizon: "Select Soil Horizon:",
        downloadCSV: "Download Dataset as CSV",
        loading: "Loading Data...",
        welcome: "Welcome",
        instructions: "Instructions",
        contact: "Contact",
    },
    tr: {
        mainTitle: "ULUSAL ORMAN ENVANTERİ",
        home: "GİRİŞ",
        plotInfo: "ÖRNEK ALAN BİLGİLERİ",
        treeData: "AĞAÇ SERVETİ-ARTIM ve CANLI KÜTLE",
        deadWood: "ÖLÜ AĞAÇ/ODUN BİLGİLERİ",
        groundCover: "DİRİ ÖRTÜ BİLGİLERİ",
        soilData: "TOPRAK BİLGİLERİ",
        carbonBalance: "KARBON BİLANÇOSU",
        waterBalance: "SU BİLANÇOSU",
        versions: "VERSİYONLAR",
        spatial: "Konumsal",
        numerical: "Sayısal",
        graphical: "Grafiksel",
        overview: "Genel Görünüm",
        treeDistribution: "Ağaçların Dağılımı",
        appInfo: "Bu uygulama Ergin Çağatay ÇANKAYA tarafından 'Yapay Zeka Algoritmaları ile Ulusal Orman Envanteri Modelinin Geliştirilmesi: İstanbul Orman Bölge Müdürlüğü Örneği' adlı doktora tez çalışmasının raporlama arayüzü olarak tasarlanmıştır.",
        thesisTitle: "Yapay zekâ algoritmaları ile ulusal orman envanteri modelinin geliştirilmesi",
        thesisSubtitle: "İstanbul Orman Bölge Müdürlüğü örneği",
        university: "Bursa Teknik Üniversitesi",
        department: "Ormancılık ve Orman Mühendisliği",
        degree: "Doktora Tezi",
        author: "ERGİN ÇAĞATAY ÇANKAYA",
        year: "2025",
        viewDetails: "Detayları Gör",
        selectSample: "ÖRNEK NOKTA NO:",
        selectSpecies: "Ağaç Türü Seçiniz:",
        selectYear: "Yıl Seçiniz:",
        selectHorizon: "Toprak Horizonu Seçiniz:",
        downloadCSV: "Verisetini .csv uzantılı indir",
        loading: "Veriler Yükleniyor...",
        welcome: "Hoş Geldiniz",
        instructions: "Kullanım Talimatları",
        contact: "İletişim",
    }
}

export const LanguageProvider = ({ children }: { children: ReactNode }) => {
    const [language, setLanguage] = useState<Language>('tr')

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
