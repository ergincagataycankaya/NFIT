export interface TreeData {
  ORNEK_NO: number
  AGAC_ADI: string
  CAP?: number
  BOY?: number
  HACIM?: number
  ARTIM?: number
  [key: string]: any
}

export interface PlotData {
  ORNEK_NO: number
  BOLGE_ADI: string
  MUDURLUK_ADI: string
  SEFLIK_ADI: string
  ENVANTER_TARIHI: string
  AKTUEL_MES_TIP: string
  PLANDAKI_MESCERE_TIPI: string
  EGIM: number
  RAKIM: number
  BAKI: string
  ENLEM?: number
  BOYLAM?: number
  [key: string]: any
}

export interface OluData {
  ORNEK_NO: number
  AGAÇ_ADI: string
  [key: string]: any
}

export interface DiriData {
  ORNEK_NO: number
  BİTKİ_ÖRTÜSÜ_TÜR: string
  [key: string]: any
}

export interface ToprakData {
  ORNEK_NO: number
  Horizon: string
  [key: string]: any
}

export interface SuData {
  ORNEK_NO: number
  YIL: number
  [key: string]: any
}

export interface KarbonData {
  ORNEK_NO: number
  [key: string]: any
}
