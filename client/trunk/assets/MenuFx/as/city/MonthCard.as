import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

function getChildrenOf(movie)
{
	var ret = [];
	for(i in movie)
	{
		var ch = movie[i];
		if(ch instanceof MovieClip)
		{
			ret.push(ch);
		}
	}	
	return ret;
}

//Top Level
var g_TopBar = _root.TopBar;
var g_Vip = _root.VIP;
var g_Buy = _root.Buy;
var g_BottomBar = _root.BottomBar;

//Top
var g_VipLevel = g_TopBar.vip.ten;
var g_VipRequire = g_TopBar.require.txt_Require;
var g_Credit = g_TopBar.credit.txt_Num;

//Vip
var g_VipInfos = [];
var g_VipObjects = [g_Vip.content_0, g_Vip.content_1, g_Vip.content_2, g_Vip.content_3, g_Vip.content_4];


//Buy
var g_Special = [g_Buy.SP_0, g_Buy.SP_1];
var g_Normal = [g_Buy.Normal_0, g_Buy.Normal_1, g_Buy.Normal_2, g_Buy.Normal_3];

var g_BackBtn = g_TopBar.btn_back;
var g_ArrowBtn = g_TopBar.btn_TopArrow;

var g_switchState = "Buy"; // or "VIP"
var g_isSwitchState = false;
var g_canSwitchState = true;

var g_vipInfoStart = 0;
var g_vipMoveRate = 0;


//cs functions
this.onLoad = function()
{
	init();

	move_in();
	move_in_buy();
	OnDragVipInfo();
}

function init()
{
	SetTopInvisible();
}

function SetTopInvisible()
{
	g_TopBar._visible = false;
	g_Vip._visible = false;
	g_Buy._visible = false;
	g_BottomBar._visible = false;
	_root.btn_bg._visible = false;
}

function move_in()
{
	g_TopBar._visible = true;
	g_TopBar.gotoAndPlay("opening_ani");

	g_TopBar.OnMoveInOver = function()
	{
		InitButtonFunctions();
	}

	g_BottomBar._visible = true;
	g_BottomBar.gotoAndPlay("opening_ani");
	_root.btn_bg._visible = true;
}

function move_out()
{
	ClearButtonFunctions();

	if(g_switchState == "VIP")
	{
		g_TopBar.gotoAndPlay("closing_ani2");
		move_out_vip();
	}
	else if(g_switchState == "Buy")
	{
		g_TopBar.gotoAndPlay("closing_ani");
		move_out_buy();
	}

	g_TopBar.OnMoveOutOver = function()
	{
		SetTopInvisible();
		// trace("Back");
		// fscommand("GotoNextMenu", "Back");
		fscommand("ExitBack", "");
	}

	g_BottomBar.gotoAndPlay("closing_ani");
}

function move_in_vip()
{
	g_Vip._visible = true;
	g_Vip.gotoAndPlay("opening_ani");
	g_Vip.OnMoveInOver = functioni()
	{
		g_Vip.OnMoveInOver = undefined;
		if(g_isSwitchState && g_switchState == "VIP")
		{
			InitButtonFunctions();
			g_isSwitchState = false;
			// trace("swtich done: " + _root.g_switchState);
		}
	}
}

function move_out_vip()
{
	g_Vip.gotoAndPlay("closing_ani");
	g_Vip.OnMoveOutOver = function()
	{
		g_Vip._visible = false;
		g_Vip.OnMoveOutOver = undefined;

		if(g_switchState == "Buy")
		{
			//_root.g_TopBar.gotoAndPlay("switch2");
			move_in_buy();
		}
	}
}

function move_in_buy()
{
	g_Buy._visible = true;

	for(var i = 0; i < g_Special.length; ++i)
	{
		var sp = g_Special[i];
		sp.my_index = i;
		sp.buy_num = 1;
		sp.btn_Buy.txt_Num.text = "X" + 1;
		sp.gotoAndPlay("opening_ani");
		sp.OnMoveInOver = function()
		{
			this.OnMoveInOver = undefined;
			if(this.my_index == 0)
			{
				if(g_isSwitchState && g_switchState == "Buy")
				{
					InitButtonFunctions();
					g_isSwitchState = false;
					// trace("swtich done: " + _root.g_switchState);
				}
			}

			this.btn_Info.my_index = this.my_index;
			this.btn_Info.onRelease = function()
			{
				trace("sp info: " + this.my_index);
			}

			this.btn_Minus.my_index = this.my_index;
			this.btn_Minus.onRelease = function()
			{
				if(g_Special[this.my_index].buy_num > 1)
				{
					g_Special[this.my_index].buy_num -= 1;
					g_Special[this.my_index].btn_Buy.txt_Num.text = "X" + g_Special[this.my_index].buy_num;
				}
			}

			this.btn_Add.my_index = this.my_index;
			this.btn_Add.onRelease = function()
			{
				if(g_Special[this.my_index].buy_num < 9)
				{
					g_Special[this.my_index].buy_num += 1;
					g_Special[this.my_index].btn_Buy.txt_Num.text = "X" + g_Special[this.my_index].buy_num;
				}
			}

			this.btn_Buy.my_index = this.my_index;
			this.btn_Buy.onRelease = function()
			{
				// trace("sp buy: " + this.my_index + "  num: " + g_Special[this.my_index].buy_num);
				fscommand("MCPurchaseClicked", "Special" + '\2' + this.my_index + '\2' + g_Special[this.my_index].buy_num);
			}

		}
	}

	for(var i = 0; i < g_Normal.length; ++i)
	{
		var normal = g_Normal[i];
		normal.my_index = i;
		normal.buy_num = 1;
		normal.btn_Buy.txt_Num.text = "X" + 1;
		normal.gotoAndPlay("opening_ani");
		normal.OnMoveInOver = function()
		{
			this.OnMoveInOver = undefined;

			this.btn_Minus.my_index = this.my_index;
			this.btn_Minus.onRelease = function()
			{
				if(g_Normal[this.my_index].buy_num > 1)
				{
					g_Normal[this.my_index].buy_num -= 1;
					g_Normal[this.my_index].btn_Buy.txt_Num.text = "X" + g_Normal[this.my_index].buy_num;
				}
			}

			this.btn_Add.my_index = this.my_index;
			this.btn_Add.onRelease = function()
			{
				if(g_Normal[this.my_index].buy_num < 9)
				{
					g_Normal[this.my_index].buy_num += 1;
					g_Normal[this.my_index].btn_Buy.txt_Num.text = "X" + g_Normal[this.my_index].buy_num;
				}
			}

			this.btn_Buy.my_index = this.my_index;
			this.btn_Buy.onRelease = function()
			{
				// trace("normal buy: " + this.my_index + "  num: " + g_Normal[this.my_index].buy_num);
				fscommand("MCPurchaseClicked", "Normal" + '\2' + this.my_index + '\2' + g_Normal[this.my_index].buy_num);
			}
		}
	}
}

function move_out_buy()
{
	for(var i = 0; i < g_Special.length; ++i)
	{
		var sp = g_Special[i];
		sp.gotoAndPlay("closing_ani");
		sp.OnMoveOutOver = function()
		{
			this.OnMoveOutOver = undefined;
			if(this.my_index == 0)
			{
				g_Buy._visible = false;
				if(g_switchState == "VIP")
				{
					g_TopBar.gotoAndPlay("switch1");
					move_in_vip();
				}
			}

			this.btn_Info.onRelease = undefined;
			this.btn_Minus.onRelease = undefined;
			this.btn_Add.onRelease = undefined;
			this.btn_Buy.onRelease = undefined;
		}
	}

	for(var i = 0; i < g_Normal.length; ++i)
	{
		var normal = g_Normal[i];
		normal.gotoAndPlay("closing_ani");
		normal.OnMoveOutOver = function()
		{
			this.OnMoveOutOver = undefined;

			this.btn_Minus.onRelease = undefined;
			this.btn_Add.onRelease = undefined;
			this.btn_Buy.onRelease = undefined;
		}
	}
}

function switch_state()
{
	if((not g_canSwitchState) or g_isSwitchState)
	{
		return;
	}

	if(g_switchState == "Buy")
	{
		g_isSwitchState = true;
		g_switchState = "VIP";

		ClearButtonFunctions();
		move_out_buy();
		// _root.g_TopBar.gotoAndPlay("switch1");
		// _root.move_in_vip();
	}
	else if(g_switchState == "VIP")
	{
		g_isSwitchState = true;
		g_switchState = "Buy";

		ClearButtonFunctions();
		move_out_vip();
		g_TopBar.gotoAndPlay("switch2");
	}
}

g_TopBar.OnSwitchOver = function()
{
	// if(g_switchState == "VIP")
	// {
	// 	_root.move_in_vip();
	// }
	// else if(g_switchState == "Buy")
	// {
	// 	_root.move_in_buy();
	// }
}


var g_Width = _root._width;
var k_DragRate = 0.5;
var k_DragFrameMax = 9;
g_Vip.onPress = function()
{
	// trace("onPress: " + _xmouse + "  " + _ymouse)
	this.is_clicked = true;
	this.startX = this._xmouse;
}

g_Vip.onMouseMove = function()
{
	if(this.is_clicked)
	{
		// trace("onMouseMove: " + _xmouse + "  " + _ymouse);
		var moved = (this._xmouse - this.startX) / g_Width;
		var oldMoveRate = g_vipMoveRate;
		g_vipMoveRate = moved / k_DragRate;
		
		var moveRate = g_vipMoveRate;

		if(moveRate < -0.02)
		{
			var skipFrame = -Math.floor((moveRate) * k_DragFrameMax);
			this.gotoAndStop("move_left");
			// trace("left: " + skipFrame + "  " + moveRate);
			for(var i = 0; i < skipFrame; ++i)
			{
				this.nextFrame();
			}
		}
		else if(moveRate > 0.02)
		{
			// var skipFrame = Math.floor((1.0 - ((moveRate - 0.5) * 2)) * _root.k_DragFrameMax);
			// this.gotoAndStop("move_left");
			var skipFrame = Math.floor((moveRate) * k_DragFrameMax);
			this.gotoAndStop("move_right");
			// trace("right: " + skipFrame + "  " + moveRate);
			for(var i = 0; i < skipFrame; ++i)
			{
				this.nextFrame();
			}
		}
		else
		{
			this.gotoAndStop("move_left");
		}

		if(moved < -0.0001)
		{
			if(Math.ceil(oldMoveRate) != Math.ceil(g_vipMoveRate))
			{
				OnVipDragMoved(true);
			}
		}
		else if(moved > 0.0001)
		{
			if(Math.floor(oldMoveRate) != Math.floor(g_vipMoveRate))
			{
				OnVipDragMoved(false);
			}
		}
	}
}

g_Vip.onRelease = function()
{
	// trace("onRelease: " + _xmouse + "  " + _ymouse)
	this.is_clicked = false;
	if(g_vipMoveRate < -0.5)
	{
		OnVipDragMoved(true);
	}
	else if(g_vipMoveRate > 0.5)
	{
		OnVipDragMoved(false);
	}
	g_vipMoveRate = 0;
	this.gotoAndStop("move_left");
}

g_Vip.onReleaseOutside = function()
{
	// trace("onReleaseOutside: " + _xmouse + "  " + _ymouse)
	this.is_clicked = false;
	if(g_vipMoveRate < -0.5)
	{
		OnVipDragMoved(true);
	}
	else if(g_vipMoveRate > 0.5)
	{
		OnVipDragMoved(false);
	}
	g_vipMoveRate = 0;
	this.gotoAndStop("move_left");
}

_root.btn_bg.onRelease = function()
{
}

function InitButtonFunctions()
{
	g_BackBtn.onRelease = function()
	{
		move_out();
		g_switchState = "";
	}

	g_ArrowBtn.onRelease = function()
	{
		switch_state();
	}
}

function ClearButtonFunctions()
{
	g_BackBtn.onRelease = undefined;
	g_ArrowBtn.onRelease = undefined;
}

function OnDragVipInfo()
{
	for(var i = 0; i < 5; ++i)
	{
		var infoId = (g_vipInfoStart + i) % g_VipInfos.length;
		g_VipObjects[i].detail.txt_Detail.text = g_VipInfos[infoId];

		if(i == 1)
		{
			g_Vip.content_1_2.detail.txt_Detail.text = g_VipInfos[infoId];
		}
		else if(i == 2)
		{
			g_Vip.content_2_1.detail.txt_Detail.text = g_VipInfos[infoId];
		}
		else if(i == 4)
		{
			g_Vip.content_4_3.detail.txt_Detail.text = g_VipInfos[infoId];
		}
	}
}

function OnVipDragMoved(isLeft : Boolean)
{
	if(isLeft)
	{
		g_vipInfoStart += 1;
		if(g_vipInfoStart >= g_VipInfos.length)
		{
			g_vipInfoStart = 0;
		}
		// trace("g_vipInfoStart: " + g_vipInfoStart);
		OnDragVipInfo();
	}
	else
	{
		g_vipInfoStart -= 1;
		if(g_vipInfoStart < 0)
		{
			g_vipInfoStart = g_VipInfos.length - 1;
		}
		// trace("g_vipInfoStart: " + g_vipInfoStart);
		OnDragVipInfo();
	}
}


//call from lua functions
function SetVipLevel(level : Number)
{
	if(level >= 1 and level <= 9)
	{
		g_VipLevel.gotoAndStop(level);
	}
}

function SetCredit(creditTxt)
{
	g_Credit.text = creditTxt;
}

function SetVipRequire(requireTxt)
{
	g_VipRequire.html = true;
	g_VipRequire.htmlText = requireTxt;
}

function SetVipInfo(infos)
{
	g_VipInfos = [];
	for(var i = 0; i < infos.length; ++i)
	{
		g_VipInfos.push(infos[i]);
	}
	OnDragVipInfo();
}


function SetSpecialBuyInfo(infos)
{
	for(var i = 0; i < g_Special.length; ++i)
	{
		var obj = g_Special[i];
		var info = infos[i];

		obj.Category.txt_Category.text = info[0];
		obj.Num.txt_Num.text = info[1];
		obj.Num.txt_Game.text = info[2];
		if(obj.frame != undefined and obj.frame.icons == undefined)
		{
			obj.frame.loadMovie("CommonIcons.swf");
		}
		obj.frame.icons.gotoAndStop(info[3]);
		obj.btn_Buy.txt_Price.text = info[4];

		var _index = 5;
		var effectObjs = [obj.effects.icon_0, obj.effects.icon_1, obj.effects.icon_2, obj.effects.icon_3];
		for(var j = 0; j < 4; ++j)
		{
			effectObjs[j].icons.gotoAndStop(info[_index]);
			++_index;
			effectObjs[j].txt_Point.text = info[_index];
			++_index;
		}
	}
}

function SetNormalBuyInfo(infos)
{
	for(var i = 0; i < g_Normal.length; ++i)
	{
		var obj = g_Normal[i];
		var info = infos[i];

		obj.Title.txt_Title.text = info[0];
		obj.Num.txt_Num.text = info[1];
		// if(obj.frame != undefined and obj.frame.icons == undefined)
		// {
		// 	obj.frame.loadMovie("CommonIcons.swf");
		// 	obj.frame.icons.gotoAndStop(info[2]);
		// }
		obj.btn_Buy.txt_Price.text = info[3];
	}
}