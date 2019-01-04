import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

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


//cs functions
this.onLoad = function(){
	fscommand("UnlockInput");
	init();
}

function init()
{
	_root.btn_facebook._visible = false;
	_root.btn_start._visible = false;
	_root.server_bar._visible = false;

	_root.btn_contact.onRelease = function()
	{
		fscommand("LoginInterfaceCmd", "OnContact");
	}

	// SetServerInfo("99999", 1, 1, true);
}

function SetFaceBookLoginText(is_valid,Text){
	if (is_valid){
		_root.btn_facebook.onRelease = function()
		{
			fscommand("LoginInterfaceCmd", "Login");
		}
	}
	else{
		_root.btn_facebook.onRelease = undefined;
	}


	_root.btn_facebook.Fb_Login_text.text = Text;
}

function SetServerInfo(nameTxt, state, flagInfo, isNew)
{
	_root.server_bar._visible = true;
	var server_bar = _root.server_bar;
	server_bar.server_new._visible = isNew;
	server_bar.server_choose.state.gotoAndStop(state);
	server_bar.server_choose.txt_name.text = nameTxt;
	server_bar.server_choose.btn_server.onRelease = function()
	{
		trace("SelectServer");
		fscommand("LoginInterfaceCmd", "SelectServer");
	}

	// if(server_bar.server_choose.flag.icons == undefined)
	// {
	// 	server_bar.server_choose.flag.loadMovie("CommonLaguageFlag.swf")
	// }
	// server_bar.server_choose.flag.IconData = flagInfo;
	// if(server_bar.server_choose.flag.UpdateIcon) { server_bar.server_choose.flag.UpdateIcon(); }
	server_bar.server_choose.txt_locale.text = flagInfo;

	_root.btn_facebook._visible = true;
	_root.btn_start._visible = true;

	_root.btn_start.onRelease = function()
	{
		fscommand("LoginInterfaceCmd", "Start");
	}

}

function SetStartText(txt)
{
	_root.btn_start.txt_start.text = txt;
}
