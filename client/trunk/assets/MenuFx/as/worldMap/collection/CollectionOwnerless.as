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
	obj.coordinate="sdfsdf"
	obj.oreName="asd"
	obj.oreCount="999999"
	obj.isFavorite=true
	obj.level="99"

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
	info.desc_title.pop_title.coord_text.text       		=UIData.coordinate
	info.desc_title.pop_title.name.text             			=UIData.name

	if(UIData.mType!=undefined)
	{
		info.desc_title.pop_title.m_type.text 			=UIData.mType
		info.desc_title.pop_title.m_status.text 			=UIData.mStatus	
	}

	info.info.battle_number.text     						=UIData.oreCount
	info.info.level.text       								=UIData.level
	info.info.name.text       								=UIData.oreName
}

function SetButton()
{
	var btns=info.tab_bottom
	btns.btn_collection.onRelease=function()
	{
		fscommand("MapCommand","Collection")
	}
	btns.btn_attack.cost.cost_num.text=UIData.attackCost

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
	var btn_star=info.desc_title.star.btn_favorite
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
