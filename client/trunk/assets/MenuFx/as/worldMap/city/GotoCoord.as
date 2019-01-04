import common.CTextEdit;
var ui_all=_root.ui_main
var UIID
var targetX=0
var targetY=0

var mc_input_x=ui_all.message_bar.input_x
var mc_input_y=ui_all.message_bar.input_y
this.onLoad = function()
{
	InitText()
}

function SetData(obj)
{
	var defaultX=obj.defaultX ? obj.defaultX : 0
	var defaultY=obj.defaultY ? obj.defaultY : 0

	UIID=obj.UIID
	mc_input_x.lua2fs_setText(defaultX)
	mc_input_y.lua2fs_setText(defaultY)

	ui_all.btn_ok.onRelease=function()
	{
		targetX=mc_input_x.getInputString()
		targetY=mc_input_y.getInputString()
		fscommand("MapCommand","GotoCoord\2"+targetX+"\2"+targetY)
	}
	ui_all.btn_close.onRelease=function()
	{
		SetUIPlay(false)
	}
	_root.bg.onRelease=function()
	{
		
	}
}

function InitText()
{
	mc_input_x.init("NumberPad", "FlashWorldMapSearchCoordUI", "hitzone", "", "content_text", true, false, '0', null, null, null, null, true);
	mc_input_x.setMaxLength(4);
	mc_input_y.init("NumberPad", "FlashWorldMapSearchCoordUI", "hitzone", "", "content_text", true, false, '0', null, null, null, null, true);
	mc_input_y.setMaxLength(4);
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		ui_all.gotoAndPlay("opening_ani")
	}else
	{
		ui_all.gotoAndPlay("closing_ani")
		ui_all.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+UIID)
		}
	}
}



