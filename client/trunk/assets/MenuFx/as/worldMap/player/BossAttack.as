var info=_root.info
var UIData
var isPopInfo=false
_root.onLoad=function()
{
	trace("this is onLoad-------")
	//for test as fun
	var obj=testF()
	SetUIData(obj)
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

	//SetIcon()
}

function SetContent()
{
	info.desc_title.pop_title.coord_text.text       	=UIData.coordinate
	info.desc_title.pop_title.name.text             		=UIData.name
	info.info.battle_number.text     					=UIData.battleNumber

	if(UIData.mType!=undefined)
	{
		info.desc_title.pop_title.m_type.text 		=UIData.mType
		info.desc_title.pop_title.m_status.text 		=UIData.mStatus	
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

function SetInfo(datas)
{
	var mc_info=info.info
	mc_info.boss_desc.text=datas.bossDesc
	mc_info.countTime.text=datas.countTime	
	mc_info.processBar.gotoAndStop(datas.process)
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