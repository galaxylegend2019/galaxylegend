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

class com.tap4fun.input.MultitouchSimulator extends com.tap4fun.components.ComponentBase
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var isMultitouchEmu:Boolean;
	
	//MovieClips
	public var leftHand:MovieClip;
	public var rightHand:MovieClip;
	public var point:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function MultitouchSimulator()
	{
		this.isMultitouchEmu = true;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private function onLoad():Void
	{
		ControllerFlash.stopEmulatingTouch();
		
		//Setting Hands
		this.leftHand.oppositeHand = this.rightHand;
		this.rightHand.oppositeHand = this.leftHand;
		this.leftHand.touchID = 0;
		this.rightHand.touchID = 1;
		
		this.point._visible = false;
		
		var _instance:MovieClip = this;
		_global.getCursorState = function($id) { return _instance.getCursorState($id); };
		_global.getActiveController = function():Number
		{
			return _global.activeController;
		};
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getCursorState($controller:Number):Object
	{
		var $cursor:Object = new Object;
		var $touch = ($controller == 0)? this.leftHand : this.rightHand;
		var $pt:Point = new Point();
		
		$pt.x = $touch._x;
		$pt.y = $touch._y;
		this.localToGlobal($pt);
		
		$cursor.x = $pt.x;
		$cursor.y = $pt.y;
		$cursor.state = $touch.touchState;
		
		//trace("getCursorState #" + $controller + " state=" + $cursor.state);
		return $cursor;
	}
	public function notifyEvent($id:Number, $pressed:Number):Void
	{
		Controller.get($id).notifyCursorState($pressed);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	

}