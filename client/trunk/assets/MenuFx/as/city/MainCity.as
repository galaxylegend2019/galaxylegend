import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;
import common.CTextEdit;


var mc_player_info=_root.player_info

var MAX_BUILDING_COUNT=10
var MenuDatas
var isShowMenu=false

var mc_last_building
var mc_buidings
var isShowMessage=false
var buildingData=undefined

var mc_time=undefined

var g_TaskHudNum = 0;
var g_TaskHudInfos = undefined;
var g_TaskHudOpen = false;
var g_TaskInitPage = 1;

_root.onLoad = function()
{
	//testAs()

	_root.building_info._visible=false
	_root.black_bg._alpha=2

	//_root.player_info.tab_bottom.btn_show._visible=false
	_root.player_info.tab_bottom.btn_hide._visible=false


	_root.test_building._visible=false

	_root.player_info.tab_bottom.button_list._visible=false

	_root.topUI.attachMovie("bloodBarBg","buiding_detail",_root.topUI.getNextHighestDepth(),{_x:0,_y:0})
	_root.topUI.buiding_detail.loadMovie("Building_Ui.swf")
	_root.topUI.buiding_detail.main._visible=false
	_root.topUI.buiding_detail.bg._visible=false

	_root.topUI.attachMovie("bloodBarBg","buiding_tech",_root.topUI.getNextHighestDepth(),{_x:0,_y:0})
	_root.topUI.buiding_tech.loadMovie("BuildingTech.swf")

	_root.topUI.buiding_tech._visible=false

	_root.btn_task_article._visible = false;
	_root.btn_article_shadow._visible = false;
	_root.btn_article_shadow1._visible = false;

	_root.player_info.tab_bottom.task_icon._visible = false;
	_root.player_info.tab_bottom.task_bar._visible = false;

}

function testAs()
{
	var obj=new Object()
	obj.namess="zhangsan"
	obj.num="100"
	for(var i in obj )
	{
		trace("----------")
		trace(i)
		trace(obj[i])
	}
}

function init()
{
	InitEditText();
}

function InitUIInfo(inputMenuData:Array)
{
	// fscommand("CityCommand","IsModelClick"+'\2'+"enable")

	MenuDatas=inputMenuData
	var btn_Arraw=_root.player_info.tab_bottom.btn_arrow
	showUnread(btn_Arraw,false)
	for(var i=0;i<MenuDatas.length;i++)
	{
		if(MenuDatas[i].isUnread==true)
		{
			showUnread(btn_Arraw,true)
		}
	}


	mc_buidings=new Array()
	for(var i=0;i<MAX_BUILDING_COUNT;i++)
	{
		var tempName="mc_building_"+i
		_root.messageBox.attachMovie("building_info",tempName,_root.messageBox.getNextHighestDepth(),{_x:0,_y:0})
		mc_buidings[i]=_root.messageBox[tempName]
		mc_buidings[i]._visible=false
		mc_buidings[i].timeShow._visible=false
		mc_buidings[i].buiding_detail._visible=false

	}
}

function InitButtons()
{

	var tab_bottom=_root.player_info.tab_bottom
	tab_bottom.gotoAndPlay("move_in")

	tab_bottom.button_list._visible=true
	tab_bottom.button_list.gotoAndPlay("move_in")
	tab_bottom.line_bg.gotoAndPlay("move_in")

	tab_bottom.line_bg._width=1000

	var mc_bottons=tab_bottom.button_list.ViewList
	for(var i=1;i<=8;i++)
	{
		var menuData=MenuDatas[i-1]	
		var btn=mc_bottons["btn_"+i]

		if(menuData.isUnread==true)
		{
			showUnread(btn,true)
		}else
		{
			showUnread(btn,false)
		}

		if(MenuDatas.length<i)
		{
			btn._visible=false
			continue
		}
		mc_bottons.test1._x=btn._x
		mc_bottons.test2._x=btn._x

		btn.menuData=menuData
		btn.btn_name.btn_name_text.text=menuData.btnNameText
		btn.iconIndex=i
		btn.item_icons.gotoAndStop(i)


		btn.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			var strPage=this.menuData.pageName
			fscommand("GotoNextMenu",strPage)
			_root._visible=false
		}

	}

	if(g_TaskHudOpen)
	{
		SwitchTaskHud();
	}
	tab_bottom.task_icon.btn_swtich.onRelease = function(){}
	tab_bottom.task_icon.btn_switch2.onRelease = function(){}
}

_root.player_info.tab_bottom.btn_arrow.onRelease=hideAndShow

function hideAndShow()
{
	isShowMenu=!isShowMenu

	if(isShowMenu)
	{
		tab_bottom.button_list._visible=true
		_root.player_info.tab_bottom.gotoAndStop("move_in")
		_root.player_info.tab_bottom.btn_arrow.gotoAndStop("opening_ani")
		InitButtons()
		fscommand("CityCommand","openButtons")
		// fscommand("CityCommand","IsModelClick"+'\2'+"disable")
	}else
	{
		var tab_bottom=_root.player_info.tab_bottom
		tab_bottom.gotoAndPlay("move_out")
		_root.player_info.tab_bottom.btn_arrow.gotoAndStop("closing_ani")

		tab_bottom.button_list.gotoAndPlay("move_out")
		tab_bottom.button_list._visible=false
		tab_bottom.line_bg.gotoAndPlay("move_out")

		tab_bottom.button_list.OnMoveOutOver=function()
		{
			this.OnMoveOutOver=undefined
			//this.onRelease=undefined
			this._visible=false
		}

		fscommand("CityCommand","closeButtons")
		// fscommand("CityCommand","IsModelClick"+'\2'+"enable")

		_root.player_info.tab_bottom.task_icon.btn_swtich.onRelease = function()
		{
			SwitchTaskHud();
		}
		_root.player_info.tab_bottom.task_icon.btn_switch2.onRelease = function()
		{
			SwitchTaskHud();
		}

	}

	_root.player_info.tab_bottom.btn_arrow.onRelease=hideAndShow

	tab_bottom.OnMoveOutOver = function()
	{
	}
}


function SetButtonsVisible(flag)
{
	hideAndShow()
}

function UpdateResource(inputPlayerData:Array)
{
	mc_player_info.credit.credit_text.text=inputPlayerData.credit

	mc_player_info.money.money_text.text=inputPlayerData.money

	UpdateBuildingResource(inputPlayerData)
}

function UpdatePoint(inputPlayerData:Array)
{
	mc_player_info.energy.energy_text.text=inputPlayerData.energy

	UpdateBuildingPoint(inputPlayerData)
}

function InitPlayerInfo(inputPlayerData:Array)
{

/*	if(mc_player_info.player_info.player_icon.icons==undefined)
	{
		mc_player_info.player_info.player_icon.loadMovie("CommonHeros.swf")
	}
	mc_player_info.player_info.player_info.icons.hero_icons.gotoAndStop("hero_Hero")*/

	//mc_vip_level
	var mc_vip_level=mc_player_info.player_info.vip_level
	if(inputPlayerData.vipLevel!=undefined)
	{
		var vipNum=(new Number(inputPlayerData.vipLevel)).toString()
		var strSize=vipNum.length
		for(var i=0;i<2;i++)
		{
			if (i>=strSize)
			{
				mc_vip_level["num_"+(i+1)]._visible=false
			}else
			{
				mc_vip_level["num_"+(i+1)]._visible=true
				var curIndex=new Number(vipNum.charAt(i))+1
				mc_vip_level["num_"+(i+1)].gotoAndStop(curIndex)
			}
		}
	}

	mc_player_info.player_info.player_level.player_level.level_text.htmlText=inputPlayerData.level
	mc_player_info.player_info.player_name.player_name_text.text=inputPlayerData.playerName
	

	var process_num=inputPlayerData.exp/inputPlayerData.nextExp
	if(process_num<=1)
	{
		process_num=1
	}
	mc_player_info.num_processBar.num_processBar.gotoAndStop(process_num)


}

function ResetBuilding()
{
	if(mc_last_building!=undefined)
	{
		//mc_last_building.gotoAndStop(1)
		mc_last_building.buiding_info.gotoAndPlay("opening_ani")
		mc_last_building.buiding_detail.gotoAndPlay("closing_ani")

		mc_last_building.buiding_detail.OnMoveOutOver=function()
		{
			mc_last_building.buiding_detail._visible=false
			this.OnMoveOutOver=undefined
		}

		if(mc_last_building.mcData.isCity==true)
		{
			mc_last_building.city_level._visible=true
			mc_last_building.city_level.level_text.text=mc_last_building.mcData.cityLevel
		}else
		{
			mc_last_building.city_level._visible=false
		}
		mc_last_building.city_name.name_text.text=mc_last_building.mcData.btnNameText
		showUnread(mc_last_building.city_name,mc_last_building.mcData.isUnread)

	}
}

function UpdateBuildingDetail(buildingData)
{
	_root.topUI.buiding_detail.main.UpdateBuildingInfo(buildingData)
}

function UpdateBuildingResource(inputData)
{
	_root.topUI.buiding_detail.main.UpdateBuildingResource(inputData)
}
function UpdateBuildingPoint(inputData)
{
	_root.topUI.buiding_detail.main.UpdateBuildingPoint(inputData)
}

function UpdateTime(timeStr)
{
	_root.topUI.buiding_detail.main.UpdateTime(timeStr)
}

//update the time for city upgrade
function UpdateUpgradeTime(inputData)
{

	if(mc_time!=undefined)
	{
		if(inputData.isFinish==false)
		{
			mc_time._visible=true
			mc_time.exp_process_bar.time_text.text=inputData.timeStr
			mc_time.exp_process_bar.gotoAndStop(inputData.process)
		}else
		{
			mc_time._visible=false
		}
	}
	
}

function ShowBuildingDetail(buildingData)
{
/*	if(_root.topUI.buiding_detail.main==undefined)
	{
		_root.topUI.buiding_detail.loadMovie("Building_Ui.swf")
		trace("loadMovie building_ui")
	}*/

	if(buildingData.cityType=="research" && buildingData.showType==2)
	{
		_root.topUI.buiding_tech._visible=true
		_root.topUI.buiding_tech.InitMC(_root.topUI.buiding_tech)
		_root.topUI.buiding_tech.InitData(buildingData)
	}else
	{
		_root.topUI.buiding_detail.main._visible=true
		_root.topUI.buiding_detail.main.InitMC(_root.topUI.buiding_detail.main)
		_root.topUI.buiding_detail.main.ShowBuildingInfo(buildingData)
	}

}

function ClickInfo(clickInfo)
{

}



function ClickBuiding(modelName,buildingInfo)
{
	buildingData=buildingInfo

	// fscommand("CityCommand","IsModelClick"+'\2'+"disable")
	isShowMessage=true
	for(var i=0;i<MAX_BUILDING_COUNT;i++)
	{
		var mc=mc_buidings[i]
		if(mc.mcData!=undefined)
		{
			if(mc.mcData.modelName==modelName)
			{
				ResetBuilding()

				mc.buiding_info.gotoAndPlay("closing_ani")
				mc.buiding_detail._visible=true
				mc.buiding_detail.gotoAndPlay("opening_ani")

				mc.buiding_detail.access_name.name_text.text=buildingInfo.accessText
				mc.buiding_detail.btn_access.onRelease=function()
				{
					fscommand("PlayMenuConfirm")
					//fscommand("CityCommand","access")
					if(buildingData!=undefined)
					{
						buildingData.showType=2
						ShowBuildingDetail(buildingData)
					}

				}

				mc.buiding_detail.detail_name.name_text.text=buildingInfo.detailText
				mc.buiding_detail.btn_detail.onRelease=function()
				{
					fscommand("PlayMenuConfirm")
					//fscommand("CityCommand","detail")
					if(buildingData!=undefined)
					{
						buildingData.showType=1
						ShowBuildingDetail(buildingData)
					}

				}

				mc.buiding_detail.upgrade_name.name_text.text=buildingInfo.upgradeText
				mc.buiding_detail.btn_upgrade.onRelease=function()
				{
					fscommand("PlayMenuConfirm")
					//fscommand("CityCommand","upgrade")
					if(buildingData!=undefined)
					{
						buildingData.showType=3
						ShowBuildingDetail(buildingData)
					}

				}
				mc_last_building=mc

			}
		}
	}
}

_root.black_bg.onRelease=function()
{
	//fscommand("CityCommand","IsModelClick")

	ResetBuilding()

	if(isShowMessage==true)
	{
		// fscommand("CityCommand","IsModelClick"+'\2'+"enable")
		isShowMessage=false
	}

	if(isShowMenu)
	{
		hideAndShow()
	}
}

_root.black_bg.onPress = function()
{
	if(isShowMessage || isShowMenu)
	{

	}
	else
	{
		fscommand("CityCommand","IsModelClick"+'\2'+"enable")
	}
}


function SetBuildingUnread(cityName,isUnread)
{
	for(var i=0;i<inputDetailData.length;i++)
	{
		var mcData=inputDetailData[i]
		var mc=mc_buidings[i]

		if(mcData.cityName==cityName)
		{
			mcData.isUnread=isUnread
			showUnread(mc.building_info.city_name,mcData.isUnread)
		}
	}
}

function UpdateBuidingInfo(inputDetailData:Array)
{
	for(var i=0;i<inputDetailData.length;i++)
	{
		var mcData=inputDetailData[i]
		var mc=mc_buidings[i]

		mc._visible=true
		if(mcData.isOpen==false)
		{
			mc._visible=false
		}else
		{
			mc.mcData=mcData
			mc._x=mcData.xPos
			mc._y=mcData.yPos

			if(mcData.isCity==true)
			{
				mc.building_info.city_level._visible=true
				mc.building_info.city_level.level_text.text=mcData.cityLevel
				mc_time=mc.timeShow
				//mc_time._visible=true
			}else
			{
				mc.building_info.city_level._visible=false
			}
			mc.building_info.city_name.name_text.text=mcData.btnNameText
			showUnread(mc.building_info.city_name,mcData.isUnread)

		}
	}	
}



//---------------control tech ui for main city--------------

function ShowTechBuilding()
{

}















function SetMCVisible()
{
	_root._visible=false
}

function SetUIPlay()
{
	mc_player_info.gotoAndPlay("opening_ani")
}

mc_player_info.OnMoveInOver = function()
{
	mc_player_info.credit.btn_add.onRelease = function()
	{
		_root.black_bg.onRelease()
		fscommand("GoToNext", "Purchase");
	}
	mc_player_info.money.btn_add.onRelease = function()
	{
		_root.black_bg.onRelease()
		fscommand("GoToNext", "Affair");

	}
	mc_player_info.energy.btn_add.onRelease = function()
	{
		_root.black_bg.onRelease()
		fscommand("CityCommand","buyEnergy")
	}

	mc_player_info.task_info.btn_Task.onRelease = function()
	{
		//fscommand("TaskCommand", "SetInitPage" + '\2' + g_TaskInitPage);
		fscommand("GotoNextMenu", "GS_Alliance")
		trace("GotoNextMenu GS_Alliance")
	}
}



//for keep icons
function keepIcon(mc)
{
	mc.gotoAndStop(mc._parent.iconIndex)
}


function showUnread(mc,isShow)
{
	if(isShow==undefined)
	{
		return
	}
	var tempName="unreadMC"
	if(mc[tempName]==undefined)
	{
		var xPos=mc._width
		mc.attachMovie("icon_tip_unread",tempName,mc.getNextHighestDepth(),{_x:xPos,_y:0})
	}
	mc[tempName]._visible=isShow
}

function SetTaskTip(tipIcon)
{
	var tipMC = mc_player_info.task_info.task_tips;
	if(tipIcon > 0)
	{
		tipMC._visible = true;
		tipMC.gotoAndStop(tipIcon);
	}
	else
	{
		tipMC._visible = false;
	}
}

function SetTaskArticle(isEnable, articleTxt)
{
	if(isEnable)
	{
		g_TaskInitPage = 1;
		_root.btn_task_article._visible = true;
		_root.btn_task_article.txt_Article.text = articleTxt;

		_root.btn_task_article.onRelease = function()
		{
			fscommand("TaskCommand", "SetInitPage" + '\2' + g_TaskInitPage);
			fscommand("GotoNextMenu", "GS_Task");
		}
		_root.btn_article_shadow._visible = true;
		_root.btn_article_shadow.onRelease = function()
		{
			SetTaskArticle(false);
		}
	}
	else
	{
		g_TaskInitPage = 1;
		_root.btn_task_article._visible = false;
		_root.btn_article_shadow._visible = false;
		_root.btn_task_article.onRelease = undefined;
		_root.btn_article_shadow.onRelease = undefined;
	}
}

_root.player_info.tab_bottom.task_icon.btn_swtich.onRelease = function()
{
	SwitchTaskHud();
}
_root.player_info.tab_bottom.task_icon.btn_switch2.onRelease = function()
{
	SwitchTaskHud();
}

function SetTaskHudInfo(num, infos)
{
	g_TaskHudNum = num;
	g_TaskHudInfos = infos;
	impSetTaskHudInfo();
}

function SwitchTaskHud()
{
	var task_icon = _root.player_info.tab_bottom.task_icon;
	var task_bar = _root.player_info.tab_bottom.task_bar;
	if(g_TaskHudOpen)
	{
		g_TaskHudOpen = false;
	}
	else
	{
		g_TaskHudOpen = true;
	}
	impSetTaskHudInfo();
}

function impSetTaskHudInfo()
{
	var task_icon = _root.player_info.tab_bottom.task_icon;
	var task_bar = _root.player_info.tab_bottom.task_bar;
	task_icon._visible = true;
	task_bar._visible = true;

	// trace("task_icon: " + task_icon);
	// trace("task_bar: " + task_bar);

	if(g_TaskHudOpen)
	{
		task_icon.gotoAndStop("open");
		task_bar.gotoAndStop("open");

		task_bar.btn_task_bg.onRelease = function(){}

		var ViewList = task_bar.task_content.ViewList;
		ViewList.clearListBox();
		if(g_TaskHudNum > 0)
		{
			// trace("ViewList: " + ViewList);
			ViewList.onEnterFrame = function()
			{
				this.initListBox("item_list_task_daily", 0, true, true);
				this.enableDrag( false );
				this.onEnterFrame = function()
				{
					this.OnUpdate();
				}

				this.onItemEnter = function(mc, index_item)
				{
					// trace("mc: " + mc);
					mc._visible = true;
					impSetTaskHudTask(mc, g_TaskHudInfos[index_item]);
				}

				for(var i = 0; i < g_TaskHudNum; ++i)
				{
					this.addListItem(i, false, false);
				}
				this.needUpdateVisibleItem();
			}
		}
	}
	else
	{
		task_icon.gotoAndStop("close");
		task_bar.gotoAndStop("close");

		task_bar.btn_task_bg.onRelease = function(){}
		impSetTaskHudTask(task_bar.task_content, (g_TaskHudInfos == undefined) ? undefined : g_TaskHudInfos[0])
	}
}

function impSetTaskHudTask(clip, info)
{
	// trace("clip: " + clip);
	if(info != undefined && info.isDone)
	{
		clip.gotoAndStop(2);
		clip.btn_task.my_task_id = info.taskID;
		clip.btn_task.onRelease = function()
		{
			fscommand("TaskCommand", "GetAward" + '\2' + this.my_task_id);
			this.onRelease = undefined;
		}
	}
	else
	{
		clip.gotoAndStop(1);
		clip.btn_task.my_task_id = info.taskID;
		clip.btn_task.onRelease = info != undefined ? function()
		{
			fscommand("TaskCommand", "Jump" + '\2' + this.my_task_id);
		} : undefined;
	}
	// trace("txt_Desc: " + clip.txt_Desc);
	clip.btn_task.txt_Desc.html = true;
	clip.btn_task.txt_Desc.htmlText = info != undefined ? info.descTxt : "";
}