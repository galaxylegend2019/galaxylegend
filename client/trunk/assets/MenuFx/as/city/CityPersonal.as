
var HeadInfo 			= undefined;
var PlayerContent 		= undefined;
var CreditBtn 			= undefined;
var EnergyBtn 			= undefined;
var MoneyBtn 			= undefined;
var PrestigePointBtn	= undefined;
var MailBtn 			= undefined;

var PlayerNameTxt 		= undefined;
var PlayerLevelTxt 		= undefined;
var PlayerVipLevelTxt 	= undefined;
var PlayerProgressBar 	= undefined;
var PlayerProgressTxt 	= undefined;

var CloseBtn 			= undefined;



var UIData

this.onLoad = function()
{
	//_root._visible = false;
	fscommand('UnlockInput');
}


function MoveIn()
{

}

function MoveOut()
{

}

function UpdateMailState(mail_count)
{
	if (mail_count > 0)
	{
		MailBtn.no_mail._visible 	= false;
		MailBtn.light._visible 		= true;
		MailBtn.mail_icon._visible 	= true;
	}else
	{
		MailBtn.no_mail._visible 	= true;
		MailBtn.light._visible 		= false;
		MailBtn.mail_icon._visible 	= false;
		MailBtn.red_point._visible 	= false;
	}
}

function UpdateUnread(datas)
{
	MailBtn.red_point._visible = datas.isMailUnread;
}

function SetDefalutShow()
{
	
	HeadInfo 		= _root.main_ui.head_info;
	PlayerContent 	= HeadInfo.player_content;
	CreditBtn 		= HeadInfo.credit;
	EnergyBtn 		= HeadInfo.energy;
	MoneyBtn 		= HeadInfo.money;
	PrestigePointBtn = HeadInfo.prestige_point;
	MailBtn 		= HeadInfo.mail_btn;

	PlayerNameTxt 		= PlayerContent.player_name;
	PlayerLevelTxt 		= PlayerContent.player_level;
	PlayerVipLevelTxt 	= PlayerContent.TxtVip.next_level;
	PlayerProgressBar 	= HeadInfo.progress_bar;
	PlayerProgressTxt 	= HeadInfo.progress_bar.progress_txt;

	CloseBtn 			= HeadInfo.btn_close;

	PlayerNameTxt.text 	= "";
	PlayerLevelTxt.text = "";
	PlayerVipLevelTxt.text = "";
	PlayerProgressBar.gotoAndStop(2);
	PlayerProgressTxt.text = "";
	CreditBtn.TxtNum.text = "";
	EnergyBtn.mc.TxtNum.text = "";
	MoneyBtn.TxtNum.text = "";
	//PrestigePointBtn.TxtNum.text = "100";
	MailBtn.red_point._visible 	= false;
	UpdateMailState(0);

	HeadInfo.OnMoveInOver = function()
	{
		MoveIn();
	}

	MoneyBtn.onRelease=function()
	{
		fscommand("GoToNext", "Affair");
	}

	CreditBtn.onRelease=function()
	{
		fscommand("GoToNext", "Purchase");
	}

	EnergyBtn.onRelease=function()
	{
		fscommand("GoToNext", "Affair");
	}

	PrestigePointBtn.onRelease = function()
	{
		
	}

	MailBtn.onRelease = function()
	{
		fscommand("PlayerInfoCommand", "Mail")
	}

	if (CloseBtn != undefined)
	{
		CloseBtn.onRelease = function()
		{
			BackToCabin();
		}
	}
}

//fte call
function BackToCabin()
{
	fscommand("MapCommand","btnClose");
}

function SetShowType(type)
{
	_root._visible = true;
	if (type == "MainUI")
	{
		//PrestigePointBtn._visible = true;
		_root.main_ui.gotoAndStop(1);
	}else if (type == "WorldMap")
	{
		//PrestigePointBtn._visible = true;
		_root.main_ui.gotoAndStop(2);

	}
	SetDefalutShow();
	HeadInfo.ruins._visible = false;
	OpenUI();
}

function OpenUI()
{
	HeadInfo.gotoAndPlay("opening_ani");
	//HeadInfo.gotoAndPlay(3);
}

function CloseUI()
{
	HeadInfo.gotoAndPlay("closing_ani");
}

function SetData(obj)
{
	UIData=obj
	SetPlayerData()
}

function SetPlayerData()
{
	PlayerNameTxt.text 	= UIData.playerName;
    PlayerLevelTxt.text = UIData.playerLevel;
    PlayerLevelTxt._x = PlayerContent.LC_UI_PLAYER_LV_CHAR._x + PlayerContent.LC_UI_PLAYER_LV_CHAR.textWidth;
	if (UIData.vipLevel == undefined)
	{
		PlayerContent.TxtVip._visible = false;
	}else
	{
		PlayerContent.TxtVip._visible = true;
		if (UIData.vipLevel<10) {
			PlayerVipLevelTxt.num.gotoAndStop(1);
			PlayerVipLevelTxt.num.num0.gotoAndStop(UIData.vipLevel+1);
		} else {
			PlayerVipLevelTxt.num.gotoAndStop(2);
			PlayerVipLevelTxt.num.num0.gotoAndStop( Math.floor(UIData.vipLevel/10) + 1);
			PlayerVipLevelTxt.num.num1.gotoAndStop( (UIData.vipLevel%10) + 1);
		}
	}
	

	SetProgressBar(UIData.expProgress);

	SetPlayerHead(UIData.playerIcon);

	PlayerContent.red_point._visible = UIData.isRedPoint;
}

function SetProgressBar( progress_value )
{
	PlayerProgressBar.gotoAndStop(progress_value + 2);
	PlayerProgressTxt.text = progress_value + "%";
}

function SetPlayerHead(playerIcon)
{	
	trace("--------------playerIcon=" + playerIcon.icon_index)
	var head_width=PlayerContent.user_head._width
	var head_height=PlayerContent.user_head._height
	var head_icon
	if(PlayerContent.user_head.icons == undefined)
	{
		head_icon = PlayerContent.user_head.loadMovie("CommonPlayerIcons.swf");
		head_icon._width = head_width
		head_icon._height = head_height
	}

	PlayerContent.user_head.IconData = playerIcon;
	if (PlayerContent.user_head.UpdateIcon)
	{
		PlayerContent.user_head.UpdateIcon()
	}
	PlayerContent.user_head.onRelease=function()
	{
		fscommand("PlayerInfoCommand","RoleInfo")
	}
}

//--------------------------------------------for update money info------------------------
function SetMoneyData(obj)
{
	CreditBtn.TxtNum.text 	= obj.credit;
	//EnergyBtn.TxtNum.text 	= obj.energy;
	MoneyBtn.TxtNum.text = obj.money;
	

}

function SetPointData(obj)
{
	EnergyBtn.mc.TxtNum.text = obj;

	var arrayNum = obj.split("/");
	var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
	ratio = Math.min(100, Math.max(1, ratio))
	EnergyBtn.mc.gotoAndStop(ratio)
	//trace("SetPointData "+ratio+" "+Number(arrayNum[0])+" "+arrayNum[0]+" "+obj)
}


//EnergyBtn 		= _root.main_ui.head_info.energy;
//SetPointData("143/293")

function SetPrestigePoint(num)
{
	PrestigePointBtn.TxtNum.text = num;
}


function SetTimeData(str_time)
{
	HeadInfo.time.time_txt.text = str_time;
}

//--------------------------------------for play ui animation----------------------
// function SetUIPlay(flag)
// {
// 	if(flag==true)
// 	{
// 		_root._visible=true
// 	}else
// 	{
// 		_root._visible=false
// 	}
// }



