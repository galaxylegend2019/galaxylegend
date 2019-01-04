/*								Multitouch Emulator
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

class com.tap4fun.components.ui.MultitouchControl extends com.tap4fun.components.ComponentBase
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

	[Inspectable(defaultValue="")]
	private var target:String;
	
	[Inspectable(defaultValue=true)]
	private var translateEnabled:Boolean = true;
	
	[Inspectable(defaultValue=true)]
	private var scaleEnabled:Boolean = true;
	
	[Inspectable(defaultValue=true)]
	private var rotateEnabled:Boolean = true;

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private var _targetMC:MovieClip;
	private var _minimumScale:Number = 0.1;
	private var _maximumScale:Number = 100;
		
	private var _point:Point;
	private var _baseScale:Number;
	private var _baseLength:Number;
	private var _baseAngle:Number;
	private var _baseTranslate:Number;
	private var _pt:Point;
	private var _touchCount = 0;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function MultitouchControl()
	{
		_pt = new Point();
		
		Controller.addListener(Events.CURSOR_UP, this, onCursorEvent);
		Controller.addListener(Events.CURSOR_DOWN, this, onCursorEvent);
		
		setTarget(_parent[target]);
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
	
	private function getScale($touch0:Object, $touch1:Object):Number
	{
		var $scale:Number = 1;
		$scale = this.calculateVectorLength($touch0, $touch1) / this._baseLength;
		
		if($scale <  this._minimumScale)
		{
			$scale = this._minimumScale;
		}
		else if($scale >  this._maximumScale)
		{
			$scale = this._maximumScale;
		}
		
		return $scale;
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
	
	private function reset():Void
	{
		this._targetMC._xscale = this._targetMC._yscale = 100;
		this._targetMC._rotation = 0;
	}
	
	private function startAdjusting():Void
	{
		var $touch0:Object = _global.getCursorState(0);
		var $touch1:Object = _global.getCursorState(1);
		
		// set other point at same place if only one touch
		if($touch0.state == 0)
			$touch0 = $touch1;
		else if($touch1.state == 0)
			$touch1 = $touch0;
		
		this._point = new Point(($touch0.x + $touch1.x) / 2, ($touch0.y + $touch1.y) / 2);
		this._baseScale = this._targetMC._xscale / 100;
		this._baseLength = this.calculateVectorLength($touch0, $touch1);
		this._baseAngle = this._targetMC._rotation - this.getRotation($touch0, $touch1);
		
		//trace(this._point.x + "," + this._point.y);
		
		this.onEnterFrame = function():Void
		{
			var $touch0:Object = _global.getCursorState(0);
			var $touch1:Object = _global.getCursorState(1);
			
			//trace("update " + this._targetMC);
			//trace(this._point.x + "," + this._point.y);
			
			if(this._touchCount == 2)
			{
				_pt.x = this._point.x;
				_pt.y = this._point.y;
				
				this._targetMC.globalToLocal(_pt);
				
				if(this.scaleEnabled)
				{
					var scale:Number = this.getScale($touch0, $touch1) * this._baseScale;
					this._targetMC._xscale = this._targetMC._yscale = 100 * scale;
				}
				
				if(this.rotateEnabled)
				{
					var angle:Number = this.getRotation($touch0, $touch1) + this._baseAngle;
					this._targetMC._rotation = angle;
				}
				
				this._targetMC.localToGlobal(_pt);
			
				this._targetMC._x -= (_pt.x - this._point.x);
				this._targetMC._y -= (_pt.y - this._point.y);
			}
			else
			{
				if(this.translateEnabled)
				{
					var $touch:Object = $touch0.state > 0 ? $touch0 : $touch1;
					this._targetMC._x += $touch.x - this._point.x;
					this._targetMC._y += $touch.y - this._point.y;
					this._point.x = $touch.x;
					this._point.y = $touch.y;
				}
			}
		};
	}
	
	private function stopAdjusting():Void
	{
		delete this.onEnterFrame;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setTarget($target:MovieClip):Void
	{
		this._targetMC = $target;
	}
	
	public function onCursorEvent($controller, $state):Void
	{
		var $id:Number = $controller._id;
		
		if($id < 0 || $id > 1) return;
		
		var oldTouchCount:Number = this._touchCount;
		
		var $touch0:Object = _global.getCursorState(0);
		var $touch1:Object = _global.getCursorState(1);
		
		this._touchCount = 0;
		this._touchCount += $touch0.state > 0 ? 1 : 0;
		this._touchCount += $touch1.state > 0 ? 1 : 0;
		
		//trace("_touchCount=" + this._touchCount);
		
		var adjusting:Boolean = this.onEnterFrame != null && this.onEnterFrame != undefined;
		
		//trace("onCursorUpdate adjusting=" + adjusting + " touchCount=" + touchCount);
		
		if(this._touchCount > 0 && this._touchCount != oldTouchCount)
		{
			var $touch:Object = $controller.getCursor();
			if(adjusting || this.hitTest($touch.x, $touch.y))
			{
				//trace("startAdjusting");
				this.startAdjusting();
			}
		}
		else if(adjusting && this._touchCount < 2)
		{
			this.stopAdjusting();
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	

}