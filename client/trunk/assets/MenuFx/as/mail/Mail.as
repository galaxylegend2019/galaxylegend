import common.CTextEdit;

var MailID
var ListDatas
var AttachDatas
var LastFocusBtn
var MailContent
var CurMailType
var CurBox = 0
var MailInfoList = undefined;
function testData()
{
	var obj:Array=new Array()
	var itemLength=20
	for(var i=0;i<itemLength;i++)
	{
		var item=new Object()
		item.mailName=random(400)
		item.isAttach=false
		item.mailDate="10/12"
		item.mailTime="10:15"
		if(i%2==0)
		{
			item.isAttach=true
		}
		obj.push(item)
	}

	return obj
}

this.onLoad=function()
{

	_root.mail_content._visible=false


	RegistEvent()
	CurMailType = "SysMail";
	_root.switch_buttons.btn_SysMail.gotoAndStop(2)
	LastFocusBtn=_root.switch_buttons.btn_SysMail

	SetMailCount()
	//ShowMailContent()
}

function RegistEvent()
{

	_root.top.OnMoveOutOver = function()
	{
		fscommand("MailCommand","btnClose")
		_root._visible=false
	}

	_root.top.btn_close.onRelease=function()
	{
		_root.top.gotoAndPlay("closing_ani");
		_root.switch_buttons.gotoAndPlay("closing_ani");
		_root.mail_main.gotoAndPlay("closing_ani");
	}

	var btns:Array=new Array("SysMail","EventMail","UserMail","ArchiveMail")
	for(var i=0;i<btns.length;i++)
	{
		var btnType=btns[i]
		var btn=_root.switch_buttons["btn_"+btnType]
		btn.btnType=btnType
		btn.box = i
		btn.onRelease=function()
		{
			if(LastFocusBtn!=undefined)
			{
				LastFocusBtn.gotoAndStop(1)
			}
			this.gotoAndStop(2)
			LastFocusBtn=this
			var mailData = new Array();
			ShowMailList(mailData)
			fscommand("MailCommand","ClickTap\2"+this.btnType)
			CurMailType=this.btnType
			CurBox = this.box
			fscommand("PlaySound","sfx_ui_selection_2")
			_root.mail_main.btn_oneKeyGet._visible=this.btnType=="SysMail"
		}


	}
	var mailData = new Array();
	ShowMailList(mailData)

	_root.mail_main.btn_delete._visible=false
	_root.mail_main.btn_delete.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")

		var IDList=GetSelectMC()
		if(IDList==undefined)
		{
			return
		}
		fscommand("MailCommand","Delete\2"+IDList)
	}
	_root.mail_main.btn_deleteall.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		fscommand("MailCommand","OneKeyDelete")
	}
	_root.mail_main.btn_oneKeyGet.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		fscommand("MailCommand","OneKeyGet")
	}
	_root.mail_main.btn_write.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		fscommand("MailCommand","Write")
	}

}

//--------------------------for mail attach--------------------------
/*function ShowMailAttach(datas)
{
	if(datas==undefined or datas.length==0)
	{
		trace("as datas is nil ")
		return
	}
	var mc_attach
	var itemCount=datas.length
	if(itemCount<=5)
	{
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
			this._visible=false
		}
	}
}
function attachList(datas)
{
	AttachDatas=datas
	var listView=_root.mail_attach_len.popup_list.board
	listView.clearListBox();
	listView.initListBox("mail_attach_popup",0,true,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc,index_item){

		for(var i = 0; i < 5 ; i++ )
		{
			var item=mc["item"+(i+1)]
			var itemData = AttachDatas[(index_item - 1) * 5 + i ]
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
	var count=AttachDatas.length/5
	for( var i=1; i <= count ; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}*/


//------------------------------------for mail list box --------------------------------------
function SetMailCount(datas)
{
	MailInfoList = datas
	var btns:Array=new Array("SysMail","EventMail","UserMail","ArchiveMail")
	for(var i=0;i<btns.length;i++)
	{
		var btnType=btns[i]
		var btn=_root.switch_buttons["btn_"+btnType]
		var count=MailInfoList[i].unread
		btn.tips.tt.text=count

		btn.tips._visible=count > 0

		if(count==undefined)
		{
			btn.tips._visible=false
		}
	}
}

function ShowMailList(datas)
{
	_root.switch_buttons._visible=true
	_root.mail_main.btn_delete._visible=false
	ListDatas=datas
	if(ListDatas==undefined)
	{
		return
	}
	var listView=_root.mail_main.mail_list.board
	listView.clearListBox();
	listView.initListBox("mail_main_board_all",0,true,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc,index_item){
		if (ListDatas.length - index_item <= 3)
		{
			fscommand("MailCommand","RequestPageMail\2"+CurMailType)
		}

		var itemData=ListDatas[index_item-1]
		if(itemData!=undefined)
		{
			SetAllMailTitle(mc,itemData)
		}
		mc.itemData=itemData
		var btn=mc.is_select
		var drag_bg=mc.drag_bg
		btn.onRelease=function(){
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
				MailTitleSelect(this._parent);
			}
		}
		drag_bg.onRelease=function(){
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
				MailOpen(this._parent);
			}
		}
		btn.onReleaseOutside =drag_bg.onReleaseOutside= function(){
			this._parent._parent.onReleasedInListbox();
		}
		btn.onPress =drag_bg.onPress =function(){
			this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
	}

	for( var i=1; i <= ListDatas.length ; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}

function UpdateListDatas( datas )
{	
	var listView=_root.mail_main.mail_list.board
	var lastDatas = ListDatas
	ListDatas = datas
	if (datas.length > lastDatas.length)
	{
		for(var i = lastDatas.length; i < datas.length; ++i)
		{
			listView.addListItem(i + 1, false, false);
		}
	}else if (datas.length < lastDatas.length)
	{
		for(var i = datas.length; i < lastDatas.length; ++i)
		{
			listView.eraseItem(i + 1);
		}
	}
	listView.needUpdateVisibleItem();
}

function MailOpen(mc)
{
	var id=mc.itemData._id
	fscommand("MailCommand","OpenMail\2"+id)
}

function MailTitleSelect(mc)
{
	//mc.unread.normal_state._visible=false
	//mc.unread.click_state._visible=true

	mc.itemData.isSelect=!mc.itemData.isSelect
	if(mc.itemData.isSelect==true)
	{
		//mc.is_select.gotoAndStop(2)
		mc.unread.normal_state.is_select.gotoAndStop(2)
		mc.isread.normal_state.is_select.gotoAndStop(2)
	}else
	{
		//mc.is_select.gotoAndStop(1)
		mc.unread.normal_state.is_select.gotoAndStop(1)
		mc.isread.normal_state.is_select.gotoAndStop(1)
	}

	var IDList=GetSelectMC()
	_root.mail_main.btn_delete._visible=!(IDList==undefined)

	//mc.unread.normal_state.is_select.gotoAndStop(2)
	//fscommand("MailCommand","Checked\2")

	//ShowMailContent()
}

function SetAllMailTitle(mc,datas)
{
	SetMailTitle(mc.unread.normal_state,datas)
	mc.unread.normal_state._visible=false
	SetMailTitle(mc.unread.click_state,datas)
	mc.unread.click_state._visible=false
	SetMailTitle(mc.isread.normal_state,datas)
	mc.isread.normal_state._visible=false
	SetMailTitle(mc.isread.click_state,datas)
	mc.isread.click_state._visible=false
	if(datas.status=="old")
	{
		mc.isread.normal_state._visible=true
	}else
	{
		mc.unread.normal_state._visible=true
	}
}

function SetMailTitle(mc,datas)
{
	if(datas.isSelect==true)
	{
		mc.is_select.gotoAndStop(2)
	}else
	{
		mc.is_select.gotoAndStop(1)		
	}
	mc.mail_name.text=datas.mailName
	mc.mail_date.text=datas.mailDate
	mc.mail_time.text=datas.mailTime
	if (datas.isAttach and datas.isGet == 0)
	{
		mc.is_attach._visible= true;
	}else
	{
		mc.is_attach._visible = false;
	}
	
}



//------------------------------------for show mail content--------------------------------
function GetSelectMC()
{
	if(ListDatas==undefined)
	{
		return
	}
	var str
	for(var i=0;i<ListDatas.length;i++)
	{
		var item=ListDatas[i]
		if(item.isSelect==true)
		{
			if(str==undefined)
			{
				str=item._id	
			}else
			{
				str+="\2"+item._id
			}
		}
	}
	return str
}


function ShowMailContent(datas)
{
    SetPlay(_root.mail_content,true)
    _root.mail_content.content_title.receive_name.text=datas.fromName
	_root.mail_content.content_title.mail_theme.text=datas.mailName


    MailContent = datas

	//
	_root.mail_content.btn_reply._visible=!MailContent.isAttach

	//_root.mail_content.btn_keep._visible=CurMailType=="UserMail"
	
	_root.mail_content.btn_delete.onRelease=function()
	{
		fscommand("MailCommand","Delete")
		SetPlay(_root.mail_content,false)
	}

	_root.mail_content.btn_keep._visible=CurMailType!="ArchiveMail"
	_root.mail_content.btn_keep.onRelease=function()
	{
		fscommand("MailCommand","Favorite")
		SetPlay(_root.mail_content,false)
	}
	
	if (MailContent.isAttach and MailContent.isGet == 0)
	{
		_root.mail_content.btn_get._visible = true;
		_root.mail_content.btn_reply._visible = false;
		_root.mail_content.btn_get.onRelease=function()
		{
			fscommand("MailCommand","GetAction")
			SetPlay(_root.mail_content,false)
		}
	}else
	{
		_root.mail_content.btn_get._visible = false;
		_root.mail_content.btn_reply._visible=MailContent.type=="user" or MailContent.type=="userarchive"
		_root.mail_content.btn_reply.onRelease=function()
		{
			fscommand("MailCommand","Reply")
			SetPlay(_root.mail_content,false)
		}
	}

	_root.mail_content.bg_shield.onRelease=function()
	{
		_root.mail_content.bg_shield=undefined
		SetPlay(_root.mail_content,false)
	}
	InitMailText()
}

function InitMailText()
{
	var MaxLine=820

	var listView=_root.mail_content.content_main.content_list

	listView.setSpecialItemHeight("mail_attach_board",0)
	listView.clearListBox();
	listView.initListBox("mail_content_all",0,true,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc,index_item){

		if(index_item==1)
		{
			mc.ui_text.tt.html = true
			mc.ui_text.tt.htmlText=MailContent.body
			mc.ui_text.bg._height=mc.ui_text.tt.textHeight

			mc.ui_text._visible=true
			mc.ui_item._visible=false
			mc.ItemHeight=mc.ui_text.bg._height//listView._getItemHeight(mc.ui_text)

			//var myformat = mc.tt.getTextFormat()
			//trace(myformat.size)
			mc.onRelease=function(){
				this._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
					//MailTitleSelect(this._parent);
				}
			}

			mc.onReleaseOutside = function(){
				this._parent.onReleasedInListbox();
			}
			mc.onPress =function(){
				this._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}
		}else
		{
			mc.ui_text._visible=false
			mc.ui_item._visible=true

			mc.ItemHeight=listView._getItemHeight(mc.ui_item)
			for(var i=0;i<6;i++)
			{
				var item=mc.ui_item["item"+(i+1)]
				var datas=MailContent["item"][i]
				SetActionIcons(item,datas)
			}
		}

	}
	var count=1
	if(MailContent.isAttach==true)
	{
		count=2
	}
	for( var i=1; i <=count; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}

function SetActionIcons(mc,datas)
{
	var item=mc
	if(datas==undefined)
	{
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


//----------------------------------------for common function-----------------------------
function SetPlay(mc,flag)
{
	if(flag==true)
	{
		mc._visible=true
		mc.gotoAndPlay("opening_ani")
	}else
	{
		if(mc._visible==false)
		{
			return
		}
		mc.gotoAndPlay("closing_ani")
		mc.OnMoveOutOver=function()
		{
			this._visible=false
		}
	}
}

function SetMoneyData(datas)
{
    _root.top.money.money_text.text = datas.money;
    _root.top.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = _root.top.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}