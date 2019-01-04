
#include "../../as/common/util.as"

import common.CTextAutoSizeTool;

var MainUI 			= _root.tab_bar;
var CloseBtn 		= _root.top.btn_close;
var ActivityList	= MainUI.board1.view_list;

var ActivityDatas 			= new Array();
var LoginAwardData = undefined
// must same in ActivityManager.lua
var LOGIN_AWARD = 0;
var ARENA_SEASON = 1;
var	REDEEM_CODE = 2;
var FIRST_PURCHASE = 3;
var EXCAVATE = 4;
var SEVEN_GOAL = 5;
var SEVEN_DAYAWARD = 6;
var EVERYDAY = 7;
var activityTypeName = [
    "login_award",
    "arena_season",
    "redeem_code",
    "first_purchase",
    "excavate",
    "seven_goal",
    "seven_dayaward",
    "everyday"
]

var CurSelectIndex = -1 ;
var LoginAwardPanel = _root.ui_login;

this.onLoad = function()
{
    init();
	InitActivityList();
    TaskSubInit();


    for (var i=1; i<=7; i++)
    {
        var themc = _root.seven_dayaward.content["c"+i]

        if(themc.item.item_icon.icons==undefined)
        {
            var w = themc.item.item_icon._width;
            var h = themc.item.item_icon._height;
            themc.item.item_icon.loadMovie("CommonIcons.swf")
            themc.item.item_icon._width = w
            themc.item.item_icon._height = h
        }
    }
}

CloseBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_cancel");
    move_out();
}

function InitActivityList()
{
    if (ActivityDatas == undefined)
    {
        return;
    }
	ActivityList.clearListBox();
    ActivityList.initListBox("Btnlist_ber", 0, true, true);
	ActivityList.enableDrag(true);
	ActivityList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ActivityList.onItemEnter = function(mc, index_item)
	{
        SetItemInfo(mc, index_item);
	}

    for (var i = 0 ; i < ActivityDatas.length; ++i)
	{
		ActivityList.addListItem(i, false, false);
	}
}

function SetItemInfo(mc, index_item)
{
	var item = undefined;
	var data = ActivityDatas[index_item];
    mc.index = index_item;
    mc.data = data
    item.txt.text = data.listitem_name
    mc.gotoAndStop(activityTypeName[data.type])
    item = mc[activityTypeName[data.type]]

    item.red_point._visible = data.red_point
    item.txt.text = data.listitem_name
    if (item != undefined)
	{
        item.onPress = function()
		{
            this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		item.onReleaseOutside = function()
		{
            this._parent._parent.onReleasedInListbox();
		}

		item.onRelease = function()
		{
            this._parent._parent.onReleasedInListbox();
            if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
            {
                if (CurSelectIndex != this._parent.index)
                {
                    fscommand("PlaySound","sfx_ui_selection_1");
                    for(var i = 0; i < ActivityDatas.length;i++)
                    {
                        var curMc = ActivityList.getMcByItemKey(i)
                        curMc[activityTypeName[curMc.data.type]].gotoAndStop(1)
                    }
                    this.gotoAndStop(2)
                    SetCurSelectIndex(this._parent.index);
                    ActivityList.needUpdateVisibleItem();
                }
            }
		}
	}
}

function UpdateSubPanel()
{
	var data = ActivityDatas[CurSelectIndex];
	if (data == undefined)
	{
		return;
	}
	switch(data.type)
	{
		case LOGIN_AWARD:
        // LoginAwardList.forceCorrectPosition();
        // UpdateLoginAwardPanel(data);
		break;
		case ARENA_SEASON:
        // UpdateArenaPanel(data);
		break;
		case REDEEM_CODE:
        // UpdateRedeemCodePanel(g_tabPages[REDEEM_CODE], data);
		break
		default:
		break;
	}
}

function InitActivityDatas( datas )
{
    trace("-------UpdateActivitys-------");
    ActivityDatas = datas;
    InitActivityList()
    ActivityList.needUpdateVisibleItem()
}

function UpdateActivitysDatas(datas)
{
    ActivityDatas = datas
    UpdateSubPanel()
}

function SetPanelShow( Show )
{
	var isShow = Show.state;
	if (isShow)
	{
		_root.top._visible 		= true;
		_root.ui_all._visible 	= true;
		_root.bg_btn.onRelease 	= undefined;
	}else
	{
		_root.top._visible 		= false;
		_root.ui_all._visible 	= false;
		_root.bg_btn.onRelease 	= function()
		{
			fscommand("CityActivityCmd", "CloseHeroShow")
		}
	}
}

var g_tabPages = [ _root.ui_login,_root.ui_arena , _root.ui_redeem, _root.ui_firstbuy,_root.excavate,_root.seven_goal,_root.seven_dayaward,_root.everyday ];
var g_NextState = "GS_MainMenu";

function init()
{
    _root.top._visible = false;
    _root.bag._visible = false;
    _root.bg1._visible = false;
    _root.popup_logout._visible = false;
    _root.bag._visible = false;
	for(var i = 0; i < g_tabPages.length; ++i)
	{
		g_tabPages[i]._visible = false;
	}
    _root.btn_bg._visible = false;
    _root.ui_firstbuy.add_star.btn_addstar.onRelease = function()
    {
        fscommand("PlaySound","sfx_ui_selection_1");
        fscommand("FirstPayClicked", _root.ui_firstbuy.add_star.btn_addstar.txt.text)
    }
}

_root.btn_bg.onRelease = function()
{
	//no click through
}

function move_in()
{
	_root.btn_bg._visible = true;
    _root.top._visible = true;
	_root.top.gotoAndPlay("opening_ani");
    _root.tab_bar._visible = true;
    _root.bg1._visible = true;
	_root.bg1.gotoAndPlay("opening_ani");
	g_NextState = "GS_MainMenu";
}

function move_out(nextState)
{
	if(nextState != undefined)
	{
		g_NextState = nextState;
    }
    if(CurSelectIndex != undefined)
    {
        var curMc = ActivityList.getMcByItemKey(CurSelectIndex)
        g_tabPages[curMc.data.type]._visible = false;
    }
	_root.top.gotoAndPlay("closing_ani");
	_root.tab_bar.gotoAndPlay("closing_ani");
    _root.bg1.gotoAndPlay("closing_ani");
	_root.bg1.OnMoveOutOver = function()
	{
		_root.top._visible = false;
		_root.tab_bar._visible = false;
		_root.bg1._visible = false;
		_root.btn_bg._visible = false;
		fscommand("GotoNextMenu", g_NextState);
		CurSelectIndex = undefined;
    }
}

function GetListItemByType(type)
{
    for(var i = 0; i < ActivityDatas.length;i++)
    {
        var curMc = ActivityList.getMcByItemKey(i)
        if (curMc.data.type == type)
        {
            return curMc[activityTypeName[curMc.data.type]]
        }
    }
}

function InitSelectIndex(type)
{
    var curIndex = 0
    for(var i = 0; i < ActivityDatas.length;i++)
    {
        var curMc = ActivityList.getMcByItemKey(i)
        if (curMc.data.type == type)
        {
            curMc[activityTypeName[curMc.data.type]].gotoAndStop(2)
            curIndex = curMc.index
            curMc[activityTypeName[curMc.data.type]].txt.text = curMc.data.listitem_name
        }
    }
    SetCurSelectIndex(curIndex)
}

function SetCurSelectIndex(idx)
{
	if(CurSelectIndex != idx)
    {
        if(CurSelectIndex != undefined)
        {
            var curMc = ActivityList.getMcByItemKey(CurSelectIndex)
            g_tabPages[curMc.data.type]._visible = false;
		}
		CurSelectIndex = idx;
		if(CurSelectIndex != undefined)
        {
            var curMc = ActivityList.getMcByItemKey(idx)
            g_tabPages[curMc.data.type]._visible = true;
            g_tabPages[curMc.data.type].gotoAndPlay("opening_ani");
            UpdateSubPanel();
        }
	}
}

function SetMoneyData(datas)
{
	_root.top.money.money_text.text = datas.money;
	_root.top.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = _root.top.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

/*------------LoginAward-----------*/
var LoginAwardList = LoginAwardPanel.award_list.view_list;
var AwardSlideItem = LoginAwardList.slideItem;
var AllAwardMc = new Array();
var EveryDayAward = new Array();
var TotalHeight = -10;
function ClearAwardMc()
{
    for(var i in AllAwardMc)
    {
        AllAwardMc[i].removeMovieClip()
    }
    LoginAwardList.forceCorrectPosition();
}

function AddAwardItem(n)
{
    var item_list = AwardSlideItem.attachMovie("list_icons", "item_list", AwardSlideItem.getNextHighestDepth());
    item_list._y = TotalHeight;
    item_list.play();
    for (var i = 0; i <= 6; ++i)
    {
        var item = item_list["item" + (i + 1)];
        EveryDayAward[n+i] = item;
        item._visible = false;
    }
    TotalHeight = TotalHeight + item_list._height - 0;
    AllAwardMc.push(item_list);
}

function UpdateLoginListItemRedPoint(type,red_point)
{
    var mc = GetListItemByType(type)
    if (mc)
    {
        var index = mc._parent.index
        if (ActivityDatas[index].red_point != undefined)
        {
            ActivityDatas[index].red_point = red_point
        }
        mc.red_point._visible = red_point
    }
}


var lastSelect = undefined;
function UpdateLoginAwardPanel( data )
{
    LoginAwardData = data
    UpdateLoginListItemRedPoint(LOGIN_AWARD,data.red_point)
    LoginAwardPanel.title_bar.title_txt.text = data.title;
    for (var i = 1; i <= 31; ++i)
    {
        var itemMc = EveryDayAward[i];
        if (itemMc == undefined)
        {
            AddAwardItem(i);
            itemMc = EveryDayAward[i];
        }

        var info = data.infos[i - 1];
        if (info == undefined)
        {
            itemMc._visible = false;
        }else
        {
            itemMc.viptab._visible = false
            itemMc._visible = true;
            itemMc.data = info

            if (info.state == 2)    //have get
            {
                itemMc.gotoAndStop(1);
            }else if (info.state == 1)  //can get
            {
                itemMc.gotoAndStop(2);
            }else if (info.state == 0) 	//can't get
            {
                itemMc.gotoAndStop(2);
            }

            SetLoginAwardIcon(itemMc, info); //only show one award
            CTextAutoSizeTool.SetSingleLineText(itemMc.num_text, info.awards[0].countTxt, 22, 18);

            // cehua
            itemMc.icon_date._visible = false

            if (info.state == 2)    //have get
            {
                itemMc.received._visible 	= true;
                itemMc.effect._visible 		= false;
                itemMc.icon_gacha._visible 	= false;
            }else if (info.state == 1)  //can get
            {
                itemMc.received._visible = false;
                itemMc.effect._visible = true;
                itemMc.icon_gacha.add_gacha_txt.text = data.add_lottery_txt;
                //itemMc.icon_gacha.gotoAndStop(1);
            }else if (info.state == 0) 	//can't get
            {
                itemMc.received._visible = false;
                itemMc.effect._visible = false;
                itemMc.icon_gacha.add_gacha_txt.text = data.add_lottery_txt;
                //itemMc.icon_gacha.gotoAndStop(2);
            }
            itemMc.onPress = function()
            {
                this._parent._parent._parent.onPressedInListbox();
                this.Press_x = _root._xmouse;
                this.Press_y = _root._ymouse;
            }

            itemMc.onReleaseOutside = function()
            {
                this._parent._parent._parent.onReleasedInListbox();
            }
            itemMc.onRelease = function()
            {
                this._parent._parent._parent.onReleasedInListbox();
                if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
                {
                    if (lastSelect != undefined)
                    {
                        lastSelect.item_icon.SelectIcon(false);
                    }
                    this.item_icon.SelectIcon(true)
                    lastSelect = this;

                    if (this.data.state != 1) //can not get award
                    {
                        fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.item_icon.IconData.res_type + "\2" + this.item_icon.IconData.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
                    }

                    if (this.data.state == 1) //can get award
                    {
                        fscommand("CityActivityCmd", "GetLoginAward" + "\2" + this.data.day);
                    }else
                    {
                        //this.item_icon.SelectIcon(false);
                        fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
                    }
                }
            }
        }
    }
    LoginAwardList.SimpleSlideOnLoad();

    LoginAwardList.onEnterFrame = function()
    {
        LoginAwardList.OnUpdate();
    }
    LoginAwardList.forceCorrectPosition();
}

function SetLoginAwardIcon(mc, info)
{
    var icon_data = info.awards[0].icon_data;
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

        mc.item_icon._width = w;
        mc.item_icon._height = h;
    }
    mc.item_icon.IconData = icon_data;
    if(mc.item_icon.UpdateIcon)
    {
        mc.item_icon.UpdateIcon();
    }
}

//----------------------------------------------------
function SetUnread(i, isUnread)
{
	g_tabBtns[i].red_point._visible = isUnread;
}


//----------------------------------------------------
// shouchong begin

function SetFirstBuyButttonState(flag)
{
    if (flag == 1)
    {
        _root.ui_firstbuy.add_star._visible = true
    }
    else
    {
        _root.ui_firstbuy.add_star._visible = false
    }
}

function FirstPay_InitAwards(info)
{
	var rewards = info.rewards;
	var viewList = _root.ui_firstbuy.worth.awards.ViewList;
	viewList.rewards = rewards;
	viewList.clearListBox();
	viewList.initListBox("icon_Cargo_body", 0, false, true);
	viewList.enableDrag(rewards.length > 4 ? true : false);
	viewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	viewList.onItemEnter = function(mc, itemKey)
	{

		if (mc.item_icon.icons == undefined)
		{
			var w = mc.item_icon._width;
			var h = mc.item_icon._height;
			mc.item_icon._alpha = 100
			var _info = mc._parent.rewards[itemKey]
			if (_info.res_type == 'hero')
			{
				mc.item_icon.loadMovie("CommonHeros.swf");
				var iconidx = _info.iconInfo.icon_index
				mc.item_icon.icons.hero_icons.gotoAndStop(iconidx)
				mc.star._visible = true
				mc.txt_num._visible = false
				mc.star.gotoAndStop(_info.count)
				mc.item_icon.icons.bg.gotoAndStop("quality_"+_info.iconInfo.icon_quality)

			}
			else
			{
				mc.item_icon.loadMovie("CommonIcons.swf");
				var iconidx = _info.iconInfo.icon_index
				mc.item_icon.icons.icons.gotoAndStop(iconidx)
				mc.star._visible = false
				mc.txt_num._visible = true
				mc.txt_num.text = ""+_info.count
				mc.item_icon.icons.bg.gotoAndStop("quality_"+_info.iconInfo.icon_quality)
			}

			mc.item_icon._width = w;
			mc.item_icon._height = h;
		}
	}

	for(var i = 0; i < rewards.length; ++i)
	{
		viewList.addListItem(i, false, false);
	}
	viewList.forceCorrectPosition();
}
// shouchong end
//---------------------------------------------------

//---------------------------------
//Excavate
var excavatePanel = _root.excavate;
var excavateAttackFlag = false
function updateExcavateInfo(data)
{
    UpdateLoginListItemRedPoint(EXCAVATE,data.red_point)
    excavatePanel.buy.btn_addstar.credit = data.cost_credit
    excavatePanel.buy.btn_addstar.credit_num.text = data.cost_credit
    excavatePanel.left_num.text = data.leftNum

    var strNum = data.min_credit.toString()
    var arrayNum = strNum.split("")
    var nLength = arrayNum.length
    excavatePanel.progress.gotoAndStop(nLength - 1)
    setCreditNum(excavatePanel.progress.cur_num,data.min_credit);
    setMaxCreditNum(excavatePanel.progress.max_num,data.max_credit);
    if (data.leftNum > 0 && data.left_time > 0)
    {
        excavatePanel.buy._visible = true;
        excavatePanel.no_star._visible = false;
    }
    else
    {
        excavatePanel.buy._visible = false;
        excavatePanel.no_star._visible = true;
    }
    if(!excavateAttackFlag)
    {
        excavatePanel.shipAttack._visible = false;
        excavatePanel.shipIdle._visible = true;
    }
}

function setCreditNum(mc,credit)
{
    var strNum = credit.toString();
    var arrayNum = strNum.split("");

    var nLength = arrayNum.length;
    for(var i = 0; i < nLength; ++i)
    {
        var temp = Number(arrayNum[i]);
        mc["num" + i].gotoAndStop(temp + 1);
    }
}

function setMaxCreditNum(mc,credit)
{
    var strNum = credit.toString();
    var arrayNum = strNum.split("");

    var nLength = arrayNum.length;
    mc.gotoAndStop(nLength - 1)
    for(var i = 0; i < nLength; ++i)
    {
        var temp = Number(arrayNum[i]);
        mc["num" + i].gotoAndStop(temp + 1);
    }
}

function UpdateExcavateTime(data)
{
    excavatePanel.tip.txt.text = data.timetext
    if (data.excavateTime <= 0 || data.leftNum <= 0)
    {
        excavatePanel.buy._visible = false;
        excavatePanel.no_star._visible = true;
    }
    else
    {
        excavatePanel.buy._visible = true;
        excavatePanel.no_star._visible = false;
    }
}

function ShowBuyCreditPanel()
{
    _root.popup_logout._visible = true;
    _root.popup_logout.gotoAndPlay("opening_ani");
}

function Init7Day(data)
{
    var topmc = _root.seven_dayaward.content
    for (var i=1; i<=data.fetched; i++)
    {
        topmc["c"+i].gotoAndStop(2)
    }
    for (var i=data.fetched+1; i<=7; i++)
    {
        topmc["c"+i].gotoAndStop(1)
    }
    if (data.fetched != 7)
    {
        topmc["c7"].gotoAndStop(3)
    }
    for (var i=1; i<=7; i++)
    {
        var themc = topmc["c"+i]
        themc.txt1.text = data.info[i-1].strDayI
        themc.txt2.text = data.info[i-1].strName

        var pmc = themc.item.item_icon
        pmc._alpha = 100
        if(pmc.icons==undefined)
        {
            pmc.loadMovie("CommonIcons.swf")
        }
        pmc.IconData=data.info[i-1].iconData
        //if(pmc.UpdateIcon) 
        //{
        //   pmc.UpdateIcon()
        //}
        pmc.icons.icons.gotoAndStop(pmc.IconData.icon_index)

        themc.item.txt_num.text = data.info[i-1].cnt
    }

    Init7DayBtn(data)
}

function Init7DayBtn(data)
{
    var txtmc = _root.seven_dayaward.btn_receive.mc.txt
    
    //UpdateLoginListItemRedPoint(SEVEN_DAYAWARD,data.canReceive)
    if (data.canReceive)
    {
        txtmc.text = data.strCanReceive
        _root.seven_dayaward.btn_receive.onRelease = function()
        {
            fscommand("CityActivityCmd", "On7DayBtn" + "\2" + 1);
            this.onRelease = null
        }
    }
    else
    {
        txtmc.text = data.strReceived
        _root.seven_dayaward.btn_receive.mc.gotoAndStop("disabled")
        _root.seven_dayaward.btn_receive.onRelease = function()
        {
            fscommand("CityActivityCmd", "On7DayBtn" + "\2" + 0);
        }
    }
}

_root.seven_dayaward.btn_info.onRelease = function()
{
    fscommand("ShowCommonRuleDescPop", "LC_RULE_NEWPLAYER_SIGNIN_NAME" + "\2" + "LC_RULE_NEWPLAYER_SIGNIN_DESC");
}

///////////////////////////////////////////////////////////////////////
//everyday
var everydayPanel = _root.everyday

everydayPanel.item_1.btn_buy.onRelease = function()
{
    fscommand("CityActivityCmd","GetEverydayAward" + "\2" + this._parent.data.id)
}

function UpdateSevenGoalRedPoint(red_point)
{
    UpdateLoginListItemRedPoint(SEVEN_GOAL,red_point)
}

function UpdateEverydayRed_piont(red_point)
{
    UpdateLoginListItemRedPoint(EVERYDAY,red_point)
}

function InitEverydayAwardLayer(datas)
{
    for (var i = 0 ;i < datas.length ; i ++)
    {
        var item = everydayPanel["item_" + datas[i].id]
        item.data = datas[i]
        if (datas[i].state == 1)
        {
            item.buy.gotoAndStop("Idle")
        }
        else
        {
            item.buy.gotoAndStop("disabled")
        }
        if (datas[i].id == 3)
        {
            item.buy.name_txt.text = datas[i].cur_count + "/" + datas[i].all_count
        }

        item.buy.hitZone.onRelease = function()
        {
            trace("xxxxxxxxxx")
            trace(this._parent._parent.data.id)
            if (this._parent._parent.data.state == 1)
            {

                fscommand("CityActivityCmd","GetEverdyAwardData" + "\2" + this._parent._parent.data.id)
            }
            else
            {
                fscommand("CityActivityCmd","ShowMessageBox" + "\2" + (this._parent._parent.data.id + 1))
            }

        }
        item.btn_info.onRelease = function()
        {
            fscommand("CityActivityCmd","ShowGiftbagData" + "\2" + this._parent.data.id)
        }
    }
}

function UpdatePrice(data)
{
    trace("dddddddddddddddddd")
    var mc = everydayPanel.item_2
    mc.buy.price_txt.text = data.price
}

function ShowGiftbagLayer(info)
{
    _root.bag._visible = true;
    _root.bag.gotoAndPlay("opening_ani")
    _root.bag.title.name_txt.text = info.titleText
    var datas = info.awardInfo
    var listBx = _root.bag.list.listView;
    listBx.datas = datas
    listBx.clearListBox()
    listBx.initListBox("Gift_Icon",0,false,true)
    listBx.enableDrag(true)
    listBx.onEnterFrame = function()
    {
        this.OnUpdate()
    }
    listBx.onItemEnter = function(mc,index)
    {
        var itemData = this.datas[index]
        mc.data = itemData
        SetAwardIcon(mc.icon_bar,itemData.iconInfo)
        mc.icon_bar.txt_num.text = itemData.count
      }
    for (var i = 0; i < datas.length; i ++)
    {
        listBx.addListItem(i,false,false)
    }
}

_root.bag.btn_shield.onRelease = function()
{
    this._parent._visible = false
}

function SetAwardIcon(mc, info)
{
    var icon_data = info;
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

        mc.item_icon._width = w;
        mc.item_icon._height = h;
    }
    mc.item_icon.IconData = icon_data;
    if(mc.item_icon.UpdateIcon)
    {
        mc.item_icon.UpdateIcon();
    }
}


everydayPanel.btn_info.onRelease = function()
{
    fscommand("ShowCommonRuleDescPop", "LC_RULE_NEWPLAYER_GIFTBAG_NAME" + "\2" + "LC_RULE_NEWPLAYER_GIFTBAG_DESC");
}

function excavatorAttackAnmation()
{
    excavateAttackFlag = true
    excavatePanel.shipAttack._visible = true
    excavatePanel.shipIdle._visible = false
    excavatePanel.shipAttack.gotoAndPlay("opening_ani")
}

excavatePanel.shipAttack.attackOver = function()
{
    fscommand("CityActivityCmd","AttackOver")
    this._visible = false
    excavateAttackFlag = false
    excavatePanel.shipIdle._visible = true
}

_root.popup_logout.btn_ok.onRelease = function()
{
    _root.popup_logout.gotoAndPlay("closing_ani");
}

_root.popup_logout.btn_close.onRelease = function()
{
    _root.popup_logout.gotoAndPlay("closing_ani")
    fscommand("CityActivityCmd","gotoStore")
}

excavatePanel.buy.btn_addstar.onRelease = function()
{
    fscommand("CityActivityCmd","buy_excavate" + "\2" + this.credit)
}

excavatePanel.no_star.onRelease = function()
{
    fscommand("CityActivityCmd","ShowMessageBox" + "\2" + 1)
}

excavatePanel.btn_info.onRelease = function()
{
    fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_EXCAVATOR_TITLE" + "\2" + "LC_RULE_RULE_EXCAVATOR_DESC");
}
