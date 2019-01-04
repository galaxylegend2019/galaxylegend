var info=_root.info
var UIData
var isPopInfo=false
_root.onLoad=function()
{
	//for test as fun
	var obj=testF()
	//SetUIData(obj)
}

function testF()
{
	var obj=new Object()
	obj.coordinate="xxx=xxx"
	obj.name="xxxx"
	obj.battleNumber="999999"
	obj.baseNumber="99"
	obj.isFavorite=true
	obj.attackCost="99"

	return obj
}

function SetUIData(obj)
{
	UIData=obj

	SetContent()
	
	SetButton()

	SetIcon()
}

function SetContent()
{
	info.desc_title.pop_title.coord_text.text       =UIData.coordinate
	info.desc_title.pop_title.name.text             	=UIData.name
	info.info.battle_number.text     				=UIData.battleNumber
	
	if(UIData.mType!=undefined)
	{
		info.desc_title.pop_title.m_type.text 	=UIData.mType
		info.desc_title.pop_title.m_status.text 	=UIData.mStatus	
	}
}

function SetButton()
{
	var btns=info.tab_bottom
	btns.btn_attack.onRelease=function()
	{
		fscommand("MapCommand","Attack")
	}
	btns.btn_attack.cost.cost_num.text=UIData.attackCost

	info.info.btn_detail.onRelease=function()
	{
		fscommand("MapCommand","ArmyDetail\2"+UIData.UIID)
	}
	info.info.btn_team.onRelease=function()
	{
		fscommand("MapCommand","TeamDetail\2"+UIData.UIID)
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
	for(var i=0;i<5;i++)
	{
		var item=UIData.ItemDatas[i]
		var itemIconData
		if(item.IconData!=undefined)
		{
			itemIconData=item.IconData
			_root.info.info["item_"+(i+1)].res_type=item.res_type
			_root.info.info["item_"+(i+1)].res_id=item.id
			_root.info.info["item_"+(i+1)].onRelease=function()
			{
				fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
			}
		}else
		{
			itemIconData=item
		}

		if(_root.info.info["item_"+(i+1)].icons==undefined)
		{
			_root.info.info["item_"+(i+1)].loadMovie("CommonIcons.swf")
		}
		_root.info.info["item_"+(i+1)].IconData=itemIconData

		if(_root.info.info["item_"+(i+1)].UpdateIcon)
		{
			_root.info.info["item_"+(i+1)].UpdateIcon()
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