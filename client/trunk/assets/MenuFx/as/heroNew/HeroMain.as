var initPosX;
var tempPosX;

//for new hero ui show
var ui_title=_root.titles;
var ui_equips=_root.bottom_equips;
var ui_hero_main=_root.hero_main
var ui_equip_info_page=ui_hero_main.equip_info_page
var ui_equip_info=ui_equip_info_page.equip_info
var ui_hero_detail_info=_root.hero_detail_info
var ui_arrow=_root.ui_arrow
var btn_upgradeHero=_root.btn_upgrade

var MAX_STAR_COUNT=5
var isQualityEnough=false

var equipButtons:Array;
var equipDatas:Array;
var heroDetailData:Array;

var curFocusButton
var isTopUI=true
var curModelName
var isSetData=false
var numberAniMCs:Array
var NumberCount=0

var attrNumberDatas
var showSpeed=5
var frameCount=0
var dataIndex=0
var NumberPosX
var NumberPosY

var PathObject=new Object()

var isEquipAdvance=false
//preLoad swf
function preLoadSwf()
{
	var strengthen=ui_equip_info.equip_strengthen
	if(strengthen.equip_icon.icons==undefined)
	{
		strengthen.equip_icon.loadMovie("CommonIcons.swf")
	}

	var evolution=ui_equip_info.equip_evolution
	if(evolution.equip_icon.icons==undefined)
	{
		evolution.equip_icon.loadMovie("CommonIcons.swf")
	}

	/*
	var evolution=ui_equip_info.equip_evolution
	for(var i=0;i<3;i++)
	{
		var item=evolution["item_"+(i+1)]
		if(item.item_icon.icons==undefined)
		{
			item.item_icon.loadMovie("CommonIcons.swf")
		}
	}
	*/
}

function InitUIState()
{
	//preLoad swf file
	preLoadSwf()

	//set all equip icon hide state
	equipButtons=new Array();
	for(var i=1;i<=6;i++)
	{
		equipButtons[i]=ui_equips["equip_"+i];
		//equipButtons[i].gotoAndStop("focus_hide")
		equipButtons[i].bg._visible=false
	}

	var ui_hero_item=ui_hero_main.hero_info.hero_item
	var strArray=new Array("skill","star","combat","form")
	var pageArray=new Array("HeroSkillPage","HeroStarPage","HeroCombatPage","HeroFormPage")

	for(var i=0;i<3;i++)
	{
		var str=strArray[i]
		ui_hero_item["btn_"+str].item_icon.gotoAndStop(str)
		ui_hero_item["btn_"+str].str="GS_"+pageArray[i]

		ui_hero_item["btn_"+str].onRelease=function()
		{

			/*******FTE*******/
			if (this._name == "btn_skill")
			{
				fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroSkillBtn");
			}
			/*******End*******/
			fscommand("PlaySound","sfx_ui_selection_1")
			fscommand("GotoNextMenu",this.str)
			_root._visible=false
		}
	}

	var ui_hero_info=ui_hero_main.hero_info.hero_info
	_root.titles.title.btn_info.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		SetHeroDetailInfo()
	}
}

// the old ui code ,ready for update
this.onLoad=function()
{
	InitUIState()
	_root._visible=false

	if(_root.messageBox.upgrade_result==undefined)
	{
		_root.messageBox.loadMovie("PopupGrowth.swf")
	}
	_root.messageBox._visible=false

	ui_hero_detail_info._visible=false
	ui_equip_info_page._visible=false
	ui_hero_main.bg._visible=false
}

//set cur equip info from lua
function InitEquipData(inputEquipData:Array)
{
	equipDatas=inputEquipData
}

//show the upgradeResult
function SetUpgradeResult(resultData)
{
	_root.messageBox._visible=true
	if(_root.messageBox.upgrade_result==undefined)
	{
		_root.messageBox.loadMovie("PopupGrowth.swf")
	}

	_root.messageBox.upgrade_result.InitMC(_root.messageBox.upgrade_result)
	_root.messageBox.upgrade_result.SetUpgradeResult(resultData)

	_root.messageBox.upgrade_result.onRelease=function()
	{
		_root.messageBox._visible=false
	}
}

function SetAttrNumber(inputData:Array)
{
	curFocusButton.hero_lv_up_plane.gotoAndPlay(2)
	ui_equip_info.equip_strengthen.hero_lv_up_plane.gotoAndPlay(2)

	attrNumberDatas=inputData
	if(ui_equip_info.equip_strengthen._visible==false)
	{
		return
	}
	var strengthen=ui_equip_info.equip_strengthen
	var btn_upgrade
	if(inputData.typex=="equipUp")
	{
		btn_upgrade=strengthen.btn_upgrade
	}else if(inputData.typex=="equipQuickUp")
	{
		btn_upgrade=strengthen.btn_quick_upgrade
	}
	var xPos=btn_upgrade._x
	var yPos=btn_upgrade._y
	NumberPosX=xPos
	NumberPosY=yPos
	for(var i=0;i<inputData.length;i++)
	{
		//var str=inputData[i]

		//SetNumber(xPos,yPos+15*i,str)
	}

	showSpeed=5
	frameCount=0
	dataIndex=0
	_root.onEnterFrame=function()
	{
		frameCount++
		if(frameCount>=showSpeed)
		{
			if(dataIndex<attrNumberDatas.length)
			{
				var str=attrNumberDatas[dataIndex]
				SetNumber(NumberPosX,NumberPosY-dataIndex*30,str)
				frameCount=0
				dataIndex++
			}else
			{
				_root.onEnterFrame=undefined
			}

		}
	}

}

function SetNumber(xPos,yPos,str)
{
	var mc_num_ani=GetNumberMC()

	mc_num_ani._x=xPos
	mc_num_ani._y=yPos

	mc_num_ani._visible=true
	mc_num_ani.add_num.num_text.text=str

	mc_num_ani.gotoAndPlay("opening_ani")
	mc_num_ani.OnMoveOutOver=function()
	{
		this._visible=false
	}
	fscommand("PlaySound","sfx_ui_armor_upgrade")
}

//set common info money
function SetMoneyInfo(moneyData)
{
	var titles=_root.titles
	titles.energy.energy_text.text=moneyData.energy
	titles.money.money_text.text=moneyData.money
	titles.credit.credit_text.text=moneyData.credit
}

_root.titles.energy.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	fscommand("GoToNext", "Energy");
}
_root.titles.money.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	fscommand("GoToNext", "Affair");
}
_root.titles.credit.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	fscommand("GoToNext", "Purchase");
}

function UpdateUnread(heroData)
{
	var ui_hero_item=ui_hero_main.hero_info.hero_item
	
	var mc=ui_hero_item.btn_skill

	showUnread(mc,heroData.isSkillUp)

	var mc=ui_hero_item.btn_star
	showUnread(mc,heroData.isStarUp)
}

//the left_top data (eg:name ,level,star,exp)
function SetHeroInfo(heroItem)
{
	var ui_hero_info=ui_hero_main.hero_info.hero_info

	//herolevel,star
	ui_hero_info.icon_info.level_info.level_text.text=heroItem.level;
	var ui_stars=ui_hero_info.icon_info.star_plane;

	for(var i=1;i<=MAX_STAR_COUNT;i++)
	{
		var ui_star=ui_stars["star_"+i];
		if(i<=heroItem.star)
		{
			ui_star.gotoAndStop("normal");
		}else
		{
			ui_star.gotoAndStop("Idle");
		}		
	}

	_root.titles.title.name_text.text=heroItem.heroNameText;
	_root.titles.title.level_text.text=heroItem.level;

	ui_hero_info.hero_info.hero_exp.htmlText=heroItem.expText
	_root.hero_info.hero_info.combat_text.htmlText=heroItem.combat
	//load hero icon

	var hero_icon=ui_hero_info.icon_info
	if(hero_icon.icons==undefined)
	{
		hero_icon.loadMovie("CommonHeros.swf")
	}
	hero_icon.IconData=heroItem.iconData
	if(hero_icon.UpdateIcon) 
	{
		hero_icon.UpdateIcon(); 
	}

	UpdateUnread(heroItem)
}

function SetTitleData(heroItem)
{
	ui_hero_main.hero_info.hero_item.chip_info
	var mc_chip_info=ui_hero_main.hero_info.hero_item.chip_info

	if(heroItem.isMaxStar==true)
	{
		mc_chip_info._visible=false
		ui_hero_main.hero_info.hero_item.btn_up._visible=false
		ui_hero_main.hero_info.hero_item.max_chip_info._visible=true
		ui_hero_main.hero_info.hero_item.btn_add._visible=false
		return
	}else
	{
		mc_chip_info._visible=true
		ui_hero_main.hero_info.hero_item.max_chip_info._visible=false
	}

	for(var j = 1 ; j <= 5 ; j++){
		var starFlag=heroItem.star >= j ? "normal" : "Idle"
		mc_chip_info["star_" + j].gotoAndStop(starFlag);
	}

	mc_chip_info.chip_count.htmlText=heroItem.chipStarCountText

	var mc_process=mc_chip_info.Power_cric
	var process=(heroItem.curStarExp/heroItem.nextStarExp)*100+1
	if(process>100)
	{
		process=100
	}
	mc_process.gotoAndStop(process)
	showUnread(ui_hero_main.hero_info.hero_item.btn_up,heroItem.isStarUp)
	if(heroItem.isStarEnough)
	{
		ui_hero_main.hero_info.hero_item.btn_up._visible=true
		mc_chip_info._visible=false
		ui_hero_main.hero_info.hero_item.btn_add._visible=false
		ui_hero_main.hero_info.hero_item.btn_up.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			fscommand("HeroCommand","HeroStarUpgrade")
		}
	}else
	{
		ui_hero_main.hero_info.hero_item.btn_up._visible=false
		mc_chip_info._visible=true
		ui_hero_main.hero_info.hero_item.btn_add._visible=true

		ui_hero_main.hero_info.hero_item.btn_add.heroItem=heroItem
		ui_hero_main.hero_info.hero_item.btn_add.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			var id=this.heroItem.starID
			var needNum=this.heroItem.nextStarExp
			fscommand("ShowItemOrigin",id+'\2'+needNum)
		}
	}

	_root.hero_main.hero_info.hero_flag.hero_flag_icon.gotoAndStop(heroItem.heroAttrType)
}

_root.hero_main.hero_info.hero_info.btn_add_exp.onRelease=function()
{
	fscommand("HeroCommand","PopUseExp")
}

function UpdateData(heroItem)
{
	heroDetailData=heroItem.heroDetailData
	
	isSetData=false
	isEquipAdvance=false
	SetHeroInfo(heroItem)
	SetTitleData(heroItem)

	InitEquipData(heroItem.equipments)
	UpdateEquipData()

	SetEquipDetail()

	SetHeroQualityUp(heroItem)

}

//set hero info and set euqip info
function SetHeroData(heroItem)
{	
	ui_hero_detail_info.btn_close.onRelease()

	heroDetailData=heroItem.heroDetailData
	
	isSetData=true
	curModelName=heroItem.heroModel
	//isTopUI=true
	InitEquipData(heroItem.equipments)

	SetHeroInfo(heroItem)
	SetTitleData(heroItem)

	SetEquipButton()

	SetHeroQualityUp(heroItem)

}	

function SetEquipButton()
{
	for(var i=1;i<=6;i++)
	{
		var equipButton=equipButtons[i];
		equipButton.bg._visible=false
	}
	UpdateEquipData()
}

function UpdateEquipData()
{
	for(var i=1;i<=equipDatas.length;i++)
	{
		var dataIndex=equipDatas[i-1].id
		var equipButton=equipButtons[dataIndex];
		var equipData=equipDatas[i-1];
		equipButton.equipData=equipData

		equipButton.equip_info.equip_level.text=equipData.level;

		showUnread(equipButton.unread,equipData.isEquipAdvance)
		var btn_unread=bottom_equips["unread_"+i]
		showUnread(btn_unread,equipData.isEquipAdvance)

		if(equipButton.equip_icon.icons==undefined)
		{
			equipButton.equip_icon.loadMovie("CommonIcons.swf")
		}
		equipButton.equip_icon.IconData=equipData.iconData
		if(equipButton.equip_icon.UpdateIcon) 
		{
			equipButton.equip_icon.UpdateIcon(); 
		}

		equipButton.onRelease=function()
		{
			/*******FTE*******/
			fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickEquipBtn");
			/*******End*******/
			//fscommand("PlayMenuConfirm")
			fscommand("PlaySound","sfx_ui_selection_3")
			isTopUI=false

			for(var i=1;i<=6;i++)
			{
				var tempButton=equipButtons[i]
				var equipData=tempButton.equipData
				if(tempButton==this)
				{
					this.bg._visible=true
					this.equip_info.equip_level.text=this.equipData.level;
				}else
				{
					tempButton.bg._visible=false
					tempButton.equip_info.equip_level.text=tempButton.equipData.level;
				}		
			}

			curFocusButton=this

			_root.hero_main.equip_info_page._visible=true	
			_root.hero_main.equip_info_page.gotoAndPlay("opening_ani")	
			ui_hero_main.bg._visible=true
			ui_hero_main.bg.onRelease=function()
			{
				hideEquip()
			}

			_root.hero_main.hero_info.gotoAndPlay("closing_ani")	
			_root.hero_main.hero_info.OnMoveOutOver=function()
			{
				_root.hero_main.hero_info._visible=false
			}
			isSetData=false
			SetEquipDetail()
			/*******FTE*******/
			fscommand("TutorialCommand","Activate" + "\2" + "EquipDetailShow");
			/*******End*******/
		}
	}
}

function SetHeroQualityUp(heroItem)
{
	isQualityEnough=true
	for(var i=1;i<=6;i++)
	{
		var equipData=equipDatas[i-1];
		if(equipData.quality<=heroItem.quality)
		{
			isQualityEnough=false
		}
	}

	btn_upgradeHero._visible =isQualityEnough
	showUnread(btn_upgradeHero.btn,isQualityEnough)


	btn_upgradeHero.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickUpgradeHeroBtn");
		/*******End*******/
		fscommand("PlayMenuConfirm")
		fscommand("HeroCommand","HeroQualityUp")
	}

	//btn_upgradeHero.gotoAndPlay("opening_ani");
/*	if (isQualityEnough)
	{
		fscommand("TutorialCommand","Activate\2HERO_UPGRADE_READY");	
	}*/
	

	btn_upgradeHero.onMovedIn = function(){
		//fscommand("TutorialCommand","Activate\2HERO_UPGRADE_READY");
	}
}
//
ui_equip_info.btn_strengthen.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	SetEquipStrengthenData(curFocusButton.equipData)
}

//
ui_equip_info.btn_evolvement.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	SetEquipEvolvementData(curFocusButton.equipData)
}

_root.hero_main.equip_info_page.btn_hide.onRelease=function()
{
	fscommand("PlaySound","sfx_ui_cancel")

	isTopUI=true
	replayMC()
	SetMainUIState()
}

function hideEquip()
{
	fscommand("PlaySound","sfx_ui_cancel")
	isTopUI=true
	replayMC()
	SetMainUIState()
}

function SetEquipUIState()
{
	_root.ui_arrow.next_arrow._visible=false
	_root.ui_arrow.last_arrow._visible=false
	_root.ui_arrow.hero_hit._visible=false

	if(_root._visible==true)
	{
		//fscommand("DisplayModel",5+'\2'+curModelName+'\2'+0)
	}

}
function SetMainUIState()
{
	_root.ui_arrow.next_arrow._visible=true
	_root.ui_arrow.last_arrow._visible=true
	_root.ui_arrow.hero_hit._visible=true

	_root.hero_main.equip_info_page.gotoAndPlay("closing_ani")	

	_root.hero_main.equip_info_page.OnMoveOutOver=function()
	{
		_root.hero_main.equip_info_page._visible=false
		_root.hero_main.bg._visible=false
	}
}

function replayMC()
{
	_root.hero_main.hero_info.gotoAndPlay("opening_ani")	
	_root.hero_main.hero_info._visible=true
	//_root.bottom_equips.gotoAndPlay("opening_ani")

	for(var i=1;i<=6;i++)
	{
		var equipButton=equipButtons[i];
		equipButton.bg._visible=false
		//equipButton.gotoAndStop("focus_hide")

		equipButton.equip_info.equip_level.text=equipButton.equipData.level;

		//equipButton.equip_icon.gotoAndStop(i)
	}
}


function SetEquipStrengthenData(equipData)
{
	ui_equip_info.equip_strengthen.add_num_ani_1._visible=false
	ui_equip_info.equip_strengthen.add_num_ani_2._visible=false

	var strengthen=ui_equip_info.equip_strengthen

	if(strengthen.equip_icon.icons==undefined)
	{
		strengthen.equip_icon.loadMovie("CommonIcons.swf")
	}
	strengthen.equip_icon.IconData=equipData.iconData
	if(strengthen.equip_icon.UpdateIcon) 
	{
		strengthen.equip_icon.UpdateIcon(); 
	}

	strengthen.curLevel.text=equipData.level
	strengthen.name_text.htmlText=equipData.equipName

	strengthen.btn_upgrade.needMoney.htmlText=equipData.upMoney
	strengthen.btn_upgrade_black.needMoney.htmlText=equipData.upMoney
	strengthen.btn_quick_upgrade.needMoney.htmlText=equipData.quickUpMoney

	strengthen.max_message._visible=false

	for(var i=0;i<3;i++)
	{
		var mc_attr_board=strengthen["attr_board_"+(i+1)]	
		var attrData=equipData.attrDatas[i]
		if(attrData==undefined)
		{
			mc_attr_board._visible=false
		}else
		{
			mc_attr_board._visible=true
			mc_attr_board.attr_name.text=attrData.attrName
			mc_attr_board.last_attr.text=attrData.curAttr
		}
	}
	
	strengthen.btn_upgrade_black._visible=!equipData.isEquipUpgrade
	strengthen.btn_upgrade.onRelease=strengthen.btn_upgrade_black.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		var id=curFocusButton.equipData.id
		fscommand("HeroCommand","HeroEquipUpgrade\2"+id)

	}
	strengthen.btn_quick_upgrade_black._visible=!equipData.isEquipUpgrade
	strengthen.btn_quick_upgrade.onRelease=strengthen.btn_quick_upgrade_black.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickEquipQuickUpGrade");
		/*******End*******/
		fscommand("PlayMenuConfirm")
		var id=curFocusButton.equipData.id
		fscommand("HeroCommand","HeroEquipQuickUpgrade\2"+id)
	}
}

function SetEquipEvolvementData(equipData)
{
	var evolution=ui_equip_info.equip_evolution

	evolution.equip_desc.htmlText=equipData.advanceDesc
	for(var i=1;i<=3;i++)
	{
		var item=evolution["item_"+i]
		item._visible=false
	}

	var equipItems=equipData.needItems
	for(var i=0;i<equipItems.length;i++)
	{
		var item=evolution["item_"+(i+1)]
		item._visible=true
		item.item_text.count_text.text=equipItems[i].curCount+"/"+equipItems[i].count


		if(item.item_icon.icons==undefined)
		{
			item.item_icon.loadMovie("CommonIcons.swf")
		}
		item.item_icon.IconData=equipItems[i].iconData
		if(item.item_icon.UpdateIcon) 
		{
			item.item_icon.UpdateIcon(); 
		}
		

		item.btn_add._visible=equipItems[i].curCount<equipItems[i].count

		item.id=equipItems[i].id
		item.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			fscommand("ShowItemOrigin",this.id)
		}	

	}

	var isEquipAdvance=equipData.isEquipAdvance
	var mc=evolution.btn_evolution
	showUnread(mc,isEquipAdvance)

	evolution.btn_evolution_black._visible=!isEquipAdvance
	evolution.btn_evolution.onRelease=evolution.btn_evolution_black.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickEquipEvolutionBtn");
		/*******End*******/
		fscommand("PlayMenuConfirm")
		var id=curFocusButton.equipData.id
		fscommand("HeroCommand","HeroEquipAdvance\2"+id)
	}
}

function SetEquipDetail()
{
	if(curFocusButton==undefined)
	{
		return
	}
	var equipData=curFocusButton.equipData

	curFocusButton.equip_level.text=equipData.level;

	if(isTopUI==true)
	{
		SetMainUIState()
		curFocusButton.bg._visible=false
	}else
	{
		SetEquipUIState()
		curFocusButton.bg._visible=true
		curFocusButton.equip_level.text=equipData.level;
	}
	SetEquipStrengthenData(curFocusButton.equipData)
	SetEquipEvolvementData(curFocusButton.equipData)

}

//show the
function SetHeroDetailInfo()
{
	if(heroDetailData==undefined)
	{
		return
	}
	
	//_root.hero_main.hero_info._visible=false
	//_root.hero_main.equip_info_page._visible=false	

	ui_hero_detail_info._visible=true
	ui_hero_detail_info.gotoAndPlay("opening_ani")

	var ui_drag_list=ui_hero_detail_info.hero_item.drag_list

	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("list_hero_infomation",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		mc._visible=true
		var hero_item_mc=mc
		mc.attr_text.htmlText=heroDetailData[index_item-1]
	}

	ui_drag_list.onItemMCCreate = function(mc){
		mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	var listLength=heroDetailData.length

	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
	
	ui_hero_detail_info.btn_close.onRelease=function()
	{
		/*******FTE*******/
		//fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroMainCloseBtn");
		/*******End*******/
		fscommand("PlayMenuConfirm")
		ui_hero_detail_info.gotoAndPlay("closing_ani")
		ui_hero_detail_info.OnMoveOutOver=function()
		{
			ui_hero_detail_info._visible=false
		}
	}

}



//----------------------not modify--------------

_root.ui_arrow.next_arrow.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	//fscommand("MoveNext",1)
	var dir=1
	fscommand("HeroCommand","MoveNext\2"+dir)

}

_root.ui_arrow.last_arrow.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	//fscommand("MoveNext",-1)
	var dir=-1
	fscommand("HeroCommand","MoveNext\2"+dir)
}

function SetUIPlay()
{
	_root._visible=true
	fscommand("HeroCommand","HeroMainModel")
	//fscommand("DisplayModel",1+'\2'+curModelName+'\2'+1)

	_root.hero_main.hero_info.gotoAndPlay("opening_ani")	
	_root.hero_main.hero_info._visible=true
	ui_equip_info_page._visible=false
	_root.hero_main.bg._visible=false

	_root.bottom_equips.gotoAndPlay("opening_ani")
	_root.titles.gotoAndPlay("opening_ani")
	_root.ui_arrow.gotoAndPlay("opening_ani")

	_root.ui_arrow.next_arrow._visible=true
	_root.ui_arrow.last_arrow._visible=true
	_root.ui_arrow.hero_hit._visible=true
}

ui_title.btn_close.onRelease=function()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroMainCloseBtn");
	/*******End*******/
	fscommand("PlayMenuBack")
	_root._visible=false
	fscommand("ExitBack")
}

function SetUIPath(inputData)
{
	PathObject.isSkill=inputData.isSkill
	PathObject.isEquip=inputData.isEquip
	PathObject.equipIndex=inputData.equipIndex

	_root.hero_main.OnMoveOutOver=function()
	{
		this.OnMoveOutOver=undefined
		CheckPath()
	}
	//CheckPath()
}

function CheckPath()
{
	if(PathObject.isSkill==true)
	{
		var ui_hero_item=ui_hero_main.hero_info.hero_item
		ui_hero_item["btn_skill"].onRelease()

		PathObject.isSkill=false
	}else if(PathObject.isEquip==true)
	{
		var equipButton=equipButtons[PathObject.equipIndex];
		equipButton.onRelease()
		PathObject.isEquip=false
	}
}

//for play num ani
function PlayCombat(num)
{
	_root.hero_info.gotoAndPlay(2)
	var strNum = num.toString();
	var arrayNum = strNum.split("");
	var nLength = arrayNum.length;

	if(nLength<=3)
	{
		_root.hero_info.extra_num.gotoAndStop("three")
	}else if(nLength<=4)
	{
		_root.hero_info.extra_num.gotoAndStop("four")
	}else if(nLength<=5)
	{
		_root.hero_info.extra_num.gotoAndStop("five")
	}

	for(var i = 0; i < 5; ++i)
	{
		var item=_root.hero_info.extra_num["num"+(i+1)]
		item._visible=true
		if(arrayNum[i]!=undefined)
		{
			var temp = Number(arrayNum[i]);
			item.gotoAndStop(temp + 1)
		}else
		{
			item._visible=false
		}
	}

	_root.click_bg._visible=true
	_root.hero_info.OnMoveOutOver=function()
	{
		_root.click_bg._visible=false
	}
}


//--------------------------------touch for 3D model------------------------------------------------------------

function updateFrame()
{
	var tempX=ui_arrow.hero_hit._xmouse-tempPosX

	var rotateAngle=-tempX/5
	if(math.abs(rotateAngle)>=0.2)
	{
		fscommand("HeroCommand","RotateModel\2"+(-tempX/5))
		//fscommand("RotateModel",-tempX/5)
	}

	tempPosX=ui_arrow.hero_hit._xmouse
}

//the screen move for move model 
ui_arrow.hero_hit.onPress=function()
{
	ui_arrow.onEnterFrame=updateFrame
	initPosX=ui_arrow.hero_hit._xmouse
	tempPosX=ui_arrow.hero_hit._xmouse
}

//the touch for play model aniamtion
ui_arrow.hero_hit.onRelease=ui_arrow.hero_hit.onReleaseOutside=function()
{
	ui_arrow.onEnterFrame=null
	var temp=ui_arrow.hero_hit._xmouse-initPosX
	if(math.abs(temp)<=4)
	{
		fscommand("HeroCommand","PlayModelAni")
		//fscommand("PlayModelAni")
	}
}

function showUnread(mc,isShow)
{
	//mc=_root
	var tempName="unreadMC"
	if(mc[tempName]==undefined)
	{
		var xPos=mc._width
		if(mc.hit!=undefined)
		{
			xPos=mc.hit._width
		}
		mc.attachMovie("icon_unread",tempName,mc.getNextHighestDepth(),{_x:xPos-27,_y:0})
	}
	mc[tempName]._visible=isShow
}


function GetNumberMC()
{
	//equip_info.equip_strengthen
	var mc=ui_equip_info.equip_strengthen//ui_equip_info_page.equip_info.equip_strengthen

	if(numberAniMCs==undefined)
	{
		numberAniMCs=new Array()
		var tempName="number_ani_"+0
		mc.attachMovie("tube_add_number_ani",tempName,mc.getNextHighestDepth(),{_x:0,_y:0})

		numberAniMCs.push(mc[tempName])
		mc[tempName]._visible=false
	}

	for(var i=0;i<numberAniMCs.length;i++)
	{
		if(numberAniMCs[i]._visible==false)
		{
			return numberAniMCs[i]
		}
	}
	NumberCount++
	var Index=NumberCount

	var tempName="number_ani_"+Index
	mc.attachMovie("tube_add_number_ani",tempName,mc.getNextHighestDepth(),{_x:0,_y:0})
	numberAniMCs.push(mc["number_ani_"+Index])

	return mc["number_ani_"+Index]
}

function SetUIAlpha(alphaValue)
{
	_root._alpha=alphaValue
}

function SetSkillUnread(isSkillPointEnough)
{
	var mc=ui_hero_item.btn_skill
	showUnread(mc,isSkillPointEnough)
}