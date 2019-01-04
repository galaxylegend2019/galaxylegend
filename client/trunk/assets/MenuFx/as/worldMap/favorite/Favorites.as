var info=_root.info
var btn_tab=_root.info.info
var UIID

_root.onLoad=function()
{
	var obj=new Object()
	obj.UIID="SSS"
	obj.FocusBtn="Ene3my"
	//SetUIData(obj)
}

function ResetBtn(index_item)
{
	var mcName=new Array("btn_friend_bg","btn_enemy_bg","btn_resource_bg","btn_important_bg")
	for(var i=0;i<mcName.length;i++)
	{
		btn_tab[mcName[i]]._visible=false
	}
	btn_tab[mcName[index_item]]._visible=true
}
function SetBtnFocus(str)
{
	if(str=="Friend")
	{
		ResetBtn(0)
	}else if (str=="Enemy")
	{
		ResetBtn(1)	
	}else if (str=="Resource")
	{
		ResetBtn(2)
	}else if(str=="Important")
	{
		ResetBtn(3)
	}else
	{
		ResetBtn(4)
	}
}

btn_tab.btn_friend.onRelease=function()
{
	ResetBtn(0)
	fscommand("MapCommand","Favorite\2Friend")
}
btn_tab.btn_enemy.onRelease=function()
{
	ResetBtn(1)
	fscommand("MapCommand","Favorite\2Enemy")
}
btn_tab.btn_resource.onRelease=function()
{
	ResetBtn(2)
	fscommand("MapCommand","Favorite\2Resource")
}
btn_tab.btn_important.onRelease=function()
{
	ResetBtn(3)
	fscommand("MapCommand","Favorite\2Important")
}

_root.bg.onRelease=function()
{
	SetUIPlay(false)
}

function SetUIData(info)
{
	UIID=info.UIID
	SetBtnFocus(info.FocusBtn)

	SetUIPlay(true)
}

_root.info.info.bg.onRelease=function()
{
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		info.gotoAndPlay("opening_ani")
		fscommand("MapCommand","UIOpen\2"+UIID)
	}else
	{
		info.gotoAndPlay("closing_ani")
		info.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+UIID)
		}
	}
}