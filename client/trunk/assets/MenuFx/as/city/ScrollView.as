var ObjArray:Array;// = new Array();
var PosArray:Array;// = new Array();
var ObjPosArray:Array;// = new Array();

var ObjLen = 0;
var RollObject:MovieClip;

var tempY = 0;
var moveY = 0;

var clickLocked=false
var midPos=260

function OnPress (curY)
{
	tempY=curY
}

//function OnRelease(releaseAction:Boolean)//:Number
function OnRelease()
{

}

function BackCenter ()
{
	var space = Math.abs(PosArray[0] - PosArray[1]);
	var total = (Math.abs(PosArray[0]) + Math.abs(PosArray[ObjLen - 1]) + Math.abs(space));	
	for(var i = 0;i<ObjLen;i++)
	{
		if(ObjPosArray[i] >=midPos-2 && ObjPosArray[i] <=midPos+2)
		{
			this.onEnterFrame = null;
			//RollObject.onEnterFrame = null;

			var temps:Array=new Array()
			for(var i = 0;i<ObjLen;i++)
			{
				temps[i]=ObjPosArray[i]
			}	
			temps.sort(Array.NUMERIC)
			for(var i = 0;i<ObjLen;i++)
			{
				if(ObjPosArray[i]==temps[0])
				{
					_root.SetTop(i)
				}
			}

			setAllVar(null,null,null,null,null,null,0,null);
			clickLocked=false
			return;
		}	
	}
	var minDis=2000;
	var temp
	for(var i = 0;i<ObjLen;i++)
	{
		if(Math.abs(ObjPosArray[i]-midPos)<minDis)
		{
			temp=ObjPosArray[i]-midPos
			minDis=Math.abs(ObjPosArray[i]-midPos)
		}
	}

	var v
	if(temp>0)
	{
		v=-minDis/4
	}
	else
	{
		v=minDis/4
	}
	for (var i=0; i<ObjLen; i++) 
	{		
		ObjPosArray[i] += v;
		ChangePos(space,total,v,i);

		SetItemAttr(i)
	}
}

function Roll ()
{
	clickLocked=true

	moveY = RollObject._parent._ymouse-tempY;
	moveY = Math.ceil(moveY)
	moveY = moveY*4;// mod for HQ
	moveY = Math.min(20, moveY);
	moveY = Math.max(-20, moveY);

	var space = Math.abs(PosArray[0] - PosArray[1]);
	var total = (Math.abs(PosArray[0]) + Math.abs(PosArray[ObjLen - 1]) + Math.abs(space));
	//trace("---------")
	//trace("moveY is "+moveY)
	for(var i=0;i<ObjLen;i++)
	{
		//trace(ObjPosArray[i])
		ObjPosArray[i] += moveY;
		//trace(ObjPosArray[i])
		ChangePos(space,total,moveY,i);
	}

	tempY = RollObject._parent._ymouse;
	for (var i=0; i<ObjLen; i++) 
	{
		SetItemAttr(i)
	}

};


function SetItemAttr(curIndex)
{
	var i=curIndex
	var scaleValue = interpolation(PosArray,ScaleArray,ObjPosArray[i],ObjLen);
	scaleValue=setDistanceRate(ObjPosArray[i])

	ObjArray[i]._xscale = scaleValue;
	ObjArray[i]._yscale = scaleValue;

	ObjArray[i]._y =(ObjPosArray[i])
}

function setDistanceRate(objpos)
{
	var disRate;
	if(objpos>=midPos)
	{
		disRate=(objpos-midPos)/100;
	}else
	{
		disRate=(midPos-objpos)/100;
	}
	var v=110-disRate*10
	return v;
}



function resetAll(obj:Array, pos:Array, objpos:Array, scale:Array, alhpa:Array, sp:Array, len:Number, enbale:Array) 
{

	setAllVar(obj,pos,objpos,6,this);
	var mid=math.floor(ObjLen/2)
	for(var i=0; i<ObjLen; i++){

		ObjPosArray[i] = pos[i];

		var scaleValue=setDistanceRate(ObjPosArray[i])
		ObjArray[i]._xscale = scaleValue;
		ObjArray[i]._yscale = scaleValue;

		ObjArray[i]._y =(ObjPosArray[i])//* sca/100;

		if(ObjPosArray[i] == midPos){
			CenterID = i;
		}
	}
	setAllVar(null,null,null,0,null);
}

function setAllVar(obj:Array, pos:Array, objpos:Array, len:Number, object:MovieClip){
	ObjArray = obj;
	PosArray = pos;
	ObjPosArray = objpos;
	ObjLen = len;
	RollObject = object;
}

//确保可以页面循环
function ChangePos(space:Number,total:Number,v:Number,id:Number)
{

	if(v > 0)
	{
		if(ObjPosArray[id] >= PosArray[ObjLen - 1] + space){
			var spa=PosArray[0]+ObjPosArray[id] -(PosArray[ObjLen - 1] + space)
			ObjPosArray[id]=Math.floor(spa)
			_root.changeData(v,id);
		}
	}else if(v < 0)
	{
		if(ObjPosArray[id] <= PosArray[0]){	
			var spa=PosArray[ObjLen - 1]-(PosArray[0]-ObjPosArray[id])
			ObjPosArray[id]=Math.floor(spa+space)
			_root.changeData(v,id);
		}
	}	

}

