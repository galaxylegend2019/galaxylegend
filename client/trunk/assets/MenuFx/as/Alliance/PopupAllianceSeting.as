
var MainUI = _root.item_origin_page.pop_content;

var CloseBtn = _root.item_origin_page.page_cover_btn;

var AllianceIcon 	= MainUI.item_origin;

var TypeSelect 		= MainUI.item_origin.type_select
var PullDownBtn 	= TypeSelect.pull_down_btn;

var ValueSet 		= MainUI.item_origin.value_set;
var ReduceBtn 		= ValueSet.btn_reduce;
var AddBtn 			= ValueSet.btn_add;
var SetNumberInput 	= ValueSet.item_num;

var SetOkBtn 		= MainUI.item_origin.set_ok_btn;

var SetDatas 		= undefined;

var isPullDown 		= false;

var CurType 		= 0;
var CurValue 		= 1;

var LocalTexts 		= undefined;
var CurIcon			= "";

_root.onLoad = function()
{
	MainUI.gotoAndPlay("opening_ani");
}

MainUI.OnMoveOutOver = function()
{
	fscommand("GoToNext", "BackToAllianceMain");
}

MainUI.OnMoveInOver = function()
{
}

MainUI.bg_btn.onRelease = function()
{
    fscommand("PlaySound","sfx_ui_cancel");
    MainUI.gotoAndPlay("closing_ani");
}



TypeSelect.cur_select_txt.onRelease = TypeSelect.pull_down_btn.onRelease = function()
{
	if (isPullDown)
	{
		TypeSelect.gotoAndPlay("pull_up_ani");
		TypeSelect.pull_down_btn.gotoAndStop(1);
	}else
	{
		TypeSelect.gotoAndPlay("pull_down_ani");
		TypeSelect.pull_down_btn.gotoAndStop(2);
	}
}

TypeSelect.PullDownOver = function()
{
	isPullDown = true;


	/*TypeSelect.select_list.btn_bg.onRelease = function()
	{
	}*/

	TypeSelect.select_list.type_0.none_verify_txt.text 	= LocalTexts.DontVerifyText;
	TypeSelect.select_list.type_3.need_level_txt.text 	= LocalTexts.NeedPlayerLevelText;
	TypeSelect.select_list.type_2.need_power_txt.text 	= LocalTexts.NeedPowerNumText;
	TypeSelect.select_list.type_0.onRelease = function()
	{
		TypeSelect.gotoAndPlay("pull_up_ani");
		TypeSelect.pull_down_btn.gotoAndStop(1);
		SetVerifyInfo(0);
	}

	TypeSelect.select_list.type_2.onRelease = function()
	{
		TypeSelect.gotoAndPlay("pull_up_ani");
		TypeSelect.pull_down_btn.gotoAndStop(1);
		SetVerifyInfo(2);
	}

	TypeSelect.select_list.type_3.onRelease = function()
	{
		TypeSelect.gotoAndPlay("pull_up_ani");
		TypeSelect.pull_down_btn.gotoAndStop(1);
		SetVerifyInfo(3);
	}
}

function SetVerifyInfo( type ,value)
{
	if (value == undefined)
	{
		value = 1;
	}
	CurType = type;
	switch(type)
	{
		case 0:
			ValueSet._visible = false;
			TypeSelect.cur_select_txt.select_txt.text = LocalTexts.DontVerifyText;
		break;
		case 1:

		break;
		case 2:
			ValueSet._visible = true;
			ValueSet.type_txt.text = LocalTexts.NeedPowerNumText;
			ValueSet.item_num.content_txt.text = value;
			CurValue = value;
			TypeSelect.cur_select_txt.select_txt.text = LocalTexts.NeedPowerNumText;
		break;
		case 3:
			ValueSet._visible = true;
			ValueSet.type_txt.text = LocalTexts.NeedPlayerLevelText;
			ValueSet.item_num.content_txt.text = value;
			CurValue = value;
			TypeSelect.cur_select_txt.select_txt.text = LocalTexts.NeedPlayerLevelText;
		break;
		default:
		break;
	}
}

TypeSelect.PullUpOver = function()
{
	isPullDown = false;
}


SetOkBtn.onRelease = function()
{
	fscommand("AllianceMainCmd", "ReqSetData" + "\2" + CurType + "\2" + CurValue + "\2" + CurIcon);
}

ReduceBtn.onRelease = function()
{
	CurValue = CurValue - 1;
	if (CurValue <= 1)
	{
		CurValue = 1;		
	}
	ValueSet.item_num.content_txt.text = CurValue;
}

AddBtn.onRelease = function()
{
	if (CurType == 3)
	{
		if (CurValue >= 99)
		{
			return;
		}
	}
	if (CurType == 2)
	{
		if (CurValue >= 999999)
		{
			return;
		}
	}
	CurValue = CurValue + 1;
	
	ValueSet.item_num.content_txt.text = CurValue;
}


function SetAllianceIcon( strIcon )
{	
    CurIcon = strIcon;
    var width =  AllianceIcon.item_icon._width;
    var height = AllianceIcon.item_icon._height;
	if (AllianceIcon.item_icon.icons == undefined)
	{
        AllianceIcon.item_icon.loadMovie("AllianceIcon.swf");
    }
    AllianceIcon.item_icon._width = width;
    AllianceIcon.item_icon._height = height;

    AllianceIcon.item_icon.icons.gotoAndStop(CurIcon)
    MainUI.item_origin.select_btn.onRelease = AllianceIcon.item_icon.onRelease = function()
	{
		fscommand("AllianceCommand","OpenSelectIconUI")
	}
}


function InitPanel(datas)
{
	LocalTexts = datas.texts;
	SetDatas = datas;
	SetNumberInput.init("NumberPad", "FlashAllianceSetingUI", "hitzone", "", "content_txt", true, false, '1', null, null, null, null, true);
	SetNumberInput.setMaxLength(6);
	SetNumberInput.onTextChange = function()
	{
		var strValue = SetNumberInput.getInputString();
		CurValue = Number(strValue);
		if (isNaN(CurValue))
		{
			CurValue = 1;
		}
		if (CurType == 3)
		{
			if (CurValue > 99)
			{
				CurValue = 99;
			}
		}
		if (CurType == 2)
		{
			if (CurValue > 999999)
			{
				CurValue = 999999;
			}
		}
		ValueSet.item_num.content_txt.text = CurValue;
	}

	MainUI.posY = MainUI._y;
	SetNumberInput.onChangeKeyBoardHeight = function()
	{
		MainUI._y = MainUI.posY - SetNumberInput.GetHeightChange();
	}

	SetVerifyInfo(datas.limit.type, datas.limit.value);
	
	SetAllianceIcon(datas.icon);
	
}