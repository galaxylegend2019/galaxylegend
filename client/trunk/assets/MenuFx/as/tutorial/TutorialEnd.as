
ContentText = _root.main.content.content_txt;
var Contents = undefined;
var CurIndex = 0;
_root.onLoad = function()
{
	_root._visible = false;
	ContentText._x = 0;
	ContentText._y = 0;
	ContentText.text = "";
}

function SetContent(datas)
{
	_root.main.gotoAndPlay("opening_ani");
	_root._visible = true;
	Contents = datas;

	CurIndex = 0;
	ContentText.text = Contents[CurIndex];
}

_root.main.OnMoveOutOver = function()
{
	CurIndex = CurIndex + 1;
	var desc = Contents[CurIndex];
	if (desc == undefined)
	{
		fscommand("WorldMapCmd", "Tutorial" + "\2" + "EnterCabin");
	}else
	{
		ContentText.text = desc;
		_root.main.gotoAndPlay("opening_ani");
	}
	fscommand("TutorialCommand","tracking\2FTE_end_black\2"+CurIndex);
}

