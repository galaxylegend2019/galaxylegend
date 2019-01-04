var AttachDatas
this.onLoad=function()
{
	_root.mail_attach._visible=false
	_root.mail_attach_len._visible=false
}

//--------------------------for mail attach--------------------------
function ShowMailAttach(datas)
{
	if(datas==undefined or datas.length==0)
	{
		trace("as datas is nil ")
		return
	}
	_root._visible=true
	_root.mail_attach._visible=false
	_root.mail_attach_len._visible=false
	var mc_attach
	var itemCount=datas.length
	if(itemCount<=5)
	{
		_root.mail_attach.attach.gotoAndStop(itemCount)
		for(var i=0;i<5;i++)
		{
			var itemData=datas[i]
			var item=_root.mail_attach.attach["item"+(i+1)]
			SetActionIcons(item,itemData)
		}
		mc_attach=_root.mail_attach
	}else
	{
		mc_attach=_root.mail_attach_len
		attachList(datas)	
	}

	mc_attach._visible=true
	mc_attach.gotoAndPlay("opening_ani")

	//for close event
	mc_attach.bg_shield.onRelease=function()
	{
		this._parent.gotoAndPlay("closing_ani")
		this._parent.OnMoveOutOver=function()
		{
			_root._visible=false
		}
	}
}

function attachList(datas)
{
	AttachDatas=datas
	var listView=_root.mail_attach_len.popup_list.board
	listView.clearListBox();
	listView.initListBox("common_attach_popup",0,true,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc,index_item){
		for(var i = 0; i < 5 ; i++ )
		{
			var item=mc["item"+(i+1)]
			var itemData = AttachDatas[(index_item - 1) * 5 + i]
			SetActionIcons(item,itemData)
		}
		mc.onRelease=function(){
			this._parent.onReleasedInListbox();
		}
		mc.onReleaseOutside= function(){
			this._parent.onReleasedInListbox();
		}
		mc.onPress =function(){
			this._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
	}
	var count=math.ceil(AttachDatas.length/5)
	for( var i=1; i <= count ; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}

function SetActionIcons(mc,datas)
{
	var item=mc
	if(datas==undefined)
	{
		trace("the datas is null")
		item._visible=false
		return
	}
	item._visible=true
	if(item.item.icons==undefined)
	{
		item.item.loadMovie("CommonIcons.swf")
	}
	item.item._width=91
	item.item._height=91
	item.item.IconData=datas.IconData
	item.num_text.text=datas.count
	if(item.item.UpdateIcon)
	{
		item.item.UpdateIcon()
	}	
}