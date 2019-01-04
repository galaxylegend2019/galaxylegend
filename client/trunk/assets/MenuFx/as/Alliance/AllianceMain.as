var MainUI 			= _root.main_ui;

var MainTitle 		= _root.filter_contral;

var CloseBtn 		= MainUI.top.btn_close;
var TopUI = MainUI.top;

var HomePanel 		= MainUI.all_content.home_content;
var MemberPanel 	= MainUI.all_content.member_content;
var DefendPanel 	= MainUI.all_content.defend_content;
var TaskPanel 		= MainUI.all_content.task_content;
var WarPanel 		= MainUI.all_content.war_content;
var PlanetPanel 	= MainUI.all_content.planet_content;

var Panels = new Array();


var HomeSwitchBtn 	= MainTitle.filter_button_1;
var MemberSwitchBtn = MainTitle.filter_button_2;
var DefendSwitchBtn = MainTitle.filter_button_3;
var TaskSwitchBtn 	= MainTitle.filter_button_4;
var WarSwitchBtn 	= MainTitle.war_btn;
var PlanetSwitchBtn = MainTitle.planet_btn;

var SwitchBtns = new Array();

var CurPanelIndex = undefined;

var LoaclTexts = undefined;

this.onLoad = function()
{
	InitPanel();
	MainUI.gotoAndPlay("opening_ani");
    MainTitle.gotoAndPlay("opening_ani");
    TopUI.gotoAndPlay("opening_ani");
	MemberTabRedPoint._visible 		= false;
	MemberApplyRedPoint._visible 	= false;
	TaskRedpoint._visible = false;
}

function InitPanel()
{
	Panels.push(HomePanel);
	Panels.push(MemberPanel);
	Panels.push(WarPanel);
	Panels.push(PlanetPanel);
	Panels.push(DefendPanel);
	Panels.push(TaskPanel);


	SwitchBtns.push(HomeSwitchBtn);
	SwitchBtns.push(MemberSwitchBtn);
	SwitchBtns.push(WarSwitchBtn);
	SwitchBtns.push(PlanetSwitchBtn);
	SwitchBtns.push(DefendSwitchBtn);
	SwitchBtns.push(TaskSwitchBtn);

	for(var i = 0; i < 6; ++i)
	{
		Panels[i]._visible = false;
	}
	SwitchPanel(HomeSwitchBtn);
	InitHomePanel();
	InitDefendPanel();
	//InitTaskPanel();
	//UpdateAwardBtnsState();
	InitPlanetPanel();
}

CloseBtn.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
    MainTitle.gotoAndPlay("closing_ani");
    TopUI.gotoAndPlay("closing_ani");
}


MainUI.OnMoveInOver = function()
{
}

MainUI.OnMoveOutOver = function()
{
	fscommand("GotoNextMenu", "GS_MainMenu");
}


HomeSwitchBtn.onRelease = MemberSwitchBtn.onRelease = WarSwitchBtn.onRelease = PlanetSwitchBtn.onRelease =
DefendSwitchBtn.onRelease = TaskSwitchBtn.onRelease = function()
{
	SwitchPanel(this);
}

function SetPanelTexts( texts )
{
	LoaclTexts = texts;
}

function SetPanelShow( isShow )
{
	if (isShow)
	{
		_root._visible = true;
	}else
	{
		_root._visible = false;
	}
}

function SwitchPanel(btn)
{
	if (btn == undefined)
	{
		return;
	}
	var name = btn._name;
	var panel_index = 0;
	switch(name)
	{
		case "filter_button_1":
			SwtichHelper(0);
			panel_index = 0;
		break;
		case "filter_button_2":
			SwtichHelper(1);
			panel_index = 1;
		break;
		case "filter_button_3":
			SwtichHelper(4);
			panel_index = 4;
		break;
		case "filter_button_4":
			SwtichHelper(5);
			panel_index = 5;
		break;
		case "war_btn":
			SwtichHelper(2);
			panel_index = 2;
		break;
		case "planet_btn":
			SwtichHelper(3);
			panel_index = 3;
		break;
		default:
			trace("Cant switch to this panel! name=" + name);
		break;
	}
	
}

var LastReqTime = new Array();

function SwtichHelper(index)
{
	if (index == CurPanelIndex)
	{
		return;
	}
	if (CurPanelIndex != undefined)
	{
		Panels[CurPanelIndex]._visible = false; 
		SwitchBtns[CurPanelIndex].gotoAndStop(1);
	}
	Panels[index]._visible = true;
	SwitchBtns[index].gotoAndStop(2);
	var cur_date = new Date();
	var cur_time = cur_date.getTime();
	if (cur_time - LastReqTime[index] >= 2000 and CurPanelIndex != undefined)
	{
		fscommand("AllianceMainCmd","ReqPanelData" +"\2"+String(index));
		LastReqTime[index] = cur_time;
	}
	CurPanelIndex = index;
}




/**********************************************/
/******************首页显示*********************/
/**********************************************/

var AllianceLevelText	= HomePanel.level_txt;
var AllianceNameText 	= HomePanel.alliance_name_txt;
var PresidentNameText 	= HomePanel.president_name_txt;
var MemberInfoText 		= HomePanel.member_num_txt;
var ActiveInfoText 		= HomePanel.active_num_txt;

var EditorBtn 			= HomePanel.btn_editor;
var NoticeInput 		= HomePanel.notice_content.notice_input;
var NoticeText 			= NoticeInput.content_txt;
var NoticeHitZone 		= NoticeInput.hitzone;
var NoticeList 			= HomePanel.notice_content.listView;

var AllianceSetBtn 		= HomePanel.alliance_set_btn;
var AllianceNoticeBtn1	= HomePanel.notice_content1_btn;
var AllianceNoticeBtn2 	= HomePanel.notice_content2_btn;

var AllianceExpProgressBar	= HomePanel.num_processBar.progress_bar;
var InfoBtn 				= HomePanel.btn_info;
var RankNum 				= HomePanel.rank_num;

var AllianceBaseData = undefined;

function InitHomePanel()
{
	/*SetRankNum(RankNum,12579);
	SetBtnShow(true);*/
	NoticeInput.init("UIKeyboardTypeDefault", "FlashAllianceMainUI", "hitzone", "", "content_txt", false, false, '', "TextView", null, null, null, true);
	NoticeInput.setMaxLength(200);
	NoticeHitZone._visible = false;
	NoticeInput.onHideKeyboard = function()
	{
		var desc = NoticeInput.getInputString();
		if (desc == "" )
		{
			NoticeInput.lua2fs_setText(AllianceBaseData.desc);
		}else
		{
			fscommand("AllianceMainCmd", "SetAllianceNotice" + "\2" + desc);
		}
		//this.hitzone._visible = true;
		MainTitle._visible = true;
		NoticeInput._visible = false;
		NoticeList._visible = true;
		SetNoticeContent(desc);
		trace("---------hide-----------")
	}

	

	NoticeInput.onShowKeyboard = function()
	{
		//this.content_txt._visible = false;
		MainTitle._visible = false;
		//this.hitzone._visible = false;
		NoticeList._visible = false;
	}

	HomePanel.posY = HomePanel._y;
	NoticeInput.onChangeKeyBoardHeight = function()
	{
		HomePanel._y = HomePanel.posY - NoticeInput.GetHeightChange();
	}

}


var AllNoticeTextMc = new Array();

function ClearAwardMc()
{
	for(var i in AllNoticeTextMc)
	{
		AllNoticeTextMc[i].removeMovieClip()
	}
	NoticeList.forceCorrectPosition();
}

function SetNoticeContent(desc)
{
	ClearAwardMc();
	var CurContent = NoticeList.slideItem.attachMovie("content_txt", "content", NoticeList.slideItem.getNextHighestDepth());
	CurContent.content_txt.html =true;
	CurContent.content_txt.htmlText = desc;
	CurContent._y = 0;
	AllNoticeTextMc.push(CurContent);

	var endLine = NoticeList.slideItem.attachMovie("content_txt", "content", NoticeList.slideItem.getNextHighestDepth());
	endLine.content_txt.text = "";
	endLine._y = CurContent.content_txt.textHeight;
	endLine._height = 10;
	AllNoticeTextMc.push(endLine);


	NoticeList.SimpleSlideOnLoad();
	NoticeList.onEnterFrame = function()
	{
		NoticeList.OnUpdate();
	}
}

/*function UpdateTextField(mc:MovieClip)
{
	mc.content_txt._visible = ("" == mc.getInputString())?true:false;
}*/

function UpdateHomePanel(data)
{
	AllianceBaseData = data;

	if (AllianceBaseData == undefined)
	{
		return;
	}
	AllianceLevelText.text 	= AllianceBaseData.level;
	AllianceNameText.text 	= AllianceBaseData.name;
	PresidentNameText.text 	= AllianceBaseData.president_name;
	MemberInfoText.text 	= AllianceBaseData.cur_member + "/" + AllianceBaseData.max_member;
	ActiveInfoText.html 	= true;
	ActiveInfoText.htmlText = LoaclTexts.TotalActivity + AllianceBaseData.cur_active + "/" + AllianceBaseData.max_active;

	NoticeInput.lua2fs_setText(AllianceBaseData.desc);
	NoticeInput._visible = false;
	NoticeList._visible = true;
	SetNoticeContent(AllianceBaseData.desc);

	EditorBtn._visible = AllianceBaseData.isPresident;
    SetBtnShow(AllianceBaseData.isPresident);
    RankNum.rank_text.text = AllianceBaseData.rank;
    // SetRankNum(RankNum, AllianceBaseData.rank);
    // SetProgressBar(AllianceExpProgressBar, AllianceBaseData.cur_active / AllianceBaseData.max_active);
	SetAllianceIcon(AllianceBaseData.icon);

	HomePanel.attack_times_txt.text = AllianceBaseData.cur_war_times + "/" + AllianceBaseData.max_war_times;
	HomePanel.planet_num_txt.text = AllianceBaseData.cur_planet_num + "/" + AllianceBaseData.max_planet_num;
	HomePanel.activity_txt.text = AllianceBaseData.cur_active;
}

EditorBtn.onRelease = function()
{
	/*if (_global.IsWin32)
	{
		NoticeHitZone.gotoAndPlay("released");
	}
	NoticeInput.onHitZoneRelease();*/
	
	NoticeInput._visible = true;
	NoticeList._visible = false;
	trace(NoticeList);


	NoticeHitZone.onRelease();
	
	var desc = NoticeInput.getInputString();
	NoticeInput.SetKeyBoardText(desc);

}



InfoBtn.onRelease = function()
{
	//TODO:
	trace("----Click InfoBtn----");
	fscommand("AllianceMainCmd", "ShowHelpInfo" + "\2" + "home");
}

AllianceSetBtn.onRelease = function()
{
	fscommand("GoToNext", "GoToSeting");
}

AllianceNoticeBtn1.onRelease = AllianceNoticeBtn2.onRelease = function()
{
	fscommand("GoToNext", "GoToRecord")
}

function SetBtnShow( isPresident )
{
	if (isPresident)
	{
		AllianceSetBtn._visible 	= true;
		AllianceNoticeBtn2._visible = true;
		AllianceNoticeBtn1._visible = false;
	}else
	{
		AllianceSetBtn._visible 	= false;
		AllianceNoticeBtn2._visible = false;
		AllianceNoticeBtn1._visible = true;
	}
}

function SetRankNum(mc, num )
{
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;
	mc.gotoAndStop(nLength);
	for(var i = 0; i < nLength; ++i)
	{
		var temp = Number(arrayNum[i]);
		mc["r_" + i].gotoAndStop(temp + 1);
	}
}

function SetProgressBar(progress_bar, rate)
{
	if (progress_bar == undefined)
	{
		return;
	}
	var nProgress = Math.ceil(rate * 100);
	if (nProgress < 1)
	{
		nProgress = 1;
	}else if (nProgress >= 100)
	{
		nProgress = 100;
	}
	progress_bar.gotoAndStop(nProgress + 1);
}

function SetAllianceIcon( strIcon )
{	
	HomePanel.icon.icon_bg._visible = false;
	if (HomePanel.icon.item_icon.icons == undefined)
	{
		var h = HomePanel.icon.item_icon._height;
		var w = HomePanel.icon.item_icon._width;
        HomePanel.icon.item_icon.loadMovie("AllianceIcon.swf");
		HomePanel.icon.item_icon._height = h;
		HomePanel.icon.item_icon._width  = w;
	}
    HomePanel.icon.item_icon.icons.gotoAndStop(strIcon);
}

function UpdateHomeTabTaskContent()
{
    if (TaskDatas == undefined)
    {
        trace("home taskdatas is undefined")
        return
    }
    UpdateAwardBtnsStateHome()
}

function UpdateAwardBtnsStateHome()
{
    trace("-------------xxxxxxxxxx-----")
    var max_active = 0;
    for(var i in TaskDatas.ActivityAwards)
    {
        var award = TaskDatas.ActivityAwards[i];
        var btn = HomePanel.num_processBar["award" + i + "_btn"];
        if (btn != undefined)
        {
            btn.gotoAndStop(award.state);
            btn.award = award;
            if (award.state == 2)  //can open
            {
                btn.onRelease = function()
                {
                    fscommand("AllianceMainCmd", "GetActivityAward" + "\2" + this.award.need_active);
                }
            }else
            {
                btn.onRelease = function()
                {
                    fscommand("AllianceMainCmd", "ShowActiveAwards" + "\2" + this.award.need_active);
                }
            }
            var bound = HomePanel.num_processBar["bound" + i];
            bound.text = award.need_active;
            if (award.need_active > max_active)
            {
                max_active = award.need_active;
            }
        }
    }
    SetProgressBar(AllianceExpProgressBar, TaskDatas.active / max_active);  //TODO: 300
}




/**********************************************/
/******************成员显示*********************/
/**********************************************/

//var MemberNumText 	= MemberPanel.defend_num_txt;
var GroupSendBtn	= MemberPanel.group_send_btn;
var AskLogBtn 		= MemberPanel.ask_log_btn;
var QuitBtn 		= MemberPanel.quit_btn;

var MemberList 		= MemberPanel.view_list;

var MemberTabRedPoint	= MainTitle.filter_button_2.task_tips;
var MemberApplyRedPoint	= MemberPanel.red_point;

var MemberDatas 	= undefined;
var OwnData 		= undefined;
var OwnDuty 		= 0;
function InitMemberPanel( data )
{
	MemberDatas = data.all;
	OwnData 	= data.own;
	if (MemberDatas == undefined)
	{
		return;
	}
/*	var defend_num = 0
	for(var i in MemberDatas)
	{
		if (MemberDatas[i].is_defend)
		{
			defend_num = defend_num + 1;
		}
	}
	MemberNumText.text = defend_num;*/

	MemberList.ItemIndex = undefined;
	MemberList.ClickedItem = undefined;

	InitMemberList();

	if (OwnData.post == 5)
	{
		QuitBtn.quit_txt.text = LoaclTexts.DissolveAllianceText;
	}else
	{
		QuitBtn.quit_txt.text = LoaclTexts.QuitAllianceText;
	}
	
	SetOwnInfo();
}

function SetOwnInfo()
{
    // SetOwnIcon();
    MemberPanel.name_txt.text = OwnData.name
	MemberPanel.level_txt.text 					= OwnData.level;
    MemberPanel.total_activity.htmlText 			= OwnData.all_active;
    MemberPanel.LC_UI_Alliance_List_Last_Time.html = true;
	if (OwnData.last_login == 0)
	{
        MemberPanel.last_time.htmlText = LoaclTexts.MemberOnlineStatus;
	}else
	{
        MemberPanel.last_time.htmlText = GetTimeText(OwnData.last_login);
    }
	
	SetDuty(MemberPanel.duty_content, OwnData);
    // MemberPanel.LC_UI_Alliance_List_Defensive.html = true;
    // if (OwnData.is_defend)
    // {
    // 	MemberPanel.LC_UI_Alliance_List_Defensive.htmlText = LoaclTexts.IsDefendText + " " + "<font color='#ffffff'>" + LoaclTexts.DefendTrue + "</font>";
    // }else
    // {
    // 	MemberPanel.LC_UI_Alliance_List_Defensive.htmlText = LoaclTexts.IsDefendText + " " + "<font color='#ffffff'>" + LoaclTexts.DefendFalse + "</font>";
    // }
}

function SetOwnIcon()
{
	if (MemberPanel.hero_icons.item_icon.icons == undefined)
	{
		var h = MemberPanel.hero_icons.item_icon._height;
		var w = MemberPanel.hero_icons.item_icon._width;
		MemberPanel.hero_icons.item_icon.loadMovie("CommonPlayerIcons.swf");
		MemberPanel.hero_icons.item_icon._height = h;
		MemberPanel.hero_icons.item_icon._width  = w;
	}
	MemberPanel.hero_icons.item_icon.IconData = OwnData.playerIcon;
	if(MemberPanel.hero_icons.item_icon.UpdateIcon)
	{ 
		MemberPanel.hero_icons.item_icon.UpdateIcon(); 
	}
}

GroupSendBtn.onRelease = function()
{
	//TODO:
	trace("------ Click GroupSendBtn ------");
	fscommand("AllianceMainCmd", "GroupSend" )
	//fscommand("AllianceMainCmd", "ReqSetData" + "\2" + "3" + "\2" + "1" + "\2" + "item_174")
}

AskLogBtn.onRelease = function()
{
	fscommand("GoToNext", "GoToApply");
}

QuitBtn.onRelease = function()
{
	fscommand("AllianceMainCmd", "QuitAlliance");
}


function InitMemberList()
{
	if (MemberDatas == undefined)
	{
		return;
	}
	MemberList.clearListBox();
	MemberList.initListBox("item_member_list",0,true,true);
	MemberList.enableDrag( true );
	MemberList.onEnterFrame = function(){
		this.OnUpdate();
	}

	MemberList.onItemEnter = function(mc,index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetMemberItemInfo(mc, index_item);
	}
	MemberList.onItemLeave = function(mc, index_item)
	{
		if (this.ClickedItem.Index == index_item)
		{
			this.ItemIndex = index_item;
			this.ClickedItem = undefined;
		}
	}
	MemberList.onItemMCCreate = undefined;
	MemberList.onListboxMove = undefined;

	for( var i = 1; i <= MemberDatas.length; i++ )
	{   
	    var temp = MemberList.addListItem(i, false, false);
	}
}


function SetMemberItemInfo(mc, index)
{
	mc.Index = index;

	if (mc._parent.ItemIndex == index)
	{
		mc.gotoAndStop("state2");
		mc._parent.ClickedItem = mc;
		mc._parent.ItemIndex = index;
	}else
	{
		mc.gotoAndStop("state1");
	}

	if (mc._parent.ClickedItem != undefined and mc._parent.ClickedItem.Index == index)
	{
		SetHandleItemRelease(mc, index, false);
	}
	else
	{
		SetInfoItemRelease(mc, index, false);
	}
	
}


function SetInfoItemRelease(mc, index_item, isPlayAni)
{
	mc.OnSetHandleInfo = function()
	{
		var data = MemberDatas[this.Index];
		this.item_content.name_txt.text = data.name;
	}

	mc.OnPlayOutOver = function()
	{
		this.item_content.chat_btn._visible = false;
		this.item_content.mail_btn._visible = false;
		this.item_content.fire_btn._visible = false;
        this.item_content.up_btn._visible = false;
        this.item_content.down_btn._visible = false;
		this.item_content.item_bg_btn._visible = false;
		this.info_content.item_bg_btn._visible = true;
		this.gotoAndStop(1);
		SetMemberBaseInfo(this, this.Index);
		
		{
			this.info_content.item_bg_btn.onPress = function()
			{
				this._parent._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}

			this.info_content.item_bg_btn.onReleaseOutside = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
			}

			this.info_content.item_bg_btn.onRelease = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
				var itemMc = this._parent._parent;
				var data = MemberDatas[itemMc.Index];
				if (OwnData.player_id == data.player_id)
				{
					return;
				}
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					
					if (itemMc._parent.ClickedItem != undefined and itemMc._parent.ItemIndex != itemMc.Index)
					{
						itemMc._parent.ClickedItem.gotoAndPlay("show_info_ani");
						SetInfoItemRelease(itemMc._parent.ClickedItem, itemMc._parent.ItemIndex, true);
					}
					itemMc.gotoAndPlay("handle_ani");
					itemMc._parent.ItemIndex = itemMc.Index;
					itemMc._parent.ClickedItem = itemMc;
					SetHandleItemRelease(itemMc, itemMc.Index, true);
					
				}
			}
		}
	}

	if (not isPlayAni)
	{
		mc.OnPlayOutOver();
	}

}

function SetDuty(mc,data)
{
	switch(data.post)
	{
		case 1:
		case 2:
		case 3:
			mc.gotoAndStop("normal");
			mc.duty_txt.text = LoaclTexts.DutyNormalMemberNameText;
			break;
		case 4:
			mc.gotoAndStop("normal");
			mc.duty_txt.text = LoaclTexts.DutyVicePresidentNameText;
			break;
		case 5:
			mc.gotoAndStop("president");
			mc.duty_txt.text = LoaclTexts.DutyPresidentNameText;
			break;
		default:
			trace("---------Dont Find Duty-----------")
			break;
	}
	
}

function GetTimeText(time)
{
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
	var ret = "";
	if (0 != year)
	{
		ret = ret + year + "Y";
	}
	if (0 != month)
	{
		ret = ret + month + "M";
	}
	if (0 != day)
	{
		ret = ret + day + "d";
	}
	if (0 != hour)
	{
		ret = ret + hour + "h";
	}
	if (0 != minutes)
	{
		ret = ret + minutes + "min";
	}
	if (ret == "")
	{
		ret = "<1min";
	}
	return ret;
}

function SetMemberBaseInfo(mc, index_item)
{
	var data = MemberDatas[index_item];
	mc.info_content.name_txt.text = data.name;
	mc.info_content.level_txt.text = data.level;
	mc.info_content.day_contribution_txt.text = data.day_active;
	mc.info_content.history_contribution_txt.text = data.all_active;
	mc.info_content.last_login_time_txt.html = true;
	if (0 == data.last_login)
	{
		mc.info_content.last_login_time_txt.htmlText = '<font color="#43C859">' + LoaclTexts.MemberOnlineStatus + '</font>';
	}else
	{
		mc.info_content.last_login_time_txt.htmlText = GetTimeText(data.last_login);
	}
	if (data.is_defend)
	{
		mc.info_content.is_defend_txt.text = LoaclTexts.DefendTrue;
	}else
	{
		mc.info_content.is_defend_txt.text = LoaclTexts.DefendFalse;
	}
	SetDuty(mc.info_content.duty_content, data);

	if (OwnData.player_id == MemberDatas[index_item].player_id)
	{
		/*mc.info_content.item_my_bg_btn._visible 	= true;
		mc.info_content.item_bg_btn._visible 		= false;*/
		mc.info_content.item_bg_btn.gotoAndStop(2);
	}else
	{
		/*mc.info_content.item_my_bg_btn._visible 	= false;
		mc.info_content.item_bg_btn._visible 		= true;*/
		mc.info_content.item_bg_btn.gotoAndStop(1);
	}

}

function SetHandleItemRelease(mc, index_item, isPlayAni)
{
	mc.OnSetBaseInfo = function()
	{
		SetMemberBaseInfo(this, this.Index);
	}

	mc.OnPlayInOver = function()
	{
		//dont have chat function
		this.item_content.chat_btn._visible = false;

		this.item_content.mail_btn._visible = true;
		this.item_content.fire_btn._visible = true;
        this.item_content.up_btn._visible = false;
        this.item_content.down_btn._visible = false;
		this.item_content.item_bg_btn._visible = true;
		this.info_content.item_bg_btn._visible = false;
		var data = MemberDatas[this.Index];
		mc.item_content.name_txt.text = data.name;
		this.item_content.item_bg_btn.onPress = function()
		{
			this._parent._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
		this.item_content.item_bg_btn.onReleaseOutside = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
		}

		this.item_content.item_bg_btn.onRelease = function()
		{
			this._parent._parent._parent.onReleasedInListbox();
			var itemMc = this._parent._parent;
			var data = MemberDatas[itemMc.Index];
			if (OwnData.player_id == data.player_id)
			{
				return;
			}
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				itemMc.gotoAndPlay("show_info_ani");
				itemMc._parent.ItemIndex = undefined;
				itemMc._parent.ClickedItem = undefined;
				SetInfoItemRelease(itemMc, itemMc.Index, true);
			}
		}
		if (OwnData.player_id != data.player_id)
		{
			/**********************chat_btn************************/
			this.item_content.chat_btn.onPress = function()
			{
				this._parent._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}
			this.item_content.chat_btn.onReleaseOutside = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
			}

			this.item_content.chat_btn.onRelease = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					//TODO:
					trace("-----------chat_btn------------");
				}
			}
			/***********************mail_btn***********************/
			this.item_content.mail_btn.onPress = function()
			{
				this._parent._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}
			this.item_content.mail_btn.onReleaseOutside = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
			}

			this.item_content.mail_btn.onRelease = function()
			{
				this._parent._parent._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					//TODO:
					var id = MemberDatas[this._parent._parent.Index].player_id;
					fscommand("AllianceMainCmd", "SendMail" + "\2" + id);
					trace("----------mail_btn------------");
				}
			}
			/********************fire_btn*******************/
			if (OwnData.post > data.post)
			{
				this.item_content.fire_btn._visible =true;
				this.item_content.fire_btn.onPress = function()
				{
					this._parent._parent._parent.onPressedInListbox();
					this.Press_x = _root._xmouse;
					this.Press_y = _root._ymouse;
				}
				this.item_content.fire_btn.onReleaseOutside = function()
				{
					this._parent._parent._parent.onReleasedInListbox();
				}

				this.item_content.fire_btn.onRelease = function()
				{
					this._parent._parent._parent.onReleasedInListbox();
					if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
					{
						var id = MemberDatas[this._parent._parent.Index].player_id;
						fscommand("AllianceMainCmd", "KickMember" + "\2" + id);
					}
				}
			}else
			{
				this.item_content.fire_btn._visible =false;
			}
			/********************rise_btn*******************/
			if (OwnData.post == 5)
            {
				if (data.post == 4)
				{
                    // this.item_content.rise_btn.gotoAndStop(1);
                    this.item_content.down_btn._visible = true;
                    this.item_content.down_btn.gotoAndStop(1);
				}else if(data.post <= 3)
				{
                    // this.item_content.rise_btn.gotoAndStop(2);
                    this.item_content.up_btn._visible = true;
                    this.item_content.up_btn.gotoAndStop(2);
				}
                this.item_content.up_btn.onPress = this.item_content.down_btn.onPress = function()
				{
					this._parent._parent._parent.onPressedInListbox();
					this.Press_x = _root._xmouse;
					this.Press_y = _root._ymouse;
				}
                this.item_content.up_btn.onReleaseOutside = this.item_content.down_btn.onReleaseOutside = function()
				{
					this._parent._parent._parent.onReleasedInListbox();
				}

                this.item_content.up_btn.onRelease = this.item_content.down_btn.onRelease = function()
				{
					this._parent._parent._parent.onReleasedInListbox();
					if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
					{
						var id = MemberDatas[this._parent._parent.Index].player_id;
						fscommand("AllianceMainCmd", "RisePost" + "\2" + id);
					}
				}
			}else
			{
                this.item_content.up_btn._visible = false;
                this.item_content.down_btn._visible = false;
			}
		}
	}
	
	if (not isPlayAni)
	{
		mc.OnPlayInOver();
	}
}

function UpdateApplyRedPoint(point_num)
{
	if (point_num > 0)
	{
		MemberTabRedPoint._visible 		= true;
		MemberTabRedPoint.num_txt.text = point_num;
		MemberApplyRedPoint._visible 	= true;
	}else
	{
		MemberTabRedPoint._visible 		= false;
		MemberApplyRedPoint._visible 	= false;
	}
	
}

function UpdateMemberPanel(data)
{
	if (data == undefined)
	{
		return;
	}
	if(data.all.length > MemberDatas.length)
	{
		for(var i = MemberDatas.length; i < data.all.length; i++)
		{
			MemberList.addListItem(i + 1, false, false);	
		}
	}else if(data.all.length < MemberDatas.length)
	{
		for(var i = data.all.length; i < MemberDatas.length; i++)
		{
			MemberList.eraseItem(i + 1);	
		}
	}
	OwnData 	= data.own;
	MemberDatas = data.all;
	MemberList.ItemIndex = undefined;
	MemberList.ClickedItem = undefined;
	MemberList.needUpdateVisibleItem();
}



function KickMemberUpdate(data)
{
	if (data == undefined)
	{
		return;
	}
	if(data.all.length > MemberDatas.length)
	{
		for(var i = MemberDatas.length; i < data.all.length; i++)
		{
			MemberList.addListItem(i + 1, false, false);	
		}
	}else if(data.all.length < MemberDatas.length)
	{
		for(var i = data.all.length; i < MemberDatas.length; i++)
		{
			MemberList.eraseItem(i + 1);	
		}
	}
	OwnData 	= data.own;
	MemberDatas = data.all;
	MemberList.ItemIndex = undefined;
	MemberList.ClickedItem = undefined;

	MemberList.needUpdateVisibleItem();
}

/**********************************************/
/******************驻守显示*********************/
/**********************************************/
//string.gsub()


var MyDefenderBtn 	= DefendPanel.my_hire_btn;
var AllDefenderBtn 	= DefendPanel.all_hire_btn;

var MyDefenderContent 	= DefendPanel.my_defender_list;
var MyDefenderNumText 	= MyDefenderContent.defend_info.LC_UI_Alliance_Garrison_Number;
var MyDefenderHelpBtn 	= MyDefenderContent.defend_info.help_btn;
var MyDefenderList 		= MyDefenderContent.list_content.view_list;


var AllDefenderContent	= DefendPanel.all_defender_list;
var AllDefenderList 	= AllDefenderContent.list_content.view_list;

var MyDefenderDatas		= undefined;
var AllDefenderDatas 	= undefined;
var OwnDefenderCout 	= 0;
//var DefenderDatas 		= undefined;

var DefenderCurPanel 	= undefined;

MyDefenderBtn.onRelease = AllDefenderBtn.onRelease = function()
{
	SwitchDefenderPanel(this);
}

MyDefenderHelpBtn.onRelease = function()
{
	//TODO:
	trace("------------Click MyDefenderHelpBtn----------");
	fscommand("AllianceMainCmd", "ShowHelpInfo" + "\2" + "defend");
}

function InitDefendPanel()
{

	/*MyDefenderDatas 	= new Array(20);
	AllDefenderDatas 	= new Array(18);
	for(var i = 0; i < 18; ++i)
	{
		AllDefenderDatas[i] = 1;
	}
	InitMyDefenderList();
	InitAllDefenderList();*/
	SwitchDefenderPanel(MyDefenderBtn);
}


function SwitchDefenderPanel(btn)
{
	var strName = btn._name;
	switch(strName)
	{
		case MyDefenderBtn._name:
			MyDefenderBtn.gotoAndStop(2);
			AllDefenderBtn.gotoAndStop(1);
			MyDefenderContent._visible = true;
			AllDefenderContent._visible = false;

		break;
		case AllDefenderBtn._name:
			MyDefenderBtn.gotoAndStop(1);
			AllDefenderBtn.gotoAndStop(2);
			MyDefenderContent._visible = false;
			AllDefenderContent._visible = true;
		break;
		default:
			trace("Dont find this btn!");
		break;
	}
}
/************************MyDefenderList*************************/
function InitMyDefenderList()
{
	if (MyDefenderDatas == undefined)
	{
		return;
	}
	MyDefenderList.clearListBox();
	MyDefenderList.initListBox("list_defend_item2",0,true,true);
	MyDefenderList.enableDrag( true );
	MyDefenderList.onEnterFrame = function(){
		this.OnUpdate();
	}

	MyDefenderList.onItemEnter = function(mc,index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetMyDefenderItemInfo(mc, index_item);
	}
	MyDefenderList.onItemMCCreate = undefined;
	MyDefenderList.onListboxMove = undefined;

	for( var i = 1; i <= OwnDefenderCout; i++ )
	{   
	    var temp = MyDefenderList.addListItem(i, false, false);
	}
}

function SetMyDefenderItemInfo(mc, index_item)
{
	var datas = MyDefenderDatas[index_item];
	mc.Data = datas;
	if (datas == undefined)
	{
		mc.gotoAndStop(2);
		SetNotDefendInfo(mc, datas);
	}else
	{
		mc.gotoAndStop(1);
		SetAlreadyDefendInfo(mc, datas);
	}
}

function SetAlreadyDefendInfo(mc, datas)
{	
    mc.hero_head.level_info.level_text.text = "Lv." + datas.hero_level;
    mc.hero_head.star.gotoAndStop(datas.hero_star);
	mc.income_txt.text = datas.income;
	mc.time_txt.text = GetTimeText(datas.time);
	mc.hero_head.head_info._visible = false;
	if (mc.hero_head.item_icon.icons == undefined)
	{
		mc.hero_head.item_icon.loadMovie("CommonHeros.swf");
	}

	mc.hero_head.item_icon.IconData = datas.icon_data;
	if(mc.hero_head.item_icon.UpdateIcon)
	{ 
		mc.hero_head.item_icon.UpdateIcon(); 
	}
	SelectIconBtn.onRelease = IconMc.item_icon.onRelease = function()
	{
		fscommand("AllianceCommand","OpenSelectIconUI")
	}

	mc.back_btn.onRelease = function()
	{
		this._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			
			var hero_id = this._parent.Data.hero_id;
			fscommand("AllianceMainCmd","RecallDefender" + "\2" + hero_id);
		}
		
	}
	mc.back_btn.onPress = function()
	{
		this._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}

	mc.back_btn.onReleaseOutside = function()
	{
		this._parent._parent.onReleasedInListbox();
	}
}


function SetNotDefendInfo(mc, datas)
{

	mc.add_btn.onRelease = function()
	{
		this._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			//fscommand("AllianceMainCmd","AddDefender" + "\2" + hero_id);
			fscommand("GoToNext", "GoToSelectHero");
		}
		
	}
	mc.add_btn.onPress = function()
	{
		this._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}

	mc.add_btn.onReleaseOutside = function()
	{
		this._parent._parent.onReleasedInListbox();
    }
    mc._SLAC_Defend_Help_Content.text = defendDescText;
}

/************************AllDefenderList*************************/
var defendDescText = ""
function InitAllDefenderList()
{		
	if (AllDefenderDatas == undefined)
	{
		return;
	}
	AllDefenderList.clearListBox();
	AllDefenderList.initListBox("list_defend_item1",0,true,true);
	AllDefenderList.enableDrag( true );
	AllDefenderList.onEnterFrame = function(){
		this.OnUpdate();
	}

	AllDefenderList.onItemEnter = function(mc,index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetAllDefenderItemInfo(mc, index_item);
	}
	AllDefenderList.onItemMCCreate = undefined;
	AllDefenderList.onListboxMove = undefined;

	var line = Math.ceil(AllDefenderDatas.length / 4);

	for( var i = 1; i <= line; i++ )
	{   
	    var temp = AllDefenderList.addListItem(i, false, false);
	}
}

function SetAllDefenderItemInfo(mc, index_item)
{
	var datas = undefined;
    for(var i = 0; i < 5; i++)
	{
        var nIndex = (index_item * 5) + i;
		datas = AllDefenderDatas[nIndex];
		var headMc = mc["head" + i];
		if (datas != undefined)
		{
			headMc._visible = true;
			headMc.nIndex = nIndex;
			headMc.name_bar.txt_Name.text = datas.player_name;
			var headInfoMc = headMc.button_icon.hero_head;
            headInfoMc.level_info.level_text.text = datas.hero_level;
            headInfoMc.star.gotoAndStop(datas.hero_star);

			if (headInfoMc.item_icon.icons == undefined)
			{
				headInfoMc.item_icon.loadMovie("CommonHeros.swf");
			}

			headInfoMc.item_icon.IconData = datas.icon_data;
			if(headInfoMc.item_icon.UpdateIcon)
			{ 
				headInfoMc.item_icon.UpdateIcon(); 
			}

			headMc.onRelease = function()
			{
				this._parent._parent.onReleasedInListbox();
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					//TODO:
					trace("-------Click Head---------" + this.nIndex);
				}
			}
			headMc.onPress = function()
			{
				this._parent._parent.onPressedInListbox();
				this.Press_x = _root._xmouse;
				this.Press_y = _root._ymouse;
			}

			headMc.onReleaseOutside = function()
			{
				this._parent._parent.onReleasedInListbox();
			}
		}else
		{
			headMc._visible = false;
		}
	}
		
}

function SetDefendText(data)
{
     defendDescText = data;
}

function UpdateDefendPanel(data)
{
	if (data == undefined)
	{
		return;
	}
	UpdateDefendOwnPanel(data)
	UpdateDefendAllPanel(data)
}

function UpdateDefendOwnPanel(data)
{
	if (data == undefined)
	{
		return;
	}
	MyDefenderNumText.text = data.InfoText;
	OwnDefenderCout = data.Count;
	MyDefenderDatas = data.Own;
	InitMyDefenderList();
}

function UpdateDefendAllPanel(data)
{
	if (data == undefined)
	{
		return;
	}
	AllDefenderDatas = data.All;
	InitAllDefenderList();
}

/**********************************************/
/******************任务显示*********************/
/**********************************************/


var TaskList = TaskPanel.view_list;

var TaskDatas = undefined;

var TaskRedpoint = MainTitle.filter_button_4.task_tips;

var AwardBtns = new Array();

var ActiveProgressBar = TaskPanel.awards.progress_bar;

function InitTaskPanel(datas)
{
	TaskDatas = datas;

	if (datas.RedPoint <= 0)
	{
		TaskRedpoint._visible = false;
	}else
	{
		TaskRedpoint._visible = true;
		TaskRedpoint.num_txt.text = datas.RedPoint;
	}

	UpdateAwardBtnsState();

	InitTaskList();

	/*for(var i = 1; i <= 4; i++)
	{
		var award = new Object();
		award.need_active = 100 * (i + 50);
		award.state = 2;    //1:cant open  2:can open 3:already open
		AwardBtns.push(award);
	}
	UpdateAwardBtnsState();
	TaskDatas = new Array(20);
	InitTaskList();*/
	//UpdateAwardBtnsState();
}

function UpdateAwardBtnsState()
{
	var max_active = 0;
	for(var i in TaskDatas.ActivityAwards)
	{
		var award = TaskDatas.ActivityAwards[i];
		var btn = TaskPanel.awards["award" + i + "_btn"];
		if (btn != undefined)
		{
			btn.gotoAndStop(award.state);	
			btn.award = award;
			if (award.state == 2)  //can open
			{
				btn.onRelease = function()
				{
					fscommand("AllianceMainCmd", "GetActivityAward" + "\2" + this.award.need_active);
				}
			}else
			{
				btn.onRelease = function()
				{
					fscommand("AllianceMainCmd", "ShowActiveAwards" + "\2" + this.award.need_active);
				}
			}
			var bound = TaskPanel.awards["bound" + i];
			bound.text = award.need_active;
			if (award.need_active > max_active)
			{
				max_active = award.need_active;
			}
		}
	}
	SetProgressBar(ActiveProgressBar, TaskDatas.active / max_active);  //TODO: 300
}


function InitTaskList(  )
{
	
	if (TaskDatas.TaskInfos == undefined)
	{
		return;
	}
	TaskList.clearListBox();
	TaskList.initListBox("task_list_all", 0, true, true);
	TaskList.enableDrag(true);
	TaskList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	TaskList.onItemEnter = function(mc, index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetTaskItemInfo(mc, index_item);
	}
	TaskList.onListboxMove = undefined;
	TaskList.onItemMCCreate = undefined;
	TaskList.onItemLeave = undefined;

	for (var i = 1 ; i <= TaskDatas.TaskInfos.length; ++i)
	{
		TaskList.addListItem(i, false, false);
	}

}



function SetTaskItemInfo(mc, index_item)
{
	var	datas = TaskDatas.TaskInfos[index_item];
	/*****test*****/
/*	datas = new Object();
	datas.state = 2;
	datas.AwardList = new Array();
	datas.AwardList[0] = new Object();
	datas.AwardList[0].icon_data = undefined;
	datas.AwardList[0].count 	 = 10;
	datas.curProgress = 1;
	datas.ProgressCount = 5;*/
	/*************/
	if (datas == undefined)
	{
		return;
	}
	mc.item_icons.gotoAndStop("normal");
	//mc.item_icons.gotoAndStop("locked");


	mc.item_process.gotoAndStop(datas.state + 1);
	mc.item_process.process_num_txt.text = datas.cur_progress + "/" + datas.progress_count;
    mc.item_process.process_name_txt.text = datas.title;
    if (mc.item_process.process_name_txt.textWidth > mc.item_process.process_name_txt._width)
    {
        mc.item_process.process_num_txt._x = mc.item_process.process_name_txt._x + mc.item_process.process_name_txt.textWidth + 5
    }
	
	mc.task_desc_txt.text = datas.desc;

	if (datas.award_list != undefined)
	{
		var len = datas.award_list.length;
		var place = 0;
		var nIndex = 1;
		for (var i = 0; i < 3; ++i)
		{
			
			//activity icon at fisrt position
			if (datas.award_list[i].id == 'alliance_active')
			{
				place = 0;
			}else
			{
				place = nIndex++;
			}

			var award_mc = mc["award_" + place];
			if (place > (len - 1))
			{
				award_mc._visible = false;
				//break;
			}else
			{
				award_mc._visible = true;
				award_mc.num_text.text = "x" + datas.award_list[i].count;

				if (award_mc.item_icon.icons == undefined)
				{
					var w = award_mc.item_icon._width;
					var h = award_mc.item_icon._height;
					award_mc.item_icon.loadMovie("CommonIcons.swf");
					award_mc.item_icon._width = w;
					award_mc.item_icon._height = h;
				}
				award_mc.item_icon.IconData = datas.award_list[i].icon_data;
				if(award_mc.item_icon.UpdateIcon)
				{ 
					award_mc.item_icon.UpdateIcon(); 
				}
			}
			
			
		}
	}
	mc.datas = datas;

	var cur_btn = undefined;
	if (datas.state == 1)
	{
        mc.task_button.gotoAndStop(1);
        mc.bg.gotoAndStop(1);
		cur_btn = mc.task_button.award_btn;
	}else
	{
        mc.task_button.gotoAndStop(2);
        mc.bg.gotoAndStop(2);
		cur_btn = mc.task_button.goto_btn;
	}

	cur_btn.onRelease = function()
	{
		this._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			var data = this._parent._parent.datas;
			if (data.state == 1)
			{
				fscommand("AllianceMainCmd", "GetAllianceTaskAward" + "\2" + data.id)
			}else
			{
				fscommand("AllianceMainCmd", "JumpTo" + "\2" + data.id)
			}
		}
	}

	cur_btn.onPress = function()
	{
		this._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}

	cur_btn.onReleaseOutside = function()
	{
		this._parent._parent.onReleasedInListbox();
	}
}

function UpdateMoneyAndCredit(datas)
{
    TopUI.money.money_text.text = datas.money;
    TopUI.credit.credit_text.text = datas.credit;
}

function UpdateEnergy(point)
{
    var energyBtn = TopUI.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}




/*****************War Panel***********************/

var WarStateInfo 	= WarPanel.prewar_info;
var TroopsInfo 	 	= WarPanel.troops_info;
var AddTroops 	 	= WarPanel.add_troop;
var TroopsContent	= WarPanel.list_content;
var GoToWar 	 	= WarPanel.go_war;
var TroopsList 		= WarPanel.list_content.list;
var Milliseconds 	= 0;
var PreWarCountDown = 5000;
var CurState 		= "normal"
var WarTexts 		= undefined;

var TroopsDatas 	= undefined;

function InitWarPanel(datas)
{
	trace("---------state=" + datas.war_info.state)
	trace("---------datas=" + datas.fleets);
	CurState = datas.war_info.state;
	TroopsDatas = datas.fleets;
	WarTexts = datas.texts;
	PreWarCountDown = datas.count_down;
	ShowWarByState(CurState);
}

// normal prewar war
function ShowWarByState(state)
{
	if (state == "normal")
	{
		WarStateInfo._visible = false;
		TroopsInfo._visible = true;
		AddTroops._visible = true;
		TroopsList._visible = true;
		GoToWar._visible = false;
		InitNormalShow();
	}else if (state == "prewar")
	{
		WarStateInfo._visible = true;
		TroopsInfo._visible = false;
		AddTroops._visible = true;
		TroopsList._visible = true;
		GoToWar._visible = false;
		InitPreWarShow();
		trace("222222222222222")
	}else if (state == "war")
	{
		WarStateInfo._visible = true;
		TroopsInfo._visible = false;
		AddTroops._visible = false;
		TroopsList._visible = false;
		GoToWar._visible = true;
		InitWarShow();
	}
}


function InitNormalShow()
{
	SetTroopsInfo();
	SetAddTroops();
	SetTroopsList();
}

function InitPreWarShow()
{
	SetPreWarInfo();
	SetAddTroops();
	SetTroopsList();
}

function InitWarShow()
{
	SetWarInfo();
}

function SetTroopsInfo()
{
	TroopsInfo.troops_num_txt.text = LoaclTexts.WarFleetNumText + " " + TroopsDatas.length;
	TroopsInfo.declare_info_btn.onRelease = function()
	{
		fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_PLANETWAR_DISPATCH_TITLE" + "\2" + "LC_RULE_RULE_PLANETWAR_DISPATCH_DESC");
	}
}

function SetWarInfo()
{
	Milliseconds = 0;
	//WarStateInfo.onEnterFrame = undefined;
	WarStateInfo.troops_num_txt._visible = false;
	WarStateInfo.prewar_tips_btn.onRelease = function()
	{
		fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_PLANETWAR_DISPATCH_TITLE" + "\2" + "LC_RULE_RULE_PLANETWAR_DISPATCH_DESC");
	}
	WarStateInfo.prewar_countdown_txt.text = WarTexts.WarGoingText;
	GoToWar.go_btn.onRelease = function()
	{
		fscommand("AllianceMainCmd", "GoToWar");
	}
}

function SetPreWarInfo()
{
	WarStateInfo.troops_num_txt.text = LoaclTexts.WarFleetNumText + " " + TroopsDatas.length;
	WarStateInfo.prewar_tips_btn.onRelease = function()
	{
		fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_PLANETWAR_DISPATCH_TITLE" + "\2" + "LC_RULE_RULE_PLANETWAR_DISPATCH_DESC");
	}
	WarStateInfo.prewar_countdown_txt.text = WarTexts.WarCountDownText + GetCountDownText(PreWarCountDown) + ".";
	
}

function GetCountDownText(time)
{
	if (time == undefined)
	{
		return;
	}
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

function SetAddTroops()
{
	AddTroops.add_btn.onRelease = function()
	{
		fscommand("AllianceMainCmd", "SelectTroop");
	}
}

function SetTroopsList()
{
	if (TroopsDatas == undefined)
	{
		return;
	}
	TroopsList.clearListBox();
	TroopsList.initListBox("list_war_item", 0, true, true);
	TroopsList.enableDrag(true);
	TroopsList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	TroopsList.onItemEnter = function(mc, index_item)
	{
		index_item = index_item - 1;
		SetItemInfo(mc, TroopsDatas[index_item]);
	}

	TroopsList.onItemMCCreate 	= undefined;
	TroopsList.onListboxMove 	= undefined;
	TroopsList.onItemLeave 		= undefined;
	for (var i = 1; i <= TroopsDatas.length; ++i)
	{
		TroopsList.addListItem(i, false, false);
	}
}

function SetItemInfo(mc, data)
{
	SetPlayerIcon(mc.hero_head, data.player_icon, data.player_level);
	
	
	for(var i = 1; i <= data.hero_info.length; ++i)
	{
		SetHeroInfo(mc["hero" + i], data.hero_info[i - 1]);
	}
	mc.name_txt.text = data.player_name
	mc.fleet_id = data.fleet_id;
	mc.player_id = data.player_id;

	mc.power_txt.html = true;
	if(data.can_recall)
	{
		mc.power_txt.htmlText = "<font color='#43C859'>" + LoaclTexts.WarFleetPowerText + " " + data.force + "</font>";
		mc.back_btn._visible = true;
		mc.back_btn.onRelease = function()
		{
			fscommand("AllianceMainCmd", "RecallFleet\2" + this._parent.fleet_id);
		}
	}else
	{
		mc.power_txt.htmlText = "<font color='#FFFFFF'>" + LoaclTexts.WarFleetPowerText + " " + data.force + "</font>";
		mc.back_btn._visible = false;
	}
}

function SetPlayerIcon(mc, playerIcon, level)
{
	var head_width=mc.user_head._width
	var head_height=mc.user_head._height
	var head_icon
	if(mc.user_head.icons == undefined)
	{
		head_icon = mc.user_head.loadMovie("CommonPlayerIcons.swf");
		head_icon._width = head_width
		head_icon._height = head_height
	}

	mc.user_head.IconData = playerIcon;
	if (mc.user_head.UpdateIcon)
	{
		mc.user_head.UpdateIcon()
	}
	mc.level_info.level_text.text = "Lv" + level;
}

function SetHeroInfo(mc, hero_info)
{
	SetHeroIcon(mc, hero_info.icon_data);
	SetHeroStar(mc, hero_info.star);
}

function SetHeroIcon(mc, icon_data)
{
	if (mc.icon.icons == undefined)
	{
		var h = mc.icon._height;
		var w = mc.icon._width;
		mc.icon.loadMovie("CommonHeros.swf");
		mc.icon._height = h;
		mc.icon._width  = w;
	}

	mc.icon.IconData = icon_data;
	if(mc.icon.UpdateIcon)
	{ 
		mc.icon.UpdateIcon(); 
	}
}

function SetHeroStar(mc, star)
{
	mc.star.gotoAndStop(star);
}

function RefreshFleetsList( datas )
{
	if(datas.length > TroopsDatas.length)
	{
		for(var i = TroopsDatas.length; i < datas.length; i++)
		{
			TroopsList.addListItem(i + 1, false, false);	
		}
	}else if(datas.length < TroopsDatas.length)
	{
		for(var i = datas.length; i < TroopsDatas.length; i++)
		{
			TroopsList.eraseItem(i + 1);
		}
	}
	TroopsDatas = datas;
	if (CurState == "normal" )
	{
		TroopsInfo.troops_num_txt.text = TroopsDatas.length;
	}
	if( CurState == "prewar")
	{
		WarStateInfo.troops_num_txt.text = TroopsDatas.length;
	}
	TroopsList.needUpdateVisibleItem();
}

/************************Planet************************/
var WaitPanel 	= PlanetPanel.wait_content;
var GetPanel 	= PlanetPanel.get_content;

var CurPanel 	= undefined;

var PlanetList 	= PlanetPanel.list;
var GetAwardCountDown = 0;

var PlanetDatas = new Array(20);

function InitPlanetPanel(  datas)
{
	PlanetPanel.info.planet_num_txt.text = datas.planet_num_txt;
	if (datas.can_get)
	{
		SetPanelShow("get_panel");	
		GetAwardCountDown = datas.left_time;
	}else
	{
		SetPanelShow("wait_panel");
		GetAwardCountDown = 0;
	}
	PlanetDatas = datas.all_planet_info
	InitPlanetList();
	SetTimeNum(CurPanel.hour, datas.get_time_hour);
	SetTimeNum(CurPanel.min, datas.get_time_min);
	
	SetAwardInfo(datas);
}

function SetAwardInfo(datas)
{
	for(var i = 1; i <= 4; ++i)
	{
		var num1 = datas.all_award["award" + i];
		if (num1 <= 0)
		{
			CurPanel.all_awards["award" + i].num._visible = false;
		}else
		{
			CurPanel.all_awards["award" + i].num._visible = true;
		}
		CurPanel.all_awards["award" + i].num.num_txt.text = num1;
		if (datas.can_get)
		{
			var num2 = datas.mine_award["award" + i];
			if (num2 <= 0)
			{
				CurPanel.mine_awards["award" + i].num._visible = false;
			}else
			{
				CurPanel.mine_awards["award" + i].num._visible = true;
			}
			CurPanel.mine_awards["award" + i].num.num_txt.text = num2;
		}
	}
}

function SetPanelShow(panel)
{
	if (panel == "wait_panel")
	{
		WaitPanel._visible = true;
		GetPanel._visible = false;
		CurPanel = WaitPanel;
	}else if (panel == "get_panel")
	{
		WaitPanel._visible = false;
		GetPanel._visible = true;
		CurPanel = GetPanel;
	}
	CurPanel.panel_name = panel
	WaitPanel.claim_btn.onRelease = function()
	{
		fscommand("AllianceMainCmd", "GetPlanetAward\2" + "0")
	}
	GetPanel.claim_btn.onRelease = function()
	{
		fscommand("AllianceMainCmd", "GetPlanetAward\2" + "1")
	}

}

//planet_name
//level
//award1 -- 4
function InitPlanetList()
{
	if (PlanetDatas == undefined)
	{
		return;
	}
	PlanetList.clearListBox();
	PlanetList.initListBox("PlanetBar", 0, true, true);
	PlanetList.enableDrag(true);
	PlanetList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	PlanetList.onItemEnter = function(mc, index_item)
	{
		index_item = index_item - 1;
		SetPlanetAwardInfo(mc, PlanetDatas[index_item]);
	}

	PlanetList.onItemMCCreate 	= undefined;
	PlanetList.onListboxMove 	= undefined;
	PlanetList.onItemLeave 		= undefined;
	for (var i = 1; i <= PlanetDatas.length; ++i)
	{
		PlanetList.addListItem(i, false, false);
	}
}

function SetPlanetAwardInfo(mc, data)
{
	mc.name.name_txt.text = data.planet_name;
	mc.level_txt.text = data.planet_level;
	for(var i = 1; i <= 4; ++i)
	{
		mc["num" + i].num_txt.text = data["award" + i];
	}
}

function SetTimeNum(mc, num)
{
	mc.num1.gotoAndStop(Math.floor(num / 10) + 1)
	mc.num2.gotoAndStop((num % 10) + 1)
}


function FormatTimeTxt(val)
{
	if (val < 10)
	{
		val = "0" + val;
	}
	return val;
}

function GetAwardTimeText(time)
{
	if (time == undefined)
	{
		return;
	}
	var seconed = FormatTimeTxt(time % 60);

	time = Math.floor(time / 60);

	var minutes = FormatTimeTxt(time % 60);
	time = Math.floor(time / 60);

	var hour = FormatTimeTxt(time);

	return hour + ":" + minutes + ":" + seconed;
}

_root.onEnterFrame = function()
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
		
		if (PreWarCountDown > 0)
		{
			PreWarCountDown -= 1;
			WarStateInfo.prewar_countdown_txt.text = WarTexts.WarCountDownText + GetCountDownText(PreWarCountDown) + ".";
		}
		if (GetAwardCountDown > 0)
		{
			GetAwardCountDown -= 1;
			CurPanel.time_txt.text = GetAwardTimeText(GetAwardCountDown)
		}
	}
}