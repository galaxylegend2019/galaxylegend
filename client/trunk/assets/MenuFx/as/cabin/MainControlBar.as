//for the cabin top show

var head_info=_root.main.head_info
var tab_bottom=_root.main.tab_bottom
var bottomIsOpen=false
this.onLoad = function()
{
	tab_bottom._visible=false
	_root.bg._visible=false
	_root.main.btn_right._visible=false
}


//_root.main.btn_control.onRelease=function()
//{
	/*******FTE*******/
	//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickShowMainControlBtn");
	/*******End*******/
	//bottomIsOpen=!bottomIsOpen
	//SetBottomPlay(bottomIsOpen)
//}

/*
_root.main.btn_control.onRelease=function()
{
	bottomIsOpen=!bottomIsOpen
	SetBottomPlay(bottomIsOpen)
}
*/

_root.main.btn_left.onRelease=function()
{
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickShowMainControlBtn");

	SetBottomPlay(true)
}
_root.main.btn_right.onRelease=function()
{
	SetBottomPlay(false)
}

_root.bg.onRelease=function()
{
	SetBottomPlay(false)
}

//for show the unread flag
function UpdateUnread(datas)
{
	var flag=datas.isArenaUnread or datas.isMailUnread or datas.isItemUnread or datas.isSetUnread
	showUnread(_root.main.unread,flag)
	showUnread(tab_bottom.btn_arena,datas.isArenaUnread)
	showUnread(tab_bottom.btn_mail,datas.isMailUnread)
	showUnread(tab_bottom.btn_item,datas.isItemUnread)
	showUnread(tab_bottom.btn_setting,datas.isSetUnread)
	showUnread(tab_bottom.btn_alliance,datas.isUnionUnread)
}


tab_bottom.btn_arena.onRelease=function()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickMainJJCBtn");
	/*******End*******/
	fscommand("CabinCommand","State\2Arena")
}
tab_bottom.btn_mail.onRelease=function()
{
	fscommand("CabinCommand","State\2Mail")
}
tab_bottom.btn_item.onRelease=function()
{
	fscommand("CabinCommand","State\2Item")
}
tab_bottom.btn_setting.onRelease=function()
{
	fscommand("CabinCommand","State\2Setting")
}
tab_bottom.btn_army.onRelease=function()
{
	fscommand("CabinCommand","State\2Army")
}
tab_bottom.btn_alliance.onRelease=function()
{
	fscommand("CabinCommand","State\2Alliance")
}




function SetBottomPlay(flag)
{
	_root.main.btn_left._visible=!flag
	_root.main.btn_right._visible=flag
	if(flag==true)
	{
		tab_bottom._visible=true
		tab_bottom.gotoAndPlay("opening_ani")
		fscommand("CabinCommand","State\2Open")
		_root.bg._visible=true
	}else
	{
		tab_bottom.gotoAndPlay("closing_ani")
		fscommand("CabinCommand","State\2Close")
		tab_bottom.OnMoveOutOver=function()
		{
			this._visible=false
		}
		_root.bg._visible=false
	}
}

function showUnread(mc,isShow)
{
	//mc=_root
	var tempName="unreadMC"
	if(mc[tempName]==undefined)
	{
		var xPos=mc._width
		if(mc.hit!=undefined)
		{
			xPos=mc.hit._width
		}
		mc.attachMovie("icon_unread",tempName,mc.getNextHighestDepth(),{_x:xPos-27,_y:0})
	}
	mc[tempName]._visible=isShow
}

//--------------------------------------for play ui animation----------------------
function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
	}else
	{
		_root._visible=false
	}
}

function PlayJJCAni()
{
	_root.main.tab_bottom.btn_arena.gotoAndPlay("new_ani")
}

function SetJJCVisible(flag)
{
	_root.main.tab_bottom.btn_arena._visible=flag
}
