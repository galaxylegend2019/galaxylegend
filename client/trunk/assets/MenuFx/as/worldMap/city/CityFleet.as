var MainUI = _root.main_ui.main_ui;

var ShowBtn = MainUI.show_btn;
var IsOpen 	= false;

var FleetList = MainUI.list.list_view;

var FleetDatas = new Array();
var Milliseconds = 0;
var CurPassSeconds = 0;

_root.onLoad = function()
{
	SetDefaultShow();
	InitUI();
	OpenUI();
}

function SetDefaultShow()
{
	MainUI.list._visible 	= false;
	MainUI.bg_btn._visible 	= false;
	SetShowBtnState(false);
	SetRedPointShow(0);
}

function InitUI()
{
	ShowBtn.onRelease = function()
	{
		IsOpen = !IsOpen;
		SetFleetShow(IsOpen);
	}

	MainUI.OnMoveInOver = function()
	{
		SetShowBtnState(IsOpen);
		MainUI.bg_btn.onRelease = function()
		{
			ShowBtn.onRelease()
		}
	}

	MainUI.OnMoveOutOver = function()
	{
		MainUI.bg_btn.onRelease = undefined;
		MainUI.list._visible 	= false;
		MainUI.bg_btn._visible 	= false;
		SetShowBtnState(IsOpen);
	}
	InitList();
}

function SetShowBtnState( is_open )
{
	ShowBtn.open._x = 10;
	ShowBtn.open._y = -11;
	ShowBtn.close._x = 21;
	ShowBtn.close._y = -11;
	if (is_open)
	{
		ShowBtn.close._visible 	= false;
		
		ShowBtn.open._visible 	= true;

	}else
	{
		ShowBtn.close._visible 	= true;
		ShowBtn.open._visible 	= false;
	}
}

function SetRedPointShow(num)
{
	if (num != undefined and num > 0)
	{
		ShowBtn.red_point.num_txt.text = num;
		ShowBtn.red_point._visible = true;
	}else
	{
		ShowBtn.red_point._visible = false;
	}
	
}

function PackUpFleetUI()
{
	IsOpen = false;
	SetFleetShow(IsOpen);
}

function SetFleetShow( is_show )
{
	if (is_show)
	{
		MainUI.list._visible 	= true;
		MainUI.bg_btn._visible 	= true;
		MainUI.gotoAndPlay("opening_ani");
		FleetList.forceCorrectPosition();
	}else
	{
		MainUI.gotoAndPlay("closing_ani");
	}
}

function OpenUI()
{
	_root.main_ui.gotoAndPlay("opening_ani");
}

function CloseUI()
{
	_root.main_ui.gotoAndPlay("closing_ani");
}


function InitList()
{
	FleetList.clearListBox();
	FleetList.initListBox("MarchingParade", 20, true, true);
	FleetList.enableDrag(true);
	FleetList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	FleetList.onItemEnter = function(mc, index_item)
	{
		index_item = index_item - 1;
		SetItemInfo(mc, FleetDatas[index_item]);
	}

	FleetList.onItemMCCreate 	= undefined;
	FleetList.onListboxMove 	= undefined;
	FleetList.onItemLeave 		= undefined;
	for (var i = 1; i <= FleetDatas.length; ++i)
	{
		FleetList.addListItem(i, false, false);
	}
}

function SetItemInfo(mc, data)
{
	if (data == undefined)
	{
		return;
	}

	mc = SetItemShowType(mc, data);
	for(var i = 1; i <= data.hero_infos.length; ++i)
	{
		SetHeroInfo(mc["hero" + i], data.hero_infos[i - 1]);	
	}
	
	SetItemStatus(mc, data);
	mc.data = data;
}

function SetItemStatus(mc, data)
{
	mc.place_txt.text = data.place_name;
	mc.state_txt.html = true;
	if (data.state == "mining")
	{
		var count_down = data.count_down - CurPassSeconds;
		if (count_down < 0)
		{
			count_down = 0;
		}
		mc.state_txt.htmlText = "<font color='#73C5EF'>" + data.status + "</font> " + "<font color='#73C5EF'>" + GetTimeText(count_down) + "</font>" 
	}else if (data.state == "recovery")
	{
		var count_down = data.count_down - CurPassSeconds;
		if (count_down < 0)
		{
			count_down = 0;
		}
		mc.state_txt.htmlText = "<font color='#73C5EF'>" + data.status + "</font> " + "<font color='#73C5EF'>" + GetTimeText(count_down) + "</font>"
	}else
	{
		mc.state_txt.htmlText = "<font color='#73C5EF'>" + data.status + "</font> "
	}
}

function SetItemShowType(mc, data)
{
	var state = data.state
	var cur_mc = undefined;
	if (state == "mining")
	{
		mc.list1._visible = true;
		mc.list2._visible = false;
		mc.list3._visible = false;
		mc.list4._visible = false;
		cur_mc = mc.list1;
		cur_mc.place.icon.gotoAndStop(1);
		cur_mc.recall_btn._visible = true;
		cur_mc.recall_btn.onRelease = function()
		{
			fscommand("FleetCommand", "MiningRecall\2" + this._parent.data.id);
		}
	}
	else if (state == "alliance_dispatch")
	{
		mc.list1._visible = true;
		mc.list2._visible = false;
		mc.list3._visible = false;
		mc.list4._visible = false;
		cur_mc = mc.list1;
		cur_mc.place.icon.gotoAndStop(2);
		cur_mc.recall_btn._visible = true;
		cur_mc.recall_btn.onRelease = function()
		{
			fscommand("FleetCommand", "DispatchRecall\2" + this._parent.data.id);
		}
	}
	else if (state == "guard")
	{
		mc.list1._visible = true;
		mc.list2._visible = false;
		mc.list3._visible = false;
		mc.list4._visible = false;
		cur_mc = mc.list1;
		cur_mc.place.icon.gotoAndStop(3);
		cur_mc.recall_btn._visible = true;
		cur_mc.recall_btn.onRelease = function()
		{
			fscommand("FleetCommand", "GuardRecall\2" + this._parent.data.id);
		}
	}
	else if (state == "war_battle")
	{
		mc.list1._visible = false;
		mc.list2._visible = false;
		mc.list3._visible = true;
		mc.list4._visible = false;
		cur_mc = mc.list3;
		cur_mc.place.icon.gotoAndStop(3);
	}
	else if (state == "war_prepare")
	{
		mc.list1._visible = true;
		mc.list2._visible = false;
		mc.list3._visible = false;
		mc.list4._visible = false;
		cur_mc = mc.list1;
		cur_mc.place.icon.gotoAndStop(2);
		cur_mc.recall_btn._visible = false;
	}else if (state == "recovery")
	{

		if (data.blood_cnt == 0)
		{
			mc.list2._visible = true;
			mc.list4._visible = false;
			cur_mc = mc.list2;
		}else
		{
			mc.list2._visible = false;
			mc.list4._visible = true;
			cur_mc = mc.list4;
		}
		mc.list1._visible = false;
		
		mc.list3._visible = false;
		
		cur_mc.place.icon.gotoAndStop(2);
		cur_mc.repair_btn.onRelease = function()
		{
			fscommand("FleetCommand", "Repaire\2" + this._parent.data.id);
		}
	}else
	{
		mc.list1._visible = false;
		mc.list2._visible = false;
		mc.list3._visible = true;
		cur_mc = mc.list3;
		cur_mc.place.icon.gotoAndStop(3);
	}
	cur_mc.place.onRelease = function()
	{
		fscommand("FleetCommand", "Place\2" + this._parent.data.id);
	}
	return cur_mc;
}

function SetHeroInfo(mc, hero_info)
{
	SetHeroIcon(mc, hero_info.icon_data);
	SetHeroStar(mc, hero_info.star);
	SetHeroBlood(mc, hero_info.max_blood, hero_info.cur_blood);
}

function SetHeroIcon(mc, icon_data)
{
	if (mc.icon.icons == undefined)
	{
		var h = mc.icon._height;
		var w = mc.icon._width;
		mc.icon.loadMovie("CommonHeros.swf");
		mc.icon._height = h;
		mc.icon._width  = w;
	}

	mc.icon.IconData = icon_data;
	if(mc.icon.UpdateIcon)
	{ 
		mc.icon.UpdateIcon(); 
	}
}

function SetHeroStar(mc, star)
{
	mc.star.gotoAndStop(star);
}

function SetHeroBlood(mc, max_blood, cur_blood)
{
	if (cur_blood != undefined)
	{
		var progress = cur_blood / max_blood;
		var frame = Math.floor(7 * progress);
		mc.blood.gotoAndStop(frame + 1);
		mc.blood._visible = true;
	}else
	{
		mc.blood._visible = false;
	}
	
}

/*
	data.id = 1
	data.state = 
	data.hero_infos = {id, star, cur_blood, max_blood, icon_data}
*/

function RefreshList( datas )
{
	if(datas.fleets.length > FleetDatas.length)
	{

		for(var i = FleetDatas.length; i < datas.fleets.length; i++)
		{
			FleetList.addListItem(i + 1, false, false);	
		}
	}else if(datas.fleets.length < FleetDatas.length)
	{
		for(var i = datas.fleets.length; i < FleetDatas.length; i++)
		{
			FleetList.eraseItem(i + 1);	
		}
	}
	Milliseconds = 0;
	CurPassSeconds = 0;
	FleetDatas = datas.fleets;
	FleetList.needUpdateVisibleItem();
	SetRedPointShow(datas.fleet_num);
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
		Milliseconds += 1000;
		CurPassSeconds = CurPassSeconds + 1;
		FleetList.needUpdateVisibleItem();
	}
}