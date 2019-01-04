//for the cabin top show

var head_info=_root.info.head_info.player_content
var money_info=_root.info.money_info
var UIData
this.onLoad = function()
{
}

function SetData(obj)
{
	UIData=obj
	SetPlayerData()
}

function SetPlayerData()
{
	head_info.player_name.text 			=			UIData.playerName
	head_info.player_level.text 				=			UIData.playerLevel
	head_info.vip_level.text 				=			UIData.vipLevel

	if(UIData.expProgress<2)
	{
		UIData.expProgress=2
	}
	_root.info.head_info.progress_bar.gotoAndStop(UIData.expProgress)

	SetPlayerHead(UIData.playerIcon)
}

function SetPlayerHead(playerIcon)
{
	var user_head=head_info.user_head
	var head_width=user_head._width
	var head_height=user_head._height
	var head_icon
	if(head_info.user_head.icons == undefined)
	{
		head_icon=head_info.user_head.loadMovie("CommonPlayerIcons.swf");
		head_icon._width=head_width
		head_icon._height=head_height
	}

	head_info.user_head.IconData = playerIcon;
	if (head_info.user_head.UpdateIcon) 
	{
		head_info.user_head.UpdateIcon()
	}

}

//--------------------------------------------for update money info------------------------
function SetMoneyData(obj)
{
	money_info.count.money_text.text=obj.money
	//money_info.count.energy_text.text=obj.energy
	money_info.count.credit_text.text=obj.credit
}

function SetPointData(obj)
{
	money_info.count.energy_text.text=obj
}

_root.btn_head.onRelease=function()
{
	fscommand("CabinCommand","RoleInfo")
}

_root.info.btn_world_map.onRelease=function()
{
	fscommand("CabinCommand","WorldMap")
}

money_info.btn_money.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

money_info.btn_credit.onRelease=function()
{
	fscommand("GoToNext", "Purchase");
}

money_info.btn_energy.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

_root.info.btn_contact.onRelease = function()
{
	fscommand("CabinCommand","ContactUS")
}

function SetTimeData(curTime)
{
	_root.info.time.time_text.time_text.text=curTime
}

//--------------------------------------for play ui animation----------------------
function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
	}else
	{
		_root._visible=false
	}
}



