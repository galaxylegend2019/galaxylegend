var MainUI 		= _root.ui_all;
var CloseBtn	= _root.top.btn_close;

var EventList 		= MainUI.board1.event_list;

var AwardInfoList 	= MainUI.board2.event_list;
var AwardSlideItem 	= MainUI.board2.event_list.slideItem;

var TotalHeight 	= 0;

var AwardItemList 	= undefined;

var EventDatas = undefined;

var CurSelectIndex = undefined;

var AllAwardMc = new Array();

var Milliseconds = 0;

var CurSecond = 0;

var LocalTexts = undefined;

var CurBoxList = undefined;

this.onLoad = function()
{

	/*EventDatas = new Array(10);

	for(var i = 0; i < EventDatas.length; ++i)
	{
		EventDatas[i] = new Object();
		EventDatas[i].id = (i % 3) + 1;
		EventDatas[i].state = "ready";
		EventDatas[i].title = "xxxxxx" + i;
		EventDatas[i].desc = "aaaaaa" + i;
		EventDatas[i].awards = new Array();
		EventDatas[i].start_time 	= 200 + i * 50;
		EventDatas[i].end_time 	= 400 + i * 50;
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

	InitEventList(EventDatas);*/
}



CloseBtn.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
	_root.top.gotoAndPlay("closing_ani");
	MainUI.bg1.gotoAndPlay("closing_ani");
}

function InitTexts( texts )
{
	LocalTexts = texts;
}

MainUI.OnMoveOutOver = function()
{
	fscommand("ExitBack", "");
}

/*RankBtn.onRelease = function()
{
	if (CurSelectIndex == undefined)
	{
		return;	
	}
	var event_id = EventDatas[CurSelectIndex].id;
	fscommand("WorldMapEventCmd", "ShowRank" + "\2" + event_id);
}*/

function InitEventList(datas)
{
	trace("--------------InitEventList-----------------")
	EventDatas = datas.event_data;
	CurSecond = datas.cur_time;
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
		AwardInfoList._visible = true;
		//InitAwardList();
		UpdateEventSelectState();
		if (EventDatas[CurSelectIndex] == undefined)
		{
			CurSelectIndex = 1;
		}
		fscommand("WorldMapEventCmd", "RefreshAwardList" + "\2" + EventDatas[CurSelectIndex].id);
	}else
	{
		AwardInfoList._visible = false;
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
	item.event_icon.gotoAndStop(data.icon_id);
	item.info.name_txt.text = data.title;
	//MapEvent only use frame 1
	item.info.gotoAndStop(1);
	if (item.info.count_down_txt)
	{
		item.info.count_down_txt.html = true;
		item.info.count_down_txt.htmlText = GetCountDownTime(data);
	}

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
					//InitAwardList();
					fscommand("WorldMapEventCmd", "RefreshAwardList" + "\2" + EventDatas[CurSelectIndex].id);
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
		time_text = "<font color='#22ff59'>" + LocalTexts.EventReadyText;
	}else if (data.state == "start")
	{
		/*var dates 	= data.dates.end_time;
		event_time = Date.UTC(dates.year, dates.month, dates.day, dates.hour, dates.minute, dates.second);
		trace("curTime=" + curTime)
		trace("event_time =" + event_time)*/
		event_time = data.end_time;
		time_text = "<font>" + LocalTexts.EventEndText;
	}else if (data.state == "expire")
	{
		return "<font color='#5dafe0'>" + LocalTexts.EventOverText + "</font>";
	}
	var count_down = event_time - CurSecond;
	if (count_down < 0)
	{
		count_down = 0;
	}
	time_text = time_text + GetTimeText(count_down) + "</font>";
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
	CurBoxList = undefined;
}

function SetArtNumber(mc, num)
{
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;
	mc.gotoAndStop(nLength);
	for(var i = 0; i < nLength; ++i)
	{
		var temp = Number(arrayNum[i]);
		mc["r_" + i].gotoAndStop(temp + 1);
	}
}

function AddBossBloodBarItem(percent)
{
	percent = percent + 1;
	var blood_bar = AwardSlideItem.attachMovie("list_boos", "blood_bar", AwardSlideItem.getNextHighestDepth());
	blood_bar.blood_bar.gotoAndStop(percent);
	blood_bar.percent.percent_txt.text = percent + "%";
	blood_bar._y = TotalHeight;
	TotalHeight = TotalHeight + blood_bar._height;
	AllAwardMc.push(blood_bar);
}

function AddMyScoresItem(num)
{
	var my_scores = AwardSlideItem.attachMovie("title_list4", "my_scores", AwardSlideItem.getNextHighestDepth());
	SetArtNumber(my_scores.scores, num);
	my_scores._y = TotalHeight;
	TotalHeight = TotalHeight + my_scores._height;
	AllAwardMc.push(my_scores);
}

function AddEventDescItem()
{
	var event_desc = AwardSlideItem.attachMovie("text_info_list", "event_desc", AwardSlideItem.getNextHighestDepth());
	//event_desc.desc_txt.htmlText = ""

	event_desc._y = TotalHeight;
	TotalHeight = TotalHeight + event_desc.desc_txt.textHeight;
	AllAwardMc.push(event_desc);
}

function AddAwardBoxItem(data)
{
	var box_data = data.info.awards_got;
	trace(data.info.score)
	trace(data.awards.max_score)
	var percent = Math.ceil(data.info.score / data.awards.max_score * 100);
	if (percent > 100)
	{
		percent = 100;
	}
	trace("percent=" + percent)
	var box_list = AwardSlideItem.attachMovie("box_info_list", "box_list", AwardSlideItem.getNextHighestDepth());
	box_list._y = TotalHeight;
	TotalHeight = TotalHeight + box_list._height;
	AllAwardMc.push(box_list);
	CurBoxList = box_list;
	if (percent != undefined)
	{
		box_list.scores_bar.gotoAndStop(percent + 1);
	}else{
		box_list.scores_bar.gotoAndStop(1);
	}
	//value state 
	for(var i = 1; i <= 3; i++)
	{
		var state = box_data[i - 1];
		trace("state=" + state)
		var box_mc = box_list["box" + i];
		if (state == 1)
		{
			box_mc.gotoAndStop(1);
		}
		else if (state == 2)
		{
			box_mc.gotoAndStop(2);
			box_list["star" + i].gotoAndStop(2);
		}
		else if (state == 3)
		{
			box_mc.gotoAndStop(3);
			box_list["star" + i].gotoAndStop(2);
		}
		
		box_list["txt_star" + i].text = data.awards.box_awards[i - 1].threshold;

		
		box_mc.index = i;
		box_mc.state = state;

		box_mc.onPress = function()
		{
			this._parent._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		box_mc.onReleaseOutside = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
		}

		box_mc.onRelease = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				var event_id = EventDatas[CurSelectIndex].id;
				if (this.state == 1 or this.state == 3)
				{
					fscommand("WorldMapEventCmd","ShowBoxAward" + "\2" + event_id + "\2" + this.index);	
				}else if (this.state == 2)
				{
					//TODO:Get Box Award
					fscommand("WorldMapEventCmd","GetBoxAwards" + "\2" + event_id + "\2" + this.index);
				}
				
			}
		}

	}
}

function SetBoxListStar()
{
	if (CurBoxList == undefined)
	{
		return
	}
	for(var i = 1; i <= 3; i++)
	{
		CurBoxList["txt_star" + i].text = i;
	}
}

function AddRuleTitleItem()
{
	var rule_title = AwardSlideItem.attachMovie("title_list1", "rule_title", AwardSlideItem.getNextHighestDepth());
	rule_title._y = TotalHeight;
	TotalHeight = TotalHeight + rule_title._height;
	AllAwardMc.push(rule_title);
}

function AddRuleDescItem(rule)
{
	var rule_desc = AwardSlideItem.attachMovie("list_event_1", "rule_desc", AwardSlideItem.getNextHighestDepth());
	rule_desc.rule_txt.html = true;
	rule_desc.rule_txt.htmlText = rule.desc;
	//rule_desc.rule_txt.text = rule.desc;

	rule_desc.point_txt.text = "X" + rule.point;

	rule_desc._y = TotalHeight;
	TotalHeight = TotalHeight + rule_desc._height;
	AllAwardMc.push(rule_desc);
}

function AddMyRankItem(num)
{
	var my_rank = AwardSlideItem.attachMovie("title_list3", "my_rank", AwardSlideItem.getNextHighestDepth());
	var symbol = false;   // true : > , false : <
	if (num < 10)
	{
		symbol = 2;
		num = 10;
	}else if (num >= 10 and num < 100)
	{
		symbol = 2;
		num = 100;
	}else if (num >= 100 and num < 500)
	{
		symbol = 2;
		num = 500;
	}else if (num >= 500 and num < 1000)
	{

		symbol = 2;
		num = 1000;

	}else
	{
		symbol = 1;
		num = 1000;
	}
	my_rank.symbol.gotoAndStop(symbol);
	trace("---------RankNum-----------" + num)
	SetArtNumber(my_rank.scores, num);

	my_rank._y = TotalHeight;
	TotalHeight = TotalHeight + my_rank._height;
	AllAwardMc.push(my_rank);
}

function AddRankAwardTitleItem()
{
	var rank_title = AwardSlideItem.attachMovie("title_list2", "rank_title", AwardSlideItem.getNextHighestDepth());
	

	rank_title._y = TotalHeight;
	TotalHeight = TotalHeight + rank_title._height;
	AllAwardMc.push(rank_title);
}

function AddRankSmallTitleItem(desc)
{
	var rank_small_title = AwardSlideItem.attachMovie("list_event_2", "rank_small_title", AwardSlideItem.getNextHighestDepth());
	rank_small_title.title_txt.html = true;
	rank_small_title.title_txt.htmlText = desc;

	rank_small_title._y = TotalHeight;
	TotalHeight = TotalHeight + rank_small_title._height;
	AllAwardMc.push(rank_small_title);
}

function AddAwardLineItem()
{
	var line = AwardSlideItem.attachMovie("list_line", "line", AwardSlideItem.getNextHighestDepth());

	line._y = TotalHeight;
	TotalHeight = TotalHeight + line._height;
	AllAwardMc.push(line);
}

function SetAwardIcon(mc, icon_data)
{
	if (mc.item_icon.icons == undefined)
	{
		var w = mc.item_icon._width;
		var h = mc.item_icon._height;
		mc.item_icon.loadMovie("CommonIcons.swf");
		mc.item_icon._width = w;
		mc.item_icon._height = h;
	}
	mc.item_icon.IconData = icon_data;
	if(mc.item_icon.UpdateIcon)
	{ 
		mc.item_icon.UpdateIcon(); 
	}
}

function AddRankAwardItem(award)
{
	var award_item = AwardSlideItem.attachMovie("list_event_3", "award_item", AwardSlideItem.getNextHighestDepth());
	/*var IconDatas = new Object();
	IconDatas.icon_index = 106;
	IconDatas.res_type = "item";
	IconDatas.icon_quality = 1;*/

	SetAwardIcon(award_item.award, award.icon_data);
	award_item.name_txt.text = award.name;
	award_item.count_txt.text = "X" + award.num;

	award_item._y = TotalHeight;
	TotalHeight = TotalHeight + award_item._height;
	AllAwardMc.push(award_item);
}

function AddShowAllRankAwardItem()
{
	var show_rank = AwardSlideItem.attachMovie("button_rank_main", "show_rank", AwardSlideItem.getNextHighestDepth());
	show_rank.btn_rank.onPress = function()
	{
		this._parent._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}

	show_rank.btn_rank.onReleaseOutside = function()
	{
		this._parent._parent._parent.onReleasedInListbox();
	}

	show_rank.btn_rank.onRelease = function()
	{
		this._parent._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			trace("--------Click RankBtn---------");
			//fscommand("GoToNext","ShowRankAward");
			fscommand("WorldMapEventCmd","ShowRankAward" + "\2" + EventDatas[CurSelectIndex].id);
		}
	}

	show_rank._y = TotalHeight;
	TotalHeight = TotalHeight + show_rank._height;
	AllAwardMc.push(show_rank);
}

function InitAwardList(  )
{
	if (CurSelectIndex == undefined)
	{
		return;
	}
	TotalHeight = 0;
	ClearAwardMc();
	var data = EventDatas[CurSelectIndex];
	if (data == undefined or data.info == undefined)
	{
		return;
	}
	//TODO: Add boss blood info
	if (data.info.type == "")
	{
		//AddBossBloodBarItem(30);	
	}
	
	AddMyScoresItem(data.info.score);


	AddAwardBoxItem(data);

	AddRuleTitleItem();

	for (var i = 0; i < data.rules.length; ++i)
	{
		AddRuleDescItem(data.rules[i]);
	}
	


	AddMyRankItem(data.info.rank);


	//AddRankAwardTitleItem();
	
	

	var first_award = data.awards.rand_awards[0];
	AddRankSmallTitleItem(first_award.title);
	for (var i = 0; i < first_award.data.length; i++)
	{
		var award = first_award.data[i];
		trace(award)
		AddRankAwardItem(award);
		if (i == first_award.data.length - 1)
		{
			break;
		}
		AddAwardLineItem();
	}

	AddShowAllRankAwardItem();

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