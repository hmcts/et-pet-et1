function getNavigatorPlatform() {
	return navigator.platform;
}
function getNavigatorOsCpu() {
	if (!navigator.oscpu || typeof (navigator.oscpu) != "string")
		return "";
	return navigator.oscpu;
}
function getNavigatorUserAgent() {
	return navigator.userAgent;
}
function getNavigatorAppName() {
	return navigator.appName;
}
function getNavigatorAppVersion() {
	return navigator.appVersion;
}

function getNavigatorPluginFnames() {
	var nps = "";

	if (navigator.plugins == null || navigator.plugins.length == 0) {
		return nps;
	}

	for ( var i = 0; i < navigator.plugins.length; i++) {
		if (i != 0)
			nps += "|";
		nps += navigator.plugins[i].filename;
	}
	
	return nps;
}

function getNavigatorPluginDescs() {
	var nps = "";

	if (navigator.plugins == null || navigator.plugins.length == 0) {
		nps = addPluginDescForIe(nps, getAdobeReaderVerForIe());
		nps = addPluginDescForIe(nps, getFlashPlayerVerForIe());
		nps = addPluginDescForIe(nps, getQuickTimePlayerVerForIe());
		nps = addPluginDescForIe(nps, getRealPlayerVerForIe());
		nps = addPluginDescForIe(nps, getShockwavePlayerVerForIe());
		nps = addPluginDescForIe(nps, getWinMediaPlayerVerForIe());
	} else {
		for ( var i = 0; i < navigator.plugins.length; i++) {
			if (i != 0)
				nps += "|";
			nps += navigator.plugins[i].description;
		}
	}

	return nps;
}

// IE specifics for plugins
function addPluginDescForIe(sPluginDescs, sPluginDescToAdd) {
	if (sPluginDescToAdd.length > 0) {
		if (sPluginDescs.length > 0)
			sPluginDescs += "|";
		sPluginDescs += sPluginDescToAdd;
	}
	return sPluginDescs;
}

function getAdobeReaderVerForIe() {
	var isInstalled = false;
	var version = "";
	if (window.ActiveXObject) {
		var control = null;
		try {
			// AcroPDF.PDF is used by version 7 and later
			control = new ActiveXObject('AcroPDF.PDF');
		} catch (e) {
			// Do nothing
		}
		if (!control) {
			try {
				// PDF.PdfCtrl is used by version 6 and earlier
				control = new ActiveXObject('PDF.PdfCtrl');
			} catch (e) {
				return version;
			}
		}
		if (control) {
			isInstalled = true;
			version = control.GetVersions().split(',');
			version = version[0].split('=');
			version = "Adobe Reader " + parseFloat(version[1]);
		}
	} else {
		// Check navigator.plugins for "Adobe Acrobat" or "Adobe PDF Plug-in"*
	}
	return version;
}

function getFlashPlayerVerForIe() {
	var isInstalled = false;
	var version = "";
	if (window.ActiveXObject) {
		var control = null;
		try {
			control = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
		} catch (e) {
			return version;
		}
		if (control) {
			isInstalled = true;
			version = control.GetVariable('$version').substring(4);
			version = version.split(',');
			version = "Flash Player " + parseFloat(version[0] + '.' + version[1]);
		}
	} else {
		// Check navigator.plugins for "Shockwave Flash"
	}
	return version;
}

function getQuickTimePlayerVerForIe() {
	var isInstalled = false;
	var version = "";
	if (window.ActiveXObject) {
		var control = null;
		try {
			control = new ActiveXObject('QuickTime.QuickTime');
		} catch (e) {
			// Do nothing
		}
		if (control) {
			// In case QuickTimeCheckObject.QuickTimeCheck does not exist
			isInstalled = true;
		}
	
		try {
			// This generates a user prompt in Internet Explorer 7
			control = new ActiveXObject('QuickTimeCheckObject.QuickTimeCheck');
		} catch (e) {
			return version;
		}
		if (control) {
			// In case QuickTime.QuickTime does not exist
			isInstalled = true;
	
			// Get version
			version = control.QuickTimeVersion.toString(16); // Convert to hex
			version = version.substring(0, 1) + '.' + version.substring(1, 3);
			version = "QuickTime Player " + parseFloat(version);
		}
	} else {
		// Check navigator.plugins for "QuickTime Plug-in"
	}
	return version;
}

function getRealPlayerVerForIe() {
	var isInstalled = false;
	var version = "";
	if (window.ActiveXObject) {
		var definedControls = [
			'rmocx.RealPlayer G2 Control',
			'rmocx.RealPlayer G2 Control.1',
			'RealPlayer.RealPlayer(tm) ActiveX Control (32-bit)',
			'RealVideo.RealVideo(tm) ActiveX Control (32-bit)',
			'RealPlayer'
		];
	
		var control = null;
		for (var i = 0; i < definedControls.length; i++) {
			try {
				control = new ActiveXObject(definedControls[i]);
			} catch (e) {
				continue;
			}
			if (control) {
				break;
			}
		}
		if (control) {
			isInstalled = true;
			version = control.GetVersionInfo();
			version = "RealPlayer " + parseFloat(version);
		}
	} else {
		// Check navigator.plugins for "RealPlayer" and "RealPlayer Version"
	}
	return version;
}

function getShockwavePlayerVerForIe() {
	var isInstalled = false;
	var version = "";
	if (window.ActiveXObject) {
		var control = null;
		try {
			control = new ActiveXObject('SWCtl.SWCtl');
		} catch (e) {
			return version;
		}
		if (control) {
			isInstalled = true;
			version = control.ShockwaveVersion('').split('r');
			version = "Shockwave Player " + parseFloat(version[0]);
		}
	} else {
		// Check navigator.plugins for "Shockwave for Director"
	}
	return version;
}

function getWinMediaPlayerVerForIe() {
	var isInstalled = false;
	var version = "";
	if (window.ActiveXObject) {
		var control = null;
		try {
			control = new ActiveXObject('WMPlayer.OCX');
		} catch (e) {
			return version;
		}
		if (control) {
			isInstalled = true;
			version = "Windows Media Player " + control.versionInfo;
		}
	} else {
		// Check navigator.plugins for "Windows Media"--this also detects the Flip4Mac plugin
	}
	return version;
}
// End IE specifics
function getNavigatorMimeTypes() {
	if (navigator.mimeTypes == null || navigator.mimeTypes.length == 0)
		return "";
	var mts = "";
	for (var i = 0; i < navigator.mimeTypes.length; i++) {
		if (i != 0)
			mts += "|";
		mts += navigator.mimeTypes[i].type;
	}
	return mts;
}
function submitForm(sFormId, bFillHdJs) {
	if (bFillHdJs) {
		fillHdJs();
	}
	if (isJavaStsOk('submitForm("' + sFormId + '",' + bFillHdJs + ');')) {
		document.getElementById(sFormId).submit();
	}
}

function getCurDateTime() {
	var oDate = new Date();
	var iYear = oDate.getFullYear();
	var iMonth = oDate.getMonth() + 1;
	var iDay = oDate.getDate();
	var iHour = oDate.getHours();
	var iMin = oDate.getMinutes();
	var iSec = oDate.getSeconds();
	var iMilliSec = oDate.getMilliseconds();
	
	return iYear + '-' + iMonth + '-' + iDay + ' ' + iHour + ':' + iMin + ':' + iSec + '.' + iMilliSec;
}

function getJsVersion() {
	var res;
	
	if (typeof js_version != 'undefined')
	{
		res = js_version;
	} else
	{
		res = "N/A";
	}
	return res;
}

var g_commonHdAr;
var g_ieHdAr;

function fillHdFromMultiDimArHd(multiDimAr) {
	var oHd;
	
	for(var i= 0; i < multiDimAr[0].length; i++)
	{
		oHd = document.getElementById(multiDimAr[0][i]);
		if (oHd != null)
		{
			oHd.value = Base64.encode(eval(multiDimAr[1][i]) + "");
		} 
	}	
}

function getHdForDirectPostFromMultiDimArHd(multiDimAr) {
	var sRes, sSepParNameVal, sSepPar;
	var oHd;
	
	sRes = "";
	sSepParNameVal = "=";
	sSepPar = "&";
	for(var i= 0; i < multiDimAr[0].length; i++)
	{
		sRes += multiDimAr[2][i] + sSepParNameVal + Base64.encode(eval(multiDimAr[1][i]) + "");
		if (i != (multiDimAr[0].length - 1))
		{
			sRes += sSepPar;
		}
	}
	return sRes;
}

function createMultiDimArHd()
{
	var multiDimAr = new Array(3);
	multiDimAr[0] = new Array();
	multiDimAr[1] = new Array();
	multiDimAr[2] = new Array();
	
	return multiDimAr;
}

function addElInMultiDimArHd(multiDimAr, fldId, valToCalc, fldName)
{
	multiDimAr[0][multiDimAr[0].length] = fldId;
	multiDimAr[1][multiDimAr[1].length] = valToCalc;
	multiDimAr[2][multiDimAr[2].length] = fldName;
}

function getHdForDirectPost() {
	var sRes;
	fillMultiDimArHd();
	sRes = getHdForDirectPostFromMultiDimArHd(g_commonHdAr);

	if (isMSIE()) 
	{
		sRes += '&' + getHdForDirectPostFromMultiDimArHd(g_ieHdAr);
	}
	return sRes;
}

function fillMultiDimArHd()
{
	g_commonHdAr = createMultiDimArHd();
	addElInMultiDimArHd(g_commonHdAr, 'hdClientDateTime', 'getCurDateTime()', 'ClientDateTime');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsVersion', 'getJsVersion()', 'js_version');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsPlatform', 'getNavigatorPlatform()', 'js_platform');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsOscpu', 'getNavigatorOsCpu()', 'js_oscpu');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsUserAgent', 'getNavigatorUserAgent()', 'js_user_agent');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsAppname', 'getNavigatorAppName()', 'js_appname');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsAppversion', 'getNavigatorAppVersion()', 'js_appversion');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsPluginFnames', 'getNavigatorPluginFnames()', 'js_plugin_fnames');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsPluginDescs', 'getNavigatorPluginDescs()', 'js_plugin_descs');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsMimetypes', 'getNavigatorMimeTypes()', 'js_mimetypes');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsTzOffset', 'new Date().getTimezoneOffset()', 'js_tz_offset');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsScreenWidth', 'screen.width', 'js_screen_width');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsScreenHeight', 'screen.height', 'js_screen_height');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsScreenColorDepth', 'screen.colorDepth', 'js_screen_color_depth');
	addElInMultiDimArHd(g_commonHdAr, 'hdJsJavaVersion', 'javaVersion()', 'js_javaversion');
	if (isMSIE())
	{
		g_ieHdAr = createMultiDimArHd();

		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenUpdateInterval', 'screen.updateInterval', 'ie_screen_updateinterval');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenFontSmoothingEnabled', 'screen.fontSmoothingEnabled', 'ie_screen_fontsmoothingenabled');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenBufferDepth', 'screen.bufferDepth', 'ie_screen_bufferdepth');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenLogicalXDPI', 'screen.logicalXDPI', 'ie_screen_logicalxdpi');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenLogicalYDPI', 'screen.logicalYDPI', 'ie_screen_logicalydpi');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenDeviceXDPI', 'screen.deviceXDPI', 'ie_screen_devicexdpi');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeScreenDeviceYDPI', 'screen.deviceYDPI', 'ie_screen_deviceydpi');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeAddressBook', 'ieComponentVersion("{7790769C-0471-11D2-AF11-00C04FA35D02}")', 'ie_address_book');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeAolArtIfs', 'ieComponentVersion("{47F67D00-9E55-11D1-BAEF-00C04FC2D130}")', 'ie_aol_art_ifs');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeArTds', 'ieComponentVersion("{76C19B38-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_ar_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeZhSimpTds', 'ieComponentVersion("{76C19B34-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_zh_simp_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeZhTradTds', 'ieComponentVersion("{76C19B33-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_zh_trad_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeDynHtmlDataBinding', 'ieComponentVersion("{9381D8F2-0288-11D0-9501-00AA00B911A5}")', 'ie_dyn_html_data_binding');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeDirectAnimation', 'ieComponentVersion("{283807B5-2C60-11D0-A31D-00AA00B92C03}")', 'ie_directanimation');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeHeTds', 'ieComponentVersion("{76C19B36-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_he_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeInternetConnWizard', 'ieComponentVersion("{5A8D6EE0-3E18-11D0-821E-444553540000}")', 'ie_internet_conn_wizard');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWinIeBrowsingEnhancements', 'ieComponentVersion("{630B1DA0-B465-11D1-9948-00C04F98BBC9}")', 'ie_win_ie_browsing_enhancements');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeInternetExplorerHelp', 'ieComponentVersion("{45EA75A0-A269-11D1-B5BF-0000F8051515}")', 'ie_internet_explorer_help');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeJpTds', 'ieComponentVersion("{76C19B30-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_jp_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeKoTds', 'ieComponentVersion("{76C19B31-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_ko_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeLanguageAutoSelection', 'ieComponentVersion("{76C19B50-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_language_auto_selection');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeMacromediaFlash', 'ieComponentVersion("{D27CDB6E-AE6D-11CF-96B8-444553540000}")', 'ie_macromedia_flash');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeMacromediaShockwaveDirector', 'ieComponentVersion("{2A202491-F00D-11CF-87CC-0020AFEECF20}")', 'ie_macromedia_shockwave_director');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeMsnMessengerService', 'ieComponentVersion("{5945C046-LE7D-LLDL-BC44-00C04FD912BE}")', 'ie_msn_messenger_service');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWinMediaPlayer', 'ieComponentVersion("{22D6F312-B0F6-11D0-94AB-0080C74C7E95}")', 'ie_win_media_player');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeOfflineBrowsingPack', 'ieComponentVersion("{3AF36230-A269-11D1-B5BF-0000F8051515}")', 'ie_offline_browsing_pack');
		addElInMultiDimArHd(g_ieHdAr, 'hdIePanEuropeanTds', 'ieComponentVersion("{76C19B32-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_pan_european_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeThTds', 'ieComponentVersion("{76C19B35-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_th_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeUniscribe', 'ieComponentVersion("{3BF42070-B3B1-11D1-B5C5-0000F8051515}")', 'ie_uniscribe');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeVectorGraphicsRendering', 'ieComponentVersion("{10072CEC-8CC1-11D1-986E-00A0C955B42F}")', 'ie_vector_graphics_rendering');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeViTds', 'ieComponentVersion("{76C19B37-F0C8-11CF-87CC-0020AFEECF20}")', 'ie_vi_tds');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeMsVirtualMachine', 'ieComponentVersion("{08B0E5C0-4FCB-11CF-AAA5-00401C608500}")', 'ie_ms_virtual_machine');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeVbsSupport', 'ieComponentVersion("{4F645220-306D-11D2-995D-00C04F98BBC9}")', 'ie_vbs_support');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWebFolders', 'ieComponentVersion("{73FA19D0-2D75-11D2-995D-00C04F98BBC9}")', 'ie_web_folders');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeDirAnimJavaClasses', 'ieComponentVersion("{4F216970-C90C-11D1-B5C7-0000F8051515}")', 'ie_direct_anim_java_classes');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeDirShow', 'ieComponentVersion("{44BBA848-CC51-11CF-AAFA-00AA00B6015C}")', 'ie_direct_show');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWebBrowser', 'ieComponentVersion("{89820200-ECBD-11CF-8B85-00AA005B4383}")', 'ie_web_browser');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeClassesForJava', 'ieComponentVersion("{08B0E5C0-4FCB-11CF-AAA5-00401C608555}")', 'ie_classes_for_java');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeHelpEngine', 'ieComponentVersion("{DE5AED00-A4BF-11D1-9948-00C04F98BBC9}")', 'ie_help_engine');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeNetMeetingNT', 'ieComponentVersion("{44BBA842-CC51-11CF-AAFA-00AA00B6015B}")', 'ie_netmeeting_NT');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeOutlookExpress', 'ieComponentVersion("{44BBA840-CC51-11CF-AAFA-00AA00B6015C}")', 'ie_outlook_express');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeTaskScheduler', 'ieComponentVersion("{CC2A9BA0-3BDD-11D0-821E-444553540000}")', 'ie_task_scheduler');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeVrmlViewer', 'ieComponentVersion("{90A7533D-88FE-11D0-9DBE-0000C0411FC3}")', 'ie_vrml_viewer');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWallet', 'ieComponentVersion("{1CDEE860-E95B-11CF-B1B0-00AA00BBAD66}")', 'ie_wallet');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWinDeskUpdNT', 'ieComponentVersion("{89820200-ECBD-11CF-8B85-00AA005B4340}")', 'ie_win_desk_upd_nt');
		addElInMultiDimArHd(g_ieHdAr, 'hdIeWinMpRealNwSup', 'ieComponentVersion("{23064720-C4F8-11D1-994D-00C04F98BBC9}")', 'ie_win_mp_realnw_support');
	}
}

function fillHdJs() 
{
	fillMultiDimArHd();
	fillHdFromMultiDimArHd(g_commonHdAr);

	if (isMSIE()) 
	{
		fillHdFromMultiDimArHd(g_ieHdAr);
	}
}

function grabFocus() {
	// regain focus from Flash
	var nbEl = document.forms[0].elements.length;

	for (var i=0; i<nbEl; i++)
	{
		if (document.forms[0].elements[i].type=="text")
		{
			document.forms[0].elements[i].focus();
			break;
		}
	}
}
function javaStatus(sSts) {
	document.getElementById("hdJavaSts").value = 'end';
	//document.write('<p>Java status: ' + sSts + '</p>');
	//alert('Java status: ' + sSts);
}
function flashStatus(sSts) {
	//document.write('<p>Flash status: ' + sSts + '</p>');
	//alert('Flash status: ' + sSts);
}

function javaPostException(sMsg) {
	alert(sMsg);
}
function javaCaptureException(sMsg) {
	alert(sMsg);
}
function flashPostException(sMsg) {
	alert(sMsg);
}
function javaCapture(sCapture) {
	//alert('Java Capture');
	document.getElementById("hdJavaAllPars").value = sCapture;
}
function flashCapture(sCapture) {
	//alert('Flash Capture');
	document.getElementById("hdFlashAllPars").value = sCapture;
}	
var g_iWaitPer = 0;
var g_dStartSubmit = null;

function isJavaStsOk(sFctToCall){
	var bStsOk = false;
	var iMaxWaitPer = 4000;
	var dIntDate = null;
	var iIntToWait = 200;
	var oHdJavaSts = document.getElementById("hdJavaSts");
	var oHdJavaAllPars = document.getElementById("hdJavaAllPars");
	var iPos = -1;
	var sFormId = '';

	if ((oHdJavaSts != null) && (detectJava())) {
		if (g_dStartSubmit == null){
			g_dStartSubmit = new Date();
		}
		//if ((oHdJavaSts.value == 'begin') || (oHdJavaSts.value == 'end')) {
		//if ((oHdJavaSts.value == 'end')) {
		if (oHdJavaAllPars != null) {
			if ((oHdJavaAllPars.value != 'none'))
				bStsOk = true;
		} else {
			if ((oHdJavaSts.value == 'end'))
				bStsOk = true;
		}
		if (!bStsOk) {
			if (g_iWaitPer > iMaxWaitPer) {
				bStsOk = true;
			} else {
				var iPos = sFctToCall.indexOf('itself|', 0);
				if (iPos != -1) {
					sFormId = sFctToCall.substring(iPos + 7);
					sFctToCall = 'submitForm("' + sFormId + '", true);';
				}
				var tO = setTimeout(sFctToCall,iIntToWait);
			}
		}
		dIntDate = new Date();
		g_iWaitPer = dIntDate - g_dStartSubmit;
		if (bStsOk) {
			document.getElementById("hdJavaWaitPer").value = g_iWaitPer;
		}
	} else {
		bStsOk = true;
	}
	return bStsOk;
}

function isJavaStsOk2(){
	var bStsOk = false;
	var iMaxWaitPer = 10000;
	var dStartSubmit = new Date();
	var dInter;
	var iWaitPer = 0;
	var oHdJavaSts = document.getElementById("hdJavaSts");

	if (oHdJavaSts != null) {
		while (!bStsOk) {
			if (oHdJavaSts.value == 'begin') {
	//alert('Java status' + bStsOk);
				bStsOk = true;
			} else {
				waitDuring(500);
			}
			dInter = new Date();
			iWaitPer = dInter - dStartSubmit;
		//	alert(iWaitPer);
			if (iWaitPer > iMaxWaitPer)
				bStsOk = true;
		}
		document.getElementById("hdJavaWaitPer").value = iWaitPer;
	} else {
		bStsOk = true
	}
	return bStsOk;
}
function waitDuring(iMs) {
	var baseDate = new Date();
	var curDate = null;

	do { curDate = new Date(); }
	while(curDate - baseDate < iMs);
}
function isMSIE() {
	return navigator.userAgent.toUpperCase().indexOf('MSIE') != -1;
}
function ieComponentVersion(guid) {
	var res;
	
	res = "";
	if (typeof ie_cc != 'undefined')
	{
		if (ie_cc.isComponentInstalled(guid, "componentid"))
		{
			res = ie_cc.getComponentVersion(guid ,"componentid");
		}
	} else
	{
		res = "N/A";
	}
	return res;
}	
function probeActiveX(jre) {
	if (!ActiveXObject)
		return false;
	try {
		return (new ActiveXObject('JavaWebStart.isInstalled.' + jre + '.0.0') != null);
	} catch (exception) {
		return false;
	}
}
function probeMimeTypesForJava() {
	if (!navigator.mimeTypes)
		return null;
	var max_java_ver = parseFloat("0.0");
	for (var i = 0; i < navigator.mimeTypes.length; i++) {
		var java = navigator.mimeTypes[i].type.match(/^application\/x-java-applet\x3Bversion=(1\.8|1\.7|1\.6|1\.5|1\.4|1\.3)$/);
		if (java != null) {
			var java_ver = parseFloat(java[1]);
			if (java_ver > max_java_ver)
				max_java_ver = java_ver;
		}
	}
	if (max_java_ver == 0)
		return null;
	return "" + max_java_ver;
}
function detectJava() {
	if (isMSIE()) {
		if (probeActiveX('1.8'))
			return true;
		else if (probeActiveX('1.7'))
			return true;
		else if (probeActiveX('1.6'))
			return true;
		else if (probeActiveX('1.5'))
			return true;
		else
			return false;
	} else
		return probeMimeTypesForJava() != null;
}
function javaVersion() {
	if (isMSIE()) {
		if (probeActiveX('1.8'))
			return "1.8";
		else if (probeActiveX('1.7'))
			return "1.7";
		else if (probeActiveX('1.6'))
			return "1.6";
		else if (probeActiveX('1.5'))
			return "1.5";
		else
			return null;
	} else
		return probeMimeTypesForJava();
}
