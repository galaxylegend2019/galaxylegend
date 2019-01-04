/*								MultitouchPinch
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
import flash.geom.Point;
import com.tap4fun.input.Controller;
import com.tap4fun.components.ComponentBase;
import com.tap4fun.components.Events;

class com.tap4fun.components.ui.MultitouchPinch extends com.tap4fun.components.ComponentBase
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var _point:Point;
	private var _pt:Point;
	private var _touchCount = 0;
	private var _hasOnlyOneTouchDown:Boolean;
	private var _onlyTouchDownId:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function MultitouchPinch()
	{
		_pt = new Point();
		this._hasOnlyOneTouchDown = false;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

	private function calculateVectorLength($touch0:Object, $touch1:Object):Number
	{
		var xDis = $touch1.x - $touch0.x;
		var yDis = $touch1.y - $touch0.y;
		return(Math.sqrt((xDis * xDis) + (yDis * yDis)));
	}
	
	private function getRotation($touch0:Object, $touch1:Object):Number
	{
		var $angle:Number;
		var _diffX = $touch1.x - $touch0.x;
		var _diffY = $touch1.y - $touch0.y;
		$angle = Math.atan2(_diffY, _diffX);
		$angle = $angle * 180 / Math.PI;
		return $angle;
	}
	
	private function startAdjusting():Void
	{
		
		var $touch0:Object = _global.getCursorState(0);
		var $touch1:Object = _global.getCursorState(1);
		
		if($touch0.state != $touch1.state)
		{
			trace(".....................Only one touch...............................");
			this.stopAdjusting();
			return;
		}
		if(this.onStartPinching) this.onStartPinching({length:this.calculateVectorLength($touch0, $touch1), angle:this.getRotation($touch0, $touch1)});
		
		this.onEnterFrame = function():Void
		{
			var $touch0:Object = _global.getCursorState(0);
			var $touch1:Object = _global.getCursorState(1);
			
			if(this.onChange) this.onChange({length:this.calculateVectorLength($touch0, $touch1), angle:this.getRotation($touch0, $touch1)});
		};
	}
	
	private function stopAdjusting():Void
	{
		delete this.onEnterFrame;
	}
	
	private function isInBounds($mc:MovieClip, $x:Number, $y:Number):Boolean
	{
		//return $mc.hitTest($x, $y);
		
		//trace("Contact with " + $mc._name + " at " + $touchInfos.x + ", " + $y + " = " + $mc.hitTest($touchInfos.x, $y, true));
		var $isInBounds:Boolean = false;
		
		var $bounds:Object = $mc.getBounds();
		var $ptMin:Object = {x:$bounds.xMin, y:$bounds.yMin};
		var $ptMax:Object = {x:$bounds.xMax, y:$bounds.yMax};
		$mc.localToGlobal($ptMin);
		$mc.localToGlobal($ptMax);
		
		$isInBounds = ($x > $ptMin.x && $x < $ptMax.x && $y > $ptMin.y && $y < $ptMax.y);
		
		return $isInBounds;
	}
	
	private function resetTouchCount():Void
	{
		var $touch0:Object = _global.getCursorState(0);
		var $touch1:Object = _global.getCursorState(1);
		this._touchCount = 0;
		this._touchCount += $touch0.state > 0 ? 1 : 0;
		this._touchCount += $touch1.state > 0 ? 1 : 0;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//public function onCursorEvent($controller, $state):Void
	public function onPress():Void
	{
		if(this.getDisabled()) return;
		
		var oldTouchCount:Number = this._touchCount;
		
		var $touch0:Object = _global.getCursorState(0);
		var $touch1:Object = _global.getCursorState(1);
		
		this._hasOnlyOneTouchDown = ($touch0.state != $touch1.state);
		this._onlyTouchDownId = this._hasOnlyOneTouchDown?(  ($touch0.state==1)?0:1  ):null;
		
		if(this._hasOnlyOneTouchDown)
		{
			trace(".....................Only one touch down...............................");
		}
		
		
		this.resetTouchCount();
			
		var $pinching:Boolean = this.onEnterFrame != null && this.onEnterFrame != undefined;
		
		/*if(this.onCursorStateChange)
		{
			this.onCursorStateChange($controller.getCursor());
		}*/
		
		if(this._touchCount > 1 && this._touchCount != oldTouchCount)
		{
			//var $touch:Object = $controller.getCursor();
			//if($pinching || this.isInBounds(this, $touch.x, $touch.y))
			//{
				this.startAdjusting();
			//}
		}
		else if($pinching && this._touchCount < 2)
		{
			this.stopAdjusting();
		}
	}
	public function onRelease():Void
	{
		if(this._onlyTouchDownId!=null && this.onSingleTouch)
		{
			var $touch:Object = _global.getCursorState(this._onlyTouchDownId);
			var $x:Number = $touch.x;
			var $y:Number = $touch.y;
			this.onSingleTouch($x, $y);
		}
		this.resetTouchCount();
		this.stopAdjusting();
	}
	public function onReleaseOutside():Void
	{
		this.resetTouchCount();
		this.stopAdjusting();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onChange($obj:Object):Void
	{
		//$obj contains members length (in pixels) and angle (in degrees)
	}
	public function onStartPinching($obj:Object):Void
	{
		
	}
	/*public function onCursorStateChange($obj:Object):Void
	{
		
	}*/
	public function onSingleTouch($obj:Object):Void
	{
		
	}
	
}