
var TaskSub = _root.seven_goal;
var ActivityTaskDatas = undefined;
var CurTaskDatas = undefined;
var ActivityTaskList = TaskSub.content.list_view.list;
var Milliseconds = 0;
var GoalTaskCountDown = 0;
var LocalTexts = undefined;
var CurPlayDay = 0;
var CurSelectDay = 0;

TaskSub.onEnterFrame = function()
{
	if (GoalTaskCountDown >= 0)
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
			Milliseconds += 1000;
			GoalTaskCountDown -= 1;
			SetTaskCountDown();
		}	
	}
	
}

function GetCountDownText(time)
{
	if (time == undefined)
	{
		return;
	}
	// var year 	= Math.floor(time / (365 * 24 * 3600));
	// time = time - (year * 365 * 24 * 3600);
	// var month  	= Math.floor(time / (30 * 24 * 3600));
	// time = time - (month * 30 * 24 * 3600);
	// var day 	= Math.floor(time / (24 * 3600));
	// time = time - (day * 24 * 3600);
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

function SetTaskCountDown()
{
	TaskSub.top_info.countdown.countdown_txt.text = GetCountDownText(GoalTaskCountDown);
}



TaskSub.top_info.btn_info.onRelease = function()
{
	fscommand("ShowCommonRuleDescPop", "LC_RULE_NEWPLAYER_ACHIEVEMENT_NAME" + "\2" + "LC_RULE_NEWPLAYER_ACHIEVEMENT_DESC");
}

TaskSub.top_info.get_btn.onRelease = function()
{
	fscommand("CityActivityCmd","ActivityTask\2"+'GetGoalAward');
}

function TaskSubInit()
{
	for(var i = 1; i <= 5; ++i )
	{
		var tab_mc = TaskSub.content["day" + i]
		tab_mc.day_num = i
		tab_mc.onRelease = function()
		{
			if (CurPlayDay >= this.day_num)
			{
				CurSelectDay = this.day_num;
				SetTabState(this.day_num);
			}else
			{
				fscommand("CityActivityCmd","ActivityTask\2"+'LockTips');
			}
		}
		tab_mc.red_point._visible = false;
	}
	//SetTabState(1);
}

function RefreshTaskData(datas)
{
	ActivityTaskDatas = datas.task_infos;
	CurPlayDay = datas.cur_playdays;
	if (CurPlayDay > 5)
	{
		CurPlayDay = 5;
	}
	GoalTaskCountDown = datas.end_countdown;
	if (GoalTaskCountDown < 0)
	{
		GoalTaskCountDown = 0
	}
	Milliseconds = 0;
	LocalTexts = datas.local_txts;
	
	
	if (CurSelectDay == 0)
	{
		CurSelectDay = CurPlayDay;
	}
	SetTabState(CurSelectDay);
	
	if (datas.score < 0)
	{
		TaskSub.top_info.get_btn._visible = false;
		TaskSub.top_info.countdown._visible = false;
		TaskSub.top_info.num._visible = false;
	}else
	{
		if (datas.cur_playdays <= 5)
		{
			TaskSub.top_info.get_btn._visible = false;
			TaskSub.top_info.countdown._visible = true;
		}else
		{
			TaskSub.top_info.get_btn._visible = true;
			TaskSub.top_info.countdown._visible = false;
		}	
		SetCompleteTaskNum(datas.score);
	}
	
	
	SetTaskCountDown();
	

}

function SetCompleteTaskNum(num )
{
	var mc = TaskSub.top_info.num;
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;
	mc.gotoAndStop(nLength);
	for(var i = 0; i < nLength; ++i)
	{
		var temp = Number(arrayNum[i]);
		mc["num" + i].gotoAndStop(temp + 1);
	}
}


function SetTabState(select_day)
{
	for(var i = 1; i <= 5; ++i )
	{
		var tab_mc = TaskSub.content["day" + i]
		tab_mc.day_num = i
		if (CurPlayDay >= i)
		{
			if (select_day == i)
			{
				tab_mc.gotoAndStop(1);
			}else
			{
				tab_mc.gotoAndStop(2);
			}	
		}else
		{
			tab_mc.gotoAndStop(3);
		}
	}

	if (ActivityTaskDatas != undefined)
	{
		for(var i = 0; i < ActivityTaskDatas.length; ++i)
		{
			var tab_mc = TaskSub.content["day" + (i + 1)];
			tab_mc.day_txt.text = LocalTexts["day" + (i + 1) + "_txt"];
			tab_mc.red_point._visible = false;
			for(var j = 0; j < ActivityTaskDatas[i].length; ++j)
			{
				if (ActivityTaskDatas[i][j].state == 1)
				{
					tab_mc.red_point._visible = true;
				}
			}
		}
	}

	InitTaskList(select_day);
}

function InitTaskList(select_day)
{
	CurTaskDatas = ActivityTaskDatas[select_day - 1];
	if (CurTaskDatas == undefined)
	{
		return;
	}
	ActivityTaskList.clearListBox();
	ActivityTaskList.initListBox("task_list_all",0,true,true);
	ActivityTaskList.enableDrag( true );
	ActivityTaskList.onEnterFrame = function(){
		this.OnUpdate();
	}

	ActivityTaskList.onItemEnter = function(mc,index_item)
	{
		mc._visible = true;
		var data = CurTaskDatas[index_item - 1]
		SetTaskItemInfo(mc, data)
	}

	ActivityTaskList.onItemMCCreate = undefined;

	ActivityTaskList.onListboxMove = undefined;
	for( var i=1; i <= CurTaskDatas.length; i++ )
	{
	    var temp=ActivityTaskList.addListItem(i, false, false);
	}
}


function SetTaskItemInfo(mc, info)
{
	//set taskbutton's state

	if(info.state==0)
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
	mc.task_button.taskData = info;


	if(info.state==0)
	{
		mc.task_button.onRelease=function()
		{
			this._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{

				var taskID=this.taskData.id
				trace("taskID=" + taskID);
				fscommand("CityActivityCmd","ActivityTask\2"+'Jump\2' + taskID);
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

		if(info.finishCount == 0)
		{
			mc.btn_goto._visible 		= false;
			mc.btn_complete._visible 	= false;
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
				fscommand("CityActivityCmd","ActivityTask\2"+'GetTaskAward\2' + taskID);
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
	}

	var MAX_LENGTH = 2;
	var award_index = 1;
	for (var i = 0; i < MAX_LENGTH; ++i)
	{
		var award 	= info.awardData[i];
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
				itemMc.item_icon.IconData = award.icon_data;
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

	//for the task detail
	mc.task_desc.html = true;
	mc.task_desc.htmlText=info.taskDesc + " <font color='#ffffff'>" + info.processNum + "</font>";
	if (info.state == 0)
	{
		var progress_num = Math.ceil((info.taskTrace / info.finishCount) * 100);
		mc.progressbar.gotoAndStop(progress_num + 1);
	}
}

