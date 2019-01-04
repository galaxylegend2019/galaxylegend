import com.tap4fun.utils.Utils;
var HeroInfoTabIndex = 1
var HeroEquipTabIndex = 2
var HeroSkillTabIndex = 3
var HeroStroryTabIndex = 4
var CurTabIndex = 1

var curentHeroData = new Object()
var equipButtons:Array;
var equipDatas:Array;
var heroDetailData:Array;
var storyInfoData;
var curSelectEquipIndex = 1
var curFocusEquipButton

var showSpeed = 5
var frameCount = 0
var dataIndex = 0
var attrNumberDatas
var NumberPosX
var NumberPosY
var numberAniMCs:Array
var AllAwardMc = new Array()
var AllSkillMc = new Array()
var skillMcindex = 0
var g_heroTypeDict = new Array()	// 12 elements, name 1,...,6, info 1, ... 6





// the old ui code ,ready for update
this.onLoad = function()
{
	HideAllLayer();
	InitUIState();
	InitCloseButton();

	_root.popup._visible = false
}

function SetHeroTypeDict(tdict)
{
	if (tdict.length != 12) {
		trace("xxpp bad SetHeroTypeDict")
		return 
	}
	for (var i=0; i<tdict.length; ++i)
		g_heroTypeDict.push(tdict[i])
}

function InitCloseButton()
{
	_root.top_ui.btn_close.onRelease = function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroMainCloseBtn");
		/*******End*******/
		fscommand("PlayMenuBack")
		_root._visible=false
		fscommand("ExitBack")
		fscommand("HeroCommand","BackHeroListLayer")
	}
}

function HideAllLayer()
{
	_root._visible = false;
	_root.power_number._visible = false;
	_root.heroMode._visible = false;
	_root.top_ui._visible = false;
	_root.filter_contral._visible = false;
	_root.hero_story._visible = false;
	_root.hero_equipment._visible = false;
	_root.hero_skills._visible = false;
	_root.hero_details._visible = false;
}

function ShowAllLayer()
{
	_root._visible = true;
	_root.power_number._visible = true;
	_root.heroMode._visible = true;
	_root.top_ui._visible = true;
	_root.filter_contral._visible = true;
}

function HideTabContentLayer()
{
	_root.hero_story._visible = false;
	_root.hero_equipment._visible = false;
	_root.hero_skills._visible = false;
	_root.hero_details._visible = false;
}

function InitUIState()
{
	InitFilterContral();
}

function InitFilterContral()
{
	var Filter = _root.filter_contral
	for(var i = 1; i < 5; i++)
	{
		var item = Filter["filter_button_" + i];
		item.index = i;
		item.onRelease = function()
		{
			for(var j = 1; j < 5; j++)
			{
                var curitem = _root.filter_contral["filter_button_" + j];
				if(curitem)
				{
                    curitem.gotoAndStop("Normal")
				}
			}
			this.gotoAndStop("Selected")
			SetCurTabInde(this.index)
			UpdateTabPanelContent()
		}
	}
}

function MoveIn()
{
	ShowAllLayer()
	_root.filter_contral["filter_button_" + 1].onRelease();
	UpdateHeroInfo(true);
	UpateHeroInfoUnRead();
	UpdateEquipmentUnRead();
	SetSkillUnRead();
}

function ShowHeroEquipmentTab()
{
	ShowAllLayer()
	_root.filter_contral["filter_button_" + 2].onRelease();
	UpdateHeroInfo(true);
	UpateHeroInfoUnRead();
	UpdateEquipmentUnRead();
	SetSkillUnRead();
}

function SetCurTabInde(tabIndex)
{
	CurTabIndex = tabIndex;
}

function UpdateTabPanelContent()
{
	HideTabContentLayer()
	if(CurTabIndex == 1)
	{
		_root.hero_details._visible = true;
		_root.hero_details.gotoAndPlay("opening_ani")
		UpdateHeroInfoContent()
	}
	else if(CurTabIndex == 2)
	{
		_root.hero_equipment._visible = true;
		_root.hero_equipment.equipment_info1.gotoAndPlay("opening_ani")
		_root.hero_equipment.hero_evolve.gotoAndPlay("opening_ani");
		_root.hero_equipment.gotoAndPlay("opening_ani");
		UpdateHeroEquipContent()
	}
	else if(CurTabIndex == 3)
	{
		_root.hero_skills._visible = true;
		_root.hero_skills.gotoAndPlay("opening_ani");
		UpdateHeroSkillContent()
	}
	else if(CurTabIndex == 4)
	{
		_root.hero_story._visible = true;
		_root.hero_skills.gotoAndPlay("opening_ani");
		UpdateHeroStoryContent()
	}
}

function UpdateCurPanleContent()
{
	HideTabContentLayer()
	if(CurTabIndex == 1)
	{
		_root.hero_details._visible = true;
		UpdateHeroInfoContent()
	}
	else if(CurTabIndex == 2)
	{
		_root.hero_equipment._visible = true;
		UpdateHeroEquipContent()
	}
	else if(CurTabIndex == 3)
	{
		_root.hero_skills._visible = true;
		UpdateHeroSkillContent()
	}
	else if(CurTabIndex == 4)
	{
		_root.hero_story._visible = true;
		UpdateHeroStoryContent()
	}
}

function UpateHeroInfoUnRead()
{
    _root.filter_contral.filter_button_1.red_point._visible = curentHeroData.isStarUp || curentHeroData.isHerolevelUp
}		

function UpdateEquipmentUnRead()
{
	_root.filter_contral.filter_button_2.red_point._visible = curentHeroData.isEquipUp;
}

function SetSkillUnRead()
{
	_root.filter_contral.filter_button_3.red_point._visible = curentHeroData.isSkillUp
}

function UpdateSkillUnRead(isSkillPointEnough)
{
	var isUnRead = false
	for(var i = 1; i <= 5; i ++)
	{
		var curSkills = curentHeroData.skills[i - 1]
		if(curSkills.isEnough)
		{
			isUnRead = true
			break;
		}
	}
	_root.filter_contral.filter_button_3.red_point._visible = (isSkillPointEnough && isUnRead)
}

_root.hero_details.details_list.list.onEnterFrame = function()
{
	this.OnUpdate()
}

_root.hero_details.details_list.list.onItemEnter = function(mc,index_item)
{
	trace("xxxxxxxxxxxxxx")
	trace(index_item)
	var _Height_
	mc.hero_info._visible = false
	mc.endAtr._visible = false
	mc.atr._visible = true
	if(index_item == 1)
	{
		mc.hero_info._visible = true
		//mc.ItemHeight = mc.hero_info._height
		mc.hero_info.hero_flag_icon.gotoAndStop(curentHeroData.heroAttrType);
	}
	else if(index_item == heroDetailData.length)
	{
		mc.endAtr._visible = true
		mc.ItemHeight = 60
		//mc.isSpecial = true
	}
	else
	{
		mc.atr._visible = true
		mc.ItemHeight = 60
		//mc.isSpecial = true
	}
	
	
	var itemData = heroDetailData[index_item - 1];
	if(itemData)
	{
		mc.atr.attr_name.htmlText = itemData.name;
		mc.atr.last_attr.text = itemData.value;
		mc.endAtr.attr_name.htmlText = itemData.name;
		mc.endAtr.last_attr.text = itemData.value;
	}
}	

function UpdateHeroInfoContent()
{
	var curComponent = _root.hero_details
	curComponent.lv_info.level_text.text = curentHeroData.level;
	curComponent.lv_info.combat_text.text = curentHeroData.combatNumber;

	var process = (curentHeroData.curStarExp / curentHeroData.nextStarExp) * 100 + 1
	if(process > 100)
	{
		process = 100
	}
	curComponent.info_progress_bar.dna_bar.txt_progress.htmlText = curentHeroData.chipStarCountText
	curComponent.info_progress_bar.dna_bar.gotoAndStop(process);
	if(curentHeroData.isMaxStar)
	{
		curComponent.info_progress_bar.btn_add1._visible = false
		curComponent.info_progress_bar.dna_bar.txt_progress._visible = false
		curComponent.info_progress_bar.dna_bar.gotoAndStop(100)
	}
	else
	{
		curComponent.info_progress_bar.btn_add1._visible = true
		curComponent.info_progress_bar.dna_bar.txt_progress._visible = true
	}

	if(curentHeroData.isStarEnough)
	{
		if(curentHeroData.isStarUp)
		{
			curComponent.add_star._visible = true;
			curComponent.add_star.onRelease = function()
			{
				fscommand("PlayMenuConfirm")
				fscommand("HeroCommand","HeroStarUpgrade")
			}
		}
		else
		{
			curComponent.add_star._visible = false		
		}		
	}
	else
	{
		curComponent.add_star._visible = false;	
	}
    curComponent.info_progress_bar.btn_add1.yellowpoint._visible = false
    curComponent.info_progress_bar.btn_add1.onRelease = function()
    {
        fscommand("PlayMenuConfirm")
        var id = curentHeroData.starID
        var needNum = curentHeroData.nextStarExp
        fscommand("ShowItemOrigin",id  +'\2' + needNum)
    }

	var expProcess = (curentHeroData.curExp / curentHeroData.nextExp) * 100 + 1
	if(expProcess > 100)
	{
		expProcess = 100
	}
	curComponent.info_progress_bar.exp_bar.gotoAndStop(expProcess);
	curComponent.info_progress_bar.exp_bar.txt_progress.htmlText = curentHeroData.expText;
    curComponent.info_progress_bar.btn_add2.yellowpoint._visible = curentHeroData.isHerolevelUp;
	curComponent.info_progress_bar.btn_add2.onRelease = function()
	{
		fscommand("HeroCommand","PopUseExp")
	}

    curComponent.lv_info.poten_text.text = curentHeroData.str_Potential

    var AtributonList = curComponent.details_list.list
    var TotalHight = 0
    for(var mc in AllAwardMc)
    {
        AllAwardMc[mc].removeMovieClip();
    }
    var count = heroDetailData.length + 1
    for(var i = 1; i <= count; ++i )
    {
        if(i == 1)
        {
            var heroType = AtributonList.slideItem.attachMovie("hero_details_info_0","heroType",AtributonList.slideItem.getNextHighestDepth());
            heroType.hero_flag_icon.gotoAndStop(curentHeroData.heroAttrType)
            heroType.hero_flag_icon.desc_info.text = curentHeroData.Describe_Desc
            heroType._y = TotalHight;
            TotalHight = TotalHight + (heroType._height)
            // type
            {
                for (var j=1; j<=4; ++j)
                {
                    heroType.hero_flag_icon.info_main["icon_"+j]._visible = false
                }
                for (var j=0; j<curentHeroData.t_Type.length; ++j)
                {
					var themc:MovieClip = heroType.hero_flag_icon.info_main["icon_"+(j+1)]
					themc._visible = true
					themc.gotoAndStop(curentHeroData.t_Type[j])
					themc.info = curentHeroData.t_Type[j]
					themc.onRelease = function() {
						var popupmc = _root.popup
						popupmc._visible = true
						popupmc.icon.gotoAndStop(this.info)
						popupmc.info_txt.txt.text = g_heroTypeDict[6+this.info-1]
						popupmc.name.txt.text = g_heroTypeDict[this.info-1]
						popupmc.gotoAndPlay("opening_ani")

						popupmc.hitzone._visible = true
						popupmc.hitzone.onRelease = function() {
							_root.popup.gotoAndPlay("closing_ani")
							_root.popup.hitzone._visible = false
						}
					}
				}
			}

            AllAwardMc.push(heroType)
        }
        else if(i == count)
        {
            var heroInfoEnd = AtributonList.slideItem.attachMovie("hero_details_info_list2","heroInfoEnd",AtributonList.slideItem.getNextHighestDepth());
            heroInfoEnd.attr_name.htmlText = heroDetailData[i - 2].name;
            heroInfoEnd.last_attr.text = heroDetailData[i -2].value;
            heroInfoEnd._y = TotalHight;
            TotalHight = TotalHight + (heroInfoEnd._height)
            AllAwardMc.push(heroInfoEnd)
        }
        else
        {
            var heroInfo = AtributonList.slideItem.attachMovie("hero_details_info_list_2","heroInfo",AtributonList.slideItem.getNextHighestDepth());
            heroInfo.attr_name.htmlText = heroDetailData[i - 2].name;
            heroInfo.last_attr.text = heroDetailData[i -2].value;
            heroInfo._y = TotalHight;
            TotalHight = TotalHight + (heroInfo._height)
            AllAwardMc.push(heroInfo)
        }
    }
    AtributonList.slideItem._height = TotalHight
    AtributonList.SimpleSlideOnLoad();
    AtributonList.onEnterFrame = function()
    {
        this.OnUpdate()
    }
    AtributonList.forceCorrectPosition()
}

function UpdateHeroEquipContent()
{
    InitAllEquipButton()
    _root.hero_equipment["equip_" + curSelectEquipIndex].onRelease();
    _root.hero_equipment["equip_" + curSelectEquipIndex].onRelease();
}

function InitAllEquipButton()
{
    var curComponent = _root.hero_equipment
    for(var i = 1; i <= 6; i++)
    {
        var but = curComponent["equip_" + i];
        but.index = i;
        but.onRelease = function()
        {
            for(var j = 1; j <= 6; j++)
            {
                var _curbutton = _root.hero_equipment["equip_" + j]
                _curbutton.selected._visible = false;
            }
            this.selected._visible = true;
            curSelectEquipIndex = this.index
            curFocusEquipButton = this
            UpdateCurEquipmendInfo()
        }

		var dataIndex = equipDatas[i-1].id
		var equipData = equipDatas[i-1];
		but.equipData = equipData
		EquipMentIcon(but)
		but.equip_info.equip_level.text = equipData.levelTxt;
		
		if(equipData.quality > 0)
		{
			but.quality_txt._visible = true
			but.quality_txt.htmlText = equipData.equipQualitytext
		}
		else
		{
			but.quality_txt._visible = false
        }

        var showpt = false
        if (!curentHeroData.isCanUpHeroQuility)
        {
            if (equipData.isCanAdvance)
            {
                if (equipData.isEquipAdvance)
                {
                    showpt = true
                }
            }
            else
            {
                if (equipData.isEquipUpgrade)
                {
                    showpt = true
                }
            }
        }
        but.point._visible = showpt
		// old
		// but.point._visible = (equipData.isEquipAdvance && equipData.isCanAdvance)
	}
}

function EquipMentIcon(but)
{
    but.equip_icon.gotoAndStop(but.equipData.iconData.icon_index)
    but.frame.gotoAndStop("quality_" + but.equipData.iconData.icon_quality);
    but.bg.gotoAndStop("quality_" + but.equipData.iconData.icon_quality)
}

function HideEquipLayer()
{
    var curComponent = _root.hero_equipment
    curComponent.equipment_info1._visible = false;
    curComponent.hero_evolve._visible = false;
}

function IsCanUpgradeHeroQuality()
{
    var flag = true
    for(var i = 1;i <= 6;i++)
    {
        var equipData = equipDatas[i-1];
        if(equipData.quality <= curentHeroData.quality)
        {
            flag = false
        }
    }
    return flag
}

function UpdateCurEquipmendInfo()
{
    HideEquipLayer()
    var curComponent = _root.hero_equipment
    var curEquipmentSelect = equipDatas[curSelectEquipIndex - 1]
    curFocusEquipButton.equipData = curEquipmentSelect
    if(IsCanUpgradeHeroQuality())
    {
        curComponent.hero_evolve._visible = true
        var  heroOne = curComponent.hero_evolve.hero_1
        heroOne.hero_star.gotoAndStop(curentHeroData.star)
        heroOne.hero_level.text = curentHeroData.levelTxt
        if(curentHeroData.quality > 0)
        {
            heroOne.quality_txt._visible = true
        }
        else
        {
            heroOne.quality_txt._visible = false;
        }
        heroOne.quality_txt.htmlText = curentHeroData.heroQualitytext;
        if(heroOne.hero_icon.icons == undefined)
        {
            heroOne.hero_icon.loadMovie("CommonHeros.swf")
        }
        heroOne.hero_icon.IconData = curentHeroData.iconData
        if(heroOne.hero_icon.UpdateIcon)
        {
            heroOne.hero_icon.UpdateIcon()
        }
        //TODO
        var  hero2 =  curComponent.hero_evolve.hero_2
        hero2.hero_star.gotoAndStop(curentHeroData.star)
        hero2.hero_level.text = curentHeroData.levelTxt
        if(curentHeroData.nextQuality > 0)
        {
            hero2.quality_txt._visible = true
        }
        else
        {
            hero2.quality_txt._visible = false;
        }
        hero2.quality_txt.htmlText = curentHeroData.heroNetQualityText;
        if(hero2.hero_icon.icons == undefined)
        {
            hero2.hero_icon.loadMovie("CommonHeros.swf")
        }
        hero2.hero_icon.IconData = curentHeroData.NextQualitIconData
        if(hero2.hero_icon.UpdateIcon)
        {
            hero2.hero_icon.UpdateIcon()
        }

        curComponent.hero_evolve.btn_evolve.onRelease = function()
        {
            /*******FTE*******/
            fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickUpgradeHeroBtn");
            /*******End*******/
            fscommand("PlayMenuConfirm")
            fscommand("HeroCommand","HeroQualityUp")
        }
    }
    else
    {
        curComponent.equipment_info1._visible = true;
        var equipAtrList = curComponent.equipment_info1.item_view.list;
        equipAtrList.clearListBox()
        equipAtrList.initListBox("equipment_info_list_all",0,true,true);
        equipAtrList.enableDrag( true );
        var listLength
        if(curEquipmentSelect.isCanAdvance)
        {
            listLength = curEquipmentSelect.equipmentAttr.length + 1
        }
        else
        {
            listLength = curEquipmentSelect.equipmentAttr.length
        }

        for(var i = 1; i <= listLength; i++)
        {
            equipAtrList.addListItem(i,false,false)
        }
        equipAtrList.onEnterFrame = function()
        {
            this.OnUpdate();
        }
        equipAtrList.onItemEnter = function(mc,index_item)
        {
            var curItemData
            if(index_item == 1 && curEquipmentSelect.isCanAdvance)
            {
                mc.gotoAndStop("atrbution1")
                mc.ItemHeight = mc.evole_atr._height;
                SetEquipEvolvementData(mc.evole_atr,curEquipmentSelect)
            }
            else if (curEquipmentSelect.isCanAdvance)
            {
                curItemData = curEquipmentSelect.equipmentAttr[index_item - 2]
                mc.gotoAndStop("atrbution2")
                mc.ItemHeight = mc.atr._height;
                if(curItemData)
                {
                    mc.atr.attr_name.text = curItemData.attrName
                    mc.atr.last_attr.text = curItemData.lastAttr
                }
            }
            else
            {
                curItemData = curEquipmentSelect.equipmentAttr[index_item - 1]
                mc.gotoAndStop("atrbution2")
                mc.ItemHeight = mc.atr._height;
                if(curItemData)
                {
                    mc.atr.attr_name.text = curItemData.attrName
                    mc.atr.last_attr.text = curItemData.lastAttr
                }
            }
        }

        curComponent.equipment_info1.btn_upgrade.txt_Price.htmlText = curEquipmentSelect.upMoney;
        Utils.ButtonIconAndNumberMidSide(curComponent.equipment_info1.btn_upgrade);
        curComponent.equipment_info1.upgrade_disabled.txt_Price.htmlText = curEquipmentSelect.upMoney;
        Utils.ButtonIconAndNumberMidSide(curComponent.equipment_info1.upgrade_disabled)
        if(curEquipmentSelect.isCanAdvance)
		{
			curComponent.equipment_info1.btn_upgrade._visible = false
			curComponent.equipment_info1.upgrade_disabled._visible = false
			if(curEquipmentSelect.isEquipAdvance)
			{
				curComponent.equipment_info1.btn_evolve._visible = true
				curComponent.equipment_info1.btn_evolve.gotoAndStop("activated")
				curComponent.equipment_info1.btn_evolve.enabled = true;
			}
			else
			{
				curComponent.equipment_info1.btn_evolve._visible = true
				curComponent.equipment_info1.btn_evolve.gotoAndStop("disabled")
				curComponent.equipment_info1.btn_evolve.enabled = false;
			}
		}
		else
		{
			curComponent.equipment_info1.btn_evolve._visible = false
			curComponent.equipment_info1.btn_evolve.enabled = false;
			curComponent.equipment_info1.upgrade_disabled._visible = false
			curComponent.equipment_info1.btn_upgrade._visible = false
			if(curEquipmentSelect.isEquipUpgrade)
			{
				trace("1111")
				curComponent.equipment_info1.btn_upgrade._visible = true
				curComponent.equipment_info1.btn_upgrade.enabled = true;
                curComponent.equipment_info1.btn_upgrade.yellowpoint._visible = true
			}
			else
			{
				trace("2222")
				if(!curEquipmentSelect.isLevelEnough)
				{
					curComponent.equipment_info1.btn_upgrade._visible = true
					curComponent.equipment_info1.btn_upgrade.enabled = true
					curComponent.equipment_info1.btn_upgrade.yellowpoint._visible = false
				}
				else
				{
					curComponent.equipment_info1.upgrade_disabled._visible = true
				}
			}
		}
		curComponent.equipment_info1.equip_name.name_text.htmlText = curEquipmentSelect.equipName
		curComponent.hero_evolve.evolve_title.name_text.htmlText = curentHeroData.heroNameText;
		curComponent.equipment_info1.btn_upgrade.onRelease = function()
		{
			if(!curFocusEquipButton.equipData.isLevelEnough)
			{
				fscommand("HeroCommand","ErrorCode\2"+1)
			}
			else
			{
				fscommand("PlayMenuConfirm")
				var id = curFocusEquipButton.equipData.id
				fscommand("HeroCommand","HeroEquipUpgrade\2"+id)
			}
		}

        curComponent.equipment_info1.btn_evolve.onRelease = function()
        {
            fscommand("PlayMenuConfirm")
            var id = curFocusEquipButton.equipData.id
            fscommand("HeroCommand","HeroEquipAdvance\2"+id)
            curComponent.equipment_info1.btn_evolve.onRelease = undefined;
        }

    }
}

function SetAttrNumber(inputData:Array)
{
    curFocusEquipButton.hero_lv_up_plane.gotoAndPlay(2)

    attrNumberDatas = inputData
    if(ui_equip_info.equip_strengthen._visible==false)
    {
        return
    }
    var btn_upgrade = _root.atrMove;

    var xPos = btn_upgrade._x
    var yPos = btn_upgrade._y
    NumberPosX = xPos
    NumberPosY = yPos
    showSpeed = 5
    frameCount = 0
    dataIndex = 0
    _root.onEnterFrame = function()
    {
        frameCount++
        if(frameCount >= showSpeed)
        {
            if(dataIndex < attrNumberDatas.length)
            {
                var str = attrNumberDatas[dataIndex]
                trace("fsfsd===str")
                trace(str)
                SetNumber(NumberPosX,NumberPosY-dataIndex*30,str)
                frameCount = 0
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
    var mc_num_ani = GetNumberMC()

    mc_num_ani._x = xPos
    mc_num_ani._y = yPos

    mc_num_ani._visible=true
    mc_num_ani.add_num.num_text.text=str

    mc_num_ani.gotoAndPlay("opening_ani")
    mc_num_ani.OnMoveOutOver=function()
    {
        this._visible=false
    }
    fscommand("PlaySound","sfx_ui_armor_upgrade")
}

function GetNumberMC()
{
    //equip_info.equip_strengthen
    var mc = _root//ui_equip_info_page.equip_info.equip_strengthen

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



function SetEquipEvolvementData(mc,equipData)
{
    for(var i = 1;i <= 2;i++)
    {
        var item = mc["material_"+i]
        item._visible = false
    }

    var equipItems = equipData.needItems
    for(var i = 0;i < equipItems.length;i++)
    {
        var item = mc["material_"+(i+1)]
        item._visible = true

        if(item.material_icon.icons==undefined)
        {
            item.material_icon.loadMovie("CommonIcons.swf")
        }
        item.material_icon.IconData=equipItems[i].iconData
        if(item.material_icon.UpdateIcon)
        {
            item.material_icon.UpdateIcon();
        }


        item.btn_add._visible = equipItems[i].curCount < equipItems[i].count
        item.number_txt.text = equipItems[i].count
        item.costItem = equipItems[i]
        item.onRelease = function()
        {
            fscommand("PlayMenuConfirm")
            fscommand("ShowItemOrigin",this.costItem.id + "\2" + this.costItem.count)
        }
    }
}

function UpdateHeroSkillContent()
{
    trace("--------------------------skills = ")
    trace("1 = " + curentHeroData.skills[0])
    var allSkills = curentHeroData.skills
    var listView = _root.hero_skills.skills_list.list;
    listView.allSkills = allSkills;
    listView.clearListBox();
    listView.initListBox("hero_skill_list",0,true,true);
    listView.enableDrag(true);
    listView.onEnterFrame = function(){
        this.OnUpdate();
    }

    AllSkillMc =new Array()
    listView.onItemEnter = function(mc, index_item){
        AllSkillMc.push(mc)
        mc.skillIndex = mc._parent.allSkills.length - index_item - 1;
        var skillInfo = mc._parent.allSkills[mc.skillIndex];
        if(!skillInfo.unLock)
        {
            mc.gotoAndStop(3);
        }
        else if(skillInfo.isEnough)
        {
            mc.gotoAndStop(1);
            mc.btn_upgrade.txt_Price.htmlText = skillInfo.moneyText;
            Utils.ButtonIconAndNumberMidSide(mc.btn_upgrade)
            mc.btn_upgrade.yellowpoint._visible = curentHeroData.isSkillUp

        }
        else
        {
            mc.gotoAndStop(2);
            mc.no_button.yellowpoint._visible = false
        }
        mc.desc._visible = false;
        mc.desc.desc.mc.tt.htmlText = skillInfo.describe;
        mc.name_text.htmlText = skillInfo.skillName;
        mc.level_text.htmlText = skillInfo.levelText;

        mc.bar.gotoAndStop(Math.max(skillInfo.levelPercent, 1));

        if(mc.skill_icon.skill_icon.icons==undefined)
        {
            mc.skill_icon.skill_icon.loadMovie("CommonSkills.swf");
        }
        mc.skill_icon.skill_icon.icons.icons.gotoAndStop("skill_"+skillInfo.id);

        mc.skill_icon.onRelease = function()
        {
            this._parent.desc._visible = true;
            this._parent.desc.onRelease = function()
            {
                this._visible = false;
                this.onRelease = undefined;
            }
        }
        mc.Index = index_item
        mc.btn_upgrade.onRelease=function()
        {
            /*******FTE*******/
            fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickUpgradeSkillBtn");
            /*******End*******/
            fscommand("PlayMenuConfirm")

            var id=this._parent._parent.allSkills[this._parent.skillIndex].id;
            //fscommand("HeroSkillUpgrade",id)
            fscommand("HeroCommand","HeroSkillUpgrade\2"+id)

            // _root.curSkillMc = this._parent;
            skillMcindex = this._parent.Index
        }

        mc.no_button.gotoAndStop("disabled");
        mc.no_button.txt_Price.htmlText = skillInfo.moneyText;
        Utils.ButtonIconAndNumberMidSide(mc.no_button)
        mc.no_button.skillInfo = skillInfo
        mc.no_button.onRelease = function()
        {
            if(this.skillInfo.moneyEnough)
            {
                fscommand("HeroCommand","ErrorCode\2" + 2)
            }
            else
            {
                fscommand("HeroCommand","ErrorCode\2" + 3)
            }
        }
    }

    for(var i = 0; i < allSkills.length; ++i)
    {
        listView.addListItem(i, false, false);
    }
}

function UpdateOneSkill(skill_index)
{
    var allSkills = curentHeroData.skills
    var listView = _root.hero_skills.skills_list.list;
    var mc = listView.getMcByItemKey(skill_index)
    mc.skillIndex = allSkills.length - skill_index - 1;
    var skillInfo = allSkills[mc.skillIndex];
    if(!skillInfo.unLock)
    {
        mc.gotoAndStop(3);
    }
    else if(skillInfo.isEnough)
    {
        mc.gotoAndStop(1);
        mc.btn_upgrade.txt_Price.htmlText = skillInfo.moneyText;
        Utils.ButtonIconAndNumberMidSide(mc.btn_upgrade)
        mc.btn_upgrade.yellowpoint._visible = curentHeroData.isSkillUp
    }
    else
    {
        mc.gotoAndStop(2);
        mc.no_button.yellowpoint._visible = false
    }
    mc.desc._visible = false;
    mc.desc.desc.mc.tt.htmlText = skillInfo.describe;
    mc.name_text.htmlText = skillInfo.skillName;
    mc.level_text.htmlText = skillInfo.levelText;

    mc.bar.gotoAndStop(Math.max(skillInfo.levelPercent, 1));

    if(mc.skill_icon.skill_icon.icons==undefined)
    {
        mc.skill_icon.skill_icon.loadMovie("CommonSkills.swf");
    }
    mc.skill_icon.skill_icon.icons.icons.gotoAndStop("skill_"+skillInfo.id);
    mc.Index = skill_index
    mc.btn_upgrade.onRelease=function()
    {
        /*******FTE*******/
        fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickUpgradeSkillBtn");
        /*******End*******/
        fscommand("PlayMenuConfirm")

        var id=this._parent._parent.allSkills[this._parent.skillIndex].id;
        //fscommand("HeroSkillUpgrade",id)
        fscommand("HeroCommand","HeroSkillUpgrade\2"+id)

        // _root.curSkillMc = this._parent;
        skillMcindex = this._parent.Index
    }
    mc.no_button.gotoAndStop("disabled");
    mc.no_button.txt_Price.htmlText = skillInfo.moneyText;
    Utils.ButtonIconAndNumberMidSide(mc.no_button)
    mc.no_button.skillInfo = skillInfo
    mc.no_button.onRelease = function()
    {
        if(this.skillInfo.moneyEnough)
        {
            fscommand("HeroCommand","ErrorCode\2" + 2)
        }
        else
        {
            fscommand("HeroCommand","ErrorCode\2" + 3)
        }
    }
}

function UpdateAllSkill()
{
    var allSkills = curentHeroData.skills
    for(var i = 0; i < allSkills.length; ++i)
    {
        UpdateOneSkill(i)
    }
}

function SetSkillPointData(skillPointData)
{
    _root.hero_skills.skill_info.level_text.text = skillPointData.point
    _root.hero_skills.skill_info.combat_text.text = skillPointData.timeStr
}

function ShowSkillUpgrade(skillText)
{
    SetAttrNumber(skillText);
}

function InitCombination(infodata)
{
    storyInfoData = infodata
}

function UpdateHeroStoryContent()
{
    var curComponent = _root.hero_story;
    curComponent.story_title_1.name_text.text = storyInfoData.comTitle;
    curComponent.story_title.LC_UI_Hero_Main_Fetters_BTN.text = storyInfoData.bigTitle;

    var listView = curComponent.story_list.list;
    listView.clearListBox();
    listView.initListBox("hero_story_txt",0,true,true);
    listView.enableDrag(true);
    listView.onEnterFrame = function(){
        this.OnUpdate();
    }

    listView.onItemEnter = function(mc,index_item){
        mc.desc.htmlText = storyInfoData.comDesc
        mc.ItemHeight = mc.desc.textHeight
        mc.onRelease = function(){
            this._parent.onReleasedInListbox();
        }

        mc.onReleaseOutside = function(){
            this._parent.onReleasedInListbox();
        }
        mc.onPress = function(){
            this._parent.onPressedInListbox();
            this.Press_x = _root._xmouse;
            this.Press_y = _root._ymouse;
        }
    }
    listView.addListItem(1, false, false);
}

//set hero info and set euqip info
function SetHeroData(heroItem)
{
    InitCurrenHeroData(heroItem)
    InitHeroDetailData(heroItem.heroDetailData)
    InitEquipData(heroItem.equipments)
}

function UpdateOnlyData(heroItem)
{
    InitCurrenHeroData(heroItem)
    InitHeroDetailData(heroItem.heroDetailData)
    InitEquipData(heroItem.equipments)
    UpdateAllSkill()
    SetSkillUnRead();
}

function UpdateData(heroItem)
{
    InitCurrenHeroData(heroItem)
    InitHeroDetailData(heroItem.heroDetailData)
    InitEquipData(heroItem.equipments)

    UpdateCurPanleContent()

    UpdateHeroInfo(false)
    UpateHeroInfoUnRead();
    UpdateEquipmentUnRead();
    SetSkillUnRead();
}

function UpdateDataWhenSkillUp(heroItem)
{
    InitCurrenHeroData(heroItem)
    InitHeroDetailData(heroItem.heroDetailData)
    InitEquipData(heroItem.equipments)
    UpdateAllSkill()

    UpdateHeroInfo(false)
    UpateHeroInfoUnRead();
    UpdateEquipmentUnRead();
    SetSkillUnRead();
}

function InitCurrenHeroData(inputHeroData)
{
    curentHeroData = inputHeroData
}
//set cur equip info from lua
function InitEquipData(inputEquipData:Array)
{
    equipDatas = inputEquipData
}

function InitHeroDetailData(inputHeroDetail)
{
    heroDetailData = inputHeroDetail
}

function UpdateHeroInfo(isInit)
{
    var curComponent = _root.heroMode
    if(isInit)
    {
        curComponent.gotoAndPlay("opening_ani");
    }

    curComponent.name.name_txt.htmlText = curentHeroData.heroNameHtmltext
    curComponent.hero_star.gotoAndStop(curentHeroData.star);
    curComponent.last_arrow.onRelease = function()
    {
        fscommand("PlayMenuConfirm")
        var dir = -1
        fscommand("HeroCommand","MoveNext\2" + dir)
    }
    curComponent.next_arrow.onRelease = function()
    {
        fscommand("PlayMenuConfirm")
        var dir = 1
        fscommand("HeroCommand","MoveNext\2" + dir)
    }
}

//set common info money
function SetMoneyInfo(moneyData)
{
    var titles = _root.top_ui
    titles.money.money_text.text = moneyData.money
    titles.credit.credit_text.text = moneyData.credit
}

function SetEnergyInfo(point)
{
    var energyBtn =  _root.top_ui.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point

}

_root.top_ui.energy.onRelease=function()
{
    fscommand("PlayMenuConfirm")
    fscommand("GoToNext", "Energy");
}
_root.top_ui.money.onRelease=function()
{
    fscommand("PlayMenuConfirm")
    fscommand("GoToNext", "Affair");
}
_root.top_ui.credit.onRelease=function()
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

//for play num ani
function PlayCombat(num)
{
    _root.power_number.gotoAndPlay(2)
    var strNum = num.toString();
    var arrayNum = strNum.split("");
    var nLength = arrayNum.length;

    if(nLength<=3)
    {
        _root.power_number.extra_num.gotoAndStop("three")
    }else if(nLength<=4)
    {
        _root.power_number.extra_num.gotoAndStop("four")
    }else if(nLength<=5)
    {
        _root.power_number.extra_num.gotoAndStop("five")
    }

    for(var i = 0; i < 5; ++i)
    {
        var item=_root.power_number.extra_num["num"+(i+1)]
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
}


//--------------------------------touch for 3D model------------------------------------------------------------

function updateFrame()
{
    var tempX = _root.heroMode.hero_hit._xmouse - tempPosX

    var rotateAngle = -tempX/5
    if(math.abs(rotateAngle)>=0.2)
    {
        fscommand("HeroCommand","RotateModel\2"+(-tempX/5))
    }

    tempPosX = _root.heroMode.hero_hit._xmouse
}

//the screen move for move model
_root.heroMode.hero_hit.onPress=function()
{
    _root.heroMode.onEnterFrame=updateFrame
    initPosX=_root.heroMode.hero_hit._xmouse
    tempPosX=_root.heroMode.hero_hit._xmouse
}

//the touch for play model aniamtion
_root.heroMode.hero_hit.onRelease=_root.heroMode.hero_hit.onReleaseOutside=function()
{
    _root.heroMode.onEnterFrame=null
    var temp=_root.heroMode.hero_hit._xmouse-initPosX
    if(math.abs(temp)<=4)
    {
        fscommand("HeroCommand","PlayModelAni")
        //fscommand("PlayModelAni")
    }
}

function SetUIAlpha(alphaValue)
{
    _root._alpha = alphaValue
}

function showUnread(mc,isShow)
{
    var tempName = "unreadMC"
    if(mc[tempName] == undefined)
    {
        var xPos = mc._width
        if(mc.hit != undefined)
        {
            xPos = mc.hit._width
        }
        mc.attachMovie("icon_unread",tempName,mc.getNextHighestDepth(),{_x:xPos-27,_y:0})
    }
    mc[tempName]._visible = isShow
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


function GetNumberMC()
{
    var mc = _root//ui_equip_info_page.equip_info.equip_strengthen

    if(numberAniMCs==undefined)
    {
        numberAniMCs=new Array()
        var tempName="number_ani_"+0
        mc.attachMovie("tube_add_number",tempName,mc.getNextHighestDepth(),{_x:0,_y:0})

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
    mc.attachMovie("tube_add_number",tempName,mc.getNextHighestDepth(),{_x:0,_y:0})
    numberAniMCs.push(mc["number_ani_"+Index])

    return mc["number_ani_"+Index]
}

function FTEOnClickRNA()
{
    fscommand("PlayMenuConfirm")
    fscommand("HeroCommand","HeroStarUpgrade")
}

function FTEClicekEquipmentTab()
{
    var Filter = _root.filter_contral
    var BtnTab = Filter["filter_button_" + 2]
    BtnTab.onRelease()
}

function FTEOnClickEquipUpgrade()
{
    var curComponent = _root.hero_equipment
    curComponent.equipment_info1.btn_upgrade.onRelease()
}

function FTEOnClickEquipEovlve()
{
    var curComponent = _root.hero_equipment
    curComponent.equipment_info1.btn_evolve.onRelease()
}

function FTEOnClickHeroEovlve()
{
    var curComponent = _root.hero_equipment
    curComponent.hero_evolve.btn_evolve.onRelease()
}

function FTEOnClickClose()
{
    //trace("========================FTEOnClickClose========================")
    _root.top_ui.btn_close.onRelease()
}


function FTEClickSkillTab()
{
    var Filter = _root.filter_contral
    var BtnTab = Filter["filter_button_" + 3]
    BtnTab.onRelease()
}

function FTEOnClickSkillUpgrade()
{
    if (AllSkillMc[0] != undefined)
        AllSkillMc[0].btn_upgrade.onRelease()
}

function FTEOnClickAddExp()
{
    var curComponent = _root.hero_details
    curComponent.info_progress_bar.btn_add2.onRelease()
}


function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.addrna._visible = false
	_root.fteanim.addexp._visible = false
	_root.fteanim.skillUpgrade._visible = false
	_root.fteanim.hero_upgrade._visible = false
	_root.fteanim.upgrade._visible = false
	_root.fteanim.skilltab._visible = false
	_root.fteanim.equipment._visible = false
	_root.fteanim.close._visible = false
}

FTEHideAnim()