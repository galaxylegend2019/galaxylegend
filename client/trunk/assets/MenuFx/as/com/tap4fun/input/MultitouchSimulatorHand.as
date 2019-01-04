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

class com.tap4fun.input.MultitouchSimulatorHand extends com.tap4fun.components.ComponentBase
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var oppositeHand:MovieClip;
	public var touchID:Number;
	public var touchState:Number;
	
	//MovieClips
	public var pin:MovieClip;
	public var hitzone_drag:MovieClip;
	public var hitzone_press:MovieClip;
	public var hitzone_invert_press:MovieClip;
	public var hitzone_simultaneous_press:MovieClip;
	public var tip_press:MovieClip;
	public var tip_simultaneous_press:MovieClip;
	public var tip_inverted_press:MovieClip;
	public var tip_move:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function MultitouchSimulatorHand()
	{
		this.touchState = 0;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function applyElementsEventsHandlers():Void
	{
		this.hitzone_drag.onRollOver = this.hitzone_press.onRollOver
			= this.hitzone_invert_press.onRollOver = this.hitzone_simultaneous_press.onRollOver
			= function():Void
		{
			this._parent.showTips();
		};
		this.hitzone_drag.onRollOut = this.hitzone_press.onRollOut
			= this.hitzone_invert_press.onRollOut = this.hitzone_simultaneous_press.onRollOut
			= function():Void
		{
			this._parent.hideTips();
		};
		
		this.hitzone_drag.onPress = function():Void
		{
			this._parent.startDrag(false);
			this._parent.hideTips();
		};
		this.hitzone_drag.onRelease = this.hitzone_drag.onReleaseOutside = function():Void
		{
			this._parent.stopDrag();
			this._parent.showTips();
		};
		
		this.hitzone_press.onPress = function():Void
		{
			this._parent.startDrag(false);
			this._parent.hideTips();
			this._parent.onTouchDown();
		};
		this.hitzone_press.onRelease = this.hitzone_press.onReleaseOutside = function():Void
		{
			this._parent.stopDrag();
			this._parent.showTips();
			this._parent.onTouchUp();
		};
		
		this.hitzone_invert_press.onPress = function($stuff):Void
		{
			this._parent.startDrag(false);
			this._parent.hideTips();
			this._parent._parent.point._x = ((this._parent.oppositeHand._x-this._parent._x)/2)+this._parent._x;
			this._parent._parent.point._y = ((this._parent.oppositeHand._y-this._parent._y)/2)+this._parent._y;
			this._parent.onEnterFrame = function():Void
			{
				this.oppositeHand._x = (this._parent.point._x * 2) - this._x;
				this.oppositeHand._y = (this._parent.point._y * 2) - this._y;
			};
			this._parent.onTouchDown();
			this._parent.oppositeHand.onTouchDown();
		};
		
		this.hitzone_invert_press.onRelease = this.hitzone_invert_press.onReleaseOutside = function():Void
		{
			this._parent.stopDrag();
			this._parent.showTips();
			delete this._parent.onEnterFrame;
			this._parent.onTouchUp();
			this._parent.oppositeHand.onTouchUp();
		};
		
		this.hitzone_simultaneous_press.onPress = function():Void
		{
			this._parent.startDrag(false);
			this._parent.hideTips();
			this._parent.onTouchDown();
			this._parent.oppositeHand.onTouchDown();
		};
		
		this.hitzone_simultaneous_press.onRelease = this.hitzone_simultaneous_press.onReleaseOutside = function():Void
		{
			this._parent.stopDrag();
			this._parent.gotoAndStop("up");
			this._parent.showTips();
			this._parent.onTouchUp();
			this._parent.oppositeHand.onTouchUp();
		};
		
		this.pin.onRelease = function():Void
		{
			if(!this.down)
			{
				this.gotoAndStop("down");
				this._parent.onTouchDown();
				this.down = true;
			}
			else
			{
				this.gotoAndStop("up");
				this._parent.onTouchUp();
				this.down = false;
			}
		};
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onLoad():Void
	{
		this.pin.gotoAndStop("up");
		this.pin.down = false;
		this.applyElementsEventsHandlers();
	}
	public function showTips($tip:String):Void
	{
		if($tip==undefined)
		{
			this.tip_press._visible = true;
			this.tip_simultaneous_press._visible = true;
			this.tip_inverted_press._visible = true;
			this.tip_move._visible = true;
		}
	}
	public function hideTips($tip:String):Void
	{
		if($tip==undefined)
		{
			this.tip_press._visible = false;
			this.tip_simultaneous_press._visible = false;
			this.tip_inverted_press._visible = false;
			this.tip_move._visible = false;
		}
	}
	public function onTouchDown():Void
	{
		_global.activeController = this.touchID;
		this.touchState = 1;
		this._parent.notifyEvent(this.touchID, this.touchState);
		this.gotoAndStop("down");
	}
	public function onTouchUp():Void
	{
		_global.activeController = this.touchID;
		this.touchState = 0;
		this._parent.notifyEvent(this.touchID, this.touchState);
		this.gotoAndStop("up");
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	

}