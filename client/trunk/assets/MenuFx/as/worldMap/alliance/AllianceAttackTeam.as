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
	obj.coordinate="xxx=xxx"
	obj.name="xxxx"
	obj.battleNumber="999999"
	obj.baseNumber="99"
	obj.isFavorite=true

	return obj
}

function SetUIData(obj)
{
	UIData=obj

	SetContent()
	
	SetButton()
}

function SetContent()
{
	info.desc_title.pop_title.coord_text.text       	=UIData.coordinate
	info.desc_title.pop_title.name.text             		=UIData.name
	info.info.battle_number.text     					=UIData.battleNumber
	info.info.base_number.text       					=UIData.baseNumber
	info.desc_title.pop_title.m_type.text                	=UIData.mType

	info.info.teamText.htmlText=UIData.teamText
}

function SetButton()
{
	var btns=info.tab_bottom
	btns.btn_attack.onRelease=function()
	{
		fscommand("MapCommand","Attack")
	}
	btns.btn_guest_book.onRelease=function()
	{
		fscommand("MapCommand","GuestBook")
	}
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
