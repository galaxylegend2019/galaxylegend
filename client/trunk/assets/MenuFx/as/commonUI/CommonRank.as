import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

//rank list
var g_rankRoot = _root.rank;
var g_rankList = g_rankRoot.list_area.ViewList;
var g_randListTitleBar = g_rankRoot.list_area.title_bar;
var g_startRankIndex = -1;
var g_endRankIndex = -1;

//bg
var g_BG = _root.bg;
var TopUI = _root.rank.top
var g_BackBtn = TopUI.btn_close;

//misc
var g_IsRank = true;

var g_UDID = "";
var g_bgIndex = 1;

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

//cs functions
this.onLoad = function(){
	init();
}

function init()
{
	g_rankRoot._visible = false;
	g_BG._visible = false;
	_root.btn_bg._visible = false;
	_root.btn_bg1._visible = false;

	InitRank();
}

_root.btn_bg.onRelease = function()
{
	//no click through
}

_root.btn_bg1.onRelease = function()
{
	//no click through
}

//rank functions
function move_in_rank()
{
	g_IsRank = true;
    g_BG._visible = true;
	if(g_bgIndex == 1)
	{
		_root.btn_bg1._visible = true;
		_root.btn_bg1.gotoAndStop(1);
	}
	else
	{
		_root.btn_bg._visible = true;
	}
	g_BG.OnMoveInOver = function()
	{
		
	}
	g_BG.OnMoveOutOver = function()
	{
		
	}
	g_BG.gotoAndPlay("opening_ani");

	g_rankRoot._visible = true;

	g_rankRoot.OnMoveInOver = function()
	{
		// trace("Move In Over");
		g_BackBtn.onRelease = function()
		{
			// trace("Back Clicked");
			move_out_rank();
			// fscommand("PlayMenuBack");
			fscommand("PlaySound", "sfx_ui_cancel");
		}
		// move_out_rank();
	}
	g_rankRoot.OnMoveOutOver = function()
	{
		// trace("Move Out Over");
		// fscommand("ExitBack", "");
		fscommand("RankCommand", "UIClosed" + "\2" + g_UDID)
		_root.btn_bg._visible = false;
	}
	g_rankRoot.gotoAndPlay("opening_ani");

	g_rankRoot.myRank.hero_icons.gotoAndPlay("opening_ani");
	g_rankRoot.myRank._visible = false;
}

function move_out_rank()
{
	g_BackBtn.onRelease = undefined;
	g_BG.gotoAndPlay("closing_ani");
	g_rankRoot.gotoAndPlay("closing_ani");
	g_rankRoot.myRank.hero_icons.gotoAndPlay("closing_ani");
}

function set_rank_num(rank, num, isLeft, maxDigit)
{
	var digits = [];
	num = Math.floor(num);
	while(num > 0)
	{
		var c = num % 10;
		digits.push(c);
		num /= 10;
		num = Math.floor(num);
	}
	for(var j = digits.length; j < maxDigit; ++j)
	{
		if(isLeft)
		{
			digits.unshift(-1);
		}
		else
		{
			digits.push(-1);
		}
	}
	// trace(digits);
	for(var i = 0; i < maxDigit; ++i)
	{
		var clipIndex = i + 1;
		var clip = rank["r_" + clipIndex];
		var d = digits[i];
		if(d != -1)
		{
			var frame = (d == 0) ? 1 : (d + 1);
			clip._visible = true;
			clip.gotoAndStop(frame);
		}
		else
		{
			clip._visible = false;
		}
	}
}

function set_rank_num_center(rank, num)
{
	if(num >= 10000)
	{
		rank.gotoAndStop(5);
	}
	else if(num >= 1000)
	{
		rank.gotoAndStop(4);

	}
	else if(num >= 100)
	{
		rank.gotoAndStop(3);
		
	}
	else if(num >= 10)
	{
		rank.gotoAndStop(2);
	}
	else 
	{
		rank.gotoAndStop(1);
	}

	var digits = [];
	num = Math.floor(num);
	while(num > 0)
	{
		var c = num % 10;
		digits.unshift(c);
		num /= 10;
		num = Math.floor(num);
	}
	var maxDigit = 5;
	for(var j = digits.length; j < maxDigit; ++j)
	{

		digits.push(-1);
	}
	// trace(digits);
	for(var i = 0; i < maxDigit; ++i)
	{
		var clipIndex = i + 1;
		var clip = rank["r_" + clipIndex];
		var d = digits[i];
		if(d != -1)
		{
			var frame = (d == 0) ? 1 : (d + 1);
			clip._visible = true;
			clip.gotoAndStop(frame);
		}
		else
		{
			clip._visible = false;
		}
	}
}

function InitRank(UDID, titleTxt, bgIndex)
{
	g_UDID = UDID;

	g_rankRoot.title_bar.txt_title.text = titleTxt;
	g_bgIndex = bgIndex;
	InitRankList();
	move_in_rank();
}

function InitRankList()
{
	g_startRankIndex = -1;
	g_endRankIndex = -1;
	var viewList = g_rankList;
	viewList.clearListBox();
	// _root.all.rank.list_area.bar._visible = false;
	viewList.initListBox("list_rank_item", 5, true, true);
	viewList.enableDrag( true );
	// viewList.setAddEraseFactor(8, 8);
	viewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	viewList.onItemEnter = function(mc, itemKey)
	{
		fscommand("RankCommand", "RequestItem" + "\2" + g_UDID + "\2" + itemKey);
		// trace("itemKey: " + itemKey + "  start: " + g_startRankIndex + "  end: " + g_endRankIndex);
		if(itemKey - g_startRankIndex <= 2)
		{
			fscommand("RankCommand", "RequestRefreshRank" + "\2" + g_UDID + "\2" + false);
		}
		if(g_endRankIndex - itemKey <= 2)
		{
			fscommand("RankCommand", "RequestRefreshRank" + "\2" + g_UDID + "\2" + true);
		}
	}

	viewList.onItemMCCreate = undefined; //function(mc){}
	viewList.onListboxMove = undefined; //function(mc){}
}

function ResetRankList()
{
	InitRankList();
}

function SetRankIndex(startIndex, endIndex)
{
	var viewList = g_rankList;
	var _start = startIndex;

	var oldStartIndex = g_startRankIndex;
	g_startRankIndex = startIndex;
	g_endRankIndex = endIndex;

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

function SetRankListTitle(combatTxt, timesTxt)
{
	g_randListTitleBar.txt_combat.text = combatTxt;
	g_randListTitleBar.txt_times.text = timesTxt;
}

function SetRankInfo(rankIndex, playerIcon, rank, playerName, levelTxt, combatNumTxt, timesNumTxt)
{
	var viewList = g_rankList;
	var itemKey = rankIndex;

	var mc = viewList.getMcByItemKey(itemKey);
	// trace(rankIndex + "  " + playerName + "  " + mc + "  " + mc.info);
	if(mc)
	{
		// mc.gotoAndStop(rank <= 3 ? 1 : 2);
		mc.gotoAndStop(1);

		var item = mc.item;
		// set_rank_num_center(item.info, rank);
		item.info.txt_rank.text = rank;

		item.iconBar.gotoAndStop(1);
		item.iconBar.hero_icons.gotoAndStop(1);
		if(item.iconBar.hero_icons.icons == undefined)
		{
			var h = item.iconBar.hero_icons._height;
			var w = item.iconBar.hero_icons._width;
			item.iconBar.hero_icons.loadMovie("CommonPlayerIcons.swf");
			item.iconBar.hero_icons._height = h;
			item.iconBar.hero_icons._width  = w;
		}
		item.iconBar.hero_icons.IconData = playerIcon;
		// trace("rankIndex: " + rankIndex + " rank: " + rank + " itemKey: "  + itemKey + " avatar: " + item.iconBar.hero_icons.IconData.icon_index + "  " + item.iconBar.hero_icons.UpdateIcon)
   		if (item.iconBar.hero_icons.UpdateIcon) { item.iconBar.hero_icons.UpdateIcon(); }

		item.iconBar.my_item_key = itemKey;
		
		item.btn_bg.my_item_key = itemKey;
		item.btn_bg.onRelease = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				fscommand("RankCommand", "IconClicked" + "\2" + g_UDID + "\2" + this.my_item_key + "\2" + -1 + "\2" + -1);
				fscommand("PlayMenuConfirm");
			}
		}
		item.btn_bg.onReleaseOutside = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
		}
		item.btn_bg.onPress = function()
		{
			this._parent._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		item.info.txt_Name.text = playerName;
		item.info.txt_Level.text = levelTxt;
		// item.info.txt_combat.text = combatTxt;
		// g_randListTitleBar.txt_combat.text = combatTxt;
		item.info.txt_combat_num.text = combatNumTxt;
		// item.txt_times.text = timesTxt;
		// g_randListTitleBar.txt_times.text = timesTxt;
		item.info.txt_times_num.text = timesNumTxt;
	}
}

function SetMyRankInfo(rank, playerIcon, playerLevel, playerName, combatTxt, combatNumTxt, timesTxt, timesNumTxt)
{
	g_rankRoot.myRank._visible = true;
	set_rank_num(g_rankRoot.myRank, rank, false, 5);

	g_rankRoot.myRank.hero_icons.hero_icons.gotoAndStop(1);
	if(g_rankRoot.myRank.hero_icons.hero_icons.icons == undefined)
	{
		var h = g_rankRoot.myRank.hero_icons.hero_icons._height;
		var w = g_rankRoot.myRank.hero_icons.hero_icons._width;
		g_rankRoot.myRank.hero_icons.hero_icons.loadMovie("CommonPlayerIcons.swf");
		g_rankRoot.myRank.hero_icons.hero_icons._height = h;
		g_rankRoot.myRank.hero_icons.hero_icons._width  = w;
	}
	g_rankRoot.myRank.hero_icons.hero_icons.IconData = playerIcon;
	if (g_rankRoot.myRank.hero_icons.hero_icons.UpdateIcon) { g_rankRoot.myRank.hero_icons.hero_icons.UpdateIcon(); }
	g_rankRoot.myRank.txt_Level.text = playerLevel;
	g_rankRoot.myRank.txt_Name.text = playerName;
	// g_rankRoot.myRank.txt_Rating.text = ratingTxt;

	g_rankRoot.myRank.txt_combat.text = combatTxt;
	g_rankRoot.myRank.txt_combat_num.text = combatNumTxt;
	g_rankRoot.myRank.txt_times.text = timesTxt;
	g_rankRoot.myRank.txt_times_num.text = timesNumTxt;
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
