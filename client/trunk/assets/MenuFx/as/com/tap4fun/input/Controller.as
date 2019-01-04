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
import com.tap4fun.input.ControllerFlash;
import com.tap4fun.input.ControllerGameSWF;
import com.tap4fun.components.ComponentBase;
import com.tap4fun.components.Events;

class com.tap4fun.input.Controller extends com.tap4fun.components.ComponentBase
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	// PS3-Specific Buttons
	public static var PS3_CROSS:Number		= 0x01;
	public static var PS3_CIRCLE:Number		= 0x02;
	public static var PS3_SQUARE:Number		= 0x03;
	public static var PS3_TRIANGLE:Number	= 0x04;
	
	// XBOX-Specific Buttons
	public static var XBOX_A:Number			= 0x01;
	public static var XBOX_B:Number			= 0x02;
	public static var XBOX_X:Number			= 0x03;
	public static var XBOX_Y:Number			= 0x04;
	
	// Wii-Specific Buttons
	public static var WII_A:Number			= 0x01;
	public static var WII_B:Number			= 0x02;
	public static var WII_1:Number			= 0x03;
	public static var WII_2:Number			= 0x04;
	
	// Generic Buttons
	public static var BTN_A:Number			= 0x01;
	public static var BTN_B:Number			= 0x02;
	public static var BTN_C:Number			= 0x03;
	public static var BTN_D:Number			= 0x04;
	
	// Analog-Left
	public static var LANALOG_CLICK:Number	= 0x10;
	public static var LANALOG_ANGLE:Number	= 0x11;
	public static var LANALOG_AMOUNT:Number	= 0x12;
	
	// Analog-Right
	public static var RANALOG_CLICK:Number	= 0x20;
	public static var RANALOG_ANGLE:Number	= 0x21;
	public static var RANALOG_AMOUNT:Number	= 0x22;
	
	// Buttons
	public static var L1:Number				= 0x30;
	public static var L2:Number				= 0x31;
	public static var R1:Number				= 0x32;
	public static var R2:Number				= 0x33;
	public static var SELECT:Number			= 0x34;
	public static var START:Number			= 0x35;
	
	// DPad
	public static var DPAD_UP:Number		= 0x40;
	public static var DPAD_DOWN:Number		= 0x41;
	public static var DPAD_LEFT:Number		= 0x42;
	public static var DPAD_RIGHT:Number		= 0x43;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private var _id = 0;
	private var _keyState:Array;
	private var _enabled:Boolean = false;
	
	// static
	private static var _controllers:Array = new Array(new Controller(0), new Controller(1), new Controller(2), new Controller(3));
	private static var _inputLock:MovieClip;
	private static var _lockedComponent:MovieClip;
	
	// ControllerFlash instanciated only outside of gameswf (flash player)
	private static var _controllerFlash:ControllerFlash = _global.$version != "gameSWF" ? new ControllerFlash() : new ControllerGameSWF();
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function Controller($id)
	{
		_id = $id;
		_keyState = new Array();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function notifyKeyState($key:Number, $state:Number):Void
	{
		//trace("notifyKeyState " + $key);
	
		var $oldState = getState($key);
		
		//if($state != $oldState)
		if(!isLocked())
		{
			if($state != 0)
				broadcastEvent(Events.KEY_DOWN, $key, $state);
			else if($state == 0)
				broadcastEvent(Events.KEY_UP, $key, $state);
			
			broadcastEvent(Events.KEY_CHANGED, $key, $state);
		}
	
		_keyState[$key] = $state;
	}
	
	public function notifyCursorState($state:Number):Void
	{
		if(!isLocked())
		{
			//trace("notifyCursorState " + this._id + " state=" + $state);
			
			if($state != 0)
			{
				//trace("CURSOR_DOWN " + this._id);
				broadcastEvent(Events.CURSOR_DOWN, $state);
			}
			else if($state == 0)
			{
				//trace("CURSOR_UP " + this._id + " pression=" + $pression);
				broadcastEvent(Events.CURSOR_UP, $state);
			}
		}
	}
	
	public function setEnabled($enabled:Boolean):Void
	{
		_enabled = $enabled;
	}
	
	public function isEnabled():Boolean
	{
		return _enabled;
	}
	
	public function isDown($key:Number):Boolean
	{
		var $state:Number = _keyState[$key];
		
		if($state != undefined)
			return $state != 0;
		else
			return false;
	}
	
	public function getState($key:Number):Number
	{
		var $state:Number = _keyState[$key];
		
		if($state != undefined)
			return $state;
		else
			return 0;
	}
	
	public function getID():Number
	{
		return this._id;
	}
	
	public function getCursor():Object
	{
		return _global.getCursorState(this._id);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public static function addListener($evt, $listener:Object, $fctn:Function):Void
	{
		for(var $i:Number = 0; $i < _controllers.length; $i++)
			_controllers[$i].addListener($evt, $listener, $fctn);
	}
	
	public static function removeListener($evt, $listener:Object, $fctn:Function):Void
	{
		for(var $i:Number = 0; $i < _controllers.length; $i++)
			_controllers[$i].removeListener($evt, $listener, $fctn);
	}
	
	public static function get($id:Number):Controller
	{
		return _controllers[$id];
	}
	
	public static function setLocked($locked:Boolean):Void
	{
		trace("setLocked " + $locked);
		
		if(_inputLock == undefined)
		{
			_inputLock = _root.createEmptyMovieClip("controllerLock", _root.getNextHighestDepth());
			_inputLock.createTextField("label", 1, 0, 0, 150, 20); //.text = "lock";
		}
		
		if($locked)
		{
			// set callbacks to null (mainly to avoid onRollOut while lock has focus)
			_lockedComponent = _global.componentWithFocus;
			_lockedComponent.onRollOver = _lockedComponent.onRollOut = _lockedComponent.onPress = _lockedComponent.onRelease = _lockedComponent.onReleaseOutside = null;
			
			// stretch lock
			var localRect:Object = _inputLock.getBounds(_inputLock);
			var worldRect:Object = _inputLock.getBounds(_root);
			_inputLock._x = localRect.xMin - worldRect.xMin;
			_inputLock._y = localRect.yMin - worldRect.yMin;
			_inputLock._width = Stage.width;
			_inputLock._height = Stage.height;
			_inputLock.onPress = function():Void {};
		}
		else
		{
			// restore callbacks
			if(_lockedComponent)
				_lockedComponent.applyEventsHandlers();
		}
		
		_inputLock._visible = $locked;
	}
	
	public static function isLocked():Boolean
	{
		return (_inputLock != undefined) && _inputLock._visible;
	}
}