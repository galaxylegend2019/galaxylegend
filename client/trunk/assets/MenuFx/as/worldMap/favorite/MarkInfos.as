var mc_message=_root.main
var ui_drag_list=mc_message.board.location_list
var UIData
var curData
var btn_tab=_root.main.ttt
var curButton=btn_tab.btn_friend

_root.onLoad=function()
{
	//var obj=testF()
	//SetTitleInfo(obj)
	//InitEvent()
}

function testF()
{
	var obj=new Object()
	obj.friends=new Array()
	for(var i=0;i<5;i++)
	{
		var o=new Object()
		o.id=i
		o.coordinate="12.10"
		obj.friends.push(o)
	}
	obj.enemys=new Array()
	for(var i=0;i<5;i++)
	{
		var o=new Object()
		o.id=i+10
		o.coordinate="122210"
		obj.enemys.push(o)
	}
	return obj
}

function SetTitleInfo(obj:Object)
{
	UpdateData(obj)

	SetUIPlay(true)
	_root.main.bg.onRelease=function()
	{
		SetUIPlay(false)
	}
}

function UpdateData(obj:Object)
{
	UIData=obj
	curButton.onRelease()
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

btn_tab.btn_friend.onRelease=function()
{
	curButton=this	
	ResetBtn(0)
	SetItemList(UIData.friends)
}
btn_tab.btn_enemy.onRelease=function()
{
	curButton=this
	ResetBtn(1)
	SetItemList(UIData.enemys)
}
btn_tab.btn_resource.onRelease=function()
{
	curButton=this
	ResetBtn(2)
	SetItemList(UIData.resoures)
}
btn_tab.btn_important.onRelease=function()
{
	curButton=this
	ResetBtn(3)
	SetItemList(UIData.importants)
}
mc_message.btn_close.onRelease=function()
{
	SetUIPlay(false)
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		mc_message.gotoAndPlay("opening_ani")
	}else
	{
		mc_message.gotoAndPlay("closing_ani")
		mc_message.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+UIData.UIID)
		}
	}
}

function SetItemList(listData)
{
	ui_drag_list.clearListBox();

	if(listData==undefined or listData.length==0)
	{
		mc_message.mc_empty._visible=true
		trace("the listData is undefined is MarkInfos.as")
		return
	}
	mc_message.mc_empty._visible=false


	curData=listData

	ui_drag_list.initListBox("item",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		var itemData=curData[index_item-1]
		if(itemData!=undefined)
		{
			mc._visible=true
			mc.coordinate.text=itemData.coordinate
			mc.id=itemData.id
			mc.btn_delete.onRelease=function()
			{
				this._parent._parent._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					fscommand("MapCommand","DeleteMark\2"+this._parent.id)
				}
			}
			mc.btn_locate.onRelease=function()
			{
				this._parent._parent._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					fscommand("MapCommand","LocateMark\2"+this._parent.id)
					SetUIPlay(false)		
				}
			}
			mc.btn_delete.onReleaseOutside = mc.btn_locate.onReleaseOutside =function()
			{
				this._parent._parent._parent.onReleasedInListbox();
			}
			mc.btn_delete.onPress = mc.btn_locate.onPress= function()
			{
				this._parent._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}
		}else
		{
			mc._visible=false
		}

	}

	ui_drag_list.onItemMCCreate = function(mc)
	{
		mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	var listLength=curData.length
	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
}