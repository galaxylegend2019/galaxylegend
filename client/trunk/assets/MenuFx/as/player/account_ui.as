
var g_TopUI = _root.top_ui;
var g_MainUI = _root.main;
var g_BindResultUI = _root.pop_bindResult;
var g_LoginPopUI = _root.popup_fb;

var g_BindRewardData = undefined;

var g_BindedCharactorData = undefined;
var g_CreateNewData = undefined;
var g_IsBindSucess = false;

this.onLoad = function()
{
	init()
}

function init()
{
	g_BindResultUI._visible = false;
	_root.pop_break._visible = false;
	g_LoginPopUI._visible = false;
	_root.popup_logout._visible = false;
	g_TopUI._visible = false;
	g_MainUI._visible = false;

	g_MainUI.login_types._visible = false;
	g_MainUI.login._visible = false;
	g_MainUI.content_3._visible = false;
	g_MainUI.content_2._visible = false;
	g_MainUI.content_1._visible = false;
}

function move_in()
{
	// trace("move_in: " + g_TopUI + "  " + g_TopUI._visible);
	g_TopUI._visible = true;
	g_TopUI.gotoAndPlay("opening_ani");
	g_TopUI.OnMoveInOver = function()
	{
		this.btn_close.onRelease = function()
		{
			fscommand("AccountCmd", "CloseUI");
		}
		// this.money.onRelease=function()
		// {
		// 	fscommand("GoToNext", "Affair");
		// }
		// this.credit.onRelease=function()
		// {
		// 	fscommand("GoToNext", "Purchase");
		// }

		// this.energy.onRelease=function()
		// {
		// 	fscommand("GoToNext", "Affair");
		// }
	}

	g_MainUI._visible = true;
	g_MainUI.login_bg_all.gotoAndPlay("opening_ani");
	g_MainUI.login_bg_all.onRelease = function()
	{
		//do nothing
	}
}

function move_out()
{
	g_TopUI.btn_close.onRelease = undefined;
	g_TopUI.OnMoveOutOver = function()
	{
		this._visible = false;
		fscommand("AccountCmd", "OnUIClosed");
	}
	g_TopUI.gotoAndPlay("closing_ani");

	// g_MainUI.login_bg_all.OnMoveOutOver = function()
	// {
	// 	this.onRelease = undefined;
	// 	this._parent._visible = false;
	// }
	g_MainUI.login_bg_all.gotoAndPlay("closing_ani");
}

function SetMoneyData(datas)
{
	g_TopUI.money.money_text.text = datas.money;
	g_TopUI.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = g_TopUI.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

function SetBindRewardData(rewardData)
{
	g_BindRewardData = rewardData;
}

function ShowNotBinded(awardDatas)
{
	g_MainUI.login._visible = true;
	g_MainUI.login.OnMoveInOver = function()
	{
		this.btn_facebook.onRelease = function()
		{
			fscommand("AccountCmd", "facebook");
		}
		this.btn_otherAccount.onRelease = function()
		{
			HideNotBinded();
			fscommand("AccountCmd", "otherAccount" + "\2" + "accountPop");
		}
	}

	//init rewardData
	for(var i = 0; i < 6; ++i)
	{
		var mc = g_MainUI.login.item_icons["item_" + (i + 1)];
		var award = awardDatas[i];
		if(award)
		{
			mc._visible = true;
			mc.txt_name.text = award.name;
			mc.item_num.text = award.count;
			if(mc.item_icon.icons==undefined)
			{
				var w = mc.item_icon._width;
				var h = mc.item_icon._height;
				mc.item_icon.loadMovie("CommonIcons.swf")
				mc.item_icon._width = w;
				mc.item_icon._height = h;
			}
			mc.item_icon.IconData = award.iconInfo
			if (mc.item_icon.UpdateIcon) { mc.item_icon.UpdateIcon(); }
		}
		else
		{
			mc._visible = false;
		}
	}

	g_MainUI.login.gotoAndPlay("opening_ani");
}

function HideNotBinded()
{
	g_MainUI.login._visible = false;
	g_MainUI.login.btn_facebook.onRelease = undefined;
	g_MainUI.login.btn_otherAccount.onRelease = undefined;
}

function ShowBinded(datas)
{
	g_BindedCharactorData = datas;
	g_MainUI.content_2._visible = true;
	g_MainUI.content_2.content.gotoAndPlay("opening_ani");

	var listView = g_MainUI.content_2.content.content_list;
	listView.setSpecialItemHeight("herolist2_1", 5)
	listView.clearListBox();
	listView.initListBox("herolist2_3",5,true,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}
	listView.onItemEnter = function(mc, index_item)
	{
		var data = g_BindedCharactorData[index_item];
		var clipIndex = data.clipIndex;
		mc.gotoAndStop(data.clipIndex);
		mc.isSpecial = data.isSpecial;
		if(data.clipIndex == 1)
		{
			mc.logout.txt_name.text = data.nameTxt;
			mc.logout.btn_logout.onRelease = function()
			{
				fscommand("AccountCmd", "logout");
			}
		}
		else if(data.clipIndex == 3)
		{
			var barMc = mc.charcator;
			for(var i = 0; i < 2; ++i)
			{
				var detail = data.details[i];
				var clip = barMc["board" + (i + 1)];
				if(detail == undefined)
				{
					clip._visible = false;
					continue;
				}
				clip._visible = true;
				clip.gotoAndStop(detail.clipIndex);
				clip.characterId = detail.characterId;
				clip.serverId = detail.serverId;
				if(detail.clipIndex == 1 || detail.clipIndex == 2)
				{
					clip.equip_info.equip_level.text = detail.levelTxt;
					clip.txt_name.text = detail.nameTxt;
					clip.txt_vip.text = detail.vipTxt;
					clip.txt_server.text = detail.serverTxt;

					if(clip.head_icon.player_icon.icons == undefined)
					{
						var head_width = clip.head_icon.player_icon._width
						var head_height = clip.head_icon.player_icon._height
						head_icon = clip.head_icon.player_icon.loadMovie("CommonPlayerIcons.swf");
						head_icon._width = head_width
						head_icon._height = head_height
					}

					clip.head_icon.player_icon.IconData = detail.playerIcon;
					if (clip.head_icon.player_icon.UpdateIcon) 
					{
						clip.head_icon.player_icon.UpdateIcon()
					}

					if(detail.allianceIcon == undefined)
					{
						detail.icon._visible = false;
					}
					else
					{
						detail.icon._visible = true;
						if(clip.icon.hero_icons.icons == undefined)
						{
							var head_width = clip.icon.hero_icons._width
							var head_height = clip.icon.hero_icons._height
							head_icon = clip.icon.hero_icons.loadMovie("AllianceIconSmall.swf");
							head_icon._width = head_width
							head_icon._height = head_height
						}
						clip.icon.hero_icons.IconData.icons.gotoAndStop(detail.allianceIcon);
					}
				}
				else
				{

				}

				if(clip.btn_bg)
				{
					clip.btn_bg.onPress = function()
					{
						this._parent._parent._parent._parent.onPressedInListbox();
						this.Press_x = _root._xmouse;
						this.Press_y = _root._ymouse;
					}
					clip.btn_bg.onReleaseOutside = function()
					{
						this._parent._parent._parent._parent.onReleasedInListbox();
					}
					clip.btn_bg.onRelease = function()
					{
						this._parent._parent._parent._parent.onReleasedInListbox();
						if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
						{
							fscommand("AccountCmd", "BindedClicked" + "\2" + this._parent.serverId + "\2" + this._parent.characterId);
						}
					}
				}
			}
		}
	}

	for( var i = 0; i < datas.length; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}

function HideBinded()
{
	var listView = g_MainUI.content_2.content.content_list;
	listView.clearListBox();
	g_MainUI.content_2._visible = false;
}

function ShowCreateNewPop(datas)
{
	g_CreateNewData = datas;
	g_MainUI.content_1._visible = true;
	g_MainUI.content_1.content.gotoAndPlay("opening_ani");

	var listView = g_MainUI.content_1.content.content_list;
	listView.setSpecialItemHeight("herolist1_1", 5)
	listView.clearListBox();
	listView.initListBox("herolist_1",5,true,true);
	listView.enableDrag( true );
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}
	listView.onItemEnter = function(mc, index_item)
	{
		var data = g_CreateNewData[index_item];
		var clipIndex = data.clipIndex;
		mc.gotoAndStop(data.clipIndex);
		mc.isSpecial = data.isSpecial;
		if(data.clipIndex == 1)
		{
			mc.bar.txt_title.text = data.titleTxt;
		}
		else if(data.clipIndex == 2)
		{
			var barMc = mc.charcator;
			for(var i = 0; i < 2; ++i)
			{
				var detail = data.details[i];
				var clip = barMc["board" + (i + 1)];
				if(detail == undefined)
				{
					clip._visible = false;
					continue;
				}
				clip._visible = true;
				clip.gotoAndStop(detail.clipIndex);
				clip.characterId = detail.characterId;
				clip.serverId = detail.serverId;
				if(detail.clipIndex == 1)
				{
					clip.equip_info.equip_level.text = detail.levelTxt;
					clip.txt_name.text = detail.nameTxt;
					clip.txt_vip.text = detail.vipTxt;
					clip.txt_server.text = detail.serverTxt;

					if(clip.head_icon.player_icon.icons == undefined)
					{
						var head_width = clip.head_icon.player_icon._width
						var head_height = clip.head_icon.player_icon._height
						head_icon = clip.head_icon.player_icon.loadMovie("CommonPlayerIcons.swf");
						head_icon._width = head_width
						head_icon._height = head_height
					}

					clip.head_icon.player_icon.IconData = detail.playerIcon;
					if (clip.head_icon.player_icon.UpdateIcon) 
					{
						clip.head_icon.player_icon.UpdateIcon()
					}

					if(detail.allianceIcon == undefined)
					{
						detail.icon._visible = false;
					}
					else
					{
						detail.icon._visible = true;
						if(clip.icon.hero_icons.icons == undefined)
						{
							var head_width = clip.icon.hero_icons._width
							var head_height = clip.icon.hero_icons._height
							head_icon = clip.icon.hero_icons.loadMovie("AllianceIconSmall.swf");
							head_icon._width = head_width
							head_icon._height = head_height
						}
						clip.icon.hero_icons.IconData.icons.gotoAndStop(detail.allianceIcon);
					}

					// clip.btn_bg.onPress = undefined;
					// clip.btn_bg.onReleaseOutside = undefined;
					// clip.btn_bg.onRelease = undefined;
				}
				else
				{
					clip.txt_server.text = detail.serverTxt;

					clip.btn_bg.onPress = function()
					{
						this._parent._parent._parent._parent.onPressedInListbox();
						this.Press_x = _root._xmouse;
						this.Press_y = _root._ymouse;
					}
					clip.btn_bg.onReleaseOutside = function()
					{
						this._parent._parent._parent._parent.onReleasedInListbox();
					}
					clip.btn_bg.onRelease = function()
					{
						this._parent._parent._parent._parent.onReleasedInListbox();
						if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
						{
							fscommand("AccountCmd", "CreateNewClicked" + "\2" + this._parent.serverId);
						}
					}
				}				
			}
		}
	}

	for( var i = 0; i < datas.length; i++ )
	{   
	    listView.addListItem(i, false, false);
	}
}

function HideCreateNewPop()
{
	var listView = g_MainUI.content_1.content.content_list;
	listView.clearListBox();
	g_MainUI.content_1._visible = false;
}

function ShowOtherAccountPop(types, isShowGuest)
{
	g_MainUI.login_types._visible = true;
	g_MainUI.login_types.gotoAndStop(types);
	g_MainUI.login_types.condition3.btn_guestAccount._visible = isShowGuest;
	g_MainUI.login_types.condition3.OnMoveInOver = function()
	{
		this.btn_facebook.onRelease = function()
		{
			fscommand("AccountCmd", "facebook");
		}
		this.btn_HA.onRelease = function()
		{
			fscommand("AccountCmd", "historyAccount");
		}
		this.btn_GC.onRelease = function()
		{
			fscommand("AccountCmd", "gamecenterAccount");
		}
		if(this.btn_guestAccount._visible)
		{
			this.btn_guestAccount.onRelease = function()
			{
				fscommand("AccountCmd", "guestAccount");
			}
		}
	}

	g_MainUI.login_bg_all.onRelease = function()
	{
		HideOtherAccountPop();
		fscommand("AccountCmd", "OnOtherAccountBack")
	}

	g_MainUI.login_types.condition3.gotoAndPlay("opening_ani");
}

function HideOtherAccountPop()
{
	g_MainUI.login_bg_all.onRelease = function()
	{
	}
	g_MainUI.login_types.condition3.gotoAndStop(1);
	g_MainUI.login_types._visible = false;
}

function ShowBindedResultPop(isSucess, titleTxt, playerName, playerIcon, fbName)
{
	g_IsBindSucess = isSucess;
	g_BindResultUI._visible = true;
	g_BindResultUI.btn_bg.onRelease = function()
	{

	}
	g_BindResultUI.pop_break.gotoAndPlay("opening_ani");
	g_BindResultUI.pop_break.content.link.gotoAndStop(isSucess ? 2 : 1);
	g_BindResultUI.pop_break.content.txt_title.text = titleTxt;
	g_BindResultUI.pop_break.content.player_icon.txt_name.text = playerName;
	g_BindResultUI.pop_break.content.fb_icon.txt_name.text = fbName;

	if(g_BindResultUI.pop_break.content.player_icon.player_icon.icons == undefined)
	{
		var head_width = g_BindResultUI.pop_break.content.player_icon.player_icon._width
		var head_height = g_BindResultUI.pop_break.content.player_icon.player_icon._height
		head_icon = g_BindResultUI.pop_break.content.player_icon.player_icon.loadMovie("CommonPlayerIcons.swf");
		g_BindResultUI.pop_break.content.player_icon.player_icon._width = head_width
		g_BindResultUI.pop_break.content.player_icon.player_icon._height = head_height
	}
	g_BindResultUI.pop_break.content.player_icon.player_icon.IconData = playerIcon;
	if (g_BindResultUI.pop_break.content.player_icon.player_icon.UpdateIcon) 
	{
		g_BindResultUI.pop_break.content.player_icon.player_icon.UpdateIcon()
	}
	if(isSucess)
	{
		g_BindResultUI.pop_break.content.btn_confirm._visible = true;
		g_BindResultUI.pop_break.content.btn_confirm.onRelease = function()
		{
			fscommand("AccountCmd", "BindResultConfirmed" + "\2" + "sucess");
		}
		g_BindResultUI.pop_break.content.btn_login._visible = false;
		g_BindResultUI.pop_break.content.btn_cancer._visible = false;
		g_BindResultUI.pop_break.content.btn_login.onRelease = undefined;
		g_BindResultUI.pop_break.content.btn_cancer.onRelease = undefined;
	}
	else
	{
		g_BindResultUI.pop_break.content.btn_confirm._visible = false;
		g_BindResultUI.pop_break.content.btn_confirm.onRelease = undefined;
		g_BindResultUI.pop_break.content.btn_login._visible = true;
		g_BindResultUI.pop_break.content.btn_cancer._visible = true;
		g_BindResultUI.pop_break.content.btn_login.onRelease = function()
		{
			fscommand("AccountCmd", "BindResultConfirmed" + "\2" + "login");
		}
		g_BindResultUI.pop_break.content.btn_cancer.onRelease = function()
		{
			fscommand("AccountCmd", "BindResultConfirmed" + "\2" + "cancel");
		}
	}
}

function HideBindedResultPop()
{
	g_BindResultUI.btn_bg.onRelease = undefined;
	g_BindResultUI._visible = false;
}

function ShowBindAfterLogoutPop(now, isNotice)
{
	g_MainUI._visible = true;
	if(now)
	{
		g_MainUI.login_bg_all.gotoAndStop("moved_in");
	}
	else
	{
		g_MainUI.login_bg_all.gotoAndPlay("opening_ani");
	}
	g_MainUI.login_bg_all.onRelease = function()
	{
		//do nothing
	}

	if(isNotice)
	{
		g_LoginPopUI.btn_shield.onRelease = function()
		{
			HideBindAfterLogoutPop();
			fscommand("AccountCmd", "OnUIClosed");
		}
	}
	else
	{
		g_LoginPopUI.btn_shield.onRelease = function()
		{
			//do nothing
		}
	}

	g_LoginPopUI._visible = true;
	g_LoginPopUI.gotoAndPlay("opening_ani");
	g_LoginPopUI.btn_ok.onRelease = function()
	{
		fscommand("AccountCmd", "facebook");
	}
	if(isNotice)
	{
		g_LoginPopUI.btn_otherAccount.onRelease = function()
		{
			HideBindAfterLogoutPop();
			fscommand("AccountCmd", "otherAccount" + "\2" + "bindNotice");
		}
	}
	else
	{
		g_LoginPopUI.btn_otherAccount.onRelease = function()
		{
			HideBindAfterLogoutPop();
			fscommand("AccountCmd", "otherAccount" + "\2" + "bindAfterLogout");
		}
	}
	g_LoginPopUI.btn_fb_s.onRelease = function()
	{
		fscommand("OnContactCmd", "facebook");
	}
	g_LoginPopUI.btn_mail.onRelease = function()
	{
		fscommand("OnContactCmd", "contact");
	}
	g_LoginPopUI.btn_home.onRelease = function()
	{
		fscommand("OnContactCmd", "forum");
	}
}

function HideBindAfterLogoutPop()
{
	g_LoginPopUI.btn_ok.onRelease = undefined;
	g_LoginPopUI.btn_otherAccount.onRelease = undefined;
	g_LoginPopUI.btn_fb_s.onRelease = undefined;
	g_LoginPopUI.btn_mail.onRelease = undefined;
	g_LoginPopUI.btn_home.onRelease = undefined;
	g_LoginPopUI.btn_shield.onRelease = undefined;
	g_LoginPopUI._visible = false;
}

function ShowLoginShowExistPop(now)
{
	g_MainUI._visible = true;
	if(now)
	{
		g_MainUI.login_bg_all.gotoAndStop("moved_in");
	}
	else
	{
		g_MainUI.login_bg_all.gotoAndPlay("opening_ani");
	}
	g_MainUI.login_bg_all.onRelease = function()
	{
	}

	g_LoginPopUI._visible = true;
	if(now)
	{
		g_LoginPopUI.gotoAndStop("moved_in");
	}
	else
	{
		g_LoginPopUI.gotoAndPlay("opening_ani");
	}
	g_LoginPopUI.btn_ok.onRelease = function()
	{
		fscommand("AccountCmd", "facebook");
	}
	g_LoginPopUI.btn_otherAccount.onRelease = function()
	{
		HideLoginShowExistPop();
		fscommand("AccountCmd", "otherAccount" + "\2" + "loginShowExist");
	}
	g_LoginPopUI.btn_fb_s.onRelease = function()
	{
		fscommand("OnContactCmd", "facebook");
	}
	g_LoginPopUI.btn_mail.onRelease = function()
	{
		fscommand("OnContactCmd", "contact");
	}
	g_LoginPopUI.btn_home.onRelease = function()
	{
		fscommand("OnContactCmd", "forum");
	}
	g_LoginPopUI.btn_shield.onRelease = function()
	{
		HideLoginShowExistPop(true);
	}
}

function HideLoginShowExistPop(hideAll)
{
	g_LoginPopUI.btn_ok.onRelease = undefined;
	g_LoginPopUI.btn_otherAccount.onRelease = undefined;
	g_LoginPopUI.btn_fb_s.onRelease = undefined;
	g_LoginPopUI.btn_mail.onRelease = undefined;
	g_LoginPopUI.btn_home.onRelease = undefined;
	g_LoginPopUI.btn_shield.onRelease = undefined;
	g_LoginPopUI._visible = false;
	if(hideAll)
	{
		g_MainUI.login_bg_all.onRelease = undefined;
		g_MainUI._visible = false;
	}
}