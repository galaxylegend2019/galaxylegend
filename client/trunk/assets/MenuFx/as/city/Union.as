import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

var ui_all=_root.ui_all
var swicth_buttons=ui_all.swicth_buttons
var messageBox=_root.messageBox

//init the pages of different
var pageCount=5
var btn_switchs:Array=new Array("btn_home","btn_member","btn_activity","btn_list","btn_record")
var page_switchs:Array=new Array("home_page","member_page","activity_page","list_page","record_page")


this.onLoad=function()
{
	initFlash()
	ui_all.list_bg.gotoAndPlay("opening_ani")
}

function initFlash()
{
	for(var j=0;j<pageCount;j++)
	{
		var curPage=ui_all[page_switchs[j]];
		curPage._visible=false;
	}

	initSwitchButtons();

	messageBox._visible=false

	initAnimations();
	
	testMemberData();
	testActivityData();
	testHomeData();
	testUnionListData();
	testRecordData();

	swicth_buttons[btn_switchs[0]].onRelease();
}

//---------------------------------------------------for switch operate ------------------------------
var pageAnis:Array=new Array()
function initAnimations()
{
	var home_page=ui_all.home_page
	var member_page=ui_all.member_page
	var activity_page=ui_all.activity_page
	var list_page=ui_all.list_page
	var record_page=ui_all.record_page

	//init the mc which will be play animations 
	pageAnis[0]=new Array(home_page.levelName,home_page.unionPos,home_page.tipsInfo,home_page.listAllBtn,home_page.npcIcon)
	pageAnis[1]=new Array(/*member_page.bottom_buttons,member_page.memberList,member_page.memberTitle*/)
	pageAnis[2]=new Array()
	pageAnis[3]=new Array(list_page.item_list,list_page.listTitle,list_page.search_board)
	pageAnis[4]=new Array(record_page.recordTitle)
}

//show and hide page
function swicth_pages(mc)
{
	for(var j=0;j<pageCount;j++)
	{
		var curPage=ui_all[page_switchs[j]];
		var tempButton=swicth_buttons[btn_switchs[j]];
		tempButton.gotoAndStop("Idle")
		if(j==mc.btnIndex)
		{
			tempButton.gotoAndStop("released")

			curPage._visible=true;
			for(var k=0;k<pageAnis[j].length;k++)
			{
				//play the animation for cur page
				pageAnis[j][k].gotoAndPlay("opening_ani")
			}
		}
		else
		{
			curPage._visible=false;
		}
	}
}

//regesit event and bind index data for every button
function initSwitchButtons()
{
	for(var i=0;i<pageCount;i++)
	{
		var curButton=swicth_buttons[btn_switchs[i]]
		curButton.btnIndex=i
		curButton.onRelease=function()
		{
			swicth_pages(this)
		}
	}
}


//---------------------------------------------------for MessageBox operate ------------------------------

var DefautStr=undefined
//show the create window for union and set data
function MessageBoxShow(requireLevel,requireMoney)
{
	setMessageBoxShow(true)
	messageBox.gotoAndPlay("opening_ani")
	messageBox.taskDsc.requireLevel.text=requireLevel;
	messageBox.taskDsc.requireMoney.text=requireMoney;

	//to keep the str tips for input field when window show every times
	if(DefautStr==undefined)
	{
		DefautStr=messageBox.text_input.text_input.text;
	}else
	{
		messageBox.text_input.text_input.text=DefautStr;
	}
}

messageBox.btn_ok.onRelease=function()
{	
	setMessageBoxShow(false)
}

messageBox.btn_close.onRelease=function()
{
	setMessageBoxShow(false)
}

//clear the str when the input_field get focus first
messageBox.text_input.text_input.onSetFocus=function()
{
	this.text="";
}

function setMessageBoxShow(flag)
{
	messageBox._visible=flag;
	ui_all._visible=!flag
}



//---------------------------------------------------for home_page ------------------------------
var btns:Array=new Array("member","garrison","rank","record")
var buttonDatas:Array=new Array();

//init some random data for the game block
function testHomeData()
{
	for(var i=0;i<btns.length;i++)
	{
		var obj=new Object();
	
		obj.icons=btns[i];
		obj.btnInfo=btns[i];

		buttonDatas[i]=obj;
	}

	initHomeButtons()
}

function initHomePage()
{

}

function initHomeButtons()
{
	var listAllBtn=ui_all.home_page.listAllBtn

	for(var i=0;i<btns.length;i++)
	{
		var tempButton=listAllBtn["btn_"+btns[i]]
		tempButton.btnIndex=i+1;

		tempButton.icons.gotoAndStop(buttonDatas[i]["icons"])
		tempButton.bar.btnInfo.text=buttonDatas[i]["btnInfo"]

		tempButton.onRelease=function()
		{
			swicth_pages(this);
		}
	}
}




//---------------------------------------------------for member_page ------------------------------

var bottom_buttons=ui_all.member_page.bottom_buttons
bottom_buttons.btn_exitUnion.onRelease=function()
{
	trace("exit union")
}
bottom_buttons.btn_backMail.onRelease=function()
{
	trace("back mail")

}

var memberDatas:Array=new Array()
var memberCount=20
function testMemberData()
{
	for(var i=0;i<memberCount;i++)
	{
		var obj=new Object()
		obj.name="test";
		obj.rating=random(20);
		obj.curPostion=i;
		obj.lastLogin="10h29s";

		memberDatas[i]=obj;
	}

	initMemberPage();
}

function initMemberPage()
{
	var memberList = ui_all.member_page.memberList.memberList.memberList;
	memberList.temp._visible=false
	memberList.clearListBox();
	memberList.initListBox("list_single2",0,true,true);
	memberList.enableDrag( true );
	memberList.onEnterFrame = function(){
		this.OnUpdate();
	}

	memberList.onItemEnter = function(mc,index_item)
	{
		mc._visible=true
		var curMemberData=memberDatas[index_item]
		var memberInfo=mc.memberInfo;

		memberInfo.userName.text="ccc"//curMemberData.name;
		memberInfo.curPostion.text=curMemberData.curPostion;
		memberInfo.lastLogin.text=curMemberData.lastLogin;
	}

	memberList.onItemMCCreate = function(mc)
	{
		mc.gotoAndPlay("opening_ani");
	}

	memberList.onListboxMove = undefined;

	for( var i=1; i <= 12; i++ )
	{   
	    var temp=memberList.addListItem(i, false, false);
	}

}

//---------------------------------------------------for activity_page ------------------------------

var top_buttons=ui_all.activity_page.top_buttons
top_buttons.all_btn.onRelease=function()
{
	this.gotoAndStop("released")
	top_buttons.my_btn.gotoAndStop("Idle")

	ui_all.activity_page.hero_move._visible=false
	ui_all.activity_page.hero_page._visible=true
}
top_buttons.my_btn.onRelease=function()
{
	this.gotoAndStop("released")
	top_buttons.all_btn.gotoAndStop("Idle")

	ui_all.activity_page.hero_move._visible=true
	ui_all.activity_page.hero_page._visible=false

	ui_all.activity_page.attr_page.gotoAndStop(2)
}

function CreateAllHeroTest(){
	var test_hero_id_list = ["Clotho","Apollo","Crius","Prometheus","takezo","Avatar","Hero","Medic"];
	var test_hero_rankvalue_list = [1000100,3010000,2000009,2000008,3999999,2000002,2000010,1000111];
	var rankvalue_localmode_map = [0,3,2,1];
	var default_hero_data = Array();
	for(var i = 0; i < 8 ; i++){
		var hero_item = Object();
		hero_item.id = test_hero_id_list[i];
		hero_item.name = test_hero_id_list[i];
		hero_item.rank_value = test_hero_rankvalue_list[i];
		hero_item.level = i * 10;
		hero_item.star = i < 6 ? 2 : 3;
		hero_item.combat = hero_item.star * 100;
		hero_item.local_mode = rankvalue_localmode_map[Math.floor(hero_item.rank_value / 1000000)];
		hero_item.is_outside = i  <= 15 ? false : true;
		hero_item.is_actived = i < 6 ? true : false;
		default_hero_data[i] = hero_item;
	}
	return default_hero_data;
}

function testActivityData()
{
	top_buttons.all_btn.onRelease()
	hero_show_list=CreateAllHeroTest()
	setActivityData()
	setActivityHeroData()
}

function SetUnionHeroId(heroId)
{
	curNpcOpen.icons.gotoAndStop("hero_"+heroId)
}
var curNpcOpen
function setActivityData()
{
	var hero_MovePage=ui_all.activity_page.hero_move.hero_move

	hero_MovePage.temp._visible=false

	hero_MovePage.clearListBox();
	hero_MovePage.initListBox("hero_move1",0,false,true);
	hero_MovePage.enableDrag( true );
	hero_MovePage.onEnterFrame = function(){
		this.OnUpdate();
	}

	hero_MovePage.onItemEnter = function(mc,index_item)
	{
		mc.npc_open._visible=false

		mc.npc.btn_heroPlus.btnIndex=index_item
		mc.npc.btn_heroPlus.controlTarget=mc
		mc.npc.btn_heroPlus.onRelease=function()
	    {
	    	this.controlTarget.npc_open._visible=true
	    	this.controlTarget.npc._visible=false

	    	this.controlTarget.npc_open.gotoAndPlay("opening_ani")

	    	curNpcOpen=this._parent._parent.npc_open.hero_icon.hero_icon.hero_icon

 			_root._visible=false
			fscommand("GotoNextMenu","GS_HeroPage5")
			trace("add the hero_page5")

	    }
	    mc.npc_open.recalBoard.btn_recall.controlTarget=mc
	    mc.npc_open.recalBoard.btn_recall.onRelease=function()
	    {
	    	this.controlTarget.npc_open._visible=false
	    	this.controlTarget.npc._visible=true

	    	this.controlTarget.npc.gotoAndPlay("opening_ani")
	    }

	    var hero_icon=mc.npc_open.hero_icon.hero_icon.hero_icon
		if (hero_icon.icons== undefined){
			hero_icon.loadMovie("CommonHeros.swf");
		}

		mc._visible=true
	}


	hero_MovePage.onItemMCCreate = function(mc)
	{
		mc.gotoAndPlay("opening_ani");
	}

	hero_MovePage.onListboxMove = undefined;


	for( var i=1; i <= 4; i++ )
	{   
	    var temp=hero_MovePage.addListItem(i, false, false);
	}
}

function setActivityHeroData()
{
	var hero_PageList=ui_all.activity_page.hero_page.DragList

	hero_PageList.clearListBox();
	hero_PageList.initListBox("item_choose_hero_list",0,true,true);
	hero_PageList.enableDrag(true);
	hero_PageList.onEnterFrame = function(){
		this.OnUpdate();
	}

	hero_PageList.onItemEnter = function(mc,index_item)
	{
		for(var i = 0; i < 3 ; i++ )
		{
			var hero_data = hero_show_list[(index_item - 1) * 3 + i];
			var hero_item_mc = mc["item_" + (i + 1)];
			if(hero_data)
			{
				hero_item_mc._visible = true;
				hero_item_mc.hero_data = hero_data;
				hero_item_mc.hero_info.textInfo.hero_name.text = hero_data.name;
				hero_item_mc.hero_info.textInfo.level_num.text = hero_data.level;
				if (hero_item_mc.hero_icon.hero_icon.icons == undefined){
					hero_item_mc.hero_icon.hero_icon.loadMovie("CommonHeros.swf");
				}
				hero_item_mc.hero_icon.hero_icon.icons.gotoAndStop("hero_" + hero_data.id);
				hero_item_mc.hero_icon.gotoAndStop(hero_data.is_actived ? "activited" : "normal");
				//star
				for(var j = 1 ; j <= 5 ; j++){
					hero_item_mc.hero_info["star_" + j].gotoAndStop( hero_data.star >= j ? "normal" : "Idle" );
				}
				hero_item_mc.onRelease = function(){
					this._parent._parent.onReleasedInListbox();
					if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
						heroMC_select(this);
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
				hero_item_mc.gotoAndPlay("opening_ani");
			}
			else
			{
				hero_item_mc._visible = false;
			}
		}
	}


	hero_PageList.onItemMCCreate = function(mc)
	{
		mc.gotoAndPlay("opening_ani");
	}

	hero_PageList.onListboxMove = undefined;


	for( var i=1; i <= (hero_show_list.length+2)/3; i++ )
	{   
	    var temp=hero_PageList.addListItem(i, false, false);
	}
}



//---------------------------------------------------for list_page ------------------------------

var search_board=ui_all.list_page.search_board

//search union when information be changed
search_board.search_board.search_input.onChanged=function()
{
	var searchData=filterUnion(this.text)
	setUnionListData(searchData);
}

search_board.btn_find.onRelease=function()
{
	trace("search button is clicked")
}

search_board.btn_add.onRelease=function()
{
	//limit the president's level and money 
	MessageBoxShow(25,2000)
}

var UnionDatas:Array=new Array()
function testUnionListData()
{
	var unionCount=10;
	var tempNames:Array=new Array("hongxing","hongmen","qingbang","qinghonghui","futoubang");
	for(var i=0;i<unionCount;i++)
	{
		var obj=new Object()

		obj.unionName=tempNames[random(5)];
		obj.unionRank=i+1;
		obj.presidentName=obj.unionName+"--bangzhu";
		obj.curMemberCount=random(99);
		obj.maxMemberCount=99;

		UnionDatas[i]=obj;
	}

	setUnionListData(UnionDatas)
}

function setUnionListData(UnionDatas)
{
	//top_buttons.all_btn.onRelease()
	var UnionList=ui_all.list_page.item_list.item_list.item_list
	UnionList.temp._visible=false

	UnionList.clearListBox();
	UnionList.initListBox("list_single1",0,true,true);
	UnionList.enableDrag( true );
	UnionList.onEnterFrame = function(){
		this.OnUpdate();
	}

	UnionList.onItemEnter = function(mc,index_item)
	{
		mc.itemInfo.unionName.text=UnionDatas[index_item].unionName;
		mc.itemInfo.presidentName.text=UnionDatas[index_item].presidentName;
		mc.itemInfo.curMemberCount.text=UnionDatas[index_item].curMemberCount;
		mc.itemInfo.maxMemberCount.text=UnionDatas[index_item].maxMemberCount;
	}


	UnionList.onItemMCCreate = function(mc)
	{
		//mc.gotoAndPlay("opening_ani");
	}

	UnionList.onListboxMove = undefined;


	for( var i=0; i < UnionDatas.length; i++ )
	{   
	    var temp=UnionList.addListItem(i, false, false);
/*	    hero_MovePage["listBoxItem"+i].npc.btn_heroPlus.onRelease=function()
	    {
	    	trace("=====")
	    }*/
	}
}

function filterUnion(str)
{
	var filterDatas:Array=new Array()
	var filterIndex=0;
	for(var i=0;i<UnionDatas.length;i++)
	{
		var tempStr=UnionDatas[i].unionName;
		var strFlag=tempStr.indexOf(str);
		if(strFlag==0)//the string which is be searched is on the position
		{
			filterDatas[filterIndex]=UnionDatas[i];
			filterIndex++;
		}
	}

	return filterDatas;
}


//---------------------------------------------------for record_page ------------------------------

function testRecordData()
{
	setRecordData()
}


function setRecordData()
{
	trace("run")
	var RecordPage=ui_all.record_page.recordList.recordList

	RecordPage.temp._visible=false

	RecordPage.clearListBox();
	RecordPage.initListBox("list_single3",0,true,true);
	RecordPage.enableDrag(true);
	RecordPage.onEnterFrame = function(){
		this.OnUpdate();
	}

	RecordPage.onItemEnter = function(mc,index_item)
	{
		mc._visible=true
		mc.textInfo.recordText.text="asdhkahdkajshdkjadhskahdashdkajhd"
		mc.textInfo.timeText.text="26"
		mc.textInfo.timeUnit.text="hours"
	}


	RecordPage.onItemMCCreate = function(mc)
	{
		mc.gotoAndPlay("opening_ani");
	}

	RecordPage.onListboxMove = undefined;


	for( var i=1; i <= 4; i++ )
	{   
	    var temp=RecordPage.addListItem(i, false, false);
	}
}







//-----------------------------------------------------for flash show and hide----------------------

ui_all.top_buttons.btn_close.onRelease=function()
{
	trace("union flash close")
//	fscommand("GotoNextMenu","Back")
	fscommand("GotoNextMenu","GS_MainMenu")

	//fscommand("ExitBack")
	_root._visible=false
}

function setUIPlay()
{
	trace("flash show")
	_root._visible=true
}