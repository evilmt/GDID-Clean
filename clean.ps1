# =====================================================================
# Windows Privacy Toolkit Unified Edition
# Compatible: Windows PowerShell 5.1 + PowerShell 7
# =====================================================================
param (
    [string]$FirstArg
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

$versionall = "V1.0.8"

# =====================================================================
#  Windows 终极隐私防御与服务深度封印脚本 (融合增强版)
#  提示：必须以管理员身份运行此脚本！支持 Windows 10 / 11
# =====================================================================

# 1. 自动请求管理员权限
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[*] 正在请求管理员权限..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}


function New-RegistryPath ($Path) {
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
}




Write-Host "====================================================" -ForegroundColor Cyan

# 安全备份与日志
$PrivacyBackup = "$((Get-Location).Path)/PrivacyCleanBackup"
if (!(Test-Path $PrivacyBackup)) {
    New-Item -ItemType Directory -Path $PrivacyBackup | Out-Null
}

$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
if (Test-Path $hostsPath) {
    Copy-Item $hostsPath "$PrivacyBackup\hosts.backup" -Force
}

Start-Transcript -Path "$PrivacyBackup\PrivacyClean.log" -Append


Write-Host "    Windows 终极隐私防御系统 (GDID & 核心服务斩断计划) $versionall " -ForegroundColor Cyan
Write-Host "Author: @evilmt" -ForegroundColor Cyan
Write-Host "Github: https://github.com/evilmt/GDID-clean" -ForegroundColor Cyan
Write-Host "斩断的不是过去，而是曾经的自己" -ForegroundColor Cyan
Write-Host "你为何而执剑" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

function New-hosts ($Path) {
# 2. 修改 Hosts 文件（域名拦截 - 融合并扩展）
Write-Host "`n[1/6] 开始注入 Hosts 域名屏蔽规则..." -ForegroundColor Yellow
$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$targetDomains = @(
    # 核心遥测与数据收集
    "v10.events.data.microsoft.com", "v20.events.data.microsoft.com",
    "v10.vortex-win.data.microsoft.com", "settings-win.data.microsoft.com",
    "settings-sandbox.data.microsoft.com", "watson.telemetry.microsoft.com",
    "watson.ppe.telemetry.microsoft.com", "telecommand.telemetry.microsoft.com",
    "sqm.telemetry.microsoft.com", "oca.telemetry.microsoft.com",
    "survey.watson.microsoft.com", "diagnostics.support.microsoft.com",
    "geo.prod.do.dsp.mp.microsoft.com","vortex.data.microsoft.com",
    "telemetry.microsoft.com","v10c.events.data.microsoft.com","telemetry.dotnet.microsoft.com",
    "v20c.events.data.microsoft.com","v10c.vortex-win.data.microsoft.com",
    "v20c.vortex-win.data.microsoft.com","v10c.vortex-win-sandbox.data.microsoft.com",
    "v20c.vortex-win-sandbox.data.microsoft.com","v10c.vortex-win-ppe.data.microsoft.com",
    "v20c.vortex-win-ppe.data.microsoft.com","v10c.vortex-win-sandbox-ppe.data.microsoft.com",
    "umwatsonc.events.data.microsoft.com","umwatsonc.vortex-win.data.microsoft.com",
    "-umwatsonc.events.data.microsoft.com","ceuswatcab01.blob.core.windows.net",
    "ceuswatcab02.blob.core.windows.net","eaus2watcab02.blob.core.windows.net",
    "eaus2watcab01.blob.core.windows.net","ceuswatcab05.blob.core.windows.net",
    "weus2watcab01.blob.core.windows.net","weus2watcab02.blob.core.windows.net",
    "oca.microsoft.com","kmwatsonc.events.data.microsoft.com",
    "us-v10c.events.data.microsoft.com","eu-v10c.events.data.microsoft.com",
    "us-v20c.events.data.microsoft.com","eu-v20c.events.data.microsoft.com",
    "watsonc.events.data.microsoft.com","eu-watsonc.events.data.microsoft.com",
    "blob.core.windows.net","mystorageaccount.blob.core.windows.net",
    "watson.events.data.microsoft.com","mobile.events.data.microsoft.com",
    "functional.events.data.microsoft.com","events.data.microsoft.com",
    "browser.events.data.microsoft.com","telemetry.microsoft.com","pipes.startpage.fragment.skybeam.microsoft.com",
    "self.events.data.microsoft.com","browser.events.data.msn.com",
    "www.telecommandsvc.microsoft.com","telecommandsvc.microsoft.com",
    "insideruser.microsoft.com","wcpstatic.microsoft.com",
    "settings.data.microsoft.com",
    "config.edge.skype.com","cy2.vortex.data.microsoft.com.akadns.net",
    "modern.watson.data.microsoft.com.akadns.net",
    "lgmsapeweu.blob.core.windows.net","lgmsapewus2.blob.core.windows.net",
    "lgmsapesea.blob.core.windows.net","lgmsapeaus.blob.core.windows.net",
    "lgmsapeind.blob.core.windows.net","lgmsapeswiss.blob.core.windows.net",
    "cds26.ams9.msecn.net","compatexchange.cloudapp.net",
    "cp501.prod.do.dsp.mp.microsoft.com","cxcs.microsoft.net",
    "deff.nelreports.net","family.api.account.microsoft.com",
    "farevents.family.microsoft.com","kv501.prod.do.dsp.mp.microsoft.com",
    "fd.api.iris.microsoft.com","iris.microsoft.com",
    "i1.services.social.microsoft.com.nsatc.net","inference.location.live.com",
    "instrumentExport.cp.microsoft.com","manage.microsoft.com",
    "mathsolver.microsoft.com","microsoftnews.msn.com",
    "msft.sts.microsoft.com","mwservice.xpay-int.microsoft.com",
    "oca.telemetry.microsoft.com.nsatc.net","telecommand.telemetry.microsoft.com.nsatc.net",
    "tip.customervoice.microsoft.com","tokenization.cp.microsoft.com",
    "vortex-bn2.metron.live.com.nsatc.net","vortex-cy2.metron.live.com.nsatc.net",
    "vortex-win.data.metron.live.com.nsatc.net","watson.telemetry.microsoft.com.nsatc.net",
    "web.vortex-sandbox.data.msn.com","web.vortex.data.msn.com",
    "webxtsvc.microsoft.com","xpay-int.microsoft.com",
    "dc.services.visualstudio.com","ic.snapi.fido.net","dc.applicationinsights.azure.com",
    "nexusrules.officeapps.live.com","umwatsonc.telemetry.microsoft.com",
    "watson.microsoft.com","experimentation.microsoft.com","telemetry.powershell.org",
    "umwatson.events.data.microsoft.com","browser.pipe.aria.microsoft.com",
    "mobile.pipe.aria.microsoft.com","eu-mobile.events.data.microsoft.com",
    "eu-v10.events.data.microsoft.com","presence-heartbeat.xboxlive.com",
    "ads.aerserv.com","ads.api.vungle.com","api.taboola.com",
    "config.inmobi.com","impression.appsflyer.com","tpat.api.vungle.com",
    "blobcollectorcommon.trafficmanager.net","aefd.nelreports.net","azureedge-t-prod.trafficmanager.net",
    "edge-mobile-static.afd.azureedge.net","edge-mobile-static.azureedge.net",
    "edgeassetservice.azureedge.net","prod-agic-we-2.westeurope.cloudapp.azure.com",
    "tm-prod-wd-csp-edge.trafficmanager.net","xpaywalletcdn.azureedge.net",
    "nw-umwatson.events.data.microsoft.com","vortex-win.data.microsoft.com",
    "sqm.telemetry.microsoft.com.nsatc.net","redir.metaservices.microsoft.com",
    "telemetry.appex.bing.net","telemetry.urs.microsoft.com",
    "vortex-sandbox.data.microsoft.com","watson.live.com",
    "statsfe2.ws.microsoft.com","corpext.msitadfs.glbdns2.microsoft.com",
    "cs1.wpc.v0cdn.net","a-0001.a-msedge.net",
    "a-0002.a-msedge.net","a-0003.a-msedge.net","a-0004.a-msedge.net",
    "a-0005.a-msedge.net","a-0006.a-msedge.net","a-0007.a-msedge.net",
    "a-0008.a-msedge.net","a-0009.a-msedge.net","a-00010.a-msedge.net",
    "fe2.update.microsoft.com.akadns.net","statsfe2.update.microsoft.com.akadns.net",
    "sls.update.microsoft.com.akadns.net","corp.sts.microsoft.com",
    "statsfe1.ws.microsoft.com","pre.footprintpredict.com","analytics.apache.org",
    "feedback.windows.com","feedback.microsoft-hohm.com","telemetry.go.dev",
    "feedback.search.microsoft.com","db5.vortex.data.microsoft.com.akadns.net","analytics.python.org",
    "geo.vortex.data.microsoft.com.akadns.net","v10-win.vortex.data.microsoft.com.akadns.net",
    "xpaywalletcdn-prod.azureedge.net",



    # Google
    "googleads.g.doubleclick.net","stats.g.doubleclick.net",
    "adservice.google.com","pagead2.googlesyndication.com",
    "securepubads.g.doubleclick.net","google-analytics.com",
    "www.google-analytics.com","ssl.google-analytics.com",
    "analytics.google.com","sb-ssl.google.com","play.google.com",
    "safebrowsing.googleapis.com",
    "googleadservices.com","play.googleapis.com","mtalk.google.com",
    "clients.googleapis.com","firebaseinstallations.googleapis.com",
    "ad.doubleclick.net","googletagmanager.com","telemetry-googleapis.com",
    "app-measurement.com","firebaselogging.googleapis.com","metrics.google.com",
    "firebase-settings.crashlytics.com","reports.crashlytics.com","gateway.dialertoserver.com",
    "tpc.googlesyndication.com","www.googletagmanager.com","*.googletagmanager.com",



    # chrome
    "clientservices.googleapis.com","optimizationguide-pa.googleapis.com",
    "content-autofill.googleapis.com","ssl.gstatic.com",
    "connectivitycheck.gstatic.com",

    #firefox
    "telemetry.mozilla.org","telemetry-inbound.mozilla.org",
    "incoming.telemetry.mozilla.org","detectportal.firefox.com",
    "crash-stats.mozilla.org","crash-reports.mozilla.com",
    "firefox.settings.services.mozilla.com","settings-win.data.mozilla.com",
    "api.getpocket.com","contile.services.mozilla.com",
    "normandy.cdn.mozilla.net","classify-client.services.mozilla.com",
    "sync.services.mozilla.com","getpocket.com","img-getpocket.cdn.mozilla.net",
    "shavar.services.mozilla.com","push.services.mozilla.com",
    "firefoxchina.cn","*.firefoxchina.cn",

    #Apple
    "diagassets.apple.com","iadsdk.apple.com","metrics.apple.com",
    "notes-analytics-events.apple.com","xp.apple.com",


    #GPS 地图
    "inference.location.live.net","maps.windows.com","ecn.dev.virtualearth.net",
    "ecn-us.dev.virtualearth.net","weathermapdata.blob.core.windows.net",
    "dev.virtualearth.net","ssl.bing.com",
    "*.ssl.ak.dynamic.tiles.virtualearth.net","*.ssl.ak.tiles.virtualearth.net",
    "store-images.s-microsoft.com",

    #Defender
    "wdcp.microsoft.com","*smartscreen-prod.microsoft.com","checkappexec.microsoft.com",
    "ping-edge.smartscreen.microsoft.com","data-edge.smartscreen.microsoft.com","nav-edge.smartscreen.microsoft.com",
    "wdcpalt.microsoft.com","*.smartscreen.microsoft.com",
    "*.smartscreen-prod.microsoft.com","clientfd.family.microsoft.com","smartscreen.microsoft.com",
    "nav.smartscreen.microsoft.com",

    # 广告与个性化追踪
    "choice.microsoft.com", "choice.microsoft.com.nstac.net",
    "df.telemetry.microsoft.com", "reports.wes.df.telemetry.microsoft.com",
    "activity.windows.com","assets.activity.windows.com","wes.df.telemetry.microsoft.com",
    "services.wes.df.telemetry.microsoft.com","sqm.df.telemetry.microsoft.com",
    "a.ads1.msn.com","a.ads2.msads.net","a.ads2.msn.com","activity.microsoft.com",
    "ppe.activity.windows.com","client.wns.windows.com","global.notify.windows.com",
    "sinnc-df.notify.windows.com","bn2-df.notify.windows.com","bn3p.notify.windows.com",
    "db3p.notify.windows.com",

    # 警告：保留了 login.live.com 等登录域名，避免导致微软账户完全无法登录。
    # 如需彻底单机、不使用任何微软账户服务，可手动取消下方两行的注释：
    "login.live.com", "clientconfig.passport.net","account.live.com","login.msa.akadns6.net","auth.gfx.ms",
    "account.microsoft.com",


    #网络连接状态指示器 (NCSI)
    "www.msftconnecttest.com","www.msftncsi.com","ipv6.msftconnecttest.com","dns.msftncsi.com","msftconnecttest.com"
    #时间
    "time.windows.com",

    #edge

    "windows.msn.cn",
    "api.msn.com","pipe.aria.microsoft.com",
    "ntp.msn.com","web.vortex.data.microsoft.com",
    "msn.com","www.msn.com","edge.nelreports.net",
    "assets.msn.com","c.msn.com","windows.msn.com",
    "iecvlist.microsoft.com",
    "edge.activity.windows.com",
    "ax-0001.ax-msedge.net",
    "ax-0003.ax-msedge.net","ax-0004.ax-msedge.net",
    "edge-microsoft-com.ax-0001.ax-msedge.net","edge-microsoft-com.ax-0002.ax-msedge.net",
    "edge-microsoft-com.ax-0003.ax-msedge.net","api.vcservice.webxtsvc-int.microsoft.com",
    "api.webxtsvc.microsoft.com","vcservice.webxtsvc.microsoft.com",
    "edge.config.oslo.ext.azure.com","msedgeextensions.sf.privatelink.msidentity.com",
    "ads.msn.com","ads1.msads.net","ads2.msads.net","adnxs.com",
    "shopping.microsoft.com","edge.shopping.microsoft.com","vortex.data.microsoft.com",
    "default.exp-tas.com","edgeservices.bing.com","spellcheck.microsoft.com",
    "xsts.auth.xboxlive.com",



    #以下是中国特供版
    "api.msn.cn","pipe.aria.microsoft.cn",
    "ntp.msn.cn","web.vortex.data.microsoft.cn",
    "browser.events.data.msn.cn","www.msn.cn",
    "assets.msn.cn","c.msn.cn","srtb.msn.cn",


    #Edge 更新
    "msedge.api.cdp.microsoft.com",

    #bing
    "bingapis.com","bat.bing.com",,"bat.bing.cn","business.bing.com",
    "business.bing.cn","ams9.msecn.net","global.bing.com","global.bing.cn",
    "m.bing.com","bgs.data.microsoft.com","th.bing.com","tse1.mm.bing.net",
    "cn.api.bing.com","c.bing.cn","r.bing.cn","ssl.bing.cn",
    "m.bing.cn","th.bing.cn","rms.bing.com","rms.bing.cn",
    "hubsedge.bing.com","hubsedge.bing.cn","staticsmarket.msn.com",
    "rewards.bing.com","rewards.bing.cn","bat.bing.net","bingads.microsoft.com",
    "copilot.microsoft.com","sydney.bing.com","a.bing.com","a.bing.cn",


    #下载Microsoft产品
    "software-download.microsoft.com",

    #Microsoft Store
    "img-prod-cms-rt-microsoft-com.akamaized.net","img-s-msn-com.akamaized.net",
    "livetileedge.dsx.mp.microsoft.com","storeedgefd.dsx.mp.microsoft.com",
    "storecatalogrevocation.storequality.microsoft.com",
    "1storecatalogrevocation.storequality.microsoft.com",
    "paymentinstruments.mp.microsoft.com","prod.rewardsplatform.microsoft.com",
    "rewards.microsoft.com","edge-enterprise.activity.windows.com",


    #用于获取 Microsoft Store 分析
    "manage.devcenter.microsoft.com","tile-service.weather.microsoft.com",
    "evoke-windowsservices-tas.msedge.net","cdn.onenote.net",
    "spclient.wg.spotify.com"
    "blob.weather.microsoft.com","wildcard.twimg.com",
    "candycrushsoda.king.com","wallet.microsoft.com","mediaredirect.microsoft.com",
    "store-images.s-microsoft.com","int.whiteboard.microsoft.com","whiteboard.microsoft.com",

    #Cortana 和动态磁贴
    "fp.msedge.net","k-ring.msedge.net","b-ring.msedge.net","business.bing.com",
    "c.bing.com","edgeassetservice.azureedge.net","fp-vs.azureedge.net",
    "ln-ring.msedge.net","prod-azurecdn-akamai-iris.azureedge.net","r.bing.com",
    "s-ring.msedge.net","t-ring.msedge.net","t-ring-fdv2.msedge.net","tse1.mm.bing.net",
    "widgetcdn.azureedge.net","widgetservice.azurefd.net","odinvzc.azureedge.net"
    "ads.arcct.msn.com","settings.family.microsoft.com","signup.live.com",
    "speech.platform.bing.com","ssl.live.com",


    #用于与 Microsoft Store 通信。 如果 关闭这些终结点的流量，则无法从Microsoft Store安装或更新应用。
    "share.microsoft.com","purchase.mp.microsoft.com",
    #"*displaycatalog.mp.microsoft.com","*.displaycatalog.mp.microsoft.com",
    #"displaycatalog.mp.microsoft.com","msedge.b.tlu.dl.delivery.mp.microsoft.com",
    #"slscr.update.microsoft.com","storesdk.dsx.mp.microsoft.com","sfdataservice-staging.microsoft.com","*g.akamaiedge.net",

    #微软待办
    "staging.to-do.microsoft.com","to-do.microsoft.com",

    #Office
    "www.office.com","blobs.officehome.msocdn.com",
    "officehomeblobs.blob.core.windows.net",
    "outlookmobile-office365-tas.msedge.net","officeclient.microsoft.com",
    "ecs.nel.measure.office.net","telecommandstorageprod.blob.core.windows.net",
    "roaming.officeapps.live.com","substrate.office.com","ocws.officeapps.live.com",
    "outlook.office365.com","office.com","tfl.nel.measure.office.net",
    "citrix.onmicrosoft.com","customervoice.microsoft.com",
    "officeapps.live.com","petrol.office.microsoft.com",
    "pptsgs.officeapps.live.com","pricelist.skype.com",
    "sdx.microsoft.com","view.officeapps.live.com",
    "config.office.com","ecs.office.com","support.content.office.net",
    "excel-telemetry.officeapps.live.com","nexus.officeapps.live.com",





    #OneDrive
    "g.live.com","api.onedrive.com",
    "skydrivesync.policies.live.net",
    "oneclient.sfx.ms","windows.policies.live.net",
    "logincdn.msauth.net","ams03pap005.storage.live.com",




    #团队
    "config.teams.microsoft.com",
    "teams.live.com",
    "teams.events.data.microsoft.com",
    "statics.teams.cdn.live.net","statics.teams.cdn.office.net",

    #用于检索设备元数据。 如果关闭此终结点的流量，将不会更新设备的元数据。
    "dmd.metaservices.microsoft.com","dmd.metaservices.microsoft.com.akadns.net",
    "dds.microsoft.com","fd.dds.microsoft.com","continuum.dds.microsoft.com",
    "aad.cs.dds.microsoft.com","cdpcs.access.microsoft.com","cs.dds.microsoft.com",


    #Windows 聚焦
    "arc.msn.com",
    "ris.api.iris.microsoft.com",
    "srtb.msn.com",
    "fd.api.iris.microsoft.com",
    "staticview.msn.com",
    "msnportal.msn.com",

    #用于 Windows 的兼容数据库更新。
    "adl.windows.com",

    #用于内容监管。 如果关闭此终结点的流量，Windows 更新代理将无法联系此终结点，从而采取回退行为。这可能导致内容被错误下载或根本不下载。
    "tsfe.trafficshaping.dsp.mp.microsoft.com",
    "dlassets-ssl.xboxlive.com",
    "da.xboxservices.com",
    "www.xboxab.com",
    "*.api.cdp.microsoft.com",
    "*.do.dsp.mp.microsoft.com",

    #推送通知服务 (WNS) 依赖项
    "*.notify.windows.com","sinwns1011421.wns.windows.com","sin.notify.windows.com","wns.windows.com",

    #Android AOSP 依赖
    "intunecdnpeasd.manage.microsoft.com",

    # VMware
    "vcsa.vmware.com","telemetry.vmware.com",
    "analytics.vmware.com","ssl-telemetry.vmware.com",
    "data.vmware.com","stats.vmware.com",
    "phonehome.vmware.com","hybrid-analytics.vmware.com",
    "vsanhealth.vmware.com","eapi.broadcom.com",
    "vvs.broadcom.com","vcf.broadcom.com",
    "dl.broadcom.com","auth.esp.vmware.com",
    "skyline.vmware.com","ocm.vmware.com",
    "cis.vmware.com","crb.vmware.com",
    "itbm.vmware.com","telemetry.tkg.vmware.com",
    "ft.tkg.vmware.com","nsxanalytics.vmware.com",
    "nsx-telemetry.vmware.com","vmware.sc.omtrdc.net",
    "telemetry.broadcom.com","services.broadcom.com",
    "api.broadcom.com","data.broadcom.com",
    "logbrowser.vmware.com","ftam.vmware.com",
    "upload.vmware.com","diagnostics.vmware.com",
    "support.vmware.com","analytics.cloud.vmware.com",
    "alert.vmware.com","endpoint.vmware.com",
    "havana.vmware.com","hcs.vmware.com",
    "ads.vmware.com","mktg.vmware.com",
    "tags.tiqcdn.com","telemetry.pivotal.io",
    "network.pivotal.io","run.pivotal.io",
    "defense-prod05.conferdeploy.net","analytics.carbonblack.io",
    "api.gb.carbonblack.io","pws.vmware.com",
    "hostupdate.vmware.com","notify.vmware.com",
    "ssl-pws.vmware.com","ops.vmware.com",
    "vmware.112.2o7.net","smetrics.vmware.com",
    "dpm.demdex.net","cm.everesttech.net",
    "segment.broadcom.com","api.bcom.com",
    "identity.broadcom.com","register.vmware.com",
    "download.vmware.com","download0.vmware.com",
    "download1.vmware.com","download2.vmware.com",
    "download3.vmware.com","download4.vmware.com",
    "softwareupdate.vmware.com",



    # 视频
    "data.bilibili.com","cm.bilibili.com",
    "analytics.bilibili.com","log.bilibili.com",
    "reporting.bilibili.com","ad.bilibili.com",
    "p.bilibili.com","btrace.bilibili.com",
    "log.douyucdn.cn","log.douyu.com",
    "adreport.douyu.com","stat.douyu.com",
    "act.douyu.com","stats.huya.com",
    "stat.huya.com","adlog.huya.com",
    "log.huya.com","business.huya.com",
    "reporting.biliapi.net","log-upload.biliapi.net",
    "adtrack.bilibili.com","infoc.bilibili.com",
    "f-log.bilibili.com","p2p-log.douyucdn.cn",
    "reporter.douyu.com","rtlog.douyu.com",
    "v-log.huya.com","p2p.huya.com",
    "szreport.huya.com","beacon-api.huya.com",
    "dotserver.douyucdn.cn","data.douyutv.com",
    "log.douyucdn.cn","act.douyutv.com",



    # github
    "collector.github.com","github-cloud.s3.amazonaws.com",
    "api.github-scripterror.com","github.browser-intake-datadog.com",
    "telemetry.github.com","copilot-telemetry.githubusercontent.com",
    "central.github.com","alive.github.com","origin-tracker.githubusercontent.com",



    # 杂
    "tracking.miui.com","data.mistat.xiaomi.com",
    "samsungads.com ","smetrics.samsung.com",
    "log-config.samsungcloudplatform.com","umeng.com",
    "umeng.co","bugly.qq.com","hm.baidu.com",
    "analysis.byteoversea.com","mon.snssdk.com",
    "anonymous-communication.ghostery.net",
    "activation.navicat.com","licensing.navicat.com",
    "customer.navicat.com","www.navicat.com",
    "download.navicat.com","patch.navicat.com",
    "updater.navicat.com","cloud.navicat.com",
    "cloud-cluster-1.navicat.com","cloud-cluster-2.navicat.com",
    "track.navicat.com","*.navicat.com",
    "navicat.com","resources.jetbrains.com",
    "usage.jetbrains.com","scans.gradle.com",
    "o1310037.ingest.sentry.io","api.mixpanel.com","gratipay.jetbrains.com",
    "dbeaver.io","dbeaver.com","telemetry.jetbrains.com",
    "serp.dbeaver.com","ai-service-telemetry.jetbrains.com",
    "error-report.jetbrains.com","statistics.jetbrains.com",
    "feature-flags.jetbrains.com","telemetry.nvidia.com",
    "events.gfe.nvidia.com","telemetry.gfe.nvidia.com",
    "p1-ln.daumcdn.net","p2-ln.daumcdn.net",
    "t1.daumcdn.net","tvpot.daum.net",
    "play.kakao.com","rts.logitech.com",
    "rts-cloud.logitech.com","telemetry.logitech.com",
    "telemetry.razerapi.com","rs-telemetry.razerapi.com",
    "crash-stats.obsproject.com","obsproject.com",
    "edge.activity.nvidia.com","gcmd.nvidia.com",
    "international-gfe.nvidia.com","api2.amplitude.com",
    "ad.daum.net","display.ad.daum.net",
    "tiara.daum.net","stat.tiara.kakao.com",
    "nv-events.data.microsoft.com","nvidia.cloud.answerhub.com",
    "logi-stream.logitech.com","cortex.razerapi.com",
    "purchase-api.razer.com","videofarm.daum.net",
    "kapi.kakao.com","e.qq.com",
    "gdt.qq.com","pgdt.gtimg.cn",
    "tajs.qq.com","btrace.qq.com","adx.qq.com",
    "hm.baidu.com","pos.baidu.com",
    "adm.baidu.com","cbjs.baidu.com",
    "nsclick.baidu.com","rollbar.com","a.rollbar.com","*.rollbar.com",
    "umeng.co","*.umeng.com","android.bugly.qq.com",
    "*.umeng.co","ynufx.alipay.com",
    "acs.m.taobao.com","tanx.com","t.gdt.qq.com",
    "click.simba.taobao.com","mon.snssdk.com",
    "log.snssdk.com","toblog.ctobsnssdk.com",
    "pangolin-sdk-va.com","pangle.io",
    "crash.steampowered.com","store.images.s3.amazonaws.com",
    "telemetry.blizzard.com","bnet.live.logger.blizzard.com",
    "rnet.blizzard.com",
    "netease.crashsight.com","dun.163.com",
    "g.163.com","iplay.163.com","httpdns.n.shifen.com","httpdns.netease.com",
    "stat.yystatic.com","log.yy.com","log.cc.netease.com",
    "adclick.yy.com","show.ad.yy.com","*.proxima.nie.netease.com",
    "extshort.weixin.qq.com","pingma.qq.com","stat.yy.com",
    "sc.reg.qq.com","aegis.qq.com","sigma.dd.163.com","stat.tp.qq.com",
    "monitor.uu.163.com","amdc.m.taobao.com","metrics.yy.com",
    "hydra.alibaba.com","i.snssdk.com","m.pingma.qq.com",
    "d.pangle.io","log-va.byteoversea.com",
    "mon-va.byteoversea.com","update.pan.baidu.com",
    "netease.neteaseup.com","unisdk.163.com",
    "steamloopback.host","httpdns.gdtimg.com",
    "ax.itop.qq.com","httpdns-api.alicdn.com",
    "amsglobal.alicdn.com","dig.bdurl.net",
    "extlog.snssdk.com","httpdns.volcengine.com",
    "httpdns.baidu.com","httpdns.n.netease.com",
    "hostbuf.com","www.hostbuf.com",
    "api.hostbuf.com","mixpanel.com",
    "segment.io","*.mixpanel.com",
    "*.segment.io","bandisoft.com",
    "www.bandisoft.com","api.bandisoft.com",
    "*.bandisoft.com","googleads.g.doubleclick.net",
    "pagead2.googlesyndication.com","wftpserver.com",
    "ftprush.com","*.wftpserver.com",
    "*.ftprush.com","register.internetdownloadmanager.com",
    "internetdownloadmanager.com","*.internetdownloadmanager.com",
    "h-statistics.kaspersky-labs.com","geo.kaspersky.com",
    "purevpn-d.openx.net","fs.hostbuf.com",
    "tonec.com","www.tonec.com","growingio.com",
    "*.tonec.com","bandisoft.net","api.growingio.com",
    "bandi.so","*.bandisoft.net","api-ad.123pan.com",
    "*.bandi.so","zu.ucweb.com",
    "puds.ucweb.com","track.uc.cn",
    "ut.ucweb.com","adashbc.ut.taobao.com",
    "log.kugou.com","tj.kugou.com",
    "ads.kugou.com","gg.kugou.com",
    "statistics.pandora.kugou.com","cdn.utorrent.com",
    "api.utorrent.com","offers.bittorrent.com",
    "telemetry.bittorrent.com","ssl.bandisoft.com",
    "www.bandicam.com","bandicam.com",
    "telemetry.deepl.com","deepl-app-t.deepl.com",
    "ali-stats.ucweb.com","pin.aliyun.com",
    "p2p.kugou.com","fanxing.kugou.com",
    "fx.service.kugou.com","analytics.live.bittorrent.com",
    "bttrack.com","telemetry.deepl.net",
    "deepl-app-t.deepl.net","telemetry.glasswire.com","api.glasswire.com",
    "activation.glasswire.com",
    "netlimiter.com","www.netlimiter.com",
    "lock.netlimiter.com","ro76ki69g1.execute-api.us-east-1.amazonaws.com",
    "mobile-api.glasswire.com","locktime.netlimiter.com",
    "eshop.netlimiter.com","*.netlimiter.com","cloud.360.cn","v.360.cn",
    "s.360.cn","sd.360.cn","rum.battlenet.com.cn",
    "leak.360.cn","dianjing.360.cn","rum.battle.net",
    "e.360.cn","pop.360.cn","rum.battlenet.com",
    "notice.360.cn","hao.360.com","kinesis.us-east-1.amazonaws.com",
    "dh.360.cn","update.360safe.com",
    "dl.360safe.com","urlsc.360.cn",
    "browser.360.cn","se.360.cn",
    "mon.zijieapi.com","mcs.zijieapi.com",
    "snssdk.com","*.snssdk.com",
    "amemv.com","*.amemv.com",
    "toutiaoapi.com","*.toutiaoapi.com","log.byteoversea.com",
    "volces.com","*.volces.com","cnzz.com","*.cnzz.com",
    "tpstelemetry.tencent.com","badjs2.qq.com",
    "btrace.qq.com","log.mmstat.com",
    "crash.163.com","iad.163.com","ad.163.com",
    "klog.kuaishou.com","kslog.com","ead.163.com",
    "*.kslog.com","hm.baidu.com","nex.163.com",
    "hmt.baidu.com","talkingdata.net","cpro.baidustatic.com"
    "*.talkingdata.com","sensorsdata.cn",
    "*.sensorsdata.cn","radars.apple.com",
    "metrics.apple.com","beacons5.gvt3.com",
    "beacons.gcp.gvt2.com","beacons.gvt2.com",
    "beacons4.gvt2.com","beacons5.gvt2.com",
    "*.gvt2.com","*.gvt3.com","pubsub.razersynapse.com",
    "*.*.gvt2.com","potplayertv.daum.net",
    "p1-play.edge4k.com","p2-play.edge4k.com",
    "gips0.baidu.com","gips1.baidu.com","gips2.baidu.com",
    "gips3.baidu.com","gips4.baidu.com","gips5.baidu.com",
    "mirror.toolbar.netcraft.com","feature-flagging.deepl.com",
    "static.cloudflareinsights.com","telemetry.incredibuild.com",
    "telemetry.tgp.qq.com","log.tgp.qq.com",
    "stat.tgp.qq.com","adshost.tgp.qq.com",
    "upgrade.tgp.qq.com","cloud.tgp.qq.com",
    "telemetry.lmstudio.ai","telemetry.asus.com",
    "srv-gpustats.asus.com","telemetry.msi.com",
    "register.msi.com","rtd.msi.com","clientofficeplus.cn",
    "api.pixpinapp.com","update.snipaste.com",
    "api-rog.asus.com","rog-live-service.asus.com",
    "odinapi.asus.com","titan.asus.com","client.officeplus.cn",
    "demeter.asus.com","messageapi.asus.com","officeplus.cn",
    "mymessage.asus.com","asc-appservice-01.asus.com","pcmconfig.officeplus.cn",
    "asus-brand-assistant.asus.com","routerfeedback.asus.com",
    "routerahs.asus.com","content.msi.comapi-us.msi.com",
    "api-eu.msi.com","security.msi.com","mq.dataservices.hp.com",
    "custom.snipaste.com","analytics.hp.com","metrics.hp.com",
    "telemetry.hp.com","device-metrics.hp.com","gx-target-experiments-frontend-api.gx.nvidia.cn",
    "events.hp.com","notifications.hpsmart.com","geo-location-finder.logitechg.com.cn",
    "metrics.asus.com","event.asus.com","datapipeline.services.logitechg.com.cn",
    "analytics.msi.com","telemetry.razer.com",
    "analytics.razer.com","insider.razer.com",
    "analytics.logitech.com","crash.logitech.com",
    "dsadata.intel.com","telemetry.intel.com",
    "telemetry.killernetworking.com","analytics.killernetworking.com",
    "telemetry.qualcomm.com","analytics.qualcomm.com",
    "telemetry.mediatek.com","analytics.mediatek.com",
    "metrics.amd.com","telemetry.amd.com","ice.alibaba-inc.com",
    "telemetry.nahimic.com","telemetry.steelseries.com",
    "telemetry.corsair.com","telemetry.dell.com","miracletek.net","www.miracletek.net",
    "telemetry.lenovo.com","telemetry.acer.com","cc.fp.ps.netease.com",
    "telemetry.gigabyte.com","telemetry.asrock.com",
    "googlesyndication.com","*.googlesyndication.com",
    "*.app-measurement.com","firebaseremoteconfig.googleapis.com",
    "firebasecrashlytics.googleapis.com","crashlytics.com",
    "*.crashlytics.com","crashlyticsreports-pa.googleapis.com",
    "*.appcenter.ms","appcenter.ms",
    "in.appcenter.ms","api.appcenter.ms",
    "install.appcenter.ms","o450.ingest.sentry.io",
    "o0.ingest.sentry.io","o1.ingest.sentry.io",
    "o2.ingest.sentry.io","o3.ingest.sentry.io",
    "o4.ingest.sentry.io","o5.ingest.sentry.io","o33249.ingest.sentry.io",
    "ingest.sentry.io","notify.bugsnag.com","survey.jetbrains.com",
    "sessions.bugsnag.com","browser-intake-datadoghq.com",
    "trace.agent.datadoghq.com","rum.browser-intake-datadoghq.com",
    "bam.nr-data.net","js-agent.newrelic.com","mkt.jetbrains.com",
    "collector.newrelic.com","mobile-collector.newrelic.com",
    "api.segment.io","cdn.segment.com",
    "events.segment.io","decide.mixpanel.com",
    "api.amplitude.com","region1.amplitude.com",
    "script.hotjar.com","surveystats.hotjar.com",
    "static.hotjar.com","vars.hotjar.com",
    "edge.fullstory.com","rs.fullstory.com",
    "bf.dynatrace.com","js-cdn.dynatrace.com",
    "api.instabug.com","sdk.instabug.com",
    "app.posthog.com","us.i.posthog.com",
    "eu.i.posthog.com","api.count.ly",
    "metrics.count.ly","config.uca.cloud.unity3d.com",
    "cdp.cloud.unity3d.com","sentry.io",
    "appsflyer.com","*.sentry.io",
    "*.appsflyer.com","events.appsflyer.com",
    "t.appsflyer.com","register.appsflyer.com",
    "app.adjust.com","view.adjust.com",
    "gdpr.adjust.com","api.branch.io",
    "cdn.branch.io","stats.jpush.cn",
    "api.jpush.cn","alogs.umeng.com",
    "ulogs.umeng.com","umsns.com",
    "*.umsns.com","tongji.talkingdata.com",
    "talkingdata.com","cpatrk.net",
    "*.cpatrk.net","trackingio.com",
    "*.trackingio.com","*.jpush.cn",
    "getui.com","sdk.open.gt.igexin.com",
    "*.getui.com","pangle.com","eclick.baidu.com",
    "*.pangle.io","*.pangle.com","wn.pos.baidu.com","drmcm.baidu.com",
    "mobads.baidu.com","qzs.qq.com","mobads-logs.baidu.com",
    "mcs.snssdk.com","rtlog.snssdk.com","als.baidu.com",
    "tongji.dcloud.io","log.dcloud.net.cn","bzclk.baidu.com",
    "c.mob.com","api.share.mob.com","log.pan.baidu.com",
    "hmma.baidu.com","yd.netease.com","hpd.baidu.com",
    "ac.dun.163.com","amaplog.com","ad.player.baidu.com",
    "logs.amap.com","adash.amap.com",
    "sad.amap.com","pagead.amap.com","p2p.baidu.com",
    "ta.qq.com","vlog.meituan.com",
    "analytics.meituan.com","ad.meituan.com",
    "reco.meituan.com","acsr.taobao.com",
    "adash.m.taobao.com","policy.jd.com","p2p.bdimg.com",
    "mercury.jd.com","ads.api.jd.com",
    "reco.m.jd.com","biz.weibo.com",
    "logs.sina.cn","log.music.163.com",
    "statistic.music.163.com","iadlog.music.163.com",
    "adash.music.163.com","log.tongji.baidu.com",
    "cpro.baidu.com","log-upload.bilibili.com",
    "e.kuaishou.com","analytics.kuaishou.com",
    "bllog.snssdk.com","vlog.snssdk.com",
    "pingtas.qq.com","safeblog.qq.com",
    "wlog.taobao.com","hng.taobao.com",
    "apoll.m.taobao.com","dlog.meituan.com",
    "report.meituan.com","log-ctc.kuaishou.com",
    "p.kuaishou.com","sp0.baidu.com",
    "sp1.baidu.com","*.caid.org.cn",
    "*.chinamobileads.org","shujulianmeng.com",
    "*.shujulianmeng.com","ynuf.meituan.com",
    "ynuf.alipay.com","fpt.pingan.com",
    "log.gifshow.com","stat.gifshow.com",
    "*pcdn*.biliapi.net","mcdn.bilivideo.cn",
    "mcdn.bilivideo.com","szbdyd.com",
    "cn-*.bilivideo.com","edge.mountaintoys.cn",
    "aliyun-pcdnts.douyucdn.cn",
    "abvolcapi.douyucdn.cn","www.voidtools.com",
    "voidtools.com","winmerge.org",
    "www.winmerge.org","*.xyplorer.com",
    "*.scootersoftware.com","*.xnview.com",
    "*.allcleaner.de","*.alldup.de",
    "xyplorer.com","scootersoftware.com",
    "xnview.com","allcleaner.de",
    "alldup.de","*.foobar2000.org",
    "foobar2000.org","*.proxifier.com",
    "proxifier.com","*.snipaste.com",
    "snipaste.com","*.pixpinapp.com",
    "pixpinapp.com","*.hostbuf.com",
    "*.netsarang.com","netsarang.com",
    "*.netsarang.co.kr","netsarang.co.kr",
    "*.mobatek.net","mobatek.net",
    "*.feem.io","feem.io",
    "*.syntevo.com","syntevo.com",
    "*.cross-plus-a.com","cross-plus-a.com",
    "*.faststone.org","*.irfanview.com",
    "faststone.org","irfanview.com",
    "*.goodsync.com","goodsync.com",
    "*.roboform.com","roboform.com",
    "*.luminescence-software.org","luminescence-software.org",
    "*.jam-software.com","*.jam-software.de",
    "*.r-tt.com","*.r-studio.com",
    "*.codecguide.com","codecguide.com",
    "*.piriform.com","*.ccleaner.com",
    "*.freefilesync.org","freefilesync.org",
    "ccleaner.com","piriform.com",
    "jobs.goodsync.com","lic.goodsync.com",
    "rf-api.roboform.com","telemetry.piriform.com",
    "telemetry-in.battlenet.com.cn","dup.baidustatic.com",
    "report-uri.baidu.com","ug.baidu.com","banti.baidu.com",
    "dlswbr.baidu.com","h2tcbox.baidu.com","suggestion.baidu.com",
    "miaowu.baidu.com","ugclandpage.pae.baidu.com","pcrec.baidu.com",
    "anti-bot.n.shifen.com","sptest.baidu.com","gsp0.baidu.com",
    "issuecdn.baidupcs.com","*.baidustatic.com",
    "log-upload.aliyuncs.com","cn-*.log.aliyuncs.com","arms-metrics-fwd.aliyuncs.com",
    "acsr.alicdn.com","adash.m.jae.taobao.com","ut.uc.cn","zzlog.uc.cn","track.uc.cn",
    "push.m.uc.cn","adis.uc.cn","ykmsg.youku.com","mtop.aliexpress.com","hector.baidu.com",
    "mbd.baidu.com","nstatis.urs.163.com","datastat.netease.com","log.unisdk.163.com","ClientLog.uu.163.com",
    "bislog.netease.com","advert.uu.163.com","ad.uu.163.com","notice.uu.163.com","prom.uu.163.com",
    "*.tongdun.cn","*.dun.163.com","analytics.163.com","injections.adguard.org","local.adguard.org",
    "stats.gradle.com","resources.jetbrains.com.cn","gratipay.jetbrains.com.cn","telemetry.jetbrains.com.cn",
    "mkt.jetbrains.com.cn","survey.jetbrains.com.cn","usage.jetbrains.com.cn",
    "ai-service-telemetry.jetbrains.com.cn","statistics.jetbrains.com.cn",
    "error-report.jetbrains.com.cn","feature-flags.jetbrains.com.cn","hub.163.com",
    "telemetry.copilot.githubservices.com","default.exp-website.com","exptest.com",
    "telemetry.arduino.cc","analytics.arduino.cc","telemetry.vsvas.microsoft.com","ir.163.com",
    "cdp.cloud.unity3d.com","config.unity3d.com","data-optout-service.unity3d.com",
    "telemetry.unity3d.com","analytics.cocos.com","telemetry.cocos.com",
    "analytics.gamepp.com","log.gamepp.com","stat.gamepp.com","stat.yandex.ru",
    "api-app.adguard.com","metrics.adguard.com","telemetry.openai.com","telemetry.yandex.ru",
    "analytics.google.com","play.google.com","telemetry.googleapis.com","metrika.yandex.com",
    "quantserve.com","pixel.wp.com","telemetry.poe.com","mc.yandex.ru","mc.yandex.md",
    "metrika.yandex.ru","appmetrica.yandex.ru","crashreport.libreoffice.org","appmetrica.yandex.com",
    "analytics.mobisystems.com","tracking.mobisystems.com","log.mobisystems.com",
    "stats.onlyoffice.com","telemetry.onlyoffice.com","laptop-updates.brave.com",
    "p3a.brave.com","crash-reports.mozilla.com","metrics.default-browser.com",
    "stats.catsbrowser.com","pipes.startpage.fragment.skybeam.microsoft.com",
    "analytics.unity3d.com","perf-events.cloud.unity3d.com","monetization-telemetry.unity3d.com","log.cocos.com",
    "event.cocos.com","data.gamepp.com","report.gamepp.com",
    "api-log.gamepp.com","p3.adguard.com","reports.adguard.com",
    "events.launchdarkly.com","o33249.ingest.sentry.io","monitoring.googleapis.com",
    "api2.branch.io","event.mobisystems.com","sdk.mobisystems.com",
    "v1.stats.onlyoffice.com","ping.telemetry.mozilla.org","telemetry-coverage.mozilla.org",
    "detectportal.firefox.com","p3a-json.brave.com","variations.brave.com",
    "ext.metrika.yandex.ru","mc.yandex.com","clck.yandex.ru","stats.g.doubleclick.net",
    "az416426.vo.msecnd.net","dc.applicationinsights.microsoft.com","telemetry.developer.microsoft.com","config.playfabapi.com","telemetry.sentry.io",
    "analytics.quickfire.unity3d.com","builder.arduino.cc","count.gamepp.com",
    "collector.gamepp.com","client-telemetry.openai.com","cdn.optimizely.com",
    "api.mixpanel.com","clouderrorreporting.googleapis.com","play-fe.googleapis.com",
    "api.singular.net","app-measurement.com","telemetry.documentfoundation.org",
    "log-sdk.mobisystems.com","mobisystems-analytics.com",
    "location.services.mozilla.com","referrals.brave.com","crash.yandex.ru",
    "grant.brave.com","grant.rewards.brave.com",
    "ads.mobisystems.com","hub.libreoffice.org","reporter.yandex.net",
    "log.yy.com","an.yandex.ru",
    "stat.yy.com","metrics.yy.com","awaps.yandex.ru",
    "trace.yy.com","report.yy.com","bs.yandex.ru",
    "analytics.yy.com","collector.yy.com",
    "data.yy.com","ad.yy.com",
    "adx.yy.com","union.yy.com",
    "pop.yy.com","adv.yy.com",
    "stat.duowan.com","log.duowan.com",
    "ad.duowan.com","stat.huya.com",
    "analytics.huya.com","analytics.duowan.com",
    "trace.duowan.com","data.duowan.com",
    "collector.duowan.com","adx.duowan.com",
    "adv.duowan.com","pop.duowan.com",
    "union.duowan.com","third-party-ad.yy.com",
    "third-party-ad-bqt.yy.com","adx-interface.yy.com",
    "newreddot.yy.com","pcyy-smallgame-tab.yy.com",
    "message-game.yy.com","imobfeedback.yy.com",
    "config.exceptionless.io","mmonitor.cc.163.com",
    "prod.otel.kaizen.nvidia.com","events.telemetry.data.nvidia.cn",
    "gm.mmstat.com","otel.gitkraken.com","mxana.tacool.com",
    "ads.mozilla.org","silkroad.csdn.net","beacons2.gvt2.com",
    "px.effirst.com","statistic.csdn.net","mp-activity.csdn.net",
    "msdl.microsoft.com","ping.cloud.tencent.com","sensors.cloud.tencent.com",
    "hdaa.shuzilm.cn","cstaticdun.126.net","creative.tscprts.com",
    "h.trace.qq.com","spocs.getpocket.com","otheve.beacon.qq.com",
    "d.ghostery.com",








    ## Windows 更新
    # "definitionupdates.microsoft.com",
    # "emdl.ws.microsoft.com",
    # "*.delivery.mp.microsoft.com",
    # "*.update.microsoft.com",
    # "windowsupdate.microsoft.com",
    # "update.microsoft.com",
    # "download.windowsupdate.com",


    # #从 Microsoft Store 下载操作系统修补程序、更新和应用。 如果关闭这些终结点的流量，设备将无法下载操作系统的更新。
    # "*.dl.delivery.mp.microsoft.com",
    # "*.windowsupdate.com",

    #联机激活和某些应用许可
    #"licensing.mp.microsoft.com","*.licensing.mp.microsoft.com","*licensing.mp.microsoft.com","clientservices.googleapis.com",

    #自动更新的证书
    # "ctldl.windowsupdate.com","ocsp.digicert.com",

    #"edge.microsoft.com","ax-0002.ax-msedge.net", # 翻译保留
    # "bing.com","www.bing.com","cn.bing.com","*.bing.com","bing.net","*.bing.net", # 全面干掉万恶的bing

    #"clients1.google.com","clients2.google.com","clients3.google.com","clients4.google.com","clients2.googleusercontent.com"

    # "login.microsoftonline.com",

    # vs
    #"openvsxorg.blob.core.windows.net","open-vsx.org","openvsxorg.blob.core.windows.net",
    # "update.code.visualstudio.com","update.code.visualstudio.com","marketplace.visualstudio.com",
    # "developercommunity.visualstudio.com","download.visualstudio.microsoft.com","aka.ms",
    # "vscode-sync.trafficmanager.net","*.gallery.vsassets.io","gallery.vsassets.io",
    # "c2rsetup.officeapps.live.com","telemetry.visualstudio.microsoft.com","oneocsp.microsoft.com",
    # "in.applicationinsights.azure.cn","go.microsoft.com","fe3cr.delivery.mp.microsoft.com",


    #字体
    #"fs.microsoft.com",


    "*-kmwatsonc.events.data.microsoft.com",
    "*-umwatsonc.events.data.microsoft.com","*.events.data.microsoft.com",
    "watson.*.microsoft.com","*smartscreen-prod.microsoft.com",
    "*.*.events.data.microsoft.com","*.wns.windows.com",
    "*.pipe.aria.microsoft.com","*.manage.microsoftonline.cn",
    "*.dm.microsoft.com","*.telecommand.telemetry.microsoft.com",
    "*.ams9.msecn.net","*.a-msedge.net","*.nsatc.net",
    "doubleclick.net","*.doubleclick.net","*.prod.do.dsp.mp.microsoft.com"
)

# 参考网站
#https://learn.microsoft.com/zh-cn/windows/privacy/configure-windows-diagnostic-data-in-your-organization
#https://learn.microsoft.com/zh-cn/windows/privacy/windows-privacy-compliance-guide
#https://learn.microsoft.com/zh-cn/windows/privacy/manage-windows-11-endpoints
#https://learn.microsoft.com/zh-cn/windows/privacy/windows-11-endpoints-non-enterprise-editions
#https://learn.microsoft.com/zh-cn/windows/privacy/manage-windows-1809-endpoints
#https://learn.microsoft.com/zh-cn/windows/privacy/manage-windows-21h2-endpoints
#https://learn.microsoft.com/zh-cn/windows/privacy/essential-services-and-connected-experiences
#https://learn.microsoft.com/zh-cn/windows/privacy/required-service-data

# 建议使用防火墙 或者 DNS拦截
# 规则更加细 目前只是粗浅封禁一些域名
# AdGuard mosdns AdBlock uBlock mosdns smartdns 这些



$targetDomains = $targetDomains | Select-Object -Unique

$DomainFile = Join-Path $PrivacyBackup "domains.txt"

$targetDomains | Set-Content -Path $DomainFile -Encoding UTF8

if (Test-Path $hostsPath) {
    $currentHosts = Get-Content $hostsPath
    $linesToAdd = [System.Collections.Generic.List[string]]::new()

    foreach ($domain in $targetDomains) {
        # 1. 过滤 hosts 不支持的通配符域名
        if ($domain.Contains('*')) {
            Write-Warning "跳过无效域名: $domain (hosts 文件不支持通配符 *)"
            continue
        }

        # 2. 正则检查当前域名是否已被屏蔽
        $escapedDomain = [regex]::Escape($domain)
        $pattern = "^\s*(127\.0\.0\.1|0\.0\.0\.0)\s+$escapedDomain"
        $alreadyMatched = $currentHosts | Where-Object { $_ -match $pattern }

        # 3. 如果未屏蔽，准备追加
        if (-not $alreadyMatched) {
            $linesToAdd.Add("0.0.0.0 $domain")
            Write-Host "[+] 待屏蔽域名: $domain" -ForegroundColor Green
        }
    }

    # 4. 只有存在新条目时，才进行一次性写入，避免频繁操作文件
    if ($linesToAdd.Count -gt 0) {
        try {
            Add-Content -Path $hostsPath -Value $linesToAdd -ErrorAction Stop
            Write-Host "[✓] 成功写入 $($linesToAdd.Count) 条记录到 Hosts 文件" -ForegroundColor Cyan
        } catch {
            Write-Error "写入 Hosts 失败: $_"
        }
    } else {
        Write-Host "[i] 所有域名已存在或已被忽略，无需更新。" -ForegroundColor Yellow
    }
}

# 3. 拦截硬编码 IP（高级防火墙规则 - 扩展范围）
Write-Host "`n[2/6] 开始配置高级防火墙封锁遥测 IP 段..." -ForegroundColor Yellow
<# $TelemetryIPs = @(
    "4.237.91.160/29","4.160.64.120/29","135.225.147.168/29",
    "4.173.72.88/29","4.248.114.8/29","74.242.234.136/29",
    "4.188.45.56/29","48.211.114.168/29","74.243.192.152/29",
    "72.153.16.200/29","4.251.29.8/29","4.250.47.152/29",
    "4.182.156.104/29","48.210.117.64/29","172.208.176.8/29",
    "4.230.181.72/29","72.145.24.32/29","72.145.132.208/29",
    "4.171.44.192/29","4.222.245.0/29","172.178.185.8/29",
    "23.98.246.88/29","57.155.157.72/29","72.154.34.248/29",
    "57.154.125.160/29"
)
foreach ($ip in $TelemetryIPs) {
    $ruleName = "Block_MS_Telemetry_$($ip -replace '/', '_').$($ip -replace '\.', '_')"
    if (!(Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -Name $ruleName -DisplayName "Block Microsoft Telemetry IP ($ip)" -Direction Outbound -RemoteAddress $ip -Action Block | Out-Null
        Write-Host "[+] 防火墙已成功封锁 IP 段: $ip" -ForegroundColor Green
    }
}

# 定义防火墙规则的名称
$RuleName = "Block_Microsoft_Telemetry_Domains"

Write-Host "开始解析域名并配置防火墙封禁规则..." -ForegroundColor Cyan
Write-Host "--------------------------------------------------" -ForegroundColor Gray

# 用于存储解析出来的所有 IP 地址
#$ipList = @()
#>

# 2. 遍历域名并解析出对应的 IP
foreach ($domain in $targetDomains) {
    Write-Host "正在解析域名: $domain ..." -ForegroundColor Yellow
    #Add-DnsClientNrptRule -Namespace $domain -Action Block

    $Namespace = $domain

    # 自动清洗：如果用户不小心输入了带有星号的 "*.domain.com"，自动转换为标准的 ".domain.com"
    if ($Namespace -like "*") {
        $Namespace = $Namespace -replace '^\*', ''
        $Namespace = $Namespace -replace '^\.\.', '.'
    }

    $ExistingRule = Get-DnsClientNrptRule -ErrorAction SilentlyContinue | Where-Object { $_.Namespace -eq $Namespace }

    if (-not $ExistingRule) {
        # 执行底层拦截核心命令
        #Add-DnsClientNrptRule -Namespace $Namespace -Action Block | Out-Null
        Add-DnsClientNrptRule -Namespace $Namespace -NameServers "0.0.0.0"
        Write-Host "[本地DNS强制解析] -> 规则已建立，$Namespace 解析至 0.0.0.0" -ForegroundColor Green
    }

    <# try {
        # 同时解析 IPv4 (A) 和 IPv6 (AAAA) 记录，忽略报错
        $ips = Resolve-DnsName -Name $domain -ErrorAction SilentlyContinue | Where-Object {$_.Type -in @('A', 'AAAA')} | Select-Object -ExpandProperty IPAddress
        if ($ips) {
            $ipList += $ips
            foreach ($ip in $ips) {
                Write-Host "  -> 发现 IP: $ip" -ForegroundColor Gray
            }
        } else {
            Write-Warning "  [! ] 未能解析到该域名的 IP 地址（可能当前网络无法连接或域名失效）。"
        }
    } catch {
        Write-Warning "  [! ] 解析 $domain 时发生未知错误。"
    } #>

}


# 取消某一个域名
#Get-DnsClientNrptRule | Where-Object {$_.Namespace -eq "xxx.com"} | Remove-DnsClientNrptRule -Force

# 强制清空所有的 NRPT 规则
#Get-DnsClientNrptRule | Remove-DnsClientNrptRule -Force




# 数组去重，确保 IP 列表唯一
<# $ipList = $ipList | Select-Object -Unique

# 3. 如果成功获取到 IP，则将其写入防火墙规则
if ($ipList.Count -gt 0) {
    Write-Host "`n正在配置防火墙规则..." -ForegroundColor Cyan

    # 检查是否已存在同名规则，如果存在则先删除，以便更新最新的 IP 列表
    if (Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue) {
        Remove-NetFirewallRule -Name $RuleName -Confirm:$false
        Write-Host "已清理旧的防火墙规则，准备更新。" -ForegroundColor Gray
    }

    # 创建新的出站封禁规则
    New-NetFirewallRule -Name $RuleName -DisplayName "封禁微软遥测域名 IP (脚本自动创建)" -Description "阻止向微软核心遥测域名发送数据" -Direction Outbound -RemoteAddress $ipList -Action Block | Out-Null


    Write-Host "--------------------------------------------------" -ForegroundColor Gray
    Write-Host "[成功] 防火墙出站规则已建立！" -ForegroundColor Green
    Write-Host "[结果] 已成功封锁以上域名的共 $($ipList.Count) 个 IP 地址。" -ForegroundColor Green
} else {
    Write-Host "--------------------------------------------------" -ForegroundColor Gray
    Write-Warning "【提示】未解析到任何有效 IP，未对防火墙做出修改。"
}
 #>

}

function New-killservices () {
# 4. 禁用系统级遥测与标准隐私相关服务（融合 13 项服务）
Write-Host "`n[3/6] 开始封印标准行为追踪与不必要的系统服务..." -ForegroundColor Yellow
# 定义服务名与中文说明的映射
$standardServices = @{
    "DiagTrack"        = "Connected User Experiences and Telemetry (连接的用户体验和遥测)"
    "dmwappushservice" = "WAP Push Message Routing Service (设备管理无线应用推播服务)"
    "DPS"              = "Diagnostic Policy Service (诊断策略服务)"
    "WdiServiceHost"   = "Diagnostic Service Host (诊断服务主机)"
    "WdiSystemHost"    = "Diagnostic System Host (诊断系统主机)"
    "WerSvc"           = "Windows Error Reporting Service (Windows 错误报告服务)"
    "PcaSvc"           = "Program Compatibility Assistant Service (程序兼容性助手服务)"
    "lfsvc"            = "Geolocation Service (地理位置服务)"
    "CDPSvc"           = "Connected Devices Platform Service (连接设备平台服务)"
    "WbioSrvc"         = "Windows Biometric Service (生物识别服务 - 如不用面容/指纹解锁可放心禁用)"
    "CDPUserSvc"       = "Connected Devices Platform User Service (连接设备平台用户服务)"
    "DusmSvc"          = "Data Usage and Size Monitor (数据使用和大小监视器)"
    "DoSvc"            = "Delivery Optimization (执行内容传递优化任务)"
}

foreach ($service in $standardServices.Keys) {
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        try {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue | Out-Null
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Host "[+] 已成功强行禁用: $($standardServices[$service])" -ForegroundColor Green
        } catch {
            Write-Host "[!] 禁用服务失败: $service ($_)" -ForegroundColor Red
        }
    } else {
        Write-Host "[-] 系统中未找到服务: $service" -ForegroundColor Gray
    }
}

Get-Service -Name 'CDPUserSvc_*' -ErrorAction SilentlyContinue | ForEach-Object {
    Stop-Service -Name $_.Name -Force -ErrorAction SilentlyContinue | Out-Null
}



# 5. 针对受保护/动态后缀服务的硬核注册表封锁
Write-Host "`n[4/6] 正在通过注册表底层硬锁受保护的数据同步服务..." -ForegroundColor Yellow
$registryServices = @("UserDataSvc", "UnistoreSvc", "PimIndexMaintenanceSvc", "OneSyncSvc", "DoSvc","CDPSvc","CDPUserSvc")

foreach ($regSvc in $registryServices) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Services\$regSvc"
    if (Test-Path $path) {
        # Start=4 代表彻底禁用 (Disabled)
        New-ItemProperty -Path $path -Name "Start" -Value 4 -Force | Out-Null
        Write-Host "[+] 注册表内核已强行永久关闭服务: $regSvc (含动态后缀模板)" -ForegroundColor Green
    }
}


# 删除 IdentityCRL 密钥 高危 在 Windows 环境中，IdentityCRL（Identity Common Runtime Library）存储着你登录 Microsoft 账户（如 Edge、OneDrive、Office 等）的凭据令牌和缓存状态
$idKey = 'HKCU:\Software\Microsoft\IdentityCRL'
if (Test-Path $idKey) {
    $backupPath = Join-Path $PrivacyBackup 'GDID-Guard\IdentityCRL-backup.reg'
    reg export "HKCU\Software\Microsoft\IdentityCRL" $backupPath /y | Out-Null
    Write-Host "将 IdentityCRL 注册表项备份到 $backupPath "
    Remove-Item -Path $idKey -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "高危操作 已删除  HKCU:\Software\Microsoft\IdentityCRL"
} else {
    Write-Host "未找到待清除的 IdentityCRL 密钥。"
}

# 6. 清理隐藏的任务计划程序 (CEIP 与 深度遥测清理)
Write-Host "`n[5/6] 开始深度清理任务计划程序中的隐形偷跑任务..." -ForegroundColor Yellow

$tasks = @(
    # 原有的 CEIP 与 应用评估
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM",
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",

    # Edge
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineCore",
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineUA",
    "\Microsoft\EdgeUpdate\LogUpload",

    # CCleaner
    "\CCleanerCrashReporting",
    "\CCleanerUpdate",
    "\CCleanerSkipUAC"

    # 补充 1：应用与启动项评估
    "\Microsoft\Windows\Application Experience\PcaPatchDbTask",
    "\Microsoft\Windows\Application Experience\StartupAppTask",

    # 补充 2：系统反馈与设备诊断
    "\Microsoft\Windows\Feedback\Siuf\ManifestProcessor",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem",

    # 补充 3：错误上报与网络隐私收集
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting",
    "\Microsoft\Windows\NetTrace\GatherNetworkInfo",

    # 补充 4：开机引导与推送弹窗
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"

    # 补充 5：离线地图与位置隐私 ---
    "\Microsoft\Windows\Maps\MapsToastTask",
    "\Microsoft\Windows\Maps\MapsUpdateTask",
    "\Microsoft\Windows\Location\Notifications",

    # 补充 6：输入法与语音遥测 ---
    "\Microsoft\Windows\Speech\SpeechModelDownloadTask",
    "\Microsoft\Windows\Input\InputAppViewer",

    # 补充 7：硬件评估（防止后台无故跑分卡顿） ---
    "\Microsoft\Windows\Maintenance\WinSAT",

    # 补充 8：设备和磁盘扫描 ---
    "\Microsoft\Windows\Device Information\Device",
    "\Microsoft\Windows\Device Directory Client\RegisterDevicePeriodically",
    "\Microsoft\Windows\DiskFootprint\Diagnostics"

    # --- 补充 9：Edge 浏览器后台偷跑 ---
    "\Microsoft\EdgeUpdate\LogUpload",
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineUA",

    # --- 补充 10：跨设备活动追踪 ---
    "\Microsoft\Windows\User Profile\UserProfileCleanupTask",

    # --- 补充 11：Xbox 游戏后台遥测 ---
    "\Microsoft\XWizards\DeviceRegistration",

    # --- 补充 12：企业及移动端多余组件 ---
    "\Microsoft\Windows\Mobile Device Management\MDMAppInstaller"

    # --- 补充 13：零售演示残余 ---
    "\Microsoft\Windows\RetailDemo\CleanupOfflineContent",

    # --- 补充 14：远程协助与过时组件 ---
    "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask",

    # --- 补充 15：Microsoft Office 深度遥测 ---
    "\Microsoft\Office\OfficeTelemetryAgentLogOn",
    "\Microsoft\Office\OfficeTelemetryAgentFallBack",
    "\Microsoft\Office\Office Feature Updates",
    "\Microsoft\Office\Office Feature Updates Logon",

    # --- 补充 16：第三方软件（Chrome）幽灵任务 ---
    "\GoogleUserPEH\RunPlatformExperienceHelperOnUnlock"
    "\GoogleUserPEH\RunPlatformExperienceHelper_Metrics",
    "\GoogleUserPEH\RunPlatformExperienceHelper_Daily",

    # --- 补充 17：底层日志与深度诊断 ---
    "\Microsoft\Windows\WDI\ResolutionHost",
    "\Microsoft\Windows\Ras\ApmTopologySanityCompiler",
    "\Microsoft\Windows\AppReadiness\InitTask",

    # --- 补充 18：音效与语言包偷跑 ---
    "\Microsoft\Windows\Multimedia\SystemSoundsService",
    "\Microsoft\Windows\LanguagePack\LanguagePackCleanupTask",

    # --- 补充 19：显卡驱动已知固定遥测 ---
    "\AMD\AUEP"

    # --- 追击补充 20：推送与主题遥测 ---
    "\Microsoft\Windows\WPN\WpnNotificationTask",
    "\Microsoft\Windows\Theme\ReconcileFeatures",

    # --- 追击补充 21：无线环境与设备扫描 ---
    "\Microsoft\Windows\Bluetooth\Advertising",

    # --- 追击补充 22：磁盘过度诊断与多媒体版权残余 ---
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver",
    "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"
)

foreach ($task in $tasks) {
    # 兼容性处理：确保路径以反斜杠开头
    if (-not $task.StartsWith("\")) { $task = "\$task" }

    # 智能分离：直接使用正则或安全字符串切割，完美解决根目录 "\" 的报错问题
    $lastSlash = $task.LastIndexOf("\")
    if ($lastSlash -eq 0) {
        $taskPath = "\"
        $taskName = $task.Substring(1)
    } else {
        $taskPath = $task.Substring(0, $lastSlash)
        $taskName = $task.Substring($lastSlash + 1)
    }

    $taskPath = $taskPath + "\"

    # 获取任务状态（强制转换为数组，统一处理单任务和多任务实例情况）
    $scheduledTasks = @(Get-ScheduledTask -TaskPath $taskPath -TaskName $taskName -ErrorAction SilentlyContinue)

    # 如果找到了任务
    if ($scheduledTasks.Count -gt 0) {
        foreach ($sTask in $scheduledTasks) {
            if ($sTask.State -ne "Disabled") {
                # 推荐直接传入任务对象（$sTask），不仅 100% 准确，而且速度极快，还避开了路径字符串的二次解析漏洞
                $sTask | Disable-ScheduledTask | Out-Null
                Write-Host "[+] 已成功禁用定时任务: $taskName" -ForegroundColor Green
            } else {
                Write-Host "[-] 定时任务已处于禁用状态: $taskName" -ForegroundColor DarkGray
            }
        }
    } else {
        # 额外提示：方便你在调试时知道哪些任务在当前电脑上其实不存在
        Write-Host "[!] 系统中未找到该任务: $taskName" -ForegroundColor Gray
    }
}


# 2. 核心大招：利用通配符，动态模糊封杀 NVIDIA / AMD 显卡及第三方软件的随机名遥测任务
Write-Host "[*] 正在检索并斩断显卡驱动及第三方隐藏的动态遥测链..." -ForegroundColor Cyan

$blurryNames = @(
    "*NvTmRep*", "*CrashReport*", "*Telemetry*", "*AUEP*",
    "*GoogleUpdate*", "*GoogleSystemUpdate*", "*Firefox*", "*Mozilla*",
    "*CCleaner*", "*GoogleUserPEH*", "*RunPlatformExperienceHelper*", "*QuarkUpdater*"
)

foreach ($name in $blurryNames) {

    $dynamicTasks = @(Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue)

    foreach ($dTask in $dynamicTasks) {
        # 3. 核心安全红线过滤：防止误伤带有 "Telemetry" 字样的底层安全/核心系统组件
        if ($dTask.TaskPath -match "\\Windows\\Windows Defender" -or $dTask.TaskPath -match "\\Windows\\SecurityMitigations") {
            continue
        }

        if ($dTask.State -ne "Disabled") {
            # 4. 改用对象直接管道传输，100% 避开任务路径带空格、特殊字符无法解析的 Bug
            $dTask | Disable-ScheduledTask | Out-Null
            Write-Host "[强制封杀] 成功捕获并禁用动态遥测: $($dTask.TaskName)" -ForegroundColor Magenta
        }
    }
}


Write-Host "`n[✓] 任务计划程序全域清理完毕！Windows 已进入绝对纯净状态。" -ForegroundColor Green

# 7. 修改注册表内核键值（斩断行为活动、广告 ID、优化 NCSI）
Write-Host "`n[6/6] 开始修改注册表切断底层数据采集" -ForegroundColor Yellow

# 内核行为活动序列
$SystemPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
New-RegistryPath $SystemPolicyPath
New-ItemProperty -Path $SystemPolicyPath -Name "EnableActivityFeed" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $SystemPolicyPath -Name "PublishUserActivities" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $SystemPolicyPath -Name "UploadUserActivities" -Value 0 -PropertyType DWord -Force | Out-Null



$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PublishUserActivities'
New-RegistryPath $key
New-ItemProperty -Path $key -Name "PublishUserActivities" -Value 0 -PropertyType DWord -Force | Out-Null

$uploadKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\UploadUserActivities'
New-RegistryPath $uploadKey
New-ItemProperty -Path $uploadKey -Name "UploadUserActivities" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 修改内核行为活动序列" -ForegroundColor Green


# 语音激活 (彻底禁用应用语音激活及锁屏激活)
$AppPrivacyPath = "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy"
New-RegistryPath $AppPrivacyPath
New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsActivateWithVoice" -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsActivateWithVoiceAboveLock" -Value 2 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 彻底禁用应用语音激活及锁屏激活" -ForegroundColor Green


# 新闻和兴趣 (关闭任务栏新闻资讯栏目)
$AFeedsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
New-RegistryPath $AFeedsPath
New-ItemProperty -Path $AFeedsPath -Name "EnableFeeds" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 关闭任务栏新闻资讯栏目" -ForegroundColor Green

# 在线语音识别
$SpeechPrivacyPath = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
New-RegistryPath $SpeechPrivacyPath
New-ItemProperty -Path $SpeechPrivacyPath -Name "HasAccepted" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 关闭任务栏新闻资讯栏目" -ForegroundColor Green


# 禁用剪贴板历史记录和跨设备同步
$RegistryPathUser = "HKCU:\Software\Microsoft\Clipboard"
New-RegistryPath $RegistryPathUser
New-ItemProperty -Path $RegistryPathUser -Name "EnableClipboardHistory" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $RegistryPathUser -Name "CloudClipboardAutomaticUpload" -Value 0 -PropertyType DWord -Force | Out-Null

# 禁用剪贴板历史记录和跨设备同步
$RegistryPathPolicy = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
New-RegistryPath $RegistryPathPolicy
New-ItemProperty -Path $RegistryPathPolicy -Name "AllowCrossDeviceClipboard" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 禁用剪贴板历史记录和跨设备同步" -ForegroundColor Green


# 禁用Cortana
$CortanaPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
New-RegistryPath $CortanaPolicyPath
New-ItemProperty -Path $CortanaPolicyPath -Name "AllowCortana" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $CortanaPolicyPath -Name "AllowCortanaAboveLock" -Value 0 -PropertyType DWord -Force | Out-Null

$CortanaUserPath = "HKCU:\Software\Microsoft\Speech_OneCore\Preferences"
New-RegistryPath $CortanaUserPath
New-ItemProperty -Path $CortanaUserPath -Name "VoiceActivationEnable" -Value 0 -PropertyType DWord -Force | Out-Null


$CortanaService = Get-Service -Name "Cortana" -ErrorAction SilentlyContinue
if ($CortanaService) {
    Stop-Service -Name "Cortana" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "Cortana" -StartupType Disabled -ErrorAction SilentlyContinue
}

Write-Host "[+] 禁用Cortana" -ForegroundColor Green

# 关闭云端推送
$NotificationPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
New-RegistryPath $NotificationPath
New-ItemProperty -Path $NotificationPath -Name "NoCloudApplicationNotification" -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 关闭云端推送" -ForegroundColor Green

# 微软应用商店自动更新
$AutoUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
New-RegistryPath $AutoUpdate
New-ItemProperty -Path $AutoUpdate -Name "AutoDownload" -Value 2 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 关闭微软应用商店自动更新" -ForegroundColor Green


# 禁用 Windows 与手机的后台协同与跨设备联通
$phone = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Windows\Phone"
New-RegistryPath $phone
New-ItemProperty -Path $phone -Name "Enable" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 禁用 Windows 与手机的后台协同与跨设备联通" -ForegroundColor Green

# 关闭地图
$MapsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Maps"
New-RegistryPath $MapsPath
New-ItemProperty -Path $MapsPath -Name "AllowUntriggeredNetworkTrafficOnSettingsPage" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $MapsPath -Name "AutoDownloadMaps" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 关闭地图" -ForegroundColor Green

# 定义要删除的微软内置应用包名关键词
$AppsToUninstall = @(
    "Microsoft.BingNews",       # 资讯 (新闻)
    "Microsoft.BingWeather",    # 天气
    "Microsoft.BingFinance",    # 财经 (金融)
    "Microsoft.BingSports"      # 体育
    "Microsoft.People"          # 人脉
    "Microsoft.MixedReality.Portal",     # 混合现实
    "Microsoft.WindowsFeedbackHub",      # 反馈中心
    "Microsoft.GetHelp",                 # 获取帮助
    "Microsoft.Getstarted",              # Tips 入门指南
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftConsumerExperience",
    "Microsoft.WindowsMaps"              # Windows 地图
)

Write-Host "[+] 正在从当前用户中卸载相关应用..." -ForegroundColor Cyan
foreach ($App in $AppsToUninstall) {
    # 从当前用户卸载
    Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue

    # 从系统预装列表(映像)中移除，防止新用户创建或系统更新时自动装回
    Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -match $App} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

    Write-Host "    [+] 已移除: $App" -ForegroundColor Green
}

Stop-Process -Name "*PCManager*" -Force -ErrorAction SilentlyContinue
Get-AppxPackage -AllUsers *MicrosoftPCManager* | Remove-AppxPackage -ErrorAction SilentlyContinue



$DataCollectionPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
New-RegistryPath $DataCollectionPath
New-ItemProperty -Path $DataCollectionPath -Name "DoNotShowFeedbackNotifications"-Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 关闭 Windows 反馈弹窗与评估频率" -ForegroundColor Green


$AppPrivacyPath = "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy"
New-RegistryPath $AppPrivacyPath
New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsAccessMotion" -Value 2 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 禁止应用程序访问运动数据传感器" -ForegroundColor Green


# 应用隐私设置 (AppPrivacy)
$AppPrivacyPath = "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy"
New-RegistryPath $AppPrivacyPath

New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsGetDiagnosticInfo" -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsActivateWithVoice" -Value 2 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsActivateWithVoiceAboveLock" -Value 2 -PropertyType DWord -Force | Out-Null
Write-Host "[+]  已限制应用诊断信息获取与语音激活权限" -ForegroundColor Green



# 限制文本与墨迹（手写）输入数据收集 (InputPersonalization)
$InputPersPath = "HKCU:\Software\Microsoft\InputPersonalization"
New-RegistryPath $InputPersPath

New-ItemProperty -Path $InputPersPath -Name "RestrictImplicitTextCollection" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $InputPersPath -Name "RestrictImplicitInkCollection" -Value 1 -PropertyType DWord -Force | Out-Null
Write-Host "[+]  已限制文本及墨迹输入数据的隐式收集" -ForegroundColor Green



# 关闭 Windows 聚焦与云端内容推送 (CloudContent)
$CloudContentPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
New-RegistryPath $CloudContentPath

New-ItemProperty -Path $CloudContentPath -Name "DisableWindowsSpotlightFeatures" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $CloudContentPath -Name "DisableCloudOptimizedContent" -Value 1 -PropertyType DWord -Force | Out-Null
Write-Host "[+]  关闭 Windows 聚焦及云端个性化内容推送" -ForegroundColor Green


# 传递优化与设置下载限制 (DeliveryOptimization & DataCollection)
$DOPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
New-RegistryPath $DOPath
New-ItemProperty -Path $DOPath -Name "DODownloadMode" -Value 99 -PropertyType DWord -Force | Out-Null

$DataCollPath = "HKLM:\Software\Policies\Microsoft\Windows\DataCollection"
New-RegistryPath $DataCollPath
New-ItemProperty -Path $DataCollPath -Name "DisableOneSettingsDownloads" -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "[+]  已限制传递优化下载模式并禁止 OneSettings 乱下配置" -ForegroundColor Green

# Edge 隐藏遥测
$EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
New-RegistryPath $EdgePolicyPath
New-ItemProperty -Path $EdgePolicyPath -Name "MetricsReportingEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $EdgePolicyPath -Name "PersonalizationReportingEnabled" -Value 0 -PropertyType DWord -Force | Out-Null

# 全局广告标识符
$AdvPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
New-RegistryPath $AdvPath
New-ItemProperty -Path $AdvPath -Name "Enabled" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+]  关闭全局广告标识符" -ForegroundColor Green


# =================【重大安全增强：重构 NCSI 防止假断网】=================
# 强行关闭 NlaSvc 会导致系统误判断网。我们不关闭它，而是把它的探测目标修改为其他服务器。
# networkcheck.kde.org
# nmcheck.gnome.org
# detectportal.firefox.com/success.txt
# 定义 NCSI 注册表路径
$NcsiPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
New-RegistryPath $NcsiPath
# 2. 启用主动探测（确保功能未被关闭）
New-ItemProperty -Path $NcsiPath -Name "EnableActiveProbing" -Value 1 -PropertyType DWord -Force | Out-Null

# 3. 配置 HTTP 探测（改用苹果的服务器、路径和预期内容）
New-ItemProperty -Path $NcsiPath -Name "ActiveWebProbeHost" -Value "captive.apple.com" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $NcsiPath -Name "ActiveWebProbePath" -Value "hotspot-detect.html" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $NcsiPath -Name "ActiveWebProbeContent" -Value "<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>" -PropertyType String -Force | Out-Null

# 4. 配置 HTTPS 探测（部分新版 Windows 会同时检测 HTTPS）
New-ItemProperty -Path $NcsiPath -Name "ActiveWebProbeHostV6" -Value "captive.apple.com" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $NcsiPath -Name "ActiveWebProbePathV6" -Value "hotspot-detect.html" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $NcsiPath -Name "ActiveWebProbeContentV6" -Value "<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>" -PropertyType String -Force | Out-Null

# 5. 配置 DNS 探测（苹果没有公开对应的固定的、像微软那样的解析验证，这里将其指向苹果官网域名以保持稳定）
New-ItemProperty -Path $NcsiPath -Name "ActiveDnsProbeHost" -Value "time.apple.com" -PropertyType String -Force | Out-Null
# 注意：因为 www.apple.com 的 IP 会根据 CDN 变动，故清空内容验证，只验证域名能成功解析即可
New-ItemProperty -Path $NcsiPath -Name "ActiveDnsProbeContent" -Value "" -PropertyType String -Force | Out-Null

New-ItemProperty -Path $NcsiPath -Name "ActiveDnsProbeHostV6" -Value "time.apple.com" -PropertyType String -Force | Out-Null
New-ItemProperty -Path $NcsiPath -Name "ActiveDnsProbeContentV6" -Value "" -PropertyType String -Force | Out-Null

New-ItemProperty -Path $NcsiPath -Name "CaptivePortalHost" -Value "captive.apple.com" -PropertyType String -Force | Out-Null


# 禁用断网或需要认证时的自动网页弹窗（关键步骤：彻底解决 msftconnecttest 弹窗）
#$Path = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"
#New-ItemProperty -Path $Path -Name "EnableActiveProbing" -Value 0 -PropertyType DWord  -Force | Out-Null

$PolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator"
New-RegistryPath $PolicyPath
New-ItemProperty -Path $PolicyPath -Name "NoActiveProbe" -Value 0 -PropertyType DWord  -Force | Out-Null

# =========================================================================

# 关闭网络主动连接探测 (NCSI) 防止泄漏公网 IP 轨迹
#New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" -Name "EnableActiveProbing" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "正在将 Windows 时间服务器 (NTP) 切换为苹果 (Apple) 官方源..." -ForegroundColor Cyan
Write-Host "--------------------------------------------------" -ForegroundColor Gray

# 2. 定义苹果的时间服务器列表
# 0x01 代表客户端模式 (Client Mode)，能更好地兼容企业和家庭网络环境
$AppleNtpServers = "time.apple.com,0x01 time.asia.apple.com,0x01 time1.apple.com,0x01 time2.apple.com,0x01"

# 3. 写入注册表配置
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "NtpServer" -Value $AppleNtpServers -PropertyType String  -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NTP" -PropertyType String  -Force | Out-Null

# 4. 优化同步频率
$NtpClientPath = "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient"
New-ItemProperty -Path $NtpClientPath -Name "SpecialPollInterval" -Value 259200 -PropertyType DWord  -Force | Out-Null

# 5. 重启时间服务并强制即时同步
Write-Host "正在重启 Windows Time 服务并强制触发同步..." -ForegroundColor Yellow

# 触发即时同步命令
Restart-Service -Name "W32Time" -Force
Start-Sleep -Seconds 3
Restart-Service w32time -Force
Start-Sleep -Seconds 3
w32tm /resync
Start-Sleep -Seconds 3

# ==============================================================================
# 方案：通过策略彻底禁止 Bing 搜索和云端内容
# ==============================================================================
$SearchPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
New-RegistryPath $SearchPolicyPath

# 1. 禁用 Bing 搜索结果（最关键的一项）
New-ItemProperty -Path $SearchPolicyPath -Name "ConnectedSearchUseBing" -Value 0 -PropertyType DWord -Force | Out-Null

# 2. 禁止通过网络获取云端内容（如 SharePoint 和 OneDrive 联机搜索）
New-ItemProperty -Path $SearchPolicyPath -Name "AllowCloudSearch" -Value 0 -PropertyType DWord -Force | Out-Null


# ==============================================================================
# 方案：补充当前用户的搜索隐私限制（双重保险）
# ==============================================================================
$SearchUserPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
New-RegistryPath $SearchUserPath

# 1. 关闭 Bing 搜索栏
New-ItemProperty -Path $SearchUserPath -Name "BingSearchEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
# 2. 拒绝在搜索中提供网络上的"合规性/建议"内容
New-ItemProperty -Path $SearchUserPath -Name "CortanaConsent" -Value 0 -PropertyType DWord -Force | Out-Null


$DataCollectionPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
New-RegistryPath $DataCollectionPath

# 创建并设置 AllowTelemetry 为 0 (REG_DWORD)
New-ItemProperty -Path $DataCollectionPath -Name "AllowTelemetry" -Value 0 -PropertyType DWord -Force | Out-Null
Write-Host "[+] 已彻底关闭系统遥测与隐私数据收集" -ForegroundColor Green

$PreviewBuildsPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds"
New-RegistryPath $PreviewBuildsPath

# 创建并设置 AllowBuildPreview 为 0 (REG_DWORD)
New-ItemProperty -Path $PreviewBuildsPath -Name "AllowBuildPreview" -Value 0 -PropertyType DWord -Force | Out-Null
Write-Host "[+] 已彻底禁用 Windows 预览体验更新接收" -ForegroundColor Green


# ==============================================================================
# 2. 配置 Device Metadata (禁止从网络下载设备元数据)
# ==============================================================================
$DeviceMetadataPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata"
New-RegistryPath $DeviceMetadataPath

# 创建并设置 PreventDeviceMetadataFromNetwork 为 1 (REG_DWORD)
New-ItemProperty -Path $DeviceMetadataPath -Name "PreventDeviceMetadataFromNetwork" -Value 1 -PropertyType DWord -Force | Out-Null
Write-Host "[+] 已禁止系统从网络自动下载设备元数据" -ForegroundColor Green

# ==============================================================================


$CloudPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
New-RegistryPath $CloudPolicyPath

# 禁用基于诊断数据的定制体验 (1 = 禁用)
New-ItemProperty -Path $CloudPolicyPath -Name "DisableTailoredExperiences" -Value 1 -PropertyType DWord -Force | Out-Null
Write-Host "[+] 已在全局策略中禁用基于遥测数据的个性化定制" -ForegroundColor Green

$FindMyDevicePath = "HKLM:\SOFTWARE\Policies\Microsoft\FindMyDevice"
$ValueName = "AllowFindMyDevice"

# 2. 确保路径存在（如果 FindMyDevice 文件夹不存在则自动创建）
New-RegistryPath $FindMyDevicePath

# 3. 创建或修改 AllowFindMyDevice 值为 0 (REG_DWORD)
New-ItemProperty -Path $FindMyDevicePath -Name $ValueName -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 已彻底禁用查找我的设备功能" -ForegroundColor Green

$AppPrivacyPath = "HKLM:\Software\Policies\Microsoft\Windows\AppPrivacy"
New-RegistryPath $AppPrivacyPath
New-ItemProperty -Path $AppPrivacyPath -Name "LetAppsAccessLocation" -Value 3 -PropertyType DWord -Force | Out-Null

# ==============================================================================
# 2. 用户层：修改当前用户的隐私偏好设置 (双重保险)
# ==============================================================================
$UserPrivacyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
New-RegistryPath $UserPrivacyPath

# 将 TailoredExperiencesAllowed（允许定制体验）设置为 0（关闭）
New-ItemProperty -Path $UserPrivacyPath -Name "TailoredExperiencesAllowed" -Value 0 -PropertyType DWord -Force | Out-Null
Write-Host "[+] 已关闭当前用户的定制体验权限" -ForegroundColor Green
# ==============================================================================
# 5. 重启资源管理器以立即生效
# ==============================================================================

$path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsAI"
New-RegistryPath $path

New-ItemProperty -Path $path -Name "DisableAIDataAnalysis" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path $path -Name "AllowRecallEnablement" -PropertyType DWord -Value 0 -Force | Out-Null

Write-Host "[+] 禁用 Windows Recall / AI Capture 功能" -ForegroundColor Yellow


$policies = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot",
    "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
)

foreach($p in $policies){
    New-RegistryPath $p
    New-ItemProperty -Path $p -Name "TurnOffWindowsCopilot" -PropertyType DWord -Value 1 -Force | Out-Null
}

Write-Host "[+] 禁用 Windows Copilot" -ForegroundColor Yellow


$path = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
New-RegistryPath $path

# 保留系统 DoH 支持，不强制关闭
New-ItemProperty -Path $path -Name "EnableAutoDoh" -PropertyType DWord -Value 2 -Force | Out-Null

Write-Host "[+] 配置 DNS over HTTPS 策略" -ForegroundColor Yellow


$keys=@(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
)

foreach($k in $keys){
    if(Test-Path $k){
        New-ItemProperty $k -Name "SubscribedContent-338388Enabled" -Value 0 -PropertyType DWord -Force | Out-Null
        New-ItemProperty $k -Name "SubscribedContent-353694Enabled" -Value 0 -PropertyType DWord -Force | Out-Null
        New-ItemProperty $k -Name "ShowSyncProviderNotifications" -Value 0 -PropertyType DWord -Force | Out-Null
    }
}
Write-Host "[+] 禁用设置画面中的推荐广告" -ForegroundColor Yellow
Write-Host "[+] 禁用小组件、开始菜单或锁屏界面上的广告内容" -ForegroundColor Yellow
Write-Host "[+] 禁用文件资源管理器里的同步提供程序通知" -ForegroundColor Yellow



# 禁用文件资源管理器和开始菜单的搜索框 Web 建议 (组策略对应的注册表项)
$PoliciesPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
New-RegistryPath $PoliciesPath
New-ItemProperty -Path $PoliciesPath -Name "DisableSearchBoxSuggestions" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 禁用文件资源管理器和开始菜单的搜索框 Web 建议 (组策略对应的注册表项)" -ForegroundColor Yellow

# 禁用系统全局 Web 搜索 (本地计算机策略)
$SystemSearchPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
New-RegistryPath $SystemSearchPath
New-ItemProperty -Path $SystemSearchPath -Name "DisableWebSearch" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $SystemSearchPath -Name "ConnectedSearchUseWeb" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 已写入注册表：已禁用所有 Bing 网页搜索和建议。" -ForegroundColor Green

# 解决 F1 键自动弹出 HelpPane 网页的问题
# 通过映像劫持 (Image File Execution Options)，让系统在试图启动 HelpPane.exe 时直接拦截，不占用任何资源
# $IfeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\HelpPane.exe"
# New-RegistryPath $IfeoPath
# New-ItemProperty -Path $IfeoPath -Name "Debugger" -Value "systray.exe" -PropertyType String -Force | Out-Null

# Write-Host "[*] 禁用F1 键自动弹出 HelpPane 网页的问题" -ForegroundColor Yellow
# 有问题 暂时取消 会卡死


$CDMPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
New-RegistryPath $CDMPath

$CDMValues = @{
    "SubscribedContent-314563Enabled" = 0  # 禁用应用程序内的 Web 建议内容
    "SubscribedContent-338393Enabled" = 0  # 禁用系统设置应用内的 Web 建议内容
    "SubscribedContent-353694Enabled" = 0  # 禁用设置中的“结束设备设置以全面体验”提示
    "SubscribedContent-353696Enabled" = 0  # 禁用 Windows 欢迎体验和新功能介绍
    "SubscribedContent-310093Enabled" = 0  # 禁用任务栏上的 Web 提示/建议
    "SubscribedContent-338389Enabled" = 0  # 禁用开始菜单中的 Web 建议应用推荐
    "SubscribedContent-338387Enabled" = 0  # 禁用锁屏界面上的 Web 聚焦/小贴士和建议
    "SubscribedContent-338388Enabled" = 0  # 禁用进入桌面时的全屏建议弹窗
    "SystemPaneSuggestionsEnabled"    = 0  # 禁用系统面板上的网络建议
    "SilentInstalledAppsEnabled"      = 0  # 阻止系统后台自动静默安装推广应用
    "SoftLandingEnabled"              = 0  # 禁用向导中的 Web 帮助提示
    "PreInstalledAppsEnabled"         = 0  # 禁用预装的促销应用内容
}

foreach ($item in $CDMValues.GetEnumerator()) {
    New-ItemProperty -Path $CDMPath -Name $item.Name -Value $item.Value -PropertyType DWord -Force | Out-Null
}

Write-Host "[+] 系统设置的web建议与帮助" -ForegroundColor Yellow

## www.bing.com/RelatedSearch?addfeaturesnoexpansion=relatedsearch
## 系统设置的 web建议 会访问这个接口 cookie里面带有 GUID 等设备ID 暂无直接解决办法
# 彻底屏蔽 bing.com 防火墙禁止系统设置联网 AdGuard windows 拉黑这个接口



#  禁用【系统通知】中的使用技巧和 Web 建议
$NotificationPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings"
New-RegistryPath $NotificationPath
New-ItemProperty -Path $NotificationPath -Name "NCSIPermitted" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 禁用【系统通知】中的使用技巧和 Web 建议" -ForegroundColor Green

# 禁用“设置”主页顶部的账户横幅中的广告和提示（如果有）
$CloudPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
New-RegistryPath $CloudPath
New-ItemProperty -Path $CloudPath -Name "UserProfileEngagementEnabled" -Value 0 -PropertyType DWord -Force | Out-Null

Write-Host "[+] 已关闭设置面板中的所有建议与推荐内容开关。" -ForegroundColor Green


$path="HKLM:\SOFTWARE\Policies\Microsoft\Edge"
New-RegistryPath $path

$items=@{
    "ShowRecommendationsEnabled"=0
    "PersonalizationReportingEnabled"=0
    "ShoppingAssistantEnabled"=0
    "EdgeShoppingAssistantEnabled"=0
}

foreach($i in $items.Keys){
    New-ItemProperty $path -Name $i -Value $items[$i] -PropertyType DWord -Force | Out-Null
}


New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowOnlineTips" -PropertyType DWord -Value 0 -Force | Out-Null

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "EnableDynamicContentInWSB"  -PropertyType DWord -Value 0 -Force | Out-Null

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -PropertyType DWord -Value 1 -Force | Out-Null


Write-Host "[+] 禁用 Edge 的推荐和广告" -ForegroundColor Yellow
Write-Host "[+] 禁用个性化数据上报" -ForegroundColor Yellow
Write-Host "[+] 禁用内置的购物助手和自动优惠券功能" -ForegroundColor Yellow

# 1. 封锁 .NET 遥测
$env:DOTNET_CLI_TELEMETRY_OPTOUT=1
$env:DOTNET_NOLOGO=1



# 2. 封锁 Microsoft Java 遥测
$env:MICROSOFT_JPN_TELEMETRY_OPTOUT=1

# 3. 封锁 Gradle 统计收集
$gradleDir = "$env:USERPROFILE\.gradle"
if (-not (Test-Path $gradleDir)) { New-Item -ItemType Directory -Path $gradleDir -Force | Out-Null }
"org.gradle.usage.stats.enabled=false" | Out-File -FilePath "$gradleDir\gradle.properties" -Encoding ascii -Append


$telemetryEnvs = @{
    # .NET / C# / .NET SDK / .NET CLI
    "DOTNET_CLI_TELEMETRY_OPTOUT"      = "1"
    "DOTNET_NOLOGO"                    = "true"

    # PowerShell (pwsh 7+)
    "POWERSHELL_TELEMETRY_OPTOUT"     = "1"

    # Python (针对 pip 及常见遥测框架如 HuggingFace / Analytics)
    "PIP_NO_INPUT"                     = "1"
    "DO_NOT_TRACK"                     = "1"
    "HF_HUB_DISABLE_TELEMETRY"         = "1"

    # Go (Golang 1.21+ 引入的 telemetry)
    "GOTELEMETRY"                      = "off"

    # Rust (Cargo 构建工具及底层分析)
    "CARGO_NET_GIT_FETCH_WITH_CLI"     = "true" # 强制使用本地 CLI 避开内置网络采集

    # Java (无标准全局环境变量，但常用工具链依赖此通用标记)
    # 注：Java 本身无遥测，但 Gradle/Maven 等工具遵循 DO_NOT_TRACK
    "MICROSOFT_JPN_TELEMETRY_OPTOUT"   = "1"

    # PHP (PHP 核心无遥测，Composer 包管理器禁用遥测/提示)
    "COMPOSER_DISABLE_XDEBUG_WARN"     = "1"
    "ANONYMIZED_TELEMETRY"             = "false"
    "GRADLE_ENTERPRISE_INJECTION_DISABLE" = "true"
}

# 遍历并写入系统的 User 和 Machine 环境变量中
foreach ($key in $telemetryEnvs.Keys) {
    $val = $telemetryEnvs[$key]
    [System.Environment]::SetEnvironmentVariable($key, $val, 'User')
    [System.Environment]::SetEnvironmentVariable($key, $val, 'Machine')
}

go telemetry local

Write-Host "[成功] .NET、Microsoft JDK、Gradle 的数据外流渠道已被全部掐断！" -ForegroundColor Green

# -------------------------------
# 软件检测
# -------------------------------
$Software=@{
 Edge = Test-Path "${env:ProgramFiles(x86)}\Microsoft\Edge"
 Chrome = Test-Path "${env:ProgramFiles}\Google\Chrome"
 Firefox = Test-Path "${env:ProgramFiles}\Mozilla Firefox"
 VSCode = Test-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code"
}



# -------------------------------
# 浏览器策略
# -------------------------------

if($Software.Edge){

    New-Item `
    "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
    -Force | Out-Null

    New-ItemProperty `
    "HKLM:\SOFTWARE\Policies\Microsoft\Edge" `
    -Name MetricsReportingEnabled `
    -Value 0 `
    -PropertyType DWord `
    -Force | Out-Null
}


if($Software.Chrome){

    New-Item `
    "HKLM:\SOFTWARE\Policies\Google\Chrome" `
    -Force | Out-Null

    New-ItemProperty `
    "HKLM:\SOFTWARE\Policies\Google\Chrome" `
    -Name MetricsReportingEnabled `
    -Value 0 `
    -PropertyType DWord `
    -Force | Out-Null
}


if($Software.Firefox) {
    $dir="$env:ProgramFiles\Mozilla Firefox\distribution"
    if(Test-Path "$env:ProgramFiles\Mozilla Firefox"){
        New-Item $dir -ItemType Directory -Force | Out-Null
        @'
{
 "policies": {
   "DisableTelemetry": true,
   "DisableFirefoxStudies": true,
   "DisablePocket": true,
   "EnableTrackingProtection": {
      "Value": true,
      "Locked": false
   }
 }
}
'@ | Set-Content "$dir\policies.json" -Encoding UTF8
    }
}
Write-Host "浏览器简易策略调整完成" -ForegroundColor Green




Write-Host "NCSI主动探测已成功修改为苹果服务器！" -ForegroundColor Green
Write-Host "时间服务器已成功修改为苹果官方源！" -ForegroundColor Green
Write-Host "[提示] 系统此后将每 72 小时(3天) 自动与 time.apple.com 对齐一次时间" -ForegroundColor Yellow
Write-Host "注册表优化与底层隐私锁闭全部完成" -ForegroundColor Green
}


function Show-Help {
    Write-Host "./clean.ps1 host     - 对网站进行封禁" -ForegroundColor Green
    Write-Host "./clean.ps1 kserv - 对核心服务进行封禁" -ForegroundColor Green
    Write-Host "./clean.ps1 all      - 对网站和核心服务进行封禁" -ForegroundColor Green
    Write-Host "重置GDID 参考 https://github.com/gd03gd031/Windows-GDID-Changer" -ForegroundColor Green
    exit
}



switch ($FirstArg) {
    "host"     { New-hosts; break}
    "kserv" { New-killservices; break}
    "all"      { New-hosts; New-killservices; break}
    "h"        { Show-Help; exit;break}
    default    { Show-Help; exit;break}
}


# 重启系统设置服务使更改生效
Write-Host "正在刷新设置服务..." -ForegroundColor Yellow
Get-Process -Name "SystemSettings" -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "正在重启 Windows 资源管理器以应用设置..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force

# 刷新 DNS 缓存
ipconfig /flushdns | Out-Null
Clear-DnsClientCache
Write-Host "[+] DNS 缓存已成功刷新。" -ForegroundColor Green


Write-Host "`n====================================================" -ForegroundColor Cyan
Write-Host " 🎉 恭喜！融合增强版脚本顺利执行完毕！系统已进入极高隐私状态" -ForegroundColor Cyan
Write-Host "    (重要提示：请立即重启电脑，使底层受保护服务和网络探测规则彻底生效)  " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
