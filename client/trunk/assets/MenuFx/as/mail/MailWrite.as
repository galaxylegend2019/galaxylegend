import common.CTextEdit;
var mc_input=_root.mail_write.name_bar
var mc_input_name=_root.mail_write.name_bar.input_name
var mc_input_theme=_root.mail_write.name_bar.input_theme
var mc_input_content=_root.mail_write.input_box.notice_input
var mc_input_content_list = _root.mail_write.input_box.listView
var mc_bg_btn = _root.mail_write.input_box.bg_btn;

this.onLoad=function()
{
	//InitText()
	mc_input_content._visible = false;

	mc_input.input_content._visible = false;
	mc_input.input_bg._visible = false;
}

function InitText()
{
	mc_input_name.init("UIKeyboardTypeDefault", "FlashMailWriteUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, true);
	mc_input_name.setMaxLength(30);
	mc_input_theme.init("UIKeyboardTypeDefault", "FlashMailWriteUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, true);
	mc_input_theme.setMaxLength(30);
	mc_input_content.init("UIKeyboardTypeDefault", "FlashMailWriteUI", "hitzone", "", "content_txt", false, false, '', "TextView", null, null, null, true);
	mc_input_content.setMaxLength(300);

	mc_input_name.posY = mc_input_name._y;
	mc_input_name.onChangeKeyBoardHeight = function ()
	{	
		var g_heightChange = mc_input_name.GetHeightChange();
		mc_input_name._y = mc_input_name.posY - g_heightChange;
	}

	mc_input_theme.posY = mc_input_theme._y;
	mc_input_theme.onChangeKeyBoardHeight = function ()
	{	
		var g_heightChange = mc_input_theme.GetHeightChange();
		mc_input_theme._y = mc_input_theme.posY - g_heightChange;
	}

	mc_input_content.onChangeKeyBoardHeight = function ()
	{	
		var g_heightChange = mc_input_content.GetHeightChange();
		_root._y = 0 - g_heightChange
		//_root.mail_write.input_box._y = mc_input_content.posY - g_heightChange;
	}

	mc_input_content.onHideKeyboard = function()
	{
		//this.hitzone._visible = true;
		var desc = mc_input_content.getInputString();
		//this.hitzone._visible = true;
		mc_input_content._visible = false;
		mc_input_content_list._visible = true;
		SetMailContent(desc);
	}

	mc_input_content.onShowKeyboard = function()
	{
		mc_input_content_list._visible = false;
	}

	SetMailContent("")
}

//-----------------------------for show Mail write------------------------
function ShowMailWrite(datas)
{
	InitText()
	_root._visible=true
	_root.mail_write.gotoAndPlay("opening_ani")
	_root.top.gotoAndPlay("opening_ani")
	_root.bg1.gotoAndPlay("opening_ani")

	trace("datas's receiveName is "+datas.receiveName)

	if(datas!=undefined)
	{
		
		mc_input_name.lua2fs_setText(datas.receiveName)
		//mc_input_theme.lua2fs_setText(datas.mailTheme)
		//mc_input_content.lua2fs_setText(datas.mailContent)
		
	}

	//send  mail to lua
	_root.mail_write.btn_send.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		var name_bar=_root.mail_write.name_bar
		var receiveName=name_bar.input_name.getInputString()
		var theme=name_bar.input_theme.getInputString()
		var mailContent=mc_input_content.getInputString()
		fscommand("MailCommand","SendMail\2"+receiveName+"\2"+theme+"\2"+mailContent)
	}

	//for close
	_root.top.btn_close.onRelease=function()
	{
		_root.mail_write.gotoAndPlay("closing_ani")
		_root.top.gotoAndPlay("closing_ani")
		_root.bg1.gotoAndPlay("closing_ani")
		_root.mail_write.OnMoveOutOver=function()
		{
			_root._visible=false
		}
	}
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root.top.btn_close.onRelease()
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


var AllContentTextMc = new Array();

function ClearContentMc()
{
	for(var i in AllContentTextMc)
	{
		AllContentTextMc[i].removeMovieClip()
	}
	mc_input_content_list.forceCorrectPosition();
}


function SetMailContent(desc)
{
	trace("SetMailContent = " + desc)
	ClearContentMc();
	var CurContent = mc_input_content_list.slideItem.attachMovie("content_txt", "content", mc_input_content_list.slideItem.getNextHighestDepth());
	var old_hight = CurContent._height;
	CurContent.content_txt.html =true;
	CurContent.content_txt.htmlText = desc;
	CurContent._y = 0;

	AllContentTextMc.push(CurContent);

	var endLine = mc_input_content_list.slideItem.attachMovie("content_txt", "content", mc_input_content_list.slideItem.getNextHighestDepth());
	endLine.content_txt.text = "";
	endLine._y = CurContent.content_txt.textHeight;
	endLine._height = 10;
	AllContentTextMc.push(endLine);


	mc_input_content_list.SimpleSlideOnLoad();
	mc_input_content_list.hitZone_panel.onRelease = function()
	{
		this._parent.onReleasedInListbox();

		mc_input_content._visible = true;
		mc_input_content_list._visible = false;
		trace(mc_input_content_list);


		mc_input_content.hitzone.onRelease();
		
		var desc = mc_input_content.getInputString();
		mc_input_content.SetKeyBoardText(desc);
	}
	mc_input_content_list.onEnterFrame = function()
	{
		mc_input_content_list.OnUpdate();
	}
}

