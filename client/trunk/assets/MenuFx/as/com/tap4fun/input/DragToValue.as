/*								DragToValue
**
** instanciation howto
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
**
*/
import com.tap4fun.input.DisplacementDeltas;
import com.tap4fun.utils.MovieClipsUtils;
import flash.geom.Point;

class com.tap4fun.input.DragToValue
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var belowMinValue:Number;
	public var belowMaxValue:Number;
	public var belowDiff:Number;
	public var aboveMinValue:Number;
	public var aboveMaxValue:Number;
	public var aboveDiff:Number;
	public var baseValue:Number;
	public var sensibility:Number;
	
	public var throwFriction:Number;
	
	public var xBased:Boolean;
	public var tellEventsOnUnderlyingMcs:Boolean;
	public var releaseArea:Number;
	
	private var previousPos:Number;
	private var _times:Number;
	private var _value:Number;
	private var _deltas:DisplacementDeltas;
	private var _mcsUtils:MovieClipsUtils;
	private var _mcNeedingRelease:MovieClip;
	private var _inReleaseArea:Boolean;
	private var _throwLength:Number;
	private var _throwPreviousPos:Number;
	
	//MovieClips
	public var targetMc:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DragToValue($targetMc:MovieClip, $sensibility:Number, $belowMinValue:Number, $belowMaxValue:Number, $baseValue:Number, $aboveMinValue:Number, $aboveMaxValue:Number)
	{
		this.targetMc = $targetMc;
		this.targetMc.DragToValue = this;
		this._deltas = new DisplacementDeltas();
		this._mcsUtils = new MovieClipsUtils();
		
		this.xBased = false;
		this.tellEventsOnUnderlyingMcs = true;
		this.releaseArea = 10;
		this._inReleaseArea = false;
		
		this.sensibility = $sensibility;
		this.belowMinValue = $belowMinValue;
		this.belowMaxValue = $belowMaxValue;
		this.belowDiff = Math.max(Math.abs(this.belowMaxValue), Math.abs(this.belowMinValue)) - Math.min(Math.abs(this.belowMaxValue), Math.abs(this.belowMinValue));
		this.baseValue = $baseValue;
		this.aboveMinValue = $aboveMinValue;
		this.aboveMaxValue = $aboveMaxValue;
		this.aboveDiff = Math.max(Math.abs(this.aboveMaxValue), Math.abs(this.aboveMinValue)) - Math.min(Math.abs(this.aboveMaxValue), Math.abs(this.aboveMinValue));
		this._times = 0;
		
		this.applyElementsEventsHandlers();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function tellNewValue($pos:Number, $forcedValue:Number):Void
	{
		var $value:Number = $pos;
		var $times:Number = 0;
		var $returnedTimes:Number = 0;
		var $reminder:Number;
		
		if($value < 0)
		{
			$reminder = Math.abs($value%this.belowDiff);
			$times = (Math.abs($value)-$reminder)*-1/this.belowDiff;
			
			if($reminder == 0) $reminder = this.baseValue;
			
			else if(this.belowMaxValue > this.belowMinValue) $reminder = this.belowMaxValue - $reminder;
			else $reminder = this.belowMaxValue + $reminder;
		}
		else if($value > 0)
		{
			$reminder =Math.abs($value%this.aboveDiff);
			$times = (Math.abs($value)-$reminder)/this.aboveDiff;
			
			if($reminder == 0) $reminder = this.baseValue;
			
			else if(this.aboveMaxValue > this.aboveMinValue) $reminder = this.aboveMinValue + $reminder;
			else $reminder = this.aboveMinValue - $reminder;
		}
		else if($value == 0)
		{
			$reminder = this.baseValue;
			$times = 0;
		}
		
		if(this._times!=$times)
		{
			$returnedTimes = ($times > this._times)?1: -1;
			
			this.onNewWhole($returnedTimes);
			
			$times = 0;
			if ($forcedValue!=undefined) this._deltas.forceStartingPoint($forcedValue, $forcedValue);
			else this._deltas.setStartingPoint();
			
			this._deltas.clearStoredSamples();
			this._deltas.addCurrentDeltaToStoredSamples();
			
			this._times = 0;
		}
		else
		{
			this.onChange($reminder, $times);
		}
		this._value = $reminder;
		this._times = $times;
	}
	private function valueIsIn($value:Number, $first:Number, $second:Number):Boolean
	{
		var $lowest:Number = Math.min($first, $second);
		var $highest:Number = Math.max($first, $second);
		
		return($value >= $lowest && $value <= $highest);
	}
	private function continueTo($value:Number):Void
	{
		var $inc:Number = 0;
		if(this._value > $value) $inc = -1;
		else $inc = 1;
		
		this.targetMc.inc = $inc;
		this.targetMc.targetValue = $value;
		this.targetMc._deltas = this._deltas;
		
		this.targetMc.onEnterFrame = function():Void
		{
			this.DragToValue._value += this.inc;
			this._deltas.addToForcedEndingPoint(this.inc, this.inc);
			this._deltas.storeCurrentDelta(true);
			
			if((this.inc == 1 && this.DragToValue._value > this.targetValue) || (this.inc == -1 && this.DragToValue._value < this.targetValue))
			{
				this.DragToValue._value = this.DragToValue.baseValue;
				if(this.DragToValue.valueIsIn(this.targetValue, this.DragToValue.belowMinValue, this.DragToValue.belowMaxValue) && this.inc == 1)
				{
					this.DragToValue.onNewWhole(-1);
				}
				else if (this.DragToValue.valueIsIn(this.targetValue, this.DragToValue.aboveMinValue, this.DragToValue.aboveMaxValue) && this.inc == 1)
				{
					this.DragToValue.onNewWhole(1);
				}
				this.DragToValue.onChange(this.DragToValue.baseValue, 0);
				delete this.onEnterFrame;
			}
			else
			{
				this.DragToValue.onChange(this.DragToValue._value, 0);
			}
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function continueToNearestLimit():Void
	{
		if(Math.round(this._value) == this.baseValue)
		{
			//At base value, ignore...
			this.onChange(this.DragToValue.baseValue, 0);
			delete this.targetMc.onEnterFrame;
			return;
		}
		
		var $isInBelow:Boolean = this.valueIsIn(this._value, this.belowMinValue, this.belowMaxValue);
		var $isInAbove:Boolean = this.valueIsIn(this._value, this.belowMinValue, this.belowMaxValue);
		
		var $lowest:Number = $isInBelow?Math.min(this.belowMinValue, this.belowMaxValue):Math.min(this.aboveMinValue, this.aboveMaxValue);
		var $highest:Number = $isInBelow?Math.max(this.belowMinValue, this.belowMaxValue):Math.max(this.aboveMinValue, this.aboveMaxValue);
		
		if($lowest + (this.belowDiff/2) > this._value)
		{
			//Going to lowset
			this.continueTo($lowest);
		}
		else
		{
			//Going to highest
			this.continueTo($highest);
		}
	}
	public function throwEffect():Void
	{
		if (this.throwFriction == 0 || _root._xmouse < 0 || _root._ymouse < 0)
		{
			this.onThrowEnd();
			return;
		}
		var $curDelta:Number = this.xBased?(this._deltas.getDeltas().x):(this._deltas.getDeltas().y);
		
		this._throwPreviousPos = this.xBased?Math.max(0, _root._xmouse):Math.max(0, _root._ymouse);
		
		var $normDelta:Point = this._deltas.getNormalizedDeltasFromStoredSamples();
		this._throwLength = this.xBased? $curDelta - $normDelta.x: $curDelta - $normDelta.y;
		this._throwLength *= this.sensibility;
		
		this.targetMc.onEnterFrame = function():Void
		{
			this.DragToValue.checkThrowPos();
		};
	}
	public function applyElementsEventsHandlers():Void
	{
		this.targetMc.onPress = function():Void {this.DragToValue.onTargetPress(this)};
		this.targetMc.onRelease = this.targetMc.onReleaseOutside = function():Void {this.DragToValue.onTargetRelease(this)};
	}
	public function checkPos():Void
	{
		var $curPos:Number = this.xBased?(this._deltas.getDeltas().x):(this._deltas.getDeltas().y);
		
		$curPos = Math.round($curPos * this.sensibility);
		
		this._deltas.addCurrentDeltaToStoredSamples();
		
		if($curPos!=this.previousPos)
		{
			this.tellNewValue($curPos);
			this.previousPos = $curPos;
		}
	}
	public function checkThrowPos():Void
	{
		this._throwLength /= this.throwFriction;
		this._deltas.forceEndingPoint(this._throwPreviousPos + this._throwLength, this._throwPreviousPos + this._throwLength);
		this._deltas.storeCurrentDelta(true);
		this._throwPreviousPos += this._throwLength;
		
		var $curPos:Number = this.xBased?(this._deltas.getForcedDeltas().x):(this._deltas.getForcedDeltas().y);
		$curPos = Math.round($curPos * this.sensibility);
		var $posDiff:Number = $curPos - this.previousPos;
		
		if($posDiff != 0)
		{
			this.tellNewValue($curPos, this._throwPreviousPos);
			this.previousPos = $curPos;
		}
		
		if (Math.abs($posDiff) <= 1)
		{
			delete this.targetMc.onEnterFrame;
			this.onThrowEnd();
		}
	}
	public function stopThrow():Void
	{
		this._throwLength = 0;
		delete this.targetMc.onEnterFrame;
	}
	public function onTargetPress($mc:MovieClip):Void
	{
		_global.forceFlashInputBehavior(true);
		
		if ($mc.onEnterFrame && _root._xmouse > 0 && _root._ymouse > 0)
		{
			this._deltas.forceStartingPoint(_root._xmouse - this._deltas.getStoredDelta().x, _root._ymouse - this._deltas.getStoredDelta().y);
		}
		else this._deltas.setStartingPoint();
		
		this._deltas.clearStoredSamples();
		this._times = 0;
		
		if(this.tellEventsOnUnderlyingMcs)
		{
			var $touchedMc:MovieClip = this._mcsUtils.findActiveMcUnderMouse();
			if (this._mcNeedingRelease instanceof MovieClip)
			{
				this._mcNeedingRelease.gotoAndPlay("focus_out");
				this._mcNeedingRelease.on_focus_out();
				this._mcNeedingRelease = null;
			}
			if($touchedMc)
			{
				this._mcNeedingRelease = $touchedMc;
				this._inReleaseArea = true;
				$touchedMc.gotoAndPlay("pressed");
				$touchedMc.onPress();
			}
		}
		
		$mc.onEnterFrame = function():Void
		{
			this.DragToValue.checkPos();
			this.DragToValue.checkPressedMc();
		};
	}
	public function checkPressedMc():Void
	{
		if (!this._mcNeedingRelease) return;
		
		if(this._inReleaseArea && this.tellEventsOnUnderlyingMcs)
		{
			this._inReleaseArea = Math.abs(this._deltas.getDeltas().x)<=this.releaseArea && Math.abs(this._deltas.getDeltas().y)<=this.releaseArea;
			if(!this._inReleaseArea)
			{
				this._mcNeedingRelease.gotoAndPlay("focus_out");
				this._mcNeedingRelease.on_focus_out();
				this._mcNeedingRelease = null;
			}
		}
	}
	public function onTargetRelease($mc:MovieClip):Void
	{
		_global.forceFlashInputBehavior(false);
		
		this._deltas.storeCurrentDelta();
		
		if(this.tellEventsOnUnderlyingMcs)
		{
			var $touchedMc:MovieClip = this._mcNeedingRelease;
			if($touchedMc)
			{
				if(this._inReleaseArea && MovieClipsUtils.isMouseOver(this._mcNeedingRelease))
				{
					$touchedMc.gotoAndPlay("released");
					if($touchedMc.onRelease)$touchedMc.onRelease();
				}
				else
				{
					if($touchedMc.onReleaseOutside)$touchedMc.onReleaseOutside();
				}
			}
			this._inReleaseArea = false;
		}
		
		delete $mc.onEnterFrame;
		this.onStopDrag();
	}
	
	public function setUnderlyingMcs($mcs:Array):Void
	{
		this._mcsUtils.setActiveMcs($mcs);
	}
	public function getDisplacementDeltas():DisplacementDeltas
	{
		return this._deltas;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onChange($value:Number, $times:Number):Void{}
	public function onStopDrag():Void { }
	public function onThrowEnd():Void { }
	public function onNewWhole($value:Number):Void{}
}