var battleControl:MovieClip = _root.battleControl;
var curHeadStates:Array=new Array(0,0,0,0,0,0);
var lockStates:Array=new Array(0,0,0,0,0,0);

var heroObjects:Array=new Array()


var headControls:Array=new Array()
var deadTypes:Array=new Array()
var targetCount=6
var lockTargetWidth;
var lockTargetHeight;
var bloodNumberObj;

var bloodAllMC
var ItemAllMC=new Array()
var allMCs

var timeTest=0
var itemHideSpeed=5

var isNeedUpdate=false
var ItemNum=0

var UniqueIndex = 0

//------------------------------2015-08-13  19:44

//define a node array for store some node
var Nodes:Array=new Array()

//define a number pools (all blood num come from here ,and it can come back if it disable)
var BloodNumPools:Array=new Array()

// get unique id
function getUniqueName(preStr)
{
	return preStr + (UniqueIndex++).toString()
}

function SetOpinion(flag)
{
	battleControl.gameSet._visible=flag;
	battleControl.timeShow._visible=flag;
}

function LoadSomeSwf()
{
	battleControl.bloodBarBg.loadMovie("BattleNumber.swf")
}

//do something after ui load
function Init()
{
	_root.setting._visible=false
	//battleControl.btn_set._visible=false
	LoadSomeSwf()
	//preLoadMC()

	battleControl.battleTitle._visible=false

	battleControl._visible = false;
	battleControl.arrowShow._visible=false;
	SetOpinion(false)
	initTargetCount(targetCount)

	bloodAllMC=battleControl.bloodBarBg.all
}

this.onLoad=function()
{
	Init()
}

//--------------for setting-----------------
battleControl.btn_set.onRelease=function()
{
	var mc_setting=_root.setting
	mc_setting._visible=true
	mc_setting.gotoAndPlay("opening_ani")	

	mc_setting.page_cover._visible=true
	mc_setting.page_cover.onRelease=function()
	{
		this.onRelease=undefined
		this._visible=false
		this._parent.gotoAndPlay("closing_ani")
		this._parent.OnMoveOutOver=function()
		{
			this._visible=false
		}
	}
}

function addEvent()
{
	var mc_setting=_root.setting.pop_content

	mc_setting.btn_quit.onRelease=function()
	{

	}
}


//-----------add node for all mc(head ,bloodBar,blood num),this position is a standard
function AddPosNode(inputDatas:Array)
{
	var curIndex=Nodes.length
	for(var i=curIndex+1;i<=curIndex+inputDatas.length;i++)
	{
		var datas=inputDatas[i-1-curIndex]
		var obj=new Object()
		obj.nodeNames=datas.name
		obj.PosX=datas.x
		obj.PosY=datas.y
		obj.objIndex=i

		obj.bloodNums=new Array()
		Nodes.push(obj)
	}
}

//--------------remove a node (destroy all mc under the node)
function RemovePosNode()
{

}

//-------------get node by node name from nodeList
function GetNodeByName(nodeNames)
{
	for(var i=0;i<Nodes.length;i++)
	{
		if(Nodes[i].nodeNames==nodeNames)
		{
			return Nodes[i]
		}
	}
}

function GetNodeById(id)
{
	for(var i=0;i<Nodes.length;i++)
	{
		if(Nodes[i].mc.id==id)
		{
			return Nodes[i]
		}
	}
}

//------------update node pos ,and need update all mc under the node
function UpdatePosNode(inputDatas:Array)
{
	//trace("UpdatePosNode------------------")

	for(var i=0;i<inputDatas.length;i++)
	{
		var datas=inputDatas[i]

		var node=GetNodeByName(datas.name)
		node.PosX=datas.x
		node.PosY=datas.y

		UpdatePosMC(node)
	}
}

//------------get all mc under the node ,and uodate their pos
function UpdatePosMC(node)
{
	//-----------update mc's pos for head--------------
	node.mc._x=node.PosX
	node.mc._y=node.PosY

	//-----------update blood_num pos
	//var node.bloodNums.length
	for(var i=0;i<node.bloodNums.length;i++)
	{
		var numberMC=node.bloodNums[i]
		if(numberMC._visible==true)
		{
			numberMC._x=node.PosX
			numberMC._y=node.PosY
		}
	}
}

//-----------new a head mc
function NewHeadMc(nameIndex)
{
	var tempName="headControl"+nameIndex;

	if(battleControl.headBg[tempName]!=undefined)
	{
		return battleControl.headBg[tempName].hero_head
	}

	battleControl.headBg.attachMovie("aim_s1",tempName,battleControl.headBg.getNextHighestDepth(),{_x:0,_y:0})
	battleControl.headBg[tempName].loadMovie("BattleUI.swf")

	return battleControl.headBg[tempName].hero_head
}

//----------------init a head for a new interface---------------
function InitHeadEx(heroArray)
{
	for(var i=0;i<heroArray.length;i++)
	{
		var datas=heroArray[i]
		var node=GetNodeByName(datas.nodeName)

		//trace(datas.nodeName)
		node.mc=NewHeadMc(node.objIndex)
		//trace("InitHeadEx----------------------")


		var mc_head=node.mc
		mc_head.id=datas.id
		mc_head.headName=datas.headName
		mc_head.selfTeam=datas.selfTeam
		mc_head.showTime=100

		mc_head._x=node.PosX
		mc_head._y=node.PosY

		//-------------init event for mc click-------------------
		mc_head.heroIcon1.gotoAndStop(2)
/*		mc_head.onRelease=function()
		{
			fscommand("HeadClick",this.id)
		}*/

		mc_head.hit.onRelease=function()
		{
			if(this._parent._alpha==1)
			{
				return
			}
			fscommand("HeadClick",this._parent.id)
			//trace("as click ")
		}

/*		mc_head.heroIcon1.hero_normal.onRelease=function()
		{
			if(this._parent._parent._alpha==1)
			{
				return
			}
			this.gotoAndPlay(1)
			fscommand("HeadClick",this._parent._parent.id)
		}
		mc_head.heroIcon2.onRelease=function()
		{
			if(this._parent._alpha==1)
			{
				return
			}
			fscommand("HeadClick",this._parent.id)
		}*/
	}

	SetUIPlay()
}

//the mc play over ,and push it to pools
function closeFinish(mc,typeString)
{
	mc._visible=false
	var node=GetNodeByName(mc.nodeNames)
	node.bloodNums.splice(mc.mcIndex,1)

	BloodNumPools.push(mc)
}

function preLoadMC()
{
	var colorType=new Array("num_red_all","num_yellow_all","num_white_all","num_white_all","world_miss","world_block")

	for(var i=0;i<colorType.length;i++)
	{
		for(var j=0;j<5;j++)
		{

			var mclink=colorType[i]
			var tempName="BloodNum"+BloodNumPools.length

			bloodAllMC.attachMovie(mclink,tempName,bloodAllMC.getNextHighestDepth(),{_x:0,_y:0})
			bloodAllMC[tempName].bloodType=i+1
			bloodAllMC[tempName]._visible=false

			BloodNumPools.push(bloodAllMC[tempName])
		}
	}

}

//get mc from pools or new one
function getVisibleMC(mcType)
{
	// { dodge, crit, intercept, other, normal, cure }
	//var colorType=new Array("num_red_all","num_yellow_all","num_white_all","num_white_all","word_miss","word_block")
	var colorType=new Array("word_miss","num_yellow_all","word_block","num_white_all","num_red_all","num_green_all")


	for(var i=0;i<BloodNumPools.length;i++)
	{
		var mc=BloodNumPools[i]

		if(mcType==mc.bloodType && mc._visible==false)
		{
			BloodNumPools.splice(i,1)
			return mc
		}
	}

	var mclink=colorType[mcType-1]
	var tempName=getUniqueName("BloodNum")

	bloodAllMC.attachMovie(mclink,tempName,bloodAllMC.getNextHighestDepth(),{_x:0,_y:0})
	bloodAllMC[tempName].bloodType=mcType

	return bloodAllMC[tempName]
}

//-- return a direction and a random value
function getRandomDir(numRate)
{
	var randomValue=Math.random()

	if(randomValue>0.5)
	{
		return Math.floor(randomValue*numRate)
	}else
	{
		return Math.floor(-randomValue*numRate)
	}
}

//------get a visible mc and set attr
function loadAndShowNumber(obj)
{
	var bloodNum=(new Number(obj.blood)).toString()

	var bloodMC=getVisibleMC(obj.showType)
	var node=GetNodeByName(obj.nodeName)

	node.bloodNums.push(bloodMC)
	bloodMC.nodeNames=obj.nodeName
	bloodMC.mcIndex=node.bloodNums.length-1

	bloodMC._visible=true
	bloodMC.gotoAndPlay(1)
	bloodMC._x=Math.floor(node.PosX)//+getRandomDir(10)
	bloodMC._y=Math.floor(node.PosY) - 90//+getRandomDir(30)-60

	var strSize=bloodNum.length

	var numMC=bloodMC
	if(obj.showType==1)
	{
		return
	}else if(obj.showType==3)
	{
		numMC=bloodMC.num
	}

	for(var i=0;i<5;i++)
	{
		if (i>=strSize)
		{
			numMC["num"+(i+1)]._visible=false
		}else
		{
			numMC["num"+(i+1)]._visible=true
			var curIndex=new Number(bloodNum.charAt(i))
			numMC["num"+(i+1)].gotoAndStop(curIndex+1)
		}
	}
}

//--------extern interface to show blood num
function AddBloodBar(inputDatas:Array)
{
	for(var i=0;i<inputDatas.length;i++)
	{
		loadAndShowNumber(inputDatas[i])
	}
}

//---------------------for play effect----------------
function SetUIPlay()
{

	battleControl.gotoAndPlay(2);
	battleControl._visible = true;

	SetBackTimer()
}

//-----------set timer for hide head
function SetBackTimer()
{
	var timer:Number = getTimer();
	_root.onEnterFrame = function()
	{
	  if (getTimer() - timer >=1000) {
	        timer = getTimer();
	        onTime()
	  }
	}
}

//---------excute every frame
function onTime()
{
	for(var i=0;i<Nodes.length;i++)
	{
		var showTime=Nodes[i].mc.showTime
		if(showTime>0)
		{
			Nodes[i].mc.showTime=showTime-1
		}

		if(Nodes[i].mc.showTime==0)
		{
			Nodes[i].mc._alpha=1
		}else
		{
			Nodes[i].mc._alpha=100
		}
	}
}

//---------for set target-----------
function SetTargetPostion(lockTarget,x1,y1,scale1)
{
	lockTarget._x=x1
	lockTarget._y=y1
	var scaleRate=0.6
	if(scale1!=undefined)
	{
		//scaleRate=scale1;
	}
	lockTarget.gotoAndPlay(1)
}

function SetTarget(lockArray)
{
	var arrayIndex=0
	for(var i=1;i<=6;i++)
	{
		var lockTarget=eval("battleControl.lockTarget"+i);
		if(lockTarget._visible==false)
		{
			lockTarget._visible=true;
			var x1=lockArray[arrayIndex][0];
			var y1=lockArray[arrayIndex][1];
			//var scale1=lockArray[arrayIndex][2]
			SetTargetPostion(lockTarget,x1,y1)//,scale1)

			arrayIndex++;
			if(arrayIndex>=lockArray.length)
			{
				return;
			}
		}
	}
}

function initTargetCount(count)
{
	var lockTarget
	for(var i=1;i<=count;i++)
	{
		var tempName="lockTarget"+i;
		battleControl.attachMovie("shot",tempName,battleControl.getNextHighestDepth(),{_x:568,_y:320})

		lockTarget=battleControl["lockTarget"+i];
		lockTarget._visible=false;

		var scaleRate=0.6
		lockTarget._width=lockTarget._width*scaleRate;
		lockTarget._height=lockTarget._height*scaleRate;
	}
}

function lockFinish(mc)
{
	mc._visible=false
}


function GetMCById(id)
{
	for(var i=0;i<Nodes.length;i++)
	{
		if(Nodes[i].mc.id==id)
		{
			return Nodes[i].mc
		}
	}
}
//----------------------------for set round show----------

function SetRound(obj)
{
	battleControl.battleTitle._visible=true
	var curRound=obj.curRound
	var maxRound=obj.maxRound
	var battleRound=battleControl.battleTitle.battleRound;
	battleRound.testText.cur_round.text=curRound
	battleRound.testText.max_round.text=maxRound
	battleControl.battleTitle.gotoAndPlay(2);
}


function SetBloodEx(bloodArray)
{
	//SetBloodEx
	//{id="xxx",mp="xxx",hp="xxx",defense="xxx"}

	var bloodType:Array=new Array("hp","mp","defense")
	for(var i=1;i<=bloodArray.length;i++)
	{
		var id=bloodArray[i-1].id
		var mc=GetMCById(id)

		mc._alpha=100
		var showTime=bloodArray[i-1].showTime
		if(showTime!=undefined)
		{
			mc.showTime=showTime
		}
		mc.hp=Math.ceil(bloodArray[i-1].hp*9)
		mc.mp=Math.ceil(bloodArray[i-1].mp*5)
		mc.defense=Math.ceil(bloodArray[i-1].defense*9)

		for(var j=1;j<=3;j++)
		{
			var mcTemp=mc[bloodType[j-1]+"_bar"]
			//var mcTemp=headControls[j]["hp_bar"]
			var bloodNum=mc[bloodType[j-1]]
			mcTemp.gotoAndStop(bloodNum+1);
		}
	}
}

function KeepHead(mc)
{
	var mc1:MovieClip=mc._parent._parent;
	for(var i=0;i<Nodes.length;i++)
	{
		if(mc1==Nodes[i].mc or mc1._parent==Nodes[i].mc)
		{

			if(Nodes[i].mc.selfTeam==false)
			{
				mc._parent._parent._visible=false
			}
			mc.gotoAndStop("hero_"+Nodes[i].mc.headName);
		}
	}

}

function SetHeadStates(stateData)
{
	var id=stateData.id
	var mc=GetMCById(id)
	mc.gotoAndPlay(stateData.stateName)
}

/*
function SetUIVisible(flag)
{
	if(flag==true)
	{
		battleControl.gotoAndPlay("appear")
	}else
	{
		battleControl.gotoAndPlay("disappear")
	}
}

function SetArrowVisible(flag)
{
	battleControl.arrowShow._visible=flag;
}*/

battleControl.arrowShow.onRelease=function()
{
	fscommand("ArrowClick");
}


/*function SetPortraitVisible(showInfo)
{
	var id=showInfo.id
	var roleIndex=GetMCIndex(id)

	var alphaValue=100
	if(showInfo.showFlag==false)
	{
		alphaValue=1
	}
	headControls[roleIndex]._alpha=alphaValue
}*/


//----------------------------set for item show
function getVisibleItemMC()
{
	for(var i=0;i<ItemAllMC.length;i++)
	{
		if(ItemAllMC[i]._alpha<=0)
		{
			return ItemAllMC[i]
		}
	}
	var tempName="item"+ItemAllMC.length

	battleControl.itemBg.attachMovie("item_show",tempName,battleControl.itemBg.getNextHighestDepth(),{_x:0,_y:0})
	battleControl.itemBg[tempName].loadMovie("CommonIcons.swf")

	ItemAllMC.push(battleControl.itemBg[tempName])
	return battleControl.itemBg[tempName]

}

function loadAndShowItem(obj)
{
	var curMC=getVisibleItemMC()
	curMC._alpha=100

	curMC._x=obj.x//+getRandomDir(100)
	curMC._y=obj.y//+getRandomDir(60)

	curMC._height=70
	curMC._width=70
	curMC.IconData=obj.iconData
	if(curMC.UpdateIcon) 
	{
		curMC.UpdateIcon(); 
	}

	//curMC.icons.icons.gotoAndStop("item_"+obj.id)

	isNeedUpdate=true

	updatePosAndAlpha()
}

function updatePosAndAlpha()
{
	_root.onEnterFrame=function()
	{
		var needCount=0
		for(var i=0;i<ItemAllMC.length;i++)
		{

			if(ItemAllMC[i]._alpha>=0)
			{
				ItemAllMC[i]._alpha=ItemAllMC[i]._alpha-itemHideSpeed
				ItemAllMC[i]._y=ItemAllMC[i]._y-itemHideSpeed
				needCount++
			}
		}

		if(needCount==0)
		{
			isNeedUpdate=false
		}
		if(isNeedUpdate==false)
		{
			_root.onEnterFrame=undefined
		}
	}
}

function AddItemDrop(itemArray)
{
	for(var i=0;i<itemArray.length;i++)
	{
		loadAndShowItem(itemArray[i])
	}
	ItemNum=ItemNum+itemArray.length
	battleControl.pick.pick.item_num.text="x"+ItemNum
	battleControl.pick.gotoAndPlay(2)
}

/*function SetRoundTime()
{
		var timer:Number = getTimer();
	_root.onEnterFrame = function()
	{
	  if (getTimer() - timer >=1000) {
	        timer = getTimer();
	        onTime()
	  }
	}
}*/

function SetCombatClock(isShow,timeSecond)
{
	if(isShow==true)
	{
		battleControl.timeShow._visible=true;
		battleControl.timeShow.time_text.time_text.text=timeSecond
		battleControl.timeShow.gotoAndPlay("opening_ani")
	}else
	{
		battleControl.timeShow.gotoAndPlay("closing_ani")
		battleControl.timeShow.onMoveOutOver=function()
		{
			this._visible=false
		}
	}
}
