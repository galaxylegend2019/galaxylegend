
var MainUI = _root.main_ui;
var CloseBtn 	= MainUI.top.btn_close;
var ListTitle 	= MainUI.list_content.list_title;
var ApplyList 	= MainUI.list_content.view_list;
var TopUI = MainUI.top
var ApplayDatas = new Object();

this.onLoad = function()
{
    MainUI.gotoAndPlay("opening_ani");
    TopUI.gotoAndPlay("opening_ani");
}

MainUI.OnMoveInOver = function()
{
	this.stop();
}

MainUI.OnMoveOutOver = function()
{
	this.stop();
	//update member panel
	fscommand("AllianceMainCmd","ReqPanelData" +"\2"+"1");
	fscommand("GoToNext", "BackToAllianceMain")
}

CloseBtn.onPress = function()
{
    MainUI.gotoAndPlay("closing_ani");
    TopUI.gotoAndPlay("closing_ani");
}

function InitApplyPanel( datas )
{
	ApplayDatas = datas;
	if (ApplayDatas == undefined)
	{
		return;
	}
	InitApplyList();
}


function InitApplyList()
{
	ApplyList.clearListBox();
	if (ApplayDatas.canHandle)
	{
		ListTitle.gotoAndStop(1);
		ApplyList.initListBox("item_list_2", 0, true, true);
	}else
	{
		ListTitle.gotoAndStop(2);
		ApplyList.initListBox("item_list_1", 0, true, true);
	}
	
	ApplyList.enableDrag(true);
	ApplyList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ApplyList.onItemEnter = function(mc, index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetApplyItemInfo(mc, index_item);
	}
	ApplyList.onListboxMove = undefined;
	ApplyList.onItemMCCreate = undefined;
	ApplyList.onItemLeave = undefined;

	for (var i = 1 ; i <= ApplayDatas.infos.length; ++i)
	{
		ApplyList.addListItem(i, false, false);
	}
}

function SetApplyItemInfo(mc, index_item)
{
	var data = ApplayDatas.infos[index_item]
	mc.data = data
	if (ApplayDatas.canHandle)
	{
		mc.allow_btn.onPress = function()
		{
			this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		mc.allow_btn.onReleaseOutside = function()
		{
			this._parent._parent.onReleasedInListbox();
		}

		mc.allow_btn.onRelease = function()
		{
			
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				fscommand("AllianceMainCmd", "AllowApply" + "\2" + this._parent.data.player_id);
			}
		}

		mc.not_allow_btn.onPress = function()
		{
			this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		mc.not_allow_btn.onReleaseOutside = function()
		{
			this._parent._parent.onReleasedInListbox();
		}

		mc.not_allow_btn.onRelease = function()
		{
			
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				fscommand("AllianceMainCmd", "RefuseApply" + "\2" + this._parent.data.player_id);
			}
		}
	}
	mc.name_txt.text 		= data.name;
	mc.level_txt.text 		= data.level;
	mc.vip_txt.text 		= data.vip;
	mc.start_time_txt.text 	= GetTimeText(data.apply_time)
	mc.end_time_txt.text 	= GetTimeText(data.valid_time)
	SetRankNum(mc.power_num, data.rank)
}


function UpdateListInfo(datas)
{
	if(datas.infos.length > ApplayDatas.infos.length)
	{

		for(var i = ApplayDatas.infos.length; i < datas.infos.length; i++)
		{
			ApplyList.addListItem(i + 1, false, false);	
		}
	}else if(datas.infos.length < ApplayDatas.infos.length)
	{
		for(var i = datas.infos.length; i < ApplayDatas.infos.length; i++)
		{
			ApplyList.eraseItem(i + 1);	
		}
	}
	ApplayDatas = datas;
	ApplyList.needUpdateVisibleItem();
}

function GetTimeText(time)
{
	//time = time / 1000;
/*	var year 	= Math.floor(time / (365 * 24 * 3600));
	time = time - (year * 365 * 24 * 3600);
	var month  	= Math.floor(time / (30 * 24 * 3600));
	time = time - (month * 30 * 24 * 3600);
	var day 	= Math.floor(time / (24 * 3600));
	time = time - (day * 24 * 3600);
	var hour 	= Math.floor(time / 3600);
	time = time - (hour * 3600);
	var minutes	= Math.floor(time / 60);*/

	var seconed = time % 60;
	time = Math.floor(time / 60);

	var minutes = time % 60;
	time = Math.floor(time / 60);

	var hour = time % 60;
	time = Math.floor(time / 60);

	var day = time % 24;
	time = Math.floor(time / 24);

	var month = time % 30;
	time = Math.floor(time / 30);

	var year = time

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


function UpdateMoneyAndCredit(datas)
{
    trace("\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\")
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
