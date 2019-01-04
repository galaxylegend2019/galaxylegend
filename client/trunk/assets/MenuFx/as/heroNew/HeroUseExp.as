var info_board=_root.item.hero_item
info_board.btn_evolution_lock.yellowpoint._visible = false
info_board.btn_evolution.yellowpoint._visible = false

var UIData
var targetLevel=0
this.onLoad=function()
{
	_root._visible=false
}

function SetUIData(datas)
{
	UIData=datas

	targetLevel=UIData.level
	info_board.num_text.text=targetLevel

	if(info_board.hero_icon.icons==undefined)
	{
		info_board.hero_icon.loadMovie("CommonHeros.swf")
	}
	info_board.hero_icon.IconData=UIData.iconData
	if(info_board.hero_icon.UpdateIcon) 
	{
		info_board.hero_icon.UpdateIcon(); 
	}
	for(var i=0;i<3;i++)
	{
		var item=info_board["item_"+(i+1)]
		var itemData=UIData.items[i]
		if(itemData)
		{
			item._visible=true
			item.item_text.count_text.text=itemData.count
			if(item.item_icon.icons==undefined)
			{
				item.item_icon.loadMovie("CommonIcons.swf")
			}
			item.item_icon.IconData=itemData.iconData
			if(item.item_icon.UpdateIcon) 
			{
				item.item_icon.UpdateIcon(); 
			}
		}else
		{
			item._visible=false
		}
	}

	
	info_board.btn_evolution_lock._visible=!UIData.isVisible	

	info_board.btn_evolution.yellowpoint._visible = UIData.showYellowPoint
	if(UIData.items[0]!=undefined)
	{
		info_board.btn_evolution._visible=true
		info_board.btn_evolution.onRelease=function()
		{
			fscommand("HeroCommand","UseExp")
			SetUIPlay(false)
		}
	}else
	{
		info_board.btn_evolution._visible=false
	}
}

function SendMessage()
{
	fscommand("HeroCommand","GetUseExp"+'\2'+targetLevel)
}

info_board.btn_reduce.onRelease=function()
{
	fscommand("PlaySound","sfx_ui_selection_3")

	targetLevel--
	if(targetLevel<UIData.minLevel)
	{
		targetLevel=UIData.minLevel
	}else
	{
		SendMessage()
	}
}

info_board.btn_add.onRelease=function()
{
	fscommand("PlaySound","sfx_ui_selection_3")

	targetLevel++
	if(targetLevel>UIData.maxLevel)
	{
		targetLevel=UIData.maxLevel
	}else
	{
		SendMessage()
	}
}

_root.item.btn_close.onRelease=function()
{
	SetUIPlay(false)
}
_root.item.bg.onRelease=function()
{
    SetUIPlay(false)
}

function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		_root.item.gotoAndPlay("opening_ani")
	}else
	{
		_root.item.gotoAndPlay("closing_ani")
		_root.item.OnMoveOutOver=function()
		{
			_root._visible=false
		}
	}
}

function FTEUseExp()
{
	info_board.btn_evolution.onRelease()
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.upgrade._visible = false
}

FTEHideAnim()