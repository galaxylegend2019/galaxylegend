import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

function getChildrenOf(movie)
{
	var ret = [];
	for(i in movie)
	{
		var ch = movie[i];
		if(ch instanceof MovieClip)
		{
			ret.push(ch);
		}
	}	
	return ret;
}

var g_message_1 = _root.message_1; //one button
var g_message_2 = _root.message_2; //two buttons
var g_message_3 = _root.message_3; //three buttons
var g_curBtnNum = 1;

var g_message_timer = _root.message_timer;

// trace("g_message_1.message_bar.txt_message._x: " + g_message_1.message_bar.txt_message._x);
// trace("g_message_2.message_bar.txt_message._x: " + g_message_1.message_bar.txt_message._x);
// trace("g_message_timer.txt_message._x: " + g_message_timer.txt_message._x);
// trace("g_message_timer._x: " + g_message_timer._x);
// g_message_1.content_bar.message_bar.txt_message._x = 10; //bugs, these two coord chagned to other value in unity, but fine in flash cs
// g_message_2.content_bar.message_bar.txt_message._x = 10;
// g_message_3.content_bar.message_bar.txt_message._x = 10;


//cs functions
_root.onLoad = function()
{
	Init();
	// ShowMessageBox(1, "1", "2");
}

function Init()
{
	g_message_1._visible = false;
	g_message_2._visible = false;
	g_message_3._visible = false;
	g_message_timer._visible = false;
	btn_bg_message_timer._visible = g_message_timer._visible;

	// g_message_1.bg_shield.setBlurBackground(true);
	// g_message_2.bg_shield.setBlurBackground(true);
	// g_message_3.bg_shield.setBlurBackground(true);
}

g_message_1.OnMoveInOver = function()
{
	this.btn_ok.onRelease = function()
	{
		fscommand("OnMessageBoxClicked", 1)
		this.onRelease = undefined;
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_confirm_purchase");
	}

	this.btn_bg.onRelease = function(){}
	this.btn_shield.my_btn = this.btn_ok;
	this.btn_shield.onRelease = function()
	{
		this.my_btn.onRelease();
	}
}

g_message_1.OnMoveOutOver = function()
{
	this.btn_ok.onRelease = undefined;
	this.btn_bg.onRelease = undefined;
	this.btn_shield.onRelease = undefined;
	this._visible = false;
}

g_message_2.OnMoveInOver = function()
{
	this.btn_ok.onRelease = function()
	{
		fscommand("OnMessageBoxClicked", 1)
		this.onRelease = undefined;
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_confirm_purchase");
	}

	this.btn_close.onRelease = function()
	{
		fscommand("OnMessageBoxClicked", 2)
		this.onRelease = undefined;
		// fscommand("PlayMenuBack");
		fscommand("PlaySound", "sfx_ui_cancel");
	}

	this.btn_bg.onRelease = function(){}
	this.btn_shield.my_btn = this.btn_close;
	this.btn_shield.onRelease = function()
	{
		this.my_btn.onRelease();
	}
}

g_message_2.OnMoveOutOver = function()
{
	this.btn_ok.onRelease = undefined;
	this.btn_close.onRelease = undefined;
	this.btn_bg.onRelease = undefined;
	this.btn_shield.onRelease = undefined;
	this._visible = false;
}

g_message_3.OnMoveInOver = function()
{
	this.btn_ok.onRelease = function()
	{
		fscommand("OnMessageBoxClicked", 1)
		this.onRelease = undefined;
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_confirm_purchase");
	}

	this.btn_2.onRelease = function()
	{
		fscommand("OnMessageBoxClicked", 2)
		this.onRelease = undefined;
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_confirm_purchase");
	}

	this.btn_close.onRelease = function()
	{
		fscommand("OnMessageBoxClicked", 3)
		this.onRelease = undefined;
		// fscommand("PlayMenuBack");
		fscommand("PlaySound", "sfx_ui_cancel");
	}

	this.btn_bg.onRelease = function(){}
	this.btn_shield.my_btn = this.btn_close;
	this.btn_shield.onRelease = function()
	{
		this.my_btn.onRelease();
	}
}

g_message_3.OnMoveOutOver = function()
{
	this.btn_ok.onRelease = undefined;
	this.btn_2.onRelease = undefined;
	this.btn_close.onRelease = undefined;
	this.btn_bg.onRelease = undefined;
	this.btn_shield.onRelease = undefined;
	this._visible = false;
}



function ShowMessageBox(btnNum : Number, titleTxt : String, contentTxt : String, btnTxts)
{
	g_curBtnNum = btnNum;
	if(btnNum == 1)
	{
		g_message_1._visible = true;
		// g_message_1.title_bar.txt_Title.text = titleTxt;
		g_message_1.message_bar.txt_message.text = contentTxt;
		g_message_1.btn_ok.txt_txt.text = btnTxts[0];
		g_message_1.gotoAndPlay("opening_ani");
		fscommand("PlaySound", "sfx_ui_menu_appears");

		g_message_2._visible = false;
		g_message_3._visible = false;
	}
	else if(btnNum == 2)
	{
		g_message_2._visible = true;
		// g_message_2.title_bar.txt_Title.text = titleTxt;
		g_message_2.message_bar.txt_message.text = contentTxt;
		g_message_2.btn_ok.txt_txt.text = btnTxts[0];
		g_message_2.btn_close.txt_txt.text = btnTxts[1];
		g_message_2.gotoAndPlay("opening_ani");
		fscommand("PlaySound", "sfx_ui_menu_appears");

		g_message_1._visible = false;
		g_message_3._visible = false;
	}
	else if(btnNum == 3)
	{
		g_message_3._visible = true;
		// g_message_3.title_bar.txt_Title.text = titleTxt;
		g_message_3.message_bar.txt_message.text = contentTxt;
		g_message_3.btn_ok.txt_txt.text = btnTxts[0];
		g_message_3.btn_2.txt_txt.text = btnTxts[1];
		g_message_3.btn_close.txt_txt.text = btnTxts[2];
		g_message_3.gotoAndPlay("opening_ani");
		fscommand("PlaySound", "sfx_ui_menu_appears");

		g_message_1._visible = false;
		g_message_2._visible = false;
	}
}

function HideMessageBox()
{
	if(g_curBtnNum == 1)
	{
		g_message_1.gotoAndPlay("closing_ani");
	}
	else if(g_curBtnNum == 2)
	{
		g_message_2.gotoAndPlay("closing_ani");
	}
	else if(g_curBtnNum == 3)
	{
		g_message_3.gotoAndPlay("closing_ani");
	}
}

function ShowMessageBoxTimer(contentTxt : String)
{
	g_message_timer._visible = true;
	g_message_timer.txt_message.text = contentTxt;
	btn_bg_message_timer._visible = g_message_timer._visible;
}

function HideMessageBoxTimer()
{
	g_message_timer._visible = false;
	btn_bg_message_timer._visible = g_message_timer._visible;
}

btn_bg_message_timer.onRelease = function()
{
	fscommand("HideMessageBoxTimer", "")
}

message_1.btn_contact_us.onRelease = function()
{
    fscommand("OnContactCmd", "contact");
}