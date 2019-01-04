// city_map.fla

#include "../../as/common/util.as"

import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

var g_hudRoot = _root.hud_root;
var g_hudWidth = g_hudRoot._width;
var g_hudHeight = g_hudRoot._height;
var g_hudAuxRoot = _root.hud_aux;
var g_popupRoot = _root.popup_root;
var g_nameBarAlpha = 50;
var g_curAlpha = g_nameBarAlpha;
var g_Event 	= _root.event;

var g_PopupReward 	= _root.popup_reward.content;
var g_GalaxyReward 	= _root.galaxy_reward;
var g_RewardBox 	= _root.reward_box;

var g_mapBar = _root.map_bar;
var g_buttonBar = _root.button_bar;
var g_taskBarRoot = _root.task_bar;
var g_taskBar = _root.task_bar.task_bar;

var g_minimapRoot = g_mapBar.small.map_root;
var g_minimapWidth = g_minimapRoot._width;
var g_minimapHeight = g_minimapRoot._height;

var g_selectedUID = "";

var g_attackingPlanetMC = undefined;
var g_fte_planet = undefined
var g_fte_levels = undefined
var g_fte_unlock = undefined

var GalaxyRewardInfos = undefined;
var CurSelectRewardInfo = undefined;

// trace("g_minimapWidth: " + g_minimapWidth + "  g_minimapHeight: " + g_minimapHeight);

var g_minimapLibNames = ["Ui_resources1", "Ui_resources2", "Ui_resources0", "Ui_resources_my", "Ui_resources_friends", "Ui_resources_boss"];

this.onLoad = function(){
	init();
}

function init()
{
	g_mapBar._visible = false;
	g_buttonBar._visible = false;
	g_taskBarRoot._visible = false;
	g_Event._visible = false;
	g_PopupReward._visible 	= false;
	g_GalaxyReward._visible = false;
	g_RewardBox._visible 	= false;
	g_taskBar.txt_title.text = "";
	g_taskBar.txt_desc.text = "";
	SetFrontEventRedPoint(false)
	// g_hudRoot._alpha = g_nameBarAlpha;

	// MoveIn();
	//test
	Test();
}

function SetFrontEventRedPoint(is_show)
{
	g_Event.event_btn.red_point._visible = is_show;
}

function MoveIn()
{
	g_mapBar._visible = true;
	g_mapBar.gotoAndPlay("opening_ani");
	g_mapBar.OnMoveInOver = function()
	{
		this.small.btn_mypos.onRelease = function()
		{
			fscommand("WorldMapCmd", "ViewFlagship")
        }
        this.small.open_minimap.onRelease = function()
        {
            fscommand("WorldMapCmd","OpenMiniMap")
        }
	}

	g_taskBarRoot._visible = true;
	g_taskBarRoot.gotoAndPlay("opening_ani");
	g_taskBarRoot.OnMoveInOver = function()
	{
		this.task_bar.btn_task.onRelease = function()
		{
			ClickTaskBtn()
		}
		this.task_bar.btn_jump.onRelease = function()
		{
			ClickTaskJump()
		}
	}
	g_Event._visible = true;
	g_Event.gotoAndPlay("opening_ani");
	g_Event.event_btn.onRelease = function()
	{
		fscommand("WorldMapCmd","OpenEventUI")
	}
	
	if (GalaxyRewardInfos.curAward != undefined)
	{
		g_GalaxyReward._visible = true;
		g_GalaxyReward.gotoAndPlay("opening_ani");
	}

	if(GalaxyRewardInfos.allAwards.length > 0)
	{
		g_RewardBox._visible = true;
		g_RewardBox.gotoAndPlay("opening_ani");
	}

	// g_buttonBar._visible = true;
	// g_buttonBar.gotoAndPlay("opening_ani");
	// g_buttonBar.OnMoveInOver = function()
	// {
	// 	this.btn_activity.onRelease = function()
	// 	{
	// 		fscommand("WorldMapCmd", "OnActivityClick")
	// 	}
	// 	this.btn_war.onRelease = function()
	// 	{
	// 		fscommand("WorldMapCmd", "OnWarClick")
	// 	}
	// 	this.btn_task.onRelease = function()
	// 	{
	// 		fscommand("WorldMapCmd", "OnTaskClick")
	// 	}
	// }
}

//fte call
function ClickTaskBtn()
{
	fscommand("WorldMapCmd", "OnTaskClick");
}
//fte call
function ClickTaskJump()
{
	if(g_taskBarRoot.task_bar.my_task_finished)
	{
		fscommand("WorldMapCmd", "OnTaskClick");
	}
	else
	{
		if(g_taskBarRoot.task_bar.my_task_id >= 0)
		{
			fscommand("TaskCommand", "Jump" + '\2' + g_taskBarRoot.task_bar.my_task_id);
			_root.fteanim.task_jump2._visible = false
		}
	}
}


function MoveOut()
{
	g_mapBar.gotoAndPlay("closing_ani");
	g_mapBar.OnMoveOutOver = function()
	{
		this._visible = false;
	}

	g_taskBarRoot.gotoAndPlay("closing_ani");
	g_taskBarRoot.OnMoveOutOver = function()
	{
		this._visible = false;
	}
	g_Event._visible = false;
	g_Event.gotoAndPlay("closing_ani");
	// g_buttonBar.gotoAndPlay("closing_ani");
	// g_buttonBar.OnMoveOutOver = function()
	// {
	// 	this._visible = false;
	// }
	g_GalaxyReward._visible = false;
	g_RewardBox._visible = false;
	g_PopupReward._visible = false;
}

// for war
// info has tow member: state warCountdown
function _setIconStateSingle(mc, info)
{
	
	if (info.state == "normal") {
		if (mc.MyIconState != undefined) {
			mc.MyIconState.removeMovieClip();
		}
	}
	else
	{
		if(mc.MyIconState == undefined)
		{
			mc.attachMovie("IconState", "MyIconState", mc.getNextHighestDepth());
			mc.MyIconState._x = 0;
			mc.MyIconState._y = 0;
		}

		var content01 = mc.MyIconState.ui_bar.content_01;
		var content02 = mc.MyIconState.ui_bar.content_02;
		if (info.state == "prewar") {
			content01.gotoAndStop(3);
			content02.gotoAndStop(3);
			content01.txt_time.text = info.warCountdown;
			content02.txt_time.text = info.warCountdown;
		}
		else {
			content01.gotoAndStop(2);
			content02.gotoAndStop(2);
		}
	}
	

}

function UpdateIconStates(updatedInfos)
{
	for(var i = 0; i < updatedInfos.length; ++i)
	{
		var UID = updatedInfos[i].UID
		var mc = g_hudRoot[UID];
		if(mc != undefined)
		{
			_setIconStateSingle(mc, updatedInfos[i])
			
		}
	}
	
}

function UpdateHudInfos(updatedInfos, deleteInfos)
{
	for(var i = 0; i < updatedInfos.length; ++i)
	{
		var info = updatedInfos[i];
		var UID = info.UID;
		// trace("UID: " + UID + " " + info);
		var mc = g_hudRoot[UID];
		if(mc == undefined)
		{
			var libName = "PlayerNameBar";
			g_hudRoot.attachMovie(libName, UID, g_hudRoot.getNextHighestDepth());
			mc = g_hudRoot[UID];
			mc.UID = UID;
			mc.UIDType = info.type;
			//update content only just created
			mc.isHud = true;
			mc.IconLevel._visible = false;
			mc.IconItem._visible = false;
			mc.IconEnemy._visible = false;
			mc.IconBorg._visible = false;
			mc.NameBarRight._visible = false;
			mc.NameBarCenter._visible = false;
			mc.alliance_icon._visible = false;
			mc.MyNameBar = undefined;
			mc.MyIconLevel = undefined;
			mc.MyIconItem = undefined;
			mc.MyIconState = undefined;

			if(info.type == "enemyShip")
			{
				mc.MyNameBar = mc.NameBarRight;
				mc.MyNameBar._visible = true;
				mc.MyNameBar.txt_name.htmlText = info.nameTxt;
			}
			else if(info.type == "flagship")
			{
				mc.MyNameBar = mc.NameBarCenter;
				mc.MyNameBar._visible = true;
				// mc.MyNameBar.txt_name.htmlText = info.nameTxt;
			}
			else if(info.type == "planet")
			{
				if(info.isShowAttack)
				{
					g_hudAuxRoot.attachMovie("attackstate", UID, g_hudAuxRoot.getNextHighestDepth());
					var mcAux = g_hudAuxRoot[UID];
					mcAux.isHud = true;
					mcAux._visible = true;
					mcAux.gotoAndPlay("opening_ani");
					g_fte_planet = mcAux.fteanim
					mcAux.fteanim._visible = false
				}

				mc.MyNameBar = mc.NameBarCenter;
				mc.MyNameBar._visible = true;
				mc.MyNameBar.txt_name.htmlText = info.nameTxt;
				trace("--------" + info.nameTxt)
				mc.alliance_icon._visible = true;
				SetAllianceIcon(mc.alliance_icon, info.alliance_icon);

			}
			else if(info.type == "mine")
			{
				if(mc.MyIconState == undefined)
				{
					mc.attachMovie("IconState", "MyIconState", mc.getNextHighestDepth());
				}

				mc.MyNameBar = mc.NameBarRight;
				mc.MyNameBar._visible = true;
				// mc.MyNameBar.txt_name.htmlText = info.nameTxt;

				mc.MyIconItem = mc.IconItem;
				mc.MyIconItem._visible = true;
				if(mc.MyIconItem.item_icon.icons == undefined)
				{
					var w = mc.MyIconItem.item_icon._width;
					var h = mc.MyIconItem.item_icon._height;
					mc.MyIconItem.item_icon.loadMovie("CommonIcons.swf");
					mc.MyIconItem.item_icon._width = w;
					mc.MyIconItem.item_icon._height = h;
					// trace("mc.MyIconItem.item_icon: " + mc.MyIconItem.item_icon + " " + mc.MyIconItem.item_icon._width + "  " + mc.MyIconItem.item_icon._height);
				}

				mc.MyIconItem.item_icon.IconData = info.itemIcon;
				mc.MyIconItem.item_icon.m_OnlyIcon = true;
				if (mc.MyIconItem.item_icon.UpdateIcon) { mc.MyIconItem.item_icon.UpdateIcon(); }
			}
			else if(info.type == "boss")
			{
				mc.MyIconEnemy = mc.IconEnemy;
				mc.MyIconEnemy._visible = true;

				mc.MyNameBar = mc.NameBarRight;
				mc.MyNameBar._visible = true;
				mc.MyNameBar.txt_name.htmlText = info.nameTxt;
			}
			else
			{
				mc.MyNameBar = mc.NameBarCenter;
				mc.MyNameBar._visible = false;
			}
			// mc._alpha = g_nameBarAlpha;

			// trace("new " + UID);
		}
		else
		{
			// trace("exist " + UID);
		}
		// mc.NameBar.txt_name.htmlText = info.nameTxt;

		//update content change every frame
		if(info.type == "mine")
		{
			if(info.playerCount > 0)
			{
				mc.MyIconState._visible = true;
				mc.MyIconState.numTxt = info.playerCount + "/" + info.playerMax;
				var content01 = mc.MyIconState.ui_bar.content_01;
				var content02 = mc.MyIconState.ui_bar.content_02;
				content01.gotoAndStop(1);
				content02.gotoAndStop(1);
				content01.txt_num.text = mc.MyIconState.numTxt;
				content02.txt_num.text = mc.MyIconState.numTxt;
			}
			else
			{
				mc.MyIconState._visible = false;
			}
			mc.MyNameBar.txt_name.htmlText = info.nameTxt;
		}
		else if(info.type == "flagship")
		{
			mc.MyNameBar.txt_name.htmlText = info.nameTxt;
			if(info.dockTimerTxt)
			{
				if(mc.MyIconState == undefined)
				{
					mc.attachMovie("IconState", "MyIconState", mc.getNextHighestDepth());
					mc.MyIconState._x = 0;
					mc.MyIconState._y = 0;
				}

				mc.MyIconState._visible = true;
				mc.MyIconState.timeTxt = info.dockTimerTxt;
				var content01 = mc.MyIconState.ui_bar.content_01;
				var content02 = mc.MyIconState.ui_bar.content_02;
				content01.gotoAndStop(4);
				content02.gotoAndStop(4);
				content01.txt_time.text = mc.MyIconState.timeTxt;
				content02.txt_time.text = mc.MyIconState.timeTxt;
			}
			else
			{
				mc.MyIconState._visible = false;
			}
		}
		else if(info.type == "planet")
		{
			_setIconStateSingle(mc, info)
		}
		mc._x = info.posx;
		mc._y = info.posy;
		mc._xscale = info.scale;
		mc._yscale = info.scale;

		var mcAux = g_hudAuxRoot[UID];
		if(mcAux)
		{
			mcAux._x = info.posx;
			mcAux._y = info.posy;
			if(info.auxScale != undefined)
			{
				var scale = info.scale * info.auxScale
				mcAux._xscale = scale;
				mcAux._yscale = scale;
			}
			else
			{
				mcAux._xscale = info.scale;
				mcAux._yscale = info.scale;
			}
		}

		if(g_selectedUID == UID)
		{
			var popup = g_popupRoot[UID];
			if(popup)
			{
				popup._x = info.posx;
				popup._y = info.posy;
			}
		}

	}

	for(var j = 0; j < deleteInfos.length; ++j)
	{
		var UID = deleteInfos[j];
		g_hudRoot[UID].removeMovieClip();
		g_hudAuxRoot[UID].removeMovieClip();
	}
}

function SetAllianceIcon(mc, strIcon)
{
    var width =  mc.item_icon._width;
    var height = mc.item_icon._height;
	if (mc.item_icon.icons == undefined)
	{
        mc.item_icon.loadMovie("AllianceIconSmall.swf");
    }
    mc.item_icon._width = width;
    mc.item_icon._height = height;

    mc.item_icon.icons.gotoAndStop(strIcon)
}

function ClearHudInfos()
{
	for(var UID in g_hudRoot)
	{
		if(g_hudRoot[UID].isHud)
		{
			g_hudRoot[UID].removeMovieClip();
		}
		if(g_hudAuxRoot[UID].isHud)
		{
			g_hudAuxRoot[UID].removeMovieClip();
		}
	}
}

function UpdateMinimapInfos(updatedInfos, deleteInfos)
{
	for(var i = 0; i < updatedInfos.length; ++i)
	{
		var info = updatedInfos[i];
		var UID = info.UID;
		// trace("UID: " + UID + " " + info);
		var mc = g_minimapRoot[UID];
		if(mc == undefined)
		{
			var libName = g_minimapLibNames[info.libIndex];
			g_minimapRoot.attachMovie(libName, UID, g_minimapRoot.getNextHighestDepth());
			mc = g_minimapRoot[UID];
			mc.UID = UID;
			mc.isHud = true;
		}
		mc._x = g_minimapWidth * info.posx;
		mc._y = g_minimapHeight * info.posy;
		if(info.rotation != undefined)
		{
			mc._rotation = info.rotation;
		}
	}

	for(var j = 0; j < deleteInfos.length; ++j)
	{
		var UID = deleteInfos[j];
		g_minimapRoot[UID].removeMovieClip();
	}
}

function ClearMinimapInfos()
{
	for(var UID in g_minimapRoot)
	{
		if(g_minimapRoot[UID].isHud)
		{
			g_minimapRoot[UID].removeMovieClip();
		}
	}
}

function UpdateSelectdEntityPopup(UID, info)
{
	if(g_selectedUID != UID)
	{
		if(g_selectedUID != "")
		{
			if(g_popupRoot[g_selectedUID].isPopup)
			{
				g_popupRoot[g_selectedUID].ui_bar.OnMoveOutOver = function()
				{
					this._parent.removeMovieClip();
				}
				if(g_popupRoot[g_selectedUID].UIDType == "planet")
				{
					OnPlanetPopupClose(g_popupRoot[g_selectedUID]);
				}
				g_popupRoot[g_selectedUID].ui_bar.gotoAndPlay("closing_ani");
				g_popupRoot[g_selectedUID].isMovedIn = false;

				var mcHud = g_hudRoot[g_selectedUID];
				if(mcHud)
				{
					mcHud.MyNameBar._visible = true;
					mcHud.MyIconLevel._visible = true;
					mcHud.MyIconState._visible = true;
				}

				var mcAux = g_hudAuxRoot[g_selectedUID];
				if(mcAux)
				{
					mcAux._visible = true;
					mcAux.gotoAndPlay("opening_ani");
				}
			}
		}
		g_selectedUID = UID;
	}

	if(g_selectedUID != "")
	{
		var mc = g_popupRoot[g_selectedUID];
		if(mc == undefined)
		{
			var libName = "";
			if(info.type == "planet")
			{
				if(info.isPassed)
				{
					libName = "PlanetSelected";
				}
				else
				{
					var len = info.gateState.length;
					libName = "PlanetCopy" + len;
					// trace("libName: " + libName);
				}
			}
			if(libName != "")
			{
				g_popupRoot.attachMovie(libName, UID, g_popupRoot.getNextHighestDepth());
				mc = g_popupRoot[UID];
				mc.UID = UID;
				mc.UIDType = info.type;
				mc.isPopup = true;

				//update content only just created
				if(info.type == "planet")
				{
					OnPlanetPopupCreated(mc, info)
				}
			}

			var mcHud = g_hudRoot[UID];
			if(mcHud)
			{
				mcHud.MyNameBar._visible = false;
				mcHud.MyIconLevel._visible = false;
				mcHud.MyIconState._visible = false;
			}

			var mcAux = g_hudAuxRoot[g_selectedUID];
			if(mcAux)
			{
				mcAux.gotoAndPlay("closing_ani");
			}

		}
		if(mc)
		{
			//update content change every frame
			mc._x = info.posx;
			mc._y = info.posy;
		}
	}	
}

function OnPlanetPopupCreated(mc, info)
{
	mc.isPassed = info.isPassed;
	if(info.isPassed)
	{
		mc.ui_bar.center_name_bar._visible = false;
		for(var i = 0; i < 4; ++i)
		{
			var item_mc = mc.ui_bar["item_" + i];
			item_mc.gotoAndStop(info.cmds[i][0])
			var btn_mc = item_mc.btn_0;
			btn_mc.gotoAndStop(info.cmds[i][1]);
			// trace("item_mc: " + item_mc + " btn_mc: " + btn_mc);
			btn_mc.my_cmd = info.cmds[i];
		}

		mc.ui_bar.OnMoveInOver = function()
		{
			for(var i = 0; i < 4; ++i)
			{
				var item_mc = this["item_" + i];
				var btn_mc = item_mc.btn_0;
				// trace("22222item_mc: " + item_mc + " btn_mc: " + btn_mc);
				btn_mc.onRelease = function()
				{
					fscommand("WorldMapCmd", "OnPlanetPopCmd" + "\2" + this._parent._parent._parent.UID + "\2" + this.my_cmd[0] + "\2" + this.my_cmd[1]);
				}
			}
			this._parent.isMovedIn = true;
		}
		mc.ui_bar.gotoAndPlay("opening_ani");
	}
	else
	{
		mc.ui_bar.center_name_bar._visible = false;
		for(var i = 0; i < info.gateState.length; ++i)
		{
			var btn_mc = mc.ui_bar["btn_icon_" + i];
			btn_mc.my_index = i;
			var gateInfo = info.gateState[i];
			var state = gateInfo.state
			btn_mc.gateState = state
			btn_mc.planetId = info.planetId
			btn_mc.gateId = gateInfo.gateId
			btn_mc.gotoAndStop(state);
			if(state == 1)
			{
				g_attackingPlanetMC = mc.fte["btn_icon_" + i]; //for tutorial
			}
			btn_mc.txt_name.text = gateInfo.bossName;
			if(btn_mc.user_head.icons == undefined)
			{
				btn_mc.user_head.loadMovie("CommonHeros.swf");
			}
			btn_mc.user_head.IconData = gateInfo.avatar;
			trace("btn_mc: " + btn_mc.user_head.icons + "  " + btn_mc.user_head.IconData);
   			if (btn_mc.user_head.UpdateIcon) { btn_mc.user_head.UpdateIcon(); }
				
		}

		//
		g_fte_levels = mc.fteanim
		g_fte_levels.btn_icon_0._visible = false
		g_fte_levels.btn_icon_1._visible = false
		g_fte_levels.btn_icon_2._visible = false
		//

		mc.ui_bar.OnMoveInOver = function()
		{
			fscommand("TutorialCommand", "Activate\2WM_FightEntrance_Open")


			for(var i = 0; i < 4; ++i)
			{
				var btn_mc = this["btn_icon_" + i];
				if(btn_mc.gateState == 1)
				{
					btn_mc.onRelease = function()
					{
						fscommand("WorldMapCmd", "OnPlanetGateClick" + "\2" + this._parent._parent.UID + "\2" + this.planetId + "\2" + this.gateId);
					}
				}
			}
			this._parent.isMovedIn = true;
		}
		mc.ui_bar.gotoAndPlay("opening_ani");
	}
}

function OnPlanetPopupClose(mc)
{
	if(mc.isPassed)
	{
	}
	else
	{
		var ui_bar = mc.ui_bar;
		for(var i = 0; i < 3; ++i)
		{
			ui_bar["btn_icon_" + i].onRelease = undefined;
		}
		if(g_attackingPlanetMC != undefined)
		{
			g_attackingPlanetMC = undefined;
		}
	}
}

_root.btn_hud_bg.onRelease = _root.btn_hud_bg.onReleaseOutside = function()
{
	// g_nameBarAlpha = 50;
	// if(g_curAlpha != g_nameBarAlpha)
	// {
	// 	g_curAlpha = g_nameBarAlpha;
	// 	// for(var UID in g_hudRoot)
	// 	// {
	// 	// 	g_hudRoot[UID]._alpha = g_nameBarAlpha;
	// 	// }
	// 	g_hudRoot._alpha = g_nameBarAlpha;
	// }
	this.clicked = false;
}

_root.btn_hud_bg.onPress = function()
{
	if(g_selectedUID != "")
	{
		if(g_popupRoot[g_selectedUID].isMovedIn)
		{
			fscommand("WorldMapCmd", "OnCloseSelectEntity" + '\2' + g_selectedUID);
		}
	}
	else
	{
		fscommand("CityCommand", "IsModelClick"+'\2'+"enable");
		this.pressedX = _root._xmouse;
		this.pressedY = _root._ymouse;
		this.clicked = true;
	}
}

_root.btn_hud_bg.onMouseMove = function()
{
	if(this.clicked)
	{
		// trace(this.pressedX + "  " + _root._xmouse + "  " + this.pressedY + "  " + _root._ymouse);
		// if(Math.abs(this.pressedX - _root._xmouse) > 20 || Math.abs(this.pressedY - _root._ymouse) > 20)
		// {
		// 	g_nameBarAlpha = 100;
		// 	if(g_curAlpha != g_nameBarAlpha)
		// 	{
		// 		g_curAlpha = g_nameBarAlpha;
		// 		// for(var UID in g_hudRoot)
		// 		// {
		// 		// 	g_hudRoot[UID]._alpha = g_nameBarAlpha;
		// 		// }
		// 		g_hudRoot._alpha = g_nameBarAlpha;
		// 	}
		// }
	}
}

function SetFlagshipPos(x, y)
{
	g_mapBar.small.txt_pos.text = "X:" + x + "    " + "Y:" + y
}

function SetTaskInfo(info)
{
	g_taskBar.txt_title.text = info.titleTxt;
	g_taskBar.txt_desc.text = info.descTxt;
	g_taskBar.my_task_id = info.mainTaskId;
	g_taskBar.my_task_finished = info.mainTaskFinished;
}

function SetTaskRedPointVisible(isVisible)
{
	g_taskBar.red_point._visible = isVisible;
}

function SetTaskBarShining(isShining)
{
	g_taskBar.light_bar._visible = isShining;
}

function SetMistIcon(info)
{
	if(info == undefined)
	{
		var mistIcon = g_hudAuxRoot["MistIcon"];
		if(mistIcon)
		{
			mistIcon._visible = false;
		}
	}
	else
	{
		var mistIcon = g_hudAuxRoot["MistIcon"];
		if(mistIcon == undefined)
		{
			g_hudAuxRoot.attachMovie("btnDenseFog", "MistIcon", g_hudAuxRoot.getNextHighestDepth());
			mistIcon = g_hudAuxRoot["MistIcon"];
			g_fte_unlock = mistIcon.fteanim
			g_fte_unlock._visible = false
		}
		mistIcon._visible = true;
		mistIcon._x = info.posx;
		mistIcon._y = info.posy;
		if(info.levelTxt != undefined)
		{
			mistIcon.gotoAndStop(1);
			mistIcon.txt_level.text = info.levelTxt;
		}
		else
		{
			mistIcon.gotoAndStop(2);
			mistIcon.txt_money.text = info.moneyTxt;
		}
	}
}

function GetMistIcon()
{
	return g_hudAuxRoot["MistIcon"].frame;
}

function Tuto_GetAttackingPlanetMC()
{
	return g_attackingPlanetMC;
}


function FTEPlayAnim(sname, only_finger)
{
	if (sname == "planet")
	{

		g_fte_planet._visible = true
	}
	else if (sname == "level1" || sname == "level2" || sname == "level3")
	{
		if (g_fte_levels != undefined)
		{
			var idx = Number(sname.substr(5))
			g_fte_levels["btn_icon_"+(idx-1)]._visible = true
			if (only_finger == true)
			{
				g_fte_levels["btn_icon_"+(idx-1)].bg._visible = false
			}
			else
			{
				g_fte_levels["btn_icon_"+(idx-1)].bg._visible = true 
			}
		}
	}
	else if (sname == "unlock")
	{
		g_fte_unlock._visible = true
	}
	else
	{
		_root.fteanim[sname]._visible = true
	}
}

function FTEHideAnim()
{

	_root.fteanim.task_enter._visible = false
	_root.fteanim.task_jump._visible = false
	_root.fteanim.task_jump2._visible = false

	if (g_fte_planet != undefined)
	{
		g_fte_planet._visible = false
	}

	if (g_fte_levels != undefined)
	{
		g_fte_levels.btn_icon_0._visible = false
		g_fte_levels.btn_icon_1._visible = false
		g_fte_levels.btn_icon_2._visible = false
	}

	if (g_fte_unlock!=undefined)
	{
		g_fte_unlock._visible = false
	}

}

FTEHideAnim()



////////////////////////GalaxyRewards////////////////////////

function Test()
{
	//OpenGalaxyRewardBoxUI();

	// var test_data = new Object();
	// test_data.allAwards = new Array(5);
	// test_data.curAward = new Object();
	// test_data.curAward.progress_txt = "[4/8]xxxxxxx";
	// test_data.curAward.progress = 50;
	// test_data.curAward.can_get = true;
	// test_data.curAward.awards = new Array();
	// SetGalaxyRewardInfo(test_data);
}


function OpenGalaxyRewardBoxUI()
{
	g_RewardBox._visible = true;
	g_RewardBox.gotoAndPlay("opening_ani");

	g_GalaxyReward._visible = true;
	g_GalaxyReward.gotoAndPlay("opening_ani");

}

function SetGalaxyRewardInfo(info_data)
{
	trace("-------info=" + info_data.curAward.progress_txt)
	GalaxyRewardInfos = info_data;
	SetProgressInfo(info_data);
	SetGalaxyBoxInfo(info_data);

	g_PopupReward.bg_btn.onRelease = function()
	{
		ClosePopupReward();
	}
}


function ClosePopupReward()
{
	g_PopupReward._visible = false;
}

//info.curAward.progress_txt
//info.curAward.progress
function SetProgressInfo(infos)
{
	if (infos.curAward == undefined)
	{
		g_GalaxyReward._visible = false;
		return
	}
	g_GalaxyReward._visible = true;
	g_GalaxyReward.progress_show.progress_txt.html = true
	g_GalaxyReward.progress_show.progress_txt.htmlText = infos.curAward.progress_txt1;
	trace("--------infos.progress=" + infos.curAward.progress)
	g_GalaxyReward.progress_bar.gotoAndStop(infos.curAward.progress + 1);
	if (infos.curAward.can_get)
	{
		g_GalaxyReward.btn_box.gotoAndStop(2);
	}else
	{
		g_GalaxyReward.btn_box.gotoAndStop(1);
	}
	g_GalaxyReward.showrewards.onRelease = function()
	{
		CurSelectRewardInfo = GalaxyRewardInfos.curAward;
		SetPopupRewardInfo();
	}
}

function SetGalaxyBoxInfo(infos)
{
	if (infos.allAwards.length <= 0)
	{
		g_RewardBox._visible = false;
		g_RewardBox.onRelease = undefined;
		return;
	}
	g_RewardBox._visible = true;

	g_RewardBox.red_point.num_txt.text = infos.allAwards.length;
	g_RewardBox.onRelease = function()
	{
		var award_info = GalaxyRewardInfos.allAwards[0];
		if (award_info == undefined)
		{
			trace("cant get galaxy reward!")
			return;
		}
		CurSelectRewardInfo = award_info;
		SetPopupRewardInfo();
	}
}

function SetPopupRewardInfo()
{
	if (CurSelectRewardInfo == undefined)
	{
		return;
	}
	g_PopupReward._visible = true;
	g_PopupReward.gotoAndPlay("opening_ani");
	g_PopupReward.title.title_txt.text = CurSelectRewardInfo.galaxy_name;
	g_PopupReward.info.progress_txt.html = true
	g_PopupReward.info.progress_txt.htmlText = CurSelectRewardInfo.progress_txt;
	g_PopupReward.info.progress_bar.gotoAndStop(CurSelectRewardInfo.progress + 1);
	if (CurSelectRewardInfo.can_get)
	{
		g_PopupReward.info.goto_btn._visible = false;
		g_PopupReward.info.claim_btn._visible = true;
		g_PopupReward.info.awards.gotoAndStop(2);
		g_PopupReward.info.target_planet_txt._visible = false;
		g_PopupReward.info.goto_btn.onRelease = undefined;
		g_PopupReward.info.claim_btn.onRelease = function()
		{
			fscommand("WorldMapCmd", "GetGalaxyReward\2" + CurSelectRewardInfo.chapter_id);
		}
	}else
	{
		g_PopupReward.info.goto_btn._visible = true;
		g_PopupReward.info.claim_btn._visible = false;
		g_PopupReward.info.awards.gotoAndStop(1);
		g_PopupReward.info.target_planet_txt._visible = true;
		g_PopupReward.info.target_planet_txt.html = true;
		g_PopupReward.info.target_planet_txt.htmlText = CurSelectRewardInfo.target_planet_name;
		g_PopupReward.info.goto_btn.onRelease = function()
		{
			fscommand("WorldMapCmd", "GetGalaxyReward\2" + CurSelectRewardInfo.chapter_id + "\2" + CurSelectRewardInfo.target_planet_id);
		}
		g_PopupReward.info.claim_btn.onRelease = undefined;
	}

	for(var i = 1; i <= 6; ++i)
	{
		var award_info = CurSelectRewardInfo.awards[i - 1];
		var item_mc = g_PopupReward.info.awards["award_" + i];
		if (award_info == undefined)
		{
			item_mc._visible = false;
		}else
		{
			item_mc._visible = true;
			SetItemIcon(item_mc, award_info);
		}
	}
}

function SetItemIcon(mc, info)
{
	var icon_data = info.iconInfo;
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
	mc.txt_num.text = info.count;
}