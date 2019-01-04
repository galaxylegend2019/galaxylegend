import com.tap4fun.utils.Utils;

var btn_main_task=_root.switch_buttons.button_mainTask
var btn_online_task=_root.switch_buttons.button_onlineTask
var btn_daily_task=_root.switch_buttons.button_dailyTask

var mc_main_task=_root.main_task
var mc_online_task = _root.online_task
var mc_daily_task=_root.daily_task

var isFirstLoad=false
var DailyDatas
var MiniDatas
var MainDatas
var lastDailyData
var lastMainData
var lastMiniData

var FTEFirstGotoMC = undefined
var FTEFirstGotoIdx = -1  // canbe 0,1,2,3
var FTEClick = false

var OnlineDatas

var curPageMC = undefined;
var curSelectIcon = undefined;

_root.onLoad=function()
{
	/*******FTE*******/
	
	/*******End*******/
	fscommand('LockInput');
	isFirstLoad=true

	_root.task_result._visible=false;
	InitSwitchButtons()

	mc_main_task._visible = false;
	mc_online_task._visible = false;
	mc_daily_task._visible = false;

	_root.btn_bg.onRelease = function()
	{
		//no click through
	}

	//testF()
	//showMain();
/*	var lock_info = new Object();
	lock_info.online = true;
	lock_info.online_ani = true;
	lock_info.daily = false;
	FuncUnLock(lock_info);*/
	_root.troops_middle.gotoAndPlay("opening_ani");

	//SwitchToPage(1);
}

_root.bg1_btn.onRelease = function()
{

}

function SetMoneyData(datas)
{
	_root.top_bar.money_plane.money_text.text = datas.money;
	_root.top_bar.credit_plane.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = _root.top_bar.energy_plane
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

_root.top_bar.money_plane.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

_root.top_bar.credit_plane.onRelease=function()
{
	fscommand("GoToNext", "Purchase");
}

_root.top_bar.energy_plane.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

function testF()
{

    MainDatas=new Array()

    for(var i=0;i<15;i++)
    {
    	var obj=new Object()

    	if(i%2==1)
    	{
    		obj.taskType="task_type_main"
		}else
		{
			obj.taskType="task_type_branch"
		}

		MainDatas.push(obj)
    }
}

_root.top_bar.OnMoveInOver = function()
{
	fscommand('UnlockInput');
	_root.top_bar.btn_close.onRelease=function()
	{
		ClickTaskCloseBtn();
	}
}

//fte call
function ClickTaskCloseBtn()
{
	fscommand("PlaySound","sfx_ui_cancel");
	/*******FTE*******/
	//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickTaskCloseBtn");
	/*******End*******/
	fscommand("PlayMenuBack");
	_root.top_bar.gotoAndPlay("closing_ani");
	_root.switch_buttons.gotoAndPlay("closing_ani");
	if(_root.main_task._visible)
	{
		_root.main_task.gotoAndPlay("closing_ani");
	}
	if(_root.mini_task._visible)
	{
		_root.mini_task.gotoAndPlay("closing_ani");
	}
	_root.bg1.gotoAndPlay("closing_ani");

	_root.top_bar.OnMoveOutOver=function()
	{
		_root._visible=false
		this.OnMoveOutOver=undefined
		fscommand("GotoNextMenu","GS_MainMenu")
	}
}

//data.online  data.online_ani data.daily data.daily_ani
function FuncUnLock( data )
{
    btn_online_task.isUnlocked = data.online
    btn_daily_task.isUnlocked = data.daily
	if (data.online)
	{
        btn_online_task._visible = true;
        btn_online_task.button_onlineTask.lock._visible = false;
        btn_online_task.button_onlineTask.tips._visible = false;
		if (data.online_ani)
		{
			//play ani
			btn_online_task.gotoAndPlay("unlock_ani");
		}	
	}else
	{
        btn_online_task._visible = true;
        btn_online_task.button_onlineTask.lock._visible = true;
	}
	if (data.daily)
	{
        btn_daily_task._visible = true;
        btn_daily_task.button_dailyTask.lock._visible = false;
        btn_daily_task.button_dailyTask.tips._visible = false;
		if (data.daily_ani)
		{
			// play ani
			btn_daily_task.gotoAndPlay("unlock_ani");
		}
	}else
	{
        btn_daily_task._visible = true;
        btn_daily_task.button_dailyTask.lock._visible = true;
	}
	
}

function InitUIInfo(inputData)
{
	_root.task_result._visible=false

	MainDatas=inputData.mainTask
	MiniDatas = inputData.miniTask
	DailyDatas=inputData.dailyTask
	lastMainData=MainDatas

	// btn_main_task.onRelease()
	updateTaskCount()
	if (curPageMC == undefined)
	{
		lastDailyData=DailyDatas
		lastMainData=MainDatas
		lastMainData=MainDatas
		SwitchToPage(1);	


	}


	
}

function UpdateTaskData(inputData)
{
	MainDatas	=	inputData.mainTask
	DailyDatas	=	inputData.dailyTask
	MiniDatas	=	inputData.miniTask

	updateTaskCount()


	updateDailyData()
	updateMainData()
	//updateMiniData()
}

function getTaskCount(datas)
{
	if(datas == undefined)
	{
		return 0;
	}
	var count = 0;
	for(var i = 0; i < datas.length; ++i)
	{
		if(datas[i].state == 1)
		{
			++count;
		}
	}
	return count;
}

function updateTaskCount()
{
	var numObj=new Object()
	numObj.mainTaskNum = getTaskCount(MainDatas)
	numObj.miniTaskNum = getTaskCount(MiniDatas)
	numObj.dailyTaskNum = getTaskCount(DailyDatas)
	updateTaskTips(numObj)
}

function InitSwitchButtons()
{
	btn_main_task.tips._visible = false;
	btn_daily_task.button_dailyTask.tips._visible = false;
	btn_online_task.button_onlineTask.tips._visible = false;

	btn_main_task.onRelease=function()
	{	
		if(curPageMC != mc_main_task)
		{
			fscommand("PlaySound","sfx_ui_selection_2");
			fscommand("PlayMenuConfirm");
		}
		showMain()
	}

	btn_online_task.onRelease=function()
    {
        if (this.isUnlocked)
        {
            if(curPageMC != mc_online_task)
            {
                fscommand("PlaySound","sfx_ui_selection_2");
                fscommand("PlayMenuConfirm");
            }
            showOnline()
        }
        else
        {
            fscommand("TaskCommand","UnLock" + "\2" + "online_task")
        }
        /*******FTE*******/
		//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickOnlineTaskBtn");
		/*******End*******/
	}

	btn_daily_task.onRelease=function()
    {
        if (this.isUnlocked)
        {
            if(curPageMC != mc_daily_task)
            {
                fscommand("PlaySound","sfx_ui_selection_2");
                fscommand("PlayMenuConfirm");
            }
            showDaily()
        }
        else
        {
            fscommand("TaskCommand","UnLock" + "\2" + "daily_task")
        }
		/*******FTE*******/
		//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickDailyTaskBtn");
		/*******End*******/
	}
}

function updateTaskTips(inputData)
{
	btn_main_task.tips.tt.text=inputData.mainTaskNum
	btn_main_task.tips._visible=inputData.mainTaskNum>0

	

	//btn_daily_task.tips.num.text="222"//inputData.dailyTaskNum
    btn_daily_task.button_dailyTask.tips.tt.text=inputData.dailyTaskNum
    if (btn_daily_task.isUnlocked)
    {
        btn_daily_task.button_dailyTask.tips._visible=inputData.dailyTaskNum>0
    }

}

function showMain()
{
	// if(isFirstLoad)
	// {
	// 	mc_daily_task._visible=false
	// 	isFirstLoad=false
	// }else
	// {
	// 	playCloseAni(mc_daily_task)
	// }
	if(curPageMC && curPageMC != mc_main_task)
	{
		playCloseAni(curPageMC);
	}

	btn_main_task.gotoAndStop(2);
	btn_online_task.button_onlineTask.gotoAndStop(1);
	btn_daily_task.button_dailyTask.gotoAndStop(1);

	mc_main_task._visible=true
	if(curPageMC != mc_main_task)
	{
		mc_main_task.gotoAndPlay("opening_ani")
	}
	curPageMC = mc_main_task;
	trace("-------------curPageMC=" + curPageMC)
	InitMainList()
}

function showOnline()
{
	if(curPageMC && curPageMC != mc_online_task)
	{
		playCloseAni(curPageMC);
	}

	btn_main_task.gotoAndStop(1);
	btn_online_task.button_onlineTask.gotoAndStop(2);
	btn_daily_task.button_dailyTask.gotoAndStop(1);

	mc_online_task._visible=true;
	if(curPageMC != mc_online_task)
	{
		mc_online_task.gotoAndPlay("opening_ani")
	}
	curPageMC = mc_online_task;

	InitOnlineList();
}

function showDaily()
{
	// //mc_main_task._visible=false
	// playCloseAni(mc_main_task)

	if(curPageMC && curPageMC != mc_daily_task)
	{
		playCloseAni(curPageMC);
	}

	btn_main_task.gotoAndStop(1);
	btn_online_task.button_onlineTask.gotoAndStop(1)
	btn_daily_task.button_dailyTask.gotoAndStop(2)

	mc_daily_task._visible=true
	if(curPageMC != mc_daily_task)
	{
		mc_daily_task.gotoAndPlay("opening_ani")
	}
	curPageMC = mc_daily_task

	InitDailyList()
}

function SwitchToPage(page)
{
	if(page == 1)
	{
		showMain();
	}
	else if(page == 2)
	{
		showOnline();
	}
	else if(page == 3)
	{
		showDaily();
	}
}

function playCloseAni(mc)
{
	mc.gotoAndPlay("closing_ani")
	mc.OnMoveOutOver=function()
	{
		this._visible=false
		this.OnMoveOutOver=undefined
	}
}

function updateDailyData()
{	
	// trace("DailyDatas.length: " + DailyDatas.length + "  lastDailyData.length: " + lastDailyData.length);
	if(DailyDatas.length>lastDailyData.length)
	{
		var ui_drag_list=mc_daily_task.mini_task.task_list
		for(var i=lastDailyData.length+1;i<=DailyDatas.length;i++)
		{
			ui_drag_list.addListItem(i, false, false);	
			// trace("ui_drag_list.addListItem: " + i);
		}
	}else if(DailyDatas.length<lastDailyData.length)
	{
		var ui_drag_list=mc_daily_task.mini_task.task_list
		for(var i=DailyDatas.length+1;i<=lastDailyData.length;i++)
		{
			// trace("ui_drag_list.erase: " + i);
			ui_drag_list.eraseItem(i);
		}
	}

	trace("-----lastDailyData=" + lastDailyData.length);
	trace("-----curDailyData=" + DailyDatas.length);
	lastDailyData=DailyDatas

	//if(mc_daily_task._visible)
	{
		mc_daily_task.mini_task.task_list.needUpdateVisibleItem()
	}
}

function InitDailyList()
{
	if(DailyDatas==undefined)
	{
		return
	}

	var listLength=DailyDatas.length
	trace("ggggggggggggg----------listLength=" + listLength)
	var ui_drag_list=mc_daily_task.mini_task.task_list

	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("task_list_all",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	FTEFirstGotoMC = undefined
	FTEFirstGotoIdx = -1  // canbe 0,1,2,3

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		mc._visible=true;
		var datas=DailyDatas[index_item-1]
		SetTaskItemData(mc,datas, index_item-1)
	}

	ui_drag_list.onItemMCCreate = function(mc){
		//mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	//ui_drag_list.onItemMCMove = OnMiniItemScaleCallBack;

	

	for( var i=1; i <= listLength; i++ )
	{   
	    var temp=ui_drag_list.addListItem(i, false, false);
	}

}


var OnlineDatas = undefined;

var Milliseconds = 0;
var CurClientTimes 	 = 0;
// var isDrag 			= false;
// var lastPos 		= 0;
// var isBottom 		= false;
// var DragSensitivity = 40;
// var canDrag 		= true;

// mc_online_task.arrow_r.onRelease = function()
// {
// 	DragToPage2();
// }

// mc_online_task.arrow_l.onRelease = function()
// {
// 	DragToPage1();
// }

var online_red_point = false;

function InitOnlineData( taskInfo )
{
	OnlineDatas = taskInfo;
	InitOnlineList();
	online_red_point = false;
	for( var i=0; i < OnlineDatas.length; i++ )
	{
		var data = OnlineDatas[i];
		if (data.state == 3)
		{
			online_red_point = true;
		}
	}
	if (not online_red_point and OnlineDatas.length > 0)
	{
		online_red_point = true;
		for( var i=0; i < OnlineDatas.length; i++ )
		{
			var data = OnlineDatas[i];
			if (data.state == 2)
			{
				online_red_point = false;
			}
		}
	}
    if (btn_online_task.isUnlocked)
    {
        btn_online_task.button_onlineTask.tips._visible 	= online_red_point;
    }
}

function InitOnlineList()
{
	if (OnlineDatas == undefined)
	{
		return;
	}

	var listLength = OnlineDatas.length

	var ui_drag_list= online_task.mini_task.task_list

	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("task_online_board_all",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		mc._visible=true;
		var datas=OnlineDatas[index_item-1]
		SetOnlineItemInfo(mc, datas)

	}

	ui_drag_list.onItemMCCreate = function(mc){
		//mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	//ui_drag_list.onItemMCMove = OnMiniItemScaleCallBack;

	

	for( var i=1; i <= listLength; i++ )
	{   
	    var temp=ui_drag_list.addListItem(i, false, false);
	}
	// var online_list = mc_online_task.list.board.online_list;
	// //online_list._visible = true;

	// if (OnlineDatas.length > 3 and isBottom)
	// {
	// 	mc_online_task.page.gotoAndStop(2);
	// 	online_list.gotoAndStop("page2");
	// 	mc_online_task.arrow_r._visible = false;
	// 	mc_online_task.arrow_l._visible = true;
	// }else
	// {
	// 	mc_online_task.page.gotoAndStop(1);
	// 	online_list.gotoAndStop("page1");
	// 	isBottom = false;
	// 	mc_online_task.arrow_r._visible = true;
	// 	mc_online_task.arrow_l._visible = false;
	// }
	// if (OnlineDatas.length > 3)
	// {
	// 	canDrag = true;
	// 	mc_online_task.page.page2._visible = true;
	// }else
	// {
	// 	canDrag = false;
	// 	mc_online_task.page.page2._visible = false;
	// 	mc_online_task.arrow_r._visible = false;
	// 	mc_online_task.arrow_l._visible = false;
	// }

	// var red_point = 0;
	// for (var i = 1; i <= 5; i++)
	// {
	// 	var data = OnlineDatas[i - 1];
	// 	var board = online_list["board" + i];
	// 	if (data == undefined)
	// 	{
	// 		if (i <= 3)
	// 		{
	// 			//board.gotoAndStop(4);
	// 			SwtichOnlineQuality(board, 4);
	// 		}else
	// 		{
	// 			board._visible = false;
	// 		}
	// 	}else
	// 	{
	// 		board._visible = true;
	// 		board.nIndex = i - 1;
	// 		board.data = data;
	// 		//board.content.states.gotoAndStop("state" + data.state);
	// 		//board.gotoAndStop(data.quality);
			
	// 		SwtichOnlineQuality(board, data.quality);
	// 		SwitchOnlineBtnState(board.content.states, data.state);
	// 		board.content.states.board_btn.onRelease = function()
	// 		{
	// 			/*******FTE*******/
	// 			fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickGetOnlineTaskBtn");
	// 			/*******End*******/
	// 			var online_list = mc_online_task.list.board.online_list;
	// 			var data = this._parent._parent._parent.data;
	// 			switch( data.state )
	// 			{
	// 				case 0:
	// 					fscommand("TaskCommand", "GetOnlineTask" + "\2" + data.id);
	// 				break;
	// 				case 1:
	// 					trace("--------Cant Start Online Task---------");
	// 				break;
	// 				case 2:
	// 					trace("-------- Task Doing Awards---------");
	// 				break;
	// 				case 3:
	// 					fscommand("TaskCommand", "CompleteOnlineTask" + "\2" + data.id);
	// 				break;
	// 				default:
	// 				break;
	// 			}
	// 		}

	// 		UpdateCountTime(board, data);

	// 		SetOnlineAwardData(board.content.award0, data.odds_awards[0]);

	// 		for (var j = 0; j < 6; j++)
	// 		{
	// 			var mc = board.content["award" + (j + 1)];
	// 			SetOnlineAwardData(mc, data.awards[j]);
	// 		}
			
	// 	}
	// 	if (data.state == 3)
	// 	{
	// 		red_point += 1;
	// 	}
	// }
	
	// if (red_point > 0)
	// {
	// 	btn_online_task.button_onlineTask.tips.tt.text 	= red_point;
	// 	btn_online_task.button_onlineTask.tips._visible 	= true;
	// }else
	// {
	// 	if (OnlineDatas.length >= 1)
	// 	{
	// 		btn_online_task.button_onlineTask.tips.tt.text 	= OnlineDatas.length;
	// 		btn_online_task.button_onlineTask.tips._visible 	= true;
	// 	}else
	// 	{
	// 		btn_online_task.button_onlineTask.tips._visible 	= false;
	// 	}
	// }


	// mc_online_task.list.board.hitZone_panel.onPress = function()
	// {
	// 	isDrag = true;
	// 	lastPos = _root._xmouse;
	// }

	// mc_online_task.list.board.hitZone_panel.onReleaseOutside = function()
	// {
	// 	isDrag = false;
	// }

	// mc_online_task.list.board.hitZone_panel.onRelease = function()
	// {
	// 	isDrag = false;
	// }

	// mc_online_task.list.board.hitZone_panel.onEnterFrame = function()
	// {
		
	// 	if (isDrag and canDrag)
	// 	{
	// 		var offset = _root._xmouse - lastPos;
	// 		if (offset < -DragSensitivity)
	// 		{
	// 			DragToPage2();
	// 			isDrag = false;
	// 		}else if (offset > DragSensitivity)
	// 		{
	// 			DragToPage1();
	// 			isDrag = false;
	// 		}
	// 	}
		
	// }

}

function SetOnlineItemInfo(mc, datas)
{
	mc.datas = datas;
	SetOnlineAward(mc, datas);
	SetOnlineBtnInfo(mc, datas);
	//set online task icon
	mc.icons.gotoAndStop(datas.id);
	//set online task desc
	mc.task_desc.text = datas.task_desc;
}

function SetOnlineBtnInfo(mc, datas)
{
	if (datas.state == 0)
	{
		mc.btn_start._visible 		= true;
		mc.btn_complete._visible	= false;
		mc.btn_start_gray._visible 	= false;
		mc.ongoing._visible 		= false;

		mc.btn_start.time_txt.text 	= GetTimeText(datas.count_time)
		mc.btn_start.onRelease = function()
		{
			fscommand("TaskCommand", "GetOnlineTask" + "\2" + this._parent.datas.id);
		}
	}else if (datas.state == 1)
	{
		mc.btn_start._visible 		= false;
		mc.btn_complete._visible	= false;
		mc.btn_start_gray._visible 	= true;
		mc.ongoing._visible 		= false;

		mc.btn_start_gray.time_txt.text 	= GetTimeText(datas.count_time)
	}else if (datas.state == 2)
	{
		mc.btn_start._visible 		= false;
		mc.btn_complete._visible	= false;
		mc.btn_start_gray._visible 	= false;
		mc.ongoing._visible 		= true;

		mc.ongoing.time_txt.text 	= GetTimeText(datas.residue_time)

		var progress = Math.ceil(((datas.count_time - datas.residue_time) / datas.count_time) * 100)
		mc.progressbar.gotoAndStop(progress + 1);
	}else if (datas.state == 3)
	{
		mc.btn_start._visible 		= false;
		mc.btn_complete._visible	= true;
		mc.btn_start_gray._visible 	= false;
		mc.ongoing._visible 		= false;

		mc.btn_complete.onRelease = function()
		{
			fscommand("TaskCommand", "CompleteOnlineTask" + "\2" + this._parent.datas.id);
		}
		mc.progressbar.gotoAndStop(101);
	}
}

function SetOnlineAward(mc, datas)
{
	var MAX_LENGTH = 2;
	var award_index = 1;
	for (var i = 0; i < MAX_LENGTH; ++i)
	{
		var award 	= datas.awards[i];
		if (award == undefined)
		{
			if (i == 0)
			{
				mc.award_1._visible = false;
			}else
			{
				mc.award_2._visible = false;
				mc.award_3._visible = false;
			}
		}else
		{
			if (award.res_type == "resource")
			{
				var awardMc = mc["award_" + award_index];
				awardMc._visible = true;
				awardMc.item_icon.gotoAndStop(award.id);
				awardMc.num_text.text = award.count;
				if (award_index == 2)
				{
					var itemMc = mc.award_3;
					itemMc._visible = false;
				}
				award_index = award_index + 1;
			}else if (award.res_type == "item")
			{
				var awardMc = mc["award_2"];
				awardMc._visible = false;
				var itemMc = mc.award_3;
				itemMc._visible = true;
				if(itemMc.item_icon.icons==undefined)
				{
					var w = itemMc.item_icon._width;
					var h = itemMc.item_icon._height;
					itemMc.item_icon.loadMovie("CommonIcons.swf");
					itemMc.item_icon._width = w;
					itemMc.item_icon._height = h;
				}
				itemMc.item_icon.IconData = award.iconInfo;
				if (itemMc.item_icon.UpdateIcon) { itemMc.item_icon.UpdateIcon(); }
				if (award.count > 1)
				{
					itemMc.num_text.text = award.count;
					itemMc.num_text._visible = true;
					itemMc.num_bg._visible 	= true;
				}else
				{
					itemMc.num_text._visible = false;
					itemMc.num_bg._visible 	= false;
				}
				

				itemMc.res_type = award.res_type
				itemMc.res_id = award.id
				{
					itemMc.onRelease = function()
					{
						fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
					}
					itemMc.onReleaseOutside = function()
					{
						fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
					}
				}
			}
		}

	}
}

// function DragToPage2()
// {
// 	var online_list = mc_online_task.list.board.online_list;
// 	if (not isBottom)
// 	{
// 		online_list.gotoAndPlay("page1_2");
// 		isBottom = true;
// 		mc_online_task.page.gotoAndStop(2);
// 		mc_online_task.arrow_r._visible = false;
// 		mc_online_task.arrow_l._visible = true;
// 	}
// }

// function DragToPage1()
// {
// 	var online_list = mc_online_task.list.board.online_list;
// 	if (isBottom)
// 	{
// 		online_list.gotoAndPlay("page2_1");
// 		isBottom = false;
// 		mc_online_task.page.gotoAndStop(1);
// 		mc_online_task.arrow_r._visible = true;
// 		mc_online_task.arrow_l._visible = false;
// 	}
// }

// function SwitchOnlineBtnState( btns, state )
// {
// 	for (var i = 0; i < 4; i++)
// 	{
// 		if (i == state)
// 		{
// 			btns["btn_state" + i]._visible = true;
// 			btns.board_btn = btns["btn_state" + i];
// 		}else
// 		{
// 			btns["btn_state" + i]._visible = false;
// 		}
// 	}
// }

// function SwtichOnlineQuality(board ,quality )
// {
// 	for (var i = 1; i <= 4; i++)
// 	{
// 		if (i == quality)
// 		{
// 			board["content" + i]._visible = true;
// 			board.content = board["content" + i];
// 		}else
// 		{
// 			board["content" + i]._visible = false;
// 		}
// 	}
// }

// function UpdateCountTime(board, data)
// {
// 	if (data.state == 2)
// 	{
// 		board.content.states.board_btn.time_txt.text = GetTimeText(data.residue_time);
// 	}
// 	if (data.state == 0 or data.state == 1)
// 	{
// 		board.content.states.board_btn.time_txt.text = GetTimeText(data.count_time);
// 	}
// }

// function SetOnlineAwardData(mc, item)
// {
// 	if (mc == undefined)
// 	{
// 		return;
// 	}
// 	if (item == undefined)
// 	{
// 		mc._visible = false;
// 	}else
// 	{
// 		mc._visible = true;
// 	}
// 	if (mc.item_icon.icons == undefined)
// 	{
// 		var w = mc.item_icon._width;
// 		var h = mc.item_icon._height;
// 		mc.item_icon.loadMovie("CommonIcons.swf");
// 		mc.item_icon._width = w;
// 		mc.item_icon._height = h;
// 	}
// 	mc.item_icon.IconData = item.iconInfo;
// 	if(mc.item_icon.UpdateIcon)
// 	{ 
// 		mc.item_icon.UpdateIcon(); 
// 	}
// 	//if (item.res_type == "item")
// 	{
// 		mc.onRelease = function()
// 		{
// 			if (curSelectIcon)
// 			{
// 				curSelectIcon.SelectIcon(false);
// 			}
// 			curSelectIcon = this.item_icon;
// 			this.item_icon.SelectIcon(true);
// 			fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.item_icon.IconData.res_type + "\2" + this.item_icon.IconData.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
// 		}


// 		mc.onReleaseOutside = function()
// 		{
// 			this.item_icon.SelectIcon(false);
// 			fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
// 		}
// 	}
	
// 	mc.num_text.text = item.count;
// }

function GetTimeText(time)
{
	if (time == undefined)
	{
		return;
	}
	//time = time / 1000;
	var year 	= Math.floor(time / (365 * 24 * 3600));
	time = time - (year * 365 * 24 * 3600);
	var month  	= Math.floor(time / (30 * 24 * 3600));
	time = time - (month * 30 * 24 * 3600);
	var day 	= Math.floor(time / (24 * 3600));
	time = time - (day * 24 * 3600);
	var hour 	= Math.floor(time / 3600);
	time = time - (hour * 3600);
	var minutes	= Math.floor(time / 60);
	var seconds = Math.floor(time - (minutes * 60));
	var ret = "";
	if (hour < 10)
	{
		ret = ret + "0" + hour + ":";
	}else{
		ret = ret + hour + ":";
	}

	if (minutes < 10)
	{
		ret = ret + "0" + minutes + ":";
	}else{
		ret = ret + minutes + ":";
	}

	if (seconds < 10)
	{
		ret = ret + "0" +seconds;
	}else{
		ret = ret + seconds;
	}

	return ret;
}

this.onEnterFrame = function()
{
	var curDate = new Date();
	var curMilliseconds = curDate.getTime();
	if (Milliseconds == 0)
	{
		Milliseconds = curMilliseconds;
	}
	var offset = curMilliseconds - Milliseconds;
	if (offset >= 1000)
	{
		var seconds = Math.floor(offset / 1000);
		Milliseconds += seconds * 1000;
		updateOnlineTime(seconds);
	}
}

function updateOnlineTime( seconds )
{	

	for (var i = 0; i < OnlineDatas.length; ++i)
	{
		var data = OnlineDatas[i];
		if (data != undefined)
		{
			if (data.state == 2)
			{
				data.residue_time -= seconds;
				if (data.residue_time < 0)
				{
					data.residue_time = 0;
				}
			}
		}
	}

    // for (var i = 0; i < DailyDatas.length; ++i)
    // {
    //     var data = DailyDatas[i];
    //     if (data != undefined)
    //     {
    //         if (data.taskType == "task_type_energy" and data.state == 0)
    //         {
    //             data.count_down -= seconds;
    //             if (data.count_down < 0)
    //             {
    //                 data.count_down = 0;
    //             }
    //         }
    //     }
    // }

	if (curPageMC == mc_online_task)
	{
		var ui_drag_list = online_task.mini_task.task_list;
		ui_drag_list.needUpdateVisibleItem();
	}else if (curPageMC == mc_daily_task)
	{
         var ui_drag_list = mc_daily_task.mini_task.task_list;
         ui_drag_list.needUpdateVisibleItem();
	}
	
}

function updateMainData()
{	
	SetMainTaskItemData();

}
function InitMainList()
{
	if (MainDatas == undefined)
	{
		mc_main_task._visible = false;
		return;
	}
	SetMainTaskItemData();

}

function SetMainTaskItemData()
{

	var item = mc_main_task;
	if(MainDatas.length == 0 || MainDatas[0] == undefined)
	{
		item._visible = false;
		return;
	}

	

	var taskData = MainDatas[0];
	item.taskData=taskData

	item.content_req.txt_req.htmlText = taskData.taskReq
	item.content_req.progress_txt.html = true;
	item.content_req.progress_txt.htmlText = taskData.processNum
	item.content_desc.txt_taskName.text = taskData.taskName
	item.content_desc.task_desc.text=taskData.taskDesc

	var awardLength = taskData.awardData.length;
	var MAX_LENGTH = 5;


	var item_index = 1;
	//first show resource
	var credit_info = undefined;
	var money_info 	= undefined;
	var exp_info 	= undefined;

	for(var i=0; i < awardLength; i++)
	{
		var awardData = taskData.awardData[i];
		if (awardData.res_type == "resource")
		{
			if (awardData.id == "money")
			{
				money_info = awardData;
			}else if (awardData.id == "credit")
			{
				credit_info = awardData;
			}else if (awardData.id == "exp")
			{
				exp_info = awardData;
			}
		}
	}

	if (money_info != undefined)
	{
		var award_item = item.icons["item" + item_index];
		award_item._visible = false;
		var award_res = item.icons["award_" + item_index];
		award_res._visible = true;
		award_res.icon.gotoAndStop("money");
		award_res.num_text.text = money_info.count;
		item_index = item_index + 1;
	}
	if (credit_info != undefined)
	{
		var award_item = item.icons["item" + item_index];
		award_item._visible = false;
		var award_res = item.icons["award_" + item_index];
		award_res._visible = true;
		award_res.icon.gotoAndStop("credit");
		award_res.num_text.text = credit_info.count;
		item_index = item_index + 1;
	}
	if (exp_info != undefined)
	{
		var award_item = item.icons["item" + item_index];
		award_item._visible = false;
		var award_res = item.icons["award_" + item_index];
		
		award_res._visible = true;
		award_res.icon.gotoAndStop("exp");
		award_res.num_text.text = exp_info.count;
		item_index = item_index + 1;

	}

	for (var j = item_index; j <= 3; ++j)
	{
		var award_res = item.icons["award_" + j];
		award_res._visible = false;
	}

	for(var i=0; i < awardLength; i++)
	{
		if (item_index > 5)
		{
			break;
		}
		var award = item.icons["item"+item_index];
		
		// trace("award: " + award + "  i: " + i);
		var awardData = taskData.awardData[i];
		if(awardData.res_type != "resource")
		{
			award._visible = true;
			// award.item_icon._visible = true;
			// award.num_text._visible = true;
			// award.num_bg._visible = true;
			// award.bg._visible = false;
			if (awardData.count == 1)
			{
				award.num_text._visible = false;
				award.num_bg._visible = false;
			}else
			{
				award.num_text.text = awardData.count;
			}
			
			if(award.item_icon.icons == undefined)
			{
				var w = award.item_icon._width;
				var h = award.item_icon._height;
				if (awardData.res_type == "hero")
				{
					award.item_icon.loadMovie("CommonHeros.swf");
				}else
				{
					award.item_icon.loadMovie("CommonIcons.swf");
				}
				award.item_icon._width = w;
				award.item_icon._height = h;
			}
			// award.item_icon.icons.gotoAndStop("item_"+awardData.id)
			award.item_icon.IconData = awardData.iconInfo
			if (award.item_icon.UpdateIcon) { award.item_icon.UpdateIcon(); }

			award.res_type = awardData.res_type
			award.res_id = awardData.id
			//if(awardData.res_type == "item")
			{
				award.onRelease = function()
				{
					if (curSelectIcon)
					{
						curSelectIcon.SelectIcon(false);
					}
					curSelectIcon = this.item_icon;
					// if (this.res_type != "hero")
					// {
					// 	this.item_icon.SelectIcon(true);
					// }
					fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
				}
				award.onReleaseOutside = function()
				{
					// if (this.res_type != "hero")
					// {
					// 	this.item_icon.SelectIcon(false);
					// }
					fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
				}
			}
			item_index = item_index + 1;
		}

	}

	for (var i = item_index; i <= 5; ++i)
	{
		var award = item.icons["item" + i];
		award._visible = false;
	}

	fscommand("TutorialCommand","Activate" + "\2" + "TaskUILoad");

	if(taskData.state == 1)
	{
		item.btn_jump._visible = false
		item.btn_get._visible = true

		item.btn_get.onRelease = function()
		{
			fscommand("PlaySound","sfx_ui_get_reward");
			/*******FTE*******/
			//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickTaskGetAwardBtn");
			/*******End*******/
			var taskID=this._parent.taskData.id
			fscommand("TaskCommand","GetAward"+'\2'+taskID)

			mc_main_task.btn_get.onRelease = undefined
			mc_main_task.btn_jump.onRelease = undefined
		}

	}else
	{
		item.btn_jump._visible = true
		item.btn_get._visible = false

		if(taskData.origin)
		{
			item.btn_jump._visible = true;
			item.btn_jump.onRelease = function()
			{
				fscommand("PlaySound","sfx_ui_selection_1");
				/*******FTE*******/
				//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickTaskJumpBtn");
				/*******End*******/
				var taskID=this._parent.taskData.id
				fscommand("TaskCommand","Jump"+'\2'+taskID)
				fscommand("PlayMenuConfirm");

				mc_main_task.btn_get.onRelease = undefined
				mc_main_task.btn_jump.onRelease = undefined
			}
		}
		else
		{
			item.btn_jump._visible = false;
		}
	}

}

//fte call
function ClickGetTaskAwardBtn()
{
	//fscommand("PlaySound","sfx_ui_get_reward");
	//var taskID = mc_main_task.taskData.id
	//fscommand("TaskCommand","GetAward"+'\2'+taskID)
	if (mc_main_task.btn_get != undefined)
		mc_main_task.btn_get.onRelease()
}

//fte call
function ClickTaskJumpBtn()
{
	//fscommand("PlaySound","sfx_ui_selection_1");
	//var taskID = mc_main_task.taskData.id
	//fscommand("TaskCommand","Jump"+'\2'+taskID)
	//fscommand("PlayMenuConfirm");

	if (mc_main_task.btn_jump != undefined)
		mc_main_task.btn_jump.onRelease()
}

function GetAffairTaskJumpBtn()
{

	var ui_drag_list=mc_daily_task.mini_task.task_list;

	for(var i = 1; i <= ui_drag_list.getItemListLength() ; ++ i){
		var mc = ui_drag_list.getMcByItemKey(i);
		if (mc.task_button.taskData.id == 206)
		{
			return mc.task_button;
		}
	}

	/*for (var i = 0; i < ui_drag_list.m_itemMCList.length; ++i)
    {
    	trace("i=" + i);
        var mc = ui_drag_list.m_itemMCList[i];
    	var itemKey     = ui_drag_list.m_itemKeyList[mc.ItemIndex];
		if( itemKey )
		{
			trace(mc.task_button.taskData.id);
    		if (mc.task_button.taskData.id == 206)
    		{
    			return mc.task_button;
    		}
		}
    }*/
    return undefined;
}

function SetTaskItemData(mc,datas, idx_from_0)
{
	//set taskbutton's state

	if(datas.state==0)
	{
		mc.btn_goto._visible = true;
		mc.btn_complete._visible = false;
		mc.task_button = mc.btn_goto;
	}else
	{
		mc.btn_goto._visible = false;
		mc.btn_complete._visible = true;
		mc.task_button = mc.btn_complete;
	}
	mc.task_button.taskData=datas;


	if(datas.state==0)
	{
		
		if(mc.task_button.taskData.origin)
		{
			if (FTEFirstGotoMC == undefined)
			{
				FTEFirstGotoMC = mc
				FTEFirstGotoIdx = idx_from_0
			}


			mc.task_button.onRelease=function()
			{
				/*******FTE*******/
				//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickJumpBtn");
				/*******End*******/
				this._parent.onReleasedInListbox();
				if(FTEClick || Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					var taskID=this.taskData.id
					fscommand("TaskCommand","Jump"+'\2'+taskID);
					fscommand("PlayMenuConfirm");
				}
			}
			mc.task_button.onReleaseOutside = function()
			{
				this._parent.onReleasedInListbox();
			}
			mc.task_button.onPress = function()
			{
				this._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}

			if(datas.finishCount == 0)
			{
				mc.btn_goto._visible 		= false;
				mc.btn_complete._visible 	= false;
			}
			
		}
		else
		{
			mc.task_button._visible = false;
			if (datas.taskType == "task_type_energy")
			{
                mc.ongoing.time_txt.text = datas.showTime;
                // mc.ongoing.time_txt.text 	= GetTimeText(datas.count_down);
			}
			
		}

	}
	else
	{
		mc.task_button.onRelease=function()
		{
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				var taskID=this.taskData.id
				fscommand("TaskCommand","GetAward"+'\2'+taskID);
				fscommand("PlayMenuConfirm");
			}
		}
		mc.task_button.onReleaseOutside = function()
		{
			this._parent.onReleasedInListbox();
		}
		mc.task_button.onPress = function()
		{
			this._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
		mc.progressbar.gotoAndStop(101);
		//mc.item_process.gotoAndStop(2)
	}

	var MAX_LENGTH = 2;
	var award_index = 1;
	for (var i = 0; i < MAX_LENGTH; ++i)
	{
		var award 	= datas.awardData[i];
		if (award == undefined)
		{
			if (i == 0)
			{
				mc.award_1._visible = false;
			}else
			{
				mc.award_2._visible = false;
				mc.award_3._visible = false;
			}
		}else
		{
			if (award.res_type == "resource")
			{
				var awardMc = mc["award_" + award_index];
				awardMc._visible = true;
				awardMc.item_icon.gotoAndStop(award.id);
				awardMc.num_text.text = award.count;
				if (award_index == 2)
				{
					var itemMc = mc.award_3;
					itemMc._visible = false;
				}
				award_index = award_index + 1;
			}else if (award.res_type == "item")
			{
				var awardMc = mc["award_2"];
				awardMc._visible = false;
				var itemMc = mc.award_3;
				itemMc._visible = true;
				if(itemMc.item_icon.icons==undefined)
				{
					var w = itemMc.item_icon._width;
					var h = itemMc.item_icon._height;
					itemMc.item_icon.loadMovie("CommonIcons.swf");
					itemMc.item_icon._width = w;
					itemMc.item_icon._height = h;
				}
				itemMc.item_icon.IconData = award.iconInfo;
				if (itemMc.item_icon.UpdateIcon) { itemMc.item_icon.UpdateIcon(); }
                itemMc.num_text.text = award.count;

				itemMc.res_type = award.res_type
				itemMc.res_id = award.id
				{
					itemMc.onRelease = function()
					{
						fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
					}
					itemMc.onReleaseOutside = function()
					{
						fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
					}
				}
			}
		}

	}

	//12 18 21



	//for the task detail
	mc.task_desc.html = true;
	mc.task_desc.htmlText=datas.taskDesc + " <font color='#ffffff'>" + datas.processNum + "</font>";
	//mc.item_process.desc_process.text=datas.taskName
	if (datas.state == 0)
	{
		var progress_num = Math.ceil((datas.taskTrace / datas.finishCount) * 100);
		mc.progressbar.gotoAndStop(progress_num + 1);
	}
	//set task icon
	mc.icons.gotoAndStop((Math.ceil(datas.id % 10)));
}

var MAX_SCALE = 1.05;
var MIN_SCALE = 0.8;
var PANEL_OFFSET = -10;

function SetMiniItemScale(minScale, maxScale, panelOffset)
{
	MIN_SCALE = minScale;
	MAX_SCALE = maxScale;
	PANEL_OFFSET = panelOffset;
}

function OnMiniItemScaleCallBack(mc)
{
	mc._xscale = mc._yscale = 100;
	var w = mc._width;
	var h = mc._height;

	var drag_list = mc._parent;
	var panelHeight = drag_list.hitZone_panel._height;
	var y = mc._y + h * 0.5;
	var halfHeight = panelHeight * 0.5;
	var distRate = 1.0 - Math.min(1.0, Math.max(0.0, Math.abs((y - (halfHeight + PANEL_OFFSET)) / halfHeight)));
	var scale = MIN_SCALE + ((MAX_SCALE - MIN_SCALE) * distRate);
	// trace("mc: " + mc.ItemIndex + " y: " + mc._y + " panelHeight: " + panelHeight + " rate: " + distRate + " scale: " + scale);


	mc._xscale = mc._yscale = scale * 100;
	mc._x = w * 0.5 * (1.0 - scale);
}

function SetAwardItem(mc,datas)
{

}

function FTEGetGotoPos()
{
	var mc
	if (FTEFirstGotoIdx == 0)
	{
		mc = _root.fte.dailymission_tab1
	}
	else if (FTEFirstGotoIdx == 1)
	{
		mc = _root.fte.dailymission_tab2
	}
	else if (FTEFirstGotoIdx == 2)
	{
		mc = _root.fte.dailymission_tab3
	}
	else if (FTEFirstGotoIdx == 3)
	{
		mc = _root.fte.dailymission_tab4
	}

	//_root.toluastr = ""
	_root.toluastr = ""+mc._x+"\2"+mc._y+"\2"+mc._width+"\2"+mc._height
}

function FTEClickDailyMissionTab()
{
	btn_daily_task.onRelease()
}

function FTEClickDailyMissionGoto()
{
	FTEClick = true
	FTEFirstGotoMC.task_button.onRelease()
	FTEClick = false
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.dailymission_tab1._visible = false
	_root.fteanim.dailymission._visible = false
	_root.fteanim.get_award._visible = false
	_root.fteanim.close._visible = false
	
}

FTEHideAnim()

