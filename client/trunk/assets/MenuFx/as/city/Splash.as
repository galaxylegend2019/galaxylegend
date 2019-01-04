

var k_txtDefaultColor = 0x000000;
var k_serverListCount = 10;
var g_mcLoadingBar = splash_barAll
var b_isSplashLoading = false
var frakePercent = 0;
var FAKEPERCENT_TOTAL = 200;

function SetShowServerList(isShow)
{
	for(var i = 1; i <= k_serverListCount; i++)
	{
		var mc = GetServerMc(i);
		mc._visible = isShow;
	}

	_root.ServerFun.Confirm._visible = isShow;
	_root.ServerFun.udid._visible = isShow;
	//Init();
}

function SetShowGotoChange(isShow)
{
	_root.ServerFun.GotoChange._visible = isShow;
	//Init();
}

function SetShowSkipTutorial(isShow)
{
	_root.ServerFun.SkipTutorial._visible = isShow;
}

function UnselectAllServer()
{
	for(var i = 1; i <= k_serverListCount; i++)
	{
		var mc = GetServerMc(i);
		mc.txt.textColor = k_txtDefaultColor;
	}
}

function SelectServer(serverIndex)
{
	UnselectAllServer();
	var mc = GetServerMc(serverIndex);
	mc.txt.textColor = 0xff00ff;
}

function SetPlay(isPlay)
{
	if(isPlay)
	{
		_root.splash.gotoAndPlay(1);
	}
	else
	{
		_root.splash.gotoAndStop(1);
	}
}

function GetServerMc(serverIndex)
{
	var endNum = serverIndex
	if(serverIndex <= 9)
	{
		endNum = "0" + serverIndex;
	}

	var mc = eval("_root.ServerFun.Sever" + endNum);
	return mc;
}

function SetUDID(udid)
{
	_root.ServerFun.udid.txt.text = udid;
}

function SetServerList(serverList)
{
	for(var i = 1; i <= k_serverListCount; i++)
	{
		var mc = GetServerMc(i);
		mc.txt.text = serverList[i - 1];
	}
}

function ShowLoadingBar(b)
{
	splash_barAll._visible = false; //TODO = b
	if(b == true)
	{
		splash_barAll.gotoAndPlay(1)
	}
	else
	{
		splash_barAll.gotoAndStop(1)
	}
}

function ShowLoadingBarV2(b)
{
	splash_barAll._visible = b

	{
		splash_barAll.gotoAndStop(1)
	}
}

function SetLoadingBarFull()
{
	splash_barAll.gotoAndStop(100)
	splash_barAll.TxtLoading1.text = "Loading..." + 100 + "%"
}

function Init()
{
	_root.All_Ui_Universal._visible = false;

	for(var i = 1; i <= k_serverListCount; i++)
	{
		var mc = GetServerMc(i);
		mc.onRelease = function()
		{
			// trace(this._name.substring(5, 7));
			fscommand("ChangeServer", this._name.substring(5, 7));
		}
	}

	_root.ServerFun.GotoChange.onRelease = function()
	{
		trace("_root.ServerFun.GotoChange.onRelease");
		fscommand("GotoSelectServer");
	}

	_root.ServerFun.Confirm.onRelease = function()
	{
		fscommand("ConfirmServer");
	}

	_root.ServerFun.SkipTutorial.onRelease = function()
	{
		fscommand("SkipTutorial")
	}
	ShowLoadingBar(true)



	var tipMenu = _root.All_Ui_Universal.UniversalDetail;
	tipMenu.btnContactUs.btnReleaseAnimStart = function()
	{
		fscommand("FS_ContactUs");
	}

	tipMenu.btnYes.btnReleaseAnimStart = function()
	{
		fscommand("FS_ERROR_OK", "" + _root.All_Ui_Universal.UniversalDetail.Code);
	}

	tipMenu.btnDownload.btnReleaseAnimStart = function()
	{
		fscommand("FS_ERROR_OK", "" + _root.All_Ui_Universal.UniversalDetail.Code);
	}
}

function showErrorMenu(errorStr, errorCode, isShow)
{
	if(isShow == undefined || isShow == null) {
		_root.All_Ui_Universal._visible = true;
	} else {
		_root.All_Ui_Universal._visible = isShow;
	}
	
	_root.All_Ui_Universal.gotoAndPlay("show");
	var tipMenu = _root.All_Ui_Universal.UniversalDetail;
	
	tipMenu._SLAC_TxtTitle.text = errorStr + " Code: " + errorCode;
	tipMenu.Code = errorCode;

	// trace(errorCode);
	if (errorCode == 2)
	{
		tipMenu.btnContactUs._visible = true;
		tipMenu.btnYes._visible = false;
		tipMenu.btnDownload._visible = true;
	}
	else
	{
		tipMenu.btnContactUs._visible = true;
		tipMenu.btnYes._visible = true;
		tipMenu.btnDownload._visible = false;
	}
}

this.onLoad = function()
{
	Init();
	SetShowGotoChange(false);
	SetShowServerList(false);
	SetShowSkipTutorial(false);

	if(false)
	{
		// SetShowGotoChange(false);
		// SetShowServerList(true);
		// //SetUDID("112312313213");
		// SelectServer(1);

		showErrorMenu("asdfasdf", 2, true);
	}
	SetLoadingState(true)
	//SetShowGotoChange(true);
	SetLoadingState(false)
}
splash_barAll.onEnterFrame = function()
{
	if(b_isSplashLoading)
	{
		var frame = splash_barAll._currentframe
		splash_barAll.TxtLoading1.text = "Loading..." + frame + "%"
	}
}

function showProgressTipStr(tip)
{
	splash_barAll.TxtLoading1.text = tip
}
function setGameSplashLoading(b)
{
	b_isSplashLoading = b
	if(b)
	{
		splash_barAll.gotoAndPlay(1)
	}
}
function setLoadingEnable(b)
{
	splash_barAll._visible = false; //TODO: b;
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
		percent =  Math.ceil((percent * splash_barAll._totalframes   + frakePercent)/(100 + FAKEPERCENT_TOTAL) * 100)	
	}
	var frame = Math.ceil(percent)
	if (frame < splash_barAll._currentframe)
	{
		frame = splash_barAll._currentframe
	}
	if(frame < 1)
	{
		frame = 1;
	}
	else if (frame > splash_barAll._totalframes)
	{
		frame = splash_barAll._totalframes
	}
	splash_barAll.gotoAndStop(frame)

	return frame + "";
}

function SetLoadingState(isFirst)
{
	if(isFirst)
	{
		splash._visible = false;
		splash_bg._visible = true;
		setLoadingEnable(false);
	}
	else
	{
		splash._visible = true;
		splash.gotoAndPlay(1);
		splash_bg._visible = false;
		setLoadingEnable(true);
	}
}
