//for the cabin top show
var UIData
var ui_all=_root.player_info
var user=ui_all.info
//var mc_input_name=user.user_info.input_name
var mc_input_name=_root.name_popup.input_text
var MAX_PAGE_COUNT=10
var lastPortrait
var listIndex=0
var listCount
var lastPoint
var g_isAccountEnabled = false;
var g_isAccountRedpoint = false;

function preLoad()
{
	for(var i=0;i<2;i++)
	{
		for(j=0;j<5;j++)
		{
			var mc_item=user.user_portrait["list_"+(i+1)]["item_"+(j+1)]
			mc_item.item_icon.loadMovie("CommonPlayerIcons.swf");
		}
	}
}

this.onLoad = function()
{
	preLoad()
	_root.name_popup._visible=false

	ui_all.btn_bg.onRelease=function()
	{		

	}
	ui_all.btn_close.onRelease=function()
	{
		SetUIPlay(false)
	}

	ui_all.bg_shield.onRelease = function()
	{

	}

	_root.name_popup.bg_shield.onRelease = function()
	{
		
    }

    _root.player_info.info.user_info.btn_contactus.onRelease = function()
    {
        fscommand("RoleCommand","ShowContastUs")
    }

	SetData()

}

function SetAccountEnabled(isEnabled, isRedpoint)
{
	g_isAccountEnabled = isEnabled;
	g_isAccountRedpoint = isRedpoint;
}

function SetData(obj)
{
	listIndex=0
	UIData=obj
	ShowUserInfo()
	//SetPlayerData()
}

function SetPlayerData()
{
	//head_info.player_name.text 			=			UIData.playerName
	//head_info.player_level.text 				=			UIData.playerLevel
	//head_info.vip_level.text 				=			UIData.vipLevel

	//_root.info.head_info.progress_bar.gotoAndStop(UIData.expProgress)

	//SetPlayerHead(UIData.playerIcon)
}

function ShowUserInfo()
{
	user.user_info._visible=true
	user.gotoAndPlay("open_info")
	user.OnMoveOver=function()
	{
		user.user_portrait._visible=false
	}
	InitText()
	SetUserInfo()
	SetUserInfoButton()

	ui_all.btn_bg.onRelease=function()
	{		
		SetUIPlay(false)
	}
}
function SetUserInfo()
{
	var mc_info=user.user_info

	var UserData=UIData.UserData
	// mc_info.portrait_info.vip_text.text=UserData.vipLevel

	LoadPortrait(mc_info.portrait_info.portrait,UserData.userIconData)

	if(UserData.expProgress<2)
	{
		UserData.expProgress=2
	}
	mc_info.exp_process.gotoAndStop(UserData.expProgress)

	// mc_info.user_level.text=UserData.userLevel
	// mc_info.hero_max_level.text=UserData.heroMaxLevel
	// mc_info.user_id.text=UserData.userID
	mc_info.team_level.htmlText=UserData.teamLevel
	mc_info.team_exp.htmlText=UserData.teamExp
	mc_info.mech_level.htmlText=UserData.mechLevel
	mc_info.version.htmlText=UserData.versionTxt
	mc_info.player_name.text=UserData.userName
	mc_info.btn_vip.txt_vip.text = UserData.vipLevel

	//mc_input_name.init("TextView", "FlashCreateUserUI", "hitzone", "", "content_text", true, false, UserData.userName, null, null, null, null, true);
	mc_input_name.init("UIKeyboardTypeDefault", "FlashCreateUserUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, true);
	mc_input_name.setMaxLength(8);
}

function InitText()
{	
	mc_input_name.init("UIKeyboardTypeDefault", "FlashCreateUserUI", "hitzone", "", "content_text", false, false, 'receiveName',null, null, null, null, true);
	//mc_input_name.init("TextView", "FlashCreateUserUI", "hitzone", "", "content_text", true, false, 'receiveName', null, null, null, null, true);
	mc_input_name.setMaxLength(8);
}

function PopupNameChange()
{
	_root.name_popup._visible=true
	_root.name_popup.gotoAndPlay("opening_ani")

	_root.name_popup.btn_yes.onRelease=function()
	{
		var newName=mc_input_name.getInputString()
		fscommand("RoleCommand","ChangeUserName"+'\2'+newName)
	}
	// _root.name_popup.btn_close.onRelease=function()
	_root.name_popup.btn_bg.onRelease=function()
	{
		_root.name_popup.gotoAndPlay("closing_ani")
		_root.name_popup.OnMoveOutOver=function()
		{
			_root.name_popup._visible=false
		}
	}

}

function SetUserInfoButton()
{
	var mc_info=user.user_info
	mc_info.btn_change_portrait.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		ShowPortraits()
	}
	mc_info.btn_change_name.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		PopupNameChange()
	}
	mc_info.btn_vip.onRelease = function()
	{
		fscommand("RoleCommand","ShowVipDetail");
	}
	//there is no function
	// mc_info.btn_user_bind.gotoAndStop("disabled")
	if(g_isAccountEnabled)
	{
		mc_info.btn_account_gray._visible = false;
		mc_info.btn_account._visible = true;
		mc_info.btn_account.onRelease = function()
		{
			fscommand("RoleCommand", "ShowAccountDetail");
		}
		mc_info.btn_account.red_point._visible = g_isAccountRedpoint;
	}
	else
	{
		mc_info.btn_account_gray._visible = true;
		mc_info.btn_account._visible = false;
		mc_info.btn_account.red_point._visible = false;
	}
}


function ShowPortraits()
{
	user.user_portrait._visible=true
	user.gotoAndPlay("open_portrait")
	user.OnMoveOver=function()
	{
		user.user_info._visible=false
	}

	//var PortraitData=UIData.PortraitData
	SetPortrait()
	SetPortraitButton()
	InitPortraitList()

	ui_all.btn_bg.onRelease=function()
	{		
		
	}
}
function SetPortrait()
{
	var PortraitData=UIData.PortraitData
	listCount=math.ceil(PortraitData.length/MAX_PAGE_COUNT)
}

function SetPortraitButton()
{
	user.user_portrait.btn_ok.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_1")
		//ShowUserInfo()
		//send message to lua
		var newPortrait=lastPortrait.itemData.portraitName
		fscommand("RoleCommand","ModifyPortrait"+'\2'+newPortrait)
	}

	user.user_portrait.btn_return.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_cancel")
		ShowUserInfo()
	}

	user.user_portrait.chapter_arrow.last_arrow.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		listIndex--;
		InitPortraitList()
	}
	user.user_portrait.chapter_arrow.next_arrow.onRelease=function()
	{
		fscommand("PlaySound","sfx_ui_selection_2")
		listIndex++;
		InitPortraitList()
	}	
}

function InitPortraitList()
{
	if(listIndex<0)
	{
		listIndex=0
	}else if(listIndex>=listCount)
	{
		listIndex=listCount-1;
	}

	if(lastPoint)
	{
		lastPoint.gotoAndStop(1)
	}
	lastPoint=user.user_portrait.flips["flip_"+listIndex]
	lastPoint.gotoAndStop(2)

	var PortraitData=UIData.PortraitData
	//var pageCount=Math.ceil(PortraitData/MAX_PAGE_COUNT)
	user.user_portrait.flips["flip_2"]._visible=false

	for(var i=0;i<2;i++)
	{
		for(j=0;j<5;j++)
		{
			
			var dataIndex=i*5+j+listIndex*MAX_PAGE_COUNT
			var itemData=PortraitData[dataIndex]
			var mc_item=user.user_portrait["list_"+(i+1)]["item_"+(j+1)]
			mc_item.itemData=itemData
			if(itemData)
			{	
				mc_item._visible=true
				mc_item.isSelect._visible=false
				LoadPortrait(mc_item.item_icon,itemData.IconData)
				mc_item.onRelease=function()
				{
					fscommand("PlaySound","sfx_ui_selection_3")
					if(lastPortrait)
					{
						lastPortrait.isSelect._visible=false
					}
					this.isSelect._visible=true
					lastPortrait=this
				}
				
			}else
			{
				mc_item._visible=false
			}

		}
	}
}


function LoadPortrait(mc,IconData)
{
	var head_width=mc._width
	var head_height=mc._height
	var head_icon

	if(mc.icons == undefined)
	{
		head_icon=mc.loadMovie("CommonPlayerIcons.swf");
		head_icon._width=head_width
		head_icon._height=head_height
	}

	mc.IconData = IconData;
	if (mc.UpdateIcon) 
	{
		mc.UpdateIcon()
	}
}
//--------------------------------------for play ui animation----------------------
function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		_root.name_popup._visible=false
		ui_all.gotoAndPlay("opening_ani")
	}else
	{
		ui_all.gotoAndPlay("closing_ani")
		ui_all.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("RoleCommand","Close")
		}
	}
}

function CloseUI()
{
	ui_all.gotoAndPlay("closing_ani")
	ui_all.OnMoveOutOver=function()
	{
		_root._visible=false
	}
}



