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

}

function SetContent()
{
	info.info.pop_title.coord_text.text       			=UIData.coordinate
	info.info.pop_title.name.text              			=UIData.name
	info.desc_title.pop_title.m_type.text                	=UIData.mType

	if(UIData.btnType=="MB_OK")
	{
		info.info.btn_ok._visible=false
		info.info.btn_move_base._visible=false
		info.info.single_ok._visible=true
	}else
	{
		info.info.btn_ok._visible=true
		info.info.btn_move_base._visible=true
		info.info.single_ok._visible=false
	}
}

function SetButton()
{
	var btns=info.info
	btns.btn_ok.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickMoveBtn");
		/*******End*******/
		fscommand("MapCommand","MoveShip")
	}
	btns.btn_ok.cost.cost_num.text=UIData.moveShipCost
	btns.single_ok.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickMoveBtn");
		/*******End*******/
		fscommand("MapCommand","MoveShip")
	}
	btns.single_ok.cost.cost_num.text=UIData.moveShipCost
	btns.btn_move_base.onRelease=function()
	{
		fscommand("MapCommand","MoveBase")
	}
	btns.btn_move_base.cost.cost_num.text=UIData.moveBaseCost
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
	info.info.bg.onRelease=function()
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
