import com.tap4fun.utils.Utils;

var ui_all=undefined
var BaseData=undefined
var mc_cur_page=undefined

this.onLoad=function()
{
	this._parent.bg._visible=false
}

function InitMC(mc)
{
	ui_all=mc

	ui_all.title.btn_close.onRelease=function()
	{
		mc_cur_page.gotoAndPlay("closing_ani")
		mc_cur_page.OnMoveOutOver=function()
		{
			fscommand("CityCommand","closeCollection")
			this._visible=false
			ui_all._parent.bg_UI._visible=false
			ui_all._parent.bg._visible=false

			ui_all._visible=false
		}
	}

	ui_all.upgrade._visible=false
	ui_all.collection._visible=false
	ui_all.info._visible=true

	ui_all._parent.bg._visible=true
	ui_all._parent.bg_UI._visible=true
	ui_all._parent.bg_UI.onRelease=function()
	{
		if(mc_cur_page!=undefined)
		{
			this.onRelease=undefined
			//mc_cur_page.btn_close.onRelease()
			ui_all.title.btn_close.onRelease()
		}
	}
}

function UpdateCollection(inputDetailData:Array)
{

}

function UpdateBuildingInfo(inputDetailData:Array)
{
	BaseData=inputDetailData
	UpdateBuildingResource(BaseData)
	UpdateBuildingPoint(BaseData)

	SetUpgradeData()
	SetCollectionData()
	SetDetailData()
}

function UpdateBuildingResource(inputData)
{
	ui_all.title.credit.credit_text.text=inputData.credit
	ui_all.title.money.money_text.text=inputData.money
}

function UpdateBuildingPoint(inputData)
{
	trace("UpdateBuildingPoint in building info")
	ui_all.title.energy.energy_text.text=inputData.energy
}

function SetUpgradeData()
{
	//upgrade
	//curLevel,nextLevel,curCollection,nextCollection,get button event(need credit)
	var mc=ui_all.upgrade
	var upgradeData=BaseData.upgradeData

	//upgrade_title.title.

	mc.level_left.level.text=upgradeData.curlevel
	mc.level_left.num.text=upgradeData.curCollectionValue


	mc.level_right.level.text=upgradeData.nextlevel
	mc.level_right.num.text=upgradeData.nextCollectionValue

	mc.btn_upgrade.num.text=upgradeData.needMoney
	mc.btn_upgrade.onRelease=function()
	{
		//this._parent.btn_close.onRelease()
		ui_all.title.btn_close.onRelease()
		fscommand("CityCommand","upgrade")
	}
}


function UpdateTime(timeStr)
{
	var board2=ui_all.collection.board2
	board2.reward_time.text=timeStr
}

function SetCollectionData()
{
	//collection
	//credit,money,collection number(like,1/12),rewardTime(like 00:12:12),add credit,get button event
	var mc=ui_all.collection
	var collectionData=BaseData.collectionData

	mc.board1.credit.text=collectionData.credit
	mc.board1.money.text=collectionData.money

	var board2=mc.board2
	
	board2.collection_num.text=collectionData.collectionNum
	board2.reward_time.text=collectionData.rewardTime
	board2.getMoney.text=collectionData.getMoney

	var btn_collect=undefined
	if(collectionData.isCreditCollection==true)
	{
		btn_collect=mc.btn_collect_1
		btn_collect.num.text=collectionData.needCredit

		mc.btn_collect._visible=false
	}else
	{
		btn_collect=mc.btn_collect
		mc.btn_collect_1._visible=false
	}

	btn_collect.onRelease=function()
	{
		//this.btn_close.onRelease()
		//ui_all.title.btn_close.onRelease()
		fscommand("CityCommand","collect")
	}
}

function SetDetailData()
{
	//describe text,collection value
	var mc=ui_all.info
	var infoData=BaseData.infoData

	mc.board1.num.text=infoData.collectionValue
	mc.board1.desc.text=infoData.desc
}

//pageType:detail,collection,upgrade
function ShowBuildingInfo(inputDetailData:Array)
{
	UpdateBuildingInfo(inputDetailData)

	ui_all.collection._visible=false
	ui_all.upgrade._visible=false
	ui_all.info._visible=false

	if(inputDetailData.showType==1)
	{
		//detail
		ui_all.title.title_type.title_type.gotoAndStop(1)
		RegisteEvent(ui_all.info)
	}else if(inputDetailData.showType==2)
	{
		//collection
		ui_all.title.title_type.title_type.gotoAndStop(2)
		RegisteEvent(ui_all.collection)
		fscommand("CityCommand","openCollection")

	}else if(inputDetailData.showType==3)
	{
		//upgrade
		ui_all.title.title_type.title_type.gotoAndStop(3)
		RegisteEvent(ui_all.upgrade)
	}
}

function RegisteEvent(mc)
{
	mc_cur_page=mc

	mc._visible=true
	mc.gotoAndPlay("opening_ani")

/*	mc.btn_close.onRelease=function()
	{
		this._parent.gotoAndPlay("closing_ani")
		this._parent.OnMoveOutOver=function()
		{
			fscommand("CityCommand","closeCollection")
			this._visible=false
			ui_all._parent.bg_UI._visible=false
			ui_all._parent.bg._visible=false

			ui_all._visible=false
		}
	}*/
}

function SetMCVisible()
{
	_root._visible=false
}

function SetUIPlay()
{
}
