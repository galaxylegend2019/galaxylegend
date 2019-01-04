

this.onLoad = function(){
	init();
}

function init()
{
	// SetVersionInfo("ttttt");
}

function SetVersionInfo(txt)
{
	_root.info.txt_info.text = txt;
	if(_root.btn_hide._visible)
	{
		_root.btn_hide.onRelease = function()
		{
			trace("SetVersionInfo flash");
			Hide();
		}
	}
}

function HideInput()
{
	_root.btn_hide.onRelease = undefined;
	_root.btn_hide._visible = false;
}

function Hide()
{
	_root.btn_hide.onRelease = undefined;
	_root.btn_hide._visible = false;
	_root._visible = false;
}