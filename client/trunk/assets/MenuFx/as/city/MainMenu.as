import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;
import common.CTextEdit;

_root.onLoad = function()
{
	init();
	loadBGNumber();
}

function init()
{
	InitEditText();
}

_root.btn_union.onRelease=function()
{
	fscommand("GotoNextMenu","GS_UnionPage")
	trace("btn_union --------")
}

_root.btn_hero.onRelease=function()
{
	fscommand("GotoNextMenu","GS_HeroPage")
	trace("btn_hero --------")
}

_root.btn_props.onRelease=function()
{
	fscommand("GotoNextMenu","GS_PropsPage")
	trace("GS_PropsPage mainMenu --------")
}

_root.btn_arena.onRelease = function()
{
	fscommand("GotoNextMenu","GS_Arena")
	trace("GS_PropsPage mainMenu --------")
}

_root.btn_callection.onRelease = function()
{
	fscommand("GotoNextMenu","GS_Collection")
	trace("GS_PropsPage Collection --------")
}

_root.btn_pve.onRelease = function()
{
	fscommand("GotoNextMenu","GS_PveMap")
	trace("GS_PropsPage Collection --------")
}

_root.btn_Expedition.onRelease = function()
{
	fscommand("GotoNextMenu","GS_Expedition")
	trace("GS_PropsPage Collection --------")
}

_root.btn_gacha.onRelease = function()
{
	fscommand("GotoNextMenu","GS_Gacha")
	trace("GS_PropsPage GS_Gacha --------")
}

_root.btn_MonthCard.onRelease = function()
{
	fscommand("GotoNextMenu","GS_MonthCard")
}

_root.btn_Task.onRelease = function()
{
	fscommand("GotoNextMenu","GS_Task")
	trace("GS_PropsPage Collection --------")
}

_root.btn_testScene.onRelease = function()
{
	fscommand("GotoNextMenu","GS_TestScene")
}


_root.btn_close.onRelease=function()
{
	fscommand("Logout")
}

_root.onStagePress = function(){
	fscommand("Debug","onStagePress   x : " + _root._xmouse + "  y: " + _root._ymouse);
	return false;
}

_root.onStageMove = function(){
	fscommand("Debug","onStageMove   x : " + _root._xmouse + "  y: " + _root._ymouse);
	return false;
}

_root.onStageRelease = function(){
	fscommand("Debug","onStageRelease   x : " + _root._xmouse + "  y: " + _root._ymouse);
	return false;
}

var g_BG = bg;
var g_BGOrignalX = bg._x;
var g_BGOrignalY = bg._y;

function Accel_SetOffSet(offX, offY)
{
	g_BG._x = g_BGOrignalX + offX * 100;
	g_BG._y = g_BGOrignalY + offY * 100;
}

// //Test text edit
// var g_mcChatInputting:MovieClip = _root.InputBox.Inputting;
// var g_SendBtn = _root.btn_send;
// var g_isSendBtnPressed = false;
// var g_heightChange = 0;

// g_mcChatInputting.onChangeKeyBoardHeight = function ()
// {
// 	g_heightChange = Math.abs(g_mcChatInputting.GetHeightChange());
// 	if (!g_isSendBtnPressed){
// 		// AdjustChatRecordHeight();
// 		trace("AdjustChatRecordHeight: " + g_heightChange);
// 	}
// }

// function lua2fs_setInputEmpty()
// {
// 	// trace('==============lua2fs_setInputEmpty');
// 	g_mcChatInputting.content_text.htmlText = '';
// 	g_mcChatInputting.lua2fs_setText('');

// 	g_mcChatInputting.setMaxLength(500)
// }

// function InitEditText() //init edit text
// {
// 	g_mcChatInputting.init("TextView", "FlashMainMenuUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, true);
// 	g_mcChatInputting.setMaxLength(500)
// }


// g_SendBtn.onPress = function ()
// {
// 	fscommand('FS_TEXTEDIT,SendPressed');
// 	g_isSendBtnPressed = true;
// 	g_heightChange = 0;
// }

// g_SendBtn.onReleaseOutside = function ()
// {
// 	fscommand('FS_TEXTEDIT,SendReleased');
// 	g_isSendBtnPressed = false;
// 	g_heightChange = 0;
// }

// g_SendBtn.onRelease = function ()
// {
// 	fscommand('FS_TEXTEDIT,SendReleased');
// 	g_isSendBtnPressed = false;
// 	g_heightChange = 0;
// 	fscommand("CUSTOM_PLAYSFX","sfx_ui_button_click");
// 	var textData:String = g_mcChatInputting.getInputString();
// 	if (textData.length == 0)
// 	{
// 		return;
// 	}

// 	// fscommand("FS_CHAT_SEND", textData);
// 	trace("Edit Text: " + textData);
// 	lua2fs_setInputEmpty();
// }

//just for the background
function loadBGNumber()
{
	_root.bg.num1.loadMovie("NumberAnimat.swf")
	_root.bg.num2.loadMovie("NumberAnimat.swf")
	_root.bg.num3.loadMovie("NumberAnimat.swf")
}