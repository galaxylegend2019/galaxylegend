var title_page=_root.title_page
var form_page=_root.form_page
var star_page=_root.star_page
var skill_page=_root.skill_page
var combination_page=_root.combination_page
var combinationData
var	title_icon=title_page.title

var curHeroData
var curShowPage=undefined
var MoneyData=undefined
var StarUpInfo=undefined
//---------------------------------for init swf page
this.onLoad()
{
	_root._visible=false
	form_page._visible=false
	star_page._visible=false
	skill_page._visible=false
	combination_page._visible=false
}

function closeUI()
{
	fscommand("PlayMenuBack")
	if(curShowPage!=undefined)
	{
		title_page.btn_close._visible=false
		curShowPage.gotoAndPlay("closing_ani")

		if(curShowPage.SetUIPlay!=undefined)
		{
			curShowPage.SetUIPlay(false)
		}

		curShowPage.OnMoveOutOver=function()
		{
			this._visible=false
			_root._visible=false
			title_page.btn_close._visible=true

			fscommand("ExitBack")
			this.OnMoveOutOver=undefined
		}
	}
}

function InitHeroDetailData(inputData)
{
	curHeroData=inputData
	if(curShowPage!=undefined)
	{
		curShowPage.InitData(curHeroData)
	}
}

//---------------------------------for skill
function SetSkillPointData(skillPointData)
{
	skill_page.SetSkillPointData(skillPointData)
}
function SetMoneyInfo(inputData)
{
	MoneyData=inputData
	//skill_page.SetMoneyInfo(MoneyData)
	InitMoneyMC(MoneyData)

}

function InitMoneyMC(moneyData)
{
	var titles=title_page
	titles.money.money_text.text=moneyData.money
	titles.credit.credit_text.text=moneyData.credit
}

title_page.money.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	fscommand("GoToNext", "Affair");
}
title_page.credit.onRelease=function()
{
	fscommand("PlayMenuConfirm")
	fscommand("GoToNext", "Purchase");
}

//-------------------------------------------------for automat call function------------------------------
function SkillShow()
{
	trace("skill show")
	_root._visible=true	
	title_icon.gotoAndStop("skill")

	skill_page._visible=true
	skill_page.gotoAndPlay("opening_ani")
	curShowPage=skill_page

	skill_page.InitMC(skill_page)
	skill_page.InitData(curHeroData)	
	skill_page.SetMoneyInfo(MoneyData)
}

function FormShow()
{
	_root._visible=true
	title_icon.gotoAndStop("form")

	form_page._visible=true
	form_page.gotoAndPlay("opening_ani")
	curShowPage=form_page

}

function StarShow()
{
	_root._visible=true
	title_icon.gotoAndStop("star")

	star_page._visible=true
	//star_page.gotoAndPlay("opening_ani")
	star_page.InitMC(star_page)
	star_page.InitData(curHeroData)

	star_page.SetUIPlay(true)
	curShowPage=star_page
}

function InitCombination(datas)
{
	trace("InitData-----")
	combinationData=datas
}
function CombatShow()
{
	trace("CombatShow")
	_root._visible=true
	title_icon.gotoAndStop("combination")

	combination_page._visible=true
	combination_page.gotoAndPlay("opening_ani")
	curShowPage=combination_page

	combination_page.InitMC(combination_page)
	combination_page.InitData(combinationData)
}


function SetAttrList(mc_drag_list)
{
	if(StarUpInfo==undefined)
	{
		return
	}
	//mc_content
	var ui_drag_list=mc_drag_list
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("item_list_info",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item)
	{
		var datas=StarUpInfo[index_item-1]
		mc._visible=true
		mc.attr_name.text=datas.attrName
		mc.attr_num.text=datas.attrNum
		mc.next_attr_num.htmlText=datas.nextNum
		//mc.next_attr_num.htmlText="<font color='#ff0000' size='12'>This is a text</font>" 
		//mc.next_attr_num.htmlText="<font color='# ff0000'> {NUMBER1} </font>"
	}

	ui_drag_list.onItemMCCreate = function(mc){
		//mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	var listLength=StarUpInfo.length

	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
}

function StarUpShow(datas)
{
	star_page.ShowStarUp(datas)
}

function SetUIAlpha(alphaValue)
{
	_root._alpha=alphaValue
}