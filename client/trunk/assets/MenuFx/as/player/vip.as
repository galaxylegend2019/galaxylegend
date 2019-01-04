
var MainUI 	= _root.main_ui;
var TopUI 	= _root.top;

var VipInfo = MainUI.vip_info;

var VipDatas = undefined;

var CurShowVip = 0;

var MAX_VIP_LEVEL = 15

this.onLoad = function()
{
	OpenUI();
	Init();
	//SetVipInfo();
	// VipDatas = new Object();
	// VipDatas.rule_list = new Array();
	// VipDatas.rule_list[0] = "11111111111";
	// VipDatas.rule_list[1] = "22222222222";
	// VipDatas.rule_list[2] = "33333333333";
	// VipDatas.rule_list[3] = "44444444444";
	// VipDatas.rule_list[4] = "55555555555";
	// InitList();
}

function Init()
{
	TopUI.btn_close.onRelease = function()
	{
		CloseUI();
	}
	TopUI.OnMoveOutOver = function()
	{
		fscommand("VipCommand", "CloseUI");
	}
}

function SetDefaultShow()
{

}

function OpenUI()
{
	MainUI.gotoAndPlay("opening_ani");
	TopUI.gotoAndPlay("opening_ani");
}

function CloseUI()
{
	MainUI.gotoAndPlay("closing_ani");
	TopUI.gotoAndPlay("closing_ani");
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

function RefreshUI(datas)
{
	VipDatas = datas;
	CurShowVip = VipDatas.cur_vip_level;
	if (CurShowVip == 0)
	{
		CurShowVip = 1;
	}
	SetVipInfo();
	SwtichVipRule(CurShowVip);
}

/*
cur_vip_level
next_vip_level
next_vip_need_credit
cur_vip_point
upgrade_vip_point
*/
function SetVipInfo()
{
	if (VipDatas.cur_vip_level >= MAX_VIP_LEVEL)
	{
		VipInfo.info._visible = false;
		VipInfo.full_level._visible = true;
		SetProgressBar(VipInfo.progress, VipDatas.cur_vip_point, VipDatas.cur_vip_point);
	}else
	{
		VipInfo.info._visible = true;
		VipInfo.full_level._visible = false;
		
		VipInfo.info.next_credit.credit_text.text = VipDatas.next_vip_need_credit;
		SetVipNum(VipInfo.info.next_level, VipDatas.next_vip_level);
		SetProgressBar(VipInfo.progress, VipDatas.cur_vip_point, VipDatas.upgrade_vip_point);
	}
	SetVipNum(VipInfo.cur_level, VipDatas.cur_vip_level);

	
	VipInfo.add_star.btn_addstar.onRelease = function()
	{
		fscommand("GoToNext","Purchase");
	}
}

function SetVipNum(mc, num)
{
	var num0 = Math.floor(num / 10);
	var num1 = num % 10;
	if (num >= 10)
	{
		mc.num.gotoAndStop(2);
		mc.num.num0.gotoAndStop(num0 + 1);
		mc.num.num1.gotoAndStop(num1 + 1);
	}else
	{
		mc.num.gotoAndStop(1);
		mc.num.num0.gotoAndStop(num1 + 1);
	}
}

function SetProgressBar(mc, cur, max)
{
	mc.txt_progress.text = cur + "/" + max;
	var progress = Math.floor((cur / max) * 100) + 1;
	mc.gotoAndStop(progress);
}

function SwtichVipRule(level)
{
	//trace("------level=" + level);
	MainUI.vip_level.level_txt.text = "V" + level;
	InitList();
	SetGiftInfo();

	MainUI.right_btn._visible = true;
	MainUI.left_btn._visible = true;
	if (CurShowVip <= 1)
	{
		MainUI.left_btn._visible = false;
	}else if (CurShowVip >= MAX_VIP_LEVEL)
	{
		MainUI.right_btn._visible = false;
	}
}


MainUI.left_btn.onRelease = function()
{
	if (CurShowVip > 1)
	{
		CurShowVip -=1;
		SwtichVipRule(CurShowVip);
	}
}

MainUI.right_btn.onRelease = function()
{
	if (CurShowVip < 15)
	{
		CurShowVip += 1;
		SwtichVipRule(CurShowVip);
	}
}


/*---------------rule list--------------*/

var AllListMc = new Array();
var RuleList = MainUI.list.view_list;
var RuleSlideItem = RuleList.slideItem;
var TotalHeight = 0;
function ClearListMc()
{
	for(var i in AllListMc)
	{
		AllListMc[i].removeMovieClip();
	}
	RuleList.forceCorrectPosition();
	AllListMc = new Array();
}

//rule_list
function InitList()
{
	TotalHeight = 0;
	ClearListMc();

	var cur_rules = VipDatas.rule_list[CurShowVip - 1];

	for (var i = 0; i < cur_rules.length; ++i)
	{
		var rule_mc = RuleSlideItem.attachMovie("VIPInfo_ber", "rule_" + i, RuleSlideItem.getNextHighestDepth());
		rule_mc.rule_txt.html 		= true;
		rule_mc.rule_txt.htmlText 	= cur_rules[i];
		rule_mc._y = TotalHeight;
		TotalHeight = TotalHeight + rule_mc.rule_txt.textHeight;
		AllListMc.push(rule_mc);
	}
	RuleList.SimpleSlideOnLoad();
	RuleList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	RuleList.forceCorrectPosition();
}

/*------------------gift-------------------*/

var GiftInfo = MainUI.gift;


function IsCanBuyGift( vip_level )
{
	for (var i = 0; i < VipDatas.buy_gifts.length; ++i)
	{
		if (VipDatas.buy_gifts[i] == vip_level)
		{
			return false;
		}
	}
	return true;
}

//buy_gifts = {1, 2}
//gift_infos[].items = {}  old_price cur_price
function SetGiftInfo()
{
	GiftInfo.title_txt.text = VipDatas.gift_infos[CurShowVip - 1].gift_title
	var gift_items = VipDatas.gift_infos[CurShowVip - 1].items;
	for (var i = 0; i < 8; ++i)
	{
		var item_mc = GiftInfo.content["item" + i];
		var item_info = gift_items[i];
		if (item_info == undefined)
		{
			item_mc._visible = false;
		}else
		{
			item_mc._visible = true;
			SetItemInfo(item_mc.icon_bar, item_info);
		}
	}
	if (IsCanBuyGift(CurShowVip))
	{
		//trace("---------------vip=" + CurShowVip)
		//trace("-----------old_price=" + VipDatas.gift_infos[CurShowVip - 1].old_price)
		GiftInfo.set_out._visible = false;
		GiftInfo.buy._visible = true;

		if (CurShowVip <= VipDatas.cur_vip_level)
		{
			GiftInfo.buy.gotoAndStop(1);
			GiftInfo.buy.buy_btn.onRelease = function()
			{
				//trace("-------Buy Gift-------" + CurShowVip);
				fscommand("VipCommand", "BuyVipGift\2" + CurShowVip)
			}
		}else
		{
			GiftInfo.buy.gotoAndStop(2);
			GiftInfo.buy.buy_btn.onRelease = function()
			{
				fscommand("VipCommand", "CantBuyVipGift")
			}
		}
		GiftInfo.buy.buy_btn.old_price_txt.text = VipDatas.gift_infos[CurShowVip - 1].old_price
		GiftInfo.buy.buy_btn.cur_price_txt.text = VipDatas.gift_infos[CurShowVip - 1].cur_price
	}else
	{
		GiftInfo.set_out._visible = true;
		GiftInfo.buy._visible = false;
	}
}

//item_icon
//item_num
function SetItemInfo(mc, item_info)
{
	//trace("--------------mc=" + mc._name)
	//trace("-----------item_count=" + item_info.count)
	SetItemIcon(mc, item_info.iconInfo);
	if (item_info.count > 1)
	{
		mc.bg_bar._visible = true;
		mc.txt_num._visible = true;
		mc.txt_num.text = item_info.count;
	}else
	{
		mc.bg_bar._visible = false;
		mc.txt_num._visible = false;
	}

	mc.res_type = item_info.iconInfo.res_type
	mc.res_id = item_info.iconInfo.res_id

	mc.onPress = function()
	{
		fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
	}
	mc.onRelease = mc.onReleaseOutside = function()
	{
		fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
	}

}


function SetItemIcon(mc, icon_data)
{
	//trace("------mc.item_icon=" + mc.item_icon._name)
	if (mc.item_icon.icons == undefined)
	{
		var w = mc.item_icon._width;
		var h = mc.item_icon._height;
		if (icon_data.res_type == "hero")
		{
			mc.item_icon.loadMovie("CommonHeros.swf");
		}else
		{
			mc.item_icon.loadMovie("CommonIcons.swf");
		}
		
		
	}
	mc.item_icon._width = 128;
	mc.item_icon._height = 128;
	mc.item_icon.IconData = icon_data;
	if(mc.item_icon.UpdateIcon)
	{ 
		mc.item_icon.UpdateIcon(); 
	}
}