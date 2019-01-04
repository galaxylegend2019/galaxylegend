import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

//Top Level
var g_All = _root.all;

//Top
var g_BackBtn = g_All.btn_close;
var g_MoneyTxt = g_All.bottom_bar;

//Item
var g_allListMC = [];

var g_itemNum = 0;
var g_itemColNum = 0;

//Bottom
g_RefreshTimeTxt = g_All.bottom_bar.txt_RefreshTime;
g_RefreshDescTxt = g_All.bottom_bar.txt_RefreshDesc;
g_RefreshBtn = g_All.bottom_bar.btn_Refresh;
g_RefreshMoneyTxt = g_All.bottom_bar.btn_Refresh.txt_RefreshMoney;
g_RefreshMoneyType = g_All.bottom_bar.money_type_refresh;

var g_ListArea = g_All.list_area;
var g_ItemList = g_ListArea.view_list;

//Misc
var g_isMovedIn = false;
var move_out_target = "";

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
	_root.move_out_target = "";
	g_All._visible = false;
	_root.btn_bg._visible = false;

	// for(var i = 0; i < 8; ++i)
	// {
	// 	g_ListArea["btn_item_" + i]._visible = false;
	// }

	// move_in();
	// InitItems(9);
}

function GetItemClip(idx)
{
	var itemIndex = Math.floor(idx / 2);
	var mc = g_ItemList.getMcByItemKey(itemIndex);
	if(!mc)
	{
		return undefined;
	}
	var subIdx = (idx % 2) + 1;
	return mc["item_" + subIdx];
}

function InitItems(itemNum : Number)
{
	g_itemNum = itemNum;
	g_itemColNum = Math.ceil(itemNum / 2);

	var viewList = g_ItemList;
	viewList.clearListBox();
	viewList.initListBox("tab_reslut_faile_tab2", 0, false, true);
	viewList.enableDrag( true );
	// viewList.setAddEraseFactor(8, 8);
	viewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	viewList.onItemMCCreate = undefined; //function(mc){}

	SetPageFlip(0);

	viewList.onItemEnter = function(mc, itemKey)
	{
		for(var i = 1; i <= 2; ++i)
		{
			var clip = mc["item_" + i];
			clip.my_index = itemKey * 2 + i - 1;
			if(clip.my_index >= g_itemNum)
			{
				clip._visible = false;
				continue;
			}
			clip._visible = true;
			// trace("clip: " + clip);
			var btnClip = clip.btn_bg;
			// trace("btnClip: " + btnClip);
			btnClip.my_index = clip.my_index;
			btnClip.onRelease = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
				if((Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
					&& g_isMovedIn
					&& !this._parent.isSold
					)
				{
					trace("ShopClicked: " + this.my_index);
					fscommand("ShopClicked", this.my_index);
					fscommand("PlayMenuConfirm");
				}
			}
			btnClip.onReleaseOutside = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
			}
			btnClip.onPress = function()
			{
				this._parent._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}
		}
	}

	viewList.onItemLeave = function(mc, itemKey)
	{
		for(var i = 1; i <= 2; ++i)
		{
			var clip = mc["item_" + i];
			var btnClip = clip.btn_bg;
			btnClip.onRelease = undefined;
			btnClip.onReleaseOutside = undefined;
			btnClip.onPress = undefined;
		}
	}

	viewList.onListboxMove = function()
	{
		var visible_pos = this.computeVisiblePos();
		var pos = visible_pos.spos; //(visible_pos.spos + visible_pos.epos) * 0.5;
		if(pos < visible_pos.item_height * 0.33)
		{
			SetPageFlip(0);
		}
		else if(pos < visible_pos.item_height * 0.66)
		{
			SetPageFlip(1);
		}
		else
		{
			SetPageFlip(2);
		}
	}

	g_allListMC = [];
	for(var i = 0; i < g_itemColNum; ++i)
	{
		var mc = viewList.addListItem(i, false, false);
		for(var j = 1; j <= 2; ++j)
		{
			var clip = mc["item_" + j];
			var btnClip = clip.btn_bg;
			if(clip.button_icon.item_icon.icons == undefined)
			{
				clip.button_icon.item_icon.loadMovie("CommonIcons.swf");
				clip.button_icon.item_icon.m_OnlyIcon = true;
			}
		}
		g_allListMC.push(mc);
	}
}

function SetItemInfo(i, info)
{
	var item = GetItemClip(i);
	if(!item)
	{
		return;
	}
	// trace(i + " " + info.titleTxt + " " + info.promo + " " + info.iconIndex + " " + info.priceTxt);
	// item.name_bar.txt_Name.text = info.titleTxt;
	if(info.promo == "new")
	{
		item.name_bar.gotoAndStop(1);
		item.name_bar.txt_Name.text = info.titleTxt;
		item.name_bar.txt_count.text = info.countTxt;
		item.name_bar.txt_count._x = item.name_bar.LC_UI_Item_Numbers._x + item.name_bar.LC_UI_Item_Numbers.textWidth + 6;

		item.promo_bar._visible = true;
		item.promo_bar.gotoAndStop(1);

		item.price_bar.price_new._visible = true;
		item.price_bar.price_normal._visible = false;
		item.price_bar.price_discount._visible = false;

		item.price_bar.price_new.txt_Time.text = info.countDownTxt;
		var bar = item.price_bar.price_new.price_new;
		if(info.isSold)
		{
			bar.gotoAndStop("Sold");
		}
		else
		{
			bar.gotoAndStop("Idle");
			bar.txt_Price.text = info.priceTxt;
			bar.price_type.gotoAndStop(info.priceType);
		}
	}
	else if(info.promo == "discount")
	{
		item.name_bar.gotoAndStop(2);
		item.name_bar.txt_Name.text = info.titleTxt;
		item.name_bar.txt_count.text = info.countTxt;
		item.name_bar.txt_count._x = item.name_bar.LC_UI_Item_Numbers._x + item.name_bar.LC_UI_Item_Numbers.textWidth + 6;

		item.promo_bar._visible = true;
		item.promo_bar.gotoAndStop(2);
		item.promo_bar.discount_bar.txt_Discount.text = info.percentTxt;

		item.price_bar.price_new._visible = false;
		item.price_bar.price_normal._visible = false;
		item.price_bar.price_discount._visible = true;

		var bar = item.price_bar.price_discount;
		if(info.isSold)
		{
			bar.gotoAndStop("Sold");
		}
		else
		{
			bar.gotoAndStop("Idle");
			bar.txt_OldPrice.text = info.oldPriceTxt;
			bar.txt_Price.text = info.priceTxt;
			bar.price_type.gotoAndStop(info.priceType);
		}
	}
	else
	{
		item.name_bar.gotoAndStop(3);
		item.name_bar.txt_Name.text = info.titleTxt;
		item.name_bar.txt_count.text = info.countTxt;
		item.name_bar.txt_count._x = item.name_bar.LC_UI_Item_Numbers._x + item.name_bar.LC_UI_Item_Numbers.textWidth + 6;

		item.promo_bar._visible = false;

		item.price_bar.price_new._visible = false;
		item.price_bar.price_normal._visible = true;
		item.price_bar.price_discount._visible = false;

		var bar = item.price_bar.price_normal;
		if(info.isSold)
		{
			bar.gotoAndStop("Sold");
		}
		else
		{
			bar.gotoAndStop("Idle");
			bar.txt_Price.text = info.priceTxt;
			bar.price_type.gotoAndStop(info.priceType);
		}

	}

	item.isSold = info.isSold;

	// item.sold_bar._visible = info.isSold;
	
	var item_icon_clip = item.button_icon.item_icon;
	item_icon_clip.IconData = info.iconInfo;
	if (item_icon_clip.UpdateIcon) { item_icon_clip.UpdateIcon(); }
}

function SetRefreshTime(timeTxt, descTxt)
{
	// g_RefreshTimeTxt.text = timeTxt;
	g_RefreshDescTxt.html = true;
	g_RefreshDescTxt.htmlText = descTxt;
}

function SetRefreshMoney(moneyTxt, moneyType)
{
	// trace("refresh money: " + moneyTxt);
	g_RefreshMoneyTxt.text = moneyTxt;
	// trace("moneyType: " + moneyType + "  " + g_RefreshMoneyType);
	g_RefreshMoneyType.gotoAndStop(moneyType);
}

function SetMoney(moneyType, moneyTypeTxt, moneyTxt)
{
	g_MoneyTxt.money_type.gotoAndStop(moneyType);
	g_MoneyTxt.txt_MoneyType.text = moneyTypeTxt;
	g_MoneyTxt.txt_Money.text = moneyTxt;
}

function move_in(isShowBg, bgClip)
{
	g_All._visible = true;
	g_All.gotoAndPlay("opening_ani");

	MoveInItems();
	_root.btn_bg._visible = true;

	g_All.bg._visible = isShowBg ? true : false;

	g_All.bg.bg_all.gotoAndStop(bgClip);
	g_All.bg.gotoAndPlay("opening_ani");
}

function move_out()
{
	g_All.gotoAndPlay("closing_ani");
	ClearButtonFunctions();
	g_isMovedIn = false;

	MoveOutItems();
	g_All.bg.gotoAndPlay("closing_ani");
}

g_All.OnMoveInOver = function()
{
	g_isMovedIn = true;
	InitButtonFunctions();
}

g_All.OnMoveOutOver = function()
{
	// trace("move out over: " + move_out_target);
	if(move_out_target != "")
	{
		if(move_out_target == "Back")
		{
			fscommand("ExitBack", "");
		}
		else if(move_out_target != "")
		{
			// trace("GoToNext: " + move_out_target);
			fscommand("GoToNext", move_out_target);
		}
		root.move_out_target = "";
	}
	_root.btn_bg._visible = false;
	this._visible = false;
}

_root.btn_bg.onRelease = function()
{
	//no click through
}

g_All.btn_mask_left.onRelease = g_All.btn_mask_right.onRelease = function()
{
	//no click through
}

function InitButtonFunctions()
{
	g_BackBtn.onRelease = function()
	{
		// fscommand("ExitBack", "");
		move_out_target = "Back";
		move_out();
		fscommand("PlaySound", "sfx_ui_cancel");
		// fscommand("PlayMenuBack");
	}

	g_RefreshBtn.onRelease = function()
	{
		// trace("Refresh Clicked");
		fscommand("ShopRefreshClicked");
		// fscommand("PlayMenuConfirm");
	}
}

function ClearButtonFunctions()
{
	g_BackBtn.onRelease = undefined;
	g_RefreshBtn.onRelease = undefined;
}

function SetTitleText(titleTxt)
{
	g_All.title_bar.txt_Title.text = titleTxt;
}

function SetPageFlip(page)
{
	var flips = g_All.flips;
	var MAX_PAGE = 3;
	for(i = 0; i < MAX_PAGE; ++i)
	{
		var flip = flips["flip_" + i];
		flip.gotoAndStop(i == page ? 1 : 2);
	}
	g_All.last_arrow._visible = page > 0;
	g_All.next_arrow._visible = page < MAX_PAGE - 1;
}

function MoveOutToBuy(where)
{
	move_out_target = where;
	move_out();
}

function MoveInItems()
{
	for(var i = 0; i < g_itemNum; ++i)
	{
		var item = GetItemClip(i);
		if(item)
		{
			item.is_moved_in = false;
			item.gotoAndPlay("opening_ani");
			item.OnMoveInOver = function()
			{
				this.is_moved_in = true;
			}
			// item.gotoAndStop(1);
		}
	}
}

function MoveOutItems()
{
	for(var i = 0; i < g_itemNum; ++i)
	{
		var item = GetItemClip(i);
		if(item && item.is_moved_in)
		{
			item.is_moved_in = false;
			item.gotoAndPlay("closing_ani");
		}
	}
}

