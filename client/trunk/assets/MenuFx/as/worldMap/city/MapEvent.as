var MainUI 		= _root.ui_all;
var CloseBtn	= _root.top.btn_close;

var EventList 		= MainUI.board1.event_list;

var AwardInfoList 	= MainUI.board2.event_list;
var AwardSlideItem 	= MainUI.board2.event_list.slideItem;

var RankBtn 		= MainUI.btn_rank;

var TotalHeight 	= 0;

var AwardItemList 	= undefined;

var EventDatas = undefined;

var CurSelectIndex = undefined;

var AllAwardMc = new Array();

var Milliseconds = 0;

var CurSecond = 0;

var LocalTexts = undefined;

this.onLoad = function()
{

/*	EventDatas = new Array(10);

	for(var i = 0; i < EventDatas.length; ++i)
	{
		EventDatas[i] = new Object();
		trace("222222");
		trace(EventDatas[i])
		EventDatas[i].id = (i % 3) + 1;
		EventDatas[i].state = (i % 3) + 1;
		EventDatas[i].title = "xxxxxx" + i;
		EventDatas[i].desc = "aaaaaa" + i;
		EventDatas[i].awards = new Array();
		EventDatas[i].time 	= 200 + i * 50;
		for (var j = 0; j < (i % 5) + 1; j++)
		{
			var list = new Array();
			for( var k = 0; k < (i % 5) + 1; k++)
			{
				var award = new Object();
				var icon_data = new Object();
				icon_data.res_type = "item"
				icon_data.res_id = 110 + i + j;
				icon_data.icon_index = "item_" + (110 + i + j)
				icon_data.icon_quality = j
				award.icon_data = icon_data;
				award.num 	= i + j;
				list.push(award);	
			}
			EventDatas[i].awards.push(list);
		}

	}

	InitEventList();*/
}



CloseBtn.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
}

function InitTexts( texts )
{
	LocalTexts = texts;
}

MainUI.OnMoveOutOver = function()
{
	fscommand("ExitBack", "");
}

RankBtn.onRelease = function()
{
	if (CurSelectIndex == undefined)
	{
		return;	
	}
	var event_id = EventDatas[CurSelectIndex].id;
	fscommand("WorldMapEventCmd", "ShowRank" + "\2" + event_id);
}

function InitEventList(datas)
{
	trace("--------------InitEventList-----------------")
	EventDatas = datas;
	if (EventDatas == undefined)
	{
		return;
	}
	EventList.clearListBox();
	EventList.setSpecialItemHeight("event_board1_menu0_2",0)
	EventList.initListBox("event_board1_menu0",0,true,true);
	EventList.enableDrag( true );
	EventList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	
	EventList.onItemEnter = function(mc, index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetEventItemInfo(mc, index_item);
	}

	EventList.onListboxMove = undefined;
	EventList.onItemMCCreate = undefined;
	EventList.onItemLeave = undefined;

	for (var i = 1; i <= EventDatas.length; i++)
	{
		EventList.addListItem(i, false, false);
	}
	if (EventDatas.length > 0)
	{
		RankBtn._visible = true;
		CurSecond = EventDatas[0].cur_time;
		InitAwardList();
		UpdateEventSelectState();
	}else
	{
		RankBtn._visible = false;
	}
}

function SetEventItemInfo(mc, index_item)
{
	var item = undefined;
	var data = EventDatas[index_item];
	mc.index = index_item;
	if (CurSelectIndex == undefined and index_item == 0)
	{
		CurSelectIndex = index_item;
	}
	if (CurSelectIndex == index_item)
	{
		mc.isSpecial=true;
		mc.gotoAndStop(2);
		mc.ItemHeight = EventList._getItemHeight(mc.have_select);
		item = mc.have_select;
	}else
	{
		mc.isSpecial = false;
		mc.gotoAndStop(1);
		mc.ItemHeight = EventList._getItemHeight(mc.not_select);
		item = mc.not_select;
	}
	item.event_icon.gotoAndStop(data.id);
	item.name_txt.text = data.title;


	item.count_down_txt.text = GetCountDownTime(data);
	

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
					CurSelectIndex = this._parent.index;
					UpdateEventSelectState();
					InitAwardList();
				}
			}
		}
	}
}

function GetCountDownTime(data)
{
	var time_text = ""
	var event_time = 0;
	if (data.state == "ready")
	{
		/*var dates 	= data.dates.start_time;
		event_time = Date.UTC(dates.year, dates.month, dates.day, dates.hour, dates.minute, dates.second);
		trace("curTime=" + curTime)
		trace("event_time =" + event_time)*/
		event_time = data.start_time;
		time_text = LocalTexts.EventReadyText;
	}else if (data.state == "start")
	{
		/*var dates 	= data.dates.end_time;
		event_time = Date.UTC(dates.year, dates.month, dates.day, dates.hour, dates.minute, dates.second);
		trace("curTime=" + curTime)
		trace("event_time =" + event_time)*/
		event_time = data.end_time;
		time_text = LocalTexts.EventEndText;
	}else if (data.state == "expire")
	{
		return LocalTexts.EventOverText;
	}
	var count_down = event_time - CurSecond;
	if (count_down < 0)
	{
		count_down = 0;
	}
	time_text = time_text + GetTimeText(count_down);
	return time_text;
}

function GetTimeText(time)
{
	//time = time / 1000;
	var year 	= Math.floor(time / (365 * 24 * 3600));
	time = time - (year * 365 * 24 * 3600);
	var month  	= Math.floor(time / (30 * 24 * 3600));
	time = time - (month * 30 * 24 * 3600);
	var day 	= Math.floor(time / (24 * 3600));
	time = time - (day * 24 * 3600);
	var hour 	= Math.floor(time / 3600);
	time = time - (hour * 3600);
	var minutes	= Math.floor(time / 60);
	var seconds = time - (minutes * 60);
	var ret = "";
	if (hour < 10)
	{
		ret = ret + "0" + hour + ":";
	}else{
		ret = ret + hour + ":";
	}

	if (minutes < 10)
	{
		ret = ret + "0" + minutes + ":";
	}else{
		ret = ret + minutes + ":";
	}

	if (seconds < 10)
	{
		ret = ret + "0" +seconds;
	}else{
		ret = ret + seconds;
	}

	return ret;
}

function UpdateEventData( datas )
{
	EventDatas = datas;
	InitAwardList();
}

function UpdateEventSelectState()
{
	EventList.needUpdateVisibleItem();
}

function ClearAwardMc()
{
	for(var i in AllAwardMc)
	{
		AllAwardMc[i].removeMovieClip()
	}
	AwardInfoList.forceCorrectPosition();

}


function InitAwardList(  )
{
	if (CurSelectIndex == undefined)
	{
		return;
	}
	var data = EventDatas[CurSelectIndex];
	TotalHeight = 0;
	ClearAwardMc();
	var award_title = AwardSlideItem.attachMovie("event_board2_title", "award_title", AwardSlideItem.getNextHighestDepth());
	award_title.title_txt.text = data.title
	award_title._y = TotalHeight;
	TotalHeight = TotalHeight + award_title._height;
	AllAwardMc.push(award_title)

	var award_desc = AwardSlideItem.attachMovie("event_board2_menu1", "award_desc", AwardSlideItem.getNextHighestDepth());
	award_desc.desc_txt.text = data.desc;
	award_desc._y = TotalHeight;
	TotalHeight = TotalHeight + award_desc.desc_txt.textHeight + 10;
	AllAwardMc.push(award_desc)
	
	/*award_item.award1._visible = false;
	award_item.award2._visible = false;
	award_item.award3._visible = false;
	award_item.award4._visible = false;*/


	for(var i = 0; i < data.awards.length; ++i)
	{
		var award_item = AwardSlideItem.attachMovie("event_board2_menu2", "award_item", AwardSlideItem.getNextHighestDepth());
		award_item._y = TotalHeight;
		TotalHeight = TotalHeight + award_item._height;	
		//award_item.index = i;

		AllAwardMc.push(award_item);



		var event_awards = data.awards[i];
		award_item.title_txt.text = event_awards.title;

		trace("event_awards=" + event_awards.data.length);
		for(var j = 0; j < 5; ++j)
		{
			//trace("yyyyyyyyyyyyyyyy=" + j);
			var award = event_awards.data[j];
			var IconMc = award_item["award" + (j + 1)];
			if (award == undefined)
			{
				IconMc._visible = false;
			}
			else
			{

				if (IconMc.item_icon.icons == undefined){
					IconMc.item_icon.loadMovie("CommonIcons.swf");
				}
				if (award.icon_data)
				{
					IconMc.item_icon.IconData = award.icon_data;
					if(IconMc.item_icon.UpdateIcon)
					{ 
						IconMc.item_icon.UpdateIcon(); 
					}
				}

				if (award.res_type == "item")
				{
					IconMc.onPress = function()
					{

						this.item_icon.SelectIcon(true);
						fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.item_icon.IconData.res_type + "\2" + this.item_icon.IconData.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
					}
					IconMc.onRelease = IconMc.onReleaseOutside = function()
					{
						this.item_icon.SelectIcon(false);
						fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
					}
				}

				IconMc.num_txt.text = award.num;
			}
		}
		/*award_item.already_get._visible = false;
		award_item.btn_get._visible = true;

		award_item.btn_get.onPress = function()
		{
			this._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		award_item.btn_get.onReleaseOutside = function()
		{
			this._parent.onReleasedInListbox();
		}

		award_item.btn_get.onRelease = function()
		{
			
			this._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				trace("-----------click award btn----------" + this._parent.index)
				this._parent.already_get._visible = true;
				this._visible = false;
			}
		}*/
	}

	AwardInfoList.SimpleSlideOnLoad();

	AwardInfoList.onEnterFrame = function()
	{
		AwardInfoList.OnUpdate();
	}
}

this.onEnterFrame = function()
{
	var curDate = new Date();
	var curMilliseconds = curDate.getTime();
	if (Milliseconds == 0)
	{
		Milliseconds = curMilliseconds;
	}
	var offset = curMilliseconds - Milliseconds;
	if (offset >= 1000)
	{
		var seconds = Math.floor(offset / 1000);
		CurSecond += seconds;
		Milliseconds += seconds * 1000;
		UpdateEventSelectState();
	}
}