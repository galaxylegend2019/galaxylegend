
var MainUI = _root.main
var MainTaskDescTxt = MainUI.desc.desc_txt;

_root.onLoad = function()
{
	//SetShow(false);
}

function SetLimitText(mc, i,desc_u8 ,desc)
{
	while(true)
	{	
		if (desc_u8[i] == undefined)
		{
			break;
		}
		desc = desc + desc_u8[i];
		mc.text = desc;
		if (mc.textWidth >= mc._width - 30)
		{
			desc = desc + "......";
			mc.text = desc;
			break;
		}
		i = i + 1;
	}
}

function SetShow(isShow)
{
	_root._visible = isShow == true ? true : false;
}

function SetMainTaskDesc(desc_u8)
{

	var desc = "";
	for(var i = 0; i < 30; i++)
	{
		desc = desc + desc_u8[i];
	}

	SetLimitText(MainTaskDescTxt, 30, desc_u8, desc);
}