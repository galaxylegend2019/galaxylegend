
var MainUI = _root.win_ui;


function ShowVictory()
{

}

MainUI.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
}

MainUI.OnMoveOutOver = function()
{
	fscommand("WorldMapCmd", "Tutorial\2" + "CompleteTutorialPve");
}

