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

var g_MainUI = _root.main_ui;
var g_Numbers = [_root.number_0, _root.number_1, _root.number_2];
var g_Items = [_root.item_0, _root.item_1, _root.item_2, _root.item_3];

var g_MoneyBar = g_MainUI.money_bar;
var g_MoneyTexts = [g_MainUI.energy, g_MainUI.money, g_MainUI.credit];

var g_backBtn = g_MainUI.btn_close;
var move_out_target = "";

//cs functions
this.onLoad = function(){
	init();

	// move_in();
	// SetInitMoney(["1,000", "2,000", "1,200"]);
}

function init()
{
	set_top_invisible();
	for(var i = 0; i < g_Numbers.length; ++i)
	{
		g_Numbers[i].my_index = i;
	}
	for(var i = 0; i < g_Items.length; ++i)
	{
		g_Items[i].my_index = i;
		g_Items[i].btn_Buy.my_index = i;
	}
}

function set_top_invisible()
{
	g_MainUI._visible = false;
	for(var i = 0; i < g_Numbers.length; ++i)
	{
		g_Numbers[i]._visible = false;
	}
	for(var i = 0; i < g_Items.length; ++i)
	{
		g_Items[i]._visible = false;
	}
	_root.btn_bg._visible = false;
}

function set_buy_function(btn_Buy)
{
	btn_Buy.onRelease = function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickAffairsBuyBtn");
		/*******End*******/
		trace("AffairBuyClicked: " + this.my_index);
		fscommand("AffairBuyClicked", this.my_index);
		fscommand("PlayMenuConfirm");
	}
}

function move_in()
{
	g_MainUI._visible = true;
	g_MainUI.gotoAndPlay("opening_ani");
	g_MainUI.OnMoveInOver = function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","Activate" + "\2" + "AffairsHallLoad");
		/*******End*******/
		g_backBtn.onRelease = function()
		{
			move_out_target = "Back";
			move_out();
			fscommand("PlayMenuBack");
		}
	}

	for(var i = 0; i < g_Items.length; ++i)
	{
		g_Items[i]._visible = true;
		g_Items[i].gotoAndPlay("opening_ani");
		g_Items[i].OnMoveInOver = function()
		{
			g_Items[i].is_moved_in = true;
			if(this.my_is_enabled)
			{
				set_buy_function(this.btn_Buy);
			}
		}
	}
	_root.btn_bg._visible = true;
}

function move_out()
{
	g_MainUI.gotoAndPlay("closing_ani");
	g_backBtn.onRelease = undefined;
	g_MainUI.OnMoveOutOver = function()
	{
		set_top_invisible();
		if(move_out_target == "Back")
		{
			// trace("ExitBack");
			fscommand("ExitBack", "");
			move_out_target = "";
		}
		else if(move_out_target != "")
		{
			// trace("GoToNext: " + move_out_target);
			fscommand("GoToNext", move_out_target);
			move_out_target = "";
		}
	}

	for(var i = 0; i < g_Items.length; ++i)
	{
		g_Items[i].gotoAndPlay("closing_ani");
		g_Items[i].is_moved_in = false;
		g_Items[i].btn_Buy.onRelease = undefined;
		g_Items[i].OnMoveOutOver = function()
		{
			this._visible = false;
		}
	}
}

_root.btn_bg.onRelease = function()
{
}

function SetDesc(descTxt)
{
	g_MainUI.desc_bar.txt_Desc.htmlText = descTxt;
}

function SetMoney(i, priceTxt, addTo)
{
    if (i == 0)
    {
        var energyBtn = g_MoneyTexts[i]
        var arrayNum = priceTxt.split("/");
        var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
        ratio = Math.min(100, Math.max(1, ratio))
        energyBtn.mc.gotoAndStop(ratio)
        energyBtn.mc.TxtNum.text = priceTxt
    }
    {
        g_MoneyTexts[i].txt_num.text = priceTxt;
    }

	var addBtn = g_MoneyTexts[i].btn_add;
	if(addTo != undefined && addTo != "")
	{
		addBtn._visible = true;
		addBtn.my_goto_target = addTo;
		addBtn.onRelease = function()
		{
			MoveOutTo(this.my_goto_target);
			fscommand("PlayMenuConfirm");
		}
	}
	else
	{
		// addBtn._visible = false;
		addBtn.onRelease = undefined;
	}
}

function set_anim_num(rank, num, maxDigit)
{
	var digits = [];
	num = Math.floor(num);
	while(num > 0)
	{
		var c = num % 10;
		digits.unshift(c);
		num /= 10;
		num = Math.floor(num);
	}
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

function SetAddMoney(i, crit_times, addPrice, addPriceTxt, endPriceIdx, endPriceTxt)
{
	if(g_Numbers[i])
	{
		g_Numbers[i].cloneCount = g_Numbers[i].cloneCount == undefined ? 0 : g_Numbers[i].cloneCount + 1;
		var clip = g_Numbers[i].duplicateMovieClip(g_Numbers[i]._name + "_" + g_Numbers[i].cloneCount, getNextHighestDepth());
		clip._visible = true;
		clip.my_index = i;
		clip.my_end_index = endPriceIdx;
		if(crit_times > 1)
		{
			clip.gotoAndStop(2);
			set_anim_num(clip.num_bar.num_bar, addPrice, 8);
			set_anim_num(clip.num_bar.time_bar, crit_times, 2);
		}
		else
		{
			clip.gotoAndStop(1);			
			clip.num_bar.num_bar.txt_money.text = addPriceTxt;
		}
		clip.end_price_txt = endPriceTxt;
		clip.my_is_playing = false;
		clip.num_bar.gotoAndPlay("move_up");
		// trace("clip: " + clip + "  " + clip._x + " " + clip._y + "  " + g_Numbers[i]._x + "  " + g_Numbers[i]._y + "  " + clip._parent + "  " + g_Numbers[i]._parent);
		clip.num_bar.onEnterFrame = function()
		{
			if(not this.my_is_playing)
			{
				this.my_is_playing = true;
				this.play();
			}
		}
		clip.num_bar.OnMoveOver = function()
		{
			g_MoneyTexts[this._parent.my_end_index].txt_num.text = this._parent.end_price_txt;
			// trace(this._parent.my_end_index + "  " + g_MoneyTexts[this._parent.my_end_index] + "  " + g_MoneyTexts[this._parent.my_end_index].text)

			this.OnMoveOver = undefined;
			// this._visible = false;
			this.removeMovieClip();
		}
	}
}

function SetItemInfo(i, info)
{
	var clip = g_Items[i];
	if(clip)
	{
		clip.title_bar._visible = info.isEnabled;
		clip.title_bar.txt_title.text = info.titleTxt;
		if(info.npcIcon == -1)
		{
			clip.tab_bg.npc._visible = false;
		}
		else
		{
			clip.tab_bg.npc._visible = true;
			clip.tab_bg.gotoAndStop(info.npcBg);
			clip.tab_bg.npc.gotoAndStop(info.npcIcon);
		}
		// if(info.iconClip == -1)
		// {
		// 	clip.icons._visible = false;
		// }
		// else
		// {
		// 	clip.icons._visible = true;
		// 	clip.icons.gotoAndStop(info.iconClip);
		// }
		if(info.isEnabled)
		{
			clip.money_icon._visible = true;
			clip.money_icon.gotoAndStop(info.moneyIcon);

			clip.triangle._visible = true;
			clip.number_bar._visible = true;
			clip.desc_bar._visible = true;
			clip.tab_bg.my_index = clip.my_index;
			clip.tab_bg.onRelease = undefined;
		}
		else
		{
			clip.money_icon._visible = false;
			clip.triangle._visible = false;
			clip.number_bar._visible = false;
			clip.desc_bar._visible = false;
			clip.tab_bg.my_index = clip.my_index;
			clip.tab_bg.onRelease = function()
			{
				trace("AffairCannotBuyClicked: " + this.my_index);
				fscommand("AffairBuyClicked", this.my_index);
			}
		}
		clip.number_bar.gotoAndStop(info.isEnabled ? 1 : 2);
		clip.number_bar.txt_number.text = info.numberTxt;
		clip.desc_bar.txt_desc.text = info.descTxt;
		clip.btn_Buy._visible = info.isEnabled;
		clip.btn_Buy.txt_Price.text = info.priceTxt;
		clip.btn_Buy.red_dot._visible = info.isFree;
		clip.my_is_enabled = info.isEnabled;
		if(clip.is_moved_in && clip.my_is_enabled)
		{
			set_buy_function(clip.btn_Buy);
		}
	}
}

function MoveOutTo(where)
{
	if(move_out_target == "")
	{
		move_out_target = where;
		move_out();
	}
}