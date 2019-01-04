var info=_root.info
var mc_content=info.pop_content
var UIData
var ItemListData
_root.onLoad=function()
{
SetUIData()
}

function SetUIData(obj)
{
	UIData=obj
	ItemListData=UIData.ItemList


	mc_content.main_ui.FormationsQueueInfo.queueText.text=UIData.queueText
	InitList()
	SetButton()
}

function InitList()
{
	var ui_drag_list = mc_content.main_ui.item_list.item_list
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("item_list_all",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		var QueueData=ItemListData[index_item - 1]
		var mc_item_info//=mc.list_item
		if(QueueData)
		{
			mc._visible=true
			SetNumber(mc.list_item_1.index_plane.index_plane,QueueData.armyIndex)
			mc.list_item_1._visible=!QueueData.isEnemy
			mc.list_item_2._visible=QueueData.isEnemy
			if(QueueData.isEnemy==true)
			{
				mc_item_info=mc.list_item_2
			}else
			{
				mc_item_info=mc.list_item_1
			}

			mc_item_info.player_name_text.htmlText = QueueData.playerName;
			mc_item_info.combat_text.htmlText=QueueData.combatNumber
			mc_item_info.enemy_text.htmlText=QueueData.armyNumber

			if (mc_item_info.headIcon.hero_icons.icons == undefined)
			{
				mc_item_info.headIcon.hero_icons.loadMovie("CommonPlayerIcons.swf");
			}
			mc_item_info.headIcon.hero_icons.IconData = QueueData.IconData;
			if(mc_item_info.headIcon.hero_icons.UpdateIcon) 
			{
				mc_item_info.headIcon.hero_icons.UpdateIcon(); 
			}

		}else
		{
			mc._visible=false
		}


	}

	if(ItemListData==undefined)
	{
		return
	}

	var itemLength=ItemListData.length
	for( var i=1; i <= itemLength ; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
}

function SetNumber(mc,num)
{
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;

	mc.gotoAndStop(nLength)

	for(var i = 0; i < nLength; ++i)
	{
		var item=mc["num_"+(i+1)]

		var temp = Number(arrayNum[i]);
		item.gotoAndStop(temp + 1)
	}
}

function SetButton()
{
	mc_content.main_ui.FormationsQueueInfo.btn_goto_me.onRelease=function()
	{
		fscommand("MapCommand","goto_me")
	}

	mc_content.btn_close.onRelease=function()
	{
		SetUIPlay(false)	
	}
	info.bg.onRelease=function()
	{
		SetUIPlay(false)	
	}
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		mc_content.gotoAndPlay("opening_ani")
		fscommand("MapCommand","UIOpen\2"+this.UIID)
	}else
	{
		mc_content.gotoAndPlay("closing_ani")
		mc_content.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+this.UIID)
		}
	}
}