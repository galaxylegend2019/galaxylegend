var ui_all=_root.ui_all
var button_items=ui_all.button_items
var bottom_content=button_items.bottom_content
var playList:Array=new Array(ui_all.npcInfo,ui_all.button_items,ui_all.hero_attr)

var heroDatas=undefined

this.onLoad=function()
{
	_root._visible=false

	ui_all.heroAni._visible=false

	ui_all.heroPic.hero_left._visible=false
	ui_all.heroPic.hero_right._visible=false
}


function InitHeroData(inputHeroData:Array)
{
	heroDatas=inputHeroData
	SetHeroData()
}

function SetHeroData()
{
	var heroInfo=ui_all.hero_attr
	var temp:Array=new Array("left_","right_")

	for(var i=0;i<2;i++)
	{
		var star=heroDatas.star+i;
		var ahead=temp[i];
		var starBoard=heroInfo[ahead+"stars"]
		starBoard.heroName.text=heroDatas.heroName

		for(var j=1;j<=5;j++)
		{
			starBoard["star"+j]._visible=star>=j
		}
	}

	ui_all.button_items.bottom_content.cur.text=heroDatas.curStarExp
	ui_all.button_items.bottom_content.next.text=heroDatas.nextStarExp

	var processNum=(heroDatas.curStarExp/heroDatas.nextStarExp)*100
	if(processNum<=1)
	{
		processNum=2
	}
	bottom_content.processBar.gotoAndStop(processNum);
}

ui_all.button_items.btn_close.onRelease=function()
{
	move_out();
}

bottom_content.btn_get.onRelease=function()
{
}

bottom_content.btn_evolution.onRelease=function()
{
	//fscommand("HeroStarUpgrade")
	fscommand("HeroCommand","HeroStarUpgrade")
}
function PlayStarUpgradeAni()
{
	ui_all.heroAni._visible=true
	ui_all.heroAni.gotoAndPlay("opening_ani");

	ui_all.heroAni.onRelease=function()
	{
	}

	ui_all.heroAni.OnMoveOutOver=function()
	{
		ui_all.heroAni.OnMoveOutOver=undefined
		ui_all.heroAni.onRelease=undefined
		this._visible=false
	}
}

function move_in()
{
	for(var i=0;i<playList.length;i++)
	{
		playList[i].gotoAndPlay("opening_ani")
	}
}
function move_out()
{
	for(var i=0;i<playList.length;i++)
	{
		playList[i].gotoAndPlay("closing_ani")
	}

	ui_all.button_items.OnMoveOutOver=function()
	{
		_root._visible=false
		fscommand("ExitBack")
		this.OnMoveOutOver=undefined
	}
}

function setUIPlay()
{
	_root._visible=true
	move_in();

	//fscommand("SwitchHeroModel","heroUpgrade")
}
