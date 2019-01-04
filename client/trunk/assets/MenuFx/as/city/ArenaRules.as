import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;


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

g_Rule = _root.rule;
g_Info = g_Rule.info_bar;
var TopUI = _root.rule.top;

//cs functions
this.onLoad = function(){
	init();

	move_in();

	// var info = new Object();
	// info.rank = 1299;
	// info.hightRank = 999;
	// info.money_0 = 129;
	// info.money_1 = 1299;
	// info.money_2 = 1129;
	// SetPlayerInfo(info);


	// var rules = [
	// 	"11111111",
	// 	"222222222",
	// 	"0000000000",
	// 	"99999999999",
	// 	"11111111",
	// 	"222222222",
	// 	"0000000000",
	// 	"99999999999"
	// ];

	// SetRules(rules);
}

function init()
{
	set_top_invisible();

	InitRuleList();
}

function set_top_invisible()
{
	g_Rule._visible = false;
}

function InitRuleList()
{

}

function move_in()
{
	// trace("move in");
	g_Rule._visible = true;
	g_Rule.gotoAndPlay("opening_ani");
	g_Rule.OnMoveInOver = function()
	{
		g_Rule.is_moved_in = true;
        TopUI.btn_close.onRelease = function()
		{
			move_out();
			// fscommand("PlayMenuBack");
			fscommand("PlaySound", "sfx_ui_cancel");
		}
	}
}

function move_out()
{
	g_Rule.is_moved_in = false;
	g_Rule.gotoAndPlay("closing_ani");
	g_Rule.OnMoveOutOver = function()
	{
		fscommand("ExitBack", "");
		set_top_invisible();
	}
	g_Rule.btn_close.onRelease = undefined;
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


function SetPlayerInfo(info)
{
	var clip = g_Info;
	set_rank_num(clip.rank, info.rank, false, 5);
	if(clip.hero_icons.hero_icons.icons == undefined)
	{
		var w = clip.hero_icons.hero_icons._width;
		var h = clip.hero_icons.hero_icons._height;
		clip.hero_icons.hero_icons.loadMovie("CommonPlayerIcons.swf");
		clip.hero_icons.hero_icons._width = w;
		clip.hero_icons.hero_icons._height = h;

	}
	clip.hero_icons.hero_icons.IconData = info.playerIconInfo;
    if (clip.hero_icons.hero_icons.UpdateIcon) { clip.hero_icons.hero_icons.UpdateIcon(); }
	clip.txt_HighRank.text = info.highRank;
	clip.txt_money_0.text = info.money_0;
	clip.txt_money_1.text = info.money_1;
	clip.txt_money_2.text = info.money_2;

}

function SetRules(txts)
{
	var ViewList = g_Rule.list_area.ViewList;
	var item = ViewList.slideItem;
	var totalHeight = 0;
	var kDist = 5;

	trace(item._height + "  " + item._yscale);
	for(var i = 0; i < txts.length; ++i)
	{
		var txt = txts[i];
		var txtItem = item.attachMovie("arena_rule_board", "txt_" + i, item.getNextHighestDepth());
		txtItem.txt_Text.text = txt;
		//trace(txtItem.txt_Text.text)
		txtItem._y = totalHeight;
		totalHeight += (txtItem.txt_Text.textHeight + kDist);
		txtItem._yscale = 100;
		// trace(i + "  " + txtItem._y + "   " + txtItem._yscale);

		var lineItem = item.attachMovie("arena_rule_board_1", "line_" + i, item.getNextHighestDepth());
		lineItem._y = totalHeight;
		totalHeight += (lineItem._height + kDist);
		txtItem._yscale = 100;
	}

	if(item._height < totalHeight)
	{
		item._height = totalHeight;
	}
	trace(item._height + "  " + item._yscale);

	ViewList.SimpleSlideOnLoad();
	ViewList.onEnterFrame = function()
	{
		this.OnUpdate();
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
