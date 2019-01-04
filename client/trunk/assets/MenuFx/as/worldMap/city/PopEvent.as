var MainUI = _root.main_ui;

var EventList = MainUI.list.list_view;
var EmptyPanel = MainUI.empty;
var EventDatas = new Array(10);

var Milliseconds = 0;

var CurSeconds = 0;

_root.onLoad = function()
{
	EmptyPanel._visible = false;
	EventList._visible = false;
	MainUI.gotoAndPlay("opening_ani")
	InitEventList();
}


MainUI.btn_bg.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani")
	fscommand("FrontEventCmd","CloseUI")
}

function InitEventList(datas)
{
	EventDatas = datas;
	if (EventDatas == undefined)
	{
		return;
	}
	if (EventDatas.length == 0)
	{
		EmptyPanel._visible = true;
		EventList._visible = false;
	}else
	{
		EmptyPanel._visible = false;
		EventList._visible = true;
	}
	Milliseconds = 0;
	CurSeconds = 0;
	EventList.clearListBox();
	EventList.initListBox("EventBerList", 0, true, true);
	EventList.enableDrag(true);
	EventList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	EventList.onItemEnter = function(mc, index_item)
	{
		index_item = index_item - 1;
		SetItemInfo(mc, EventDatas[index_item]);
	}

	EventList.onItemMCCreate 	= undefined;
	EventList.onListboxMove 	= undefined;
	EventList.onItemLeave 		= undefined;
	for (var i = 1; i <= EventDatas.length; ++i)
	{
		EventList.addListItem(i, false, false);
	}
}

/*
event_type = 
planet_id =
title_txt = 
attacker_name=
attacker_icon=
defender_name=
defender_icon=
def_is_mine = 
status =
status_txt =
count_down =
*/
function SetItemInfo(mc, data)
{
	var show_mc = undefined;
	if (data.event_type == "planet_war")
	{
		mc.gotoAndStop(1);
		show_mc = mc.event;
		SetPlanetWarInfo(show_mc, data);
	}
	
}

function SetPlanetWarInfo(mc, data)
{
	mc.data = data;
	if (data.status == "war")
	{
		mc.gotoAndStop(2);
	}else
	{
		mc.gotoAndStop(1);
	}
	mc.place.icon.gotoAndStop(3);
	mc.goto_btn.onRelease = function()
	{
		fscommand("FrontEventCmd","GoToPlanet\2" + this._parent.data.planet_id);
	}

	mc.title_txt.text = data.title_txt;
	mc.state_txt.text = data.status_txt;
	mc.time_txt.text = GetTimeText(data.count_down - CurSeconds)
	mc.alliance_info.atk_info.alliance_name_txt.text = data.attacker_name;
	SetAllianceIcon(mc.alliance_info.atk_info, data.attacker_icon);

	var def_info_mc = undefined;
	if (data.def_is_mine)
	{
		mc.alliance_info.mine_def_info._visible = true;
		mc.alliance_info.other_def_info._visible = false;
		def_info_mc = mc.alliance_info.mine_def_info;
	}else
	{
		mc.alliance_info.mine_def_info._visible = false;
		mc.alliance_info.other_def_info._visible = true;
		def_info_mc = mc.alliance_info.other_def_info;
	}
	def_info_mc.alliance_name_txt.text = data.defender_name;
	SetAllianceIcon(def_info_mc, data.defender_icon);

}


function SetAllianceIcon(mc, strIcon)
{
    var width =  mc.alliance_icon._width;
    var height = mc.alliance_icon._height;
	if (mc.alliance_icon.icons == undefined)
	{
        mc.alliance_icon.loadMovie("AllianceIconSmall.swf");
    }
    mc.alliance_icon._width = width;
    mc.alliance_icon._height = height;

    mc.alliance_icon.icons.gotoAndStop(strIcon)
}

function FormatTimeTxt(val)
{
	if (val < 10)
	{
		val = "0" + val;
	}
	return val;
}

function GetTimeText(time)
{
	if (time == undefined)
	{
		return;
	}
	if (time < 0)
	{
		time = 0;
	}
	var seconed = FormatTimeTxt(time % 60);

	time = Math.floor(time / 60);

	var minutes = FormatTimeTxt(time % 60);
	time = Math.floor(time / 60);

	var hour = FormatTimeTxt(time);

	return hour + ":" + minutes + ":" + seconed;
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
		Milliseconds += seconds * 1000;
		CurSeconds += 1;
		EventList.needUpdateVisibleItem();
	}
}