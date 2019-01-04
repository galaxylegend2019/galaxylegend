var m_Dialog = _root.Dialogue_bottom;
var m_SkipBtn = _root.skip_btn;
var m_LastShow 	= undefined;
var m_CurShow 	= undefined;
var Milliseconds = 0;
var StartTime 	= false;
var PlotDatas 	= undefined;
var CurPlotIndex = 0;
var CurDialog = undefined;
var DoDlgLogic = false; 
var ClickSkip = false;
var IsPlayingDlg = false;

_root.onLoad = function()
{
	m_Dialog._visible = false;
	//m_SkipBtn._visible = false;
	m_SkipBtn.onRelease = OnSkipPlot;
	m_Dialog.onRelease = OnDlalogRelease;
	//PlayDialog();
	//m_Dialog.content_plane.arrow._visible = false;
	//SetTimer();
}

//-----------set timer for hide skip_btn
function SetTimer()
{
	var timerMilliSecond:Number = getTimer();
	_root.onEnterFrame = function()
	{
		if(_root.onUpdate!=undefined)
		{
			_root.onUpdate()
		}

		if (getTimer() - timerMilliSecond >= 5000) 
		{
		   	timerMilliSecond = getTimer();
		   	m_SkipBtn._visible = false;
		}
	}
}


function OnDlalogRelease()
{
	trace("[FTE]  OnDlalogRelease " + DoDlgLogic)
	if ( DoDlgLogic )
	{
		CloseDialog();
	}

}

function OnSkipPlot()
{
	m_SkipBtn._visible = false;
	ClickSkip = true;
	
	if ( IsPlayingDlg )
	{
		CurDialog.gotoAndPlay("closing_ani");
		IsPlayingDlg = false;
	}
	
	fscommand("TutorialCommand","SkipPlot");
}

function ShowSkipBtn(showSkip)
{
	m_SkipBtn._visible = showSkip;
}

function PlayDialog()
{
	m_Dialog._visible = true;
	CurDialog.gotoAndPlay("opening_ani");
	IsPlayingDlg = true;
	
	CurDialog.OnMoveInOver = function()
	{
		DoDlgLogic = true;
		//m_Dialog.onRelease = CloseDialog;
		CurPlotIndex = CurPlotIndex + 1;
	}
}

function CloseDialog()
{
	DoDlgLogic = false;
	CurDialog.gotoAndPlay("closing_ani");
	CurDialog.OnMoveOutOver = function()
	{
		var plot = PlotDatas[CurPlotIndex];
		if (plot != undefined)
		{
			ShowDialog(plot);
		}else
		{
			//resume
			fscommand("TutorialCommand","PlotOver");
			m_Dialog._visible = false;
			
			IsPlayingDlg = false;
		}
	}
}

function StartDialog(datas)
{
	//m_Dialog._visible = true;
	//m_Dialog.onRelease = undefined;
	PlotDatas = datas;
	CurPlotIndex = 0;
	var plot = PlotDatas[CurPlotIndex];
	if (plot != undefined)
	{
		ShowDialog(plot);
	}else
	{
		m_Dialog.gotoAndPlay("closing_ani");
		//resume
		fscommand("TutorialCommand","PlotOver");
	}
}

//show.dir show.content show.left_npc show.right_npc show.time
function ShowDialog( show )
{
	trace("---------------play plot=" + CurPlotIndex);
	Milliseconds = 0;
	m_LastShow 		= m_CurShow;
	m_CurShow  		= show;
	m_CurShow.time 	= m_CurShow.time * 1000;
	if (m_CurShow.voice != undefined)
	{
		fscommand("PlaySound", m_CurShow.voice);
	}
	var content_mc1 = undefined;
	var content_mc2 = undefined;
	
	var mc 			= undefined;
	var last_mc		= undefined;

	m_Dialog.gotoAndPlay("opening_ani");

	//return
	if (m_CurShow.dir == "left")
	{
		m_Dialog.left_npc._visible = true;
		m_Dialog.right_npc._visible = false;
		//content_mc1 = m_Dialog.left_npc.TxtLiftLight.content_left;
		content_mc2 = m_Dialog.left_npc.TxtLeft.content_txt;
		SetPlayerHead(m_Dialog.left_npc.head, m_CurShow.left_npc);
		m_Dialog.left_npc.name.name_txt.text = m_CurShow.left_name_txt;
		CurDialog = m_Dialog.left_npc;
	}else if (m_CurShow.dir == "right")
	{
		m_Dialog.left_npc._visible = false;
		m_Dialog.right_npc._visible = true;
		content_mc1 = m_Dialog.right_npc.TxtRight.content_txt;
		//content_mc2 = m_Dialog.right_npc.TxtRightLight.content_right;
		SetPlayerHead(m_Dialog.right_npc.head, m_CurShow.right_npc);
		m_Dialog.right_npc.name.name_txt.text = m_CurShow.right_name_txt;
		CurDialog = m_Dialog.right_npc;
	}

	PlayDialog();
	

	content_mc1.html = true;
	content_mc1.htmlText = m_CurShow.content;
	content_mc2.html = true;
	content_mc2.htmlText = m_CurShow.content;
	StartTime = true;
}



function SetPlayerHead( head_mc, name )
{
	trace("--------head_mc=" + head_mc)
	trace("--------name=" + name)
	if (name == undefined)
	{
		head_mc._visible = false;	
	}else
	{
		head_mc._visible = true;	
		head_mc.gotoAndStop(name);
	}
	
}

function SetShowPlayer(npc_mc, is_show)
{
	if (is_show)
	{
		npc_mc.gotoAndPlay("show");
	}else
	{
		npc_mc.gotoAndPlay("hide");
	}
}