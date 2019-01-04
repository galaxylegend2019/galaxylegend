var ui_all
var maxItemCount=4
var heroDatas

var numberCount=0
var btn_skill
var lastSkill
var listView
var contentText
function InitMC(mc)
{
	ui_all=mc
	ui_all.blank_replace._visible=false
	if(ui_all.blank_replace.item_tips==undefined)
	{
		ui_all.blank_replace.loadMovie("ItemTip.swf")
		ui_all.blank_replace._x=350
		ui_all.blank_replace._y=100
		ui_all.blank_replace._visible=false
	}
	ui_all.bg.onRelease=function()
	{
		if(lastSkill!=undefined)
		{

		}
	}
}

//init skill data info from lua
function InitData(inputHeroData:Array)
{
	heroDatas=inputHeroData

	heroDatas.skillInfos=new Array()

	ui_all.hero_name.hero_name.text=inputHeroData.heroNameText

	for(var i=0;i<inputHeroData.skills.length;i++)
	{
		var obj=inputHeroData.skills[i]
		heroDatas.skillInfos.push(obj)
	}

	//init skill button after data is be inited
	InitButtons()

	SetHeroInfo(inputHeroData)

	ui_all.btn_close.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickSkillPageCloseBtn");
		/*******End*******/
		_root.closeUI()
	}
}

function SetMoneyInfo(moneyData)
{
	var titles=ui_all
	titles.energy.energy_text.text=moneyData.technique
	titles.money.money_text.text=moneyData.money
	titles.credit.credit_text.text=moneyData.credit

	titles.energy.btn_add.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		fscommand("GoToNext", "Affair");
	}
	titles.money.btn_add.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		fscommand("GoToNext", "Affair");
	}
	titles.credit.btn_add.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		fscommand("GoToNext", "Purchase");
	}
}

function SetHeroInfo(heroData)
{
	var hero_title=ui_all.hero_name
	hero_title.hero_level.hero_level.text=heroData.level
	hero_title.hero_name.hero_name.text=heroData.heroNameText

	for(var j = 1 ; j <= 5 ; j++){
		var starFlag=heroData.star >= j ? "normal" : "Idle"
		hero_title["star_" + j].gotoAndStop(starFlag);
	}
}


function SetSkillData(skill)
{
	//var skill=ui_all["skill_"+skillIndex];
	//var curData=heroDatas.skillInfos[skillIndex-1]
	var curData=skill.skillData

	if(skill.skill_icon.skill_icon.icons==undefined)
	{
		skill.skill_icon.skill_icon.loadMovie("CommonSkills.swf")
	}
	skill.skill_icon.skill_icon.icons.icons.gotoAndStop("skill_"+curData.id)

	skill.level_text.htmlText=curData.levelText
	skill.btn_add.money_info.money_num.htmlText=curData.moneyText
	skill.btn_add_black.money_info.money_num.htmlText=curData.moneyText

	skill.skill_name.name_text.text=curData.skillName

	var isVisible=!skill.isUp
	skill.skill_icon.locked._visible=isVisible
	skill.btn_unlock._visible=isVisible

	skill.btn_add_black._visible=!skill.isEnough
}

function SetSkillPointData(skillPointData)
{
	ui_all.skill_title.skill_point.htmlText=skillPointData.point
	ui_all.skill_title.timestr.text=skillPointData.timeStr
}


function InitButtons()
{
	for(var i=1;i<=maxItemCount;i++)
	{
		var itemIndex=heroDatas.skillInfos[i-1].skillIndex
		var skill=ui_all["skill_"+itemIndex];

		skill.skillData=heroDatas.skillInfos[i-1]
		skill.skillID=heroDatas.skillInfos[i-1].id
		skill.describe=heroDatas.skillInfos[i-1].describe

		skill.qualityNotEnough=heroDatas.skillInfos[i-1].qualityText

		skill.isUp=heroDatas.skillInfos[i-1].unLock
		skill.isEnough=heroDatas.skillInfos[i-1].isEnough

		if(i>heroDatas.skillInfos.length)
		{
			skill._visible=false
			continue;
		}
		SetSkillData(skill)

		skill.btn_unlock.onRelease=function()
		{
			fscommand("HeroCommand","HeroSkillUnlock")
		}

		skill.btn_add.onRelease=skill.btn_add_black.onRelease=function()
		{
			/*******FTE*******/
			fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickUpgradeSkillBtn");
			/*******End*******/
			fscommand("PlayMenuConfirm")
			btn_skill=this
			if(this._parent.isUp==false)
			{
				//ShowSkillUpgrade(this._parent.qualityNotEnough)
				//return
			}
			var id=this._parent.skillID
			//fscommand("HeroSkillUpgrade",id)
			fscommand("HeroCommand","HeroSkillUpgrade\2"+id)
		}
		skill.desc._visible=false
		skill.bg.onRelease=function()
		{
			if(lastSkill!=undefined)
			{
				lastSkill.gotoAndPlay("closing_ani")
				lastSkill.OnMoveOutOver=function()
				{
					this._visible=false
				}				
			}

			lastSkill=this._parent.desc
			this._parent.desc._visible=true
			this._parent.desc.gotoAndPlay("opening_ani")
			this._parent.desc.desc.desc.text=this._parent.describe

			listView=this._parent.desc.desc.board
			contentText=this._parent.describe
			SetSkillDescList()
			this._parent._parent.bg.onRelease=function()
			{
				lastSkill.gotoAndPlay("closing_ani")
				lastSkill.OnMoveOutOver=function()
				{
					this._visible=false
				}
			}
		}
	}
}


function ShowSkillUpgrade(skillText)
{

	if(ui_all.skilldesc==undefined)
	{
		return
	}

	numberCount++
	var tempName="tempName"+numberCount
	ui_all.skilldesc.attachMovie("tube_add_number_ani",tempName,ui_all.skilldesc.getNextHighestDepth(),{_x:200,_y:0})

	ui_all.skilldesc[tempName].add_num.num_text.htmlText=skillText
	ui_all.skilldesc[tempName].gotoAndPlay("opening_ani")
	ui_all.skilldesc[tempName].OnMoveOutOver=function()
	{
		this._visible=false
	}
}

function SetSkillDescList()
{
	listView.clearListBox();
	listView.initListBox("heroskill_info_txt",0,true,true);
	listView.enableDrag(true);
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc,index_item){
		mc.tt.htmlText=contentText
		mc.bg._height=mc.tt.textHeight
		mc.ItemHeight=mc.bg._height

		mc.onRelease=function(){
			this._parent.onReleasedInListbox();
		}

		mc.onReleaseOutside = function(){
			this._parent.onReleasedInListbox();
		}
		mc.onPress =function(){
			this._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
	}
	listView.addListItem(1, false, false);
}