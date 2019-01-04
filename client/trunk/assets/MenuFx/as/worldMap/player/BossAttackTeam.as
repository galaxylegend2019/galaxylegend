var info=_root.info
var UIData
var isPopInfo=false
var ui_drag_list=info.info.item_list
//var RankDatas
_root.onLoad=function()
{
	//trace("this is onLoad-------")
	//trace(ui_drag_list)
	//for test as fun
	var obj=testF()
	//SetUIData(obj)
}

function testF()
{
	var obj=new Object()
	obj.coordinate="xxx=xxx"
	obj.name="xxxx"
	obj.battleNumber="999999"
	obj.baseNumber="99"
	obj.isFavorite=true
	obj.attackCost="99"

	return obj
}

function SetUIData(obj)
{
	UIData=obj

	SetContent()
	
	SetButton()

	SetRanking()
	//SetIcon()
}

function SetContent()
{
	info.desc_title.pop_title.coord_text.text       =UIData.coordinate
	info.desc_title.pop_title.name.text             	=UIData.name
	info.info.battle_number.text     				=UIData.battleNumber
	
	if(UIData.mType!=undefined)
	{
		info.desc_title.pop_title.m_type.text 	=UIData.mType
		info.desc_title.pop_title.m_status.text 	=UIData.mStatus	
	}

	if(_root.info.info.rank_info.headIcon.icons==undefined)
	{
		_root.info.info.rank_info.headIcon.loadMovie("CommonPlayerIcons.swf")
	}
	_root.info.info.rank_info.headIcon.IconData=UIData.IconData
	if(_root.info.info.rank_info.headIcon.UpdateIcon)
	{
		_root.info.info.rank_info.headIcon.UpdateIcon()
	}
}

function SetButton()
{
	var btns=info.tab_bottom
	btns.btn_attack.onRelease=function()
	{
		fscommand("MapCommand","Attack")
	}
	btns.btn_attack.cost.cost_num.text=UIData.attackCost

	info.info.btn_detail.onRelease=function()
	{
		fscommand("MapCommand","ArmyDetail\2"+UIData.UIID)
	}
	info.info.btn_team.onRelease=function()
	{
		fscommand("MapCommand","TeamDetail\2"+UIData.UIID)
	}

	btns.btn_info.onRelease=function()
	{
		if(isPopInfo==false)
		{
			info.gotoAndPlay("opening_menu")
			isPopInfo=true
		}else
		{
			info.gotoAndPlay("closing_menu")
			isPopInfo=false
		}
	}

	var flag="open"
	if(UIData.isFavorite==false)
	{
		flag="close"
	}

	info.UIID=UIData.UIID
	var btn_star=info.star.btn_favorite
	btn_star.UIID=UIData.UIID
	btn_star.gotoAndStop(flag)
	btn_star.onRelease=function()
	{
		fscommand("MapCommand","Favorites\2"+this.UIID)
	}

	_root.bg.onRelease=function()
	{
		SetUIPlay(false)	
	}
	info.bg.onRelease=function()
	{
		
	}
}

function SetIcon()
{
	for(var i=0;i<5;i++)
	{
		var item=info.info["item_"+(i+1)]
		var itemIconData=UIData.ItemDatas[i]
		if(item.icons==undefined)
		{
			item.loadMovie("CommonIcons.swf")
		}
		item.IconData=itemIconData
		if(item.UpdateIcon)
		{
			item.UpdateIcon()
		}
	}
}

function GetFrame(num)
{
	var va=(7/100)*num+1
	return va
}

function SetInfo(datas)
{
	var mc_info=info.info
	mc_info.boss_desc.text=datas.bossDesc
	mc_info.countTime.text=datas.countTime	
	mc_info.processBarShield.gotoAndStop(GetFrame(datas.shield))
	mc_info.process_shield.text=datas.shield+"%"
	mc_info.processBarBlood.gotoAndStop(GetFrame(datas.process))
	mc_info.process_blood.text=datas.process+"%"

}

//for user rank info
function SetRanking()
{
	var mc_info=info.info
	mc_info.rank_info.rank_num.text=UIData.RankDatas.rankNum
	mc_info.rank_info.attack_num.text=UIData.RankDatas.attackNum
	mc_info.rank_info.attack_value.text=UIData.RankDatas.attackValue

	SetRankList()
}

function SetRankList()
{
	//var ui_drag_list
	//trace(ui_drag_list)
	ui_drag_list.clearListBox();
	ui_drag_list.initListBox("item_rank_list",0,true,true);
	ui_drag_list.enableDrag( true );
	ui_drag_list.onEnterFrame = function(){
		this.OnUpdate();
	}

	ui_drag_list.onItemEnter = function(mc,index_item){

		var attr_data = UIData.RankDatas.PlayerList[index_item-1];
		var item_mc = mc;

		if(attr_data)
		{
			item_mc._visible = true;
			item_mc.rank_value.htmlText = attr_data.rankValue
			item_mc.player_name.htmlText = attr_data.playerName
			item_mc.attack_num.htmlText = attr_data.attackNum
			item_mc.attack_value.htmlText = attr_data.attackValue
		}else
		{
			item_mc._visible=false
		}
		
	}

	ui_drag_list.onListboxMove = undefined;
	if(UIData.RankDatas.PlayerList==undefined)
	{
		return
	}
	var listLength=UIData.RankDatas.PlayerList.length
	for( var i=1; i <= listLength; i++ )
	{   
	    ui_drag_list.addListItem(i, false, false);
	}
}

function UpdateData(obj)
{
	info.info.countTime=obj.countTime
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		info.gotoAndPlay("opening_ani")
		fscommand("MapCommand","UIOpen\2"+this.UIID)
	}else
	{
		isPopInfo=false
		info.gotoAndPlay("closing_ani")
		info.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+this.UIID)
		}
	}
}