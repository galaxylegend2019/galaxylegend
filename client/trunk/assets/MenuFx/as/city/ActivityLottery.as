
var MainUI 		= _root.ui_all;

var CloseBtn 	= MainUI.btn_close;
var StartBtn 	= MainUI.btn_start;

var LotteryUI 	= MainUI.lottery;
var AllItem 	= LotteryUI.all_item;

var LotteryDatas 	= undefined;
var GetAwardData 	= undefined;

var isLotterying  	= false; 

this.onLoad = function()
{
	AllItem._visible = false;
}

MainUI.btn_bg.onRelease = CloseBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_cancel");
	MainUI.gotoAndPlay("closing_ani");

}

MainUI.OnMoveOutOver = function()
{
	fscommand("GoToNext","BackToActivity");
}

StartBtn.onRelease = function()
{
	if (isLotterying)
	{
		fscommand("PlaySound","sfx_ui_warning");
		return;
	}
	if (LotteryDatas.times > 0)
	{
		fscommand("PlaySound","sfx_ui_selection_1");
	}else
	{
		fscommand("PlaySound","sfx_ui_warning");
	}
	fscommand("CityActivityCmd", "StartLottery" + "\2" + LotteryDatas.times);
}

LotteryUI.TakeOutCallBack = function()
{
	SetAwardIcon("item_18", GetAwardData.icon_data);
}

LotteryUI.TakeOutOver = function()
{
	AllItem.gotoAndPlay("show");
}

AllItem.ItemShowOver = function()
{
	fscommand("CityActivityCmd", "ShowGetAward");
	isLotterying = false;
}


function RandomAwardsData( datas )
{
	for (var i in datas.awards)
	{
		 var R = Math.floor(Math.random() * 10);
		 if (R >= datas.awards.length)
		 {
		 	R = R - datas.awards.length;
		 }
		 var temp = datas.awards[i];
		 datas.awards[i] = datas.awards[R];
		 datas.awards[R] = temp;
	}
}

function InitData(datas)
{
	AllItem._visible = true;
	AllItem.gotoAndStop(1);
	LotteryDatas = datas;
	if (LotteryDatas == undefined)
	{
		return;
	}
	MainUI.state.times_txt.text = LotteryDatas.times;

	RandomAwardsData(LotteryDatas)

	var n = datas.awards.length - 1;
	var j = 0;
	for(var i = 0; i < 20; ++i)
	{
		if (i % n == 0)
		{
			j = 0;
		}
		var award = datas.awards[j];
		
		SetAwardIcon("item_" + i, award.icon_data);
		j++;
	}
}

function SetAwardIcon(item, icon_data)
{
	//var itemMc = AllItem[item];
	trace("-------" + icon_data.icon_index);
	if (AllItem[item].icons == undefined)
	{
		var w = AllItem[item]._width;
		var h = AllItem[item]._height;
		AllItem[item].loadMovie("CommonIcons.swf");
		AllItem[item]._width = w;
		AllItem[item]._height = h;
	}
	AllItem[item].IconData = icon_data;
	if(AllItem[item].UpdateIcon)
	{ 
		AllItem[item].UpdateIcon(); 
	}
}

function StartLottery( award )
{

	GetAwardData = award;
	LotteryUI.gotoAndPlay("play");
	isLotterying = true;
}