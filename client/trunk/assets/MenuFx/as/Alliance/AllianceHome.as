import com.tap4fun.utils.Utils;
import common.CTextEdit;

//top
var TopUI = _root.main_ui.top_bar;
//get operate lable
var MainUI 				= _root.main_ui;
var MainContent			= MainUI.all_content
var CloseBtn 			= MainUI.top_bar.btn_close;

var JoinAllianceSwitchBtn 		= MainContent.join_btn;
var CreateAllianceSwitchBtn 	= MainContent.create_btn;

//select alliance join panel
var SearchBtn 			= MainContent.alliance_content.join_content.search_btn;
var AllianceJoinList 	= MainContent.alliance_content.join_content.alliance_list.view_list;
var SearchInput 		= MainContent.alliance_content.join_content.search_text.search_input;

//create alliance panel
var AllianceIcon 		= MainContent.alliance_content.create_content.item_icon;
var CreateAllianceBtn 	= MainContent.alliance_content.create_content.create_btn;
var SelectIconBtn 		= MainContent.alliance_content.create_content.select_icon_btn;
var NameInput 			= MainContent.alliance_content.create_content.alliance_name.name_input;
var DescInput 			= MainContent.alliance_content.create_content.alliance_desc.desc_input;

var AllianceDatas 		= undefined;
var AllDatas 			= undefined;

var CurIcon 			= undefined;

var LoaclTexts 			= undefined;

var isEmpty 			= true;

var JoinSucceed 		= false;

this.onLoad = function()
{
	//play opening_ani
    MainUI.gotoAndPlay("opening_ani");
    TopUI.gotoAndPlay("opening_ani");
    //defalut select
	SetSwitchBtn(JoinAllianceSwitchBtn);
}

JoinAllianceSwitchBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_selection_2");
	SetSwitchBtn(JoinAllianceSwitchBtn);
}

CreateAllianceSwitchBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_selection_2");
	SetSwitchBtn(CreateAllianceSwitchBtn);
}

CloseBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_cancel");
    MainUI.gotoAndPlay("closing_ani");
    TopUI.gotoAndPlay("closing_ani")
}

MainUI.OnMoveInOver = function()
{
	MainUI.stop();
}

MainUI.OnMoveOutOver = function()
{
	MainUI.stop();
	if (JoinSucceed)
	{
		fscommand("AllianceCommand", "GotoMainUI")
	}else
	{
		fscommand("GotoNextMenu", "GS_MainMenu");
	}
	
}

function ClosePanel()
{
	JoinSucceed = true
    MainUI.gotoAndPlay("closing_ani");
    TopUI.gotoAndPlay("closing_ani")
}

function InitPanel(texts)
{
	LoaclTexts = texts;
	InitSearchInput();
	InitCreatePanel();
}

function InitSearchInput()
{
	SearchInput.init("ASCIICapable", "FlashAllianceHomeUI", "hitzone", "", "content_txt", true, false, '', null, null, null, null, true);
	SearchInput.setMaxLength(12);
	SearchInput.lua2fs_setText(LoaclTexts.SearchDefaultText);
	SearchInput.onTextChange = function()
	{
		var searchName = SearchInput.getInputString();
		if (searchName == "" and not isEmpty)
		{
			InitJoinList(AllDatas, true);
			isEmpty = true;
		}else
		{
			isEmpty = false;
		}
	}
	var JoinContent  = MainContent.alliance_content.join_content;
	JoinContent.posY = JoinContent._y;
	SearchInput.onChangeKeyBoardHeight = function()
	{
		var JoinContent  = MainContent.alliance_content.join_content;
		JoinContent._y = JoinContent.posY - SearchInput.GetHeightChange();
	}

	SearchBtn.onRelease = function()
	{
		fscommand("PlaySound","sfx_ui_selection_1");
		if (isEmpty)
		{
			return;
		}
		var allianceName = SearchInput.getInputString();
		if (allianceName == "")
		{
			return;
		}
		//AllianceJoinList.clearListBox();
		fscommand("AllianceCommand", "SearchAlliance" + "\2" + allianceName);
	}
}

function ShowSearchList(data)
{
	InitJoinList(data, true)
}

function SetSelectTitleShow( isShow )
{
	CreateAllianceSwitchBtn._visible = isShow;
	JoinAllianceSwitchBtn._visible = isShow;
}

function InitCreatePanel()
{
	//NameInput.init("ASCIICapable", "FlashAllianceHomeUI", "hitzone", "", "content_txt", true, false, LoaclTexts.InputNameDefaultText, null, null, null, null, true);
	NameInput.init("ASCIICapable", "FlashAllianceHomeUI", "hitzone", "", "content_txt", true, false, '', null, null, null, null, true);
	NameInput.setMaxLength(8);
	
	var CreateContent  = MainContent.alliance_content.create_content;
	CreateContent.posY = CreateContent._y;
	NameInput.onChangeKeyBoardHeight = function()
	{

		var CreateContent  = MainContent.alliance_content.create_content;
		CreateContent._y = CreateContent.posY - NameInput.GetHeightChange();
	}

	var NameEditBtn 	= MainContent.alliance_content.create_content.alliance_name.edit_btn;
	var DescEditBtn 	= MainContent.alliance_content.create_content.alliance_desc.edit_btn;
	NameEditBtn.onRelease = function()
	{
		NameInput.hitzone.onRelease();
	}

	DescEditBtn.onRelease = function()
	{
		DescInput.hitzone.onRelease();
	}

    DescInput.init("ASCIICapable", "FlashAllianceHomeUI", "hitzone", "", "LC_UI_Alliance_Description_info", true, false, LoaclTexts.InputDescDefalutText, "TextView", null, null, null, true);
	DescInput.setMaxLength(100);
	//NameInput.lua2fs_setText(LoaclTexts.InputNameDefaultText);
	//DescInput.lua2fs_setText(LoaclTexts.InputDescDefalutText);

	//keyboard
	DescInput.onChangeKeyBoardHeight = function()
	{
		var CreateContent  = MainContent.alliance_content.create_content;
		CreateContent._y = CreateContent.posY - DescInput.GetHeightChange();
	}

	NameInput.onShowKeyboard = DescInput.onShowKeyboard = function()
	{
		SetSelectTitleShow(false);
	}
	NameInput.onHideKeyboard = DescInput.onHideKeyboard = function()
	{
		SetSelectTitleShow(true);
	}

	SetAllianceIcon("item_2001");
}

function SetAllianceIcon( strIcon )
{	
	var IconMc = MainContent.alliance_content.create_content;
	CurIcon = strIcon;
    var width = IconMc.item_icon._width;
    var height = IconMc.item_icon._height;
	if (IconMc.item_icon.icons == undefined)
	{
        IconMc.item_icon.loadMovie("AllianceIcon.swf");
	}

    IconMc.item_icon._width = width;
    IconMc.item_icon._height = height;
    IconMc.item_icon.icons.gotoAndStop(CurIcon);
    SelectIconBtn.onRelease = IconMc.item_icon.onRelease = function()
	{
		fscommand("PlaySound","sfx_ui_selection_1");
		fscommand("AllianceCommand","OpenSelectIconUI")
	}
}

CreateAllianceBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_selection_1");
	var strName = NameInput.getInputString();
	var strDesc = DescInput.getInputString();
	fscommand("AllianceCommand", "CreateAllianceBtn" + "\2" + strName + "\2" + strDesc + "\2" + CurIcon);
}

function SetCreateAllianceMoney( create_money )
{
	CreateAllianceBtn.txt_Price.text = create_money;
}

function InitJoinList(datas, isAsCall)
{
	if (not isAsCall)
	{
		AllDatas = datas;
	}
	AllianceDatas = datas;
	
	if (undefined == AllianceDatas)
	{
		return;
	}
	AllianceJoinList.clearListBox();
	AllianceJoinList.initListBox("item_alliance_list",0,true,true);
	AllianceJoinList.enableDrag( true );
	AllianceJoinList.onEnterFrame = function(){
		this.OnUpdate();
	}
	AllianceJoinList.onItemEnter = function(mc,index_item)
	{
		mc._visible=true;
		index_item = index_item - 1;
		SetItemInfo(mc, index_item);
		if (isEmpty)
		{
			if (index_item >= AllianceDatas.length - 1)
			{
				fscommand("AllianceCommand", "RquestAllianceList");
			}
		} 
		
	}
	AllianceJoinList.onItemMCCreate = undefined;
	AllianceJoinList.onListboxMove = undefined;

	for( var i = 1; i <= AllianceDatas.length; i++ )
	{   
	    var temp = AllianceJoinList.addListItem(i, false, false);
	}
}

function SetItemInfo(mc, Index)
{
	var info = AllianceDatas[Index];
	//Set Rank Nuber
    // SetNumber(mc.rank_num, info.rank);
    mc.rank_num.rank_text.text = info.rank;
	var curBtn = SetJoinBtnState(mc.join_opt, info);

	SetListIcon(mc, info.icon);
	SetLableInfo(mc, info);
	curBtn.onPress = function()
	{
		this._parent._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}
	curBtn.Index = Index;
	curBtn.onRelease = function()
	{
		this._parent._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			//deal click
			var nID = AllianceDatas[this.Index].id;
			fscommand("AllianceCommand", "ClickJoinBtn" + "\2" + nID);
		}
	}
	curBtn.onReleaseOutside = function()
	{
		this._parent._parent._parent.onReleasedInListbox();
	}
	
}

function SetLimitText(mc, i,desc_u8 ,desc)
{
	while(true)
	{	
		if (desc_u8[i] == undefined)
		{
			break;
		}
		desc = desc + desc_u8[i];
		mc.text = desc;
		if (mc.textWidth >= mc._width - 10)
		{
			desc = desc + "......";
			mc.text = desc;
			break;
		}
		i = i + 1;
	}
}

function SetLableInfo(mc, info)
{
	mc.lv_txt.text = info.level.toString();
	mc.name_txt.text = info.name;
	mc.capacity_txt.text = info.cur_member + "/" + info.max_member;
	/*var i = 0;
	var desc = "";
	while(true)
	{	
		if (info.desc_u8[i] == undefined)
		{
			break;
		}
		desc = desc + info.desc_u8[i];
		mc.desc_content.desc_txt.text = desc;
		if (mc.desc_content.desc_txt.textWidth >= 580)
		{
			desc = desc + "......"
			mc.desc_content.desc_txt.text = desc;
			break;
		}
		i = i + 1;
	}*/
	var desc = "";
	for(var i = 0; i < 30; i++)
	{
		desc = desc + info.desc_u8[i];
	}
	SetLimitText(mc.desc_content.desc_txt, 30,info.desc_u8 ,desc);
	trace("---------------x=" + mc.desc_content.desc_txt.textWidth);
}

function SetListIcon(mc, icon_name)
{
	if (mc.item_icon.icons == undefined)
    {
        var w = mc.item_icon._width;
        var h = mc.item_icon._height;
        mc.item_icon.loadMovie("AllianceIcon.swf");
        mc.item_icon._width = w;
        mc.item_icon._height = h;
	}
    mc.item_icon.icons.gotoAndStop(icon_name);
}

function SetJoinBtnState(mc, info)
{
	if (mc == undefined)
	{
		return;
	}
	var retBtn = undefined;
	if (info.state == 3) //dont apply
	{
		if (info.limit.type == 0) // 0:Dont limit, 1:vip limit ,2: power limit, 3:player level limit 
		{
			
			mc.direct_btn._visible 	= true;
			mc.join_btn._visible 	= false;
			mc.cancel_btn._visible 	= false;
			mc.LC_UI_Alliance_Limit_Type.text = "";
			mc.need_lv_txt.text = "";
			mc.BtnState = 3;
			retBtn = mc.direct_btn;
		}else
		{
			mc.direct_btn._visible 	= false;
			mc.join_btn._visible 	= true;
			mc.cancel_btn._visible 	= false;

			mc.BtnState = 1;
			retBtn = mc.join_btn;
			
			//set ask for level
			//mc.LC_UI_Alliance_Limit_Type.text = "";
			if (info.limit.type == 2)
			{
				mc.LC_UI_Alliance_Limit_Type.text = LoaclTexts.NeedPowerNumText;
			}else if (info.limit.type == 3)
			{
				mc.LC_UI_Alliance_Limit_Type.text = LoaclTexts.NeedPlayerLevelText;
			}
			mc.need_lv_txt.text = String(info.limit.value);
		}
	}else if (info.state == 2)	//have apply
	{
		//mc.LC_UI_Alliance_Limit_Type.text = "";
		mc.direct_btn._visible 	= false;
		mc.join_btn._visible 	= false;
		mc.cancel_btn._visible 	= true;

		mc.BtnState = 2;
		retBtn = mc.cancel_btn;
		mc.need_lv_txt.text = String(info.limit.value);
		if (info.limit.type == 2)
		{
			mc.LC_UI_Alliance_Limit_Type.text = LoaclTexts.NeedPowerNumText;
		}else if (info.limit.type == 3)
		{
			mc.LC_UI_Alliance_Limit_Type.text = LoaclTexts.NeedPlayerLevelText;
		}
	}
	return retBtn;
}

function SetSwitchBtn(focusBtn)
{
	
	switch(focusBtn._name)
	{
		case "join_btn":

			JoinAllianceSwitchBtn.gotoAndStop("show_focus");
			CreateAllianceSwitchBtn.gotoAndStop("hide_focus");
			MainContent.alliance_content.create_content._visible = false;
			MainContent.alliance_content.join_content._visible = true;
			/*if (MainContent.alliance_content.join_content.bOpen == undefined)
			{
				InitSearchInput();
				trace("---------InitJoinList------------");
			}
			MainContent.alliance_content.join_content.bOpen = true;*/
		break;
		case "create_btn":
			CreateAllianceSwitchBtn.gotoAndStop("show_focus");
			JoinAllianceSwitchBtn.gotoAndStop("hide_focus");
			MainContent.alliance_content.create_content._visible = true;
			MainContent.alliance_content.join_content._visible = false;
			/*if (MainContent.alliance_content.create_content.bOpen == undefined)
			{
				trace("---------InitCreatePanel------------");
				InitCreatePanel();
				
			}
			MainContent.alliance_content.create_content.bOpen = true;*/
			
		break;
		default:
		trace("input focusBtn error!");
		break;
	}
}

function SetNumber(mc, number)
{
	if (undefined == mc or undefined == number)
	{
		trace("SetNumber Failed!");
		return;
	}
	if (0 > number or 999 < number)
	{
		trace("number range error! number=" + number);
		return;
	}

	var arrayMc = new Array(mc.r_0, mc.r_1, mc.r_2);
	for (var i = 0; i < arrayMc.length; i++)
	{
		arrayMc[i]._visible = false;
	}
	var nIndex = 0;
	var temp = Math.floor(number / 100);
	if (0 != temp)
	{
		arrayMc[nIndex]._visible = true;
		arrayMc[nIndex].gotoAndStop(temp + 1);
		++nIndex;
	}
	temp = Math.floor(number / 10);
	if (0 != temp)
	{
		arrayMc[nIndex]._visible = true;
		temp = temp % 10;
		arrayMc[nIndex].gotoAndStop(temp + 1);
		++nIndex;
	}
	arrayMc[nIndex]._visible = true;
	temp = number % 10;
	arrayMc[nIndex].gotoAndStop(temp + 1);
}

function UpdateListInfoState( datas )
{
	AllDatas = datas;
	AllianceDatas = datas;
	AllianceJoinList.needUpdateVisibleItem();
}

//update search list
function UpdateSearchListState( data )
{
	for(var i in AllianceDatas)
	{
		if (AllianceDatas[i].id == data.id)
		{
			AllianceDatas[i] = data;
			break;
		}
	}

	for(var i in AllDatas)
	{
		if (AllDatas[i].id == data.id)
		{
			AllDatas[i] = data;
			break;
		}
	}

	AllianceJoinList.needUpdateVisibleItem();
}

function UpdateListInfoNum(datas)
{
	if (datas.length > AllDatas.length)
	{
		for(var i = AllDatas.length; i < datas.length; ++i)
		{
			AllianceJoinList.addListItem(i + 1, false, false);
		}
	}
	AllDatas = datas;
	AllianceDatas = AllDatas;
	AllianceJoinList.needUpdateVisibleItem();
}
function OnlyUpdateAllDatas(datas)
{
	AllDatas = datas;
}


function UpdateMoneyAndCredit(datas)
{
    trace("9099999999999999999999999999")
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