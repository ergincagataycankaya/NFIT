### GÜNCELLEMELER
<br>

<p style="font-size:14px; text-align:justify;">
<strong>1 Şubat 2020</strong>&nbsp;&nbsp;
<b>version:</b> 1.0
<ul style="padding-left:5em; list-style-type: square;">
  <li>UOE kullanıcı arayüzünün ilk sürümü yayımlandı; temel harita ve veri görselleştirme modülleri entegre edildi.</li>
</ul>
</p>

<p style="font-size:14px; text-align:justify;">
<strong>26 Şubat 2020</strong>&nbsp;&nbsp;
<b>version:</b> 1.1
<ul style="padding-left:5em; list-style-type: square;">
  <li>Kullanıcı geri bildirimleri doğrultusunda etkileşim ve performans iyileştirmeleri gerçekleştirildi (önbellekleme stratejileri, Shiny modül revizyonları).</li>
</ul>
</p>

<p style="font-size:14px; text-align:justify;">
<strong>31 Mart 2021</strong>&nbsp;&nbsp;
<b>version:</b> 2.0
<ul style="padding-left:5em; list-style-type: square;">
  <li>UOE eğitimi sonrası istatistiksel raporlama modülleri eklendi ve kullanım kılavuzu güncellendi.</li>
</ul>
</p>

<p style="font-size:14px; text-align:justify;">
<strong>15 Mayıs 2022</strong>&nbsp;&nbsp;
<b>version:</b> 2.5
<ul style="padding-left:5em; list-style-type: square;">
  <li>Veritabanı şeması revize edilerek SQL indekslemeleri ve optimize edilmiş VIEW tanımlamaları eklendi; veri sorgu süreleri %30 oranında kısaltıldı.</li>
</ul>
</p>

<p style="font-size:14px; text-align:justify;">
<strong>20 Haziran 2023</strong>&nbsp;&nbsp;
<b>version:</b> 2.8
<ul style="padding-left:5em; list-style-type: square;">
  <li>UI/UX tasarımına rehber modülü (in-app tour) ve responsive iyileştirmeleri eklendi; mobil uyumluluk artırıldı.</li>
  <li>Konumsal harita katmanlarına lazy-loading getirildi; WMS/WFS katman istekleri optimize edilerek başlangıç yükleme süreleri azaltıldı.</li>
</ul>
</p>

<p style="font-size:14px; text-align:justify;">
<strong>10 Kasım 2024</strong>&nbsp;&nbsp;
<b>version:</b> 3.0
<ul style="padding-left:5em; list-style-type: square;">
  <li>OWASP ZAP ile kapsamlı güvenlik taraması yapıldı; XSS/CSRF zaafiyetleri giderildi, JWT tabanlı kimlik doğrulama modülü eklendi.</li>
  <li>Docker ve Docker Compose ile kapsayıcı dağıtım yapılandırması oluşturuldu; GitHub Actions üzerinde CI/CD pipeline entegrasyonu tamamlandı.</li>
</ul>
</p>

<p style="font-size:14px; text-align:justify;">
<strong>12 Ocak 2025</strong>&nbsp;&nbsp;
<b>version:</b> 3.1
<ul style="padding-left:5em; list-style-type: square;">
  <li>Modüler mimariye geçiş: `modules/` ve `helpers/` klasör yapılarıyla kod tekrarı azaltıldı (Wickham, 2015).</li>
  <li>Veri yükleme ve performans artışı: `data.table` kullanımıyla büyük veri işlemleri hızlandırıldı (Dowle & Srinivasan, 2019).</li>
  <li>Güvenlik ve şifreleme: Veritabanı bağlantıları SSL/TLS destekli DBI/odbc yapısına geçirildi.</li>
  <li>UI tasarımı: `shinydashboardPlus` ile erişilebilirlik ve stil geliştirmeleri uygulandı (WCAG 2.1 uyumlu).</li>
  <li>Bağımlılık yönetimi: `pacman` ve `renv` ile paket kilitleme, gereksiz paketler ayıklandı (Ushey et al., 2021).</li>
  <li>Paralel işlem yönetimi: `future`/`furrr` kullanılarak modern iş parçacığı altyapısı kuruldu.</li>
  <li>Dökümantasyon: `roxygen2` ile fonksiyon belgeleri ve `devtools::check()` ile paket bütünlüğü sağlandı.</li>
</ul>
</p>