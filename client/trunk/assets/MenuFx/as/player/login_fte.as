

var g_MainUI = _root.main;

this.onLoad = function()
{
	init()
}

function init()
{
	g_MainUI._visible = false;
}

function move_in()
{
	g_MainUI._visible = true;
	g_MainUI.board.btn_continue.onRelease = function()
	{
		fscommand("AccountCmd", "Login_Continue");
	}
	g_MainUI.board.btn_txt.onRelease = function()
	{
		fscommand("AccountCmd", "Login_ShowExist");
	}
}

function move_out()
{
	g_MainUI._visible = false;
}


function move_in_end(txt)
{
	g_MainUI._visible = true;
	//g_MainUI.mask._visible = false;
	g_MainUI.bg._visible = false;
	g_MainUI.board.btn_txt._visible = false;
	g_MainUI.board.LC_UI_ACCOUNT_FTE_TEXT.text = txt
	g_MainUI.gotoAndPlay("opening_ani")
	g_MainUI.board.btn_continue.onRelease = function()
	{
		move_out()
	}
}


function test()
{
	trace("test")
	this.onLoad = function(){
		Selection.setFocus(g_MainUI)
	}
	g_MainUI.onPress = function()
	{
		trace("xxx "+Key.getCode())
		if(Key.getCode() == 49)
		{
			move_in_end("xxxttt")
		}
		else if(Key.getCode() == 50)
		{
			move_out()
		}
	}
}
//test()