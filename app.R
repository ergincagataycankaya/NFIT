############ Prepared by: Ergin Cankaya #####################
# rm(list = ls())
# gc()

library(shinydashboard)
library(shiny)
library(sf)
library(shinycssloaders)
library(dplyr)
library(DT)
library(raster)
library(tidyr)
library(RColorBrewer)
library(rpivotTable)
library(leafsync)
library(plotly)
library(leaflet.extras)
library(leaflet)
library(formattable)
library(shinymanager)
library(markdown)
# parallelStartSocket(parallel::detectCores())

# Import Data and clean it
# setwd("C:/Users/ergin/OneDrive/Desktop/UOE/")
# conn <- odbcConnectAccess2007("www/uoe.accdb")
# TREE <- sqlFetch(conn, "TREE")
# PLOT <- sqlFetch(conn, "PLOT")
# OLU <- sqlFetch(conn, "OLU")
# DIRI <- sqlFetch(conn, "DIRI")
# KARBON <- sqlFetch(conn, "KARBON")
# TOPRAK <- sqlFetch(conn, "TOPRAK")
# SU <- sqlFetch(conn, "SU")
TREE <- read.csv("www/TREE.csv")
PLOT <- read.csv("www/PLOT.csv")
OLU <- read.csv("www/OLU.csv")
DIRI <- read.csv("www/DIRI.csv")
KARBON <- read.csv("www/TREE.csv")
TOPRAK <- read.csv("www/TOPRAK.csv")
SU <- read.csv("www/SU.csv")

seflik <- readRDS("www/seflik.rds")
ecoregions <- readRDS("www/ecoregions.rds")
ISTANBUL_OBM <- readRDS("www/ISTANBUL_OBM.rds")
ISTANBUL_OIM <- readRDS("www/ISTANBUL_OIM.rds")
# seflik <- sf::st_read("www/veriler.gdb", layer = "seflik")
# ecoregions <- shapefile("www/ecoregions.shp", use_iconv=TRUE, encoding="UTF-8", stringsAsFactors = TRUE)
# ISTANBUL_OBM <- shapefile("www/dis_sinir.shp", use_iconv=TRUE, encoding="UTF-8", stringsAsFactors = TRUE)
# ISTANBUL_OIM <- shapefile("www/ISTANBUL_OIM.shp", use_iconv=TRUE, encoding="UTF-8", stringsAsFactors = TRUE)


factpal_obm <- colorFactor(
  palette = "#1f78b4", # sabit mavi tonu (tek değer için)
  domain = ISTANBUL_OBM$ADI
)
factpal_seflik <- colorFactor(
  palette = colorRampPalette(brewer.pal(9, "Spectral"))(89),
  domain = seflik$SEFLIK_ADI
)

factpal_ecoregions <- colorFactor(brewer.pal(n = length(unique(ecoregions$IKLIM_TIP)), name = "Spectral"), ecoregions$IKLIM_TIP)
factpal <- colorFactor(brewer.pal(n = 11, name = "Spectral"), ISTANBUL_OIM$ISLETME_MD)

# secure database
# define some credentials
# credentials <- data.frame(
#   user = c("ergin", "uoe"), # mandatory
#   password = c("ergin", "uoe"), # mandatory
#   start = c("2021-04-15","2050-04-15"), # optional (all others)
#   expire = c(NA, NA),
#   admin = c(TRUE, TRUE),
#   comment = "Lütfen kullanıcı adı ve şifrenizi giriniz",
#   stringsAsFactors = FALSE
# )

# Define UI for application
ui <-
  shinyUI(
    fluidPage(
      # load custom stylesheet
      includeCSS("www/style.css"),

      # load page layout
      dashboardPage(
        skin = "green",
        dashboardHeader(
          title = "ULUSAL ORMAN ENVANTERİ", titleWidth = 400,
          tags$li(actionLink("openModal", label = "", icon = icon("info")), # user panel on top right corner of shiny
            class = "dropdown"
          )
        ),
        dashboardSidebar(
          width = 400,
          sidebarMenu(
            selectInput("lang", NULL,
              choices = c("Türkçe" = "tr", "English" = "en"),
              selected = "tr"
            ),
            HTML(paste0(
              "<br>",
              "<a href='https://www.ogm.gov.tr/tr'><img style = 'display: block; margin-left: auto; margin-right: auto;' src='https://resmim.net/cdn/2022/02/22/NSEtc.png' width = '185'></a>",
              "<p style = 'text-align: center;'><small><a href='https://www.tarimorman.gov.tr/Sayfalar/Bakanlik.aspx?OgeId=284&Liste=Bakanlik' target='_blank'>OGM Ortak Logo Kullanımları</a></small></p>",
              "<br>"
            )),
            menuItem("GİRİŞ", tabName = "home", icon = icon("home")),
            menuItem("ÖRNEK ALAN BİLGİLERİ", tabName = "PLOT", icon = icon("map")),
            menuItem("AĞAÇ SERVETİ-ARTIM ve CANLI KÜTLE",
              tabName = "TREE", icon = icon("tree"),
              menuSubItem("Konumsal", tabName = "TREE_Konumsal"),
              menuSubItem("Sayısal", tabName = "TREE_Sayisal"),
              menuSubItem("Grafiksel", tabName = "TREE_Grafiksel"),
              menuSubItem("Genel Görünüm", tabName = "TREE_Isi"),
              menuSubItem("Ağaçların Dağılımı", tabName = "TREE_Agaclarin_Dagilimi")
            ),
            menuItem("ÖLÜ AĞAÇ/ODUN BİLGİLERİ",
              tabName = "OLU", icon = icon("cannabis"),
              menuSubItem("Konumsal", tabName = "OLU_Konumsal"),
              menuSubItem("Sayısal", tabName = "OLU_Sayisal"),
              menuSubItem("Grafiksel", tabName = "OLU_Grafiksel"),
              menuSubItem("Genel Görünüm", tabName = "OLU_Isi")
            ),
            menuItem("DİRİ ÖRTÜ BİLGİLERİ",
              tabName = "DIRI", icon = icon("envira"),
              menuSubItem("Konumsal", tabName = "DIRI_Konumsal"),
              menuSubItem("Sayısal", tabName = "DIRI_Sayisal"),
              menuSubItem("Grafiksel", tabName = "DIRI_Grafiksel"),
              menuSubItem("Genel Görünüm", tabName = "DIRI_Isi")
            ),
            menuItem("TOPRAK BİLGİLERİ",
              tabName = "TOPRAK", icon = icon("solar-panel"),
              menuSubItem("Konumsal", tabName = "TOPRAK_Konumsal"),
              menuSubItem("Sayısal", tabName = "TOPRAK_Sayisal"),
              menuSubItem("Grafiksel", tabName = "TOPRAK_Grafiksel"),
              menuSubItem("Genel Görünüm", tabName = "TOPRAK_Isi")
            ),
            menuItem("KARBON BİLANÇOSU",
              tabName = "KARBON", icon = icon("pagelines"),
              menuSubItem("Konumsal", tabName = "KARBON_Konumsal"),
              menuSubItem("Sayısal", tabName = "KARBON_Sayisal"),
              menuSubItem("Grafiksel", tabName = "KARBON_Grafiksel"),
              menuSubItem("Genel Görünüm", tabName = "KARBON_Isi")
            ),
            menuItem("SU BİLANÇOSU",
              tabName = "SU", icon = icon("tint"),
              menuSubItem("Konumsal", tabName = "SU_Konumsal"),
              menuSubItem("Sayısal", tabName = "SU_Sayisal"),
              menuSubItem("Grafiksel", tabName = "SU_Grafiksel"),
              menuSubItem("Genel Görünüm", tabName = "SU_Isi")
            ),
            menuItem("VERSİYONLAR", tabName = "releases", icon = icon("tasks")),
            HTML(
              paste0(
                "<br><br><br><br><br><br><br><br>",
                "<table style='margin-left:auto; margin-right:auto;'>",
                "<tr>",
                "<td style='padding: 5px;'><a href='https://tr-tr.facebook.com/OGMgovtr' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
                "<td style='padding: 5px;'><a href='https://www.youtube.com/channel/UC9UlnBFzP3lQ2ZBc5oO6Yiw' target='_blank'><i class='fab fa-youtube fa-lg'></i></a></td>",
                "<td style='padding: 5px;'><a href='https://twitter.com/ogmgovtr?lang=tr' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
                "<td style='padding: 5px;'><a href='https://www.instagram.com/ogmgovtr/?hl=tr' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
                "</table>",
                "<br>"
              ),
              HTML(paste0(
                "<script>",
                "var today = new Date();",
                "var yyyy = today.getFullYear();",
                "</script>",
                "<p style = 'text-align: center;'><small>&copy; - <a href='https://www.linkedin.com/in/Ergincagataycankaya/' target='_blank'>Ergin Çağatay ÇANKAYA</a> - <script>document.write(yyyy);</script></small></p>"
              ))
            )
          ) # end sidebarMenu
        ), # end dashboardSidebar

        dashboardBody(
          tags$head(tags$style(HTML('
    .main-header .logo {
      font-family: "Georgia", Times, "Times New Roman", serif;
      font-weight: bold;
      font-size: 20px;
    }
  '))),
          tabItems(
            tabItem(
              tabName = "home",
              fluidRow(
                align = "center",
                box(
                  title = "Bilgilendirme",
                  status = "success",
                  solidHeader = TRUE,
                  width = 16,
                  collapsible = TRUE,
                  collapsed = TRUE,
                  tabBox(
                    width = 32,

                    # TAB 1: Giriş
                    tabPanel(
                      title = "Giriş", align = "left",
                      p(strong("Bu bölümde arayüzün kullanımı ile ilgili bilgilere ve Türkiye Orman Varlığına ilişkin kaynaklara yer verilmiştir.")),
                      p("Detaylı bilgi için aşağıdaki kaynaklara göz atabilirsiniz:"),
                      tags$ul(
                        tags$li(tags$a(href = "https://www.ogm.gov.tr/tr/ormanlarimiz-sitesi/TurkiyeOrmanVarligi/Yayinlar/2020%20T%C3%BCrkiye%20Orman%20Varl%C4%B1%C4%9F%C4%B1.pdf", "Türkiye Orman Varlığı Raporu (PDF)")),
                        tags$li(tags$a(href = "https://www.ogm.gov.tr/tr/ormanlarimiz-sitesi/TurkiyeOrmanVarligi/Haritalar/2020%20T%C3%BCrkiye%20Orman%20Varl%C4%B1%C4%9F%C4%B1%20Haritas%C4%B1.jpg", "Orman Varlığı Haritası"))
                      ),
                      tags$h4("Temel Kullanım Talimatları"),
                      tags$ul(
                        tags$li("Orta kısımda yer alan 'ÖRNEK NOKTA NO' seçimi ile farklı noktalara erişim sağlayabilirsiniz."),
                        tags$li("Yıllar için çoklu seçim sunulmuştur; dilediğiniz yılı filtreleyerek karşılaştırma yapabilirsiniz."),
                        tags$li("Sol üstte yer alan katmanlar panelinden uydu görüntüleri ve tematik haritalar (İşletme Müdürlükleri, Şeflikler, İklim Tipleri) aktif hale getirilebilir."),
                        tags$li("Sol alt köşede yer alan cetvel aracı ile mesafe ölçümleri yapılabilir.")
                      ),
                      tags$h4("Diğer Sekmelerde Geçerli Ortak Özellikler"),
                      tags$ul(
                        tags$li("İlgili örnek alan seçimi yapılır ve otomatik olarak yakınlaştırılır."),
                        tags$li("Tematik katmanlar tercihinize göre eklenebilir."),
                        tags$li("Seçilen nokta üzerine tıklanarak özet bilgiler görüntülenebilir.")
                      ),
                      tags$hr(),
                      tags$h4("İletişim ve Katkılar"),
                      p("Yazar:", tags$a(href = "https://www.linkedin.com/in/Ergincagataycankaya/", "Ergin Çağatay ÇANKAYA")),
                      p("Tez Danışmanı:", tags$a(href = "https://sayfam.btu.edu.tr/turan.sonmez", "Prof. Dr. Turan SÖNMEZ")),
                      p("Özel Teşekkür:", tags$a(href = "https://www.ogm.gov.tr/tr/kurulusumuz-sitesi/Pages/orman-idaresi-ve-planlama-dairesi-baskanligi.aspx", "Orman İdaresi ve Planlama Dairesi Başkanlığı"))
                    ),

                    # TAB 2: Eğitim Videosu
                    # TAB 2: Eğitim Videoları
                    tabPanel(
                      title = "Arayüz Kullanımı Eğitim Videoları",
                      fluidRow(
                        column(
                          width = 6, align = "center",
                          div(
                            class = "video-box",
                            tags$iframe(
                              class = "video-frame",
                              src = "https://www.youtube.com/embed/UlwetFrA6ic",
                              frameborder = "0",
                              allow = "autoplay; fullscreen",
                              allowfullscreen = NA
                            )
                          )
                        ),
                        column(
                          width = 6, align = "center",
                          div(
                            class = "video-box",
                            tags$iframe(
                              class = "video-frame",
                              src = "https://www.youtube.com/embed/qp-jazAirE4",
                              frameborder = "0",
                              allow = "autoplay; fullscreen",
                              allowfullscreen = NA
                            )
                          )
                        )
                      )
                    )
                  ) # end tabBox
                ) # end box
              ), # end fluidRow

              includeMarkdown("www/home.md"),

              # Ana ekran pasta grafiği
              fluidRow(
                column(
                  width = 6, offset = 3, align = "center",
                  box(
                    title = "Yıllara Göre Örnek Nokta Adetleri",
                    status = "info",
                    solidHeader = TRUE,
                    width = 12,
                    plotlyOutput("yearPie", height = 350) %>% withSpinner()
                  )
                )
              )
            ),
            tabItem(
              tabName = "PLOT",
              includeMarkdown("www/PLOT.md"),

              # Örnek alan seçimi
              fluidRow(
                column(
                  width = 8, offset = 2, align = "center",
                  selectInput(
                    inputId = "ORNEK_NO",
                    label   = "ÖRNEK NOKTA NO:",
                    choices = sort(unique(PLOT$ORNEK_NO))
                  )
                )
              ),

              # Harita (sayfanın üst yarısı)
              fluidRow(
                column(
                  width = 12,
                  leafletOutput("PLOT", height = 400) %>% withSpinner(color = "green")
                )
              ),

              # Tablo (sayfanın alt yarısı)
              fluidRow(
                column(
                  width = 12,
                  dataTableOutput("PLOT_table")
                )
              )
            ),
            tabItem(
              tabName = "TREE_Konumsal",
              includeMarkdown("www/TREE_Konumsal.md"),
              fluidRow(
                column(
                  8,
                  align = "center", offset = 2,
                  selectizeInput(
                    inputId = "ORNEK_NO",
                    label = "ÖRNEK NOKTA NO:",
                    choices = sort(unique(TREE$ORNEK_NO)),
                    options = list(placeholder = "Select an ÖRNEK NOKTA NO")
                  )
                )
              ),
              leafletOutput("TREE_Konumsal", height = 1000) %>% withSpinner(color = "green")
            ),
            tabItem(tabName = "TREE_Sayisal", dataTableOutput("TREE_Sayisal", width = "100%", height = "auto", fill = TRUE), downloadButton("download1", "Verisetini .csv uzantili indir"), ),
            tabItem(tabName = "TREE_Grafiksel", includeMarkdown("www/TREE_Grafiksel.md"), rpivotTableOutput("TREE_Pivot")),
            tabItem(
              tabName = "TREE_Isi",
              # includeMarkdown("www/TREE_Isi.md"),

              # Species selector centered
              fluidRow(
                column(
                  width = 12, align = "center",
                  selectizeInput(
                    inputId  = "AGAC_ADI",
                    label    = "Ağaç Türü Seçiniz:",
                    choices  = sort(unique(TREE$AGAC_ADI)),
                    selected = "Kayın",
                    options  = list(placeholder = "Ağaç Türü Seçiniz:")
                  )
                )
              ),

              # Row 1: Two heatmaps
              fluidRow(
                box(
                  title = "Isı Haritası — Ortalama Hacim (m³/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("heatmapHacim", height = 400) %>% withSpinner()
                ),
                box(
                  title = "Isı Haritası — Ortalama Artım (m³/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("heatmapArtim", height = 400) %>% withSpinner()
                )
              ),

              # Row 2: Two bar charts
              fluidRow(
                box(
                  title = "Bar Grafik — Hektardaki Ortalama Hacim (m³/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("barChartHacim", height = 300)
                ),
                box(
                  title = "Bar Grafik — Hektardaki Ortalama Artım (m³/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("barChartArtim", height = 300)
                )
              )
            ),

            # dropdown + plot + tree list side‐by‐side
            tabItem(
              tabName = "TREE_Agaclarin_Dagilimi",

              # 1. choose plot
              fluidRow(
                column(
                  width = 8, offset = 2, align = "center",
                  selectInput(
                    inputId = "TREE_DAG_ORNEK_NO",
                    label   = "ÖRNEK NOKTA NO:",
                    choices = sort(unique(TREE$ORNEK_NO))
                  )
                )
              ),

              # 2. plot on left, table on right
              fluidRow(
                column(
                  width = 8,
                  plotlyOutput("TREE_Agaclarin_Dagilimi", height = "750px") %>%
                    withSpinner(color = "green")
                ),
                column(
                  width = 4,
                  shinydashboard::box(
                    title       = "Ağaç Listesi",
                    width       = NULL,
                    status      = "primary",
                    solidHeader = TRUE,
                    tableOutput("tree_list")
                  )
                )
              )
            ),
            tabItem(
              tabName = "OLU_Konumsal", includeMarkdown("www/OLU_Konumsal.md"),
              fluidRow(column(8, align = "center", offset = 2, selectizeInput(inputId = "ORNEK_NO", label = "ÖRNEK NOKTA NO:", choices = sort(unique(OLU$ORNEK_NO)), options = list(placeholder = "Select an ÖRNEK NOKTA NO")))),
              leafletOutput("OLU_Konumsal", height = 1000) %>% withSpinner(color = "green")
            ),
            tabItem(tabName = "OLU_Sayisal", dataTableOutput("OLU_Sayisal", width = "100%", height = "auto", fill = TRUE), downloadButton("download2", "Verisetini .csv uzantili indir"), ),
            tabItem(tabName = "OLU_Grafiksel", includeMarkdown("www/OLU_Grafiksel.md"), rpivotTableOutput("OLU_Pivot")),
            tabItem(
              tabName = "OLU_Isi",
              # includeMarkdown("www/OLU_Isi.md"),

              # Species selector centered
              fluidRow(
                column(
                  width = 12, align = "center",
                  selectizeInput(
                    inputId  = "AGAÇ_ADI",
                    label    = "Ağaç Türü Seçiniz:",
                    choices  = sort(unique(OLU$AGAÇ_ADI)),
                    selected = "Kayın",
                    options  = list(placeholder = "Ağaç Türü Seçiniz:")
                  )
                )
              ),

              # Row 1: Two heatmaps
              fluidRow(
                box(
                  title = "Isı Haritası — Hekt. Ort. Ölü Odun Hacmi (m³/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("OLU_heatmap_hacim", height = 400) %>% withSpinner()
                ),
                box(
                  title = "Isı Haritası — Hekt. Ort. Ölü Odun Karbonu (m³/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("OLU_heatmap_tcbkm", height = 400) %>% withSpinner()
                )
              ),

              # Row 2: Two bar charts
              fluidRow(
                box(
                  title = "Bar Grafik — Hekt. Ort. Ölü Odun Hacmi (m³/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("OLU_bar_hacim", height = 300)
                ),
                box(
                  title = "Bar Grafik — Hekt. Ort. Ölü Odun Karbonu (m³/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("OLU_bar_tcbkm", height = 300)
                )
              )
            ),
            tabItem(
              tabName = "DIRI_Konumsal", includeMarkdown("www/DIRI_Konumsal.md"),
              fluidRow(column(8, align = "center", offset = 2, selectizeInput(inputId = "ORNEK_NO", label = "ÖRNEK NOKTA NO:", choices = sort(unique(DIRI$ORNEK_NO)), options = list(placeholder = "Select an ÖRNEK NOKTA NO")))),
              leafletOutput("DIRI_Konumsal", height = 1000) %>% withSpinner(color = "green")
            ),
            tabItem(tabName = "DIRI_Sayisal", dataTableOutput("DIRI_Sayisal", width = "100%", height = "auto", fill = TRUE), downloadButton("download3", "Verisetini .csv uzantili indir"), ),
            tabItem(tabName = "DIRI_Grafiksel", rpivotTableOutput("DIRI_Pivot")),
            tabItem(
              tabName = "DIRI_Isi",
              # includeMarkdown("www/DIRI_Isi.md"),

              # Species selector centered
              fluidRow(
                column(
                  width = 12, align = "center",
                  selectizeInput(
                    inputId  = "BİTKİ_ÖRTÜSÜ_TÜR",
                    label    = "Diri Örtü Türü Seçiniz:",
                    choices  = sort(unique(DIRI$BİTKİ_ÖRTÜSÜ_TÜR)),
                    selected = "Alıç",
                    options  = list(placeholder = "Diri Örtü Türü Seçiniz:")
                  )
                )
              ),

              # Row 1: Two heatmaps
              fluidRow(
                box(
                  title = "Isı Haritası — Hektardaki Örtme Oranı (%/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("DIRI_heatmap_ortme", height = 400) %>% withSpinner()
                ),
                box(
                  title = "Isı Haritası — Hektardaki Ortalama Boy (m/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("DIRI_heatmap_boy", height = 400) %>% withSpinner()
                )
              ),

              # Row 2: Two bar charts
              fluidRow(
                box(
                  title = "Bar Grafik — Örtme Oranı (%)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("DIRI_bar_ortme", height = 300)
                ),
                box(
                  title = "Bar Grafik — Ortalama Boy (m)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("DIRI_bar_boy", height = 300)
                )
              )
            ),
            tabItem(
              tabName = "KARBON_Konumsal", includeMarkdown("www/KARBON_Konumsal.md"),
              fluidRow(column(8, align = "center", offset = 2, selectizeInput(inputId = "ORNEK_NO", label = "ÖRNEK NOKTA NO:", choices = sort(unique(KARBON$ORNEK_NO)), options = list(placeholder = "Select an ÖRNEK NOKTA NO")))),
              leafletOutput("KARBON_Konumsal", height = 1000) %>% withSpinner(color = "green")
            ),
            tabItem(tabName = "KARBON_Sayisal", dataTableOutput("KARBON_Sayisal", width = "100%", height = "auto", fill = TRUE), downloadButton("download4", "Verisetini .csv uzantili indir"), ),
            tabItem(tabName = "KARBON_Grafiksel", rpivotTableOutput("KARBON_Pivot")),
            tabItem(
              tabName = "KARBON_Isi",
              # includeMarkdown("www/KARBON_Isi.md"),

              # Species selector centered
              fluidRow(
                column(
                  width = 12, align = "center",
                  selectizeInput(
                    inputId  = "AGAC_ADI",
                    label    = "Ağaç Türü Seçiniz:",
                    choices  = sort(unique(TREE$AGAC_ADI)),
                    selected = "Kayın",
                    options  = list(placeholder = "Ağaç Türü Seçiniz:")
                  )
                )
              ),

              # Row 1: Two heatmaps
              fluidRow(
                box(
                  title = "Isı Haritası — Hektardaki Ortalama Canlı Karbon (ton/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("KARBON_heatmap_karbon", height = 400) %>% withSpinner()
                ),
                box(
                  title = "Isı Haritası — Hektardaki Oksijen Üretimi (ton/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("KARBON_heatmap_oksijen", height = 400) %>% withSpinner()
                )
              ),

              # Row 2: Two bar charts
              fluidRow(
                box(
                  title = "Bar Grafik — Hektardaki Ortalama Canlı Karbon (ton/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("KARBON_bar_karbon", height = 300)
                ),
                box(
                  title = "Bar Grafik — Hektardaki Oksijen Üretimi (ton/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("KARBON_bar_oksijen", height = 300)
                )
              )
            ),
            tabItem(
              tabName = "TOPRAK_Konumsal", includeMarkdown("www/TOPRAK_Konumsal.md"),
              fluidRow(column(8, align = "center", offset = 2, selectizeInput(inputId = "ORNEK_NO", label = "ÖRNEK NOKTA NO:", choices = sort(unique(TOPRAK$ORNEK_NO)), options = list(placeholder = "Select an ÖRNEK NOKTA NO")))),
              leafletOutput("TOPRAK_Konumsal", height = 1000) %>% withSpinner(color = "green")
            ),
            tabItem(tabName = "TOPRAK_Sayisal", dataTableOutput("TOPRAK_Sayisal", width = "100%", height = "auto", fill = TRUE), downloadButton("download5", "Verisetini .csv uzantili indir"), ),
            tabItem(tabName = "TOPRAK_Grafiksel", rpivotTableOutput("TOPRAK_Pivot")),
            tabItem(
              tabName = "TOPRAK_Isi",
              # includeMarkdown("www/TOPRAK_Isi.md"),

              # Toprak Horizonu selector centered
              fluidRow(
                column(
                  width = 12, align = "center",
                  selectizeInput(
                    inputId = "Horizon",
                    label = "Toprak Horizonu Seçiniz:",
                    choices = sort(unique(TOPRAK$Horizon)),
                    selected = "A",
                    options = list(placeholder = "Toprak Horizonu Seçiniz:")
                  )
                )
              ),

              # Row 1: Two heatmaps
              fluidRow(
                box(
                  title = "Isı Haritası — Hektardaki Ortalama Organik Madde (ton/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("TOPRAK_heatmap_organikmadde", height = 400) %>% withSpinner()
                ),
                box(
                  title = "Isı Haritası — Hektardaki Ortalama Organik Karbon (ton/ha)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("TOPRAK_heatmap_karbon", height = 400) %>% withSpinner()
                )
              ),

              # Row 2: Two bar charts
              fluidRow(
                box(
                  title = "Bar Grafik — Horizon Katmanına Göre Dağılım - Hektardaki Ortalama Organik Madde (ton/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("TOPRAK_bar_organikmadde", height = 300)
                ),
                box(
                  title = "Bar Grafik — Horizon Katmanına Göre Dağılım - Hektardaki Ortalama Organik Karbon (ton/ha)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("TOPRAK_bar_karbon", height = 300)
                )
              )
            ),
            tabItem(
              tabName = "SU_Konumsal", includeMarkdown("www/SU_Konumsal.md"),
              fluidRow(column(8, align = "center", offset = 2, selectizeInput(inputId = "ORNEK_NO", label = "ÖRNEK NOKTA NO:", choices = sort(unique(SU$ORNEK_NO)), options = list(placeholder = "Select an ÖRNEK NOKTA NO")))),
              leafletOutput("SU_Konumsal", height = 1000) %>% withSpinner(color = "green") %>% withSpinner(color = "green")
            ),
            tabItem(tabName = "SU_Sayisal", dataTableOutput("SU_Sayisal", width = "100%", height = "auto", fill = TRUE), downloadButton("download6", "Verisetini .csv uzantili indir"), ),
            tabItem(tabName = "SU_Grafiksel", includeMarkdown("www/SU_Grafiksel.md"), rpivotTableOutput("SU_Pivot")),
            tabItem(
              tabName = "SU_Isi",
              # includeMarkdown("www/SU_Isi.md"),

              # Species selector centered
              fluidRow(
                column(
                  width = 12, align = "center",
                  selectizeInput(
                    inputId = "YIL",
                    label = "Yıl Seçiniz:",
                    choices = sort(unique(SU$YIL)),
                    selected = 2019,
                    options = list(placeholder = "Yıl Seçiniz:")
                  )
                )
              ),

              # Row 1: Two heatmaps
              fluidRow(
                box(
                  title = "Isı Haritası — Yıllık Su Verimi (mm/yıl)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("SU_heatmap_verim", height = 400) %>% withSpinner()
                ),
                box(
                  title = "Isı Haritası — Yıllık Su Kaybı (mm/yıl)",
                  status = "primary", solidHeader = TRUE,
                  width = 6,
                  leafletOutput("SU_heatmap_kayip", height = 400) %>% withSpinner()
                )
              ),

              # Row 2: Two bar charts
              fluidRow(
                box(
                  title = "Bar Grafik — Yıllık Su Verimi (mm/yıl)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("SU_bar_verim", height = 300)
                ),
                box(
                  title = "Bar Grafik — Yıllık Su Kaybı (mm/yıl)",
                  status = "warning", solidHeader = TRUE,
                  width = 6,
                  plotlyOutput("SU_bar_kayip", height = 300)
                )
              )
            ),
            tabItem(tabName = "releases", includeMarkdown("www/releases.md"))
          ) # end tabItems
        ) # end dashboardBody
      ) # end dashboardPage
    )
  )

# ui <- secure_app(ui,
#                  background  = "linear-gradient(rgba(0, 0, 0, 0),
#                                 rgba(0, 0, 0, 0)),
#                                 url('https://resmim.net/cdn/2022/10/11/t9MEi.jpg');
#                                 background-repeat: no-repeat;
#                                 background-size: cover;
#                                 background-position: center;")


server <- shinyServer(function(input, output, session) {
  observeEvent(input$openModal, { # user panel on top right corner of shiny
    showModal(
      modalDialog(
        title = "Bu APP Nasıl Kullanılır, Lütfen Bilgilendirme Kısımlarını Kontrol Ediniz!",
        p("Bu APP Ergin Çağatay ÇANKAYA tarafından 'Yapay Zeka Algoritmaları ile Ulusal Orman Envanteri Modelinin Geliştirilmesi: İstanbul Orman Bölge Müdürlüğü Örneği' adlı doktora tez çalışmasının raporlama arayüzü olarak tasarlanmıştır.")
      )
    )
  })

  # call the server part
  # check_credentials returns a function to authenticate users
  # res_auth <- secure_server(check_credentials = check_credentials(credentials))


  ##### GİRİŞ EKRANI ######
  output$yearPie <- renderPlotly({
    df <- PLOT %>%
      count(YIL) %>%
      arrange(YIL)

    plot_ly(df,
      labels = ~YIL, values = ~n, type = "pie",
      textinfo = "label+percent",
      insidetextorientation = "radial"
    ) %>%
      layout(
        legend = list(
          orientation = "h", # legend yatay
          x = 0.5, # ortalanmış
          xanchor = "center",
          y = -0.2 # grafiğin altına
        ),
        margin = list(b = 80) # alt boşluk
      )
  })

  ##### PLOT ######
  # new column for the popup label for PLOT
  pops_plot <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", PLOT$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", PLOT$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", PLOT$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", PLOT$SEFLIK_ADI,
    "<br><strong>ENVANTER YILI:</strong> ", PLOT$ENVANTER_TARIHI,
    "<br><strong>AKTÜEL MEŞÇERE TİPİ:</strong> ", PLOT$AKTUEL_MES_TIP,
    "<br><strong>PLANDAKİ MEŞÇERE TİPİ:</strong> ", PLOT$PLANDAKI_MESCERE_TIPI,
    "<br><strong>EĞİM:</strong> ", PLOT$EGIM,
    "<br><strong>RAKIM:</strong> ", PLOT$RAKIM,
    "<br><strong>BAKI:</strong> ", PLOT$BAKI
  )

  # katman <- mutate(katman,popss = paste0("<strong>Name: </strong>",PLAN_ADI))

  # create a color paletter for category type in the data file
  pal_PLOT <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # create the leaflet map
  output$PLOT <- renderLeaflet({
    leaflet() %>%
      # add different provider tiles
      addProviderTiles(
        "Esri.WorldStreetMap",
        group = "İDARİ SINIRLAR"
      ) %>%
      addProviderTiles(
        "Esri.WorldImagery",
        group = "UYDU GÖRÜNTÜSÜ"
      ) %>%
      # add the Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # add the Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # add the Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # add a layers control
      addLayersControl(
        baseGroups = c(
          # "OpenStreetMap", "Stamen.Toner",
          # "Stamen.Terrain", "Wikimedia", "CartoDB.Positron",
          "İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"
        ),
        # position it on the topleft
        position = "topleft",

        # adding overlay as show/hide layers
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE),
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add the control widget
      # addCircles(
      #   data = PLOT, lng = ~NAD_X, lat = ~NAD_Y) %>%

      addCircleMarkers(
        data = PLOT, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 15, popup = pops_plot,
        color = ~ pal_PLOT(YIL),
        stroke = TRUE, fillOpacity = 1,
        popupOptions = popupOptions(maxWidth = 1000, closeOnClick = TRUE),
        labelOptions = labelOptions(interactive = T, noHide = T, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 1)
      ) %>%
      addTiles() %>%
      # #set zoom view
      # setView(mean(PLOT$NAD_X),mean(PLOT$NAD_Y),5) %>%

      addLegend(
        pal = pal_PLOT, values = PLOT$YIL, opacity = 1, position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      # add a minimap to our basemap
      addMiniMap(
        # all the tiles in our basemap, display the first one
        tiles = c(
          "Esri.WorldImagery"
        )[1], # change minimap types
        toggleDisplay = TRUE
      ) %>%
      addScaleBar(position = "bottomleft") %>%
      # add a measure control to the bottom left
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7",
      )
  }) # end of PLOT

  # selected Plot
  selectedPLOT <- reactive({
    filtered <- PLOT %>%
      filter(ORNEK_NO %in% input$ORNEK_NO)

    return(filtered)
  })

  observe({
    leafletProxy("PLOT", session) %>% # coming from leafletOutput in ui
      clearMarkers() %>%
      addMarkers(
        data = selectedPLOT(), lng = ~NAD_X, lat = ~NAD_Y,
        icon = makeIcon(
          iconUrl = "https://www.freeiconspng.com/uploads/tree-png-by-camelfobia-on-deviantart-24.png",
          iconWidth = 38, iconHeight = 95,
          iconAnchorX = 22, iconAnchorY = 80,
          shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
          shadowWidth = 50, shadowHeight = 64,
          shadowAnchorX = 4, shadowAnchorY = 62
        )
      ) %>%
      flyTo(lng = selectedPLOT()$NAD_X, lat = selectedPLOT()$NAD_Y, zoom = 15)
  })

  # --- alt kısımdaki tablo ---
  output$PLOT_table <- DT::renderDataTable({
    df <- PLOT %>%
      arrange(desc(ORNEK_NO == input$ORNEK_NO), ORNEK_NO)

    DT::datatable(
      df,
      rownames = FALSE,
      options = list(
        pageLength = 1,
        dom        = "tip",
        scrollX    = TRUE, # ✅ sağa kaydırma aktif
        autoWidth  = TRUE
      ),
      class = "compact nowrap stripe" # ✅ küçük yazı ve dar satırlar
    ) %>%
      DT::formatStyle(
        "ORNEK_NO",
        target = "row",
        backgroundColor = DT::styleEqual(
          levels = input$ORNEK_NO,
          values = "red"
        )
      )
  })

  ##### TREE ######
  # new column for the popup label for TREE (kept unchanged)
  pops_tree <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", TREE$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", TREE$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", TREE$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", TREE$SEFLIK_ADI,
    "<br><strong>ENVANTER YILI:</strong> ", TREE$ENVANTER_TARIHI,
    "<br><strong>AKTÜEL MEŞÇERE TİPİ:</strong> ", TREE$AKTUEL_MES_TIP,
    "<br><strong>BONİTET SINIFI:</strong> ", TREE$BONİTET_TAHMİN,
    "<br><strong>AĞAÇ TÜR ADI:</strong> ", TREE$AGAC_ADI,
    "<br><strong>AĞAÇ NO:</strong> ", TREE$AGAC_NO,
    "<br><strong>DENEME ALANI BÜYÜKLÜĞÜ (m²):</strong> ", TREE$DEN_AL_BUYUKLUGU,
    "<br><strong>GÖĞÜS ÇAPI (cm):</strong> ", TREE$Göğüs_Çapı,
    "<br><strong>BOYU (m):</strong> ", TREE$BOY_TAHMİN,
    "<br><strong>YAŞI:</strong> ", TREE$YAS_TAHMİN,
    "<br><strong>AĞACN HACMİ (m³):</strong> ", round(TREE$HACIM, 3),
    "<br><strong>AĞACIN ARTIMI (m³):</strong> ", round(TREE$ARTIM, 3)
  )

  # create a color palette for TREE by year (unchanged)
  pal_TREE_yil <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # Render the initial leaflet map for TREE_Konumsal.
  output$TREE_Konumsal <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldStreetMap", group = "İDARİ SINIRLAR") %>%
      addProviderTiles("Esri.WorldImagery", group = "UYDU GÖRÜNTÜSÜ") %>%
      # Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # Layers control
      addLayersControl(
        baseGroups = c("İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"),
        position = "topleft",
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add tree markers
      addCircleMarkers(
        data = TREE, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 10, popup = ~ as.character(pops_tree),
        color = ~ pal_TREE_yil(YIL),
        stroke = TRUE, fillOpacity = 1,
        labelOptions = labelOptions(noHide = TRUE, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 50)
      ) %>%
      addTiles() %>%
      addLegend(
        pal = pal_TREE_yil, values = TREE$YIL, opacity = 1,
        position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      addMiniMap(tiles = "Esri.WorldImagery", toggleDisplay = TRUE) %>%
      addScaleBar(position = "bottomleft") %>%
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7"
      ) %>%
      addEasyButton(easyButton(
        icon = "fa-crosshairs", title = "Locate Me",
        onClick = JS("function(btn, map){ map.locate({setView: true}); }")
      ))
  })

  # Create a reactive expression based on the input "ORNEK_NO"
  selectedTREE <- reactive({
    TREE %>% filter(ORNEK_NO %in% input$ORNEK_NO)
  })

  # Observer to fly to the selected tree coordinates
  observe({
    req(selectedTREE())
    # Here we use the first record of the filtered data; you can adjust if needed.
    leafletProxy("TREE_Konumsal", session) %>%
      flyTo(
        lng = selectedTREE()$NAD_X[1],
        lat = selectedTREE()$NAD_Y[1],
        zoom = 15
      )
  })
  # end of TREE Konumsal


  ##### OLU ######
  # new column for the popup label for OLU
  pops_olu <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", OLU$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", OLU$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", OLU$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", OLU$SEFLIK_ADI,
    "<br><strong>ENVANTER YILI:</strong> ", OLU$ENVANTER_TARIHI,
    "<br><strong>AĞAÇ TÜR ADI:</strong> ", OLU$AGAÇ_ADI,
    "<br><strong>ÖLÜ ODUN TÜRÜ:</strong> ", OLU$OLU_ODUN_TIPI,
    "<br><strong>ÇÜRÜME DERECESİ:</strong> ", OLU$CÜRÜME_DERECESİ,
    "<br><strong>ÇAPI (cm):</strong> ", OLU$AĞAÇ_ÇAPI,
    "<br><strong>BOYU (m):</strong> ", OLU$AĞAÇ_BOYU,
    "<br><strong>HACİM (m³/ha):</strong> ", round(OLU$HACIM, 2),
    "<br><strong>BİYOKÜTLE MİKTARI (ton):</strong> ", round(OLU$TUB, 1),
    "<br><strong>KARBON STOKU (ton):</strong> ", round(OLU$TUK, 1)
  )

  # katman <- mutate(katman,popss = paste0("<strong>Name: </strong>",PLAN_ADI))

  # create a color paletter for category type in the data file
  pal_OLU_yil <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # create the leaflet map
  output$OLU_Konumsal <- renderLeaflet({
    leaflet() %>%
      # add different provider tiles
      addProviderTiles(
        "Esri.WorldStreetMap",
        group = "İDARİ SINIRLAR"
      ) %>%
      addProviderTiles(
        "Esri.WorldImagery",
        group = "UYDU GÖRÜNTÜSÜ"
      ) %>%
      # add the Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # add the Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # add the Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # add a layers control
      addLayersControl(
        baseGroups = c(
          "İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"
        ),
        # position it on the topleft
        position = "topleft",

        # adding overlay as show/hide layers
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add the control widget
      # addCircles(
      #   data = OLU, lng = ~NAD_X, lat = ~NAD_Y) %>%

      addCircleMarkers(
        data = OLU, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 10, popup = ~ as.character(pops_olu),
        color = ~ pal_OLU_yil(YIL),
        stroke = TRUE, fillOpacity = 1,
        labelOptions = labelOptions(noHide = T, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 50)
      ) %>%
      addTiles() %>%
      addLegend(
        pal = pal_OLU_yil, values = OLU$YIL, opacity = 1, position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      # add a minimap to our basemap
      addMiniMap(
        # all the tiles in our basemap, display the first one
        tiles = c(
          "Esri.WorldImagery"
        )[1], # change minimap types
        toggleDisplay = TRUE
      ) %>%
      addScaleBar(position = "bottomleft") %>%
      # add a measure control to the bottom left
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7",
      )
  })
  # Create a reactive expression based on the input "ORNEK_NO"
  selectedOLU <- reactive({
    OLU %>% filter(ORNEK_NO %in% input$ORNEK_NO)
  })

  # Observer to fly to the selected tree coordinates
  observe({
    req(selectedOLU())
    # Here we use the first record of the filtered data; you can adjust if needed.
    leafletProxy("OLU_Konumsal", session) %>%
      flyTo(
        lng = selectedOLU()$NAD_X[1],
        lat = selectedOLU()$NAD_Y[1],
        zoom = 15
      )
  })
  # end of OLU

  ##### DIRI ######
  # new column for the popup label for DIRI
  pops_diri <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", DIRI$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", DIRI$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", DIRI$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", DIRI$SEFLIK_ADI,
    "<br><strong>ENVANTER YILI:</strong> ", DIRI$ENVANTER_TARIHI,
    "<br><strong>BAKI:</strong> ", DIRI$BAKI,
    "<br><strong>AKTÜEL MEŞÇERE TİPİ:</strong> ", DIRI$AKTUEL_MES_TIP,
    "<br><strong>DİRİ ÖRTÜ ADI:</strong> ", DIRI$BİTKİ_ÖRTÜSÜ_TÜR,
    "<br><strong>ORTALAMA BOYU (m):</strong> ", DIRI$ORTALAMA_BOY,
    "<br><strong>ÖRTME ORANI (%):</strong> ", DIRI$ÖRTME_ORANI
  )

  # katman <- mutate(katman,popss = paste0("<strong>Name: </strong>",PLAN_ADI))

  # create a color paletter for category type in the data file
  pal_DIRI_yil <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # create the leaflet map
  output$DIRI_Konumsal <- renderLeaflet({
    leaflet() %>%
      # add different provider tiles
      addProviderTiles(
        "Esri.WorldStreetMap",
        group = "Esri.WorldStreetMap"
      ) %>%
      addProviderTiles(
        "Esri.WorldImagery",
        group = "UYDU GÖRÜNTÜSÜ"
      ) %>%
      # add the Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # add the Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # add the Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # add a layers control
      addLayersControl(
        baseGroups = c(
          "İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"
        ),
        # position it on the topleft
        position = "topleft",

        # adding overlay as show/hide layers
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add the control widget
      # addCircles(
      #   data = DIRI, lng = ~NAD_X, lat = ~NAD_Y) %>%

      addCircleMarkers(
        data = DIRI, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 10, popup = ~ as.character(pops_diri),
        color = ~ pal_DIRI_yil(YIL),
        stroke = TRUE, fillOpacity = 1,
        labelOptions = labelOptions(noHide = T, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 50)
      ) %>%
      addTiles() %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addLegend(
        pal = pal_DIRI_yil, values = DIRI$YIL, opacity = 1, position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      # add a minimap to our basemap
      addMiniMap(
        # all the tiles in our basemap, display the first one
        tiles = c(
          "Esri.WorldImagery"
        )[1], # change minimap types
        toggleDisplay = TRUE
      ) %>%
      addScaleBar(position = "bottomleft") %>%
      # add a measure control to the bottom left
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7",
      )
  })
  # Create a reactive expression based on the input "ORNEK_NO"
  selectedDIRI <- reactive({
    DIRI %>% filter(ORNEK_NO %in% input$ORNEK_NO)
  })

  # Observer to fly to the selected tree coordinates
  observe({
    req(selectedDIRI())
    # Here we use the first record of the filtered data; you can adjust if needed.
    leafletProxy("DIRI_Konumsal", session) %>%
      flyTo(
        lng = selectedDIRI()$NAD_X[1],
        lat = selectedDIRI()$NAD_Y[1],
        zoom = 15
      )
  })
  # end of DIRI

  ##### KARBON ######
  # new column for the popup label for KARBON
  pops_KARBON <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", KARBON$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", KARBON$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", KARBON$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", KARBON$SEFLIK_ADI,
    "<br><strong>KAPALILIK:</strong> ", KARBON$KAPALILIK,
    "<br><strong>ORMAN TÜRÜ:</strong> ", KARBON$ORMAN_TUR,
    "<br><strong>TOPLAM CANLI BİYOKÜTLE KARBON MİKTARI (ton):</strong> ", KARBON$Toplam_Canli_Karbon,
    "<br><strong>TOPRAKTAKİ ORGANİK KARBON STOKU (ton):</strong> ", KARBON$Toprak_Karbon,
    "<br><strong>ÖLÜ ÖRTÜDEKİ KARBON STOKU (ton):</strong> ", KARBON$Olu_Ortu_Karbon,
    "<br><strong>ÖLÜ ODUN KARBON MİKTARI (ton):</strong> ", KARBON$Olu_Odun_Karbon,
    "<br><strong>OKSİJEN ÜRETİMİ (ton):</strong> ", KARBON$Oksijen_Uretimi
  )

  # katman <- mutate(katman,popss = paste0("<strong>Name: </strong>",PLAN_ADI))

  # create a color paletter for category type in the data file
  pal_KARBON_yil <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # create the leaflet map
  output$KARBON_Konumsal <- renderLeaflet({
    leaflet() %>%
      # add different provider tiles
      addProviderTiles(
        "Esri.WorldStreetMap",
        group = "İDARİ SINIRLAR"
      ) %>%
      addProviderTiles(
        "Esri.WorldImagery",
        group = "UYDU GÖRÜNTÜSÜ"
      ) %>%
      # add the Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # add the Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # add the Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # add a layers control
      addLayersControl(
        baseGroups = c(
          "İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"
        ),
        # position it on the topleft
        position = "topleft",

        # adding overlay as show/hide layers
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add the control widget
      # addCircles(
      #   data = KARBON, lng = ~NAD_X, lat = ~NAD_Y) %>%

      addCircleMarkers(
        data = KARBON, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 10, popup = ~ as.character(pops_KARBON),
        color = ~ pal_KARBON_yil(YIL),
        stroke = TRUE, fillOpacity = 1,
        labelOptions = labelOptions(noHide = T, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 50)
      ) %>%
      addTiles() %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addLegend(
        pal = pal_KARBON_yil, values = KARBON$YIL, opacity = 1, position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      # add a minimap to our basemap
      addMiniMap(
        # all the tiles in our basemap, display the first one
        tiles = c(
          "Esri.WorldImagery"
        )[1], # change minimap types
        toggleDisplay = TRUE
      ) %>%
      addScaleBar(position = "bottomleft") %>%
      # add a measure control to the bottom left
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7",
      )
  })
  # Create a reactive expression based on the input "ORNEK_NO"
  selectedKARBON <- reactive({
    KARBON %>% filter(ORNEK_NO %in% input$ORNEK_NO)
  })

  # Observer to fly to the selected tree coordinates
  observe({
    req(selectedKARBON())
    # Here we use the first record of the filtered data; you can adjust if needed.
    leafletProxy("KARBON_Konumsal", session) %>%
      flyTo(
        lng = selectedKARBON()$NAD_X[1],
        lat = selectedKARBON()$NAD_Y[1],
        zoom = 15
      )
  })
  # end of KARBON

  ##### TOPRAK ######
  pops_toprak <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", TOPRAK$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", TOPRAK$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", TOPRAK$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", TOPRAK$SEFLIK_ADI,
    "<br><strong>AKTÜEL MEŞÇERE TİPİ:</strong> ", TOPRAK$AKTUEL_MES_TIP,
    "<br><strong>TOPRAK HORİZONU:</strong> ", TOPRAK$Horizon,
    "<br><strong>DOĞAL GENÇLİK:</strong> ", TOPRAK$DOGAL_GENCLIK,
    "<br><strong>TOPRAK TÜRÜ:</strong> ", TOPRAK$TOPRAK_TURU,
    "<br><strong>ÖLÜ ÖRTÜ TİPİ:</strong> ", TOPRAK$OLU_ORTU_TIPI,
    "<br><strong>DIŞ TOPRAK DURUMU:</strong> ", TOPRAK$DIS_TOPRAK,
    "<br><strong>ENVANTER TARİHİ:</strong> ", TOPRAK$ENVANTER_TARIHI
  )

  # katman <- mutate(katman,popss = paste0("<strong>Name: </strong>",PLAN_ADI))

  # create a color paletter for category type in the data file
  pal_TOPRAK_yil <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # create the leaflet map
  output$TOPRAK_Konumsal <- renderLeaflet({
    leaflet() %>%
      # add different provider tiles
      addProviderTiles(
        "Esri.WorldStreetMap",
        group = "İDARİ SINIRLAR"
      ) %>%
      addProviderTiles(
        "Esri.WorldImagery",
        group = "UYDU GÖRÜNTÜSÜ"
      ) %>%
      # add the Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # add the Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # add the Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # add a layers control
      addLayersControl(
        baseGroups = c(
          "İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"
        ),
        # position it on the topleft
        position = "topleft",

        # adding overlay as show/hide layers
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add the control widget
      # addCircles(
      #   data = TOPRAK, lng = ~NAD_X, lat = ~NAD_Y) %>%

      addCircleMarkers(
        data = TOPRAK, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 10, popup = pops_toprak,
        color = ~ pal_TOPRAK_yil(YIL),
        stroke = TRUE, fillOpacity = 1,
        popupOptions = popupOptions(maxWidth = 1000, closeOnClick = TRUE),
        labelOptions = labelOptions(interactive = T, noHide = T, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 50)
      ) %>%
      addTiles() %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addLegend(
        pal = pal_TOPRAK_yil, values = TOPRAK$YIL, opacity = 1, position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      # add a minimap to our basemap
      addMiniMap(
        # all the tiles in our basemap, display the first one
        tiles = c(
          "Esri.WorldImagery"
        )[1], # change minimap types
        toggleDisplay = TRUE
      ) %>%
      addScaleBar(position = "bottomleft") %>%
      # add a measure control to the bottom left
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7",
      )
  })
  # Create a reactive expression based on the input "ORNEK_NO"
  selectedTOPRAK <- reactive({
    TOPRAK %>% filter(ORNEK_NO %in% input$ORNEK_NO)
  })

  # Observer to fly to the selected tree coordinates
  observe({
    req(selectedTOPRAK())
    # Here we use the first record of the filtered data; you can adjust if needed.
    leafletProxy("TOPRAK_Konumsal", session) %>%
      flyTo(
        lng = selectedTOPRAK()$NAD_X[1],
        lat = selectedTOPRAK()$NAD_Y[1],
        zoom = 15
      )
  })
  # end of TOPRAK

  ##### SU BILANCOSU ######
  # new column for the popup label for SU BILANCOSU
  pops_su <- paste0(
    "<strong>ÖRNEK NOKTA NO: </strong> ", SU$ORNEK_NO,
    "<br><strong>OBM ADI:</strong> ", SU$BOLGE_ADI,
    "<br><strong>OİM ADI:</strong> ", SU$MUDURLUK_ADI,
    "<br><strong>OİŞ ADI:</strong> ", SU$SEFLIK_ADI,
    "<br><strong>ENVANTER YILI:</strong> ", SU$ENVANTER_TARIHI,
    "<br><strong>AKTÜEL MEŞÇERE TİPİ:</strong> ", SU$AKTUEL_MES_TIP,
    "<br><strong>MEVCUT ARAZİ DURUMU:</strong> ", SU$MEVCUT_ARAZI,
    "<br><strong>ORT. YAĞIŞ (mm/yıl):</strong> ", SU$ORT_YAGIS,
    "<br><strong>ORT. SICAKLIK (mm/yıl):</strong> ", SU$ORT_SICAKLIK,
    "<br><strong>ORMAN KARIŞIM ŞEKLİ:</strong> ", SU$KARISIM_SEKLI,
    "<br><strong>TOPLAM KAYIP (mm/m²):</strong> ", SU$KAYIP,
    "<br><strong>TOPLAM VERİM (mm/m²):</strong> ", SU$VERIM
  )

  # katman <- mutate(katman,popss = paste0("<strong>Name: </strong>",PLAN_ADI))

  # create a color paletter for category type in the data file
  pal_SU_yil <- colorFactor(
    pal = c("yellow", "forestgreen", "red2", "blue", "mediumorchid1"),
    domain = c("2019", "2020", "2021", "2022", "2023")
  )

  # create the leaflet map
  output$SU_Konumsal <- renderLeaflet({
    leaflet() %>%
      # add different provider tiles
      addProviderTiles(
        "Esri.WorldStreetMap",
        group = "İDARİ SINIRLAR"
      ) %>%
      addProviderTiles(
        "Esri.WorldImagery",
        group = "UYDU GÖRÜNTÜSÜ"
      ) %>%
      # add the Istanbul OBM polygons
      addPolygons(
        data = ISTANBUL_OBM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OBM$ADI),
        fillColor = ~ factpal_obm(ADI)
      ) %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "yellow", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD),
        group = "OİM SINIRLARI"
      ) %>%
      # add the Istanbul OIS polygons
      addPolygons(
        data = seflik,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "red", popup = ~ as.character(seflik$SEFLIK_ADI),
        fillColor = ~ factpal_seflik(SEFLIK_ADI),
        group = "OİŞ SINIRLARI"
      ) %>%
      # add the Ecoregions
      addPolygons(
        data = ecoregions,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "blue", popup = ~ as.character(ecoregions$IKLIM_TIP),
        fillColor = ~ factpal_ecoregions(IKLIM_TIP),
        group = "İKLİM TİPLERİ"
      ) %>%
      # add a layers control
      addLayersControl(
        baseGroups = c(
          "İDARİ SINIRLAR", "UYDU GÖRÜNTÜSÜ"
        ),
        # position it on the topleft
        position = "topleft",

        # adding overlay as show/hide layers
        overlayGroups = c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      hideGroup("OİM SINIRLARI") %>%
      hideGroup("OİŞ SINIRLARI") %>%
      hideGroup("İKLİM TİPLERİ") %>%
      # Add the control widget
      # addCircles(
      #   data = SU, lng = ~NAD_X, lat = ~NAD_Y) %>%

      addCircleMarkers(
        data = SU, lng = ~NAD_X, lat = ~NAD_Y,
        radius = 10, popup = pops_su,
        color = ~ pal_SU_yil(YIL),
        stroke = TRUE, fillOpacity = 1,
        popupOptions = popupOptions(maxWidth = 1000, closeOnClick = TRUE),
        labelOptions = labelOptions(interactive = T, noHide = T, direction = "auto"),
        clusterOptions = markerOptions(maxClusterradius = 50)
      ) %>%
      addTiles() %>%
      # add the Istanbul OIM polygons
      addPolygons(
        data = ISTANBUL_OIM,
        stroke = TRUE, fillOpacity = 0.1, smoothFactor = 0.1,
        color = "black", popup = ~ as.character(ISTANBUL_OIM$ISLETME_MD),
        fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addLegend(
        pal = pal_SU_yil, values = SU$YIL, opacity = 1, position = "topright", title = "YILLAR", na.label = "Not Available"
      ) %>%
      # add a minimap to our basemap
      addMiniMap(
        # all the tiles in our basemap, display the first one
        tiles = c(
          "Esri.WorldImagery"
        )[1], # change minimap types
        toggleDisplay = TRUE
      ) %>%
      addScaleBar(position = "bottomleft") %>%
      # add a measure control to the bottom left
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#0bd3d3",
        completedColor = "#f890e7",
      )
  })
  # Create a reactive expression based on the input "ORNEK_NO"
  selectedSU <- reactive({
    SU %>% filter(ORNEK_NO %in% input$ORNEK_NO)
  })

  # Observer to fly to the selected tree coordinates
  observe({
    req(selectedSU())
    # Here we use the first record of the filtered data; you can adjust if needed.
    leafletProxy("SU_Konumsal", session) %>%
      flyTo(
        lng = selectedSU()$NAD_X[1],
        lat = selectedSU()$NAD_Y[1],
        zoom = 15
      )
  })
  # end of SU BILANCOSU

  ##### TABLES #####

  # Define a list with common DT options
  dtOptions <- list(
    autoWidth = TRUE,
    dom = "Bfrtip",
    searching = TRUE,
    extend = "collection",
    buttons = c("copy", "csv", "excel", "pdf", "print"),
    scrollY = TRUE,
    scrollX = TRUE,
    scroller = TRUE
  )

  # Fonksiyon: Sayısal veri tablolarını kullanıcı dostu biçimde sunar ve dışa aktarma seçenekleriyle destekler.
  renderDataAndDownload <- function(data, dtOutput, downloadOutput, prefix) {
    # Sayısal sütunlar 2 ondalık basamağa yuvarlanır; tablolar hem görsel netlik hem de akademik sunum için sadeleştirilir.
    formatted_data <- data %>%
      mutate(across(where(is.numeric), ~ round(., 2)))

    # Görselleştirme: responsive, dar satırlı ve kaydırılabilir yapı ile sunum
    output[[dtOutput]] <- DT::renderDataTable({
      datatable(
        formatted_data,
        filter = "top", # Her sütun için filtreleme aktif
        extensions = "Buttons", # Dışa aktarma butonları
        style = "bootstrap", # Bootstrap ile modern görünüm
        options = c(dtOptions, list(
          scrollX = TRUE, # Yatay kaydırma aktif
          autoWidth = TRUE,
          pageLength = 10,
          lengthMenu = c(5, 10, 20, 50)
        )),
        rownames = FALSE,
        class = "compact nowrap stripe" # Küçük yazı, satır daraltma ve şeritli görünüm
      )
    })

    # Dışa Aktarım: CSV formatında indirilebilir veri sunumu
    output[[downloadOutput]] <- downloadHandler(
      filename = function() {
        paste0(prefix, format(Sys.Date(), "%Y-%m-%d"), ".csv")
      },
      content = function(file) {
        write.csv(formatted_data, file, row.names = FALSE, fileEncoding = "UTF-8")
      }
    )
  }

  # Render DT tables and downloads for each dataset
  renderDataAndDownload(TREE, "TREE_Sayisal", "download1", "TREE_")
  renderDataAndDownload(OLU, "OLU_Sayisal", "download2", "OLU_")
  renderDataAndDownload(DIRI, "DIRI_Sayisal", "download3", "DIRI_")
  renderDataAndDownload(KARBON, "KARBON_Sayisal", "download4", "KARBON_")
  renderDataAndDownload(TOPRAK, "TOPRAK_Sayisal", "download5", "TOPRAK_")
  renderDataAndDownload(SU, "SU_Sayisal", "download6", "SU_BILANCOSU_")

  # Helper function to render a pivot table for a given dataset.
  renderPivotTable <- function(data, outputName) {
    output[[outputName]] <- renderRpivotTable({
      rpivotTable(data = data)
    })
  }

  # Render pivot tables for each dataset
  renderPivotTable(TREE, "TREE_Pivot")
  renderPivotTable(OLU, "OLU_Pivot")
  renderPivotTable(DIRI, "DIRI_Pivot")
  renderPivotTable(KARBON, "KARBON_Pivot")
  renderPivotTable(TOPRAK, "TOPRAK_Pivot")
  renderPivotTable(SU, "SU_Pivot")


  ### ISI HARITASI ###

  ### TREE ###
  # pre-define your palettes
  palette_fn <- function(vals) colorNumeric("RdYlBu", domain = vals, reverse = T)

  # Reactive filtered data
  filteredTree <- reactive({
    req(input$AGAC_ADI)
    TREE %>% filter(AGAC_ADI == input$AGAC_ADI)
  })

  # --- Heatmap: Ortalama Hacim ---
  output$heatmapHacim <- renderLeaflet({
    df <- filteredTree()
    leaflet(df) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~HACIM_HA, blur = 20, max = 0.1, radius = 10
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df$HACIM_HA), values = df$HACIM_HA,
        title = "Hekt. Ort. Hacim (m³/ha)"
      )
  })

  # --- Heatmap: Ortalama Artım ---
  output$heatmapArtim <- renderLeaflet({
    df <- filteredTree()
    leaflet(df) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ARTIM_HA, blur = 20, max = 0.1, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df$ARTIM_HA), values = df$ARTIM_HA,
        title = "Hekt. Ort. Artım (m³/ha)",
        bins = 5
      )
  })

  # --- Bar Chart: Ortalama Hacim by Çap Sınıfı ---
  output$barChartHacim <- renderPlotly({
    df <- filteredTree() %>%
      group_by(CAP_SINIFI) %>%
      summarize(avg = round(mean(HACIM_HA, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        CAP_SINIFI = factor(c("I", "II", "III", "IV", "V"), levels = c("I", "II", "III", "IV", "V")),
        fill = list(avg = 0)
      )

    plot_ly(df, x = ~CAP_SINIFI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$AGAC_ADI, "— Hekt. Ort. Hacim"),
        xaxis = list(title = "Çap Sınıfı"), yaxis = list(title = "m³/ha")
      )
  })

  # --- Bar Chart: Ortalama Artım by Çap Sınıfı ---
  output$barChartArtim <- renderPlotly({
    df <- filteredTree() %>%
      group_by(CAP_SINIFI) %>%
      summarize(avg = round(mean(ARTIM_HA, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        CAP_SINIFI = factor(c("I", "II", "III", "IV", "V"), levels = c("I", "II", "III", "IV", "V")),
        fill = list(avg = 0)
      )

    plot_ly(df, x = ~CAP_SINIFI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$AGAC_ADI, "— Hekt. Ort. Artım"),
        xaxis = list(title = "Çap Sınıfı"), yaxis = list(title = "m³/ha")
      )
  })

  ## DIRI ##
  # Reactive filtered data
  filteredDIRIIsi <- reactive({
    req(input$BİTKİ_ÖRTÜSÜ_TÜR)
    DIRI %>% filter(BİTKİ_ÖRTÜSÜ_TÜR == input$BİTKİ_ÖRTÜSÜ_TÜR)
  })

  # --- Heatmap: Ortalama Örtme ---
  output$DIRI_heatmap_ortme <- renderLeaflet({
    df_DIRI <- filteredDIRIIsi()
    leaflet(df_DIRI) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ÖRTME_ORANI, blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_DIRI$ÖRTME_ORANI), values = df_DIRI$ÖRTME_ORANI,
        title = "Hekt. Ort. Örtme Oranı (%/ha)"
      )
  })

  # --- Heatmap: Ortalama Boy ---
  output$DIRI_heatmap_boy <- renderLeaflet({
    df_DIRI <- filteredDIRIIsi()
    leaflet(df_DIRI) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ORTALAMA_BOY, blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_DIRI$ORTALAMA_BOY), values = df_DIRI$ORTALAMA_BOY,
        title = "Hekt. Ort. Ortalama Boy (m/ha)"
      )
  })

  # --- Bar Chart: Ortalama Örtme by OİM ---
  output$DIRI_bar_ortme <- renderPlotly({
    df_DIRI <- filteredDIRIIsi() %>%
      group_by(MUDURLUK_ADI) %>%
      summarize(avg = round(mean(ÖRTME_ORANI, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        MUDURLUK_ADI = factor(c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE"), levels = c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE")),
        fill = list(avg = 0)
      )

    plot_ly(df_DIRI, x = ~MUDURLUK_ADI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$BİTKİ_ÖRTÜSÜ_TÜR, "— Hekt. Ort. Örtme Oranı (%/ha)"),
        xaxis = list(title = "OİM"), yaxis = list(title = "%/ha")
      )
  })

  # --- Bar Chart: Ortalama Boy by OİM ---
  output$DIRI_bar_boy <- renderPlotly({
    df_DIRI <- filteredDIRIIsi() %>%
      group_by(MUDURLUK_ADI) %>%
      summarize(avg = round(mean(ORTALAMA_BOY, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        MUDURLUK_ADI = factor(c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE"), levels = c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE")),
        fill = list(avg = 0)
      )

    plot_ly(df_DIRI, x = ~MUDURLUK_ADI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$BİTKİ_ÖRTÜSÜ_TÜR, "— Hekt. Ort. Ortalama Boy (m/ha)"),
        xaxis = list(title = "OİM"), yaxis = list(title = "m/ha")
      )
  }) # end of DIRI ISI haritasi

  ## OLU ODUN ##
  ## # Reactive filtered data
  filteredOLUIsi <- reactive({
    req(input$AGAÇ_ADI)
    OLU %>% filter(AGAÇ_ADI == input$AGAÇ_ADI)
  })

  # --- Heatmap: Ortalama hacim ---
  output$OLU_heatmap_hacim <- renderLeaflet({
    df_OLU <- filteredOLUIsi()
    leaflet(df_OLU) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ mean(HACIM_HA), blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_OLU$HACIM_HA), values = df_OLU$HACIM_HA,
        title = "Hekt. Ort. Ölü Odun Hacmi (m³/ha)"
      )
  })

  # --- Heatmap: Ortalama karbon ---
  output$OLU_heatmap_tcbkm <- renderLeaflet({
    df_OLU <- filteredOLUIsi()
    leaflet(df_OLU) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ mean(TUK_HA), blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_OLU$TUK_HA), values = df_OLU$TUK_HA,
        title = "Hekt. Ort. Ölü Odun Karbonu (m³/ha)"
      )
  })

  # --- Bar Chart: Ortalama Hacim by OİM ---
  output$OLU_bar_hacim <- renderPlotly({
    df_OLU <- filteredOLUIsi() %>%
      group_by(OLU_ODUN_TIPI) %>%
      summarize(avg = round(mean(HACIM_HA, na.rm = TRUE), 1), .groups = "drop") %>%
      complete(
        OLU_ODUN_TIPI = factor(c("1-Dikili kuru", "2-Devrik", "3-Kırılmış Gövdeler", "4-Dip Kütük", "5-Dal veya Gövde"), levels = c("1-Dikili kuru", "2-Devrik", "3-Kırılmış Gövdeler", "4-Dip Kütük", "5-Dal veya Gövde")),
        fill = list(avg = 0)
      )

    plot_ly(df_OLU, x = ~OLU_ODUN_TIPI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$AGAÇ_ADI, "— Hekt. Ort. Ölü Odun Hacmi (m³/ha)"),
        xaxis = list(title = "ÖLÜ ODUN TİPİ"), yaxis = list(title = "m³/ha")
      )
  })

  # --- Bar Chart: Ortalama Karbon by OİM ---
  output$OLU_bar_tcbkm <- renderPlotly({
    df_OLU <- filteredOLUIsi() %>%
      group_by(OLU_ODUN_TIPI) %>%
      summarize(avg = round(mean(TUK_HA, na.rm = TRUE), 1), .groups = "drop") %>%
      complete(
        OLU_ODUN_TIPI = factor(c("1-Dikili kuru", "2-Devrik", "3-Kırılmış Gövdeler", "4-Dip Kütük", "5-Dal veya Gövde"), levels = c("1-Dikili kuru", "2-Devrik", "3-Kırılmış Gövdeler", "4-Dip Kütük", "5-Dal veya Gövde")),
        fill = list(avg = 0)
      )

    plot_ly(df_OLU, x = ~OLU_ODUN_TIPI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$AGAÇ_ADI, "— Hekt. Ort. Ölü Odun Karbon (m³/ha)"),
        xaxis = list(title = "ÖLÜ ODUN TİPİ"), yaxis = list(title = "m³/ha")
      )
  }) # end of OLU ODUN ISI haritasi

  ## KARBON ##
  # Reactive filtered data
  filteredKARBONIsi <- reactive({
    req(input$AGAC_ADI)
    KARBON %>% filter(AGAC_ADI == input$AGAC_ADI)
  })

  # --- Heatmap: Toplam_Canli_Karbon_HA ---
  output$KARBON_heatmap_karbon <- renderLeaflet({
    df_KARBON <- filteredKARBONIsi()
    leaflet(df_KARBON) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ mean(Toplam_Canli_Karbon_ha), blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_KARBON$Toplam_Canli_Karbon_ha), values = df_KARBON$Toplam_Canli_Karbon_ha,
        title = "Hekt. Ort. Canlı Karbon (ton/ha)"
      )
  })

  # --- Heatmap: Oksijen_Uretimi_ha ---
  output$KARBON_heatmap_oksijen <- renderLeaflet({
    df_KARBON <- filteredKARBONIsi()
    leaflet(df_KARBON) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ mean(Oksijen_Uretimi_ha), blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_KARBON$Oksijen_Uretimi_ha), values = df_KARBON$Oksijen_Uretimi_ha,
        title = "Hekt. Ort. Oksijen Üretimi (ton/ha)"
      )
  })

  # --- Bar Chart: Toplam_Canli_Karbon_HA by CAP_SINIFI ---
  output$KARBON_bar_karbon <- renderPlotly({
    df_KARBON <- filteredKARBONIsi() %>%
      group_by(CAP_SINIFI) %>%
      summarize(avg = round(mean(Toplam_Canli_Karbon_ha, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        CAP_SINIFI = factor(c("I", "II", "III", "IV", "V"), levels = c("I", "II", "III", "IV", "V")),
        fill = list(avg = 0)
      )

    plot_ly(df_KARBON, x = ~CAP_SINIFI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$AGAC_ADI, "— Hekt. Ort. Canlı Karbon"),
        xaxis = list(title = "Çap Sınıfı"), yaxis = list(title = "ton/ha")
      )
  })

  # --- Bar Chart: Oksijen_Uretimi_ha by OİM ---
  output$KARBON_bar_oksijen <- renderPlotly({
    df_KARBON <- filteredKARBONIsi() %>%
      group_by(CAP_SINIFI) %>%
      summarize(avg = round(mean(Oksijen_Uretimi_ha, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        CAP_SINIFI = factor(c("I", "II", "III", "IV", "V"), levels = c("I", "II", "III", "IV", "V")),
        fill = list(avg = 0)
      )

    plot_ly(df_KARBON, x = ~CAP_SINIFI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$AGAC_ADI, "— Hekt. Ort. Oksijen Üretimi"),
        xaxis = list(title = "Çap Sınıfı"), yaxis = list(title = "ton/ha")
      )
  }) # end of KARBON ISI haritasi

  ## TOPRAK ##
  # Reactive filtered data
  filteredTOPRAKIsi <- reactive({
    req(input$Horizon)
    TOPRAK %>% filter(Horizon == input$Horizon)
  })

  # --- Heatmap: Organik Madde ---
  output$TOPRAK_heatmap_organikmadde <- renderLeaflet({
    df_TOPRAK <- filteredTOPRAKIsi()
    leaflet(df_TOPRAK) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~organik_madde_stok_ton_ha, blur = 20, max = 0.05, radius = 10
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_TOPRAK$organik_madde_stok_ton_ha), values = df_TOPRAK$organik_madde_stok_ton_ha,
        title = "Hekt. Ort. Organik Madde (ton/ha)"
      )
  })

  # --- Heatmap:  Organik Karbon ---
  output$TOPRAK_heatmap_karbon <- renderLeaflet({
    df_TOPRAK <- filteredTOPRAKIsi()
    leaflet(df_TOPRAK) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~organik_karbon_stok_ton_ha, blur = 20, max = 0.05, radius = 10
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_TOPRAK$organik_karbon_stok_ton_ha), values = df_TOPRAK$organik_karbon_stok_ton_ha,
        title = "Hekt. Ort. Organik Karbon (ton/ha)"
      )
  })

  # --- Bar Chart: organik madde by CAP_SINIFI ---
  output$TOPRAK_bar_organikmadde <- renderPlotly({
    df_TOPRAK <- filteredTOPRAKIsi() %>%
      group_by(MUDURLUK_ADI) %>%
      summarize(avg = round(mean(organik_madde_stok_ton_ha, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        MUDURLUK_ADI = factor(c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE"), levels = c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE")),
        fill = list(avg = 0)
      )

    plot_ly(df_TOPRAK, x = ~MUDURLUK_ADI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$Horizon, "— Hekt. Ort. Organik Madde (ton/ha)"),
        xaxis = list(title = "Horizonlar"), yaxis = list(title = "ton/ha")
      )
  })

  # --- Bar Chart: organik karbon by OİM ---
  output$TOPRAK_bar_karbon <- renderPlotly({
    df_TOPRAK <- filteredTOPRAKIsi() %>%
      group_by(MUDURLUK_ADI) %>%
      summarize(avg = round(mean(organik_karbon_stok_ton_ha, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        MUDURLUK_ADI = factor(c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE"), levels = c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE")),
        fill = list(avg = 0)
      )

    plot_ly(df_TOPRAK, x = ~MUDURLUK_ADI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$Horizon, "— Hekt. Ort. Organik Karbon (ton/ha)"),
        xaxis = list(title = "Horizonlar"), yaxis = list(title = "ton/ha")
      )
  }) # end of TOPRAK ISI haritasi

  ## SU BILANCOSU ##
  # Reactive filtered data
  filteredSUIsi <- reactive({
    req(input$YIL)
    SU %>% filter(YIL == input$YIL)
  })

  # --- Heatmap: Organik Madde ---
  output$SU_heatmap_verim <- renderLeaflet({
    df_SU <- filteredSUIsi()
    leaflet(df_SU) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ mean(VERIM), blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_SU$VERIM), values = df_SU$VERIM,
        title = "Ort. Yıllık Su Verimi (mm/yıl)"
      )
  })

  # --- Heatmap:  Organik Karbon ---
  output$SU_heatmap_kayip <- renderLeaflet({
    df_SU <- filteredSUIsi()
    leaflet(df_SU) %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      # Bölge Müd. sınırları
      addPolygons(
        data = ISTANBUL_OBM,
        group = "OBM SINIRI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "black", popup = ~ADI, fillColor = ~ factpal_obm(ADI)
      ) %>%
      # Diğer katmanlar
      addPolygons(
        data = ISTANBUL_OIM,
        group = "OİM SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "yellow", popup = ~ISLETME_MD, fillColor = ~ factpal(ISLETME_MD)
      ) %>%
      addPolygons(
        data = seflik,
        group = "OİŞ SINIRLARI",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "red", popup = ~SEFLIK_ADI, fillColor = ~ factpal_seflik(SEFLIK_ADI)
      ) %>%
      addPolygons(
        data = ecoregions,
        group = "İKLİM TİPLERİ",
        stroke = TRUE, fillOpacity = .1, smoothFactor = .1,
        color = "blue", popup = ~IKLIM_TIP, fillColor = ~ factpal_ecoregions(IKLIM_TIP)
      ) %>%
      addHeatmap(
        lng = ~NAD_X, lat = ~NAD_Y,
        intensity = ~ mean(KAYIP), blur = 20, max = 0.05, radius = 20
      ) %>%
      # Kontroller ve legend
      addLayersControl(
        position = "topleft",
        overlayGroups = c("OBM SINIRI", "OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ", "Isı Haritasi"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      showGroup("OBM SINIRI") %>%
      hideGroup(c("OİM SINIRLARI", "OİŞ SINIRLARI", "İKLİM TİPLERİ")) %>%
      addLegend(
        "bottomleft",
        pal = palette_fn(df_SU$KAYIP), values = df_SU$KAYIP,
        title = "Ort. Yıllık Su Kaybı (mm/yıl)"
      )
  })

  # --- Bar Chart: SU VERİMİ by OİM ---
  output$SU_bar_verim <- renderPlotly({
    df_SU <- filteredSUIsi() %>%
      group_by(MUDURLUK_ADI) %>%
      summarize(avg = round(mean(VERIM, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        MUDURLUK_ADI = factor(c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE"), levels = c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE")),
        fill = list(avg = 0)
      )

    plot_ly(df_SU, x = ~MUDURLUK_ADI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$MUDURLUK_ADI, "— Ort. Yıllık Su Verimi (mm/yıl)"),
        xaxis = list(title = "OİM"), yaxis = list(title = "mm/yıl")
      )
  })

  # --- Bar Chart: SU VERİMİ by OİM ---
  output$SU_bar_kayip <- renderPlotly({
    df_SU <- filteredSUIsi() %>%
      group_by(MUDURLUK_ADI) %>%
      summarize(avg = round(mean(KAYIP, na.rm = TRUE), 0), .groups = "drop") %>%
      complete(
        MUDURLUK_ADI = factor(c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE"), levels = c("ŞİLE", "KANLICA", "BAHÇEKÖY", "İSTANBUL", "ÇATALCA", "TEKİRDAĞ", "VİZE", "DEMİRKÖY", "KIRKLARELİ", "EDİRNE")),
        fill = list(avg = 0)
      )

    plot_ly(df_SU, x = ~MUDURLUK_ADI, y = ~avg, type = "bar") %>%
      layout(
        title = paste(input$MUDURLUK_ADI, "— Ort. Yıllık Su Kaybı (mm/yıl)"),
        xaxis = list(title = "OİM"), yaxis = list(title = "mm/yıl")
      )
  }) # end of SU BILANCOSU haritasi


  ### TREE_Agaclarin_Dagilimi ###
  # -- 1) reactive subset for selected plot
  reactive_tree_data <- reactive({
    req(input$TREE_DAG_ORNEK_NO)
    TREE %>%
      filter(ORNEK_NO == input$TREE_DAG_ORNEK_NO) %>%
      arrange(AGAC_NO) # <<< sıralama burada
  })

  # -- 2) your existing polar plot (just uses reactive_tree_data())
  output$TREE_Agaclarin_Dagilimi <- renderPlotly({
    df <- reactive_tree_data()
    plot_ly(
      df,
      type = "scatterpolar",
      r = ~MERKEZE_UZAKLIK,
      theta = ~SEMT_ACISI,
      color = ~AGAC_ADI,
      colors = c("red", "blue", "green", "yellow", "purple"),
      text = ~ paste0(
        "<b>DETAYLAR</b><br>",
        "Ağaç Türü: ", AGAC_ADI, "<br>",
        "Ağaç No: ", AGAC_NO, "<br>",
        "Çap (cm): ", `Göğüs_Çapı`, "<br>",
        "Boy (m): ", BOY_TAHMİN, "<br>",
        "Yaş: ", YAS_TAHMİN
      ),
      mode = "markers",
      hoverinfo = "text",
      marker = list(symbol = "circle", line = list(width = 0.1, color = "black")),
      source = "treeDag"
    ) %>%
      layout(
        showlegend = TRUE,
        polar = list(
          radialaxis = list(
            tickfont  = list(size = 20, color = "red"),
            range     = c(0, 15),
            tickvals  = c(0, 5, 10, 15),
            ticktext  = c("0", "5", "10", "15"),
            angle     = 90
          ),
          angularaxis = list(
            tickmode = "array",
            tickvals = c(0, 45, 90, 135, 180, 225, 270, 315),
            ticktext = c(
              "KUZEY", "KUZEYDOĞU", "DOĞU", "GÜNEYDOĞU",
              "GÜNEY", "GÜNEYBATI", "BATI", "KUZEYBATI"
            ),
            rotation = 90,
            direction = "clockwise"
          )
        )
      )
  })

  # -- 3) render only the tree list
  output$tree_list <- renderTable(
    {
      reactive_tree_data() %>%
        transmute(
          `Ağaç Türü` = AGAC_ADI,
          `Ağaç No`   = sprintf("%.0f", AGAC_NO),
          `Çap (cm)`  = sprintf("%.0f", `Göğüs_Çapı`),
          `Boy (m)`   = sprintf("%.0f", BOY_TAHMİN),
          `Yaş`       = sprintf("%.0f", YAS_TAHMİN)
        )
    },
    rownames = FALSE,
    sanitize.text.function = function(x) x
  )
}) # ending shinyServer

# Run the application
shinyApp(ui = ui, server = server)

# odbcClose(conn)
# rm(conn)
