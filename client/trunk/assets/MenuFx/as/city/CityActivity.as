import common.CTextAutoSizeTool;


var MainUI 		= _root.main;
var HeroBtn 	= MainUI.hero_btn;
var Gacha 		= MainUI.gacha;
var GachaBtn 	= Gacha.gacha_btn;
var Task 		= MainUI.task;
var TaskBtn 	= Task.task_btn;
var WorldMapBtn = MainUI.worldmap;
var Activity 	= MainUI.activity;
var ActivityList = Activity.activitys.list;
var ActivityDatas = undefined;
var isDragRotation = false;
var canDrag 		= false;
var dragStartX 		= 0;
_root.onLoad = function()
{
	SetDefalutShow();
	InitUI();
	//WorldMapBtn._visible = false;
	
}


function SetDefalutShow()
{
	ShowUnread(WorldMapBtn, false);
	ShowUnread(GachaBtn, false);
	ShowUnread(TaskBtn, false);
	Activity.Sale._visible = false;	
    Activity.activity_name.name_txt.text = "";
}

function InitUI()
{
	
	HeroBtn.onRelease = function()
	{
		if (not isDragRotation)
		{
			fscommand("CabinCommand","Hero");
		}
		fscommand("CabinCommand", "StartAutoRotate");
		canDrag = false;
		isDragRotation = false;
	}
	HeroBtn.onPress = function()
	{
		canDrag = true;
		startPosX = _root._xmouse;
		fscommand("CabinCommand", "StopAutoRotate");
	}
	HeroBtn.onReleaseOutside = function()
	{
		fscommand("CabinCommand", "StartAutoRotate");
		canDrag = false;
		isDragRotation = false;
	}
	HeroBtn.onEnterFrame = function()
	{
		if (canDrag)
        {
            var offset = _root._xmouse - startPosX;
            if (Math.abs(offset) > 10)
            {
            	var angle = offset / 4;
	            fscommand("CabinCommand", "Rotate\2" + angle);
	            isDragRotation = true;
            }
            
        }
	}
	TaskBtn.onRelease = function()
	{
		fscommand("CabinCommand","Task");
	}
	GachaBtn.onRelease = function()
	{
		fscommand("CabinCommand","Gacha");
	}
	WorldMapBtn.onRelease = function()
	{
		fscommand("CabinCommand","WorldMap");
	}
	OpenUI();
}

function JumpToGacha()
{
	fscommand("CabinCommand","Gacha");
}

function JumpToTask()
{
	fscommand("CabinCommand","Task");
}

function JumpToWorldMap()
{
	fscommand("CabinCommand","WorldMap");
	trace("FTE tttttttttttt JumpToWorldMap")
}

function OpenUI()
{
	WorldMapBtn.gotoAndPlay("opening_ani");
	Task.gotoAndPlay("opening_ani");
	Gacha.gotoAndPlay("opening_ani");
	Activity.gotoAndPlay("opening_ani");
	if (ActivityList.GetCurItem())
	{
		ActivityList.GetCurItem().gotoAndPlay("opening_ani");
	}
	ActivityList.SetAutoMove(true);
	
}

function CloseUI()
{
	WorldMapBtn.gotoAndPlay("closing_ani");
	Task.gotoAndPlay("closing_ani");
	Gacha.gotoAndPlay("closing_ani");
	Activity.gotoAndPlay("closing_ani");
	ActivityList.SetAutoMove(false);
	if (ActivityList.GetCurItem())
	{
		ActivityList.GetCurItem().gotoAndPlay("closing_ani");	
	}
	
}

Task.OnMoveOutOver = function()
{
	fscommand("CabinCommand","MoveOut")
}

function ShowUnread(mc,isShow)
{
	mc.red_point._visible = isShow;
}



function UpdateUnread(datas)
{
	//var flag=datas.UGUIUnread.isTaskUnread or datas.UGUIUnread.isMapUnread or datas.UGUIUnread.isGachaUnread;
	ShowUnread(WorldMapBtn,datas.UGUIUnread.isMapUnread);
	ShowUnread(GachaBtn,datas.UGUIUnread.isGachaUnread);
	ShowUnread(TaskBtn,datas.UGUIUnread.isTaskUnread);
	//TODO:Hero Unread
}

//----------------------------------------------------------------

function InitActivityList(datas)
{
	ActivityDatas = datas;

	ActivityList.Init();
	ActivityList.onItemEnter = function(mc, index)
    {
        trace("-xxxxxxxxxxxxxxxxxxxxx==============")
		var data = ActivityDatas[index];
		mc.gotoAndStop(1);
        mc.icons.gotoAndStop(ActivityDatas[index].icon);
        mc.data = data
        CTextAutoSizeTool.SetSingleLineText(mc.activity_name.name_txt, data.title, 20, 10);
        if (data.time > 0)
        {
            mc.time._visible = true
            mc.time.time_txt.text = data.timeText
        }
        else
        {
            mc.time._visible = false
        }

	}

	ActivityList.onMoveIn = function(mc)
	{
        var data = ActivityDatas[mc.m_index];
        var nLength = ActivityDatas.length
        Activity.page.gotoAndStop(nLength)
        Activity.page.pages.gotoAndStop(mc.m_index + 1)

		trace("----------------index=" + (mc.m_index + 1))
        if (data.sale_info.sale == "")
		{
			Activity.Sale._visible = false;
		}else
		{
			Activity.Sale._visible = true;
			Activity.Sale.gotoAndPlay("opening_ani");
			Activity.Sale.TxtSale.gotoAndStop(data.sale_info.sale);
			if (data.sale_info.value != undefined)
			{
				Activity.Sale.TxtSale.info.num_txt.text = data.sale_info.value;	
			}
        }

    }

	ActivityList.onMoveStart = function(last_mc)
	{
		var data = ActivityDatas[last_mc.m_index];
		if (data.sale_info != undefined)
		{
			//Activity.Sale._visible = true;
			Activity.Sale.gotoAndPlay("closing_ani");
		}
		if (ActivityList.m_isDrag == true)
		{
			fscommand("PlaySound","main_activity_drag");
		}
	}

	this.onEnterFrame = function()
	{
		ActivityList.OnUpdate();
    }

    if ( ActivityDatas.length > 1)
    {
        ActivityList.SetAutoMove(true);
    }
    else
    {
        ActivityList.SetAutoMove(false);
    }
    ActivityList.onClick = OnActivityClick;

	for (var i = 0; i < ActivityDatas.length; i++)
	{
		ActivityList.AddItem("PictureAllAni", i);
	}
	ActivityList.GetCurItem().gotoAndPlay("opening_ani");
}

function UpdateActivityTime(datas)
{
    for (var i = 0; i < datas.length; i++)
    {
        var mc = ActivityList.GetItemByIndex(i)
        var data = datas[i]
        if (data.time > 0)
        {
            mc.time._visible = true
            mc.time.time_txt.text = data.timeText
        }
        else
        {
            mc.time._visible = false
        }
    }
}

function OnActivityClick(mc)
{
	// if (mc.m_index == 0)
    // {
    trace("--------mc.m_index ===" + mc.data.type)
    fscommand("CabinCommand","Activity\2" + (mc.data.type))
	//}
}

function SetActivityState(type, state)
{
    for (var i = 0; i < ActivityDatas.length; i ++)
    {
        if (ActivityDatas[i].type == type)
        {
            ActivityDatas[i].sale_info.sale = state
        }
    }
}


function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.hero._visible = false
	_root.fteanim.world_map._visible = false
	_root.fteanim.gacha._visible = false
	_root.fteanim.task._visible = false
}

FTEHideAnim()