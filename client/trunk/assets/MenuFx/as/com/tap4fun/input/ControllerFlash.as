/*								Key
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
import com.tap4fun.input.Controller;
import flash.geom.Point;

class com.tap4fun.input.ControllerFlash
{
	private var _activeController:Number = 0;
	private var _keyMapping:Array = new Array();
	
	private static var _mouseListener:Object = new Object();

	function ControllerFlash()
	{
		//trace("ControllerFlash");
	
		Key.addListener(this);
		
		_keyMapping[Key.UP]		= Controller.DPAD_UP;
		_keyMapping[Key.DOWN]	= Controller.DPAD_DOWN;
		_keyMapping[Key.LEFT]	= Controller.DPAD_LEFT;
		_keyMapping[Key.RIGHT]	= Controller.DPAD_RIGHT;
		
		_keyMapping[Key.SPACE]	= Controller.PS3_CROSS;
		_keyMapping[98]			= Controller.PS3_CROSS; // numpad 2
		_keyMapping[104]		= Controller.PS3_TRIANGLE; // numpad 8
		_keyMapping[100]		= Controller.PS3_SQUARE; // numpad 4
		_keyMapping[102]		= Controller.PS3_CIRCLE; // numpad 6
		
		this.emulateTouchUsingMouse();
	}

	public function onKeyDown():Void
	{
		//trace(Key.getCode());
		Controller.get(_activeController).notifyKeyState(_keyMapping[Key.getCode()], 1);
	}
	
	public function onKeyUp():Void
	{
		Controller.get(_activeController).notifyKeyState(_keyMapping[Key.getCode()], 0);
	}
	
	public function setActiveController($id:Number):Void
	{
		_activeController = $id;
	}
	
	public function emulateTouchUsingMouse():Void
	{
		if (_global.getCursorState)
		{
			//Emulator or simulator found, exiting...
			return;
		}
		
		_global.renderTouch = _root.createEmptyMovieClip("renderTouch", _root.getNextHighestDepth());
		
		//Natives
		_global.getCursorState = function($id)
		{
			if ($id == 0)
			{
				return {  x:_root._xmouse, y:_root._ymouse, state:(_global.firstCursorIsDown)?1:0 };
			}
			else
			{
				if (Key.isDown(Key.UP)) _global.startPoint.y--;
				if (Key.isDown(Key.DOWN)) _global.startPoint.y++;
				if (Key.isDown(Key.LEFT)) _global.startPoint.x--;
				if (Key.isDown(Key.RIGHT)) _global.startPoint.x++;
				
				var pt2:Point = new Point(_global.startPoint.x * 2 - _root._xmouse, _global.startPoint.y * 2 - _root._ymouse);
				if (_global.secondCursorIsDown)
				{
					_global.renderTouch.clear();
					_global.renderTouch.lineStyle(1, 0x00FF00, 70);
					_global.renderTouch.moveTo(_global.startPoint.x, _global.startPoint.y);
					_global.renderTouch.lineTo(pt2.x, pt2.y);
				}
				return {  x:pt2.x, y:pt2.y, state:(_global.secondCursorIsDown)?1:0 };
			}
		};
		
		_global.getActiveController = function():Number { return _global.activeController};
		
		
		//Mouse listener, invokes
		_mouseListener.onMouseDown = function():Void
		{
			_global.renderTouch.clear();
			_global.activeController = 0;
			
			_global.firstCursorIsDown = true;
			
			_global.startPoint = new Point(_root._xmouse+Stage.width/8, _root._ymouse+Stage.height/8);
			
			Controller.get(_global.activeController).notifyCursorState(1);
			if (Key.isDown(Key.SHIFT))
			{
				_global.secondCursorIsDown = true;
				_global.activeController = 1;
				Controller.get(_global.activeController).notifyCursorState(1);
			}
		};
		_mouseListener.onMouseUp = function():Void
		{
			_global.renderTouch.clear();
			var $controller:Number = _global.activeController;
			_global.activeController = null;
			
			if (_global.secondCursorIsDown)
			{
				_global.secondCursorIsDown = false;
				Controller.get(1).notifyCursorState(0);
			}
			_global.firstCursorIsDown = false;
			Controller.get(0).notifyCursorState(0);
			
		};
		Mouse.addListener(_mouseListener);
	}
	public static function stopEmulatingTouch():Void
	{
		Mouse.removeListener(_mouseListener);
	}
}