import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

function getChildrenOf(movie)
{
	var ret = [];
	for(i in movie)
	{
		var ch = movie[i];
		if(ch instanceof MovieClip)
		{
			ret.push(ch);
		}
	}	
	return ret;
}

var g_MainUI = _root.main_ui;
var g_CircleUI = _root.circle_ui;

//cs functions
this.onLoad = function(){
	init();
}

function init()
{
	g_MainUI._visible = false;
	g_MainUI.btn_bg.onRelease = function()
	{
		//no click through
	}

	g_CircleUI._visible = false;
	g_CircleUI.circle._visible = false;
	g_CircleUI.btn_bg.onRelease = function()
	{
		//no click through
	}
}

function Show(pic)
{
	g_MainUI._visible = true;
	if(pic != undefined)
	{
		g_MainUI.bg_all.gotoAndStop(pic);
	}
}

function Hide()
{
	g_MainUI._visible = false;
}

function ShowCircle()
{
	g_CircleUI._visible = true;
}

function HideCircle()
{
	g_CircleUI._visible = false;
}



function SetPercent(percent)
{
	// TODO
}