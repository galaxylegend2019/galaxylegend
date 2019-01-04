var enemy_info=_root.enemy_info
var mc_message
var ui_drag_list=enemy_info.double_content.info.item_list
var infoLists
var UIID
_root.onLoad=function()
{
	//for test info is correct
	//testF()
}

function testF()
{
	var testDatas=new Array()

	for(var i=0;i<1;i++)
	{
		testDatas[i]=new Object()
		testDatas[i].enemyList=new Array()
		testDatas[i].enemyTimes="times "+i
		for(var j=0;j<6;j++)
		{
			var obj=new Object()
			obj.blood=random(5)+1
			obj.star=random(5)+1

			testDatas[i].enemyList[j]=obj
		}
	}
	SetTitleInfo(testDatas)
}


function SetTitleInfo(obj,ID)
{
	if(obj==undefined)
	{
		trace("the Enemy data is undefined in EnemyInfoPopup.as function SetEnemyInfo")
		return
	}

	infoLists=obj
	UIID=ID
	if(infoLists.length==1)
	{
		enemy_info.double_content._visible=false
		enemy_info.single_content._visible=true
		mc_message=enemy_info.single_content

		enemy_info.single_content.gotoAndPlay("opening_ani")
		var item_list=enemy_info.single_content.info.info1
		SetInfoList(item_list,infoLists[0])
	}else
	{
		enemy_info.single_content._visible=false
		enemy_info.double_content._visible=true
		mc_message=enemy_info.double_content

		enemy_info.double_content.gotoAndPlay("opening_ani")
		SetEnemyItemList()
	}

	_root.bg.onRelease=function()
	{
		SetUIPlay(false)
	}

}

_root.bg.onRelease=function()
{
	SetUIPlay(false)
}

function SetUIPlay(flag)
{
	if(mc_message==undefined)
	{
		_root._visible=false
		return
	}

	if(flag==true)
	{
		_root._visible=true
		mc_message.gotoAndPlay("opening_ani")
	}else
	{
		mc_message.gotoAndPlay("closing_ani")
		mc_message.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+UIID)
		}
	}
}

function SetInfoList(item_list:MovieClip,EnemyInfoList:Array)
{
	//for icon,level,name,battle_number
	if(item_list.headIcon.hero_icons.icons==undefined)
	{
		item_list.headIcon.hero_icons.loadMovie("CommonIcons.swf")
	}
	item_list.headIcon.hero_icons.IconData=EnemyInfoList.HeroIconData
	if(item_list.headIcon.hero_icons.UpdateIcon)
	{
		item_list.headIcon.hero_icons.UpdateIcon()
	}
	item_list.level.text=EnemyInfoList.level
	item_list.player_name.text=EnemyInfoList.playerName
	item_list.battle_number.text=EnemyInfoList.battleNumber

	var MAX_MC_COUNT=6
	for(var i=0;i<MAX_MC_COUNT;i++)
	{
		var item=item_list["item"+(i+1)]
		//trace("item")
		//trace(item)
		var itemData=EnemyInfoList.enemyList[i]

		SetItemInfo(item,itemData)
	}
}

//for enemy info item
function SetItemInfo(item,EnemyInfo)
{
	if(EnemyInfo==undefined)
	{
		item._visible=false
		return
	}
	item.blood.gotoAndStop(EnemyInfo.blood+1)							//blood Num ,cur Max count is 6,from 0 to 5
	item.icon_info.star_plane.star.gotoAndStop(EnemyInfo.star)		//set star num, cur Max count is 5,from 1 to 5

	//there is no icon info
	//item.icon_info.icon_info.loadMovie()				//load Enemy icon for show
	if(item.icon_info.icon_info.icons==undefined)
	{
		item.icon_info.icon_info.loadMovie("CommonIcons.swf")
	}
	item.icon_info.icon_info.IconData=EnemyInfo.IconData
	if(item.icon_info.icon_info.UpdateIcon)
	{
		item.icon_info.icon_info.UpdateIcon()
	}
}

function SetEnemyItemList()
{
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("item_list",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		var itemData=infoLists[index_item-1]
		var mc_item
		mc.info2._visible=false
		mc.info1._visible=false
		if(index_item!=1)
		{
			mc.info1._visible=true
			mc_item=mc.info1
		}else
		{
			mc.info2._visible=true
			mc_item=mc.info2
		}
		mc_item.pos.index_number.text=index_item-1
		SetInfoList(mc_item,itemData)
	}

	ui_drag_list.onItemMCCreate = function(mc)
	{
		mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	var listLength=infoLists.length
	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
}