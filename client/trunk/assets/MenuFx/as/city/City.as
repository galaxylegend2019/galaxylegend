import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

/**************************************************************************
 * MovieClip list
 */

var g_mcTestPanel:MovieClip = _root.TestPanel;
var g_mcTestPanelDetail:MovieClip = g_mcTestPanel.TestDetail;

function InitFlash()
{
	g_mcTestPanel._visible = false;
}

this.onLoad = function()
{
	InitFlash();

	// SetShowMenu(true, LuaSA_MCPlayType.PlayIn);

}

function onShowOK(mc)
{
	fscommand('UnlockInput');
}

function onHideOK(mc)
{
	fscommand('UnlockInput');
	mc._visible = false;
}

function SetShowMenu(isShow, playType)
{
	g_mcTestPanel._visible = isShow;
	Utils.SetPlayMC(g_mcTestPanel, playType);
}

function ShowContentMenu(title, content)
{
	SetShowMenu(true, LuaSA_MCPlayType.PlayIn);
	g_mcTestPanelDetail.txtTitle.text = title;
	g_mcTestPanelDetail.txtContent.text = content;
}

g_mcTestPanel.btnuntouch1.onRelease = function()
{
	fscommand("BG_Release");
}

g_mcTestPanelDetail.btnOk.btnReleaseAnimStart = function()
{
	trace(LuaSA_MenuType.GS_Battle)
	fscommand("GotoNextMenu", "GS_Battle");
}

g_mcTestPanelDetail.btnClose.btnReleaseAnimStart = function()
{
	fscommand("FS_MENU_CLOSE");
}






