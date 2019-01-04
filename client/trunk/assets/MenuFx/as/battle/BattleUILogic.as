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
var selfTeamNum=0

var head_board

var CountDownTime = 0;
var IsPause = false;
var speed_scale = 1

var skillInterval=100
var isSkillBarPause=false

var boss_info

var ult_guide = null
var ult_guide_array = new Array()

var combo_text 
var lastComboTime = 0
var comboRefreshTime = 0



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
	battleControl.btn_set._visible=flag
	//battleControl.timeShow._visible=flag;
	//battleControl.timeShow.btn_speed._visible=flag;
	//battleControl.timeShow.btn_auto._visible=flag;
}

function LoadSomeSwf()
{
	battleControl.bloodBarBg.loadMovie("BattleNumber.swf")
}

//do something after ui load
function Init()
{
    _root.setting._visible=false
	battleControl.pick.pick.item_num.text="x"+0
	//battleControl.btn_set._visible=false
	LoadSomeSwf()
	//preLoadMC()

	battleControl.battleTitle._visible=false

	//battleControl._visible = false;
	battleControl.arrowShow._visible=false;
	SetOpinion(false)
	initTargetCount(targetCount)

	bloodAllMC=battleControl.bloodBarBg.all

	//load head mc------------pre
    // LoadHeadMC()

	_root.boss._visible=false
	_root.popup_btn_info._visible=false
	_root.bossInfo._visible=false
	
	AddEvent()
	
	battleControl.timeShow.time_text.time_text.text = "02:00"
	PauseCountDown()

	fscommand("TutorialCommand","AsTrackEvent" + "\2" + "battleui");
}

this.onLoad=function()
{
    Init()
}

//count down

function SetCountDownNum( count_down )
{
	battleControl.timeShow.time_text.time_text._visible= true
	CountDownTime = count_down;
	ResumeCountDown();
}

function RefreshCountDown()
{
	if (not IsPause)
	{
		if (CountDownTime < 0)
		{
			return;
		}
		CountDownTime  -= 1;
		battleControl.timeShow.time_text.time_text.text = GetTimeText(CountDownTime);	
	}
	
}

function ResumeCountDown()
{
	IsPause = false;
}

function PauseCountDown()
{
	IsPause = true;
}


//--------------auto attack ----------------
battleControl.timeShow.btn_auto.onRelease = function()
{
	fscommand("AutoAttack");
}


//--------------control battle speed ---------
battleControl.timeShow.btn_speed.onRelease = function()
{
	fscommand("BattleSpeed");
}

//---------------Set auto attack status-----------
//1-inactive 2-active 3-disabled
function SetAutoStatus(active)
{
	var enable = active != 3
	battleControl.timeShow.btn_auto._visible = enable
	battleControl.timeShow.btn_auto.gotoAndStop(active)
}

//---------------Set speed button status-----------
//1-1x 2-2x 3-disabled
function SetSpeedStatus(speedArgs)
{
	var enable = speedArgs.unlock
	speed_scale  = speedArgs.speed
	var frame = speed_scale > 1 ? 2 : 1 
	battleControl.timeShow.btn_speed._visible = enable

	if(!enable)
		battleControl.timeShow.btn_speed.gotoAndStop(3)
	else
		battleControl.timeShow.btn_speed.gotoAndStop(frame)
		
	battleControl.timeShow.btn_speed.txt_speed.text = speed_scale + "x"
}

//---------------Set music discription-----------
function SetMusicDisc(discription)
{
	_root.setting.pop_content.btn_music.txt_music.text = discription
}

//---------------Set sound discription-----------
function SetSoundDisc(discription)
{
	_root.setting.pop_content.btn_sound.txt_sound.text = discription
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
		fscommand("CombatPause", "0")

		this.onRelease=undefined
		this._visible=false
		this._parent.gotoAndPlay("closing_ani")
		this._parent.OnMoveOutOver=function()
		{
			this._visible=false
		}
	}
	
	fscommand("CombatPause", "1")
}

function addEvent()
{	
	var setting=_root.setting
	
	setting.pop_content.btn_quit.onRelease=function()
	{
		
	}
	
	setting.pop_content.btn_sound.onRelease=function()
	{
		fscommand("SoundSwitch")
	}
	
	setting.pop_content.btn_music.onRelease=function()
	{
		fscommand("MusicSwitch")
	}
	
	setting.pop_content.btn_continue.onRelease=function()
	{
		setting.gotoAndPlay("closing_ani")	
	
		setting.OnMoveOutOver=function()
		{
			setting._visible=false
			fscommand("CombatPause", "0")
		}
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
		obj.lastTimer=0

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
	node.bloodMC._x=node.PosX
	node.bloodMC._y=node.PosY

	//-----------update blood_num pos
	//var node.bloodNums.length
	//伤害数字不跟随角色移动，避免随角色颤动
	/*for(var i=0;i<node.bloodNums.length;i++)
	{
		var numberMC=node.bloodNums[i]
		if(numberMC._visible==true)
		{
			numberMC._x=node.PosX
			numberMC._y=node.PosY
		}
	}*/
}

//-----------new a head mc
function NewHeadMc()
{
	var tempName=getUniqueName("headControl")//"headControl"+nameIndex;

	if(battleControl.headBg[tempName]!=undefined)
	{
		return battleControl.headBg[tempName].hero_head
	}

	battleControl.headBg.attachMovie("aim_s1",tempName,battleControl.headBg.getNextHighestDepth(),{_x:0,_y:0})
	battleControl.headBg[tempName].loadMovie("BattleUI.swf")

	return battleControl.headBg[tempName].hero_head
}

//----------load head mc
function LoadHeadMC()
{
	var tempName="headMC"
    battleControl.headBg.attachMovie("aim_s1",tempName,battleControl.headBg.getNextHighestDepth(),{_x:0,_y:0})

    if (_root.is4x3())
    {
        battleControl.headBg[tempName].loadMovie("BattleUI_new_4x3.swf")
    }
    else
    {
        battleControl.headBg[tempName].loadMovie("BattleUI_new.swf")
    }
    head_board=battleControl.headBg[tempName].hero_head

	for(var i=0;i<6;i++)
	{
		var item=head_board["item"+(i+1)]
		item._visible=false
	}
	head_board._visible=false

	battleControl.headBg.headMC.fteanim.hero5._visible = false
	battleControl.headBg.headMC.fteanim.hero4._visible = false
	battleControl.headBg.headMC.fteanim.hero3._visible = false
	battleControl.headBg.headMC.fteanim.hero2._visible = false
	battleControl.headBg.headMC.fteanim.hero1._visible = false

}

//----------new a blood mc
function NewBloodMC()
{
	var tempName=getUniqueName("bloodMC")//"headControl"+nameIndex;

	if(battleControl.bloodBar[tempName]!=undefined)
	{
		return battleControl.bloodBar[tempName]
	}

	battleControl.bloodBar.attachMovie("aim_s1",tempName,battleControl.bloodBar.getNextHighestDepth()+1,{_x:0,_y:0})
	battleControl.bloodBar[tempName].loadMovie("BattleBlood.swf")
	battleControl.bloodBar[tempName].skill_bar._visible=false
	battleControl.bloodBar[tempName].isBloodMC = true
	return battleControl.bloodBar[tempName]
}

//----------------init a head for a new interface---------------
function InitHeadEx(heroArray)
{
	for(var i=0;i<heroArray.length;i++)
	{
		var datas=heroArray[i]
		var node=GetNodeByName(datas.nodeName)

		//trace(datas.nodeName)
		if(node.bloodMC!=undefined)
		{
			continue
		}
		//node.mc=NewHeadMc()
		node.bloodMC=NewBloodMC()

		var mc_head=node.bloodMC
		mc_head.id=datas.id
		mc_head.headName=datas.headName
		mc_head.selfTeam=datas.selfTeam
		mc_head.showTime=100

		mc_head._x=node.PosX
		mc_head._y=node.PosY
		if(datas.selfTeam)
		{
			selfTeamNum++
			//node.headMC=NewHeadMc()
			head_board._visible=true
			node.headMC=head_board["item"+selfTeamNum]
			node.headMC.headName=datas.headName
			node.headMC.heroIcon1.hero_normal.icons.gotoAndStop("hero_"+datas.headName)
			node.headMC._visible=true

			node.headMC.id=datas.id
			//node.headMC._y=640
			//node.headMC._x=1136-(150*selfTeamNum)

			var mc_head=node.headMC
			//mc_head.heroIcon1.gotoAndStop(2)

			mc_head.onRelease=function()
			{
				fscommand("HeadClick",this.id)
			}
		}
	}

	//SetUIPlay()
	battleControl._visible = true;
	SetBackTimer()
	head_board.gotoAndPlay("opening_ani")
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
	var colorType=new Array("word_miss","word_block","num_yellow_all","num_yell_all","num_white_all","num_red_block","num_red_all","num_green_all","num_blue_all")


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
	
	var len = node.bloodNums.length
	var prevMC = len > 0 ? node.bloodNums[len - 1] : null
	
	node.bloodNums.push(bloodMC)
	bloodMC.nodeNames=obj.nodeName
	bloodMC.mcIndex=node.bloodNums.length-1

	bloodMC._visible=true
	bloodMC.gotoAndPlay(1)
	bloodMC._x=Math.floor(node.PosX) - bloodMC._width * 0.5// - 30//+getRandomDir(10)
	bloodMC._y=Math.floor(node.PosY)// - 40//+getRandomDir(30)-60
	
	var yOffset = 0
	var timer = getTimer()
	if(prevMC != null && timer - node.lastTimer < 200)
	{
		prevMC._y = prevMC._y - bloodMC._height
	}
	
	node.lastTimer = timer

	var strSize=bloodNum.length

	var numMC=bloodMC

	/*
	if(obj.showType==1)
	{
		return
	}else if(obj.showType==3)
	{
		numMC=bloodMC.num
	}
	*/

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
	

	
}

//-----------set timer for hide head
function SetBackTimer()
{
	var timerSecond:Number = getTimer();
	var timerMilliSecond:Number = getTimer();
	_root.onEnterFrame = function()
	{
		if(_root.onUpdate!=undefined)
		{
			_root.onUpdate()
		}

		if (getTimer() - timerSecond >= 1000 / speed_scale) 
		{
		      timerSecond = getTimer();
		      onTime()
		      RefreshCountDown();
		}
		if (getTimer() - timerMilliSecond >=skillInterval) 
		{
			var intervalTime=getTimer()-timerMilliSecond
			//trace(getTimer() - timerMilliSecond)
		      timerMilliSecond = getTimer();
		      onTimeSecond(intervalTime)
		}

		if(ult_guide_array.length > 0 and ult_guide == null)
		{
			AddUltGuild(ult_guide_array.shift())
		}
	}
}

//excute every 0.1 second
function onTimeSecond(intervalTime)
{
	if(isSkillBarPause==true)
	{
		return
	}
	for(var i=0;i<Nodes.length;i++)
	{
		//------------for skill show
		var skillMC=Nodes[i].bloodMC.skill_bar
		if(skillMC.curTime>0)
		{
			skillMC.curTime=skillMC.curTime-(intervalTime/1000)
			skillMC._visible=true
			var process=Math.floor((skillMC.curTime/skillMC.MaxTime)*100)
			if(process>=100)
			{
				process=100
			}else if(process<=2)
			{
				process=2
			}
			skillMC.gotoAndStop(process)
		}else
		{
			skillMC._visible=false
		}
	}
}

//---------excute every 1 second
function onTime()
{
	for(var i=0;i<Nodes.length;i++)
	{
		//-----------for blood show
		var showTime=Nodes[i].bloodMC.showTime
		if(showTime>0)
		{
			Nodes[i].bloodMC.showTime=showTime-1
		}

		if(Nodes[i].bloodMC.showTime<=0)
		{
			//Nodes[i].bloodMC.defense_bar._visible=false
			Nodes[i].bloodMC.hp_bar._visible=false
			Nodes[i].bloodMC.hp_bar_1._visible=false
		}else
		{
			//Nodes[i].bloodMC._alpha=100
			//Nodes[i].bloodMC.defense_bar._visible=true
			//Nodes[i].bloodMC.hp_bar._visible=true
			var hp_bar = GetBloodBar(Nodes[i].bloodMC, Nodes[i].bloodMC.isEnemy)
			hp_bar._visible = true
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
		if(Nodes[i].bloodMC.id==id)
		{
			return Nodes[i]
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

	
	for(var i=1;i<=bloodArray.length;i++)
	{
		var id=bloodArray[i-1].id
		var bloodMC=GetMCById(id).bloodMC
		var bloodData=bloodArray[i-1]
		SetBloodBar(bloodMC,bloodData)

		var headMC=GetMCById(id).headMC
		SetBloodBar(headMC,bloodData)
	}
}

function GetBloodBar(mc, isEnemy)
{
	if(!mc.isBloodMC)
	{
		return mc.hp_bar
	}

	if(isEnemy)
	{
		mc.hp_bar._visible = false
		return mc.hp_bar_1
	}

	mc.hp_bar_1._visible = false
	return mc.hp_bar
}

function SetBloodBar(mc,bloodData)
{
	//var bloodType:Array=new Array("hp","mp","defense")
	var bloodType:Array=new Array("hp","mp")
	if (mc.isBloodMC)
	{
		var isEnemy = bloodData.isEnemy
		var hp_bar = GetBloodBar(mc, isEnemy)
		mc.isEnemy = isEnemy
	}
	else
		mc.hp_bar._visible=true

	mc.defense_bar._visible=false
	
	//mc._alpha=100
	var showTime=bloodData.showTime
	if(showTime!=undefined)
	{
		mc.showTime=showTime
	}

	if (mc.isBloodMC)
	{
		hp_bar.blood_bg._x= -35;
		hp_bar.blood_bg._y = -7;
		hp_bar.blood_body._x= -33;
		hp_bar.blood_body._y = -6;
		hp_bar.blood_head._x= -34;
		hp_bar.blood_head._y = -6;

		hp_bar.blood_end._y = -6;
		hp_bar.blood_end._y = -6;
		hp_bar._visible=showTime > 0
	}
		

	//mc.hp=Math.ceil(bloodData.hp*100)
	//mc.mp=Math.ceil(bloodData.mp*100)
	//mc.defense=Math.ceil(bloodData.defense*9)

	for(var j=1;j<=2;j++)
	{
		var mcTemp
		if(isHeadMC)
			mcTemp = mc[bloodType[j-1]+"_bar"]
		else
			mcTemp = isEnemy ? mc[bloodType[j-1]+"_bar_1"] : mc[bloodType[j-1]+"_bar"]
		//var mcTemp=headControls[j]["hp_bar"]

		if(mcTemp!=undefined)
		{
			mc[bloodType[j-1]] = Math.ceil(bloodData[bloodType[j-1]] * (mcTemp._totalframes - 1))

			var bloodNum=mc[bloodType[j-1]]

			if(bloodNum==100)
			{
				bloodNum=99
			}		
			mcTemp.gotoAndStop(bloodNum+1);
		}
	}
}

function SetSkillBar(skillArray)
{
	//{isVisible=true,MaxTime=3}
	for(var i=1;i<=skillArray.length;i++)
	{
		var id=skillArray[i-1].id
		var skillMC=GetMCById(id).bloodMC.skill_bar
		var skillData=skillArray[i-1]
		SetSkillBarMC(skillMC,skillData)

	}
}

function SetSkillBarPause(flag)
{
	isSkillBarPause=flag
}

function SetSkillBarMC(mc,datas)
{
	if(datas.isVisible==true)
	{
		mc._visible=true
		mc.gotoAndStop(100)
		mc.MaxTime=datas.MaxTime
		mc.curTime=datas.MaxTime


		mc.skill_body._y = -3
		mc.skill_bg._y = 0

		if(datas.intervalTime!=undefined)
		{
			skillInterval=datas.intervalTime*1000
		}
	}else
	{
		mc._visible=false
		mc.curTime=-1
	}
}


function KeepHead(mc)
{
	var mc1:MovieClip=mc._parent._parent;
	for(var i=0;i<Nodes.length;i++)
	{
		if(mc1==Nodes[i].headMC or mc1._parent==Nodes[i].headMC or mc1._parent._parent==Nodes[i].headMC)
		{
			mc.gotoAndStop("hero_"+Nodes[i].headMC.headName);
		}
	}

}

function SetHeadStates(stateData)
{
	var id=stateData.id
	//var mc=GetMCById(id).mc
	//mc.gotoAndPlay(stateData.stateName)

	var mc=GetMCById(id).headMC
	var obj=new Object()
	obj.normalToSkill=3
	obj.skillToNormal=1
	obj.normalToDead=2
	mc.heroIcon1.gotoAndStop(obj[stateData.stateName])
}

function SetUltGuild(args)
{
	var show = args.show

	if (show)
	{
		if(args.drama)
			ult_guide_array.push(args)
		else
		{
			AddUltGuild(args)
		}
	}
	else
	{
		RemoveUltGuild(args)
		if(not args.drama)
			ult_guide = 1
	}
}

function AddUltGuild(args)
{
	var show = args.show
	var id   = args.id

	if (ult_guide == null)
	{
		var mc   = GetMCById(id).headMC
		var txt  = args.desc
		ult_guide = mc.heroIcon1.attachMovie("point_guide" , "ult_guide_mc", mc.heroIcon1.getNextHighestDepth(),{_x:0,_y:10})
		ult_guide.id = id
		//ult_guide.Dialogue_guide.content_view.content_text.text = txt
	}
}

function RemoveUltGuild(args)
{
	var id = args.id
	if (ult_guide and ult_guide.id == id)
	{

		ult_guide.removeMovieClip()
		ult_guide = null
	}

	for(var i = ult_guide_array.length - 1; i >= 0; --i)
	{
		if(ult_guide_array[i].id == id)
			ult_guide_array.splice(i, 1)
	}
}

function HideUltGuild(hide)
{
	if(ult_guide)
	{
		ult_guide._visible = (not hide)
	}
}

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
	curMC.standardX=obj.x
	curMC.standardY=obj.y

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

	_root.onUpdate=function()
	{
		var needCount=0
		for(var i=0;i<ItemAllMC.length;i++)
		{

			if(ItemAllMC[i]._alpha>=0)
			{
				ItemAllMC[i]._alpha=ItemAllMC[i]._alpha-itemHideSpeed

				var standardx=ItemAllMC[i].standardX
				var standardy=ItemAllMC[i].standardY
				var xspeed=(1136-standardx)/(100/itemHideSpeed)
				var yspeed=standardy/(100/itemHideSpeed)
				ItemAllMC[i]._y=ItemAllMC[i]._y-yspeed
				ItemAllMC[i]._x=ItemAllMC[i]._x+xspeed
				needCount++
			}
		}

		if(needCount==0)
		{
			isNeedUpdate=false
		}
		if(isNeedUpdate==false)
		{
			_root.onUpdate=undefined
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

function SetPlayBoss(bossInfo)
{
	_root.boss._visible=true
	_root.boss.gotoAndPlay("open")
	boss_info = bossInfo
	ShowBossInfo()
	//_root.boss.onMoveInOver=function()
	//{
	//	ShowBossInfo()
	//}
}

function ShowBossInfo()
{
	if (!boss_info)
		return;

	_root.bossInfo._visible = true
	_root.bossInfo.gotoAndPlay("opening_ani")	
	battleControl.bloodBar._visible = false

	_root.bossInfo.onRelease=function()
	{
		fscommand("CombatPause", "0")

		this.onRelease = undefined
		this._visible = false
		fscommand("ShowModelUI", "0" + "\2" + "")
		boss_info = undefined
		battleControl.bloodBar._visible = true
	}
	
	fscommand("CombatPause", "1")
	
	_root.bossInfo.title.txt_name.text = boss_info.name
	_root.bossInfo.hero_flag_icon.txt_locate.text = boss_info.desc
	_root.bossInfo.hero_flag_icon.hero_desc.text = boss_info.detail
	
	_root.bossInfo.skill_info.txt_name.text = boss_info.skillName
	_root.bossInfo.skill_info.txt_desc.text = boss_info.skillDesc
	
	if(_root.bossInfo.skill_info.skill_icon.icons==undefined)
    {
    	_root.bossInfo.skill_info.skill_icon.loadMovie("CommonSkills.swf");
    }
	
    _root.bossInfo.skill_info.skill_icon.icons.icons.gotoAndStop("skill_" + boss_info.skillId);
	
	fscommand("ShowModelUI", "1" + "\2" + boss_info.modelName)
}

function ShowComboText(args)
{
	var comboNum = args.comboNum
	var showTime = args.showTime
	
	if (not combo_text)
	{
		bloodAllMC.attachMovie("word_hits","ComboText",bloodAllMC.getNextHighestDepth(),{_x:800,_y:250})
		combo_text = bloodAllMC["ComboText"]
	}

	if (comboNum > 99)
		comboNum = 99

	var num2 = Math.floor(comboNum / 10)
	var num1 = comboNum - num2 * 10

	combo_text._visible = true
	combo_text.comboHits.number_2.gotoAndStop(num2 + 1)
	combo_text.comboHits.number_1.gotoAndStop(num1 + 1)
	combo_text.comboHits.amazing._visible = comboNum >= 20
	combo_text.gotoAndPlay(1)
}

function GetTimeText(time)
{
  if (time == undefined)
  {
    return;
  }
  //time = time / 1000;
  var year   = Math.floor(time / (365 * 24 * 3600));
  time = time - (year * 365 * 24 * 3600);
  var month    = Math.floor(time / (30 * 24 * 3600));
  time = time - (month * 30 * 24 * 3600);
  var day   = Math.floor(time / (24 * 3600));
  time = time - (day * 24 * 3600);
  var hour   = Math.floor(time / 3600);
  time = time - (hour * 3600);
  var minutes  = Math.floor(time / 60);
  var seconds = Math.floor(time - (minutes * 60));
  var ret = "";
  //if (hour < 10)
  //{
  //  ret = ret + "0" + hour + ":";
  //}else{
  //  ret = ret + hour + ":";
  //}

  if (minutes < 10)
  {
    ret = ret + "0" + minutes + ":";
  }else{
    ret = ret + minutes + ":";
  }

  if (seconds < 10)
  {
    ret = ret + "0" +seconds;
  }else{
    ret = ret + seconds;
  }

  return ret;
}


function FTEPlayAnim(sname, xpos, ypos)
{
	if (sname == "skill1")
	{
		battleControl.headBg.headMC.fteanim.hero1._visible = true
	}
	else if (sname == "skill2")
	{
		battleControl.headBg.headMC.fteanim.hero2._visible = true
	}
	else if (sname == "skill3")
	{
		battleControl.headBg.headMC.fteanim.hero3._visible = true
	}
	else if (sname == "skill4")
	{
		battleControl.headBg.headMC.fteanim.hero4._visible = true
	}
	else if (sname == "skill5")
	{
		battleControl.headBg.headMC.fteanim.hero5._visible = true
	}
	else if (sname == "hitpt")
	{
		_root.fteanim.hitpt._visible = true
		_root.fteanim.hitpt._x = xpos
		_root.fteanim.hitpt._y = ypos
	}
	else
	{
		_root.fteanim[sname]._visible = true
	}
	
}

function FTEHideAnim()
{
	if (battleControl.headBg.headMC.fteanim != undefined)
	{
		battleControl.headBg.headMC.fteanim.hero5._visible = false
		battleControl.headBg.headMC.fteanim.hero4._visible = false
		battleControl.headBg.headMC.fteanim.hero3._visible = false
		battleControl.headBg.headMC.fteanim.hero2._visible = false
		battleControl.headBg.headMC.fteanim.hero1._visible = false
	}

	_root.fteanim.hitpt._visible = false
}
FTEHideAnim()




