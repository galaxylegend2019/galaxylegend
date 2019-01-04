import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;


this.onLoad = function(){
	init();
}

function init(){
	
}

_root.btn_bg.onPress = function()
{
	fscommand("CityCommand", "IsModelClick"+'\2'+"enable");
}

_root.btn_bg.onRelease = function()
{
	//no click through
}