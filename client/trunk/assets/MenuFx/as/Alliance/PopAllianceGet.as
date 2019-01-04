var MainUI = _root.message_1;

var DefendGetTxt = MainUI.content.get1.get_txt;
var	HireGetText  = MainUI.content.get2.get_txt;
var TotalGetText = MainUI.content.get3.get_txt;
var OkBtn 		 = MainUI.content.btn_ok;

_root.onLoad = function()
{
	DefendGetTxt.html = true;
	HireGetText.html = true;
	TotalGetText.html = true;
}

OkBtn.onRelease = MainUI.bg_btn.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
}

MainUI.OnMoveOutOver = function()
{
	fscommand("AllianceMainCmd", "CloseAllianceGetUI");
}

function SetInfoText(data)
{
	DefendGetTxt._x = 0;
	HireGetText._x 	= 0;
	TotalGetText._x = 0;
	DefendGetTxt.htmlText 	= data.defend_info;
	HireGetText.htmlText 	= data.hire_info;
	TotalGetText.htmlText 	= data.total_info;
}