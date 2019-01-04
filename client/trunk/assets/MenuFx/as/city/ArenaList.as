import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

//history list
var g_historyRoot = _root.history;
var g_historyList = g_historyRoot.history_area.ViewList;
var g_startHistoryIndex = -1;
var g_endHistoryIndex = -1;

//bg
var g_BG = _root.bg;
var TopUI = _root.history.top;
var g_BackBtn = TopUI.btn_close;

//misc

//cs functions
this.onLoad = function(){
	init();
}

function init()
{
    g_historyRoot._visible = false;
	g_BG._visible = false;
}

//history functions
function move_in_history()
{
    g_BG._visible = true;
    g_BG.OnMoveInOver = function()
	{
	}
	g_BG.OnMoveOutOver = undefined;
	g_BG.gotoAndPlay("opening_ani");

    g_historyRoot._visible = true;
    g_historyRoot.OnMoveInOver = function()
	{
		trace("Move In Over");
		g_BackBtn.onRelease = function()
		{
			// fscommand("ExitBack", "");
			// trace("Back Clicked");
			move_out_history();
			g_historyRoot.OnMoveOutOver = function()
			{
				fscommand("ExitBack", "");
			}
			// fscommand("PlayMenuBack");
			fscommand("PlaySound", "sfx_ui_cancel");
		}
	}
	g_historyRoot.OnMoveOutOver = function()
	{
		// trace("History Move Out Over");
	}
	g_historyRoot.gotoAndPlay("opening_ani");
}

function move_out_history()
{
	g_BackBtn.onRelease = undefined;
	g_BG.gotoAndPlay("closing_ani");
	g_historyRoot.gotoAndPlay("closing_ani");
}

function InitHistory()
{
	InitHistoryList();
	move_in_history();
}

function InitHistoryList()
{
	g_startHistoryIndex = -1;
	g_endHistoryIndex = -1;
	var viewList = g_historyList;
	viewList.clearListBox();
	_root.all.history.history_area.bar._visible = false;
	viewList.initListBox("list_history", 5, true, true);
	viewList.enableDrag( true );
	// viewList.setAddEraseFactor(8, 8);
	viewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	viewList.onItemEnter = function(mc, itemKey)
	{
		fscommand("RequestArenaHistory", itemKey);
		if(itemKey - g_startHistoryIndex < 2)
		{
			fscommand("RequestArenaRefreshHistory", false);
		}
		if(g_endHistoryIndex - itemKey < 2)
		{
			fscommand("RequestArenaRefreshHistory", true);
		}
	}

	viewList.onItemMCCreate = undefined; //function(mc){}
	viewList.onListboxMove = undefined; //function(mc){}
}

function ResetHistoryList()
{
	InitHistoryList();
}

function SetHistoryIndex(startIndex, endIndex)
{
	var viewList = g_historyList;
	var _start = startIndex;

	var oldStartIndex = g_startHistoryIndex;
	g_startHistoryIndex = startIndex;
	g_endHistoryIndex = endIndex;

	if(oldStartIndex != -1 and startIndex < oldStartIndex)
	{
		for(var i = oldStartIndex - 1; i >= startIndex; --i)
		{
			var itemIndex = viewList.getItemIndexOfKey(i);
			if(itemIndex < 0)
			{
				viewList.addListItem(i, true, false); //add to head
			}
		}
		_start = oldStartIndex;
	}
	for(var j = _start; j <= endIndex; ++j)
	{
		var itemIndex = viewList.getItemIndexOfKey(j);
		if(itemIndex < 0)
		{
			viewList.addListItem(j, false, false); //add to tail
		}
	}
}

function SetHistoryInfo(historyIndex, txt_Time, txt_All, isWin, delta_rank)
{
	var viewList = g_historyList;
	var itemKey = historyIndex;

	var mc = viewList.getMcByItemKey(itemKey);
	if(mc)
	{
		if(delta_rank >= 0)
		{
			mc.info.gotoAndStop(1);
		}
		else
		{
			mc.info.gotoAndStop(2);
		}
		mc.info.txt_Day.text = txt_Time;
		mc.info.txt_Days.text = "";
		mc.info.txt_Hours.text = "";
		mc.info.txt_Hour.text = "";
		mc.info.txt_Challenge.htmlText = txt_All;
		mc.info.txt_Name.text = "";
		mc.info.txt_Win.text = "";
		// if(isWin)
		// {
		// 	mc.info.txt_Rating.textColor = 0x55E36C;
		// }
		// else
		// {
		// 	mc.info.txt_Rating.textColor = 0xFB3229;
		// }
		if(delta_rank != 0)
		{
			mc.info.arrowMark._visible = true;
			mc.info.txt_Rating._visible = true;
			mc.info.txt_Rating.text = delta_rank;
		}
		else
		{
			mc.info.arrowMark._visible = false;
			mc.info.txt_Rating._visible = false;
		}
		mc.info.btn_Replay.my_index = historyIndex;
		mc.info.btn_Replay._visible = false; //replay function not done, hide temp
		mc.info.btn_Replay.onRelease = function()
		{
			// trace("Replay Clicked: " + this.my_index);
			this._parent._parent._parent.onReleasedInListbox();
			if(g_BG.OnMoveOutOver == undefined
				&& (Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				)
			{
				fscommand("ArenaReplayClicked", this.my_index);
				move_out_history();
				g_BG.OnMoveOutOver = function()
				{
					fscommand("ExitBack", "");
				}
				fscommand("PlayMenuConfirm");
			}
		}

		mc.info.btn_Replay.onReleaseOutside = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
		}
		mc.info.btn_Replay.onPress = function()
		{
			this._parent._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
	}
}

function SetMoneyData(datas)
{
    TopUI.money.money_text.text = datas.money;
    TopUI.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = TopUI.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}
