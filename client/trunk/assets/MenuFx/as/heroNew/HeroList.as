//import com.tap4fun.utils.Utils;
//import common.Lua.LuaSA_MCPlayType;

//var m_hero_list : Array;
var s_list_all : Number = 0;
var s_list_front : Number = 1;
var s_list_middle : Number = 2;
var s_list_back : Number = 3;
var s_list_outside : Number = 4;

//for hero count 
var heroCount=0
var heroMaxCount=0

var m_hero_list;


var ui_hero_list=_root.hero_list
var ui_hero_choose=_root.hero_list.hero_list.hero_name.hero_name_text
var ui_drag_list=_root.hero_list.hero_list.item_view.view_list

var textArray=new Array("WHOLE","FRONT","MIDDLE ROW","BACK ROW","UNION")

var mc_last_button=undefined
var mc_cur_button=undefined
var hero_show_list
var cur_data_index
var isModelShow=false
var isFirstButton=true
var frameCount=0
var curFocusButton

var pathObject=new Object()

var mc_hero_title=_root.hero_list.hero_title
var item_count=3

var headMcs:Array=new Array();
this.onLoad=function()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "HeroListUILoad");
	/*******End*******/
	_root.getui._visible=false
	mc_hero_title._visible=false
/*	var default_hero_data = CreateAllHeroTest();
	InitHeroList(default_hero_data);
*/

	_root.tests.loadMovie("Vignette.swf")
	InitFilterButtons()
	_root._visible=false
	//var testMC=_root.hero_list.btn_detail
	//showUnread(testMC,true)
}

function getPercentNum(num1,num2)
{
	var num=Math.ceil((num1/num2)*100)
	if(num<2)
	{
		num=num+2
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
	for(var i=1;i<=5;i++)
	{
		var curButton=_root.filter_contral["filter_button_"+i]

		curButton.str=textArray[i-1]
		curButton.btnIndex=i;
		curButton.onRelease=function()
		{
			fscommand("PlaySound","sfx_ui_selection_2")
			curFocusButton=this
			for(var j = 1; j <= 5 ; j++)
			{
				this._parent["filter_button_" + j].gotoAndStop("Idle");
			}
			this.gotoAndStop("released");

			ui_hero_list.hero_list.hero_type.hero_type_text.text=this.str

			cur_data_index=this.btnIndex-1
			hero_show_list = m_hero_list[this.btnIndex-1];

			//just filter click for update data
			showAllHero();
		}
		
	}

	//can not know whether is union
	//_root.filter_contral["filter_button_"+5]._visible=false

}

//update the list data for ui play
function UpdateData(input_hero_data:Array)
{
	heroCount=0
	heroMaxCount=0
	m_hero_list = undefined
	m_hero_list = new Array();
	for (var i = s_list_all ; i <= s_list_outside ; i++ )
	{
		m_hero_list[i] = new Array();
	}
	for (var i = 0; i < input_hero_data.length ; i++)
	{
		var m = input_hero_data[i];
		m.heroIndex=i

		m_hero_list[s_list_all].push(m);

		if(m.heroType!=undefined)
		{
			m_hero_list[m.heroType].push(m);
			heroCount++;
		}
	}

	heroMaxCount=input_hero_data.length
	//just update data without reset mc
	if(mc_hero_title._visible==true)
	{
		//ui_drag_list.needUpdateVisibleItem()
		curFocusButton.onRelease()
	}
}


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


function InitHeroList(input_hero_data:Array)
{
	UpdateData(input_hero_data)
	//_root.filter_contral["filter_button_"+1].onRelease()
	ShowHeroCount()
}

function ShowHeroCount()
{
	_root.hero_list.hero_type.hero_count.text=heroCount
	_root.hero_list.hero_type.hero_max_count.text=heroMaxCount
}

function showAllHero(hero_list_sign:Number)
{
	
	mc_hero_title._visible=false

	isFirstButton=true
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("list_hero_icon",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	headMcs=new Array();

	ui_drag_list.onItemEnter = function(mc,index_item){
		hero_show_list=m_hero_list[cur_data_index]
		for(var i = 0; i < item_count ; i++ ){

			var hero_data = hero_show_list[(index_item - 1) * item_count + i ];
			var hero_item_mc = mc["item_" + (i + 1)];
			hero_item_mc.selected_bg._visible=false
			if(isFirstButton==true)
			{
				mc_cur_button=hero_item_mc;
				isFirstButton=false
			}

			hero_item_mc.level_info._visible=true
			hero_item_mc.star_plane._visible=true

			if(hero_data)
			{
				headMcs.push(hero_item_mc)

				hero_item_mc._visible = true;
				hero_item_mc.select._visible=false

				hero_item_mc.heroIndex = hero_data.heroIndex;
				hero_item_mc.hero_data = hero_data;

				if(hero_data.isNeedChip==true)
				{
					showUnread(hero_item_mc,hero_data.isEnoughCall)

					if(hero_data.chipCount>=hero_data.needChipCount)
					{
						hero_item_mc.gotoAndStop("enough")
					}
					else
					{
						hero_item_mc.gotoAndStop("need_chip")
						//var processNum=hero_data.chipCount/hero_data.needChipCount
						var processNum=getPercentNum(hero_data.chipCount,hero_data.needChipCount)
						hero_item_mc.num_processBar.gotoAndStop(processNum)
						hero_item_mc.chip_count_text.htmlText=hero_data.chipCountText
					}

				}else
				{
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
				
				hero_item_mc.hero_icon.loadMovie("CommonHeros.swf")
				hero_item_mc.hero_icon.IconData=hero_data.iconData
				if(hero_item_mc.hero_icon.hero_icon.UpdateIcon) 
				{
					hero_item_mc.hero_icon.hero_icon.UpdateIcon(); 
				}

			}else
			{
				hero_item_mc._visible = false

				if(hero_item_mc.hero_icon.icons==undefined)
				{
					hero_item_mc.hero_icon.loadMovie("CommonHeros.swf")
				}
				hero_item_mc.hero_icon.icons.gotoAndStop(1)
				hero_item_mc.hero_data=undefined
				hero_item_mc.level_info._visible=false
				hero_item_mc.star_plane._visible=false
			}
		}
	}

	ui_drag_list.onItemMCCreate = function(mc){
		mc.gotoAndPlay("opening_ani");
	}

	ui_drag_list.onListboxMove = undefined;

	if(hero_show_list==undefined)
	{
		return
	}

	var listLength=Math.ceil(hero_show_list.length/item_count)
	trace(hero_show_list.length)
	if (listLength<1)
	{
		listLength=1
	}
	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}

	_root.hero_list.gotoAndPlay("opening_ani")
	_root.hero_list.OnMoveStartOver=function()
	{
		heroMC_select(mc_cur_button)
		this.OnMoveStartOver=undefined
	}
}

function showDetail()
{
	_root.hero_list.btn_detail.gotoAndStop("normal")
	_root.hero_list.btn_detail.onRelease=function()
	{
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickHeroDetailBtn");
		/*******End*******/
		fscommand("PlaySound","sfx_ui_selection_1")
		isModelShow=false
		fscommand("GotoNextMenu","GS_HeroMainPage")
		//switch the hero data for choose
		//fscommand("SetCurHeroInfo",mc_cur_button.heroIndex)
		fscommand("HeroCommand","SetCurHeroInfo\2"+mc_cur_button.hero_data.id)
		_root._visible=false
	}
}

function SetUIPath(inputData)
{
	pathObject.isDirect=true
	pathObject.heroModel = inputData.heroModel

/*	_root._visible=false
	fscommand("GotoNextMenu","GS_HeroMainPage")
	//fscommand("SetCurHeroInfo",1)
	trace("call as function SetUIPath")*/

/*	if(inputData.isDirect==true)
	{
		isModelShow=false
		fscommand("GotoNextMenu","GS_HeroMainPage")
		//switch the hero data for choose
		fscommand("SetCurHeroInfo",inputData.heroIndex)
		_root._visible=false
	}*/
}

function showGet()
{
	_root.hero_list.btn_detail.gotoAndStop("need_chip")
	_root.hero_list.btn_detail.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		PopChipOrigin(mc_cur_button.hero_data)
	}
}

function showEnough()
{	
	_root.hero_list.btn_detail.gotoAndStop("enough")
	_root.hero_list.btn_detail.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		var id=mc_cur_button
		//fscommand("HeroCall",mc_cur_button.hero_data.id)
		fscommand("HeroCommand","HeroCall\2"+mc_cur_button.hero_data.id)

	}

}	

function PopChipOrigin(heroData)
{
	fscommand("ShowItemOrigin",heroData.chipID+'\2'+heroData.needChipCount)
	return

	_root.messageBox._visible=true
	if(_root.messageBox.item_origin_page==undefined)
	{
		_root.messageBox.loadMovie("PopupGetWay.swf")
	}

	_root.messageBox.item_origin_page.pop_content.gotoAndPlay("opening_ani")
	var ui_item_origin=_root.messageBox.item_origin_page.pop_content.item_origin

	var chipOrigin=heroData.item.origin
	for(var i=0;i<3;i++)
	{
		var curOrigin=ui_item_origin["origin_"+(i+1)]
		if(i<chipOrigin.length)
		{
			curOrigin._visible=true
			curOrigin.origin_name.origin_text.text=chipOrigin[i].type+chipOrigin[i].name
		}else
		{
			curOrigin._visible=false
		}
	}

	var btn_close=_root.messageBox.item_origin_page.pop_content.btn_close
	var page_cover=_root.messageBox.item_origin_page.page_cover
	page_cover._visible=true
	page_cover.onRelease=function()
	{
		trace("click cover for block user click----")
	}
	btn_close.onRelease=OnClose
}

function OnClose()
{
	fscommand("PlayMenuConfirm")
	_root.messageBox.item_origin_page.pop_content.gotoAndPlay("closing_ani")

	_root.messageBox.item_origin_page.pop_content.OnMoveOutOver=function()
	{
		_root.messageBox._visible=false
		this.OnMoveOutOver=undefined
		page_cover._visible=false
		page_cover.onRelease=undefined
	}
}

function showHeroTitle(heroData)
{
	mc_hero_title._visible=true
	var hero_title=mc_hero_title
	hero_title.hero_name.name_text.text=heroData.heroNameText

	if(heroData.isNeedChip==true)
	{
		if(heroData.chipCount>=heroData.needChipCount)
		{
			hero_title.gotoAndStop("enough")
			
			//var numStr=heroData.needChipCount+"/"+heroData.needChipCount
			//hero_title.chip_count_text.text=numStr
			hero_title.chip_count_text.htmlText=heroData.chipCountText
			hero_title.num_processBar.gotoAndStop(100)

			showEnough()
		}else
		{
			hero_title.gotoAndStop("need_chip")
			var processNum=getPercentNum(heroData.chipCount,heroData.needChipCount)
			hero_title.num_processBar.gotoAndStop(processNum)
			hero_title.chip_count_text.htmlText=heroData.chipCountText

			showGet()
		}
	}else
	{
		hero_title.gotoAndStop("normal")
		hero_title.hero_level.hero_level.text=heroData.level
		for(var j = 1 ; j <= 5 ; j++){
			var starFlag=heroData.star >= j ? "normal" : "Idle"
			hero_title["star_" + j].gotoAndStop(starFlag);
		}

		showDetail()
	}

}

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

function heroMC_select(this_mc:Object){

	if(this_mc.hero_data==undefined)
	{
		isModelShow=false
		_root.hero_list.btn_detail._visible=false

		//ui_hero_choose._visible=false
		var displayType=0
		//fscommand("DisplayModel",0+'\2'+"null"+'\2'+displayType)
		fscommand("HeroCommand","DisplayModel\2"+"null")
		return
	}

	_root.hero_list.btn_detail._visible=true

	var flag=this_mc.hero_data.isNeedChip and this_mc.hero_data.isEnoughCall
	showUnread(_root.hero_list.btn_detail,this_mc.hero_data.isUp or flag)

	if(mc_last_button!=undefined)
	{
		//mc_last_button.hero_icon.icons.gotoAndStop("normal")
		mc_last_button.selected_bg._visible=false
		mc_last_button.hero_icon.icons.bg.gotoAndStop("quality_"+mc_last_button.hero_data.quality)
		mc_last_button.hero_icon.icons.frame.gotoAndStop("quality_"+mc_last_button.hero_data.quality)
	}
	mc_last_button=this_mc
	mc_cur_button=this_mc

	//this_mc.hero_icon.icons.gotoAndStop("selected")
	mc_last_button.selected_bg._visible=true
	this_mc.hero_icon.icons.bg.gotoAndStop("quality_"+this_mc.hero_data.quality)
	this_mc.hero_icon.icons.frame.gotoAndStop("quality_"+this_mc.hero_data.quality)

	var heroData=this_mc.hero_data

	showHeroTitle(heroData)

	/*
	if(_root._visible==true)
	{
		var displayType=0
		if(heroData.isNeedChip==true)
		{
			displayType=1
		}
		//fscommand("DisplayModel",0+'\2'+heroData.heroModel+'\2'+displayType)
		fscommand("HeroCommand","DisplayModel\2"+heroData.heroModel)
	}
	*/
	fscommand("HeroCommand","DisplayModel\2"+heroData.heroModel)

	isModelShow=true
}


//for ui close call
_root.titles.btn_close.onRelease=function()
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
	isModelShow=false
	_root._visible=true

	updataData()
	_root.filter_contral["filter_button_"+1].onRelease()

	if(pathObject.isDirect==true)
	{
		_root._visible=false
		fscommand("GotoNextMenu","GS_HeroMainPage")
		pathObject.isDirect=false
		heroMC_select(mc_cur_button)
		fscommand("HeroCommand","DisplayModel\2"+pathObject.heroModel)
	}
	fscommand("HeroCommand","HeroListModel")
}

function ShowUI(flag)
{
/*	var mcs=new Array("title","hero_list","filter_contral")
	for(var i=0;i<mcs.length;i++)
	{
		if(flag==true)
		{
			_root[mcs[i]].gotoAndPlay("opening_ani")
		}else
		{
			_root[mcs[i]].gotoAndPlay("closing_ani")
		}
	}*/
}

function updateFrame()
{
	var tempX=_root.hero_hit._xmouse-tempPosX

	var rotateAngle=-tempX/5
	if(math.abs(rotateAngle)>=0.2)
	{
		//fscommand("RotateModel",-tempX/5)
		fscommand("HeroCommand","RotateModel\2"+(-tempX/5))
	}

	tempPosX=_root.hero_hit._xmouse
}

//the screen move for move model 
_root.hero_hit.onPress=function()
{
	if(isModelShow==false)
	{
		return
	}
	_root.onEnterFrame=updateFrame
	initPosX=_root.hero_hit._xmouse
	tempPosX=_root.hero_hit._xmouse
}

//the touch for play model aniamtion
_root.hero_hit.onRelease=_root.hero_hit.onReleaseOutside=function()
{
	if(isModelShow==false)
	{
		return
	}
	_root.onEnterFrame=null
	var temp=_root.hero_hit._xmouse-initPosX
	if(math.abs(temp)<=4)
	{
		//fscommand("PlayModelAni")
		fscommand("HeroCommand","PlayModelAni")
	}
}

function SetUIAlpha(alphaValue)
{
	_root._alpha=alphaValue
}