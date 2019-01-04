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

var g_btn_Select = _root.btn_Select;
var g_isSelected = false;

//cs functions
_root.onLoad = function()
{
	SetServers()
}

function SetServers(servers)
{
	for(var i = 0; i < servers.length; ++i)
	{
		var obj = g_btn_Select;
		if(i > 0)
		{
			obj = g_btn_Select.duplicateMovieClip("btn_Select_" + i, this.getNextHighestDepth(), g_btn_Select);
			obj._y = g_btn_Select._y + i * 90;
		}

		obj.txt_Txt.text = servers[i][0] + "    " + servers[i][1];
		obj.my_index = i;
		
		obj.onRelease = function()
		{
			if(not g_isSelected)
			{
				fscommand("SelectServer", this.my_index + 1);
				fscommand("GotoNextMenu", "GS_MainMenu");
				g_isSelected = true;
			}
		}
	}
}