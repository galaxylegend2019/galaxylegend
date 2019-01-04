import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

function getChildrenOf(movie)
{
	var ret = [];
	for(i in movie)
	{
		var ch = movie[i];
		if(ch instanceof MovieClip)
		{
			ret.push(ch);
		}
	}	
	return ret;
}

var g_title = _root.title_bar;
var g_switchAll = _root.switch_buttons;
var g_serverList = _root.common_list;

var g_curSwitchPage = -1;
var g_switches = [g_switchAll.btn_mine, g_switchAll.btn_recommanded, g_switchAll.btn_all];

var g_totalListPage = 0;
var g_curListPage = 0;

var g_curList = [];
var g_prevList = [];
var g_nextList = [];

var g_mcChatInputting:MovieClip = g_serverList.inputbox_anim.inputbox;
var g_heightChange = 0;
var g_SearchBtn = g_serverList.inputbox_anim.btn_find;

//cs functions
this.onLoad = function(){
	init();
}

function init()
{
	g_title._visible = false;
	g_switchAll._visible = false;
	g_serverList._visible = false;

	move_in();
	SetSwitchBtn(0);
	InitEditText();
}

function move_in()
{
	_root._visible = true;
	g_title._visible = true;
	g_title.gotoAndPlay("opening_ani");
	g_title.OnMoveInOver = function()
	{
		g_title.btn_close.onRelease = function()
		{
			fscommand("PlaySound", "sfx_ui_cancel");
			move_out();
		}
	}

	g_switchAll._visible = true;
	g_switchAll.gotoAndPlay("opening_ani");
	g_switchAll.OnMoveInOver = function()
	{	
		for(var i = 0; i < g_switches.length; ++i)
		{
			g_switches[i].my_index = i;
			g_switches[i].onRelease = function()
			{
				if(g_curSwitchPage != this.my_index)
				{
					fscommand("PlaySound", "sfx_ui_selection_2");
					SetSwitchBtn(this.my_index);
				}
			}
		}
	}

	_root.bg1.gotoAndPlay("opening_ani");
}

function move_out()
{
	g_title.gotoAndPlay("closing_ani");
	g_title.btn_close.onRelease = undefined;
	g_title.OnMoveOutOver = function()
	{
		g_title._visible = false;
		fscommand("ServerListCmd", "Back");
		_root._visible = false;
	}

	g_switchAll.gotoAndPlay("closing_ani");
	g_switchAll.OnMoveOutOver = function()
	{
		g_switchAll._visible = false;
	}

	g_serverList._visible = false;

	_root.bg1.gotoAndPlay("closing_ani");
}

function SetSwitchBtn(switchPage)
{
	if(switchPage != g_curSwitchPage)
	{
		for(var i = 0; i < g_switches.length; ++i)
		{
			if(i == switchPage)
			{
				g_switches[i].gotoAndStop(2);
			}
			else
			{
				g_switches[i].gotoAndStop(1);
			}
		}
		fscommand("ServerListCmd", "Switch" + "\2" + switchPage);
	}
}

function CheckAndScrollPage(pressX, pressY)
{
	if(Math.abs(pressY - _root._ymouse) < 50)
	{
		if(_root._xmouse < pressX - 40)
		{
			SwitchServerPage(false);
		}
		else if(_root._xmouse > pressX + 40)
		{
			SwitchServerPage(true);
		}
	}
}

function SetServerInfo(info, mc)
{
	if(info.isSelf)
	{
		mc.gotoAndStop(2);
		var clip = mc.self;
		clip.txt_name.text = info.nameTxt;
		clip.state.gotoAndStop(info.state);
		clip.txt_vip.text = info.vipTxt;
		clip.txt_level.text = info.levelTxt;
		clip.txt_player.text = info.playerTxt;

		clip.btn_select.my_index = info.indexName;
		clip.btn_select.onPress = function()
		{
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
		clip.btn_select.onRelease = clip.btn_select.onReleaseOutside = function()
		{
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				// trace("select: " + this.my_index);
				fscommand("PlaySound", "sfx_ui_selection_1");
				fscommand("ServerListCmd", "Select" + "\2" + this.my_index);
			}
			else
			{
				// trace("CheckAndScrollPage 111");
				CheckAndScrollPage(this.Press_x, this.Press_y);
			}
		}

		// if(clip.flag.icons == undefined)
		// {
		// 	clip.flag.loadMovie("CommonLaguageFlag.swf")
		// }
		// clip.flag.IconData = info.flagInfo;
		// if(clip.flag.UpdateIcon) { clip.flag.UpdateIcon(); }
		clip.txt_locale.text = info.flagInfo;

		if(clip.headIcon.hero_icons.icons == undefined)
		{
			clip.headIcon.hero_icons.loadMovie("CommonPlayerIcons.swf");
		}
		clip.headIcon.hero_icons.IconData = info.playerIcon;
		if (clip.headIcon.hero_icons.UpdateIcon) { clip.headIcon.hero_icons.UpdateIcon(); }

	}
	else
	{
		mc.gotoAndStop(1);
		var clip = mc.other;
		clip.server_new._visible = info.isNew ? true : false;
		clip.txt_index.text = info.indexTxt;
		clip.txt_name.text = info.nameTxt;
		clip.state.gotoAndStop(info.state);

		clip.btn_select.my_index = info.indexName;
		clip.btn_select.onPress = function()
		{
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
		clip.btn_select.onRelease = clip.btn_select.onReleaseOutside = function()
		{
			if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
			{
				// trace("select: " + this.my_index);
				fscommand("PlaySound", "sfx_ui_selection_1");
				fscommand("ServerListCmd", "Select" + "\2" + this.my_index);
			}
			else
			{
				// trace("CheckAndScrollPage 222");
				CheckAndScrollPage(this.Press_x, this.Press_y);
			}
		}

		// if(clip.flag.icons == undefined)
		// {
		// 	clip.flag.loadMovie("CommonLaguageFlag.swf")
		// }
		// clip.flag.IconData = info.flagInfo;
		// if(clip.flag.UpdateIcon) { clip.flag.UpdateIcon(); }
		clip.txt_locale.text = info.flagInfo

	}
}

function SetListContent(contentList, mc)
{
	for(var i = 0; i < 8; ++i)
	{
		var clip = mc["server_" + (i + 1)];
		if(i >= contentList.length)
		{
			clip._visible = false;
		}
		else
		{
			clip._visible = true;
			SetServerInfo(contentList[i], clip)
		}
	}
}

function SetServerListTotalPage(totalPage)
{
	g_totalListPage = totalPage;
}

function SetServerList(curPage, prevList, curList, nextList)
{
	if(!g_serverList._visible)
	{
		g_serverList.inputbox_anim.gotoAndPlay("opening_ani");
	}

	g_serverList._visible = true;
	g_serverList.btn_hitzone.onPress = function()
	{
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}

	g_serverList.btn_hitzone.onRelease = g_serverList.btn_hitzone.onReleaseOutside = function()
	{
		// trace("g_serverList.btn_hitzone.onRelease");
		CheckAndScrollPage(this.Press_x, this.Press_y);
	}

	g_curListPage = curPage;
	g_curList = curList;
	g_prevList = prevList;
	g_nextList = nextList;

	// trace("g_curListPage: " + g_curListPage + "  g_totalListPage: " + g_totalListPage);

	g_serverList.gotoAndStop(1);
	SetListContent(curList, g_serverList.list_1);

	g_serverList.btn_arrow_prev._visible = g_curListPage > 0;
	g_serverList.btn_arrow_next._visible = g_curListPage < g_totalListPage - 1;
}

function SwitchServerPage(isPrev)
{
	if(g_serverList.is_switching)
	{
		// trace("switching");
		return;
	}

	if(isPrev && g_curListPage > 0)
	{
		g_serverList.gotoAndPlay("list_2");
		SetListContent(g_curList, g_serverList.list_2);
		SetListContent(g_prevList, g_serverList.list_1);
		
		g_serverList.is_switching = true;
		g_serverList.OnSwitchOver = function()
		{
			this.is_switching = false;
			// trace("OnSwitchOver Prev");
			fscommand("ServerListCmd", "ScrollPage" + "\2" + (g_curListPage - 1));
		}
	}
	else if(!isPrev && g_curListPage < g_totalListPage - 1)
	{
		g_serverList.gotoAndPlay("list_1");
		SetListContent(g_curList, g_serverList.list_1);
		SetListContent(g_nextList, g_serverList.list_2);

		g_serverList.is_switching = true;
		g_serverList.OnSwitchOver = function()
		{
			this.is_switching = false;
			// trace("OnSwitchOver Next");
			fscommand("ServerListCmd", "ScrollPage" + "\2" + (g_curListPage + 1));
		}
	}
}


function InitEditText() //init edit text
{
	g_mcChatInputting.init("TextView", "FlashChooseServerUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, true);
	g_mcChatInputting.setMaxLength(16);

	g_mcChatInputting.onChangeKeyBoardHeight = function ()
	{
		g_heightChange = Math.abs(g_mcChatInputting.GetHeightChange());
	}

	g_SearchBtn.onPress = function ()
	{
		fscommand('FS_TEXTEDIT,SendPressed');
		g_heightChange = 0;
	}

	g_SearchBtn.onReleaseOutside = function ()
	{
		fscommand('FS_TEXTEDIT,SendReleased');
		g_heightChange = 0;
	}

	g_SearchBtn.onRelease = function()
	{
		fscommand('FS_TEXTEDIT,SendReleased');
		g_heightChange = 0;
		// fscommand("CUSTOM_PLAYSFX","sfx_ui_button_click");
		var textData:String = g_mcChatInputting.getInputString();
		if (textData.length == 0)
		{
			return;
		}
		fscommand("ServerListCmd", "Search" + "\2" + textData);
		lua2fs_setInputEmpty();
	}
}

function lua2fs_setInputEmpty()
{
	// trace('==============lua2fs_setInputEmpty');
	g_mcChatInputting.content_text.htmlText = '';
	g_mcChatInputting.lua2fs_setText('');

	g_mcChatInputting.setMaxLength(16)
}
