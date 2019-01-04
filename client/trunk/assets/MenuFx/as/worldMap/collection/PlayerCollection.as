var info=_root.info
var UIData
var isPopInfo=false
_root.onLoad=function()
{
	//for test as fun
	var obj=testF()
	SetUIData(obj)
}

function testF()
{
	var obj=new Object()
	obj.name="123"
	obj.coordinate="xxx=xxx"
	obj.oreName="xxxx"
	obj.oreCount="999999"
	obj.level="99"
	obj.isFavorite=true
	obj.playerName="playerName"
	obj.attackCost="99"

	return obj
}

function SetUIData(obj)
{
	UIData=obj

	SetContent()
	
	SetButton()

	SetIcon()

	SetArmyData()
}

function SetContent()
{
	info.desc_title.pop_title.coord_text.text       =UIData.coordinate
	info.desc_title.pop_title.name.text             	=UIData.name
	info.desc_title.pop_title.m_type.text            	=UIData.mType

	info.info.battle_number.text     				=UIData.oreCount
	//info.info.base_number.text       =UIData.baseNumber
	info.info.level.text       						=UIData.level
	info.info.name.text       						=UIData.oreName
	info.info.player_name.text       				=UIData.playerName
}

function SetUpdateData(obj)
{
	info.info.count.text       						=obj.curCollectCount
	info.info.maxCount.htmlText       				=obj.maxCollectCount

	var army_info=info.info.army_info
	army_info.progressbar.gotoAndStop(obj.process)
	army_info.left_time.text=obj.leftTime ? obj.leftTime:"99:99:99"
	army_info.uncount.text=obj.uncount

}

function SetButton()
{
	var btns=info.tab_bottom
	btns.btn_recall.onRelease=function()
	{
		fscommand("MapCommand","Recall")
	}

	btns.btn_info.onRelease=function()
	{
		if(isPopInfo==false)
		{
			info.gotoAndPlay("opening_menu")
			isPopInfo=true
		}else
		{
			info.gotoAndPlay("closing_menu")
			isPopInfo=false
		}
	}

	var flag="open"
	if(UIData.isFavorite==false)
	{
		flag="close"
	}

	info.UIID=UIData.UIID
	var btn_star=info.star.btn_favorite
	btn_star.UIID=UIData.UIID
	btn_star.gotoAndStop(flag)
	btn_star.onRelease=function()
	{
		fscommand("MapCommand","Favorites\2"+this.UIID)
	}

	_root.bg.onRelease=function()
	{
		SetUIPlay(false)	
	}
	info.bg.onRelease=function()
	{

	}
}

function SetIcon()
{
	//for ore icon data
	if(info.info.item_icon.icons==undefined)
	{
		info.info.item_icon.loadMovie("CommonIcons.swf")
	}
	info.info.item_icon.IconData=UIData.OreIconData
	if(info.info.item_icon.UpdateIcon)
	{
		info.info.item_icon.UpdateIcon()
	}
	if(UIData.res_type!=undefined)
	{
		info.info.item_icon.res_type=UIData.res_type
		info.info.item_icon.res_id=UIData.id
		info.info.item_icon.onRelease=function()
		{
			fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
		}
	}	
}

function loadIcon(mc,iconData,iconUrl)
{
	if(mc.icons==undefined)
	{
		mc.loadMovie(iconUrl)
	}
	mc.IconData=iconData
	if(mc.UpdateIcon)
	{
		mc.UpdateIcon()
	}
}

function SetArmyData()
{
	var army_info=info.info.army_info
	for(var i=0;i<6;i++)
	{
		var item=army_info["item_"+(i+1)]
		var itemData=UIData.armyDatas[i]

		if(itemData==undefined)
		{
			item._visible=false
		}else
		{
			item._visible=true
			var item_icon=item.icon_info.icon_info
			//loadIcon(item_icon,itemData.IconData,)
			if(item.icon_info.icon_info.icons==undefined)
			{
				item.icon_info.icon_info.loadMovie("CommonHeros.swf")
			}
			item.icon_info.icon_info.IconData=itemData.IconData
			if(item.icon_info.icon_info.UpdateIcon)
			{
				item.icon_info.icon_info.UpdateIcon()
			}

			item.blood.gotoAndStop(itemData.blood+1)
			item.icon_info.star_plane.star.gotoAndStop(itemData.star)			
		}
	}
}


function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		info.gotoAndPlay("opening_ani")
		fscommand("MapCommand","UIOpen\2"+this.UIID)
	}else
	{
		isPopInfo=false
		info.gotoAndPlay("closing_ani")
		info.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+this.UIID)
		}
	}
}
