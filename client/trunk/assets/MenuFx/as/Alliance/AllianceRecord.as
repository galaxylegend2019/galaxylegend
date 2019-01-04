var MainUI = _root.main_ui;

var CloseBtn = MainUI.top.btn_close;

var TopUI = MainUI.top

var RecordList = MainUI.list_content.view_list;

var RecordDatas = undefined;

var SildeBar 	= MainUI.list_content.sidebar;

var SildeHeight = SildeBar.cloumn._height;

var ItemPerHeight = 0;

var StartOffset = 0;

var CurSildeMc 	= undefined;

var CurBaseHeight 	= 0;



var FisrtShowMc 	= undefined;
var LastShowMc 		= undefined;
var ShowLength 		= 0;

this.onLoad = function()
{
	MainUI.top.gotoAndPlay("opening_ani");
	MainUI.bg1.gotoAndPlay("opening_ani");
	MainUI.gotoAndPlay("opening_ani");
}

MainUI.OnMoveInOver = function()
{
	//Test();
}

MainUI.OnMoveOutOver = function()
{
	fscommand("GoToNext", "BackToAllianceMain")
}

CloseBtn.onRelease = function()
{

	MainUI.top.gotoAndPlay("closing_ani");
	MainUI.bg1.gotoAndPlay("closing_ani");
	MainUI.gotoAndPlay("closing_ani");
}


function Test()
{
	var Datas = new Array(20);
	InitRecordList(Datas);
}



function InitRecordList( datas )
{
	RecordDatas = datas;
	if (RecordDatas == undefined)
	{
		return;
	}
	RecordList.clearListBox();
	RecordList.initListBox("item_list_1", 0, true, true);
	RecordList.enableDrag(true);
	RecordList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	//StartOffset = Math.ceil(RecordList.m_panelHeight / RecordList.m_itemHeight) + 3;
	StartOffset = 10;

	RecordList.onItemEnter = function(mc, index_item)
	{
		mc._visible = true;
		index_item = index_item - 1;
		SetRecordItemInfo(mc, index_item);
		//trace("-----------onItemEnter----------" + index_item);
		UpdateFirstAndLastShowMc();
	}

/*	RecordList.onItemMCCreate 	= undefined;
	RecordList.onListBoxMove 	= undefined;
	RecordList.onItemLeave 		= undefined;*/

	RecordList.onItemMCCreate 	= undefined;
	RecordList.onListboxMove 	= function()
	{
		//trace("1111");
		UpdateFirstAndLastShowMc();
	}
	RecordList.onItemLeave 		= function(mc, index_item)
	{
		//trace("-----------onItemLeave----------" + index_item);
		

	}
	for (var i = 1; i <= RecordDatas.length; ++i)
	{
		RecordList.addListItem(i, false, false);
	}
}

function SetRecordItemInfo(mc, index_item)
{
	var data = RecordDatas[index_item];
	var HeadIcon 	= mc.head_icon;
	var DescTxt 	= mc.desc_txt;
	var TimeTxt 	= mc.time_txt;
	mc.index_item = index_item;

	if (HeadIcon.item_icon.icons == undefined)
	{
		var h = HeadIcon.item_icon._height;
		var w = HeadIcon.item_icon._width;
		HeadIcon.item_icon.loadMovie("CommonPlayerIcons.swf");
		HeadIcon.item_icon._height = h;
		HeadIcon.item_icon._width  = w;
	}

	HeadIcon.item_icon.IconData = data.playerIcon;
	if(HeadIcon.item_icon.UpdateIcon)
	{ 
		HeadIcon.item_icon.UpdateIcon(); 
	}

	if (data.type == 1 or data.type == 2 or data.type == 3)
	{
		DescTxt.text = data.player_name + data.desc;
		TimeTxt.text = GetTimeText(data.time);
	}
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

	mc.onRelease = function()
	{
		
		this._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			//trace("--------------click---------------index=" + index_item + "---mc=" + this);
			
		}
	}


}

function UpdateRecordList( datas )
{
	RecordDatas = datas;
	RecordList.needUpdateVisibleItem();
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

this.onEnterFrame = function()
{
	
	
}

function xxx()
{
	if (LastShowMc.index_item >= StartOffset and LastShowMc.index_item < RecordDatas.length - 1)
	{
		//trace(LastShowMc._y);	
		var height = SildeHeight / (RecordDatas.length - StartOffset) / 58 * (LastShowMc._y - 495);
		height = CurBaseHeight - height;
		if (height < 0)
		{
			height = 0;
		}else if (height > SildeHeight)
		{
			height = SildeHeight;
		}
		SildeBar.progress._y = height;
	}else
	{
	
	}
}

function FixPosition()
{
	RecordList._regetFirstAndLastVisibleItemMC();
	if (RecordList.isReachHeadLimit())
	{
		//trace("****1111******isReachHeadLimit************");
		SildeBar.progress._y = 0;
	}
	if (RecordList.isReachTailLimit())
	{
		//trace("****2222******isReachTailLimit************");
		SildeBar.progress._y = SildeHeight;
	}
}

function UpdateFirstAndLastShowMc()
{
	if (RecordDatas.length < StartOffset)
	{
		return;
	}

	//trace("***************************************");
	FisrtShowMc  = RecordList.getFirstVisibleItemMC()
	//trace("------------firstMc=" + FisrtShowMc.index_item);
	LastShowMc = RecordList.getLastVisibleItemMC();
	//trace("------------lastMc=" + LastShowMc.index_item);
	//ShowLength = RecordList.getItemListLength();
	//trace("------------listLength=" + ShowLength);
	//trace("***************************************");

	var height = SildeHeight / (RecordDatas.length - StartOffset) * (LastShowMc.index_item + 1 - 10);
	if (height < 0)
	{
		SildeBar.progress._y = 0;
		return;
	}
	if (height > SildeHeight)
	{
		height = SildeHeight;
	}
	CurBaseHeight = height;
	SildeBar.progress._y = height;
	//trace("---------------=" + height)
	/*trace("----SildeHeight=" + SildeHeight);
	trace("----RecordDatas.length=" + RecordDatas.length);
	trace("----StartOffset=" + StartOffset);
	trace("----LastShowMc.index_item=" + LastShowMc.index_item);*/
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
