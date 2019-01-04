var GATEWAY_ERROR = 
{
	ERROR_NORMAL_NOTICE : 1,
	ERROR_UNDER_MAINTENANCE : 2,
	ERROR_NET_ERROR : 3,
	ERROR_DOWNLOADING_FAILED : 4,
	ERROR_FORCE_UPDATE : 5
}

var g_mcLoadingBar = _root.loadingBar
var g_infoPopup = _root.pop_content
var g_curErrorType = 0

var b_isSplashLoading = false
var frakePercent = 0;
var FAKEPERCENT_TOTAL = 200;

var g_loadingInterval = null
var c_intervalTime = 30;
var cur_step = 0;
var delta_step = 2;
var g_isShowLoadingBar = false;

function initFlashObj()
{
	g_mcLoadingBar._visible = true
	g_infoPopup._visible = false
}

function ShowLoadingBarV2(b)
{
	g_mcLoadingBar._visible = b
	g_mcLoadingBar.gotoAndStop(1)

	g_mcLoadingBar.TxtLoadingTip._visible = false
	g_mcLoadingBar.TxtLoadingFrac._visible = false

	g_mcLoadingBar.TxtLoadingPercent.text = "0%"
}

function SetLoadingBarFull()
{
	g_mcLoadingBar.gotoAndStop(100)
	g_mcLoadingBar.TxtLoadingPercent.text = "100%"
}

function Init()
{
	initFlashObj()

	g_infoPopup.download.btn_restart.onRelease = function()
	{
		fscommand("FS_restartGame");
	}

	g_infoPopup.download.btn_download.onRelease = function()
	{
		fscommand("FS_downloadApp");
	}

	g_infoPopup.btn_contact_us.onRelease = function()
	{
		fscommand("FS_ContactUs");
	}
	g_infoPopup.btn_forum.onRelease = function()
	{
		fscommand("FS_Forum");
	}
	g_infoPopup.btn_facebook.onRelease = function()
	{
		fscommand("FS_facebook");
	}

	ShowLoadingBarV2(true)
}

function luafs_showErrorMenu(errorStr, errorType, errorCode, isShow)
{
	if(isShow)
	{
		g_infoPopup._visible = true
		g_infoPopup.gotoAndPlay("opening_ani")
	}
	else
	{
		g_infoPopup._visible = false
		return;
	}

	g_infoPopup.content_txt._visible = false;
	g_infoPopup.timeless._visible = false;
	g_infoPopup.download._visible = false;

	g_infoPopup.download.btn_restart._visible = false;
	g_infoPopup.download.btn_download._visible = false;

	var curPopup = undefined;

	if (errorType == GATEWAY_ERROR.ERROR_NORMAL_NOTICE)
	{
		curPopup = g_infoPopup.download;
		g_infoPopup.download._visible = true;
		g_infoPopup.download.btn_restart._visible = true;
	}
	else if(errorType == GATEWAY_ERROR.ERROR_UNDER_MAINTENANCE)
	{
		curPopup = g_infoPopup.timeless;
		g_infoPopup.timeless._visible = true;
	}
	else if(errorType == GATEWAY_ERROR.ERROR_NET_ERROR)
	{
		curPopup = g_infoPopup.download;
		g_infoPopup.download._visible = true;
		g_infoPopup.download.btn_restart._visible = true;	
	}
	else if(errorType == GATEWAY_ERROR.ERROR_DOWNLOADING_FAILED)
	{
		curPopup = g_infoPopup.download;
		g_infoPopup.download._visible = true;
		g_infoPopup.download.btn_restart._visible = true;
	}
	else if(errorType == GATEWAY_ERROR.ERROR_FORCE_UPDATE)
	{
		curPopup = g_infoPopup.download;
		g_infoPopup.download._visible = true;
		g_infoPopup.download.btn_download._visible = true;
	}

	g_curErrorType = errorType
	// g_infoPopup.content.noticeText.text = errorStr
	SetText(curPopup, errorStr)
}

function luafs_showUnderMaintenance(errorStr, errorType, maintenTime, errorCode, isShow)
{
	luafs_showErrorMenu(errorStr, errorType, errorCode, isShow)
	trace("maintenTime = " + maintenTime)
	g_infoPopup.timeless.countdown.countDownTime.text = maintenTime
}

function luafs_setMaintenanceTime(maintenTime)
{
	g_infoPopup.timeless.countdown.countDownTime.text = maintenTime
}

this.onLoad = function()
{
	Init();
}

function luafs_ShowProgressTipStr(str:String)
{
	g_isShowLoadingBar = true;
}

function luafs_SetLoadingPercent( percent:Number ,needFake :Boolean)	// 0 - 100
{
	if(needFake)
	{
		if(percent != 0 )
		{
			frakePercent = FAKEPERCENT_TOTAL;
		}

		if(frakePercent / FAKEPERCENT_TOTAL < percent / 100 )
		{	
			frakePercent = percent / 100 * FAKEPERCENT_TOTAL
		}
		percent =  Math.ceil((percent * g_mcLoadingBar._totalframes   + frakePercent)/(100 + FAKEPERCENT_TOTAL) * 100)	
	}
	var frame = Math.ceil(percent)
	if (frame < g_mcLoadingBar._currentframe)
	{
		frame = g_mcLoadingBar._currentframe
	}
	if(frame < 1)
	{
		frame = 1;
	}
	else if (frame > g_mcLoadingBar._totalframes)
	{
		frame = g_mcLoadingBar._totalframes
	}
	g_mcLoadingBar.gotoAndStop(frame)

	return frame + "";
}

function luafs_SetEnterGameLoadingPercent( percent:Number)	// 0 - 100
{	
	var frame = Math.ceil(percent)
	if(frame < 1)
	{
		frame = 1;
	}
	else if (frame > g_mcLoadingBar._totalframes)
	{
		frame = g_mcLoadingBar._totalframes;
	}
	//mcLoadingBar.gotoAndStop(frame)
	cur_step = frame;

	if(frame == g_mcLoadingBar._totalframes)
	{
		g_mcLoadingBar.gotoAndStop(frame);
	}

	g_isShowLoadingBar = true;
	StartLoadingBarInterval();

	return frame + "";
}

function StartLoadingBarInterval()
{
	if(g_loadingInterval == null)
	{
		g_loadingInterval = setInterval(UpdateBarAnimation, c_intervalTime);
	}
}

function luafs_SwitchLoadingBar(type:Number)//1-regular loading progress	2-dlc loading progress
{
	g_mcLoadingBar._visible = true;
	if (type == 1)
	{
		g_isShowLoadingBar = true;
		g_mcLoadingBar.TxtLoadingTip._visible = false;
		g_mcLoadingBar.TxtLoadingFrac._visible = false;
		g_mcLoadingBar.TxtLoadingPercent._visible = true;
	}
	else if (type == 2)
	{
		g_isShowLoadingBar = false;
		g_mcLoadingBar.TxtLoadingTip._visible = true;
		g_mcLoadingBar.TxtLoadingFrac._visible = true;
		g_mcLoadingBar.TxtLoadingPercent._visible = false;
	}
}

function lua2fs_SetDLCBar(singleProgress:Number, downloadingTaskNum:Number, totalTaskNum:Number, strRes:String)
{
	trace("singleProgress = " + singleProgress)
	trace("downloadingTaskNum = " + downloadingTaskNum)
	trace("totalTaskNum = " + totalTaskNum)
	trace("strRes = " + strRes)

	if (downloadingTaskNum <= totalTaskNum)
	{
		g_mcLoadingBar.gotoAndStop(Math.max(1, Math.ceil(singleProgress)));
		g_mcLoadingBar.TxtLoadingFrac.text = "(" + downloadingTaskNum + "/" + totalTaskNum + ")" 
	}
}

function UpdateBarAnimation()
{
	if(g_mcLoadingBar._currentFrame < cur_step)
	{
		if(g_mcLoadingBar._currentFrame + delta_step > g_mcLoadingBar._totalframes)
		{
			g_mcLoadingBar._currentFrame = g_mcLoadingBar._totalframes;
		}
		else
		{
			g_mcLoadingBar.gotoAndStop(g_mcLoadingBar._currentFrame + delta_step);
		}
	}

	if(g_isShowLoadingBar)
	{
		g_mcLoadingBar.TxtLoadingPercent.text = String(g_mcLoadingBar._currentFrame) + "%"
	}
}

function luafs_FinishLoading(  )
{
	g_isShowLoadingBar = false
}

function SetText(mc, contentTxt)
{
	var ViewList = mc.desc.ViewList;
	var item = ViewList.slideItem;
	var item2 = ViewList.slideItem2;
	var totalHeight = 0;
	var kDist = 5;

	for(var mc in item2)
	{
		item2[mc].removeMovieClip();
	}

	var txtItem = item2.attachMovie("content_txt", "txt_" + 0, item2.getNextHighestDepth());
	trace("txtItem: " + txtItem);
	txtItem.txt_content.htmlText = contentTxt;
	// trace("txtItem height: " + txtItem._height + "  textheight: " + txtItem.txt_content.textHeight);
	txtItem._y = totalHeight;
	totalHeight += (txtItem.txt_content.textHeight);
	// trace("txtItem height: " + txtItem._height + "  textheight: " + txtItem.txt_content.textHeight);

	item._height = totalHeight;

	// trace("SimpleSlideOnLoad: " + ViewList.SimpleSlideOnLoad);
	ViewList.SimpleSlideOnLoad();
	ViewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ViewList.forceCorrectPosition();
}