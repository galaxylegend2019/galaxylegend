import common.CTextAutoSizeTool;
var GachaHomeUI = _root.gacha_home;
var GachaTenUI 	= _root.gacha_ten;
var GachaOneUI 	= _root.gacha_one;
var GachaHeroUI = _root.gacha_hero;
var GachaHeroList = _root.info_main;

var CurUI 		= undefined;
var GachaDatas 	= undefined;
var Milliseconds = 0;
var CurGachaType 	= 1; 	//1、free 2、money
var IsClickCloseBtn = false;
var IsClickCarryOnBtn = false;
var IsGachaing 		= false;
var GachaOneResult = undefined;
var GachaTenResult = undefined;
var CurGachaInfo = undefined;
var CanGetHeroList = undefined;
var TopUI 			= _root.top_ui;
var herolist_item_count = 4;
var list = GachaHeroList.hero_list.item_view.view_list

_root.onLoad = function()
{
	InitUI();
	//Test();
	GachaHomeUI._visible = false;
	GachaTenUI._visible 	= false;
	GachaOneUI._visible 	= false;
    GachaHeroUI._visible 	= false;
    GachaHeroList._visible  = false;
    GachaHomeUI.normal_gacha.btn_info._visible = false
}


function Test()
{
	var datas = new Object();
	datas.free_normal_num = 0;
	datas.free_normal_total_num = 0;
	datas.free_normal_count_down = 0;
	datas.every_normal_money = 0;
	datas.normal_10_discount = 0;
	datas.free_high_count_down = 0;
	datas.every_high_credit = 0;
	datas.high_10_discount = 0;
	datas.normal_money_txt = "0";
	datas.normal_10_money_txt = "0";
	datas.advance_money_txt = "0";
	datas.advance_10_money_txt = "0";
	RefreshUI(datas);
	SetMoney(0,0,0);
}

function SwitchUI(ui_name)
{
	if (ui_name == "GachaHomeUI")
	{
		GachaHomeUI._visible 	= true;
		GachaTenUI._visible 	= false;
		GachaOneUI._visible 	= false;
		GachaHeroUI._visible 	= false;
		GachaHomeUI.ui_name = "GachaHomeUI";
		CurUI = GachaHomeUI;
	}else if (ui_name == "GachaTenUI")
	{
		GachaHomeUI._visible 	= false;
		GachaTenUI._visible 	= true;
		GachaOneUI._visible 	= false;
		GachaHeroUI._visible 	= false;
		GachaTenUI.ui_name = "GachaTenUI";
		CurUI = GachaTenUI;
	}else if (ui_name == "GachaOneUI")
	{
		GachaHomeUI._visible 	= false;
		GachaTenUI._visible 	= false;
		GachaOneUI._visible 	= true;
		GachaHeroUI._visible 	= false;
		GachaOneUI.ui_name = "GachaOneUI";
		CurUI = GachaOneUI;
	}else if (ui_name == "GachaHeroUI")
	{
		GachaHomeUI._visible 	= false;
		GachaTenUI._visible 	= false;
		GachaOneUI._visible 	= false;
		GachaHeroUI._visible 	= true;
		GachaHeroUI.ui_name = "GachaHeroUI";
		CurUI = GachaHeroUI;
	}
	
}

/*---------------GachaHome----------------*/


var NormalGacha		= GachaHomeUI.normal_gacha;
var AdvancedGacha	= GachaHomeUI.advanced_gacha;

var CloseBtn = TopUI.btn_close;

function SetDefaultShow()
{
	SetBtnState(NormalGacha.gacha1, false);
	SetBtnState(AdvancedGacha.gacha1, false);
	SetMoney(0, 0, 0);
}

function InitUI()
{
	TopUI.OnMoveInOver = function()
	{
		trace("TopUI.OnMoveInOver");

	}

	TopUI.OnMoveOutOver = function()
	{
		trace("TopUI.OnMoveOutOver");
		if (IsGachaing)
		{
			return;
		}
		if (IsClickCloseBtn)
		{
			if (CurUI.ui_name == "GachaOneUI")
			{
				fscommand("GachaCommand", "CloseGachaOneUI");
				IsClickCloseBtn = false;
			}else if (CurUI.ui_name == "GachaTenUI")
			{
				fscommand("GachaCommand", "CloseGachaTenUI");
				IsClickCloseBtn = false;
			}
			
		}else{
				fscommand("GachaCommand", "CloseHomeUI")
		}
		
	}

	NormalGacha.OnMoveOutOver = function()
	{
		if (IsClickCloseBtn)
		{
			if (CurUI.ui_name == "GachaHomeUI")
			{
				fscommand("GotoNextMenu", "GS_MainMenu");
				//IsClickCloseBtn = false;
			}
		}
	}

	CloseBtn.onRelease = function()
	{

		ClickTopUIClose()
	}
	SetDefaultShow();
}
//fte call
function ClickTopUIClose()
{
	if (IsGachaing)
	{
		return;
	}
	fscommand("PlaySound","main_button_click");
	if (CurUI.ui_name == "GachaHomeUI")
	{
		TopUI.gotoAndPlay("closing_ani");
		NormalGacha.gotoAndPlay("closing_ani");
		AdvancedGacha.gotoAndPlay("closing_ani");
	}else if (CurUI.ui_name == "GachaOneUI")
	{
		CurUI.gotoAndPlay("closing_ani");
		CurUI.carryclose.gotoAndPlay("closing_ani");
		TopUI.gotoAndPlay("closing_ani");
		fscommand("GachaCommand", "ShowHomeScene");
	}else if (CurUI.ui_name == "GachaTenUI")
	{
		CurUI.gotoAndPlay("closing_ani");
		CurUI.pumpingclose.gotoAndPlay("closing_ani");
		TopUI.gotoAndPlay("closing_ani");
		fscommand("GachaCommand", "ShowHomeScene");
	}

	IsClickCloseBtn = true;
}

function ShowHomeUI()
{
	SwitchUI("GachaHomeUI");
	TopUI.gotoAndPlay("opening_ani");
	NormalGacha.gotoAndPlay("opening_ani");
	AdvancedGacha.gotoAndPlay("opening_ani");

	fscommand("TutorialCommand","AsTrackEvent" + "\2" + "gachaopen");
}


function CloseHomeUI()
{
	trace("xxpp CloseHomeUI "+GachaHomeUI._visible)
	if (GachaHomeUI._visible)
	{
		TopUI.gotoAndPlay("closing_ani");
		NormalGacha.gotoAndPlay("closing_ani");
		AdvancedGacha.gotoAndPlay("closing_ani");	
	}else
	{
		fscommand("GachaCommand", "CloseHomeUI")
	}
	
}

function SetBtnState(mc, isFree)
{
	var frame = 2;
	if (isFree)
	{
		frame = 1;
	}
	mc.gotoAndStop(frame);
	mc.btn_gacha.isFree = isFree;
}

/*
datas.free_normal_num = 2
datas.free_normal_total_num = 5
datas.free_normal_count_down = 200000
datas.every_normal_money = 2000
datas.normal_10_discount = 10
datas.free_high_count_down = 10000;
datas.every_high_credit = 100;
datas.high_10_discount = 10;
*/

function SetNormalInfo()
{
	var is_free = false;
	if (GachaDatas.free_normal_total_num - GachaDatas.free_normal_num  <= 0)
	{
        NormalGacha.resttime._visible = false;
		is_free = false;
	}else
	{
		if (GachaDatas.free_normal_count_down <= 0)
		{
            NormalGacha.gacha1.btn_gacha.times_txt.text = (GachaDatas.free_normal_total_num - GachaDatas.free_normal_num) + "/" + GachaDatas.free_normal_total_num;
			NormalGacha.resttime._visible = false;
			is_free = true;
		}else
		{
            NormalGacha.resttime._visible = true;
			NormalGacha.resttime.time_txt.text = GetTimeText(GachaDatas.free_normal_count_down);
			is_free = false;
		}
	}
	SetBtnState(NormalGacha.gacha1, is_free);
	if (not is_free)
	{
		NormalGacha.gacha1.btn_gacha.txt_Price.text = GachaDatas.normal_money_txt
	}
	NormalGacha.gacha1.btn_gacha.onRelease = function()
	{
		if (this.isFree)
		{
			fscommand("GachaCommand", "DoGacha\2" + "1\2" + "1\2" + "1");
		}else
		{
			fscommand("GachaCommand", "DoGacha\2" + "1\2" + "1\2" + "2");
		}
		
	}
}

function SetAdvanceInfo()
{
	var is_free = false;
	if (GachaDatas.free_high_count_down <= 0)
	{
		AdvancedGacha.resttime._visible = false;
		is_free = true;
	}else
	{
		AdvancedGacha.resttime._visible = true;
		AdvancedGacha.resttime.time_txt.text = GetTimeText(GachaDatas.free_high_count_down);
		is_free = false;
	}

	SetBtnState(AdvancedGacha.gacha1, is_free);
	if (not is_free)
	{
		AdvancedGacha.gacha1.btn_gacha.txt_Price.text = GachaDatas.advance_money_txt
	}
	AdvancedGacha.gacha1.btn_gacha.onRelease = function()
	{
		if (this.isFree)
		{
			fscommand("GachaCommand", "DoGacha\2" + "2\2" + "1\2" + "1");
		}else
		{
			fscommand("GachaCommand", "DoGacha\2" + "2\2" + "1\2" + "2");
		}
		
	}
}

function UpdateInfo()
{
	SetNormalInfo();
	SetAdvanceInfo();
}

function SetBaseInfo()
{
	NormalGacha.btn_gacha_10.txt_Price.text = GachaDatas.normal_10_money_txt;
	NormalGacha.btn_gacha_10.sale_txt.text = GachaDatas.normal_10_discount + "%";
	NormalGacha.btn_gacha_10.onRelease = function()
	{
		fscommand("GachaCommand", "DoGacha\2" + "1\2" + "10\2" + "2");
	}
	AdvancedGacha.btn_gacha_10.txt_Price.text = GachaDatas.advance_10_money_txt;
	AdvancedGacha.btn_gacha_10.sale_txt.text = GachaDatas.high_10_discount + "%";
	AdvancedGacha.btn_gacha_10.onRelease = function()
	{
		fscommand("GachaCommand", "DoGacha\2" + "2\2" + "10\2" + "2");
	}
}

function RefreshUI( datas )
{
	if (CurUI == undefined)
	{
		GachaHomeUI._visible = true;
		ShowHomeUI();
	}
	GachaDatas = datas;
	GachaDatas.free_high_count_down = Math.ceil(GachaDatas.free_high_count_down);
	GachaDatas.free_normal_count_down = Math.ceil(GachaDatas.free_normal_count_down);
	UpdateInfo();
	SetBaseInfo();
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
	var seconed = FormatTimeTxt(time % 60);

	time = Math.floor(time / 60);

	var minutes = FormatTimeTxt(time % 60);
	time = Math.floor(time / 60);

	var hour = FormatTimeTxt(time);

	return hour + ":" + minutes + ":" + seconed;
}

this.onEnterFrame = function()
{
	var curDate = new Date();
	var curMilliseconds = curDate.getTime();
	if (Milliseconds == 0)
	{
		Milliseconds = curMilliseconds;
	}
	var offset = curMilliseconds - Milliseconds;
	if (offset >= 1000)
	{
		Milliseconds += 1000;
		if (GachaDatas.free_normal_total_num - GachaDatas.free_normal_num > 0 and GachaDatas.free_normal_count_down > 0)
		{
			GachaDatas.free_normal_count_down = GachaDatas.free_normal_count_down - 1;
		}
		if (GachaDatas.free_high_count_down > 0)
		{
			GachaDatas.free_high_count_down = GachaDatas.free_high_count_down - 1;
		}
		UpdateInfo();
	}
}

function SetMoney(moneyTxt, creditTxt, point)
{
	TopUI.money.money_text.text = moneyTxt;
	TopUI.credit.credit_text.text = creditTxt;

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

/*************GachaOneUI*************/


GachaOneUI.OnMoveInOver = function()
{
	IsGachaing = false;
	IsClickCarryOnBtn = false;
	GachaOneUI.carryclose.gotoAndPlay("opening_ani");
	GachaOneUI.carryclose._visible = true;
	TopUI.gotoAndPlay("opening_ani");
	TopUI._visible = true;
}

GachaOneUI.StartShow = function(index)
{
	//fscommand("PlaySound","sfx_lottery_card_appear");
}

GachaOneUI.ShowItem = function(index)
{
	if (GachaOneResult.res_type == "hero" or GachaOneResult.res_type == "soul")
	{
		this.stop();
		GachaOneUI.item1.gotoAndPlay("opening_ani");
		GachaOneUI.item1.OnEffectPlayOver = function()
		{	
			CurUI._visible = false;
			TopUI._visible = false;
			CurGachaInfo = GachaOneResult;
			fscommand("GachaCommand", "ShowHero\2" + CurGachaInfo.hero_id);
		}
	}
}

//info.item_name
//info.item_num
//info.icon_data
function SetItemInfo(mc, info)
{
	CTextAutoSizeTool.SetSingleLineText(mc.name_txt, info.item_name, 18, 10);
	mc.num_txt.text = info.count;
	
	{
		var w = mc.item_icon._width;
		var h = mc.item_icon._height;
		if (info.res_type == "hero")
		{
			mc.item_icon.loadMovie("CommonHeros.swf");
		}else
		{
			mc.item_icon.loadMovie("CommonIcons.swf");
		}
		mc.item_icon._width = 128;
		mc.item_icon._height = 128;
	}
	mc.item_icon.IconData = info.icon_data;
	if(mc.item_icon.UpdateIcon)
	{ 
		mc.item_icon.UpdateIcon(); 
	}
	mc.num_bg._x = 13;
	mc.num_bg._y = 75;

	mc.item_icon.onRelease = function()
	{
		if (IsClickCarryOnBtn)
		{
			return;
		}
		fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.IconData.res_type + "\2" + this.IconData.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
	}
	if (info.res_type == "hero")
	{
		mc.num_bg._visible = false;
		mc.num_txt._visible = false;
	}else
	{
		mc.num_bg._visible = true;
		mc.num_txt._visible = true;
	}
}

function ShowGachaOneUI(gacha_type, item_info)
{
	fscommand("GachaCommand", "ShowGachaScene");
	IsGachaing = true;
	CurGachaType = gacha_type;
	GachaOneResult = item_info;
	SwitchUI("GachaOneUI");
	if (IsClickCarryOnBtn)
	{
		TopUI.gotoAndPlay("closing_ani");
		GachaOneUI.carryclose.gotoAndPlay("closing_ani");
		GachaOneUI.gotoAndPlay("closing_ani");
		GachaOneUI.carryclose.carry_on.btn_gacha.onRelease = undefined;
	}else
	{
		GachaOneUI._visible = false;
	}
	
	//TODO:
	//PlayGachaOne(gacha_type);
}

function PlayGachaOne()
{

	SetItemInfo(GachaOneUI.item1, GachaOneResult);
	GachaOneUI._visible = true;
	
	GachaOneUI.gotoAndPlay("opening_ani");

	GachaOneUI.carryclose._visible = false;
	GachaOneUI.carryclose.carry_on.gotoAndStop(CurGachaType);
	var gacha_btn = GachaOneUI.carryclose.carry_on.btn_gacha;
	gacha_btn.CurGachaType = CurGachaType;
	if (CurGachaType == 1)
	{
		gacha_btn.txt_Price.text = GachaDatas.normal_money_txt;
	}else
	{
		gacha_btn.txt_Price.text = GachaDatas.advance_money_txt;
	}
	gacha_btn.onRelease = function()
	{
		ClickGachaOneBtn();
	}
}

function ClickGachaOneBtn()
{
	var gacha_btn = GachaOneUI.carryclose.carry_on.btn_gacha;
	if (IsGachaing)
	{
		return;
	}
	IsClickCarryOnBtn = true;
	if (gacha_btn.CurGachaType == 1)
	{
		fscommand("GachaCommand", "DoGacha\2" + "1\2" + "1\2" + "2");
	}else
	{
		fscommand("GachaCommand", "DoGacha\2" + "2\2" + "1\2" + "2");
	}
}

/*********GachaTenUI*********/

GachaTenUI.OnMoveInOver = function()
{
	IsClickCarryOnBtn = false;
	IsGachaing = false;
	GachaTenUI.pumpingclose.gotoAndPlay("opening_ani");
	TopUI.gotoAndPlay("opening_ani");
	TopUI._visible = true;
	GachaTenUI.pumpingclose._visible = true;
}

GachaTenUI.StartShow = function(index)
{
	fscommand("PlaySound","sfx_lottery_card_appear");
}

GachaTenUI.ShowItem = function(index)
{
	if (GachaTenResult[index - 1].res_type == "hero" or GachaTenResult[index - 1].res_type == "soul")
	{
		this.stop();
		this["item" + index].index = index
		this["item" + index].gotoAndPlay("opening_ani");
		this["item" + index].OnEffectPlayOver = function()
		{	
			CurGachaInfo = GachaTenResult[this.index - 1];
			fscommand("GachaCommand", "ShowHero\2" + CurGachaInfo.hero_id);
			CurUI._visible = false;
			TopUI._visible = false;
		}
		
		
	}

}

function ShowGachaTenUI(gacha_type, item_infos)
{
	fscommand("GachaCommand", "ShowGachaScene");
	IsGachaing = true;
	GachaTenResult = item_infos;
	CurGachaType = gacha_type;
	SwitchUI("GachaTenUI");
	

	if (IsClickCarryOnBtn)
	{
		TopUI.gotoAndPlay("closing_ani");
		GachaTenUI.pumpingclose.gotoAndPlay("closing_ani");
		GachaTenUI.gotoAndPlay("closing_ani");
		GachaTenUI.pumpingclose.carry_on.btn_gacha.onRelease = undefined;
	}else
	{
		GachaTenUI._visible = false;
	}
	
	//TODO:
	//PlayGachaTen(gacha_type);
}


function PlayGachaTen()
{
	for(var i = 1; i <= 10; ++i)
	{
		SetItemInfo(GachaTenUI["item" + i], GachaTenResult[i - 1]);
	}
	GachaTenUI._visible = true;
	GachaTenUI.gotoAndPlay("opening_ani");

	GachaTenUI.pumpingclose._visible = false;
	GachaTenUI.pumpingclose.carry_on.gotoAndStop(CurGachaType);
	var gacha_btn = GachaTenUI.pumpingclose.carry_on.btn_gacha;
	gacha_btn.CurGachaType = CurGachaType;
	if (CurGachaType == 1)
	{
		gacha_btn.txt_Price.text = GachaDatas.normal_10_money_txt;
	}else
	{
		gacha_btn.txt_Price.text = GachaDatas.advance_10_money_txt;
	}
	gacha_btn.onRelease = function()
	{
		if (IsGachaing)
		{
			return;
		}
		IsClickCarryOnBtn = true;
		if (this.CurGachaType == 1)
		{
			fscommand("GachaCommand", "DoGacha\2" + "1\2" + "10\2" + "2");
		}else
		{
			fscommand("GachaCommand", "DoGacha\2" + "2\2" + "10\2" + "2");
		}
	}
}

/****************GachaHeroUI*****************/

GachaHeroUI.OnMoveOutOver = function()
{
	GachaHeroUI._visible = false;
	CurUI._visible = true;
	fscommand("GachaCommand", "CloseHeroShow");
	CurUI.play();
}

function ShowGachaHeroUI()
{
	if (CurGachaInfo == undefined)
	{
		return;
	}
	GachaHeroUI._visible = true;
	GachaHeroUI.gotoAndPlay("opening_ani");
	GachaHeroUI.hitzone.onRelease = function()
	{
		CloseShowHeroUI();
	}
	if (CurGachaInfo.res_type == "hero")
	{
		GachaHeroUI.desc._visible = false;
		GachaHeroUI.info._visible = true;
        GachaHeroUI.info.name_txt.htmlText = CurGachaInfo.item_name;
        GachaHeroUI.info.hero_star.gotoAndStop(CurGachaInfo.hero_star);
	}else
	{
		GachaHeroUI.desc._visible = true;
		GachaHeroUI.info._visible = false;
    }
    GachaHeroUI.hero_flag_icon.gotoAndStop(CurGachaInfo.heroType);
    GachaHeroUI.hero_flag_icon.hero_desc.text = CurGachaInfo.heroDesc;
    if (CurGachaInfo.isUnlockSkill)
    {
        GachaHeroUI.skill_info._visible = true
        if(GachaHeroUI.skill_info.skill_icon.skill_icon.icons == undefined)
        {
            GachaHeroUI.skill_info.skill_icon.skill_icon.loadMovie("CommonSkills.swf")
        }
        GachaHeroUI.skill_info.skill_icon.skill_icon.icons.icons.gotoAndStop("skill_" + CurGachaInfo.skillInfo.id)
        GachaHeroUI.skill_info.name_text.text = CurGachaInfo.skillInfo.skillName
        GachaHeroUI.skill_info.info_text.text = CurGachaInfo.skillInfo.skillDesc
    }
    else
    {
        GachaHeroUI.skill_info._visible = false
    }
}

/****************HeroList*****************/
_root.gacha_home.advanced_gacha.btn_info.onRelease = function()
{
    GachaHeroList._visible = true
    GachaHeroList.gotoAndPlay("opening_ani")
    InitHeroList()
}

list.onEnterFrame = function()
{
    this.OnUpdate();
}

list.onItemEnter = function(mc,index_item)
{
    for(var i = 0; i < herolist_item_count; i++)
    {
        var IconMc = mc["item_" + (i + 1)];
        IconMc._visible = true;
        var nIndex = (index_item - 1) * herolist_item_count + i;
        var heroData = CanGetHeroList[nIndex];
        if(heroData == undefined)
        {
            IconMc._visible = false;
            continue;
        }
        IconMc.gotoAndStop("normal");
        if(IconMc.hero_icon.icons == undefined)
        {
            IconMc.hero_icon.loadMovie("CommonHeros.swf");
            IconMc.hero_icon.IconData = heroData.heroIcon
        }
        if(IconMc.hero_icon.UpdateIcon)
        {
            IconMc.hero_icon.UpdateIcon();
        }
        IconMc.star_plane.star.gotoAndStop(heroData.star)
        IconMc.type.gotoAndStop(heroData.heroType)
        IconMc.name_txt.text = heroData.heroName
        IconMc.name_txt._x = (IconMc.bg._width - IconMc.name_txt.textWidth) / 2
    }
}

GachaHeroList.btn_bg.onRelease = function()
{
    GachaHeroList.gotoAndPlay("closing_ani")
}

GachaHeroList.OnMoveOutOver = function()
{
    GachaHeroList._visible = false;
}

function SetCanGetHerolistData(datas)
{
    CanGetHeroList = datas
}

function InitHeroList()
{
    list.clearListBox()
    list.initListBox("list_hero_icon",0,true,true)
    list.enableDrag(true)

    var listCount = Math.ceil(CanGetHeroList.length / herolist_item_count)
    for(var i = 1; i <= listCount; i++ )
    {
        list.addListItem(i,false,false)
    }
}

//fte call
function CloseShowHeroUI()
{
	GachaHeroUI.hitzone = undefined;
		
	GachaHeroUI.gotoAndPlay("closing_ani");
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.free._visible = false
}

FTEHideAnim()
