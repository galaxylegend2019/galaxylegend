//return a result 
function GetPercentNum(num1,num2)
{
	var num=Math.ceil((num1/num2)*100)
	if(num<2)
	{
		num+2
	}
	return num
}

function _getNumAdd(Num,numArrays)
{
	var strNumber=""
	for(var i=0;i<numArrays.length;i++)
	{
		var maxNum=new Number(Num.charAt(i))

		if(numArrays[i]<maxNum)
		{
			numArrays[i]=numArrays[i]+1
		}

		strNumber=strNumber+numArrays[i]
	}
	trace(strNumber)
	return strNumber
}


function PlayTextNumAni(numMC,num)
{
	var speed=3
	var frameCount=0

	var Num=(new Number(num)).toString()

	var strSize=Num.length
	var numArrays=new Array(strSize)

	for(var i=0;i<strSize;i++)
	{
		numArrays[i]=0
	}

	numMC._parent.onEnterFrame=function()
	{
		frameCount++;
		if(frameCount%speed==0)
		{
			trace("_getNumAdd")
			numMC.text=_getNumAdd(Num,numArrays)
		}
		if(frameCount>=speed*10)
		{
			this.onEnterFrame=undefined
		}
	}




/*	for(var i=0;i<7;i++)
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
	}*/
}
