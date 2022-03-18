# third_party_chromium

## 简介

Chromium是由Google主导开发的网页浏览器。以BSD许可证等多重自由版权发行并开放源代码，Chromium的开发可能早自2006年即开始。Chromium 是 Google 的Chrome浏览器背后的引擎，其目的是为了创建一个安全、稳定和快速的通用浏览器。
OpenHarmony web基于Chromium构建。

## 软件架构
软件架构说明

```
    -----------------------
    |      web组件         |
    -----------------------
    |        nweb          |
    -----------------------
    |        CEF           |
    -----------------------
    |      Chromium        |
    -----------------------
    |  OpenHarmony基础库   |
    -----------------------
```

 web组件：OpenHarmony的UI组件
 nweb：基于CEF构建的OpenHarmony web Native引擎
 CEF：CEF全称Chromium Embedded Framework，是一个基于Google Chromium 的开源项目
 Chromium： Chromium是一个由Google主导开发的网页浏览器。以BSD许可证等多重自由版权发行并开放源代码

## 目录

```
.
├── patch                      # 构建nweb，针对chromium修改的patch目录
```


## 使用说明

1.  执行init_chromium.sh，初始化源代码
2.  执行build.sh，编译源码


## 相关仓
ace_ace_engine

third_party_cef

web_webview

third_party_chromium

