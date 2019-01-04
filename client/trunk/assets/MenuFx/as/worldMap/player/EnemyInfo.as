var enemy_info=_root.enemy_info
var mc_message=enemy_info.double_content
var ui_drag_list=enemy_info.double_content.info.item_list
var infoLists
var UIID
_root.onLoad=function()
{
	//for test info is correct
	//trace("this is onLoad")
	//testF()
}

function testF()
{
	var testDatas=new Array()

	for(var i=0;i<2;i++)
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


function SetUIData(obj,ID)
{
	UIID=ID
	infoLists=obj

	enemy_info.double_content.gotoAndPlay("opening_ani")
	SetEnemyItemList()

	_root.bg.onRelease=function()
	{
		SetUIPlay(false)
	}

}

_root.bg.onRelease=function()
{
	SetUIPlay(false)
}

_root.enemy_info.double_content.btn_close.onRelease=function()
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
		fscommand("MapCommand","UIOpen\2"+UIID)
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
	item_list.title_text.title_text.text=EnemyInfoList.enemyTimes
	var MAX_MC_COUNT=6
	for(var i=0;i<MAX_MC_COUNT;i++)
	{
		var item=item_list["item"+(i+1)]
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
	item.shield.gotoAndStop(EnemyInfo.shield+1)
	item.icon_info.star_plane.star.gotoAndStop(EnemyInfo.star)		//set star num, cur Max count is 5,from 1 to 5

	//there is no icon info
	//item.icon_info.icon_info.loadMovie()				//load Enemy icon for show
	if(item.icon_info.icon_info.icons==undefined)
	{
		item.icon_info.icon_info.loadMovie("CommonHeros.swf")
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
		SetInfoList(mc,itemData)
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