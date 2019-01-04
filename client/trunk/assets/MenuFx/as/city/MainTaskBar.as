import com.tap4fun.utils.Utils;


var g_TaskHudNum = 0;
var g_TaskHudInfos = undefined;
var g_TaskHudOpen = false;
var g_TaskInitPage = 1;
var g_isSwitching = false;

var g_mainUI = _root.main_ui.main_ui;
var g_bg = _root.bg;

_root.onLoad = function()
{
	init();
}

function init()
{
	_root.main_ui._visible = false;
	g_bg._visible = false;
	g_bg.onRelease = function()
	{
		SwitchTaskHud();
	}
}

function move_in()
{
	_root.main_ui._visible = true;
	_root.main_ui.gotoAndPlay("opening_ani");
}

function move_out()
{
	_root.main_ui.gotoAndPlay("closing_ani");
}


function SetTaskHudInfo(num, infos)
{
	if (num <= 0 )
	{
		_root._visible = false;
	}else
	{
		_root._visible = true;
	}
	g_TaskHudNum = num;
	g_TaskHudInfos = infos;
	_root.main_ui._visible = true;
	_root.main_ui.gotoAndPlay("opening_ani");
	impSetTaskHudInfo();
}

function SwitchTaskHud()
{
	if(!g_isSwitching)
	{
		// trace("SwitchTaskHud: " + g_TaskHudOpen);
		g_isSwitching = true;
		if(g_TaskHudOpen)
		{
			var task_list = g_mainUI.task_list;
			task_list.gotoAndPlay("close");
			task_list.OnMoveOutOver = function()
			{
				g_isSwitching = false;
				g_TaskHudOpen = false;
				impSetTaskHudInfo();
				
			}
			g_bg._visible = false;
		}
		else
		{
			g_mainUI.gotoAndStop(2);
			g_TaskHudOpen = true;
			impSetTaskHudInfo();
			var task_list = g_mainUI.task_list;
			task_list.gotoAndPlay("open");
			task_list.OnMoveInOver = function()
			{
				g_isSwitching = false;
				g_bg._visible = true;
			}
		}
	}
}

function impSetTaskHudInfo()
{
	if(g_TaskHudOpen)
	{
		g_mainUI.gotoAndStop(2);

		var task_bar = g_mainUI.task_bar;
		impSetTaskHudTask(task_bar, (g_TaskHudInfos == undefined) ? undefined : g_TaskHudInfos[0]);

		var task_list = g_mainUI.task_list;
		for(var i = 1; i <= 3; ++i)
		{
			var bar = task_list["task_" + (i - 1)];
			if(i < g_TaskHudNum)
			{
				bar._visible = true;
				impSetTaskHudTask(bar, g_TaskHudInfos[i]);
			}
			else
			{
				bar._visible = false;
			}
		}
	}
	else
	{
		g_mainUI.gotoAndStop(1);
		var task_bar = g_mainUI.task_bar;
		impSetTaskHudTask(task_bar, (g_TaskHudInfos == undefined) ? undefined : g_TaskHudInfos[0]);
	}
}

function impSetTaskHudTask(task_bar, info)
{
	// trace("clip: " + clip);
	if(info != undefined && info.isDone)
	{
		task_bar.gotoAndStop(2);
		var btn_goto = task_bar.bg.btn_goto;
		var btn_switch = task_bar.bg.btn_switch;

		btn_goto.my_task_id = info.taskID;
		btn_goto.onRelease = function()
		{
			if(!g_isSwitching)
			{
				fscommand("TaskCommand", "GetAward" + '\2' + this.my_task_id);
				this.onRelease = undefined;
			}
		}

		btn_switch.onRelease = function()
		{
			if(!g_isSwitching)
			{
				SwitchTaskHud();
				this.onRelease = undefined;
			}
		}
	}
	else
	{
		task_bar.gotoAndStop(1);
		var btn_goto = task_bar.btn_goto;
		var btn_switch = task_bar.btn_switch;
		// trace("btn_switch: " + btn_switch)

		btn_goto.my_task_id = info.taskID;
		btn_goto.onRelease = info != undefined ? function()
		{
			fscommand("TaskCommand", "Jump" + '\2' + this.my_task_id);
			//this.onRelease = undefined;
		} : undefined;

		btn_switch.onRelease = function()
		{
			if(!g_isSwitching)
			{
				SwitchTaskHud();
				this.onRelease = undefined;
			}
		}
	}
	// trace("txt_Desc: " + clip.txt_Desc);
	task_bar.txt_task.html = true;
/*	trace(info.descTxt);
	trace("------xxxxxxx--------=" + info.descTxt.length);
	var str1 = "1234567890..";
	trace(str1.length);*/

	//task_bar.txt_task.htmlText = info != undefined ? info.descTxt : "";
	var desc = "";
	for(var i = 0; i < 40; i++)
	{
		desc = desc + info.desc_u8[i];
	}
	SetLimitText(task_bar.txt_task, 40, info.desc_u8, desc);
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
		mc.htmlText = desc;
		if (mc.textWidth >= mc._width - 15)
		{
			desc = desc + "......";
			mc.htmlText = desc;
			break;
		}
		i = i + 1;
	}
}