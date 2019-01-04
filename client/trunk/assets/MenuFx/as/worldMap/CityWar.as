
var BattleResult 	= _root.battle_result;
var BattleInfo 		= _root.battle_info;
var BattleHud 		= _root.battle_hud;
var PlayerHud 		= _root.huds;

_root.onLoad = function()
{
	SetDefaultShow();
}

function SetDefaultShow()
{
	OpenUI();
	//_root._visible = false;
}


function SwitchUI(ui_name)
{
	if (ui_name == "BattleHud")
	{
		BattleHud._visible 		= true;
		PlayerHud._visible 		= true;
		BattleInfo._visible 	= false;
		BattleResult._visible 	= false;
	}else if (ui_name == "BattleInfo")
	{
		BattleHud._visible 		= false;
		PlayerHud._visible 		= false;
		BattleInfo._visible 	= true;
		BattleInfo.gotoAndPlay("opening_ani");
		BattleResult._visible 	= false;
	}else if (ui_name == "BattleResult")
	{
		BattleHud._visible 		= false;
		PlayerHud._visible 		= false;
		BattleInfo._visible 	= false;
		BattleResult._visible 	= true;
		BattleResult.gotoAndPlay("opening_ani");
	}
}

/********************BattleHud********************/

var CloseBtn 			= BattleHud.btn_close;
var AttackBtn 			= BattleHud.attack_btn;
var DefendBtn 			= BattleHud.defend_btn;

var AttackerInfoTxt 	= BattleHud.top_ui.attacker_info_txt;
var DefenderInfoTxt 	= BattleHud.top_ui.defender_info_txt;

var WarCountDown 			= 0;
var Milliseconds 		= 0;

var WarInfo 			= 0;

BattleHud.OnMoveInOver = function()
{
	trace("-----------BattleHud.OnMoveInOver-----------")
}

BattleHud.OnMoveOutOver = function()
{
	trace("-----------BattleHud.OnMoveOutOver-----------")
	fscommand("WorldMapFightCommand", "CloseUI");
}

function OpenUI(info)
{
	_root._visible = true;
	SwitchUI("BattleHud");
	BattleHud.gotoAndPlay("opening_ani");
	InitBattleHud(info);
	WarInfo = info;
}

function CloseUI()
{
	BattleHud.gotoAndPlay("closing_ani");
}

CloseBtn.onRelease = function()
{
	CloseUI();
}

AttackBtn.onRelease = function()
{
	fscommand("WorldMapFightCommand", "JoinBattle");
}

BattleHud.top_ui.onRelease = function()
{
	SwitchUI("BattleInfo");
	fscommand("WorldMapFightCommand", "ShowFleetInfo");
}

/*
atk_name = 
atk_icon = 
def_name = 
def_icon = 
count_down = 
is_attack = 
*/
function InitBattleHud(info)
{

	if (info.status == "normal")
	{
		BattleHud.top_ui.atk_name_txt._visible = false;
		BattleHud.atk_alliance_icon._visible = false;
		BattleHud.atk_more._visible = false;

		BattleInfo.atk_info._visible = false;

		BattleHud.count_down.state.gotoAndStop(2);
	}else
	{
		BattleHud.top_ui.atk_name_txt._visible = true;
		BattleHud.atk_alliance_icon._visible = true;
		BattleHud.atk_more._visible = true;

		BattleInfo.atk_info._visible = true;

		WarCountDown = info.count_down;
		BattleHud.count_down.state.gotoAndStop(1);
		BattleHud.count_down.state.time_txt.text = GetTimeText(WarCountDown);
	}

	BattleHud.top_ui.atk_name_txt.text = info.atk_name
	SetAllianceIcon(BattleHud.atk_alliance_icon, info.atk_icon)
	BattleHud.top_ui.def_name_txt.text = info.def_name
	SetAllianceIcon(BattleHud.def_alliance_icon, info.def_icon)

	//battle info
	BattleInfo.atk_info.atk_name_txt.text = info.atk_name
	SetAllianceIcon(BattleInfo.atk_info.icon, info.atk_icon)
	BattleInfo.def_info.def_name_txt.text = info.def_name
	SetAllianceIcon(BattleInfo.def_info.icon, info.def_icon)

	//result info
	BattleResult.atk_info.atk_name_txt.text = info.atk_name
	SetAllianceIcon(BattleResult.atk_info.icon, info.atk_icon)
	BattleResult.def_info.def_name_txt.text = info.def_name
	SetAllianceIcon(BattleResult.def_info.icon, info.def_icon)

	if (info.is_attack)
	{
		AttackBtn._visible = true;
		DefendBtn._visible = false;
		AttackBtn.onRelease = function()
		{
			fscommand("WorldMapFightCommand","AddTroops\2" + "1");   //1--attakcer
		}
		DefendBtn.onRelease = undefined;
	}else
	{
		AttackBtn._visible = false;
		DefendBtn._visible = true;

		AttackBtn.onRelease = undefined;
		DefendBtn.onRelease = function()
		{
			fscommand("WorldMapFightCommand","AddTroops\2" + "2");   //2--defend
		}
	}
	RefreshTroopsNum(0, 0);
	Milliseconds = 0;

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


function RefreshTroopsNum(atk_num, def_num)
{
	if(WarInfo.status == "normal")
	{
		BattleHud.top_ui.atk_num_txt._visible = false;
	}else
	{
		BattleHud.top_ui.atk_num_txt._visible = true;
		BattleHud.top_ui.atk_num_txt.text = atk_num;
	}
	
	BattleHud.top_ui.def_num_txt.text = def_num;
}

function GetTimeText(time)
{
	if (time == undefined)
	{
		return;
	}
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
	var seconds = Math.floor(time - (minutes * 60));
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

_root.onEnterFrame = function()
{
	if (WarInfo.status != "normal")
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
			WarCountDown -= 1;
			if (WarCountDown >= 0)
			{
				BattleHud.count_down.state.time_txt.text = GetTimeText(WarCountDown);
			}
		}
	}
}

/******************BattleInfo*******************/

var AtkList 	= BattleInfo.atk_list_content.atk_list;
var DefList 	= BattleInfo.def_list_content.def_list;

var AtkInfoDatas 	= new Array(20);
var DefInfoDatas 	= new Array(10);

BattleInfo.OnMoveInOver = function()
{
	
}

BattleInfo.OnMoveOutOver = function()
{
	SwitchUI("BattleHud");
}

BattleInfo.bg_btn.onRelease = function()
{
	BattleInfo.gotoAndPlay("closing_ani");

	for (i = 0; i < AtkList.m_itemMCList.length; ++i)
	{
		var item_mc = AtkList.m_itemMCList[i];
		item_mc.gotoAndPlay("closing_ani");
	}
	for (i = 0; i < DefList.m_itemMCList.length; ++i)
	{
		var item_mc = DefList.m_itemMCList[i];
		item_mc.gotoAndPlay("closing_ani");
	}
}

/*
datas.atk_infos
datas.def_infos
*/
function InitInfoList(datas)
{
	AtkInfoDatas = datas.atk_infos;
	DefInfoDatas = datas.def_infos;
	InitAtkInfoList();
	InitRightInfoList();
}

function InitAtkInfoList()
{
	if (AtkInfoDatas == undefined)
	{
		return;
	}
	AtkList.clearListBox();
	AtkList.initListBox("warbar", 0, true, true);
	AtkList.enableDrag(true);
	AtkList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	AtkList.onItemEnter = function(mc, index_item)
	{
		index_item = index_item - 1;
		SetItemInfo(mc, AtkInfoDatas[index_item]);
	}

	AtkList.onItemMCCreate 	= undefined;
	AtkList.onListboxMove 	= undefined;
	AtkList.onItemLeave 		= undefined;
	for (var i = 1; i <= AtkInfoDatas.length; ++i)
	{
		var item_mc = AtkList.addListItem(i, false, false);
		// if (item_mc != null)
		// {
		// 	item_mc.gotoAndPlay("opening_ani");	
		// }
		
	}
}

function InitRightInfoList()
{
	if (DefInfoDatas == undefined)
	{
		return;
	}
	DefList.clearListBox();
	DefList.initListBox("warbar", 0, true, true);
	DefList.enableDrag(true);
	DefList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	DefList.onItemEnter = function(mc, index_item)
	{
		
		index_item = index_item - 1;
		SetItemInfo(mc, DefInfoDatas[index_item]);
	}

	DefList.onItemMCCreate 	= undefined;
	DefList.onListboxMove 	= undefined;
	DefList.onItemLeave 		= undefined;
	for (var i = 1; i <= DefInfoDatas.length; ++i)
	{
		var item_mc = DefList.addListItem(i, false, false);
		// if (item_mc != null)
		// {
		// 	item_mc.gotoAndPlay("opening_ani");
		// }
	}
}

/*
data.is_mine
data.state //pending,battle,dead,disappear
data.level
data.name
data.power
data.state_txt
*/
function SetItemInfo(mc, data)
{
	switch(data.state)
	{
		case "pending":
		case "battle":
		case "disappear":
			if (data.is_mine)
			{
				mc.content.gotoAndStop(1);
			}else
			{
				mc.content.gotoAndStop(3);
			}
		break;
		case "dead":
			if (data.is_mine)
			{
				mc.content.gotoAndStop(2);
			}else
			{
				mc.content.gotoAndStop(4);
			}
		break;
		default:
		break;
	}
	mc.content.state_txt.text = data.state_txt
	mc.content.level_txt.text = data.level;
	mc.content.name_txt.text = data.name;
	mc.content.power_txt.text = data.power;
}


/******************BattleResult****************/

var ResultContent 	= BattleResult.detail_content;
var ResultInfo 		= BattleResult.result_info;
var ResultIcon 		= BattleResult.result_icon;
//reason: timeout, countdown, flagout
function InitBattleResult(datas)
{
	ResultContent.atk_destroy_num.text = datas.attacker_dead;
	ResultContent.def_destroy_num.text = datas.defender_dead;
	ResultContent.atk_engage_num.text = datas.attacker_engaged;
	ResultContent.def_engage_num.text = datas.defender_engaged;
	if (datas.reason == "flagout")
	{
		ResultInfo.gotoAndStop(1);
		ResultIcon.gotoAndStop(1);
		BattleResult.result_icon_word.gotoAndStop(1);
		BattleResult.atk_info.winner._visible = true;
		BattleResult.def_info.winner._visible = false;
	}else
	{
		ResultInfo.gotoAndStop(2);
		ResultIcon.gotoAndStop(2);
		BattleResult.result_icon_word.gotoAndStop(2);
		BattleResult.atk_info.winner._visible = false;
		BattleResult.def_info.winner._visible = true;
	}

}

BattleResult.btn_close.onRelease = function()
{
	fscommand("WorldMapFightCommand", "CloseUI");
}

/*******************Huds************************/
function GetPlayerHud(entity_id)
{
	entity_id = "entity_" + entity_id;
	if (PlayerHud[entity_id] == undefined)
	{
		PlayerHud.attachMovie("battle_part_info", entity_id, PlayerHud.getNextHighestDepth());
		PlayerHud[entity_id]._visible = false;
		PlayerHud[entity_id].ValueIndex = 0;
	}
	return PlayerHud[entity_id];
}

function DestoryHud(entity_id)
{
	entity_id = "entity_" + entity_id;
	PlayerHud[entity_id].removeMovieClip();
	PlayerHud[entity_id] = undefined;
}

function UpdatePlayerHud(entity_id, x, y)
{
	var hud = GetPlayerHud(entity_id);
	if (hud == undefined)
	{
		return;
	}
	hud._visible = true;
	hud._x = x;
	hud._y = y;
}

function SetBloodShow(entity_id, is_show)
{
	var hud = GetPlayerHud(entity_id);
	if (hud == undefined)
	{
		return;
	}
	hud.hp_bar._visible = is_show == true;
}

function ShowHurtValue(entity_id, num)
{
	var hud = GetPlayerHud(entity_id);
	if (hud == undefined)
	{
		return;
	}
	hud.ValueIndex = hud.ValueIndex + 1;
	var mc = hud.attachMovie("num_red_all","hrut_" + hud.ValueIndex , hud.getNextHighestDepth());
	mc._x = 0;
	mc._y = 0;
	SetHurtNum(mc, num);
	mc.gotoAndPlay(1);
}

function SetHurtNum(mc, num)
{
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;
	mc.num.gotoAndStop(nLength);
	for(var i = 0; i < nLength; ++i)
	{
		var temp = Number(arrayNum[i]);
		mc.num["num" + (i + 1)].gotoAndStop(temp + 1);
	}
}

function UpdatePlayerBlood(entity_id, rate)
{
	var hud = GetPlayerHud(entity_id);
	if (hud == undefined)
	{
		return;
	}
	rate = Math.ceil(rate / 10) + 1;
	hud.hp_bar.gotoAndStop(rate);
}

function InitPlayerInfo(entity_id, name, alliance_icon)
{
	var hud = GetPlayerHud(entity_id);
	if (hud == undefined)
	{
		return;
	}
	hud.name_txt.html = true;
	hud.name_txt.htmlText = name;
	hud.hp_bar.gotoAndStop(11);
	SetAllianceIcon(hud.icon, alliance_icon)
}
