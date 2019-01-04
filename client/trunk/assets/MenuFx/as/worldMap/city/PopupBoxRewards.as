var MainUI = _root.mainUI;

var CloseBtn = MainUI.btn_close;
var curSelectIcon = undefined;

_root.onLoad = function()
{
	/*var datas = new Object();
	datas.state = false;
	datas.awards_data = new Array();

	var award = new Object();
	award.num = 28;
	var IconDatas = new Object();
	IconDatas.icon_index = 106;
	IconDatas.res_type = "item";
	IconDatas.icon_quality = 1;
	award.icon_data = IconDatas;
	datas.awards_data.push(award);

	InitData(datas);*/
}

MainUI.content_btn.onRelease = function()
{

}

CloseBtn.onRelease = MainUI.bg_btn.onRelease  = function()
{
	MainUI.gotoAndPlay("closing_ani");
	MainUI.bg_btn.gotoAndPlay("closing_ani");
}

MainUI.OnMoveOutOver = function()
{
	fscommand("GoToNext","CloseBoxAward");
}

function SetAwardIcon(mc, icon_data)
{
	if (mc.item_icon.icons == undefined)
	{
		var w = mc.item_icon._width;
		var h = mc.item_icon._height;
		mc.item_icon.loadMovie("CommonIcons.swf");
		mc.item_icon._width = w;
		mc.item_icon._height = h;
	}
	mc.item_icon.IconData = icon_data;
	if(mc.item_icon.UpdateIcon)
	{ 
		mc.item_icon.UpdateIcon(); 
	}
	mc.item_icon.onRelease = function()
	{
		if (curSelectIcon)
		{
			//curSelectIcon.SelectIcon(false);
		}
		curSelectIcon = this;
		//this.SelectIcon(true);
		fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.IconData.res_type + "\2" + this.IconData.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
	}
}

function SetItemInfo(mc, data)
{
	if (data == undefined)
	{
		mc.num_bg._visible 	= false;
		mc.item_num._visible = false;
		return
	}
	mc.bg._visible = false;
	if (data.num == undefined)
	{
		data.num = data.count;
	}
	if (data.num == 1)
	{
		mc.num_bg._visible 	= false;
		mc.item_num._visible = false;
	}else
	{
		mc.item_num.text = data.num;
	}
	SetAwardIcon(mc, data.icon_data);
}

function InitData(datas)
{
	MainUI.content.state._visible = datas.state;
	var awards_content = MainUI.content;
	for (var i = 0; i < 8; ++i)
	{
		SetItemInfo(awards_content["award" + i], datas.awards_data[i]);
	}

}