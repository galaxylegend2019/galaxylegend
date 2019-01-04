
var UIRoot = _root.icon_content;

var UIContent = UIRoot.pop_content;

var CloseBtn = UIContent.bg_btn;

var HeadList = UIContent.item_origin.list_content.view_list;
var SelectOKBtn = UIContent.item_origin.ok_btn;

var IconDatas = undefined;

var CurSelectIcon = undefined;

var SelectType 	= 1;   //0:AllianceIcon 1:HeroIcon

this.onLoad = function()
{
	
	//_root._visible = false;
	OpenUI();
}


CloseBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_cancel");
	CloseUI();
}

UIContent.OnMoveOutOver = function()
{
	if (SelectType == 0)
	{

		fscommand("AllianceCommand","CloseSelectIconUI");
	}else if (SelectType == 1)
	{
		fscommand("AllianceMainCmd","AddDefender");
		//fscommand("GoToNext", "BackToAllianceMain")
	}
}

UIContent.OnMoveInOver = function()
{
	UIContent.stop();
}

function OpenUI()
{
	UIContent.gotoAndPlay("opening_ani");
}

function CloseUI()
{
	UIContent.gotoAndPlay("closing_ani");
}

function SetUIShow( bShow )
{
	if (bShow == undefined)
	{
		bShow = false;
	}
	_root._visible = bShow;
}

function SetTitle(text)
{
	UIContent.panel_title.title_txt.text = text;
}

SelectOKBtn.onRelease = function()
{
	fscommand("PlaySound","sfx_ui_selection_1");
	if (SelectType == 0)
	{
		if (CurSelectIcon == undefined)
		{
			fscommand("AllianceCommand","CloseSelectIconUI");
		}else
		{
			fscommand("AllianceCommand","CloseSelectIconUI" + "\2" + String(CurSelectIcon));
		}
	}else if (SelectType == 1)
	{
		fscommand("AllianceMainCmd","AddDefender" + "\2" + String(CurSelectHero));
		//fscommand("GoToNext", "BackToAllianceMain")
	}
}

/*******************AllianceIcon**************************/
function InitUI( icon_datas )
{
	SelectType = 0;
	IconDatas = icon_datas;
	InitHeadList();
}

function InitHeadList()
{
	HeadList.clearListBox();
	HeadList.initListBox("list_alliance_icon", 0, true, true);
	HeadList.enableDrag(true);
	HeadList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	HeadList.onItemEnter = function(mc,index_item)
	{
		mc._visible=true;
		SetItemInfo(mc, index_item);
	}
	HeadList.onItemMCCreate = undefined;
	HeadList.onListboxMove = undefined;
    var nLine = Math.ceil(IconDatas.length / 5);
	for( var i = 0; i < nLine; i++ )
	{   
	    var temp = HeadList.addListItem(i, false, false);
	}
}

function SetItemInfo(mc, index_item)
{
    for (var i = 1; i <= 5; i++)
	{
		var IconMc = mc["head_icon" + i ];
        IconMc._visible = true
        IconMc.selected._visible = false
        var nIndex = index_item * 5 + i - 1;
        var iconData = IconDatas[nIndex];
		if (iconData == undefined)
		{
			IconMc._visible = false;
			continue;
		}
        IconMc.Index = nIndex;
        var width = IconMc.item_icon._width;
        var height = IconMc.item_icon._height;
		if (IconMc.item_icon.icons == undefined){
            IconMc.item_icon.loadMovie("AllianceIcon.swf");
        }
        IconMc.item_icon._width = width;
        IconMc.item_icon._height = height;

		if (iconData)
        {
            IconMc.item_icon.icons.gotoAndStop(iconData)
        }
		IconMc.onPress = function()
		{
			this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
        IconMc.onRelease = function()
		{
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				//deal click
				fscommand("PlaySound","sfx_ui_selection_1");
				if (_root.curSelectIcon != undefined)
				{
                    _root.curSelectIcon.selected._visible = false
				}
                this.selected._visible = true
				_root.curSelectIcon = this;
                CurSelectIcon = IconDatas[this.Index];
			}
		}
		IconMc.onReleaseOutside = function()
		{
			this._parent._parent.onReleasedInListbox();
		}
	}
}



/**************************HeroIcon****************************/

var HeroDatas = undefined;
var CurSelectHero = 0;


function InitHeroList( datas )
{
	HeroDatas = datas;
	SelectType = 1;

	if (HeroDatas == undefined)
	{
		return;
	}

	HeadList.clearListBox();
    HeadList.initListBox("list_My_Hero", 0, true, true);
	HeadList.enableDrag(true);
	HeadList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	HeadList.onItemEnter = function(mc,index_item)
	{
		mc._visible=true;
		SetHeroInfo(mc, index_item);
	}
	HeadList.onItemMCCreate = undefined;
	HeadList.onListboxMove = undefined;
    var nLine = Math.ceil(HeroDatas.length / 5);
	for( var i = 0; i < nLine; i++ )
	{   
	    var temp = HeadList.addListItem(i, false, false);
	}

}


function SetHeroInfo(mc, index_item)
{
    for (var i = 1; i <= 5; i++)
	{
        var IconMc = mc["hero_icon" + i ];
		IconMc.item_icon._visible = false;

        var nIndex = index_item * 5 + i - 1;

		var heroData = HeroDatas[nIndex];
		if (heroData == undefined)
		{
			IconMc._visible = false;
			continue;
		}

		IconMc.selected_bg._visible = false;
		IconMc.hero_head.head_info.gotoAndStop(2);
		IconMc.hero_head.head_info.click_bg._visible = false;
        IconMc.hero_head.star_plane.gotoAndStop(heroData.star);
        IconMc.hero_head.level_info.level_text.text = "Lv." + heroData.level;
        IconMc.hero_head.name_txt.text = heroData.name;

		switch(heroData.state)
		{
			case 0:
				IconMc.hero_head.defend_state._visible = false;
			break;
			case 1:
				IconMc.hero_head.defend_state._visible = true;
				IconMc.hero_head.defend_state.gotoAndStop(1);
			break;
			case 2:
				IconMc.hero_head.defend_state._visible = true;
				IconMc.hero_head.defend_state.gotoAndStop(2);
			break;
			default:
			break;
		}

		if (IconMc.hero_head.item_icon.icons == undefined){
			IconMc.hero_head.item_icon.loadMovie("CommonHeros.swf");
		}
		if (heroData)
		{
			IconMc.hero_head.item_icon.IconData = heroData.icon_data;
			if(IconMc.hero_head.item_icon.UpdateIcon)
			{ 
				IconMc.hero_head.item_icon.UpdateIcon(); 
			}
		}
		IconMc.onPress = function()
		{
			this._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
		IconMc.Index = nIndex;
		IconMc.onRelease = function()
		{
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				//deal click
				fscommand("PlaySound","sfx_ui_selection_1");
				if (HeroDatas[this.Index].state == 0)
				{
					if (_root.curSelectIcon != undefined)
					{
						//_root.curSelectIcon.hero_head.head_info.click_bg._visible = false;
						_root.curSelectIcon.hero_head.item_icon.SelectIcon(false);
					}
					this.hero_head.head_info.gotoAndStop(2);
					//this.hero_head.head_info.click_bg._visible = true;
					//this.hero_head.head_info.click_bg.gotoAndStop("quality_" + HeroDatas[this.Index].quality);
					this.hero_head.item_icon.SelectIcon(true);
					_root.curSelectIcon = this;
					CurSelectHero = HeroDatas[this.Index].hero_id;
				}
			}
		}
		IconMc.onReleaseOutside = function()
		{
			this._parent._parent.onReleasedInListbox();
		}
	}
}