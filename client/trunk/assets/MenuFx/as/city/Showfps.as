import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;
import common.CTextEdit;

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


var g_IsShow = false;
var g_History = [];
var g_HistoryIndex = -1;

//cs functions
_root.onLoad = function()
{
	Init();
}

function Init()
{
	_root.btn_Switch._visible = false;
	_root.btn_Switch.onRelease = function()
	{
		if(g_IsShow)
		{
			g_IsShow = false;
			_root.InputBox._visible = false;
			_root.btn_Send._visible = false;
			_root.txt_Result._visible = false;
			_root.txt_Cmd._visible = false;
			_root.txt_udid._visible = false;
			_root.btn_Up._visible = false;
			_root.btn_Down._visible = false;
			_root.btn_Clear._visible = false;
			_root.btn_Fps._visible = false;
			_root.btn_Body._visible = false;
			_root.btn_test._visible=false;
			_root.btn_break._visible = false;
			_root.btn_super._visible = false;
			_root.btn_profiler_enable._visible = false;
			_root.btn_profiler_output._visible = false;
			_root.btn_log._visible = false;
			_root.btn_tttt._visible = false;
		}
		else
		{
			g_IsShow = true;
			_root.InputBox._visible = true;
			_root.btn_Send._visible = true;
			_root.txt_Result._visible = true;
			_root.txt_Cmd._visible = true;
			_root.txt_udid._visible = true;
			_root.btn_Up._visible = true;
			_root.btn_Down._visible = true;
			_root.btn_Clear._visible = true;
			_root.btn_Fps._visible = true;
			_root.btn_Body._visible = true;
			_root.btn_test._visible=true;
			_root.btn_break._visible = true;
			_root.btn_super._visible = true;
			_root.btn_profiler_enable._visible = true;
			_root.btn_profiler_output._visible = true;
			_root.btn_log._visible = true;
			_root.btn_tttt._visible = true;
		}
	}

	InitEditText();
	_root.txt_Fps._visible = false;
}

//Test text edit
var g_mcChatInputting:MovieClip = _root.InputBox.Inputting;
var g_SendBtn = _root.btn_Send;
var g_isSendBtnPressed = false;
var g_heightChange = 0;
var g_isShowBodyRadius = false;
var g_isProfilerEnable = false;
var g_isCombatSuperEnable = false;

_root.InputBox.posY = _root.InputBox._y;
g_mcChatInputting.onChangeKeyBoardHeight = function ()
{

	g_heightChange = g_mcChatInputting.GetHeightChange();
	_root.InputBox._y = _root.InputBox.posY + g_heightChange;
	// trace("onChangeKeyBoardHeight: " + g_heightChange + "  " + g_mcChatInputting.getInputZoneGlobalPos().y);
}

g_mcChatInputting.onTextChange = function(inputString)
{
	trace("onTextChange: " + inputString);
}

g_mcChatInputting.onShowKeyboard = function()
{
	trace("onShowKeyboard ");
}

g_mcChatInputting.onHideKeyboard = function()
{
	trace("onHideKeyboard ");
}

// g_mcChatInputting.beginHideKeyboard = function()
// {
// 	trace("beginHideKeyboard ");
// }

g_mcChatInputting.onReturnPressed = function()
{
	trace("onReturnPressed " + g_mcChatInputting.getInputString())
}


function lua2fs_setInputEmpty()
{
	// trace('==============lua2fs_setInputEmpty');
	g_mcChatInputting.content_text.htmlText = '';
	g_mcChatInputting.lua2fs_setText('');

	g_mcChatInputting.setMaxLength(100)
}

function InitEditText() //init edit text
{
	g_mcChatInputting.init("UIKeyboardTypeDefault", "FlashShowfpsUI", "hitzone", "", "content_text", false, false, '', "TextView", null, null, null, true);

	g_mcChatInputting.setMaxLength(100);

	_root.InputBox._visible = false;
	_root.btn_Send._visible = false;
	_root.txt_Result._visible = false;
	_root.txt_Cmd._visible = false;
	_root.txt_udid._visible = false;
	_root.btn_Up._visible = false;
	_root.btn_Down._visible = false;
	_root.btn_Clear._visible = false;
	_root.btn_Fps._visible = false;
	_root.btn_Body._visible = false;
	_root.btn_test._visible=false;
	_root.btn_break._visible = false;
	_root.btn_super._visible = false;
	_root.btn_profiler_enable._visible = false;
	_root.btn_profiler_output._visible = false;
	_root.btn_log._visible = false;
	_root.btn_tttt._visible = false;
}


g_SendBtn.onPress = function ()
{
	fscommand('FS_TEXTEDIT,SendPressed');
	g_isSendBtnPressed = true;
	g_heightChange = 0;
}

g_SendBtn.onReleaseOutside = function ()
{
	fscommand('FS_TEXTEDIT,SendReleased');
	g_isSendBtnPressed = false;
	g_heightChange = 0;
}

g_SendBtn.onRelease = function ()
{
	fscommand('FS_TEXTEDIT,SendReleased');
	g_isSendBtnPressed = false;
	g_heightChange = 0;
	// fscommand("CUSTOM_PLAYSFX","sfx_ui_button_click");
	var textData:String = g_mcChatInputting.getInputString();
	if (textData.length == 0)
	{
		return;
	}

	// fscommand("FS_CHAT_SEND", textData);
	g_History.unshift(textData);
	g_HistoryIndex = -1;
	if(g_History.length > 30)
	{
		g_History.pop();
	}

	fscommand("DoString", textData);
	_root.txt_Cmd.text = textData + " >";
	// trace("Edit Text: " + textData);
	lua2fs_setInputEmpty();
}

_root.btn_Body.onRelease = function()
{
	g_isShowBodyRadius = !g_isShowBodyRadius
	fscommand("ShowBodyRadius", g_isShowBodyRadius);
}

_root.btn_break.onRelease = function()
{
	fscommand("CastSkillBreak", "1");
}

_root.btn_super.onRelease = function()
{
	g_isCombatSuperEnable = !g_isCombatSuperEnable
	fscommand("CombatSuper", g_isCombatSuperEnable);
}

_root.btn_profiler_enable.onRelease = function()
{
	g_isProfilerEnable = !g_isProfilerEnable
	fscommand("DebugProfilerEnable", g_isProfilerEnable);
	_root.btn_profiler_enable.txt_profiler.text = g_isProfilerEnable ? "Prof_on":"Prof_off";
}

_root.btn_profiler_output.onRelease = function()
{
	fscommand("DebugProfilerOutput");
}

_root.btn_log.onRelease=function()
{
	fscommand("DebugCommand","DebugPrint");
}

_root.btn_tttt.onRelease=function()
{
	fscommand("DebugTutorial");
}

_root.btn_test.onRelease=function()
{
	fscommand("GotoNextMenu","GS_TestScene")
}
_root.btn_Up.onRelease = function()
{
	if(g_History.length > 0 and g_HistoryIndex < g_History.length - 1)
	{
		++g_HistoryIndex;
		g_mcChatInputting.content_text.htmlText = g_History[g_HistoryIndex];
		g_mcChatInputting.lua2fs_setText(g_History[g_HistoryIndex]);
		g_mcChatInputting.setMaxLength(500)
	}
}

_root.btn_Down.onRelease = function()
{
	if(g_History.length > 0 and g_HistoryIndex > 0)
	{
		--g_HistoryIndex;
		g_mcChatInputting.content_text.htmlText = g_History[g_HistoryIndex];
		g_mcChatInputting.lua2fs_setText(g_History[g_HistoryIndex]);
		g_mcChatInputting.setMaxLength(500);
	}
	else if(g_HistoryIndex == 0)
	{
		--g_HistoryIndex;
		g_mcChatInputting.content_text.htmlText = "";
		g_mcChatInputting.lua2fs_setText("");
		g_mcChatInputting.setMaxLength(500);
	}
}

_root.btn_Clear.onRelease = function()
{
	// _root.txt_Cmd.text = "";
	fscommand("DoString", "gm delme")
	// _root.txt_Result.text = "";
}

_root.btn_Fps.onRelease = function()
{
	_root.txt_Fps._visible = !_root.txt_Fps._visible;
}

function SetFpsText(txt : String)
{
	_root.txt_Fps.text = txt;
}

function SetDebugResult(txt: String)
{
	_root.txt_Result.text = txt;
}

function SetEnable(enable)
{
	_root.btn_Switch._visible = enable;
	// if(enable)
	// {
	// 	fscommand("DoString", "gm showudid");
	// }
}

function SetUdid(txt: String)
{
	_root.txt_udid.text = txt;
}

function SetInputText(txt: String)
{
	g_mcChatInputting.content_text.htmlText = txt;
	g_mcChatInputting.lua2fs_setText(txt);
	g_mcChatInputting.setMaxLength(500);
}