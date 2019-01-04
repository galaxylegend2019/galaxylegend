import common.CTextAutoSizeTool;
var MainUI 	= _root.main_ui;
var TopUI 	= MainUI.top_ui;

var CloseBtn = TopUI.btn_close;

// var EliteBtn 		= MainUI.elite;
// var ArenaBtn 		= MainUI.arena;
// var ExpeditionBtn 	= MainUI.expedition;

var g_challengeBtnOrder = ["elite", "arena", "expedition", "blackhole", "mechtrial"];
var g_challengeCmdOrder = ["Elite", "Arena", "Expedition", "BlackHole", "MechTrial"];
var g_challengeMCOrder = [undefined, undefined, undefined, undefined, undefined];

var g_challengeDatas = undefined;

var g_curPopType = undefined;

var g_mechTrialDatas = undefined;
var g_mechTrialType = undefined;

var g_blackHoleDatas = undefined;
var g_blackHoleType = undefined;

_root.onLoad = function()
{
	InitUI();
}

function InitUI()
{
	//RefreshUIInfo();
	MainUI.popup_logout._visible = false;
	MainUI.pop_trial_info._visible = false;
	MainUI.pop_trial_difficulty._visible = false;
	MainUI.pop_trial._visible = false;
	MainUI.pop_blackhole._visible = false;
	MainUI.pop_challenge._visible = false;

	// OpenUI();
	// OpenMechTrail();
}

function OpenUI(now)
{
	if(now)
	{
		TopUI.gotoAndStop("moved_in");
		MainUI.gotoAndStop("moved_in");
	}
	else
	{
		TopUI.gotoAndPlay("opening_ani");
		// EliteBtn.content.gotoAndPlay("opening_ani");
		// ArenaBtn.content.gotoAndPlay("opening_ani");
		// ExpeditionBtn.content.gotoAndPlay("opening_ani");
		MainUI.gotoAndPlay("opening_ani");
	}
	MainUI.pop_challenge._visible = true;

	var listView = MainUI.pop_challenge.list_content;
	listView.clearListBox();
	listView.initListBox("challenge_contents",0,false,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc, index_item)
	{
		g_challengeMCOrder[index_item] = mc
		mc.gotoAndStop(index_item + 1);
		mc.my_dataIndex = g_challengeBtnOrder[index_item];
		mc.my_cmd = g_challengeCmdOrder[index_item];

		// trace("index_item: "  + index_item);
		if(g_challengeDatas)
		{
			// trace("mc.my_dataIndex: "  + mc.my_dataIndex + "  " + index_item);
			SetChallengeInfo(mc.content, g_challengeDatas[mc.my_dataIndex]);
		}
		mc.my_index = index_item;

		mc.onPress = function()
		{
			this._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
		mc.onReleaseOutside = function()
		{
			this._parent.onReleasedInListbox();
		}
		mc.onRelease = function(isFTE)
		{
			this._parent.onReleasedInListbox();
			if(isFTE or (Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10))
			{
				// trace("ChallengeCommand: " + this.my_cmd);
				fscommand("ChallengeCommand", this.my_cmd);
			}
		}

		CloseBtn.onRelease = function()
		{
			CloseUI(true);
		}
	}

	for( var i = 0; i < 4; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}


function CloseUI( is_exit )
{
	TopUI.gotoAndPlay("closing_ani");
	// EliteBtn.content.gotoAndPlay("closing_ani");
	// ArenaBtn.content.gotoAndPlay("closing_ani");
	// ExpeditionBtn.content.gotoAndPlay("closing_ani");
	MainUI.gotoAndPlay("closing_ani");
	if (is_exit)
	{
		TopUI.OnMoveOutOver = function()
		{
			fscommand("ChallengeCommand", "CloseUI");
		}
	}else
	{
		TopUI.OnMoveOutOver = undefined;
	}
	
}

function OpenChanllengeUI()
{
	MainUI.pop_challenge._visible = true;
	CloseBtn.onRelease = function()
	{
		CloseUI(true);
	}
}

function CloseChallengeUI()
{
	MainUI.pop_challenge._visible = false;
}

var flag = false;
// CloseBtn.onRelease = function()
// {
// 	CloseUI(true);
// }

// EliteBtn.onRelease = function()
// {
// 	fscommand("ChallengeCommand", "Elite");
// }

// ArenaBtn.onRelease = function()
// {
// 	fscommand("ChallengeCommand", "Arena");
// }

// ExpeditionBtn.onRelease = function()
// {
// 	fscommand("ChallengeCommand", "Expedition");
// }

//datas.elite -- type:1 or 2 flash frame, is_open, cur_times, max_times: only type 2, info_txt
//datas.arena
//datas.expedition
function RefreshUIInfo( datas )
{
	// SetChallengeInfo(EliteBtn.content, datas.elite);
	// SetChallengeInfo(ArenaBtn.content, datas.arena);
	// SetChallengeInfo(ExpeditionBtn.content, datas.expedition);
	var listView = MainUI.pop_challenge.list_content
	g_challengeDatas = datas;
	listView.needUpdateItemData = true;

	fscommand("TutorialCommand","Activate" + "\2" + "OpenChanllenge");
}


function SetChallengeInfo(mc, data)
{
	// trace("mc: " + mc + "  data: " + data);
	if (data.is_open)
	{
		// mc.icon.gotoAndStop(1);
		mc.gotoAndStop(1);
		if (data.type == 1)
		{
			mc.content.state_info.gotoAndStop(1);
		}else
		{
			mc.content.state_info.gotoAndStop(2);
			//TODO:Set Progress
			SetProgressNum(mc.content.state_info.progress.cur_num, data.cur_times);
			SetProgressNum(mc.content.state_info.progress.max_num, data.max_times);
		}
		// mc.state_info.info.info_txt.html = true;
		// mc.state_info.info.info_txt.htmlText = data.reset_txt;
		CTextAutoSizeTool.SetSingleLineText(mc.content.state_info.info.info_txt, data.reset_txt, 20, 10);
	}else
	{
		// mc.icon.gotoAndStop(2);
		mc.gotoAndStop(2);
		mc.content.state_info.gotoAndStop(3);
		// mc.state_info.info.info_txt.html = true;
		// mc.state_info.info.info_txt.htmlText = data.unlock_txt;
		CTextAutoSizeTool.SetSingleLineText(mc.content.state_info.info.info_txt, data.unlock_txt, 20, 10);
	}
	

	mc.content.drop.info.drop_txt.html = true;
    mc.content.drop.info.drop_txt.htmlText = data.drop_txt;

    mc.content.title_txt.title_SLAC_.text = data.title_txt
}

function SetProgressNum(mc, num)
{
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

function SetCurPopType(popType)
{
	g_curPopType = popType;
}

function SetChallengeTitleTxt(titleTxt)
{
	TopUI.title_bar.txt_title.text = titleTxt;
}

//MechTrial functions
function SetMechTrialDatas(datas)
{
	g_mechTrialDatas = datas;
	SetMechTrialContent(MainUI.pop_trial.btn_trial_1, datas.aerialTrialData);
	SetMechTrialContent(MainUI.pop_trial.btn_trial_2, datas.armorTrialData);
	SetMechTrialContent(MainUI.pop_trial.btn_trial_3, datas.bioTrialData);
}

function OpenMechTrail(now)
{
	MainUI.pop_trial._visible = true;
	if(now)
	{
		MainUI.pop_trial.gotoAndStop("moved_in");
	}
	else
	{
		MainUI.pop_trial.gotoAndPlay("opening_ani");
	}

	CloseBtn.onRelease = function()
	{
		CloseMechTrial();
		fscommand("ChallengeCommand", "MechTrailClosed");
	}
}

function CloseMechTrial()
{
	// MainUI.pop_trial.OnMoveOutOver = function()
	// {
	// 	this._visible = false;
	//  fscommand("ChallengeCommand", "MechTrailClosed")
	// }
	// MainUI.pop_trial.gotoAndPlay("closing_ani");
	MainUI.pop_trial._visible = false;
}

function SetMechTrialContent(mc, data)
{
	mc.my_trialType = data.trialType;
	if(data.is_open)
	{
		mc.gotoAndStop(1);
		mc.content.state_info.gotoAndStop(1);
		SetProgressNum(mc.content.state_info.progress.cur_num, data.cur_times);
		SetProgressNum(mc.content.state_info.progress.max_num, data.max_times);
	}
	else
	{
		mc.gotoAndStop(2);
		mc.content.state_info.gotoAndStop(3);
		CTextAutoSizeTool.SetSingleLineText(mc.content.state_info.info.info_txt, data.unlock_txt, 20, 10);
	}

	mc.content.drop.info.drop_txt._visible = false;
	// mc.content.drop.info.drop_txt.html = true;
	// mc.content.drop.info.drop_txt.htmlText = data.drop_txt;

	mc.onRelease = function()
	{
		g_mechTrialType = this.my_trialType;
		fscommand("ChallengeCommand", "MechTrialType" + "\2" + this.my_trialType);
	}
}

//BlackHole functions
function SetBlackHoleDatas(datas)
{
	g_blackHoleDatas = datas;
	SetBlackHoleContent(MainUI.pop_blackhole.blackhole_1, datas.type1);
	SetBlackHoleContent(MainUI.pop_blackhole.blackhole_2, datas.type2);
}

function OpenBlackHole(now)
{
	MainUI.pop_blackhole._visible = true;
	if(now)
	{
		MainUI.pop_blackhole.gotoAndStop("moved_in");
	}
	else
	{
		MainUI.pop_blackhole.gotoAndPlay("opening_ani");
	}

	CloseBtn.onRelease = function()
	{
		CloseBlackHole();
		fscommand("ChallengeCommand", "BlackHoleClosed");
	}
}

function CloseBlackHole()
{
	MainUI.pop_blackhole._visible = false;
}

function SetBlackHoleContent(mc, data)
{
	mc.my_holeType = data.holeType;
	if(data.is_open)
	{
		mc.isCD = data.isCD;
		if(data.isCD && data.chanceLeft > 0)
		{
			mc.gotoAndStop(1);
			mc.content.state_info.gotoAndStop(2);
			mc.content.state_info.info_bar.gotoAndStop(1);
			mc.content.state_info.info_bar.time.txt_time.text = data.cdTxt;
			if(data.refreshCredit > 0)
			{
				mc.content.state_info.info_bar.btn_refresh._visible = true;
				CTextAutoSizeTool.SetSingleLineText(mc.content.state_info.info_bar.btn_refresh.txt_credit, data.refreshCredit, 16, 8);
				mc.content.state_info.info_bar.btn_refresh.my_holeType = mc.my_holeType;
				mc.content.state_info.info_bar.btn_refresh.onRelease = function()
				{
					fscommand("ChallengeCommand", "RefreshBlackHole" + "\2" + this.my_holeType);
				}
			}
			else
			{
				mc.content.state_info.info_bar.btn_refresh._visible = false;
			}
		}
		else
		{
			mc.gotoAndStop(1);
			mc.content.state_info.gotoAndStop(1);
			SetProgressNum(mc.content.state_info.progress.cur_num, data.chanceLeft);
			SetProgressNum(mc.content.state_info.progress.max_num, data.max_times);
			CTextAutoSizeTool.SetSingleLineText(mc.content.state_info.info.info_txt, data.closeTxt, 20, 10);
		}
	}
	else
	{
		mc.gotoAndStop(2);
		mc.content.state_info.gotoAndStop(3);
		CTextAutoSizeTool.SetSingleLineText(mc.content.state_info.info_txt, data.unlock_txt, 20, 10);
	}

	// mc.content.drop.info.drop_txt._visible = false;
	mc.content.drop.drop_txt.html = true;
	mc.content.drop.drop_txt.htmlText = data.drop_txt;

	mc.content.btn_icon.my_holeType = data.holeType;
	if(data.is_open && mc.isCD && data.chanceLeft > 0)
	{
		mc.content.btn_icon.clickPlayMC = mc.content.state_info.info_bar;
		mc.content.btn_icon.onRelease = function()
		{
			trace("this.clickPlayMC: " + this.clickPlayMC);
			this.clickPlayMC.gotoAndPlay("click_play");
		}
	}
	else
	{
		mc.content.btn_icon.onRelease = function()
		{
			g_blackHoleType = "type" + this.my_holeType;
			fscommand("ChallengeCommand", "BlackHoleType" + "\2" + this.my_holeType);
		}
	}
}

//common pop mechtrial and blackhole
function ShowCommonDifficulty(now)
{
	TopUI._visible = false;
	MainUI.pop_trial_difficulty._visible = true;
	if(now)
	{
		MainUI.pop_trial_difficulty.gotoAndStop("moved_in");
	}
	else
	{
		MainUI.pop_trial_difficulty.gotoAndPlay("opening_ani");
	}
	MainUI.pop_trial_difficulty.bg_btn._visible = true;
	MainUI.pop_trial_difficulty.bg_btn.onRelease = function()
	{
		HideCommonDifficulty();
		fscommand("ChallengeCommand", "CommonDifficultyClosed");
	}
	var pop_content = MainUI.pop_trial_difficulty.pop_content;
	pop_content.btn_shield._visible = true;
	pop_content.btn_shield.onRelease = function()
	{
	}

	pop_content.btn_info.onRelease = function()
	{
		if(g_curPopType == "MechTrial")
		{
			HideCommonDifficulty();
			ShowCommonInfo("difficulty");
		}
		else
		{
			if(g_blackHoleType == "type1")
			{
				fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_WORMHOLE_CASTOR_NAME" + "\2" + "LC_RULE_RULE_WORMHOLE_CASTOR_DESC");
			}
			else
			{
				fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_WORMHOLE_POLLUX_NAME" + "\2" + "LC_RULE_RULE_WORMHOLE_POLLUX_DESC");
			}
		}
	}

	var data = undefined;
	if(g_curPopType == "MechTrial")
	{
		data = g_mechTrialDatas[g_mechTrialType];
	}
	else
	{
		data = g_blackHoleDatas[g_blackHoleType];
	}
	pop_content.txt_chance.text = data.chanceTxt;
	pop_content.panel_title.title_txt.text = data.difficultyTitleTxt;

	var listView = pop_content.list_content.view_list;
	listView.clearListBox();
	listView.initListBox("DifficultyBar",0,false,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc, index_item)
	{
		var diffData = undefined;
		if(g_curPopType == "MechTrial")
		{
			diffData = g_mechTrialDatas[g_mechTrialType].diffs[index_item];
		}
		else
		{
			diffData = g_blackHoleDatas[g_blackHoleType].diffs[index_item];
		}
		if(diffData.isLocked)
		{
			mc.gotoAndStop(2);
			CTextAutoSizeTool.SetSingleLineText(mc.content.txt_unlock, diffData.unlockTxt, 20, 10);
		}
		else
		{
			mc.gotoAndStop(1);
			mc.content.stars.gotoAndStop(diffData.star + 1);
		}
		mc.content.txt_difficulty.text = diffData.difficultyTxt;
		mc.content.icon_difficulty.gotoAndStop(diffData.difficultyClip);

		mc.my_difficulty = diffData.difficulty;
		mc.onPress = function()
		{
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
			this._parent.onPressedInListbox();
		}
		mc.onReleaseOutside = function()
		{
			this._parent.onReleasedInListbox();
		}
		mc.onRelease = function()
		{
			this._parent.onReleasedInListbox();
			var pt:Object = {x:this.Press_x, y:this.Press_y};
			this._parent.globalToLocal(pt);
			if(pt.x > this._parent._getPanelPosY() && pt.x < this._parent._getPanelBottomPosY())
			{
				if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					fscommand("ChallengeCommand", "CommonDifficultySelected" + "\2" + this.my_difficulty);
				}
			}
			else
			{
				MainUI.pop_trial_difficulty.bg_btn.onRelease();
			}
		}
	}
	for(var i = 0; i < data.diffs.length; ++i)
	{
		listView.addListItem(i, false, false);
	}
}

function HideCommonDifficulty()
{
	TopUI._visible = true;
	MainUI.pop_trial_difficulty._visible = false;
	MainUI.pop_trial_difficulty.bg_btn._visible = false;
	MainUI.pop_trial_difficulty.bg_btn.onRelease = undefined;
	var pop_content = MainUI.pop_trial_difficulty.pop_content;
	pop_content.btn_shield._visible = false;
	pop_content.btn_shield.onRelease = undefined;
}

function ShowCommonInfo(from)
{
	g_mechTrialInfoFrom = from;
	TopUI._visible = false;
	MainUI.pop_trial_info._visible = true;
	MainUI.pop_trial_info.bg_btn._visible = true;
	MainUI.pop_trial_info.bg_btn.onRelease = function()
	{
		HideCommonInfo();
		if(g_mechTrialInfoFrom == "difficulty")
		{
			ShowCommonDifficulty(true);
		}
		else
		{
			if(g_curPopType == "MechTrial")
			{
				OpenMechTrail(true);
			}
			else
			{
				OpenBlackHole(true);
			}
		}
	}
	var pop_content = MainUI.pop_trial_info.pop_content;
	pop_content.btn_shield._visible = true;
	// pop_content.btn_shield.onRelease = function()
	// {
	// }

	var data = undefined;
	if(g_curPopType == "MechTrial")
	{
		data = g_mechTrialDatas[g_mechTrialType];
	}
	else
	{
		data = g_blackHoleDatas[g_blackHoleType];
	}
	pop_content.title_txt.text = data.infoTitleTxt;
	pop_content.txt_rule.text = data.infoRuleTxt;
	pop_content.txt_desc.text = data.infoDescTxt;

	var listView = pop_content.drop_bar.list_content.view_list;
	listView.drops = data.drops;
	listView.clearListBox();
	listView.initListBox("Raids_Icon",0,false,true);
	listView.enableDrag( drops.length >= 6 );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}


	listView.onItemEnter = function(mc, index_item)
	{
		mc.my_index = index_item;
		var dropData = mc._parent.drops[index_item];
		mc.icon_bar.txt_num._visible = false;
		mc.icon_bar.bg_bar._visible = false;

		if(mc.icon_bar.item_icon.icons==undefined)
		{
			var w = mc.icon_bar.item_icon._width;
			var h = mc.icon_bar.item_icon._height;
			mc.icon_bar.item_icon.loadMovie("CommonIcons.swf")
			mc.icon_bar.item_icon._width = w;
			mc.icon_bar.item_icon._height = h;
		}
		// trace("dropData: " + dropData);
		// trace("dropData.IconData: " + dropData.IconData);
		// trace("dropData.IconData.icon_index: " + dropData.IconData.icon_index);
		mc.icon_bar.item_icon.IconData = dropData.IconData;
		if (mc.icon_bar.item_icon.UpdateIcon) { mc.icon_bar.item_icon.UpdateIcon(); }
	}
	for(var i = 0; i < data.drops.length; ++i)
	{
		listView.addListItem(i, false, false);
	}
	listView.forceCorrectPosition();
}

function HideCommonInfo()
{
	TopUI._visible = true;
	MainUI.pop_trial_info._visible = false;
	MainUI.pop_trial_info.bg_btn._visible = false;
	MainUI.pop_trial_info.bg_btn.onRelease = undefined;
	var pop_content = MainUI.pop_trial_info.pop_content;
	pop_content.btn_shield._visible = false;
	pop_content.btn_shield.onRelease = undefined;
}

//FTE functions
function FTEClickElite()
{
	g_challengeMCOrder[0].onRelease(true)
}

function FTEClickArena()
{
	g_challengeMCOrder[1].onRelease(true)
}

function FTEClickExpedition()
{
	g_challengeMCOrder[2].onRelease(true)
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.expedition._visible = false
	_root.fteanim.arena._visible = false
	_root.fteanim.elite._visible = false
}

FTEHideAnim()