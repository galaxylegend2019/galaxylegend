

var k_txtDefaultColor = 0x000000;
var k_serverListCount = 10;

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

function Init()
{
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

}

this.onLoad = function()
{
	Init();
	SetShowGotoChange(false);
	SetShowServerList(false);

	if(false)
	{
		SetShowGotoChange(false);
		SetShowServerList(true);
		//SetUDID("112312313213");
		SelectServer(1);
	}
	//SetShowGotoChange(true);

	_root.splash._visible = true
	SetPlay(true)
}






