import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

var g_screenW = _root._width;
var g_screenH = _root._height;

var g_popupRoot = _root.popup_root;

var g_popW = 0;
var g_popH = 0;
var g_popX = 0;
var g_popY = 0;
var g_curPopup = undefined;
var g_curPopupName = "";

var g_popSizes = new Object();

var g_nextId = 0;


trace("g_screenW: " + g_screenW + " g_screenH: " + g_screenH);

_root.btn_bg._visible = false;

this.onLoad = function(){
	init();
}

function init()
{
	// var mc = ShowPopLine("popName", 1, new Array( 500, 300, 500, 150, 450, 150, 600, 600), 1000, false, false);
	// ShowPopup("Pop_CreepsOn", "Title", 1, 600, 300);
}

function CreatePopup(popName, libName)
{
	g_popupRoot.attachMovie(popName, libName, g_popupRoot.getNextHighestDepth());
}

function ReleasePopup(popName, libName)
{
	g_popupRoot[popName].removeMovieClip();
}

function UpdatePopupPos(entityX, entityY)
{
	var popName = g_curPopupName
	var mc = g_popupRoot[popName];
	if(mc)
	{
		var popSize = g_popSizes[popName];
		if(!popSize)
		{
			var sizeObj = new Object();
			sizeObj.w = mc._width;
			sizeObj.h = mc._height;
			g_popSizes[popName] = sizeObj;
			popSize = g_popSizes[popName];
		}

		// trace("size: " + popSize.w + " " + popSize.h);

		var isLeft = mc.isLeft;
		var isUp = mc.isUp;

		var mcX = mc._x;
		var mcY = mc._y;

		var lineStartX = mc.lineStartX;
		var lineStartY = mc.lineStartY;
		var lineEndX = mc.lineEndX;
		var lineEndY = mc.lineEndY;


		lineStartX = entityX;
		lineEndX = entityX - 100;
		mcX = lineEndX - popSize.w / 2;
		if(entityX < g_screenW / 2 - 50)
		{
			isLeft = false;
			lineEndX = entityX + 100;
			mcX = lineEndX + popSize.w / 2;
		}

		var upOffset = mc.markOffset ? mc.markOffset : 0;
		lineStartY = entityY - 55 - upOffset;
		lineEndY = entityY - popSize.h / 2 + 0 - upOffset;
		mcY = entityY - 18 - upOffset;
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
				lineStartY = entityY + 55;
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

		var markMc = g_popupRoot[mc.markName];
		markMc._x = entityX;
		markMc._y = entityY;

		UpdateLinePos(mc.lineName, new Array(lineStartX, lineStartY, lineStartX, lineEndY, lineEndX, lineEndY))
	}
}

function ShowPopup(popName, popTitle, colorIndex, entityX, entityY, entityType, entityId, markOffset)
{
	if(g_curPopupName != "" && g_curPopupName != popName)
	{
		CloseCurrentPopup();
	}

	_root.btn_bg._visible = true;
	_root.btn_bg.onRelease = function(){}

	g_curPopupName = popName;
	if(popName == "PreShow") //only stop input
	{
		return;
	}

	CreatePopup(popName, popName);
	var mc = g_popupRoot[popName];
	mc.popName = popName;
	mc.entityType = entityType;
	mc.entityId = entityId;

	mc.markOffset = markOffset;

	var popSize = g_popSizes[popName];
	if(!popSize)
	{
		var sizeObj = new Object();
		sizeObj.w = mc._width;
		sizeObj.h = mc._height;
		g_popSizes[popName] = sizeObj;
		popSize = g_popSizes[popName];
	}

	// trace("size: " + popSize.w + " " + popSize.h);

	var isLeft = true;
	var isUp = true;

	var lineStartX = entityX;
	var lineEndX = entityX - 100;
	var mcX = lineEndX - popSize.w / 2;
	if(entityX < g_screenW / 2 - 50)
	{
		isLeft = false;
		lineEndX = entityX + 100;
		mcX = lineEndX + popSize.w / 2;
	}

	var upOffset = mc.markOffset ? mc.markOffset : 0;
	var lineStartY = entityY - 55 - upOffset;
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
			lineStartY = entityY + 55;
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
	mc.isUp = isUp;
	mc.isLeft = isLeft;
	mc.lineStartX = lineStartX;
	mc.lineStartY = lineStartY;
	mc.lineEndX = lineEndX;
	mc.lineEndY = lineEndY;
	mc.title_bar.txt_title.text = popTitle;
	// trace("x: " + mc._x + " y: " + mc._y + mc);
	mc.InitFunc = _root["InitFunc_" + popName];
	if(mc.InitFunc == undefined)
	{
		mc.InitFunc = InitFunc_Default;
	}
	mc.UpdateFunc = _root["UpdateFunc_" + popName];
	mc._alpha = 1;
	mc.onEnterFrame = function()
	{
		// trace("this: " + this + "  " + this.InitFunc);
		// trace("this: " + this._x + " " + this._y);
		this._alpha = 100;
		this.InitFunc(this);
		this.onEnterFrame = undefined;
	}
	g_curPopup = mc;

	var markName = popName + (g_nextId++) + "_Mark";
	g_popupRoot.attachMovie("aimall" + colorIndex, markName, g_popupRoot.getNextHighestDepth());
	var markMc = g_popupRoot[markName];
	markMc._x = entityX;
	markMc._y = entityY;
	// markMc.gotoAndStop(colorIndex);
	markMc.circle.gotoAndPlay("opening_ani");

	mc.markName = markName;

	var lineName = popName + (g_nextId++);
	mc.lineName = lineName;
	ShowPopLine(lineName, colorIndex, new Array(lineStartX, lineStartY, lineStartX, lineEndY, lineEndX, lineEndY), 300, false, false);

}

function UpdatePopupInfo(popName, info)
{
	var mc = g_popupRoot[popName];
	mc.UpdateFunc(mc, info);
}

function CloseCurrentPopup()
{
	if(g_curPopupName == "PreShow")
	{
		_root.btn_bg.onRelease = undefined;
		_root.btn_bg._visible = false;
		g_curPopupName = "";
	}
	else if(g_curPopup)
	{
		_root.btn_bg.onRelease = function(){}
		g_curPopup.OnMoveOutOver = function()
		{
			_root.btn_bg.onRelease = undefined;
			_root.btn_bg._visible = false;
			// _root.btn_bg.onRelease = function()
			// {
			// 	ShowPopup("Pop_Raids", 2, _root._xmouse, _root._ymouse);
			// }

			var popName = this.popName;
			ReleasePopup(popName);
		}

		var markName = g_curPopup.markName;
		g_popupRoot[markName].circle.gotoAndPlay("closing_ani");
		g_popupRoot[markName].circle.OnMoveOutOver = function()
		{
			// trace("mark moved out");
			this._parent.removeMovieClip();			
		}

		g_curPopup.gotoAndPlay("closing_ani");

		var lineMc = g_popupRoot[g_curPopup.lineName + "_Lines0"];
		HidePopLine(lineMc);

		fscommand("WorldMapCmd", "OnPopupClosed" + "\2" + g_curPopupName);
		g_curPopupName = "";
		g_curPopup = undefined;
	}
	else
	{
		_root.btn_bg.onRelease = undefined;
		// g_curPopup = undefined;
		g_curPopupName = "";
	}
}

function UpdateLinePos(popName, poses)
{
	var baseName = popName + "_Lines";
	var rootName = baseName + "0";
	var posLen = poses.length / 2;
	var rootMc = g_popupRoot[rootName];
	if(rootMc)
	{
		rootMc.myPoses = poses;

		var totalLenth = 0;
		for(var i = 0; i < posLen - 1; ++i)
		{
			var mc = g_popupRoot[baseName + i];
			mc._x = poses[i * 2];
			mc._y = poses[i * 2 + 1];
			// mc._yscale = isReverse ? 100 : 0;

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
		rootMc.isDone = false;
	}
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
		// var rootMc = g_popupRoot[rootName];
		// rootMc.initH = 100; //rootMc._height;
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

function HidePopLine(mc)
{
	ShowPopLine(mc.popName, mc.clipIndex, mc.myPoses, mc.timeTotal, true, true)
}

function InitFunc_Default(mc)
{
	mc.OnMoveInOver = function()
	{
		trace("Moved in");
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
	}
	mc.gotoAndPlay("opening_ani");
}

//planet raids
function InitFunc_Pop_Raids(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnRaidsPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_raid1.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnRaidsPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "raid" + "\2" + 1);
		}
		this.btn_raid10.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnRaidsPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "raid" + "\2" + 10);
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_Raids(popMc, info)
{
	popMc.btn_raid1.txt_energy.text = info.needEnergy;
	popMc.btn_raid10.txt_energy.text = info.needEnergy10;

	var rewards = info.rewards;
	var viewList = popMc.list_area.ViewList;
	viewList.rewards = rewards;
	viewList.clearListBox();
	viewList.initListBox("Raids_Icon", 6, false, true);
	viewList.enableDrag(rewards.length > 4 ? true : false);
	viewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	viewList.onItemEnter = function(mc, itemKey)
	{
		mc.icon_bar.txt_num._visible = false;
		mc.icon_bar.bg_bar._visible = false;
		mc.icon_bar.item_icon._alpha = 100;
		if(mc.icon_bar.item_icon.icons == undefined)
		{
			var w = mc.icon_bar.item_icon._width;
			var h = mc.icon_bar.item_icon._height;
			mc.icon_bar.item_icon.loadMovie("CommonIcons.swf");
			// mc.icon_bar.item_icon._alpha = 100;
			mc.icon_bar.item_icon._width = w;
			mc.icon_bar.item_icon._height = h;
			// trace(mc.icon_bar.item_icon._width + "  " + mc.icon_bar.item_icon._height);
		}

		mc.icon_bar.item_icon.IconData = mc._parent.rewards[itemKey];
		// trace(itemKey + " : " + mc.icon_bar.item_icon.IconData + " bb  " + mc.icon_bar.item_icon.IconData.icon_index);
		// trace("mc " + mc._visible + " " + mc.icon_bar._visible + " " + mc.icon_bar.item_icon._visible);
		// trace("mc " + mc._alpha + " " + mc.icon_bar._alpha + " " + mc.icon_bar.item_icon._alpha);
		if (mc.icon_bar.item_icon.UpdateIcon) { mc.icon_bar.item_icon.UpdateIcon(); }
	}

	for(var i = 0; i < rewards.length; ++i)
	{
		viewList.addListItem(i, false, false);
	}
	viewList.forceCorrectPosition();
}

//planet attack info
function InitFunc_Pop_AttackInfo(popMc)
{
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnAttackInfoClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_declare.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnAttackInfoClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "declare");
		}
	}
	popMc.gotoAndPlay("opening_ani");
	trace("xxpp InitFunc_Pop_AttackInfo");
}

function UpdateFunc_Pop_AttackInfo(popMc, info)
{

	popMc.title.txt.text = info.popTitle;
	popMc.owner.name_txt.text = info.alliance_name;

	SetAllianceIcon(popMc.owner.icon, info.alliance_icon);

	popMc.txt_level.txt_num.text = info.level;
	popMc.txt_level.txt2.text = info.level_txt
	popMc.txt_num.txt_num.text = info.num;
	popMc.txt_num.txt2.text = info.num_txt;
	popMc.btn_declare.txt.text = info.strBtnDeclare;
	popMc.btn_declare.txt_time.text = info.strtimestamp;

	trace("xxpp UpdateFunc_Pop_AttackInfo");
}

//planet attack countown
function InitFunc_Pop_AttackCountdown(popMc)
{
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnAttackCountdown" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
	}
	popMc.gotoAndPlay("opening_ani");
	trace("xxpp InitFunc_Pop_AttackCountdown");
}

function FormatTimeTxt(val)
{
	if (val < 10)
	{
		val = "0" + val;
	}
	return val;
}

function GetTimeText(time)
{
	if (time == undefined)
	{
		return;
	}
	if (time < 0)
	{
		time = 0;
	}
	var seconed = FormatTimeTxt(time % 60);

	time = Math.floor(time / 60);

	var minutes = FormatTimeTxt(time % 60);
	time = Math.floor(time / 60);

	var hour = FormatTimeTxt(time);

	return hour + ":" + minutes + ":" + seconed;
}

function UpdateFunc_Pop_AttackCountdown(popMc, info)
{

	popMc.title.txt.text = info.popTitle;
	popMc.owner.name_txt.text = info.alliance_name;
	
	SetAllianceIcon(popMc.owner.icon, info.alliance_icon);

	//popMc.owner.icon
	popMc.txt_level.txt_num.text = info.level;
	popMc.txt_level.txt2.text = info.level_txt
	popMc.txt_num.txt_num.text = info.num;
	popMc.txt_num.txt2.text = info.num_txt
	popMc.countdown.txt.text = info.countdown_txt
	popMc.countdown.txt_time.text = info.strtimestamp
	popMc.ower2.txt.text = info.alliance_name
	//popMc.ower2.icon
	if (info.owner_id == 0)
	{
		popMc.ower2.icon.gotoAndStop(2);
	}else
	{
		popMc.ower2.icon.gotoAndStop(3);
		SetAllianceIcon(popMc.ower2.icon, info.alliance_icon);
	}
	popMc.attacker.txt.text = info.attacker_name
	//popMc.attacker.icon  attacker_icon
	popMc.attacker.icon.gotoAndStop(3);
	SetAllianceIcon(popMc.attacker.icon, info.attacker_icon);

	popMc.countdown.count_down = info.count_down
	popMc.countdown.Milliseconds = 0
	popMc.countdown.onEnterFrame = function()
	{
		var curDate = new Date();
		var curMilliseconds = curDate.getTime();
		if (this.Milliseconds == 0)
		{
			this.Milliseconds = curMilliseconds;
		}
		var offset = curMilliseconds - this.Milliseconds;
		if (offset >= 1000)
		{
			var seconds = Math.floor(offset / 1000);
			this.Milliseconds += seconds * 1000;
			this.count_down = this.count_down - 1;
			if (this.count_down >= 0)
			{
				this.txt_time.text = GetTimeText(this.count_down);
			}
		}
	}
}

function SetAllianceIcon(mc, strIcon)
{
    var width =  mc.item_icon._width;
    var height = mc.item_icon._height;
	if (mc.item_icon.icons == undefined)
	{
        mc.item_icon.loadMovie("AllianceIconSmall.swf");
    }
    mc.item_icon._width = width;
    mc.item_icon._height = height;

    mc.item_icon.icons.gotoAndStop(strIcon)
}

//mineral
function InitFunc_Pop_Mining(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnMinePopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_detail.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnMinePopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "detail");
		}
		this.btn_extract.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnMinePopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "extract");
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_Mining(popMc, info)
{
	popMc.level_bar.txt_num.text = info.levelTxt;
	popMc.fleet_bar.txt_num.text = info.fleetTxt;
	popMc.reserve_bar.txt_num.text = info.reserveTxt;
}

function InitFunc_Pop_MyMining(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnMinePopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_detail.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnMinePopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "detail");
		}
		this.btn_recall.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnMinePopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "recall");
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_MyMining(popMc, info)
{
	UpdateFunc_Pop_Mining(popMc, info); //common msg

	var num = Math.floor(info.progressNum);
	popMc.progress_bar.gotoAndStop(num + 2);
	popMc.progress_bar.txt_progress.text = info.amountStr;

	popMc.time_bar.txt_time.text = info.timeTxt;
	
	var player_content = popMc.player_icon.player_content;
	if(player_content.user_head.icons == undefined)
	{
		var w = player_content.user_head._width;
		var h = player_content.user_head._height;
		player_content.user_head.loadMovie("CommonPlayerIcons.swf");
		player_content.user_head._width = w;
		player_content.user_head._height = h;
	}

	player_content.user_head.IconData = info.playerIcon;
	if (player_content.user_head.UpdateIcon) { player_content.user_head.UpdateIcon(); }
}

//planet dock, to dock
function InitFunc_Pop_Anchor(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnDockPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_detail.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnDockPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "detail");
		}
		this.btn_dock.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnDockPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "dock");
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_Anchor(popMc, info)
{
	popMc.income_bar.txt_num.text = info.incomeTxt;
	popMc.fleet_bar.txt_num.text = info.fleetTxt;
}

//planet dock, to leave
function InitFunc_Pop_Go(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnDockPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_detail.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnDockPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "detail");
		}
		this.btn_undock.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnDockPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "undock");
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_Go(popMc, info)
{
	UpdateFunc_Pop_Anchor(popMc, info); //common msg

	var num = Math.floor(info.progressNum);
	popMc.progress_bar.gotoAndStop(num + 2);
	popMc.progress_bar.txt_progress.text = info.amountStr;

	popMc.time_bar.txt_time.text = info.timeTxt;
	
	var player_content = popMc.player_icon.player_content;
	if(player_content.user_head.icons == undefined)
	{
		var w = player_content.user_head._width;
		var h = player_content.user_head._height;
		player_content.user_head.loadMovie("CommonPlayerIcons.swf");
		player_content.user_head._width = w;
		player_content.user_head._height = h;
	}

	player_content.user_head.IconData = info.playerIcon;
	if (player_content.user_head.UpdateIcon) { player_content.user_head.UpdateIcon(); }
}

//boss 
function InitFunc_Pop_CreepsOn(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.btn_info.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnBossPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "info");
		}
		this.btn_detail.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnBossPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "detail");
		}
		this.btn_attack.onRelease = function()
		{
			fscommand("WorldMapCmd", "OnBossPopClick" + "\2" + this._parent.entityType + "\2" + this._parent.entityId + "\2" + "attack");
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_CreepsOn(popMc, info)
{
	var num = Math.floor(info.progressNum);
	popMc.progress_bar.gotoAndStop(num + 2);
	popMc.progress_bar.txt_progress.text = num + "%";

	popMc.time_bar.txt_time.text = info.timeTxt;
	popMc.level_bar.txt_num.text = info.levelTxt;
	popMc.players_bar.txt_num.text = info.playersTxt;

	popMc.info_bar.txt_damage.text = info.damageTxt;
	popMc.info_bar.txt_rank.text = info.rankTxt;

	popMc.btn_attack._visible = info.canAttack;
	popMc.btn_unattack._visible = !info.canAttack;
	popMc.btn_attack.txt_cost.text = info.energyCost;

	if(info.needUpdateRewards)
	{
		if(info.onlyRewardMoney)
		{
			popMc.money_bar._visible = false;
			popMc.credit_bar._visible = false;
			popMc.money_bar1._visible = true;
			popMc.money_bar1.txt_num.text = info.moneyTxt;
		}
		else
		{
			popMc.money_bar._visible = true;
			popMc.credit_bar._visible = true;
			popMc.money_bar1._visible = false;
			popMc.money_bar.txt_num.text = info.moneyTxt;
			popMc.credit_bar.txt_num.text = info.creditTxt;
		}

		var rewards = info.rewards;
		var viewList = popMc.list_area.ViewList;
		viewList.rewards = rewards;
		viewList.clearListBox();
		viewList.initListBox("Raids_Icon", 6, false, true);
		viewList.enableDrag(rewards.length > 2 ? true : false);
		viewList.onEnterFrame = function()
		{
			this.OnUpdate();
		}

		viewList.onItemEnter = function(mc, itemKey)
		{
			var reward = mc._parent.rewards[itemKey];

			mc.icon_bar.txt_num._visible = true;
			mc.icon_bar.txt_num.text = reward.numTxt;
			mc.icon_bar.bg_bar._visible = true;
			mc.icon_bar.item_icon._alpha = 100;
			if(mc.icon_bar.item_icon.icons == undefined)
			{
				var w = mc.icon_bar.item_icon._width;
				var h = mc.icon_bar.item_icon._height;
				mc.icon_bar.item_icon.loadMovie("CommonIcons.swf");
				mc.icon_bar.item_icon._width = w;
				mc.icon_bar.item_icon._height = h;
			}

			mc.icon_bar.item_icon.IconData = reward.iconData;
			if (mc.icon_bar.item_icon.UpdateIcon) { mc.icon_bar.item_icon.UpdateIcon(); }
		}

		for(var i = 0; i < rewards.length; ++i)
		{
			viewList.addListItem(i, false, false);
		}
		viewList.forceCorrectPosition();
	}
}

//Enemy Info
//
function InitFunc_Pop_ArmInfo(popMc)
{
	popMc.btn_shield.onRelease = function(){}
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.info_btn.onRelease = function()
		{
			fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_PLANETWAR_INFO_TITLE" + "\2" + "LC_RULE_RULE_PLANETWAR_INFO_DESC");
		}
	}
	
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_ArmInfo(popMc, info)
{
	SetAllianceIcon(popMc.alliance_info.icon, info.alliance_icon)
	popMc.alliance_info.name_txt.text 	= info.alliance_name;
	popMc.content.level_txt.text 		= info.level;
	popMc.content.fleets_txt.text 		= info.fleets;
	popMc.content.prestige_txt.text 	= info.prestige;

	for(var i = 1; i <= 4; ++i)
	{
		popMc["box" + i].num.num_txt.text = info["award" + i]
	}
}

//upgrade
function InitFunc_Pop_MyInfo(popMc)
{
	popMc.OnMoveInOver = function()
	{
		_root.btn_bg.onRelease = function()
		{
			CloseCurrentPopup();
		}
		this.info_btn.onRelease = function()
		{
			fscommand("ShowCommonRuleDescPop", "LC_RULE_RULE_PLANETWAR_INFO_TITLE" + "\2" + "LC_RULE_RULE_PLANETWAR_INFO_DESC");
		}
	}
	popMc.gotoAndPlay("opening_ani");
}

function UpdateFunc_Pop_MyInfo(popMc, info)
{
	if(not info.can_operation or info.is_max_level)
	{
		popMc.upgrade.gotoAndStop(2);
	}else
	{
		popMc.upgrade.gotoAndStop(1);
	}
	SetAllianceIcon(popMc.alliance_info.icon, info.alliance_icon)
	popMc.alliance_info.name_txt.text 	= info.alliance_name;
	if(info.is_max_level)
	{
		popMc.content.cur_level_txt.text 	= info.cur_level + "(MAX)";
		popMc.upgrade.upgrade_btn.num_txt.text 		= "(MAX)";
		popMc.content.next_level_txt._visible = false;
		popMc.content.next_fleets_txt._visible = false;
		popMc.content.next_prestige_txt._visible = false;
		popMc.content.arrow1._visible = false;
		popMc.content.arrow2._visible = false;
		popMc.content.arrow3._visible = false;
	}else
	{
		popMc.content.cur_level_txt.text 	= info.cur_level;
		popMc.upgrade.upgrade_btn.num_txt.text 		= info.upgrade_use;

		popMc.content.next_level_txt.text 	= info.next_level;
		popMc.content.next_fleets_txt.text 	= info.next_fleets;
		popMc.content.next_prestige_txt.text = info.next_prestige;

		popMc.content.next_level_txt._visible = true;
		popMc.content.next_fleets_txt._visible = true;
		popMc.content.next_prestige_txt._visible = true;
		popMc.content.arrow1._visible = true;
		popMc.content.arrow2._visible = true;
		popMc.content.arrow3._visible = true;
	}
	popMc.content.cur_fleets_txt.text 	= info.cur_fleets
	popMc.content.cur_prestige_txt.text = info.cur_prestige

	

	
	popMc.upgrade.upgrade_btn.onRelease = function()
	{
		fscommand("WorldMapCmd", "PlanetUpgrade\2" + this.planet_id);
	}
	popMc.upgrade.upgrade_btn.planet_id = info.planet_id

	//popMc.upgrade_btn._visible = info.is_max_level == false

	for(var i = 1; i <= 4; ++i)
	{
		popMc["box" + i].num.num_txt.text = info["award" + i]
	}

}