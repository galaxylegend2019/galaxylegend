/*								ComponentName
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

class com.tap4fun.components.Events
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private static var index:Number = -1;
	public static var ROLL_OVER:Number = ++index;
	public static var ROLL_OUT:Number = ++index;
	public static var PRESS:Number = ++index;
	public static var RELEASE:Number = ++index;
	public static var RELEASE_OUTSIDE:Number = ++index;
	public static var CLICK:Number = ++index;
	public static var ENTER_FRAME:Number = ++index;
	public static var CHANGE:Number = ++index;
	
	public static var ANIMATION_END:Number = ++index;
	public static var READY:Number = ++index;
	
	//Menu Stack
	public static var CHANGE_MENU:Number = ++index;
	public static var POP_MENU:Number = ++index;
	public static var PUSH_MENU:Number = ++index;
	public static var FOCUS_IN:Number = ++index;
	public static var FOCUS_OUT:Number = ++index;
	public static var DISABLE:Number = ++index;
	public static var ENABLE:Number = ++index;
	
	//Inputs
	public static var KEY_DOWN:Number = ++index;
	public static var KEY_UP:Number = ++index;
	public static var KEY_CHANGED:Number = ++index;
	
	//Multitouch
	public static var CURSOR_DOWN:Number = ++index;
	public static var CURSOR_UP:Number = ++index;
}