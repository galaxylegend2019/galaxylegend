
var MainUI 			= _root.ui_main;

this.onLoad = function()
{
	MainUI.gotoAndPlay("opening_ani");
	MainUI.activity.time_txt._visible = false;
}


MainUI.OnMoveInOver = function()
{
	fscommand("CityActivityCmd", "RefreshActivityState");
}

MainUI.activity.not_activity_btn.onRelease = 
MainUI.activity.have_activity_btn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_selection_1");
	fscommand("GotoNextMenu", "GS_Activity");
}

function SetActivityState( Active )
{
	var isActive = Active.isActivity;
	if (isActive)
	{
		MainUI.activity.red_point._visible 		  = true;
		MainUI.activity.not_activity_btn._visible = false;
		MainUI.activity.have_activity_btn._visible = true;
	}else
	{
		MainUI.activity.red_point._visible 		  = false;
		MainUI.activity.not_activity_btn._visible = true;
		MainUI.activity.have_activity_btn._visible = false;
	}
}
