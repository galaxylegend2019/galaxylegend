var ui_all
var heroDatas
var StarUpInfo
var cur_page

var anis=new Array("left_attr","right_attr","RegionBottom")

function InitMC(mc)
{
	ui_all=mc
}

function SetHeroInfo()
{
	var hero_title=ui_all.hero_name
	hero_title.hero_level.hero_level.text=heroDatas.level
	hero_title.hero_name.hero_name.text=heroDatas.heroNameText

	for(var j = 1 ; j <= 5 ; j++){
		var starFlag=heroDatas.star >= j ? "normal" : "Idle"
		hero_title["star_" + j].gotoAndStop(starFlag);
	}
}

function InitData(inputHeroData:Array)
{
	ui_all.upgrade_bg._visible=false
	cur_page=ui_all.star_page
	heroDatas=inputHeroData
	SetHeroInfo()

	var mc_attrs=ui_all.star_page.com_desc.attrs
	for(var i=1;i<=3;i++)
	{
		var attr=mc_attrs["attr"+i]
		attr.num1.attr_text.text=heroDatas.curStarRanks[i-1]
		attr.num2.attr_text.text=heroDatas.nextStarRanks[i-1]
	}

	//ui_all.RegionBottom.chip_info.chip_count.text=heroDatas.curStarExp+"/"+heroDatas.nextStarExp
	var mc_chip_info=ui_all.star_page.com_desc.RegionBottom.chip_info
	mc_chip_info.chip_count.htmlText=heroDatas.chipStarCountText

	var mc_process=mc_chip_info.Power_cric
	var process=(heroDatas.curStarExp/heroDatas.nextStarExp)*100+1
	if(process>100)
	{
		process=100
	}
	mc_process.gotoAndStop(process)
	
	var btn_circle=ui_all.star_page.com_desc.RegionBottom.btn_circle

	if(heroDatas.curStarExp>=heroDatas.nextStarExp)
	{
		btn_circle.btn_state.btn_add._visible=false
		btn_circle.btn_state.btn_up._visible=true
		btn_circle.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			//fscommand("HeroStarUpgrade")
			fscommand("HeroCommand","HeroStarUpgrade")
		}
	}else
	{
		//btn_circle.btn_state.gotoAndStop("need_chip")
		btn_circle.btn_state.btn_add._visible=true
		btn_circle.btn_state.btn_up._visible=false
		btn_circle.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			showChipGet(heroDatas)
		}
	}

	ShowDetail()
}

function ShowDetail()
{
	ui_all.star_page.btn_info.onRelease=function()
	{
		fscommand("PlayMenuConfirm")
		fscommand("HeroCommand","ShowStarUp")
	}
}

function showChipGet(heroData)
{
	var id=heroData.starID
	var needNum=heroData.nextStarExp

	fscommand("ShowItemOrigin",id+'\2'+needNum)
}

function ShowStarUp(datas)
{
	StarUpInfo=datas
	ui_all.popup_info._visible=true
	ui_all.gotoAndPlay("opening_attr")
	ui_all.popup_info.gotoAndPlay("opening_ani")

	cur_page=ui_all.popup_info

	
	//var mc_info=_root.popup_info
	var mc_info=ui_all.popup_info
	var mc_drag_list=mc_info.item_list.drag_list

	SetAttrList(mc_drag_list)

	mc_info.btn_close.onRelease=function()
	{
		fscommand("PlayMenuBack")
		SetUIPlay(true)
	}
	
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
		mc.attr_text.htmlText=datas.attrName+"   "+datas.nextNum
		
		//mc.attr_name.text=datas.attrName
		//mc.attr_num.text=datas.attrNum
		//mc.next_attr_num.htmlText=datas.nextNum
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


function SetUIPlay(flag)
{
	var aniFlag="closing_ani"
	if(flag==true)
	{
		aniFlag="opening_info"
		cur_page=ui_all.star_page
		ui_all.star_page._visible=true
		ui_all.gotoAndPlay("opening_info")
		ui_all.popup_info._visible=false
		ui_all.star_page.gotoAndPlay("opening_ani")
	}else
	{
		cur_page.gotoAndPlay("closing_ani")
		cur_page.OnMoveOutOver=function()
		{
			ui_all.OnMoveOutOver()
		}
	}
}