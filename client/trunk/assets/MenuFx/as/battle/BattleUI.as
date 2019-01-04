

var battleControl:MovieClip = _root.battleControl;
var curHeadStates:Array=new Array(0,0,0,0,0,0);
var lockStates:Array=new Array(0,0,0,0,0,0);

var heroObjects:Array=new Array()

var bloodStates:Array=[
	[8,15,20],
	[8,15,20],
	[8,15,20],
	[8,15,20],
	[8,15,20],
	[8,15,20]
	];

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


this.onLoad = function()
{
	InitFlash();
}

function InitFlash()
{
	LoadSomeSwf()

	battleControl._visible = false;
	battleControl.arrowShow._visible=false;
	SetOpinion(false)
	initTargetCount(targetCount)

	bloodAllMC=battleControl.bloodBarBg.all

	allMCs=new Array()
	for(var i=1;i<=5;i++)
	{
		allMCs[i]=new Array()
	}

	var mc_setting=_root.setting
	mc_setting._visible=false
}


//--------------for setting-----------------
battleControl.btn_set.onRelease=function()
{
	trace("btn_set click")
	var mc_setting=_root.setting
	mc_setting._visible=true
	mc_setting.gotoAndPlay("opening_ani")	

	mc_setting.page_cover._visible=true
	mc_setting.page_cover.onRelease=function()
	{
		trace("---------------page_cover-------")
		this.onRelease=undefined
		this._visible=false
		this._parent.gotoAndPlay("closing_ani")
		this._parent.OnMoveOutOver=function()
		{
			this._visible=false
		}
	}
}



//load swf for use
function LoadSomeSwf()
{
	battleControl.bloodBarBg.loadMovie("BattleNumber.swf")
}

function SetOpinion(flag)
{
	battleControl.gameSet._visible=flag;
	battleControl.timeShow._visible=flag;
}

//just hide the big portrait and play
function SetUIPlay()
{

	battleControl.gotoAndPlay(2);
	battleControl._visible = true;

	SetBackTimer()
}

function InitHeadEx(heroArray)
{
	var curObjectIndex=heroObjects.length
	for(var i=curObjectIndex+1;i<=curObjectIndex+heroArray.length;i++)
	{
		heroObjects[i]=new Object()
		heroObjects[i].id=heroArray[i-1-curObjectIndex].id;
		heroObjects[i].heroName=heroArray[i-1-curObjectIndex].heroName;
		heroObjects[i].selfTeam=heroArray[i-1-curObjectIndex].selfTeam

		var tempName="headControl"+i;
		//battleControl.headBg.attachMovie("testhead",tempName,battleControl.headBg.getNextHighestDepth(),{_x:0,_y:0})
		battleControl.headBg.attachMovie("aim_s1",tempName,battleControl.headBg.getNextHighestDepth(),{_x:0,_y:0})
		
		//battleControl.headBg[tempName].icon_mechas.loadMovie("BattleUI.swf")

		//headControls[i]=battleControl.headBg[tempName].icon_mechas.hero_head
		battleControl.headBg[tempName].loadMovie("BattleUI.swf")
		headControls[i]=battleControl.headBg[tempName].hero_head


		headControls[i].showTime=0
		headControls[i].id=heroObjects[i].id
		headControls[i].selfTeam=heroObjects[i].selfTeam
		headControls[i].heroName=heroObjects[i].heroName

		headControls[i].heroIcon1.gotoAndStop(2)
		headControls[i].heroIcon1.hero_useless.onRelease=function()
		{
			this.gotoAndPlay(1)
			fscommand("HeadClick",this._parent._parent.id)
		}
		headControls[i].heroIcon2.onRelease=function()
		{
			fscommand("HeadClick",this._parent.id)
		}
	}
	SetUIPlay()
}

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


function SetRound(obj)
{
	var curRound=obj.curRound
	var maxRound=obj.maxRound
	var battleRound=battleControl.battleTitle.battleRound;
	battleRound.testText.cur_round.text=curRound
	battleRound.testText.max_round.text=maxRound
	battleControl.battleTitle.gotoAndPlay(2);
}

function SetPortraitPos(heroPosInfos)
{
	for(var i=0;i<heroPosInfos.length;i++)
	{
		var curIndex=GetMCIndex(heroPosInfos[i]["id"])
		headControls[curIndex]._x=heroPosInfos[i]["PosX"]			
		headControls[curIndex]._y=heroPosInfos[i]["PosY"]

		if(!heroObjects[curIndex].selfTeam)
		{	
			headControls[curIndex]._x=headControls[curIndex]._x-40		
		}
	}
}

function GetMCIndex(id)
{
	for(var i=0;i<headControls.length;i++)
	{
		if(id==headControls[i+1].id)
		{
			return i+1
		}
	}
}


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

function onTime()
{
	for(var i=0;i<headControls.length;i++)
	{
		if(headControls[i].showTime>0)
		{
			headControls[i].showTime=headControls[i].showTime-1
		}

		if(headControls[i].showTime==0)
		{
			headControls[i]._alpha=1
		}else
		{
			headControls[i]._alpha=100
		}
	}
}

function SetBloodEx(bloodArray)
{
	//SetBloodEx
	//{id="xxx",mp="xxx",hp="xxx",defense="xxx"}

	var bloodType:Array=new Array("hp","mp","defense")
	for(var i=1;i<=bloodArray.length;i++)
	{
		var id=bloodArray[i-1].id
		var showTime=bloodArray[i-1].showTime
		var mcIndex=GetMCIndex(id)

		headControls[mcIndex].showTime=showTime
		headControls[mcIndex].hp=bloodArray[i-1].hp*16
		headControls[mcIndex].mp=bloodArray[i-1].mp*5
		headControls[mcIndex].defense=bloodArray[i-1].defense*16

		for(var j=1;j<=3;j++)
		{
			var mcTemp=headControls[mcIndex][bloodType[j-1]+"_bar"]
			//var mcTemp=headControls[j]["hp_bar"]
			var bloodNum=headControls[mcIndex][bloodType[j-1]]
			mcTemp.gotoAndStop(bloodNum+1);
		}
	}
}

function KeepHead(mc)
{
	var mc1:MovieClip=mc._parent._parent._parent;
	for(var i=1;i<=headControls.length;i++)
	{
		if(mc1==headControls[i])
		{

			if(headControls[i].selfTeam==false)
			{
				mc._parent._parent._visible=false
			}
			mc.gotoAndStop("hero_"+heroObjects[i].heroName);
		}
	}
}

function SetHeadStates(stateData)
{
	var id=stateData.id
	var roleIndex=GetMCIndex(id)
	headControls[roleIndex].gotoAndPlay(stateData.stateName)
}

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
}

battleControl.arrowShow.onRelease=function()
{
	fscommand("ArrowClick");
}


function SetPortraitVisible(showInfo)
{
	var id=showInfo.id
	var roleIndex=GetMCIndex(id)

	var alphaValue=100
	if(showInfo.showFlag==false)
	{
		alphaValue=1
	}
	headControls[roleIndex]._alpha=alphaValue
}

//green=1,red=2,yellow=3

function getVisibleMC(mcType)
{
	var colorType=new Array("num_green_all","num_red_all","num_yellow_all","num_white_all","num_red_all")
	var curMCSet=allMCs[mcType]
	for(var i=0;i<curMCSet.length;i++)
	{
		if(curMCSet[i]._visible==false)
		{
			return curMCSet[i]
		}
	}
	var tempName=colorType[mcType-1]+curMCSet.length

	bloodAllMC.attachMovie(colorType[mcType-1],tempName,bloodAllMC.getNextHighestDepth(),{_x:0,_y:0})
	curMCSet.push(bloodAllMC[tempName])
	return bloodAllMC[tempName]
}

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


function AddPosNode()
{

}

function RemovePosNode()
{

}

function UpdatePosNode()
{
	
}

function UpdateBloodPos()
{
	var id
	var PosX
	var PosY

	for(var i=0;i<allMCs.length;i++)
	{
		var curMCSet=allMCs[i]
		for(var j=0;j<curMCSet.length;j++)
		{
			var curMC=curMCSet[j]
			if(curMC._visible==true)
			{

			}
		}
	}
	var curMCSet=allMCs[mcType]


}

function loadAndShow(obj)
{
	var bloodNum=(new Number(obj.blood)).toString()

	var bloodMC=getVisibleMC(obj.showType)
	bloodMC.id=obj.id

	bloodMC._visible=true
	bloodMC.gotoAndPlay(1)
	bloodMC._x=Math.floor(obj.x)+getRandomDir(10)
	bloodMC._y=Math.floor(obj.y)+getRandomDir(30)-60

	var strSize=bloodNum.length

	for(var i=0;i<5;i++)
	{
		if (i>=strSize)
		{
			bloodMC["num"+(i+1)]._visible=false
		}else
		{
			bloodMC["num"+(i+1)]._visible=true
			var curIndex=new Number(bloodNum.charAt(i))

			bloodMC["num"+(i+1)].curIndex=curIndex+1
			bloodMC["num"+(i+1)].i=0

			bloodMC["num"+(i+1)].onEnterFrame=function()
			{
				this.i=this.i+this.curIndex/9

				this.gotoAndStop(this.i)
				if(this.curIndex<=this.i)
				{
					this.gotoAndStop(this.curIndex)
					this.onEnterFrame=undefined
				}
			}
		}
	}
}

function AddBloodBar(bloodBarArray)
{
	for(var i=0;i<bloodBarArray.length;i++)
	{
		loadAndShow(bloodBarArray[i])
	}
}


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

	battleControl.itemBg.attachMovie("testhead",tempName,battleControl.itemBg.getNextHighestDepth(),{_x:0,_y:0})
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

	curMC.icons.gotoAndStop("item_"+obj.id)

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



function closeFinish(mc,typeString)
{
	mc._visible=false
}