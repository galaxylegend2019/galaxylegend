import common.CTextAutoSizeTool;
var all_view_mov_object_list : Array = [ _root.ItemBoxUI ];

this.onLoad = function(){
	init();

    // var infos = [];
    // for(var i = 0; i < 4; ++i)
    // {
    //     var info = new Object();
    //     info.nameTxt = "0" + i;
    //     info.oldTxt = "6" + i;
    //     info.newTxt = "8" + i;
    //     infos.push(info);
    // }
    // Show(infos, "xyyy", "");
}

function init()
{
	_root.popup_info._visible = false;
	_root.btn_bg._visible = false;
}

function Show(infos, unlockTitleTxt, unlockedTxt)
{
	_root.popup_info._visible = true;
	_root.btn_bg._visible = true;

	var pop_content = _root.popup_info.pop_content;
    pop_content.gotoAndPlay("opening_ani");
    fscommand("PlaySound","sfx_ui_commander_level_up")
	pop_content.OnMoveInOver = function()
	{
		this.btn_close.onRelease = function()
		{
			this.onRelease = undefined;
			Hide();
		}
		this.bg.btn_bg.onRelease = function(){};
	}

	for(var i = 0; i < infos.length; ++i)
	{
		var clip = pop_content.item_list["item_" + i];
		if(clip)
		{
            var info = infos[i];
            CTextAutoSizeTool.SetSingleLineText(clip.txt_Name, info.nameTxt, 22, 16);
			clip.txt_Old.text = info.oldTxt;
			clip.txt_New.text = info.newTxt;
			clip.clip_icon.gotoAndStop(info.clipIdx);
		}
	}
	pop_content.unlock_list.item_unlock.txt_UnlockTitle.text = unlockTitleTxt;
    pop_content.unlock_list.item_unlock.txt_Unlocked.text = unlockedTxt;
    pop_content.unlock_list._visible = true
    if (unlockTitleTxt == "" || unlockedTxt == "")
    {
        pop_content.unlock_list._visible = false
    }

	// pop_content.btn_shield.onRelease = function(){}
	pop_content.btn_shield.onRelease = undefined;
	_root.btn_bg.onRelease = function()
	{
		// _root.popup_info.pop_content.btn_close.onRelease();
		Hide();
	}
}

function Hide()
{
	var pop_content = popup_info.pop_content;
	pop_content.gotoAndPlay("closing_ani");
	//fscommand("TutorialCommand","resume");
	pop_content.OnMoveOutOver = function()
	{
		_root.popup_info._visible = false;
	}

	_root.btn_bg._visible = false;
	_root.btn_bg.onRelease = undefined;
}




