_root.toluastr = ""

function SetDicts(dict)
{
	for (var mcpath in dict)
	{
		var arrayName = mcpath.split(".");
		var obj = _root
		for (var i=0; i<arrayName.length; i++)
		{
			obj = obj[arrayName[i]]
			if (obj == undefined)
			{
				trace("[bad dict] " + mcpath+" "+arrayName[i])
				break
			}
		}
		obj.text = dict[mcpath]
	}

}

function GetVisibleInfo_obj(obj)
{
	var desc = ""
	do
	{
		if (obj == undefined)
		{
			desc = desc + "{"+"obj:"+" undefined}"
			return desc
		}
		desc = desc + "{"+"obj:"+obj._name  +",vis:"+obj._visible+",alpha:"+obj._alpha+",nf:"+obj._currentframe+"}"
		obj = obj._parent
	} while(obj != undefined)
	return desc
}

function GetObjByPath(strpath)
{
	var arrayName = strpath.split(".");
	var obj = _root
	for (var i=0; i<arrayName.length; i++)
	{
		obj = obj[arrayName[i]]
		if (obj == undefined)
		{
			trace( "xxpp {"+"obj:"+arrayName[i]+" undefined}")
			return undefined
		}
		//desc = desc + "{"+"obj:"+arrayName[i]+",vis:"+obj._visible+",alpha"+obj._alpha+",nf:"+obj._currentframe+"}"
	}
	return obj;
}


function GetVisibleInfo(strpath)
{
	var arrayName = strpath.split(".");
	var obj = _root
	var desc = ""
	for (var i=0; i<arrayName.length; i++)
	{
		obj = obj[arrayName[i]]
		if (obj == undefined)
		{
			desc = desc + "{"+"obj:"+arrayName[i]+" undefined}"
			return desc
		}
		//desc = desc + "{"+"obj:"+arrayName[i]+",vis:"+obj._visible+",alpha"+obj._alpha+",nf:"+obj._currentframe+"}"
	}
	return desc
}


// not tested for multy path
function GetPosition($mc:MovieClip)
{
	var $pt:Object = { x : $mc._x, y : $mc._y };
	var tmp = $mc
	do 
	{
		tmp.localToGlobal($pt);
		//tmp = tmp._parent
		//trace("xxpp GetPosition "+tmp._name)
	} while (false)
	return $pt;
}

/*
function SetGlobalPosition($mc:MovieClip, $pt:Object)
{
	$mc._parent.globalToLocal($pt);
	$mc._x = $pt.x
	$mc._y = $pt.y
}
*/
//------------------------------------------
function GetObjInfo_mc(mc, desc)
{
	var adesc = desc.split(".");
	var desc = ""
	for (var i=0; i<adesc.length; i++)
	{
		if (adesc[i] == "pos") {
			desc = desc+mc._x+"\2"+mc._y;
		}
		else if (adesc[i] == "gpos") {
			var pt = GetPosition(mc)
			desc = desc+pt.x+"\2"+pt.y;
		}
		else if (adesc[i] == "size") {
			desc = desc+mc._width+"\2"+mc._height
		}
		else {
			_root.toluastr = ""
			return  _root.toluastr
		}
		if (i!=adesc.length-1)
			desc = desc + "\2"
	}
	_root.toluastr = desc
	return  desc
}
// path is form of : fte.tmp
// LuaObjectManager:InvokeASFunc('FlashHeroListUI','GetObjInfo', story.guide.path, "gpos.size")
function GetObjInfo(strpath, desc)
{
	var mc = GetObjByPath(strpath)
	if (mc == undefined) {
		_root.toluastr = ""
		return  _root.toluastr
	}
	return GetObjInfo_mc(mc, desc)
}



