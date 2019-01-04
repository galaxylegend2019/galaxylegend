import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;


init();

function init(){
	_root.bg1.bnt_exit.onRelease = function(){
		fscommand("ExitBack");
	}

	_root.attack_content.attack_btn.onRelease = function(){
		fscommand("GotoNextMenu", "GS_Battle");
	}
}