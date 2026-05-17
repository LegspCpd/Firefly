---
title: 使用华为云制作优选域名
published: 2026-05-09
tags: [CloudFlare, CloudFlare优选, CloudFlare优选教程, 教程, Edgeone优选]
category: CloudFlare
draft: false
---
# 作者的优选域名
Edgeone：[https://eo.legspcpd.furry.bz/](https://eo.legspcpd.furry.bz/)
![](https://imghub.legspcpd.indevs.in/file/image/QQ20260509-110615.png)
Cloudflare: [https://cf.legspcpd.furry.bz/](https://cf.legspcpd.furry.bz/)
![](https://imghub.legspcpd.indevs.in/file/image/QQ20260509-110717.png)

---

## Cloudflare
可以去看我之前做的教程
[Cloudflare优选教程](https://blog.legspcpd.qzz.io/posts/cf-ys/)

---
## Edgeone
Edgeone的原理是差不多的，但这里推荐用华为云国际来优选

推荐以下IP

43.174.150.*

43.174.151.*

其实还有

43.174.130.*

43.174.131.*

43.174.132.*

这三个，但是基本上都会被ban

---
## 优选过程
打开[华为云](https://huaweicloud.com/)

注册一个账号，并把一个域名托管到上面

解析完之后，找到 ==云解析服务 DNS==>==公网域名==>你托管的域名
点 ==添加记录集== ，用A记录指向那四个IP
![](https://imghub.legspcpd.indevs.in/file/image/QQ20260509-111220.png)
按照这样来填，填完后点确定
这时候我们去测试
![](https://imghub.legspcpd.indevs.in/file/image/QQ20260509-111546.png)
解析出来了