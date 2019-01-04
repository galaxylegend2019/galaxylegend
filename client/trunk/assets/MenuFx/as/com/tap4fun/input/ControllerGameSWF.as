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

class com.tap4fun.input.ControllerGameSWF
{
	function ControllerGameSWF()
	{
		//trace("ControllerGameSWF");
	
		_global.onReceiveKeyState = this.onReceiveKeyState;
		_global.onReceiveControllerState = this.onReceiveControllerState;
		_global.onReceiveCursorState = this.onReceiveCursorState;
	}

	public function onReceiveKeyState($controller:Number, $key:Number, $state:Number):Void
	{
		Controller.get($controller).notifyKeyState($key, $state);
	}
	
	public function onReceiveControllerState($controller:Number, $enabled:Boolean):Void
	{
		Controller.get($controller).setEnabled($enabled);
	}
	
	public function onReceiveCursorState($controller:Number, $state:Number):Void
	{
		Controller.get($controller).notifyCursorState($state);
	}
}