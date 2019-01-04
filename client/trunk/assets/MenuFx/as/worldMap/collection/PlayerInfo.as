var mc_message=_root.messageBox
var info=mc_message.info

var MAX_TYPE_COUNT=6
var UIData
var UIID
_root.onLoad=function()
{
	//////---------for test as run
/*	trace("load player info")
	var obj=testF()
	SetTitleInfo(obj)*/
}

function testF()
{
	var testObj=new Object()

	testObj.titleText="lalalalala"
	testObj.soldiers=new Array()

	for(var i=0;i<MAX_TYPE_COUNT;i++)
	{
		var obj=new Object()
		obj.star=random(5)+1
		obj.blood=random(5)
		testObj.soldiers.push(obj)
	}

	return testObj
}

function SetTitleInfo(obj,ID)
{
	UIData=obj
	UIID=ID
	info.title_text.title_text.text=UIData.titleText

	SetSoldierList()

	_root.messageBox.bg.onRelease=function()
	{
		SetUIPlay(false)
	}
}

function SetSoldierList()
{
	for(var i=0;i<MAX_TYPE_COUNT;i++)
	{
		var item=info["item"+(i+1)]
		item._visible=false
		item.itemData=UIData.soldiers[i]
		if(item.itemData!=undefined)
		{
			SetSoldierInfo(item)
		}
	}	
}

function SetSoldierInfo(item)
{
	item._visible=true
	var itemData=item.itemData
	//icon
	if(item.icon_info.icon_info.icons==undefined)
	{
		item.icon_info.icon_info.loadMovie("CommonHeros.swf")
	}
	item.icon_info.icon_info.IconData=itemData.IconData
	if(item.icon_info.icon_info.UpdateIcon)
	{
		item.icon_info.icon_info.UpdateIcon()
	}
	//star
	item.icon_info.star_plane.star.gotoAndStop(itemData.star)
	//blood
	item.blood.gotoAndStop(itemData.blood+1)
	item.shield.gotoAndStop(itemData.shield+1)

}


function SetUIPlay(flag)
{
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