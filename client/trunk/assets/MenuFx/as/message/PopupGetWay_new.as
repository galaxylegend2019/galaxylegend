
var ui_all=_root.item_origin_page
var origin_content=ui_all.pop_content

this.onLoad=function()
{
/*	var item_icon=origin_content.item_origin.item_info.reward_icon.item_icon
	item_icon.loadMovie("CommonIcons.swf")*/
	
	_root._visible=false

	// load here, avoid bug
	ui_all.pop_content.hero_main.skill_info.skill_icon.skill_icon.loadMovie("CommonSkills.swf")
}

function SetUIPlay()
{
	_root._visible=true
	origin_content.gotoAndPlay("opening_ani")
}



var AllGotoMC = undefined
function ShowList(listData)
{
	var listView = _root.item_origin_page.pop_content.get_list.list.ViewList

	listView.datas = listData;
	listView.clearListBox();
	listView.initListBox("get_pop_list",0,true,true);
	listView.enableDrag(listData.length>=5);
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	AllGotoMC =new Array()
	listView.onItemEnter = function(mc, index_item){
		AllGotoMC.push(mc)

		mc._visible=true
		var _data = mc._parent.datas[index_item]

		if(_data.openState==true)
		{
			mc.gotoAndStop(1)

			mc.btn_go.originData = _data
			mc.btn_go.onRelease = function()
			{
				fscommand("PlayMenuConfirm")
				var id=this.originData.originID
				var originType=this.originData.originType
				//if(this.originData.openState==true)
				{
					ui_all.page_cover.onRelease()
					fscommand("LoadAnimationCmd","Goto"+'\2'+originType+'\2'+id)
				}
				//else
				//{
				//	fscommand("LoadAnimationCmd","Lock"+'\2'+originType)
				//}
			}
		}
		else
		{
			mc.gotoAndStop(2)
		}
		//
		mc.name_txt.txt.text=_data.originName
		mc.icon.gotoAndStop(_data.isShop ? 1 : 2)
	}

	for(var i = 0; i < listData.length; ++i)
	{
		listView.addListItem(i, false, false);
	}

}


function SetItemData(inputData, txttitle)
{
	SetUIPlay()

	ui_all.pop_content.hero_main._visible = false
	ui_all.pop_content.item_main._visible = true

	ui_all.pop_content.title.txt.text = txttitle

	var mcitem_main = ui_all.pop_content.item_main

	//
	if(mcitem_main.item.icons==undefined)
	{
		mcitem_main.item.loadMovie("CommonIcons.swf")
	}
	mcitem_main.item.IconData=inputData.iconData
	if(mcitem_main.item.UpdateIcon) 
	{
		mcitem_main.item.UpdateIcon()
	}

	mcitem_main.name_text.text=inputData.itemName
	//item_info.count_text.text=inputData.count
	mcitem_main.item_bar.txt_progress.htmlText=inputData.numText
	mcitem_main.item_bar.gotoAndStop(inputData.progress)

	mcitem_main.info_txt.text = inputData.desc

	ShowList(inputData.originDatas)

	ui_all.page_cover.onRelease=hideWindonw
}

function SetHeroData(inputData, txttitle)
{
	
	SetUIPlay()
	ui_all.pop_content.hero_main._visible = true
	ui_all.pop_content.item_main._visible = false

	ui_all.pop_content.title.txt.text = txttitle

	var mchero_main = ui_all.pop_content.hero_main

	//
	if(mcitem_main.hero.hero_icon==undefined)
	{
		mchero_main.hero.hero_icon.loadMovie("CommonHeros.swf")
	}
	mchero_main.hero.hero_icon.IconData=inputData.iconData
	if(mchero_main.hero.hero_icon.UpdateIcon) 
	{
		mchero_main.hero.hero_icon.UpdateIcon()
	}
	mchero_main.hero.hero_star.gotoAndStop(inputData.herostar)
	mchero_main.heroname.text = inputData.heroname
	/*
	        datas.herostar = heroinfo.star
        local hero_base_info = HeroDataManager:GetHeroBaseInfo(heroinfo)
        datas.iconData = hero_base_info.iconData
        datas.heroAttrType = hero_base_info.heroAttrType
        local key = "LC_UI_Hero_Describe_Name" .. tostring(datas.heroAttrType)
        datas.attrname = GameLoader:GetGameText(key)
        datas.Describe_Desc = hero_base_info.hero_base_info
        datas.heroname = heroinfo.name
        local baseskill = heroinfo.skills[1]
        datas.skillname = baseskill.skillName
        datas.skilldesc = baseskill.smallDesc
        */

	mchero_main.locate_info.attrtxt.text=inputData.attrname
	mchero_main.locate_info.herodesc.text = inputData.Describe_Desc
	mchero_main.locate_info.gotoAndStop(inputData.heroAttrType)

	mchero_main.skill_info.skillname.text = inputData.skillName
	mchero_main.skill_info.skilldesc.text = inputData.skilldesc
	var mcskill = mchero_main.skill_info.skill_icon.skill_icon
	if(mcskill.icons==undefined)
	{
		mcskill.loadMovie("CommonSkills.swf")
	}
	

	mcskill.icons.icons.gotoAndStop("skill_"+inputData.skillid)
	
	//
	mchero_main.dna_bar.txt_progress.htmlText=inputData.numText
	mchero_main.dna_bar.gotoAndStop(inputData.progress)
	//

	ShowList(inputData.originDatas)

	ui_all.page_cover.onRelease=hideWindonw

	
}


//------------------------for page close 
origin_content.btn_close.onRelease=function()
{
	fscommand("PlayMenuBack")
	ui_all.page_cover.onRelease()
}


function hideWindonw()
{
	ui_all.page_cover.onRelease=undefined
	origin_content.gotoAndPlay("closing_ani")
	origin_content.OnMoveOutOver=function()
	{
		_root._visible=false
		this.OnMoveOutOver=undefined
	}
	fscommand("LoadAnimationCmd", "CloseItemGetWay");
}

