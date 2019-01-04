this.onLoad=function()
{
	_root._visible=false
}

function PlayCombat(num)
{
	_root._visible=true
	_root.hero_info.gotoAndPlay(1)
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;

	if(nLength<=3)
	{
		_root.hero_info.extra_num.gotoAndStop("three")
	}else if(nLength<=4)
	{
		_root.hero_info.extra_num.gotoAndStop("four")
	}else if(nLength<=5)
	{
		_root.hero_info.extra_num.gotoAndStop("five")
	}

	for(var i = 0; i < 5; ++i)
	{
		var item=_root.hero_info.extra_num["num"+(i+1)]
		item._visible=true
		if(arrayNum[i]!=undefined)
		{
			var temp = Number(arrayNum[i]);
			item.gotoAndStop(temp + 1)
		}else
		{
			item._visible=false
		}

	}
	_root.hero_info.OnMoveOutOver=function()
	{
		_root._visible=false
	}

}

