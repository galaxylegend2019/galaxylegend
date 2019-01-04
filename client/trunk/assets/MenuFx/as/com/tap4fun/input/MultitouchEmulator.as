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
import com.tap4fun.input.ControllerFlash;
import com.tap4fun.components.ComponentBase;
import com.tap4fun.components.Events;

class com.tap4fun.input.MultitouchEmulator extends com.tap4fun.components.ComponentBase
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static var keyMaxSpeed:Number = 20;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

	public var keySpeed:Number = 1;
	public var point:MovieClip;
	public var touch1:MovieClip;
	public var touch2:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private var _draggedTouch:MovieClip;
	private var _freeTouch:MovieClip;
	private var _tempPos:Point;
	
	private var _cursors:Array;
	
	private static var _instance:MultitouchEmulator;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function MultitouchEmulator()
	{
		_tempPos = new Point();
		
		_cursors = new Array(new Object(), new Object());
		_instance = this;
		_global.getCursorState = function($id) { return _instance.getCursorState($id); };
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onLoad():Void
	{
		//notifyCursorUpdate($x:Number, $y:Number, $pression:Number)
		if(_global.$version == "gameSWF")
		{
			this._visible = false;
			return;
		}
		
		Key.addListener(this);
		ControllerFlash.stopEmulatingTouch();
		
		//Touch
		this.touch1.onPress = function():Void
		{
			this.startDrag(false);
			_parent._draggedTouch = this;
			_parent._freeTouch = _parent.touch2;
			
			_parent._freeTouch._x = (_parent.point._x * 2) - _parent._draggedTouch._x;
			_parent._freeTouch._y = (_parent.point._y * 2) - _parent._draggedTouch._y;
			
			_parent.notifyEvent(0, 1);
			//Also Notify about the inverted following touch...
			_parent.notifyEvent(1, 1);
		};
		this.touch1.onRelease = this.touch1.onReleaseOutside = function():Void
		{
			this.stopDrag();
			_parent._draggedTouch = null;
			_parent.notifyEvent(0, 0);
			_parent.notifyEvent(1, 0);
		};
		this.touch2.onPress = function():Void
		{
			this.startDrag(false);
			_parent._draggedTouch = this;
			_parent._freeTouch = _parent.touch1;
			_parent.notifyEvent(1, 1);
		};
		this.touch2.onRelease = this.touch2.onReleaseOutside = function():Void
		{
			this.stopDrag();
			_parent._draggedTouch = null;
			_parent.notifyEvent(1, 0);
		};
		this.point.onPress = function():Void
		{
			this.startx = this._x;
			this.starty = this._y;
			this.startDrag(false);
			this.onEnterFrame = function()
			{
				_parent.touch1._x += this._x - this.startx;
				_parent.touch1._y += this._y - this.starty;
				_parent.touch2._x += this._x - this.startx;
				_parent.touch2._y += this._y - this.starty;
				this.startx = this._x;
				this.starty = this._y;
			}
		};
		this.point.onRelease = this.touch2.onReleaseOutside = function():Void
		{
			this.stopDrag();
			delete this.onEnterFrame;
		};
	}
	
	private function notifyEvent($id:Number, $pressed:Number):Void
	{
		Controller.get($id).notifyCursorState($pressed);
	}
	
	private function isMultiTouch():Boolean
	{
		return this._draggedTouch == touch1;
	}
	
	private function onEnterFrame():Void
	{
		if(this._draggedTouch != undefined && this._draggedTouch != null)
		{
			if(isMultiTouch())
			{
				this._freeTouch._x = (this.point._x * 2) - this._draggedTouch._x;
				this._freeTouch._y = (this.point._y * 2) - this._draggedTouch._y;
			}
		}
	}
	
	/*private function accelerateKeySpeed():Void
	{
		this.keySpeed = ((this.keySpeed+0.2) > keyMaxSpeed)? keyMaxSpeed : (this.keySpeed+0.2);
	}
	
	private function onKeyDown():Void
	{
		if(Key.isDown(Key.UP) || Key.isDown(Key.DOWN) || Key.isDown(Key.LEFT) || Key.isDown(Key.RIGHT))
		{
			//startAdjusting();
		}
		if(Key.isDown(Key.UP))
		{
			this._freeTouch._y-=this.keySpeed;
			this.accelerateKeySpeed();
		}
		if(Key.isDown(Key.DOWN))
		{
			this._freeTouch._y+=this.keySpeed;
			this.accelerateKeySpeed();
		}
		if(Key.isDown(Key.LEFT))
		{
			this._freeTouch._x-=this.keySpeed;
			this.accelerateKeySpeed();
		}
		if(Key.isDown(Key.RIGHT))
		{
			this._freeTouch._x+=this.keySpeed;
			this.accelerateKeySpeed();
		}
	};
	
	function onKeyUp():Void
	{
		//stopAdjusting();
		this.keySpeed = 1;
	};*/

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function getCursorState($controller:Number):Object
	{
		var $touch = $controller == 0 ? this.touch1 : this.touch2;
		
		this._tempPos.x = $touch._x;
		this._tempPos.y = $touch._y;
		this.localToGlobal(_tempPos);
		
		var $cursor:Object = this._cursors[$controller];
		$cursor.x = this._tempPos.x;
		$cursor.y = this._tempPos.y;
		$cursor.state = ($touch == this._draggedTouch) ? 1 : 0;
		
		if(isMultiTouch())
			$cursor.state = 1;
		
		//trace("getCursorState #" + $controller + " state=" + $cursor.state);
		return $cursor;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

}