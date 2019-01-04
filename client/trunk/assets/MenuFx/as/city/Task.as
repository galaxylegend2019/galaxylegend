import com.tap4fun.utils.Utils;

var btn_main_task=_root.switch_buttons.button_mainTask
var btn_mini_task=_root.switch_buttons.button_miniTask
var btn_daily_task=_root.switch_buttons.button_dailyTask

var mc_main_task=_root.main_task
var mc_mini_task = _root.mini_task
var mc_daily_task=_root.daily_task

var isFirstLoad=false
var DailyDatas
var MiniDatas
var MainDatas
var lastDailyData
var lastMainData
var lastMiniData

var curPageMC = undefined;

_root.onLoad=function()
{
	isFirstLoad=true

	_root.task_result._visible=false;
	InitSwitchButtons()

	mc_main_task._visible = false;
	mc_mini_task._visible = false;
	mc_daily_task._visible = false;

	//testF()
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

_root.bg.btn_close.onRelease=function()
{
	_root.bg.gotoAndPlay("closing_ani")

	_root.bg.OnMoveOutOver=function()
	{
		_root._visible=false
		this.OnMoveOutOver=undefined
		fscommand("GotoNextMenu","GS_MainMenu")
	}
	fscommand("PlayMenuBack");
}

function InitUIInfo(inputData)
{
	_root.task_result._visible=false

	MainDatas=inputData.mainTask
	MiniDatas = inputData.miniTask
	DailyDatas=inputData.dailyTask

	lastDailyData=DailyDatas
	lastMainData=MainDatas
	lastMiniData=MiniDatas

	// btn_main_task.onRelease()
	updateTaskCount(inputData)
}

function UpdateTaskData(inputData)
{
	MainDatas=inputData.mainTask
	DailyDatas=inputData.dailyTask
	MiniDatas=inputData.miniTask

	updateTaskCount()


	updateDailyData()
	updateMainData()
	updateMiniData()
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
	btn_mini_task.tips._visible = false;
	btn_daily_task.tips._visible = false;

	btn_main_task.onRelease=function()
	{	
		if(curPageMC != mc_main_task)
		{
			fscommand("PlayMenuConfirm");
		}
		showMain()
	}

	btn_mini_task.onRelease=function()
	{	
		if(curPageMC != mc_mini_task)
		{
			fscommand("PlayMenuConfirm");
		}
		showMini()
	}

	btn_daily_task.onRelease=function()
	{
		if(curPageMC != mc_daily_task)
		{
			fscommand("PlayMenuConfirm");
		}
		showDaily()
	}
}

function updateTaskTips(inputData)
{
	btn_main_task.tips.tt.text=inputData.mainTaskNum
	btn_main_task.tips._visible=inputData.mainTaskNum>0

	btn_mini_task.tips.tt.text=inputData.miniTaskNum
	btn_mini_task.tips._visible=inputData.miniTaskNum>0

	//btn_daily_task.tips.num.text="222"//inputData.dailyTaskNum
	btn_daily_task.tips.tt.text=inputData.dailyTaskNum
	btn_daily_task.tips._visible=inputData.dailyTaskNum>0

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
	btn_mini_task.gotoAndStop(1)
	btn_daily_task.gotoAndStop(1)

	mc_main_task._visible=true
	if(curPageMC != mc_main_task)
	{
		mc_main_task.gotoAndPlay("opening_ani")
	}
	curPageMC = mc_main_task;

	InitMainList()
}

function showMini()
{
	if(curPageMC && curPageMC != mc_mini_task)
	{
		playCloseAni(curPageMC);
	}

	btn_main_task.gotoAndStop(1);
	btn_mini_task.gotoAndStop(2)
	btn_daily_task.gotoAndStop(1)

	mc_mini_task._visible=true
	if(curPageMC != mc_mini_task)
	{
		mc_mini_task.gotoAndPlay("opening_ani")
	}
	curPageMC = mc_mini_task;

	InitMiniList()
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
	btn_mini_task.gotoAndStop(1)
	btn_daily_task.gotoAndStop(2)

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
		showMini();
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
		var ui_drag_list=mc_daily_task.daily_task.task_list
		for(var i=lastDailyData.length+1;i<=DailyDatas.length;i++)
		{
			ui_drag_list.addListItem(i, false, false);	
			// trace("ui_drag_list.addListItem: " + i);
		}
	}else if(DailyDatas.length<lastDailyData.length)
	{
		var ui_drag_list=mc_daily_task.daily_task.task_list
		for(var i=DailyDatas.length+1;i<=lastDailyData.length;i++)
		{
			// trace("ui_drag_list.erase: " + i);
			ui_drag_list.eraseItem(i);	
		}
	}


	lastDailyData=DailyDatas
	if(mc_daily_task._visible)
	{
		mc_daily_task.daily_task.task_list.needUpdateVisibleItem()
	}
}

function InitDailyList()
{
	if(DailyDatas==undefined)
	{
		return
	}

	var listLength=DailyDatas.length

	var ui_drag_list=mc_daily_task.daily_task.task_list

	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("task_list_all",10,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		mc._visible=true
		var datas=DailyDatas[index_item-1]
		SetTaskItemData(mc,datas)

	}

	ui_drag_list.onItemMCCreate = function(mc){
		mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	

	for( var i=1; i <= listLength; i++ )
	{   
	    var temp=ui_drag_list.addListItem(i, false, false);
	}

}

function InitMiniList()
{
	if(MiniDatas==undefined)
	{
		return
	}

	var listLength=MiniDatas.length

	var ui_drag_list=mc_mini_task.mini_task.task_list

	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("task_list_all",10,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		mc._visible=true
		var datas=MiniDatas[index_item-1]
		SetTaskItemData(mc,datas)

	}

	ui_drag_list.onItemMCCreate = function(mc){
		mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	

	for( var i=1; i <= listLength; i++ )
	{   
	    var temp=ui_drag_list.addListItem(i, false, false);
	}
}

function updateMiniData()
{	
	if(MiniDatas.length>lastMiniData.length)
	{
		var ui_drag_list=mc_mini_task.mini_task.task_list
		for(var i=lastMiniData.length+1;i<=MiniDatas.length;i++)
		{
			ui_drag_list.addListItem(i, false, false);	
		}
	}else if(MiniDatas.length<lastMiniData.length)
	{
		var ui_drag_list=mc_mini_task.mini_task.task_list
		for(var i=MiniDatas.length+1;i<=lastMiniData.length;i++)
		{
			ui_drag_list.eraseItem(i);	
		}
	}


	lastMiniData=MiniDatas
	if(mc_mini_task._visible)
	{
		mc_mini_task.mini_task.task_list.needUpdateVisibleItem()
	}
}

function updateMainData()
{	
	if(MainDatas.length>lastMainData.length)
	{
		trace("length is increase")
		var ui_drag_list=mc_main_task.maintask.task_list
		for(var i=lastMainData.length+1;i<=MainDatas.length;i++)
		{
			ui_drag_list.addListItem(i, false, false);	
		}
	}else if(MainDatas.length<lastMainData.length)
	{
		trace("length is redece")
		var ui_drag_list=mc_main_task.maintask.task_list
		for(var i=MainDatas.length+1;i<=lastMainData.length;i++)
		{
			trace("erase index is "+i)
			ui_drag_list.eraseItem(i);	
		}
		//ui_drag_list.removeListItem()
		//ui_drag_list.RefreshListItemHeight()
	}


	lastMainData=MainDatas

	if(mc_main_task._visible)
	{
		mc_main_task.maintask.task_list.needUpdateVisibleItem()
	}
}
function InitMainList()
{
	if(MainDatas==undefined)
	{
		return
	}
	var listLength=MainDatas.length


	var ui_drag_list=mc_main_task.maintask.task_list

	ui_drag_list.setSpecialItemHeight("task_ui_maintask",0)
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("task_list_all_1",0,true,true);
	ui_drag_list.enableDrag( true );	

	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		//trace("-------"+index_item)
		//trace(mc)

		var taskData=MainDatas[index_item-1]
		if(taskData!=undefined && mc!=undefined)
		{
			mc._visible=true
			if(taskData.taskType=="task_type_main")
			{
				mc.isSpecial=true
				mc.task_ui_maintask._visible=true
				mc.task_list_all._visible=false
				mc.ItemHeight=ui_drag_list._getItemHeight(mc.task_ui_maintask)

				var item=mc.task_ui_maintask
				item.taskData=taskData

				item.content_title.title_text.awardDesc.text=taskData.taskReq
				item.content_title.title_text.awardProcess.htmlText=taskData.processNum
				item.txt_taskName.text = taskData.taskName
				item.task_desc.text=taskData.taskDesc

				item.content_title.title_text.awardProcess._x = item.content_title.title_text.awardDesc._x + item.content_title.title_text.awardDesc.textWidth + 6;

				var awardLength=taskData.awardData.length
				var MAX_LENGTH=5
				var clipLen = Math.min(awardLength, MAX_LENGTH);
				item.icons.gotoAndStop(clipLen);
				for(var i=0;i<clipLen;i++)
				{
					var award=item.icons["award"+(i + 1)]
					// trace("award: " + award + "  i: " + i);

					if(i<awardLength)
					{
						award._visible=true
						var awardData=taskData.awardData[i]

						//for the item color(quality)
						//award.gotoAndStop(1)
						
						award.num_text.text=awardData.count
						if(award.item_icon.icons==undefined)
						{
							award.item_icon.loadMovie("CommonIcons.swf")
						}
						// award.item_icon.icons.gotoAndStop("item_"+awardData.id)
						award.item_icon.IconData = awardData.iconInfo
						if (award.item_icon.UpdateIcon) { award.item_icon.UpdateIcon(); }

						award.res_type = awardData.res_type
						award.res_id = awardData.id
						if(awardData.res_type == "item")
						{
							award.onPress = function()
							{
								this.item_icon.SelectIcon(true);
								fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
							}
							award.onRelease = award.onReleaseOutside = function()
							{
								this.item_icon.SelectIcon(false);
								fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
							}
						}
						else
						{
							award.onPress = undefined;
							award.onRelease = undefined;
						}

					}else
					{
						award._visible=false
					}

				}

				if(taskData.state==1)
				{
					item.btn_jump._visible=false
					item.btn_get._visible=true

					item.btn_get.onRelease=function()
					{
						this._parent._parent._parent.onReleasedInListbox();
						if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
						{
							var taskID=this._parent.taskData.id
							fscommand("TaskCommand","GetAward"+'\2'+taskID)
						}
					}
					item.btn_get.onReleaseOutside = function()
					{
						this._parent._parent._parent.onReleasedInListbox();
					}
					item.btn_get.onPress = function()
					{
						this._parent._parent._parent.onPressedInListbox();
						this.Press_x = _root._xmouse;
						this.Press_y = _root._ymouse;
					}

				}else
				{
					item.btn_jump._visible=true
					item.btn_get._visible=false

					if(taskData.origin)
					{
						item.btn_jump._visible = true;
						item.btn_jump.onRelease=function()
						{
							this._parent._parent._parent.onReleasedInListbox();
							if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
							{
								var taskID=this._parent.taskData.id
								fscommand("TaskCommand","Jump"+'\2'+taskID)
								fscommand("PlayMenuConfirm");
							}
						}
						item.btn_jump.onReleaseOutside = function()
						{
							this._parent._parent._parent.onReleasedInListbox();
						}
						item.btn_jump.onPress = function()
						{
							this._parent._parent._parent.onPressedInListbox();
							this.Press_x = _root._xmouse;
							this.Press_y = _root._ymouse;
						}
					}
					else
					{
						item.btn_jump._visible = false;
					}
				}
			}else
			{
				mc.isSpecial=false
				mc.ItemHeight=ui_drag_list._getItemHeight(mc.task_list_all)

				mc.task_ui_maintask._visible=false
				mc.task_list_all._visible=true

				SetTaskItemData(mc.task_list_all,taskData)
			}
		}else
		{
			mc._visible=false
		}

	}

	for( var i=1; i <= listLength; i++ )
	{   
	    var temp=ui_drag_list.addListItem(i, false, false);
	}

}

function SetTaskItemData(mc,datas)
{
	//set taskbutton's state
	mc.task_button.taskData=datas

/*	if(mc.item_icon.icons.normal_icons.icons=undefined)
	{
		mc.item_icon.icons.normal_icons.loadMovie("CommonIcons.swf")
	}
	mc.item_icon.icons.normal_icons.icons.gotoAndStop(icons)*/


	if(datas.state==0)
	{
		mc.task_button.gotoAndStop(2)
		if(mc.task_button.taskData.origin)
		{
			mc.task_button._visible = true;
			mc.task_button.onRelease=function()
			{
				this._parent._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					var taskID=this.taskData.id
					fscommand("TaskCommand","Jump"+'\2'+taskID);
					fscommand("PlayMenuConfirm");
				}
			}
			mc.task_button.onReleaseOutside = function()
			{
				this._parent._parent.onReleasedInListbox();
			}
			mc.task_button.onPress = function()
			{
				this._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}

			if(datas.finishCount == 0)
			{
				mc.item_process.gotoAndStop(3)
			}
			else
			{
				mc.item_process.gotoAndStop(1)
			}
		}
		else
		{
			mc.task_button._visible = false;
		}
	}
	else
	{
		mc.task_button.gotoAndStop(1)
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
			this._parent._parent.onReleasedInListbox();
		}
		mc.task_button.onPress = function()
		{
			this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}


		mc.item_process.gotoAndStop(2)
	}
	//for the task award 
	var MAX_LENGTH=3
	var awardLength=datas.awardData.length
	for(var i=0;i<MAX_LENGTH;i++)
	{
		var award=mc["award_"+(i+1)]

		if(i<awardLength)
		{
			award._visible=true
			var awardData=datas.awardData[i]

			//for the item color(quality)
			//award.gotoAndStop(1)
			
			award.num_text.text=awardData.count
			if(award.item_icon.icons==undefined)
			{
				award.item_icon.loadMovie("CommonIcons.swf")
			}
			// award.item_icon.icons.gotoAndStop("item_"+awardData.id)
			award.item_icon.IconData = awardData.iconInfo
			if (award.item_icon.UpdateIcon) { award.item_icon.UpdateIcon(); }
			award.item_icon._width=25
			award.item_icon._height=25

			award.res_type = awardData.res_type
			award.res_id = awardData.id
			if(awardData.res_type == "item")
			{
				award.onPress = function()
				{
					this.item_icon.SelectIcon(true);
					fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
				}
				award.onRelease = award.onReleaseOutside = function()
				{
					this.item_icon.SelectIcon(false);
					fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
				}
			}
			else
			{
				award.onPress = undefined;
				award.onRelease = undefined;
			}

		}else
		{
			award._visible=false
		}
	}


	//for the task detail
	mc.task_desc.text=datas.taskDesc
	mc.item_process.desc_process.text=datas.taskName
	mc.item_process.num_process.text=datas.processNum
	// mc.item_process.desc_process._x = mc.item_process.num_process._x + mc.item_process.num_process.textWidth + 6;
}

function SetAwardItem(mc,datas)
{

}

