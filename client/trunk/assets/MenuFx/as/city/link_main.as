
var g_WeakNet = _root.weak_net;
var g_Reconnect = _root.reconnect;

this.onLoad = function()
{
	init();
}

function init()
{
	g_WeakNet._visible = false;
	g_Reconnect._visible = false;

	// ShowWeakNet(true);
	// ShowReconnect(true);
}

function ShowWeakNet(isShow)
{
	g_WeakNet._visible = isShow;
}

function ShowReconnect(isShow)
{
	g_Reconnect._visible = isShow;
	if(isShow)
	{
		g_Reconnect.bg.onRelease = function(){}
	}
	else
	{
		g_Reconnect.bg.onRelease = undefined;
	}
}