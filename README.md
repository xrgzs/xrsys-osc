<div align="center">


<img src="./osc.ico" alt="xrosc" width="20%" />

# 潇然系统部署插件

</div>

潇然系统优化组件（XRSYSOSC，`osc.exe`）完成系统登录进入桌面后的各种优化操作，包括但不限于注册表优化、电源优化、软件安装等🌟🚀

📄[文档](https://sys.xrgzs.top/diy/osc/)

🔗[下载地址](https://url.xrgzs.top/osc)

📍**小提示：**潇然系统优化组件支持直接使用，这意味着您不需要安装潇然系统，只需运行`osc.exe`即可切换到最新版本的潇然系统

**🚨警告：**在使用潇然系统优化组件之前，**请务必进行备份浏览器里面的重要数据**，并最好将浏览器卸载。潇然系统优化组件会自动清空所有浏览器的数据

> 🌄图标来自：https://icons8.com/icons/fluency

---

以下内容可能已经过期，建议前往文档查看

`osc.exe`是一个SFX程序，目标路径：`C:\Windows\Setup\Set\osc`

`osc.exe`支持在第三方封装软件中调用，调用的方法非常简单，只需要在`进桌面`后无参数执行即可

`osc.exe`优化完成后，会自动重启系统

`osc.exe`一般可以随意存放直接运行，存放在 `C:\Windows\Setup\Set\osc.exe` 支持自动删除

如果要让潇然系统优化组件为潇然系统部署接口（XRSYSAPI，`api.exe`）提供`apifiles`，这种情况存放路径必须为`C:\Windows\Setup\Set\osc.exe`

> `api.exe` 需要调用到 `osc.exe` 内的相关文件，会创建 `Set\needoscapifiles.txt` 并运行 `osc.exe` 让其提供 `apifiles`
>
> 潇然系统优化的原则就是尽量不动组策略，提供给用户修改空间，因此大多数工作都是进桌面以后运行

**🫡使用到的项目：**

[7-zip](https://7-zip.org/)

[NSIS](https://nsis.sourceforge.io/)

[dmidecode](http://savannah.nongnu.org/projects/dmidecode/)

[nircmd](https://www.nirsoft.net/utils/nircmd.html)

[PECMD](http://wuyou.net/forum.php?mod=viewthread&tid=205402)

[Wbox](https://www.horstmuc.de/w32dial.htm)

[Winput](https://www.horstmuc.de/w32dial.htm)

[Curl](https://curl.se/)

[M2TeamArchived/NSudo](https://github.com/M2TeamArchived/NSudo)

[Windows Update Blocker](https://www.sordum.org/9470)

[stdin82/htfx](https://github.com/stdin82/htfx)

[abbodi1406/KMS_VL_ALL_AIO](https://github.com/abbodi1406/KMS_VL_ALL_AIO)

[zbezj/HEU_KMS_Activator](https://github.com/zbezj/HEU_KMS_Activator)

[Wind4/vlmcsd](https://github.com/Wind4/vlmcsd)

[q3aql/aria2-static-builds](https://gitlab.com/q3aql/aria2-static-builds)

