# GDID Windows Privacy & De-bloat Script

> **⚠️ WARNING / 声明**
> 本脚本为个人自用脚本，采取了**非常激进（Aggressive）**的策略来保护隐私和优化系统。由于其激进程度较高，可能会对某些系统功能、软件更新或微软官方服务的正常运行造成影响。请在充分了解脚本内容、具备一定系统排查能力的前提下**谨慎使用**！

---

## 概述 / Overview

本项目参考并借鉴了 [gdid-reversal](https://github.com/SmtimesIWndr/gdid-reversal) 的设计思路，旨在通过批处理/PowerShell脚本深度清理Windows系统中的冗余组件，全面封锁微软及第三方应用的数据收集与遥测（Telemetry）行为，打造一个更加干净、私密的个人操作系统环境。

数据已在它的数据库中,无法被选中

斩断的不是过去，而是曾经的自己

斩掉的只是心中的执念

Version:V1.0.8

---

## 脚本主要功能与措施

本脚本主要从以下几个维度对Windows系统进行了加固和精简：

### 1. 阻止微软隐私收集与遥测
* **禁用遥测服务 (Telemetry)**：关闭了 Diagnostic Tracking Service、Connected User Experiences and Telemetry 等后台数据收集服务。
* **屏蔽数据上传**：通过防火墙规则与Hosts文件拦截，阻止系统向微软分析服务器发送诊断数据、崩溃报告和用户行为习惯。
* **关闭广告与个性化推荐**：禁用Windows内置的推广通知、应用商店自动下载推广软件以及基于广告ID的追踪功能。

### 2. 禁用部分系统与后台服务
* **精简不必要的后台常驻服务**：根据自用习惯，关闭了部分日常开发和使用中完全用不到的Windows内置服务，释放内存与CPU开销。
* **阻止强制更新与助手**：对部分可能会偷偷唤醒、下载安装包的系统升级助手或推送机制进行了干预（请注意：这可能会影响常规的系统大版本升级）。

### 3. 网络与安全加固
* 清理并重置了部分网络协议栈，默认建立更严格的隐私边界。

---

## 推荐搭配使用的隐私/网络工具

为了达到更彻底的隐私保护效果，建议配合以下工具一起使用：

* **NetLimiter**：精细化控制每个应用程序的网络带宽，随时监控并拦截不明软件的联网请求。
* **AdGuard**：系统级的全平台广告拦截与隐私保护软件，能够过滤应用内广告及跟踪器。
* **AdGuard Home**：网络层的 DNS 拦截服务器（可部署在路由器或本地），在整个局域网级别屏蔽恶意域名、广告和遥测服务器。
* **uBlock Origin**：目前市面上最高效、最干净的浏览器扩展，强烈建议在所有浏览器中安装，用于拦截网页端广告、脚本和隐私追踪器。

---

## 封禁对象说明（概览）

本脚本在执行过程中，会针对以下方向实施拦截：

主要是微软的遥测 屏蔽了众多微软的域名

可能导致 Windows 部分功能受限

微软全家桶(微软账号 office Outlook OneDrive edge bing等)无法登录 云服务限制

针对 Google chrome firefox apple 部分 云服务遥测进行了限制

可能会导致 浏览器无法同步 更新

对Windows 的 网络连接状态指示器 (NCSI) 时间同步 修改成 apple源

不过 NCSI 作为win专属设置 会导致偶尔 右下角网络状态显示有问题 不过问题不大 禁用 再启用就好了

屏蔽了 bilibili vmware baidu csdn douyu xiaomi jd taobao aliyun douyin nvidia qq yy weixin kugou wangyi 360 等 遥测 广告 域名 可能会导致一些问题

不过还是保留了 bing翻译 win更新 一些的 没那么极端 全屏蔽了

不过 edge 和 bing 遥测太多了 没用习惯 还是不要用了



建议使用

AdGuard for Windows

https://www.osssr.com/7345.html

https://www.osssr.com/15789.html

https://www.52pojie.cn/thread-2058253-1-1.html

https://www.52pojie.cn/thread-1139887-1-1.html


Adguard home

[AdguardTeam/AdGuardHome: Network-wide ads & trackers blocking DNS server](https://github.com/AdguardTeam/AdGuardHome)


对DNS 和本地网络 更强的屏蔽

||bing.com/RelatedSearch^$app=SystemSettings.exe

||www.bing.com/RelatedSearch^$app=SystemSettings.exe

||cn.bing.com/RelatedSearch^$app=SystemSettings.exe

||api.bilibili.com/x/click-interface/click/web/h5^$xhr,domain=bilibili.com

||api.bilibili.com/x/web-frontend/data/report^$xhr,domain=bilibili.com

||api.bilibili.com/x/kv-frontend/namespace/data^$xhr,domain=bilibili.com

||api.bilibili.com/x/activity/subject/info^$xhr,domain=bilibili.com

||*.hdslb.com/bfs/polaris_web_conf/polaris/webcnf/event.cnf^$xhr,domain=bilibili.com

||bing.com/RelatedSearch^

||www.bing.com/RelatedSearch^

||cn.bing.com/RelatedSearch^

||login.live.com/ppsecure/deviceaddcredential.srf


这是我 AdGuard for Windows的一些规则



Adguard home 规则

anti-AD

https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-easylist.txt

adblockfilters

https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockdns.txt

dns-blocklists

https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt

秋风广告规则

https://raw.githubusercontent.com/TG-Twilight/AWAvenue-Ads-Rule/main/AWAvenue-Ads-Rule.txt

blacklist

https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt

WindowsSpyBlocker_extra

https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/refs/heads/master/data/hosts/extra.txt

WindowsSpyBlocker_spy

https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/refs/heads/master/data/hosts/spy.txt

WindowsSpyBlocker_update

https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/refs/heads/master/data/hosts/update.txt

adblockplus_easylist

https://easylist-downloads.adblockplus.org/easylist.txt

adblockplus_easylistchina

https://easylist-downloads.adblockplus.org/easylistchina.txt

AbBlock List

https://raw.githubusercontent.com/xndeye/adblock_list/refs/heads/release/easylist.txt

neodevhost

https://raw.githubusercontent.com/neodevpro/neodevhost/master/host

AdRules

https://raw.githubusercontent.com/Cats-Team/AdRules/main/dns.txt



Windows 系统设置 里面有一个 来着web的建议 也使用了

www.bing.com/RelatedSearch 这个接口 上传了 一些机器码 研究半天 暂时没找到关闭这个功能的方法

只能通过 屏蔽 bing 或者 禁止程序联网 进行解决使用 AdGuard for Windows(收费) 或者Zen 禁用 ( Zen 还是没AdGuard好用 差挺远的 就是AdGuard要收费 不过可以 刷180天试用 循环用



---

## 运行说明

./clean.ps1 host   - 对网站进行封禁

./clean.ps1 kserv - 对核心服务进行封禁

./clean.ps1 all    - 对网站和核心服务进行封禁

 重置GDID 参考 https://github.com/gd03gd031/Windows-GDID-Changer

建议

运行本脚本 全屏蔽了 隔段时间重置一下GDID

虚拟机可先不联网 运行本脚本 先屏蔽 不让其上传数据

最好隔一段时间 删了虚拟机 重开一个

---

## 其他软件推荐

optimizerDuck

是免费开源的 Windows 优化工具。一键清除系统垃圾、禁用遥测、优化游戏性能、管理启动项，无需安装

https://github.com/itsfatduck/optimizerDuck

O&O ShutUp10++


是一个免费适用于 Windows 10 和 11 的隐私（反间谍）设置软件，在 Windows 中系统默认会打开一些手机隐私数据的设置，使用 O&O ShutUp10++ 您可以完全控制这些相关的隐私设置，可以方便的关闭相关隐私收集选项
https://www.mefcl.com/oosu10.html

W10Privacy

Windows 隐私设置工具

https://www.mefcl.com/w10privacy.html

WinScript

是一款轻便易用的工具，旨在提升和定制您的 Windows 体验。轻松移除臃肿软件，禁用遥测，提升Windows性能，批量安装你喜欢的应用，等等

https://github.com/flick9000/winscript


Optimizer

是一款开源免费 Windows 优化工具，可以在安装 Windows 系统后来进行调整优化。

https://github.com/hellzerg/optimizer

其他很多相似类型的
DoNotSpy

WindowsManager

GTweak

BoosterX

RyTuneX

ZyperWin++

等等

清理类的
privazer
官网:https://privazer.com/zc/index.php

privazer是一款多功能清理上网浏览痕迹工具，该工具内置深层扫描机制，可靠的对你的隐私数据加以清理并且不可恢复

默认设置是一次覆写 可以在高级设置中选多次覆写

R-Wipe & Clean

是一款由R-Tools Technology开发的数据擦除和系统优化工具

下载地址:https://www.osssr.com/15813.html

ASCOMP Secure Eraser

是一款专业的数据删除工具，旨在帮助用户彻底销毁文件、文件夹及磁盘分区，防止敏感信息被恢复。通过采用多种高级擦除算法

下载地址 https://www.osssr.com/17618.html

Macrorit Data Wiper

是一款专业的数据擦除工具，专为彻底清除存储设备上的敏感信息而设计

下载地址 https://www.osssr.com/16568.html

Privacy Eraser

Privacy Eraser (隐私橡皮擦) 是一个全功能于一身的隐私套件，通过清理所有的互联网历史轨迹和过去的电脑活动，保护您的隐私

https://www.mefcl.com/privacy-eraser.html

sdelete

是一个由微软提供的工具,用于安全地删除文件和擦除磁盘上的数据

下载地址 https://learn.microsoft.com/en-us/sysinternals/downloads/sdelete


Wise Care 365 Pro

是一款由WiseCleaner公司开发的系统优化和维护工具，主要面向Windows用户。它提供了包括注册表清理、磁盘清理、隐私保护、系统优化和启动项管理等一系列功能

https://www.mefcl.com/wise-care-365-pro.html

LightC

C盘智能清理

https://github.com/Chunyu33/light-c

VeraCrypt

https://www.ghxi.com/veracrypt.html

https://www.veracrypt.fr/en/Downloads.html

一般覆写一次就差不多了
不过传闻中 小道消息 机械盘 存在磁性残留 通过磁带回线反推历史写入数据 这种高端技术 只有大神级别人物 能恢复一点点数据出来
不过 闪存 固态  厂家有做OP预留空间(是指在SSD中预留一部分空间来进行擦除和重写操作,以提升固态硬盘的性能和寿命）一般预留在总空间的5% 7%的样子
这样就要对整个固态所有存储进行多次覆写 比较麻烦 不过有些固态可以安装厂家一些软件 对OP空间进行调整 直接删除OP空间 在进行多次覆写

一次 00 覆写 两次 随机覆写
全盘写三遍 基本大概没有任何办法 我是想不到还有什么办法(除开什么主控里面有额外的芯片储存了数据) 应该时间回溯 回到过去那个夏天 找到那个她 拿到最开始的
不行 硬盘砸碎 细细的磨成粉末 泡上可乐 晒干 倒上酒精 让火焰净化一切吧！
净化过去与未来 只修今生 斩断过去 断绝未来 做减成空 终成道果
愿理想闪耀如初 愿长剑锋芒如故


---

## 免责声明

本脚本及其中的所有修改、配置均基于作者个人需求编写。使用本脚本所带来的任何系统故障、软件不兼容、数据丢失或更新失败，均由使用者自行承担风险。建议在运行脚本前**完整备份重要数据**并**创建系统还原点**。
