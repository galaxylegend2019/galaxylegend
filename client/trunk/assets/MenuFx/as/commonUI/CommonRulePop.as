import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

var g_screenW = _root._width;
var g_screenH = _root._height;

// trace("g_screenW: " + g_screenW + " g_screenH: " + g_screenH);

var g_popRule = _root.pop_rule;

this.onLoad = function(){
	init();
}

function init()
{
	g_popRule._visible = false;
}


function ShowPopRule(info)
{
	var mc = g_popRule;
	if(mc)
	{
		mc._visible = true;
		mc.gotoAndPlay("opening_ani");
		mc.btn_shield.onRelease = function(){}
		mc.btn_bg.onRelease = function()
		{
			ClosePopDetail();
			this.onRelease = undefined;
		}
		InitFunc_pop_rule(mc, info);
	}
}

function ClosePopDetail()
{
	var mc = g_popRule;
	mc.OnMoveOutOver = function()
	{
		this._visible = false;
	}
	mc.gotoAndPlay("closing_ani");
}


function InitFunc_pop_rule(mc, info)
{
	var txts = info.descTxts;

	var ViewList = mc.desc.ViewList;
	var item = ViewList.slideItem;
	var item2 = ViewList.slideItem2;
	var totalHeight = 0;
	var kDist = 5;

	for(var mc in item2)
	{
		item2[mc].removeMovieClip();
	}

	for(var i = 0; i < txts.length; ++i)
	{
		var txt = txts[i];
		var txtItem = item2.attachMovie("Rule_info_txt", "txt_" + i, item2.getNextHighestDepth());
		txtItem.txt_Text.htmlText = txt;
		txtItem._y = totalHeight;
		totalHeight += (txtItem.txt_Text.textHeight);
	}

	item._height = totalHeight;

	ViewList.SimpleSlideOnLoad();
	ViewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ViewList.forceCorrectPosition();
}