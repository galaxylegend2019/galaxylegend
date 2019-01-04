
var g_mainUI = _root.main_ui;

this.onLoad = function(){
	init();
}

function init(){
	g_mainUI._visible = false;

	// move_in();
}

function move_in()
{
	g_mainUI._visible = true;
	g_mainUI.gotoAndPlay("opening_ani");
	g_mainUI.bg_btn.onRelease = function(){}
	g_mainUI.OnMoveInOver = function()
	{
		this.bg_btn.onRelease = function()
		{
			this.onRelease = undefined;
			move_out();
		}
	}

	g_mainUI.btn_facebook.onRelease = function()
	{
		fscommand("OnContactCmd", "facebook");
	}
	g_mainUI.btn_forum.onRelease = function()
	{
		fscommand("OnContactCmd", "forum");
	}
	g_mainUI.btn_contact.onRelease = function()
	{
		fscommand("OnContactCmd", "contact");
	}
}

function move_out()
{
	g_mainUI.gotoAndPlay("closing_ani");
	g_mainUI.OnMoveOutOver = function()
	{
		this._visible = false;
	}
}



