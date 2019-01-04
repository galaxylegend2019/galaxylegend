//for the cabin top show


var OpenBar 		= _root.OpenBar;

var HeroBtn 		= OpenBar.hero_btn;
var ItemBtn 		= OpenBar.item_btn;
var AllianceBtn 	= OpenBar.alliance_btn;
var StoreBtn 		= OpenBar.store_btn;
var ContactBtn 		= OpenBar.contact_us_btn;
var ChallengeBtn 	= OpenBar.challenge_btn;


var CurBar 			= undefined;
var BarCommand 		= undefined;

var MenuBarBtn 	= _root.OpenMenu.bar_btn;
var IsOpenBar 	= false;
var CurType 	= undefined;


this.onLoad = function()
{
	_root.OpenMap._visible = false;
	// AchievementBtn._visible = false;
	SetDefaultShow();
	InitUI();
	//_root._visible = false;
}


function SetDefaultShow()
{
	MenuBarBtn.close._visible = false;
	MenuBarBtn.open._visible = true;
	ShowUnread(MenuBarBtn, false);

	ShowUnread(HeroBtn, false);
	ShowUnread(AllianceBtn, false);
	ShowUnread(ItemBtn, false);
	ShowUnread(StoreBtn,false);
	ShowUnread(ContactBtn,false);
	ShowUnread(ChallengeBtn,false);
}

function InitUI()
{
	MenuBarBtn.onRelease = function()
	{
		SetBarBtnState();
	}

	HeroBtn.onRelease = function()
	{
		if (IsOpenBar)
		{
			fscommand(BarCommand,"Affair")
		}
	}
	ItemBtn.onRelease = function()
	{
		if (IsOpenBar)
		{
			fscommand(BarCommand,"Item")
		}
	}
	AllianceBtn.onRelease = function()
	{
		if (IsOpenBar)
		{
			fscommand(BarCommand,"Alliance")
		}
	}

	StoreBtn.onRelease = function()
	{
		if (IsOpenBar)
		{
			fscommand(BarCommand,"Store");
		}
	}
	ChallengeBtn.onRelease = function()
	{
		if (IsOpenBar)
		{
			fscommand(BarCommand,"Challenge");
		}
	}
	ContactBtn.onRelease = function()
	{
		if (IsOpenBar)
		{
			fscommand(BarCommand,"ContactUs");
		}
	}
}

function OpenUI()
{
	SetPlayShow(true);
}

function CloseUI()
{
	SetPlayShow(false);

}

function SetBarType(type)
{
	if (type == "MainUI")
	{
		WorldMap._visible = false;
		BarCommand = "CabinCommand";
	}if (type == "WorldMap")
	{
		WorldMap._visible = false;
		BarCommand = "MapCommand";
	}
	CurBar = OpenBar;
	OpenUI();
	CurType = type;
}

function SetBarBtnState()
{
	IsOpenBar = !IsOpenBar;
	if (IsOpenBar)
	{
		MenuBarBtn.close._visible = true;
		MenuBarBtn.open._visible = false;
		CurBar.gotoAndPlay("opening_ani");
		fscommand("CabinCommand","State\2Open");
	}else
	{
		MenuBarBtn.close._visible = false;
		MenuBarBtn.open._visible = true;
		CurBar.gotoAndPlay("closing_ani");
		fscommand("CabinCommand","State\2Close");
	}
}

function SetPlayShow( isShow )
{
	if (isShow)
	{
		MenuBarBtn.close._visible = false;
		MenuBarBtn.open._visible = true;
		IsOpenBar = false;
		_root.OpenMenu.gotoAndPlay("opening_ani");
		//_root._visible = true;
	}else
	{
		if (IsOpenBar)
		{
			CurBar.gotoAndPlay("closing_ani");
		}
		_root.OpenMenu.gotoAndPlay("closing_ani");
	}
}

function ShowUnread(mc,isShow)
{
	isShow = isShow == true;
	mc.red_point._visible = isShow;
}

function UpdateUnread(datas)
{
	var flag = false;
	flag = datas.isUnionUnread or datas.isItemUnread or datas.isAffairUnread or datas.isSetUnread or datas.isChallengeUnread;
	ShowUnread(MenuBarBtn,flag);
	//MainUI
	ShowUnread(SetingBtn,datas.isSetUnread);
	ShowUnread(AllianceBtn,datas.isUnionUnread);
	ShowUnread(ItemBtn,datas.isItemUnread);
	// ShowUnread(AchievementBtn,false);
	//WorldMapUI
	//ShowUnread(AllianceBtn2,datas.isUnionUnread);
	ShowUnread(ChallengeBtn,datas.isChallengeUnread);
	ShowUnread(HeroBtn, datas.isAffairUnread);
}

function FTEHideBar()
{
	if (IsOpenBar)
	{
		SetBarBtnState()
	}
}
function FTEClickChallenge()
{
	ChallengeBtn.onRelease()
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.barbtn._visible = false
	_root.fteanim.challenge._visible = false
}

FTEHideAnim()