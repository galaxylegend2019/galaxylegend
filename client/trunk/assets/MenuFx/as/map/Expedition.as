
var MainUI 		= _root;
var TopUI 		= MainUI.top_ui;
var GateLayer 	= MainUI.Gate_layer;
var BottomUI 	= MainUI.bottom_ui;
var BoxPopup 	= MainUI.box_popup;
var RewardPopup = MainUI.reward_popup;

var GateContent = GateLayer.content;

var RefreshBtn 	= MainUI.btn_refresh;
var ExchangeBtn = MainUI.btn_exchange;

var CurFogIndex = 1;

var IsClose = false;

var g_screenW = 1136;
var g_screenH = 640;
var g_popupRoot = GateLayer.content;
var g_popSizes = new Object();
var g_popArray = new Array();
this.onLoad = function(){
	SetDefaultShow();
	InitUI();
	//OpenUI();
	//_root._visible = false;
	//ShowPopLine("pop_line", 1, new Array(400, 100, 400, 400, 300, 400), 300, false, false);
	
	//ShowPopup("popup_info", "11111", 1, 109, 171, 0);
}

function SetDefaultShow()
{
	BoxPopup._visible 		= false;
	RewardPopup._visible 	= false;
	GateContent._visible 	= false;
	_root.rewards._visible 	= false;
}

function OpenUI()
{
	_root._visible = true;
	TopUI.gotoAndPlay("opening_ani");
	GateLayer.gotoAndPlay("opening_ani");
	BottomUI.gotoAndPlay("opening_ani");
	OpenPopupUI();
	fscommand("TutorialCommand","Activate" + "\2" + "OpenExpedition");
}

function CloseUI()
{
	TopUI.gotoAndPlay("closing_ani");
	GateLayer.gotoAndPlay("closing_ani");
	BottomUI.gotoAndPlay("closing_ani");
	ClosePopupUI();
}

function InitUI()
{
	TopUI.btn_close.onRelease = function()
	{
		IsClose = true;
		CloseUI();
	}
	TopUI.OnMoveOutOver = function()
	{
		if (IsClose)
		{
			trace("-----------close---------------")
			//fscommand("ExitBack");
			fscommand("ExpeditionCmd","Exit");
			IsClose = false;
		}else
		{
			fscommand("ExpeditionCmd","AttackCurTask");
		}
		
	}
	BoxPopup.onRelease = function(){
		fscommand("ExpeditionCmd","GetAward");
		this.gotoAndPlay("closing_ani");
	}
	RewardPopup.OnMoveOutOver = function(){
		fscommand("ExpeditionCmd","EndAwardShow");
		this._visible = false;
	}
	BoxPopup.OnMoveOutOver = function(){
		this._visible = false;
	}

	RewardPopup.onRelease = function(){
		this.gotoAndPlay("closing_ani");
	}
	_root.bottom_ui.btn_refresh.onRelease = function(){
		fscommand("ExpeditionCmd","refresh")
	}

	_root.bottom_ui.btn_exchange.onRelease = function(){
		fscommand("ExpeditionCmd","exchange")
	}
	_root.bottom_ui.btn_rull.onRelease = function()
	{
		fscommand("ShowCommonRuleDescPop", "LC_RULE_rule_expedition_title" + "\2" + "LC_RULE_rule_expedition_des");
	}
}

function set_refreashTimes(times_description){
	_root.bottom_ui.btn_refresh.refresh_times_text.text = times_description;
}

function SetMoneyData(datas)
{
	TopUI.money.money_text.text = datas.money;
	TopUI.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = TopUI.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

TopUI.money.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

TopUI.credit.onRelease=function()
{
	fscommand("GoToNext", "Purchase");
}

TopUI.energy.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

function RefreshGateInfos( datas )
{
	GateContent._visible 	= true;
	for (var i = 0; i < 15; i++)
	{

		SetGateInfo(GateLayer.content["qia_" + (datas[i].gate_id)], datas[i]);
	}
}

function RefreshFog(fog_index, gate_index)
{
	
	for (var i = 2; i <= 5; ++i)
	{
		var fog_item = GateLayer.content["fog_" + i];
		fog_item.gotoAndStop(1);
		if (i <= fog_index)
		{
			fog_item._visible = false;
		}else
		{
			fog_item._visible = true;
		}
	}

	var offset = 618 - GateLayer.content["qia_" + gate_index]._x;
	SetGatePosition(offset);
}

function PlayUnlockFog(index)
{
	var fog_item = GateLayer.content["fog_" + index];
	if (fog_item != undefined)
	{
		fog_item.gotoAndPlay("closing_ani");
	}
}

/*
info.state -- activited locked passed
info.level
info.alliance_icon_data
info.player_icon_data
info.player_name
info.gate_id
*/
function SetGateInfo(mc, info)
{
	mc.gotoAndStop(info.state);
	mc.info = info;
	mc.onRelease = undefined;
	var gate_item = mc.task_plane;
	if (info.state == "activited")
	{
		gate_item.info.level.level_num.text = info.levelTxt;
		if (info.alliance_icon_data == undefined)
		{
			gate_item.info.name.gotoAndStop(2);	
		}else
		{
			gate_item.info.name.gotoAndStop(1);
			SetAllianceIcon(gate_item.info.name.alliance_icon, info.alliance_icon_data);
		}
		gate_item.info.name.name_bar.txt_name.text = info.player_name;
		SetPlayerIcon(gate_item.info, info.player_icon_data);
		mc.onRelease = function()
		{
			//fscommand("ExpeditionCmd", "show_detail\2" + this.info.gate_id);
			ShowPopup("popup_info", this.info , 1, this._x, this._y, 0);
		}
	}else if (info.state == "locked")
	{
		gate_item.level.level_num.text = info.levelTxt;
		SetPlayerIcon(gate_item, info.player_icon_data);
	}else if (info.state == "passed")
	{
		gate_item.level.level_num.text = info.levelTxt;
		SetPlayerIcon(gate_item, info.player_icon_data);
		if (info.alliance_icon_data == undefined)
		{
			gate_item.info.name.gotoAndStop(2);	
		}else
		{
			gate_item.info.name.gotoAndStop(1);
			SetAllianceIcon(gate_item.name.alliance_icon, info.alliance_icon_data);
		}
		gate_item.name.name_bar.txt_name.text = info.player_name;
		gate_item.name.name_bar._x = 75;
		gate_item.name.name_bar._y = 17;
	}
	
}

function SetPlayerIcon(mc, icon_data)
{
	var head_width  = mc.player_icon._width
	var head_height = mc.player_icon._height
	var head_icon

	if(mc.player_icon.icons == undefined)
	{
		head_icon         = mc.player_icon.loadMovie("CommonPlayerIcons.swf");
		head_icon._width  = head_width
		head_icon._height = head_height
	}

	mc.player_icon.IconData = icon_data;
	if (mc.player_icon.UpdateIcon) 
	{
		mc.player_icon.UpdateIcon()
	}
}

function SetAllianceIcon(mc, icon_data)
{

}

function ShowGetAwardUI()
{
	MainUI.box_popup._visible = true;
	MainUI.box_popup.gotoAndPlay("opening_ani");
}

function ShowAward(AwardInfo){
	refreshAward(AwardInfo);
	_root.reward_popup.gotoAndPlay("opening_ani");
	_root.reward_popup._visible = true;
}

function refreshAward(AwardInfo){
	var reward_plane = _root.reward_popup;
	var res_plane = reward_plane.title_view.res_plane;
	if ( AwardInfo.res_list.length == 0 ){
		res_plane._visible = false;
	}else{
		res_plane._visible = true;
		var frame = AwardInfo.res_list.length;
		res_plane.gotoAndStop(frame);
		for (var i = 0; i < AwardInfo.res_list.length ; ++i){
			res_plane["res_plane_" + (i + 1)].gotoAndStop("res_" + AwardInfo.res_list[i].name);
			res_plane["res_plane_" + (i + 1)].value_plane.value_text.text = "x" + AwardInfo.res_list[i].count;
		}
	}
	
	for(var i = 1 ; i <= 3 ; ++i){
		reward_plane["item_" + i]._visible = false;
	}

	if ( AwardInfo.item_list.length == 1 ){
		refreshAwardItem(reward_plane["item_2"],AwardInfo.item_list[0]);
	}
	else if ( AwardInfo.item_list.length > 1 ){
		for (var i = 0; i < 3; ++i){
			refreshAwardItem(reward_plane["item_" + (i + 1)],AwardInfo.item_list[i]);
		}
	}
}

function refreshAwardItem(item_mc,item_data){
	item_mc._visible = item_data != undefined;
	
	if (item_mc.item_icon.icons == undefined){
		item_mc.item_icon.loadMovie("CommonIcons.swf");
	}
	item_mc.item_icon.IconData = item_data.icon_data;
	if (item_mc.item_icon.UpdateIcon) { item_mc.item_icon.UpdateIcon(); }
	item_mc.item_num.text = item_data.cont
}

function OpenPopupUI()
{
	if (g_popupRoot[g_popArray[0]] != undefined)
	{
		g_popupRoot[g_popArray[0]].gotoAndPlay("opening_ani");
		g_popupRoot[g_popArray[0]]._visible = true;
		g_popupRoot[g_popArray[1]]._visible = true;
		g_popupRoot[g_popArray[2]]._visible = true;
	}
}


function ClosePopupUI()
{
	if (g_popupRoot[g_popArray[0]] != undefined)
	{
		g_popupRoot[g_popArray[0]].gotoAndPlay("closing_ani");

		
	}
	g_popupRoot[g_popArray[0]].OnMoveOutOver = function()
	{
		g_popupRoot[g_popArray[0]]._visible = false;
		g_popupRoot[g_popArray[1]]._visible = false;
		g_popupRoot[g_popArray[2]]._visible = false;
	}
	
}

function ClearPopupUI()
{
	for(var i = 0; i < g_popArray.length; ++i)
	{
		g_popupRoot[g_popArray[i]].removeMovieClip();
	}
	
}

function CreatePopup(popName, libName)
{
	g_popupRoot.attachMovie(popName, libName, g_popupRoot.getNextHighestDepth());
	g_popArray[0] = popName;
	g_popupRoot[popName].gotoAndPlay("opening_ani");
}

function ShowPopup(popName, datas, colorIndex, entityX, entityY, markOffset)
{
	ClearPopupUI()
	CreatePopup(popName, popName);
	var mc = g_popupRoot[popName];
	mc.popName = popName;
	mc.markOffset = markOffset;
	mc.all_bg_btn.onRelease = function()
	{
		ClosePopupUI();
	}
	var popSize = g_popSizes[popName];
	if(popSize == undefined)
	{
		var sizeObj = new Object();
		sizeObj.w = 336;
		sizeObj.h = 241;
		g_popSizes[popName] = sizeObj;
		popSize = g_popSizes[popName];
	}

	// trace("size: " + popSize.w + " " + popSize.h);

	var isLeft = true;
	var isUp = true;

	var lineStartX = entityX;
	var lineEndX = entityX - 100;
	var mcX = lineEndX - popSize.w / 2;
	if(((entityX + GateContent._x) % 1136) < g_screenW / 2)
	{
		isLeft = false;
		lineEndX = entityX + 100;
		mcX = lineEndX + popSize.w / 2;
	}

	var upOffset = mc.markOffset ? mc.markOffset : 0;
	var lineStartY = entityY - 5 - upOffset;
	var lineEndY = entityY - popSize.h / 2 + 0 - upOffset;
	var mcY = entityY - 18 - upOffset;
	if(lineEndY < 100)
	{
		lineEndY = 100;
		if(entityY > lineEndY + 100)
		{
			mcY = lineEndY - 0 + popSize.h / 2 - 18;
		}
		else
		{
			isUp = false;
			lineStartY = entityY + 5;
			lineEndY = entityY + popSize.h / 2 + 40;
			mcY = entityY + popSize.h / 2 - 40;
		}
	}
	else if(mcY + popSize.h / 2 > g_screenH - 100)
	{
		mcY = g_screenH - 100 - popSize.h / 2
		lineEndY = mcY - popSize.h / 2 + 0 + 18;
	}

	mc._x = mcX;
	mc._y = mcY;
	//return
	mc.isUp = isUp;
	mc.isLeft = isLeft;
	mc.lineStartX = lineStartX;
	mc.lineStartY = lineStartY;
	mc.lineEndX = lineEndX;
	mc.lineEndY = lineEndY;


	ShowPopLine("pop_line", colorIndex, new Array(lineStartX, lineStartY, lineStartX, lineEndY, lineEndX, lineEndY), 300, false, false);

	SetPopupInfo(mc, datas);
}

function ShowPopLine(popName, clipIndex, poses, timeTotal, isReverse, destroyWhenDone)
{
	var baseName = popName + "_Lines";
	var rootName = baseName + "0";
	var posLen = poses.length / 2;
	var isCreate = true;

	

	if(!g_popupRoot[rootName])
	{
		g_popupRoot.attachMovie("pop_line" + clipIndex, rootName, g_popupRoot.getNextHighestDepth());
		g_popArray[1] = rootName;
		g_popupRoot[rootName].gotoAndPlay("opening_ani");
	}

	var rootMc = g_popupRoot[rootName];
	rootMc.clipIndex = clipIndex;
	rootMc.popName = popName;
	// rootMc.gotoAndStop(clipIndex);
	rootMc.myPoses = poses;
	rootMc.timeTotal = timeTotal;
	rootMc.isReverse = isReverse;
	rootMc.destroyWhenDone = destroyWhenDone;

	rootMc.myLines = new Array();
	rootMc.myLines.push(rootName);
	for(var i = 1; i < posLen - 1; ++i)
	{
		var mcName = baseName + i;
		if(!g_popupRoot[mcName])
		{
			g_popupRoot.attachMovie("pop_line" + clipIndex, mcName, g_popupRoot.getNextHighestDepth());
			g_popArray[2] = mcName;
			g_popupRoot[mcName].gotoAndPlay("opening_ani");
		}
		var mc = g_popupRoot[mcName];
		// mc.gotoAndStop(clipIndex);
		rootMc.myLines.push(mcName);
	}

	var totalLenth = 0;
	for(var i = 0; i < posLen - 1; ++i)
	{
		var mc = g_popupRoot[baseName + i];
		mc._x = poses[i * 2];
		mc._y = poses[i * 2 + 1];
		mc._yscale = isReverse ? 100 : 0;

		var nextX = poses[(i + 1) * 2];
		var nextY = poses[(i + 1) * 2 + 1];

		// trace("x: " + mc._x + " y: " + mc._y + " nextX: " + nextX + " nextY: " + nextY);

		var distX = nextX - mc._x;
		var distY = nextY - mc._y;
		var rot = Math.atan2(distY, distX) / (Math.PI / 180) + 90;
		// trace("rot: " + rot + "  " + distX + " " + distY);
		mc._rotation = rot;
		mc.myLength = Math.sqrt(distX * distX + distY * distY);
		// trace("myLength: " + mc.myLength);
		totalLenth += mc.myLength;
	}
	rootMc.totalLenth = totalLenth;
	rootMc.startTime = getTimer();
	rootMc.endTime = rootMc.startTime + timeTotal;
	rootMc.isDone = false;
	rootMc.updatedCount = 0;
	rootMc._alpha = 1;
	rootMc._visible = true;

	rootMc.onEnterFrame = function()
	{
		if(!this.isDone)
		{
			this._alpha = 100;
			++this.updatedCount;
			var curTime = getTimer();
			if(curTime >= this.endTime && this.updatedCount >= 3)
			{
				this.isDone = true;
				if(this.destroyWhenDone)
				{
					// trace("done destroyWhenDone");
					// this.onEnterFrame = undefined;
					var myLines = this.myLines;
					this.myLines = undefined;
					for(var i = 1; i < myLines.length; ++i)
					{
						g_popupRoot[myLines[i]].removeMovieClip();
					}
					g_popupRoot[myLines[0]].removeMovieClip();
					return;
				}
				else
				{
					// trace("done onEnterFrame");
					// this.onEnterFrame = undefined;
					// HidePopLine(this);
				}
			}
			var timeRate = Math.min((curTime - this.startTime) / (this.endTime - this.startTime), 1);

			if(this.isReverse)
			{
				timeRate = 1 - timeRate;
			}
			// timeRate *= timeRate;
			var needLen = this.totalLenth * timeRate;
			var len = 0;
			for(var i = 0; i < this.myLines.length; ++i)
			{
				var mc = g_popupRoot[this.myLines[i]];
				var scale = 0;
				if(needLen >= mc.myLength)
				{
					// scale = mc.myLength / this.initH * 100;
					scale = mc.myLength;
					needLen -= mc.myLength;
					// trace("1 " + i + "  " + mc._yscale + " needLen: " + needLen + " " + this.isReverse + " " + this.initH);
					// trace("aaa " + i + "  " + scale + " rot: " + mc._rotation + " " + timeRate + " " + scale);
				}
				else
				{
					// scale = needLen / this.initH * 100;
					scale = needLen;
					needLen = 0;
					// trace("2 " + i + "  " + mc._yscale + " needLen: " + needLen + " " + this.isReverse + " " + this.initH);
					// trace("bbb " + i + "  " + scale + " rot: " + mc._rotation + " " + timeRate + " " + scale);
				}
				if(scale <= 1)
				{
					mc.scale = 1;
					mc._alpha = 1;
				}
				else
				{
					mc._alpha = 100;
					mc._yscale = scale;
				}
			}
		}
	}

	return rootMc;
}

function SetPopupInfo(mc, datas)
{
	mc.rule_btn.onRelease = function()
	{
		fscommand("ShowCommonRuleDescPop", "LC_RULE_rule_expedition_title" + "\2" + "LC_RULE_rule_expedition_des");
	}
	mc.title.title_txt.text = datas.player_name;
	mc.level.num_txt.text 	= datas.level;
	mc.power.num_txt.text 	= datas.detail_info.Combat_value;

	for (var i = 1; i <= 5; ++i)
	{
		var info = datas.detail_info.heroData_list[i - 1];
		var item = mc.hero_view["item" + i];
		if (info == undefined)
		{
			item._visible = false;
		}else
		{
			item._visible = true;
			SetHeroIcon(item, info);
		}
	}

	mc.btn_atk.onRelease = function()
	{
		CloseUI();
	}
}

function SetHeroIcon(mc, info)
{
	if (mc.icon_info.icons == undefined){
		var w = mc.icon_info._width;
		var h = mc.icon_info._height;
		mc.icon_info.loadMovie("CommonHeros.swf");
		mc.icon_info._width		= w;
		mc.icon_info._height	= h;
	}
	mc.icon_info.IconData = info.icon_data;
	if(mc.icon_info.UpdateIcon)
	{ 
		mc.icon_info.UpdateIcon(); 
	}

	mc.star_plane.star.gotoAndStop(info.star);
	var frame = info.mp_percent;
	mc.energy.gotoAndStop(frame + 1);
	var frame = Math.floor((info.hp_percent / 100) * 5);
	mc.blood.gotoAndStop(frame + 1);
}


/*************drag************/
var last_x = -1;
var start_pos = 0;
var slide = false;
var dir  = 0;
var dis = 0;
var slide_val = 0;
var last_mouse_x = 0;
GateLayer.hitzone.onPress = function()
{
	slide_val = 20;
	last_mouse_x = last_x = _root._xmouse;
	start_pos = GateContent._x;
}

GateLayer.hitzone.onRelease = GateLayer.hitzone.onReleaseOutside = function()
{
	last_x = -1;
	slide = true;
}

_root.onEnterFrame = function()
{
	if (last_x != -1)
	{
		var offset = _root._xmouse - last_x;

		var frame_offset = _root._xmouse - last_mouse_x;
		if (frame_offset > 0)
		{
			dir = 0;
			//trace("-----right------");
		}else if (frame_offset < 0)
		{
			dir = 1;
			//trace("-----left------");
		}
		last_mouse_x = _root._xmouse;

		//slide_val = Math.abs(frame_offset * 2);
		var new_pos = start_pos + offset;
		SetGatePosition(new_pos);
	}
	// if (slide)
	// {
	// 	slide_val = slide_val - 1;
	// 	if (slide_val <= 0)
	// 	{
	// 		dis = 0;
	// 		slide = false;
	// 	}else
	// 	{
	// 		dis = dis + slide_val;
	// 		var new_pos = 0;
	// 		if (dir == 1)
	// 		{
	// 			new_pos = GateContent._x - slide_val;
	// 		}else
	// 		{
	// 			new_pos = GateContent._x + slide_val;
	// 		}
	// 		SetGatePosition(new_pos);
	// 	}
		
	// 	if (dis >= 300)
	// 	{
	// 		dis = 0;
	// 		slide = false;
	// 	}
	// }
}

function SetGatePosition(pos)
{
	if (pos > 0)
	{
		pos = 0;
	}
	if (pos < -(GateContent._width - 1136))
	{
		pos = -(GateContent._width - 1136);
	}
	GateContent._x = pos;
	//g_screenW = 1136 - pos;
}


function FTEClickFirst()
{
	GateLayer.content["qia_1"].onRelease()
}

function FTEClickAttack()
{
	g_popupRoot["popup_info"].btn_atk.onRelease()
}


function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.attack._visible = false
	_root.fteanim.first._visible = false
}

FTEHideAnim()