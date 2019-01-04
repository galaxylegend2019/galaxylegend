import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;
import common.CTextEdit;


var g_TaskHudNum = 0;
var g_TaskHudInfos = undefined;
var g_TaskHudOpen = false;
var g_TaskInitPage = 1;

_root.onLoad = function()
{
	_root.main_ui.btn_task_article._visible = false;
	_root.main_ui.btn_article_shadow._visible = false;

	_root.main_ui.task_icon._visible = false;
	_root.main_ui.task_bar._visible = false;

}

_root.main_ui.OnMoveInOver = function()
{
	main_ui.task_info.btn_Task.onRelease = main_ui.task_info.hero_icon.onRelease = function()
	{
		fscommand("TaskCommand", "SetInitPage" + '\2' + g_TaskInitPage);
		fscommand("GotoNextMenu", "GS_Task")
	}
}

function showUnread(mc,isShow)
{
	if(isShow==undefined)
	{
		return
	}
	var tempName="unreadMC"
	if(mc[tempName]==undefined)
	{
		var xPos=mc._width
		mc.attachMovie("icon_tip_unread",tempName,mc.getNextHighestDepth(),{_x:xPos,_y:0})
	}
	mc[tempName]._visible=isShow
}

function SetTaskTip(tipIcon)
{
	var tipMC = main_ui.task_info.task_tips;
	if(tipIcon > 0)
	{
		tipMC._visible = true;
		tipMC.gotoAndStop(tipIcon);
	}
	else
	{
		tipMC._visible = false;
	}
}

function SetTaskArticle(isEnable, articleTxt)
{
	if(isEnable)
	{
		g_TaskInitPage = 1;
		_root.main_ui.btn_task_article._visible = true;
		_root.main_ui.btn_task_article.txt_Article.text = articleTxt;

		_root.main_ui.btn_task_article.onRelease = function()
		{
			fscommand("TaskCommand", "SetInitPage" + '\2' + g_TaskInitPage);
			fscommand("GotoNextMenu", "GS_Task");
		}
		_root.main_ui.btn_article_shadow._visible = true;
		_root.main_ui.btn_article_shadow.onRelease = function()
		{
			SetTaskArticle(false);
		}
	}
	else
	{
		g_TaskInitPage = 1;
		_root.main_ui.btn_task_article._visible = false;
		_root.main_ui.btn_article_shadow._visible = false;
		_root.main_ui.btn_task_article.onRelease = undefined;
		_root.main_ui.btn_article_shadow.onRelease = undefined;
	}
}

_root.main_ui.task_icon.btn_swtich.onRelease = function()
{
	SwitchTaskHud();
}
_root.main_ui.task_icon.btn_switch2.onRelease = function()
{
	SwitchTaskHud();
}

function SetTaskHudInfo(num, infos)
{
	g_TaskHudNum = num;
	g_TaskHudInfos = infos;
	impSetTaskHudInfo();
}

function SwitchTaskHud()
{
	var task_icon = _root.main_ui.task_icon;
	var task_bar = _root.main_ui.task_bar;
	if(g_TaskHudOpen)
	{
		g_TaskHudOpen = false;
	}
	else
	{
		g_TaskHudOpen = true;
	}
	impSetTaskHudInfo();
}

function impSetTaskHudInfo()
{
	var task_icon = _root.main_ui.task_icon;
	var task_bar = _root.main_ui.task_bar;
	task_icon._visible = true;
	task_bar._visible = true;

	// trace("task_icon: " + task_icon);
	// trace("task_bar: " + task_bar);

	if(g_TaskHudOpen)
	{
		task_icon.gotoAndStop("open");
		task_bar.gotoAndStop("open");

		task_bar.btn_task_bg.onRelease = function(){}

		var ViewList = task_bar.task_content.ViewList;
		ViewList.clearListBox();
		if(g_TaskHudNum > 0)
		{
			// trace("ViewList: " + ViewList);
			ViewList.onEnterFrame = function()
			{
				this.initListBox("item_list_task_daily", 0, true, true);
				this.enableDrag( false );
				this.onEnterFrame = function()
				{
					this.OnUpdate();
				}

				this.onItemEnter = function(mc, index_item)
				{
					// trace("mc: " + mc);
					mc._visible = true;
					impSetTaskHudTask(mc, g_TaskHudInfos[index_item]);
				}

				for(var i = 0; i < g_TaskHudNum; ++i)
				{
					this.addListItem(i, false, false);
				}
				this.needUpdateVisibleItem();
			}
		}
	}
	else
	{
		task_icon.gotoAndStop("close");
		task_bar.gotoAndStop("close");

		task_bar.btn_task_bg.onRelease = function(){}
		impSetTaskHudTask(task_bar.task_content, (g_TaskHudInfos == undefined) ? undefined : g_TaskHudInfos[0])
	}
}

function impSetTaskHudTask(clip, info)
{
	// trace("clip: " + clip);
	if(info != undefined && info.isDone)
	{
		clip.gotoAndStop(2);
		clip.btn_task.my_task_id = info.taskID;
		clip.btn_task.onRelease = function()
		{
			fscommand("TaskCommand", "GetAward" + '\2' + this.my_task_id);
			this.onRelease = undefined;
		}
	}
	else
	{
		clip.gotoAndStop(1);
		clip.btn_task.my_task_id = info.taskID;
		clip.btn_task.onRelease = info != undefined ? function()
		{
			fscommand("TaskCommand", "Jump" + '\2' + this.my_task_id);
		} : undefined;
	}
	// trace("txt_Desc: " + clip.txt_Desc);
	clip.btn_task.txt_Desc.html = true;
	clip.btn_task.txt_Desc.htmlText = info != undefined ? info.descTxt : "";
}