
var MainUI 			= _root.ui_all;
var CloseBtn 		= _root.top.btn_close;

var ActivityList	= MainUI.board1.view_list;

var ActivityDatas 			= new Array();

var LOGIN_AWARD = 0;
var CurSelectIndex = undefined;

var LoginAwardPanel = MainUI.login_award;

this.onLoad = function()
{
	InitActivityList();
}

CloseBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_cancel");
	MainUI.gotoAndPlay("closing_ani");
	_root.top.gotoAndPlay("closing_ani");
}

MainUI.OnMoveOutOver = function()
{
	fscommand("GotoNextMenu", "GS_MainMenu");
}

/*
datas.activity = {}
datas.activity.type = login_award;
datas.activity.time = undefined;
datas.activity.texts = "login_award"
*/

function InitActivityList()
{
	if (ActivityDatas == undefined)
	{
		return;
	}
	ActivityList.clearListBox();
	ActivityList.setSpecialItemHeight("event_board1_menu0_2",0);
	ActivityList.initListBox("activity_board1_menu0", 0, true, true);
	ActivityList.enableDrag(true);
	ActivityList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ActivityList.onItemEnter = function(mc, index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetItemInfo(mc, index_item);
	}
	ActivityList.onListboxMove = undefined;
	ActivityList.onItemMCCreate = undefined;
	ActivityList.onItemLeave = undefined;

	for (var i = 1 ; i <= ActivityDatas.length; ++i)
	{
		ActivityList.addListItem(i, false, false);
	}

	//default select first
	
}

function SetItemInfo(mc, index_item)
{
	var item = undefined;
	var data = ActivityDatas[index_item];
	mc.index = index_item;
	if (CurSelectIndex == undefined and index_item == 0)
	{
		CurSelectIndex = index_item;
	}
	if (CurSelectIndex == index_item)
	{
		mc.isSpecial = true;
		mc.gotoAndStop(2);
		mc.ItemHeight = ActivityList._getItemHeight(mc.have_select);
		item = mc.have_select;
	}else
	{
		mc.isSpecial = false;
		mc.gotoAndStop(1);
		mc.ItemHeight = ActivityList._getItemHeight(mc.not_select);
		item = mc.not_select;
	}

	if (item != undefined)
	{
		if (data.time == undefined)
		{
			item.icon_title.gotoAndStop(2);
		}else
		{
			item.icon_title.gotoAndStop(1);
			item.count_down_txt.text = GetTimeText(data.time);	
		}
		item.event_icon.gotoAndStop(data.icon_id);
		item.icon_title.name_txt.text = data.item_title;
		item.red_point._visible 	= data.red_point == true ? true : false;
		
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
					CurSelectIndex = this._parent.index;
					UpdateSubPanel( );
					ActivityList.needUpdateVisibleItem();
				}
			}
		}
	}

}

function UpdateSubPanel( )
{
	var data = ActivityDatas[CurSelectIndex];
	if (data == undefined)
	{
		return;
	}
	switch(data.type)
	{
		case LOGIN_AWARD:
			LoginAwardPanel._visible = true;
			LoginAwardList.forceCorrectPosition();
			UpdateLoginAwardPanel(data);
		break;
		default:
		break;
	}
}

function UpdateActivitys( datas )
{

	trace("-------UpdateActivitys-------");
	if(datas.length > ActivityDatas.length)
	{

		for(var i = ActivityDatas.length; i < datas.length; i++)
		{
			ActivityList.addListItem(i + 1, false, false);	
		}
	}else if(datas.length < ActivityDatas.length)
	{
		for(var i = datas.length; i < ActivityDatas.length; i++)
		{
			ActivityList.eraseItem(i + 1);
		}
	}
	ActivityDatas = datas;
	ActivityList.needUpdateVisibleItem();
	UpdateSubPanel();
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
	for (var i = 0; i <= 4; ++i)
	{
		var item = item_list["item" + (i + 1)];
		EveryDayAward[n+i] = item;
		item._visible = false;
	}
	TotalHeight = TotalHeight + item_list._height - 25;
	AllAwardMc.push(item_list);
}

var lastSelect = undefined;
function UpdateLoginAwardPanel( data )
{
	LoginAwardPanel.title_txt.text = data.title;
	LoginAwardPanel.times_txt.text = data.sign_day;

	LoginAwardPanel.gacha_btn.gacha_txt.text = data.lottery_btn_txt;
	LoginAwardPanel.gacha_btn.onRelease = function()
	{
		fscommand("PlaySound","sfx_ui_selection_1");
		fscommand("GoToNext","GoToLottery");
	}
	//ClearAwardMc();
	//TotalHeight = -10;
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
			itemMc._visible = true;
			itemMc.data = info
			SetLoginAwardIcon(itemMc, info); //only show one award
			itemMc.num_text.text = info.awards[0].count;

			itemMc.icon_date.num_txt.text = info.day_txt;

			/*var week = info.day % 7;
			if (week == 2 or week == 0)
			{
				itemMc.icon_date._visible = true;
				itemMc.icon_date.num_txt.text = info.day;
			}else
			{
				itemMc.icon_date._visible = false;
			}*/
			
			if (info.is_gacha)
			{
				itemMc.icon_gacha._visible = true;
			}else
			{
				itemMc.icon_gacha._visible = false;
			}
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
/*	for (var i = 1; i <= 31; i++)
	{
		var info = data.infos[i - 1];
		
		if (info == undefined)
		{
			var mc = LoginAwardPanel["item" + i];
			mc._visible = false;
		}else
		{
			var mc = LoginAwardPanel["item" + info.day];
			mc._visible = true;
			mc.data = info
			SetLoginAwardIcon(mc, info); //only show one award
			mc.num_text.text = info.awards[0].count;

			var week = info.day % 7;
			if (week == 2 or week == 0)
			{
				mc.icon_date._visible = true;
				mc.icon_date.num_txt.text = info.day;
			}else
			{
				mc.icon_date._visible = false;
			}
			
			if (info.is_gacha)
			{
				mc.icon_gacha._visible = true;
			}else
			{
				mc.icon_gacha._visible = false;
			}
			if (info.state == 2)    //have get
			{
				mc.received._visible 	= true;
				mc.effect._visible 		= false;
				mc.icon_gacha._visible 	= false;
			}else if (info.state == 1)  //can get
			{
				mc.received._visible = false;
				mc.effect._visible = true;
				mc.icon_gacha.gotoAndStop(1);
			}else if (info.state == 0) 	//can't get
			{
				mc.received._visible = false;
				mc.effect._visible = false;
				mc.icon_gacha.gotoAndStop(2);
			}
			
			mc.onRelease = function()
			{
				
				if (lastSelect != undefined)
				{
					lastSelect.item_icon.SelectIcon(false);
				}
				this.item_icon.SelectIcon(true)
				lastSelect = this;

				if (this.data.state != 1) //can get award
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
	}*/
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

function UpdateLotteryTimes( times )
{
	LoginAwardPanel.tips._visible = times > 0;
	LoginAwardPanel.tips.num_txt.text = times;
}

function GetTimeText(time)
{
	var seconed = time % 60;
	time = Math.floor(time / 60);

	var minutes = time % 60;
	time = Math.floor(time / 60);

	var hour = time % 24;
	time = Math.floor(time / 24);

	var day = time % 30;
	time = Math.floor(time / 30);

	var month = time % 12;
	time = Math.floor(time / 12);

	var year = time

	var ret = "";
	if (0 != year)
	{
		ret = ret + year + "Y";
	}
	if (0 != month)
	{
		ret = ret + month + "M";
	}
	if (0 != day)
	{
		ret = ret + day + "d";
	}
	if (0 != hour)
	{
		ret = ret + hour + "h";
	}
	if (0 != minutes)
	{
		ret = ret + minutes + "min";
	}
	if (ret == "")
	{
		ret = "<1min";
	}
	return ret;
}