# 潇然系统 Microsoft Office ISO 自动安装器

自动安装 Microsoft Office VL ISO 镜像并自动激活，支持 Microsoft Office 2007-最新版、MSI 和 C2R 类型、MSDN 原版和第三方升级版，具体支持的版本取决于配置文件（config 目录下的 xml 文件）。

## 脚本逻辑

1. 读取传入的参数文件信息或从 ISO 文件名中提取 Office 版本、版本号、架构和类型。
2. 读取系统版本和架构。
3. 判断系统版本和架构与安装程序是否匹配。
4. 判断系统版本是否支持指定的 Office 版本。
5. 挂载 Office ISO 文件到一个未使用的盘符。
6. 运行 Office 安装程序（根据安装类型选择 MSI 或 C2R）。
7. 卸载挂载的 ISO 文件。
8. 安装 SaveAsPDFandXPS 插件（仅适用于 Office 2007）。
9. 创建桌面快捷方式。
10. 对于 Office 2013，执行一些修复操作，如删除 SkyDrive 右键菜单、跳过首次引导程序等。
11. 解决 Office 2016 以前版本中文未知字体难看的问题。
12. 使用 KMS 激活 Office。
13. 输出安装完成消息。
14. 删除自身。

## 文件结构

config 文件夹：Office 自动安装配置文件，支持 MSI 和 C2R 两种类型

OSFMount 文件夹：PassMark OSFMount ISO 挂载组件
 - `OSFMount.com`或`OSFMount.exe`
 - `OSFMount.sys`

## 使用方法

### 1、将 MSDN 原版 Office 的 ISO 文件复制到此文件夹，将其按照以下格式重命名：

```
Office_年份版本号_大内部版本号_版本架构_版本类型.iso
```

- Office：不要动。

- 年份版本号：20XX，如`2007`、`2010`、`2013`、`2016`、`2019`、`2021LTSC`。

- 大内部版本号：必须严格填写，年份版本号对应的内核版本号，如2007对应`12`，2010对应`14`，2013对应15，2016-最新对应`16`。

- 版本架构：必须根据系统变量 `%PROCESSOR_ARCHITECTURE%` 严格填写，`x86`、`AMD64`、`ARM64`。

- 版本类型：必须严格填写，`MSI`、`C2R`，MSI为传统类型，应用于 Office发布-2016；C2R 为即点即用类型，应用于 Office 2010-最新；Office 2010-2016常见为 MSI，Office 2019及以后均为 C2R。


如：

```
Office_2007_12_x86_MSI.iso
Office_2010_14_x86_MSI.iso
Office_2010_14_AMD64_MSI.iso
Office_2013_15_x86_MSI.iso
Office_2013_15_AMD64_MSI.iso
Office_2016_16_x86_MSI.iso
Office_2016_16_AMD64_MSI.iso
Office_2019_16_x86_C2R.iso
Office_2019_16_AMD64_C2R.iso
Office_2021LTSC_16_x86_C2R.iso
Office_2021LTSC_16_AMD64_C2R.iso
Office_365_16_x86_C2R.iso
Office_365_16_AMD64_C2R.iso
```

### 2、将对应版本的配置文件复制到此文件夹下的 config 目录，将其按照以下格式重命名：

MSI 类型：

```
年份版本号_版本类型.xml
```

C2R 类型：

```
年份版本号_版本架构.xml
```

备注：由于 MSI 类型不包含版本架构，可以不分版本结构，C2R 类型为了提高稳定性，需要严格区分版本架构。

### 3、进桌面运行`MSOInst.bat`，安装后会自删。