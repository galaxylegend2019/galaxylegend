var ui_all=_root.upgrade_result
var attrDatas
var ui_drag_list
var curType

var mc_skill_attr=ui_all.skill_info
var mc_common_attr=ui_all.attr.attr_list

var left_item=ui_all.left_item
var right_item=ui_all.right_item
var mc_icons=new Array(left_item,right_item)

_root.onLoad=function()
{
	_root._visible=false
	var skill_info=mc_skill_attr.skill_attr.skill_info

	if(skill_info.skill_icon.icons==undefined)
	{
		skill_info.skill_icon.loadMovie("CommonSkills.swf")
	}
}

function InitFlash()
{
	mc_skill_attr._visible=false
	mc_common_attr._visible=false
}


//-------------------------common function--------------------------------

function SetUpgradeResult(inputData)
{
	fscommand("HeroCommand","ShowQualityEffect")
	_root._visible=true
	/*******FTE*******/
	fscommand("TutorialCommand","Activate" + "\2" + "HeroUpgradeLoad");
	/*******End*******/
	ui_all.gotoAndPlay("opening_ani")
	SetBoardVisible(true)

	attrDatas=inputData.attrDatas

	//set common icon for all item
	for(var i=0;i<2;i++)
	{
		var mc=mc_icons[i]
		SetIcon(mc,inputData.iconInfos[i],inputData.dataType)
	}

	if(inputData.dataType=="hero_star")
	{
		SetStarAdvance(inputData)
	}else if(inputData.dataType=="equip_quality")
	{
		fscommand("PlaySound","equipment levelup")
		SetEquipAdvance(inputData)
	}else if(inputData.dataType=="hero_quality")
	{
		SetHeroAdvance(inputData)
	}

	//the mc tag is "hero_star","equip_quality","hero_quality"
	ui_all.type_title.gotoAndStop(inputData.dataType)
	SetHeroData(inputData)

	ui_all.btn_close.onRelease=ui_all.bg.onRelease=OnClose

	ui_all.OnMoveOutOver = function(){
		fscommand("PlayMenuBack")
		fscommand("HeroCommand","HideQualityEffect")
	 	_root._visible=false
	}

}

function OnClose()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroUpgradeCloseBtn");
	/*******End*******/
	ui_all.gotoAndPlay("closing_ani");
}

function SetHeroData(inputData)
{
	var mc_hero_title=ui_all.hero_title
	mc_hero_title.hero_level.hero_level.text=inputData.level
	mc_hero_title.hero_name.name_text.text=inputData.heroName
	for(var j = 1 ; j <= 5 ; j++){
		var starFlag=inputData.star >= j ? "normal" : "Idle"
		mc_hero_title["star_" + j].gotoAndStop(starFlag);
	}
}

function SetIcon(mc,inputData,iconType)
{
	var iconData=inputData.iconData
	var starNum=inputData.starNum

	mc.star_plane._visible=false
	if(iconType=="equip_quality")
	{
		mc.item_icon.loadMovie("CommonIcons.swf")
		mc.item_icon.IconData=iconData
		if(mc.item_icon.UpdateIcon) 
		{
			trace("CommonIcons updateIcon")
			mc.item_icon.UpdateIcon(); 
		}

	}else
	{
		mc.item_icon.loadMovie("CommonHeros.swf")
		mc.item_icon.IconData=iconData
		if(mc.item_icon.hero_icon.UpdateIcon) 
		{
			mc.item_icon.hero_icon.UpdateIcon(); 
		}

		if(iconType=="hero_star")
		{
			mc.star_plane._visible=true
			mc.star_plane.star.gotoAndStop(starNum)
		}
	}

}

//-------------------------show for equip advance-------------------------
//use attr
function SetEquipAdvance(inputData)
{
	mc_skill_attr._visible=false
	//mc_common_attr._visible=true
	ui_drag_list=mc_common_attr

	SetAttr()
}


//-------------------------shwo for hero star up----------------------
//use attr
function SetStarAdvance(inputData)
{
	mc_skill_attr._visible=false
	//mc_common_attr._visible=true
	ui_drag_list=mc_common_attr

	SetAttr()
}

//-------------------------shwo for hero quality up----------------------
//if unlock skill,show skillInfo,or show attr
//use hero attr
function SetHeroAdvance(inputData)
{
	var isUnlockSkill=inputData.isUnlockSkill

	mc_skill_attr._visible=isUnlockSkill
	//mc_common_attr._visible=!isUnlockSkill

	if(isUnlockSkill)
	{
		var skill_info=mc_skill_attr.skill_attr.skill_info
		skill_info.skill_name.text=inputData.skillName
		skill_info.level.text="LV.1"
		skill_info.skill_desc.text=inputData.skillDesc

		if(skill_info.skill_icon.icons==undefined)
		{
			skill_info.skill_icon.loadMovie("CommonSkills.swf")
		}
		skill_info.skill_icon.icons.icons.gotoAndStop("skill_"+inputData.id)

	}else
	{	
		//ui_drag_list=mc_common_attr.attr_list
	}
	ui_drag_list=mc_common_attr

	SetAttr()
}

//for common attr list for drag is show
function SetAttr()
{
	if(ui_drag_list==undefined)
	{
		return
	}

	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("item_upgrade_info",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item){

		var attr_data = attrDatas[index_item-1];
		var item_mc = mc;

		if(attr_data)
		{
			item_mc._visible = true;
			item_mc.attr_name.htmlText = attr_data.attrName
			item_mc.last_attr.htmlText = attr_data.attrNum
			item_mc.cur_attr.htmlText = attr_data.nextNum
		}else
		{
			item_mc._visible=false
		}
		
	}

	ui_drag_list.onListboxMove = undefined;
	var listLength=attrDatas.length
	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
}




//for call hero upgrade--------------------------------------------------------

function SetBoardVisible(flag)
{
	ui_all.type_title._visible=flag
	ui_all.skill_info._visible=flag
	ui_all.left_item._visible=flag
	ui_all.arrow._visible=flag
	ui_all.right_item._visible=flag
	ui_all.attr._visible=flag
}

ui_all.btn_close.onRelease=ui_all.bg.onRelease=function()
{
    ui_all.gotoAndPlay("closing_ani");
}

ui_all.OnMoveOutOver = function(){
    fscommand("PlayMenuBack")
    fscommand("HeroCommand","CallHeroHide")
    _root._visible=false
}


function ForCallHero(inputData)
{
	_root._visible=true
	fscommand("HeroCommand","ShowQualityEffect")
	_root._visible=true
	ui_all.gotoAndPlay("opening_ani")
	
	SetBoardVisible(false)

    SetHeroData(inputData)
}
function HideCallHeroUI()
{
    if(_root._visible)
    {
        ui_all.btn_close.onRelease();
    }
}
function FTEOnclickConfirm()
{
	ui_all.btn_close.onRelease();
}
