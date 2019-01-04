import flash.geom.Point;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_SelectItem;

class com.tap4fun.utils.Utils
{
	static var __DEBUG__ = false

	static function getGlobalPosition(obj)
	{
	    var pt = {x : 0, y : 0}
	    if (obj)
	    {
	    	obj.localToGlobal(pt)
	    }    
	    return pt
	}

	static function isMouseOver(obj : Object)
	{
	    var x = _root._xmouse
	    var y = _root._ymouse
	    var pt = getGlobalPosition(obj)

	    if(__DEBUG__)
	    {
		    trace("1 " + x + " " + pt.x + " " + (pt.x + obj._width))
		    trace("2 " + y + " " + pt.y + " " + (pt.y + obj._height))
	    }
	    return x >= pt.x && x <= (pt.x + obj._width) && y >= pt.y && y <= (pt.y + obj._height);
	}

	static function getFullName(obj)
	{
	    var path : String = ''
	    while (obj != null) {
	        path = obj._name + '.' + path
	        obj = obj._parent
	    }
	    if (path.length == 0) return path
		var begin = path.charAt(0) == '.' ? 1 : 0
		var end = path.charAt(path.length - 1) == '.' ? path.length - 1 : path.length
		return path.slice(begin, end)
	}


	static function SetPlayMC(mc, playType, isLockInput)
	{
		if(__DEBUG__)
		{
			trace("SetPlayMC: " + mc._visible + " " + getFullName(mc) + " " + playType);
		}

		if(!mc._visible || playType == LuaSA_MCPlayType.PlayNone)
		{
			return;
		}

		if(playType == LuaSA_MCPlayType.PlayIn)
		{
			if(__DEBUG__)
			{
				trace("show");
			}
			if(isLockInput || isLockInput == undefined)
			{
				fscommand('LockInput');
			}
			mc.gotoAndPlay("show");
		}
		else if(playType == LuaSA_MCPlayType.PlayOut)
		{
			if(__DEBUG__)
			{
				trace("hide");
			}
			if(isLockInput || isLockInput == undefined)
			{
				fscommand('LockInput');
			}
			mc.gotoAndPlay("hide");
		}
		else
		{
			if(__DEBUG__)
			{
				trace("Idle");
			}
			mc.gotoAndStop("Idle");
		}
	}

	static function SwitchSelectItem(mc)
	{
		if(mc.state == LuaSA_SelectItem.Select)
		{
			mc.gotoAndPlay("hide");
			mc.state = LuaSA_SelectItem.Unselect;
		}
		else if(mc.state == LuaSA_SelectItem.Unselect)
		{
			mc.gotoAndPlay("show");
			mc.state = LuaSA_SelectItem.Select;
		}
	}

	static function InitSelectItem(mc, state)
	{
		if(state == LuaSA_SelectItem.Select)
		{
			mc.gotoAndStop("showEnd");
		}
		else if(state == LuaSA_SelectItem.Unselect)
		{
			mc.gotoAndStop("hideEnd");
		}
		mc.state = state;
	}

	static function SwitchSelectItem2(mc)
	{
		if(mc.selectState == LuaSA_SelectItem.Select)
		{
			if(mc.defaultState == undefined)
			{
				mc.defaultState = "Unselected";
			}
			mc.gotoAndStop(mc.defaultState);
			mc.selectState = LuaSA_SelectItem.Unselect;
		}
		else if(mc.selectState == LuaSA_SelectItem.Unselect)
		{
			mc.gotoAndStop("Selected");
			mc.selectState = LuaSA_SelectItem.Select;
		}
	}

	static function InitSelectItem2(mc, state)
	{
		if(state == LuaSA_SelectItem.Select)
		{
			mc.gotoAndStop("Selected");
		}
		else if(state == LuaSA_SelectItem.Unselect)
		{
			if(mc.defaultState == undefined)
			{
				mc.defaultState = "Unselected";
			}
			mc.gotoAndStop(mc.defaultState);
		}
		mc.selectState = state;
	}

	static function ltrim (str) 
	{ 
	    var size = str.length; 
	    for (var i = 0; i < size; i ++) 
	    { 
	        if (str.charCodeAt (i) > 32) //解释：空格，tab,回车，换行charCode小于32 
	        { 
	            return str.substring (i); 
	        }
	    } 
	    return ""; 
    }
    //按钮中的消耗的资源图标和number居中对齐
    static function ButtonIconAndNumberMidSide(mc)
    {
        var allWidth = mc.icon._width + mc.txt_Price.textWidth + 5;
        mc.icon._x = (mc.hit._width - allWidth) / 2;
        mc.txt_Price._x = mc.icon._x + mc.icon._width + 5;
    }

    static function ButtonIconAndNumberMidSideDiscount(mc)
    {
        var allWidth = mc.icon._width + mc.txt_Price.textWidth + mc.txt_OldPrice.textWidth + 10;
        mc.icon._x = (mc.hit._width - allWidth) / 2;
        mc.txt_OldPrice._x = mc.icon._x + mc.icon._width + 5;
        mc.line._x = mc.txt_OldPrice._x + 7;
        mc.txt_Price._x = mc.txt_OldPrice._x + mc.txt_OldPrice.textWidth + 5;
    }
}




