#include "../../as/common/util.as"


var s_list_all : Number = 0;
var s_list_front : Number = 1;
var s_list_middle : Number = 2;
var s_list_back : Number = 3;
var s_list_outside : Number = 4;

//for hero count 
var heroCount = 0
var heroMaxCount = 0

var m_hero_list;

var ui_hero_list = _root.hero_list
var ui_hero_choose = _root.hero_list.hero_list.hero_name.hero_name_text
var ui_drag_list = _root.hero_list.hero_list.item_view.view_list

var textArray = new Array("WHOLE","FRONT","MIDDLE ROW","BACK ROW","UNION")

var mc_last_button = undefined
var mc_cur_button = undefined
var hero_show_list
var cur_data_index
var isModelShow = false
var isFirstButton = true
var frameCount = 0
var curFocusButton

var pathObject = new Object()

var mc_hero_title = _root.hero_list.hero_title
var item_count = 4

var headMcs:Array=new Array();
this.onLoad = function()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "HeroListUILoad");
	/*******End*******/

	InitFilterButtons()
	SetAllLayerVisibleState(false)
}

function SetAllLayerVisibleState(flag)
{
	_root._visible = flag;
	_root.top_ui._visible = flag;
	_root.filter_contral._visible = flag;
	_root.filter_contral_team._visible = flag;
	_root.hero_list._visible = flag
}

function getPercentNum(num1,num2)
{
	var num = Math.ceil((num1/num2)*100)
	if(num < 2)
	{
		num = num + 2
	}
	return num
}

function showUnread(mc,isShow)
{
	var tempName="unreadMC"
	if(mc[tempName]==undefined)
	{
		mc.attachMovie("icon_unread",tempName,mc.getNextHighestDepth(),{_x:mc._width-27,_y:0})
	}
	mc[tempName]._visible=isShow
}

function InitFilterButtons()
{
	for(var i = 1;i <= 4;i++)
	{
		var curButton = _root.filter_contral["filter_button_"+i]

		curButton.str = textArray[i-1]
		curButton.btnIndex = i;
		curButton.onRelease = function()
		{
			fscommand("PlaySound","sfx_ui_selection_2")
			curFocusButton = this
			for(var j = 1; j <= 4 ; j++)
			{
				this._parent["filter_button_" + j].gotoAndStop("Normal");
				//this.enabled = true;
			}
			this.gotoAndStop("Selected");
			//this.enabled = false;

			cur_data_index = this.btnIndex - 1
			hero_show_list = m_hero_list[this.btnIndex-1];

			//just filter click for update data
			showAllHero();
			_root.hero_list.gotoAndPlay("opening_ani")
		}
	}

	for(var j = 1; j <= 3; j++)
	{
		var curButton = _root.filter_contral_team["filter_button_" + j];
		curButton.red_point._visible = false;
		curButton.btnIndex = j;
		curButton.onRelease = function()
		{
			if (this.btnIndex != 1)
			{
				fscommand("HeroCommand","TIP_CloseOption");
				return 
			}
			fscommand("PlaySound","sfx_ui_selection_2")
			for(var i = 1; i <= 3; i ++)
			{
				this._parent["filter_button_" + i].gotoAndStop("Normal");
				this.enabled = true
			}
			this.gotoAndStop("Selected");
			this.enabled = false

			//--TODO
			SetShowHeroLsit(this.btnIndex);
		}
	}
}

function InitHeroList(input_hero_data:Array)
{
	m_hero_list = undefined
	m_hero_list = new Array();
	for (var i = s_list_all ; i <= s_list_outside ; i++ )
	{
		m_hero_list[i] = new Array();
	}
	for (var i = 0; i < input_hero_data.length ; i++)
	{
		var m = input_hero_data[i];
		m.heroIndex = i

		m_hero_list[s_list_all].push(m);

		if(m.heroType!=undefined)
		{
			m_hero_list[m.heroType].push(m);
			heroCount++;
		}
	}
}

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

//for ui close call
_root.top_ui.btn_close.onRelease=function()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroListCloseBtn");
	/*******End*******/
	fscommand("PlayMenuBack")
	_root._visible=false
	fscommand("GotoNextMenu","GS_MainMenu")
}

function SetUIPlay()
{
	SetAllLayerVisibleState(true)
	_root.filter_contral_team.gotoAndPlay("opening_ani")
	_root.filter_contral_team["filter_button_" + 1].onRelease();
	_root.filter_contral_team["filter_button_" + 1].onRelease();

	_root.filter_contral.gotoAndPlay("opening_ani")
	_root.filter_contral["filter_button_" + 1].onRelease();
	_root.filter_contral["filter_button_" + 1].onRelease();

	_root.top_ui.gotoAndPlay("opening_ani");
}

function UpdateCurFocusData()
{
	if(curFocusButton != undefined && cur_data_index != undefined)
	{
		showAllHero();
	}
}

ui_drag_list.onEnterFrame = function()
{
    this.OnUpdate();
}

headMcs = new Array();
ui_drag_list.onItemEnter = function(mc,index_item)
{
    hero_show_list = m_hero_list[cur_data_index]
    for(var i = 0; i < item_count ; i++ )
    {
        var hero_item_mc = mc["item_" + (i + 1)];
        hero_item_mc.selected_bg._visible = false
        hero_item_mc.equip_info._visible = false
        hero_item_mc.star_plane._visible = false
        hero_item_mc.seq = i

        var hero_data = hero_show_list[(index_item - 1) * item_count + i ];
        if(hero_data)
        {

            headMcs.push(hero_item_mc)
            hero_item_mc._visible = true;

            hero_item_mc.heroIndex = hero_data.heroIndex;
            hero_item_mc.hero_data = hero_data;
            hero_item_mc.equip_info.equip_level.text = hero_data.levelTxt;
            hero_item_mc.name_txt.text = hero_data.heroNameText;
            hero_item_mc.type.gotoAndStop(hero_data.heroAttrType)

            if(hero_data.isNeedChip == true)
            {

                showUnread(hero_item_mc,hero_data.isEnoughCall)
                if(hero_data.chipCount >= hero_data.needChipCount)
                {
                    hero_item_mc.gotoAndStop("enough")
                }
                else
                {
                    hero_item_mc.gotoAndStop("need_chip")
                    var processNum = getPercentNum(hero_data.chipCount,hero_data.needChipCount)
                    hero_item_mc.num_processBar.gotoAndStop(processNum)
                    hero_item_mc.chip_count_text.htmlText = hero_data.chipCountText
                }
            }else
            {
                hero_item_mc.star_plane._visible = true
                hero_item_mc.equip_info._visible = true
                hero_item_mc.gotoAndStop("normal")
                showUnread(hero_item_mc,hero_data.isUp)

                hero_item_mc.star_plane.star.gotoAndStop(hero_data.star)
            }
            hero_item_mc.onRelease = function(){
                this._parent._parent.onReleasedInListbox();
                if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
                    heroMC_select(this);
                    fscommand("PlaySound","sfx_ui_selection_3")
                }
            }
            hero_item_mc.onReleaseOutside = function(){
                this._parent._parent.onReleasedInListbox();
            }
            hero_item_mc.onPress = function(){
                this._parent._parent.onPressedInListbox();
                this.Press_x = _root._xmouse;
                this.Press_y = _root._ymouse;
            }

            if(hero_item_mc.hero_icon.icons == undefined)
            {
                hero_item_mc.hero_icon.loadMovie("CommonHeros.swf")
            }
            hero_item_mc.hero_icon.IconData = hero_data.iconData
            if(hero_item_mc.hero_icon.UpdateIcon)
            {
                hero_item_mc.hero_icon.UpdateIcon();
            }

        }else
        {
            hero_item_mc._visible = false
        }
        hero_item_mc.name_txt._x = (hero_item_mc.bg._width - hero_item_mc.name_txt.textWidth) / 2
    }
}

ui_drag_list.onItemMCCreate = function(mc)
{
    mc.gotoAndPlay("opening_ani");
}

function showAllHero()
{
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("list_hero_icon",0,true,true);
	ui_drag_list.enableDrag( true );

	var listLength = Math.ceil(hero_show_list.length / item_count)
	trace(hero_show_list.length)
	if (listLength < 1)
	{
		listLength = 1
	}
	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}


	ui_drag_list.onListboxMove = undefined;

	if(hero_show_list == undefined)
	{
		return
	}

	_root.hero_list.OnMoveStartOver = function()
	{
		heroMC_select(mc_cur_button)
		this.OnMoveStartOver = undefined
	}
}

function SetUIPath(inputData)
{
	pathObject.isDirect = true
	pathObject.heroModel = inputData.heroModel
}	

function PopChipOrigin(heroData)
{
	fscommand("ShowItemOrigin",heroData.chipID +'\2'+ heroData.needChipCount+"\2"+heroData.id)
	return
}

function heroMC_select(this_mc:Object){
	var flag = this_mc.hero_data.isNeedChip and this_mc.hero_data.isEnoughCall
	showUnread(_root.hero_list.btn_detail,this_mc.hero_data.isUp or flag)

	if(mc_last_button != undefined)
	{
		//mc_last_button.hero_icon.icons.gotoAndStop("normal")
		mc_last_button.hero_icon.icons.bg.gotoAndStop("quality_"+mc_last_button.hero_data.quality)
		mc_last_button.hero_icon.icons.frame.gotoAndStop("quality_"+mc_last_button.hero_data.quality)
	}
	mc_last_button = this_mc
	mc_cur_button = this_mc

	//this_mc.hero_icon.icons.gotoAndStop("selected")
	this_mc.hero_icon.icons.bg.gotoAndStop("quality_"+this_mc.hero_data.quality)
	this_mc.hero_icon.icons.frame.gotoAndStop("quality_"+this_mc.hero_data.quality)

	var heroData = this_mc.hero_data
	if(heroData.isNeedChip == true)
	{
		if(heroData.chipCount >= heroData.needChipCount)
		{
			fscommand("PlayMenuConfirm")
			var id = mc_cur_button
			fscommand("HeroCommand","HeroCall\2" + mc_cur_button.hero_data.id)
			fscommand("HeroCommand","DisplayModel\2" + heroData.heroModel)
		}else
		{
			fscommand("PlayMenuConfirm")
			PopChipOrigin(mc_cur_button.hero_data)
		}
	}else
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroDetailBtn");
		/*******End*******/
		fscommand("PlaySound","sfx_ui_selection_1")
		fscommand("GotoNextMenu","GS_HeroMainPage")
		//switch the hero data for choose
		//fscommand("SetCurHeroInfo",mc_cur_button.heroIndex)
		fscommand("HeroCommand","SetCurHeroInfo\2" + mc_cur_button.hero_data.id)
		fscommand("HeroCommand","DisplayModel\2" + heroData.heroModel)
		_root._visible = false
	}
}

function SetUIAlpha(alphaValue)
{
	_root._alpha = alphaValue
}

//FTE
//get mc by heroid
function GetMCByHeroID(heroID)
{
	for(var i=0;i<headMcs.length;i++)
	{
		if(headMcs[i].hero_data.id==heroID)
		{
			return headMcs[i]
		}
	}
}

function SetMCSelectByHeroID(heroID)
{
	trace("--------------heroID=" + heroID);
	mc_cur_button=GetMCByHeroID(heroID)
	isFirstButton=false
	heroMC_select(mc_cur_button)
}

function FTEOnclickClose()
{
	_root.top_ui.btn_close.onRelease()
}


function FTEGetHeroPos(heroid)
{
	_root.toluastr = ""
	//
	var mc_x = GetMCByHeroID(heroid)
	var idx =  Math.floor(mc_x.seq / 4)
	var mc = undefined
	
	if (mc_x._name == "item_1")
	{
		mc = _root.fte.dna
	}
	else if (mc_x._name == "item_2")
	{
		mc = _root.fte.hero
	}
	else if (mc_x._name == "item_3")
	{
		mc = _root.fte.third
	}
	else if (mc_x._name == "item_4")
	{
		mc = _root.fte.forth
	}
	else
	{
		trace("xxpp FTEGetHeroPos error " + mc_x._name)
	}
	if (idx == 0 )
	{
	}
	else
	{
		trace("xxpp FTEGetHeroPos error " + idx)
	}

	{
		_root.toluastr = ""+mc._x+"\2"+mc._y+"\2"+mc._width+"\2"+mc._height
	}
}


function FTEOnHeroItemClicked(idx)
{
	var mc = ui_drag_list.getMcByItemKey(1)
	var mc_x = mc["item_" + idx]
	if(mc_x)
	{
		heroMC_select(mc_x)
		fscommand("PlaySound","sfx_ui_selection_3")
	}
}

function FTEClick(heroid)
{
	var mc_x = GetMCByHeroID(heroid)
	if(mc_x)
	{
		heroMC_select(mc_x)
		fscommand("PlaySound","sfx_ui_selection_3")
	}
}

function FTEOnHeroItemClicked_One()
{
	FTEOnHeroItemClicked(1)
}

function FTEOnHeroItemClicked_Two()
{
	FTEOnHeroItemClicked(2)
}




function FTEPlayAnim(sname)
{
	var mc_x = GetMCByHeroID(sname)
	
	if (mc_x._name == "item_1")
	{
		_root.fteanim.hero1._visible = true
	}
	else if (mc_x._name == "item_2")
	{
		_root.fteanim.hero2._visible = true
	}
	else if (mc_x._name == "item_3")
	{
		_root.fteanim.hero3._visible = true
	}
	else
	{
		_root.fteanim[sname]._visible = true
	}
}

function FTEHideAnim()
{
	_root.fteanim.hero1._visible = false
	_root.fteanim.hero2._visible = false
	_root.fteanim.hero3._visible = false
	_root.fteanim.close._visible = false
}

FTEHideAnim(sname)