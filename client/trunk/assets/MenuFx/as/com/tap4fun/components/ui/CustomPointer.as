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
[IconFile("icons/CustomPointer.png")]
class com.tap4fun.components.ui.CustomPointer extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "CustomPointer";
	static var symbolOwner:Object = CustomPointer;
	var className:String = "CustomPointer";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=false)]
	public var followAndPoint:Boolean;
	[Inspectable(defaultValue=1)]
	public var followLength:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function CustomPointer()
	{
		this.setFollowAndPoint(this.followAndPoint);
		this.setFollowLength(this.followLength);
		
		this.start();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function start():Void
	{
		if(Mouse.hide) Mouse.hide();
		if(this.followAndPoint)
		{
			this.onEnterFrame = function():Void
			{
				this.setPosition();
				this.setRotation();
			};
		}
		else
		{
			this.onEnterFrame = function():Void
			{
				this.setPosition();
			};
		}
	}
	private function end():Void
	{
		if(Mouse.show) Mouse.show();
		delete this.onEnterFrame;
	}
	private function setPosition():Void
	{
		var $xDiff:Number = this._parent._xmouse - this._x;
		var $yDiff:Number = this._parent._ymouse - this._y;
		
		this._x += $xDiff/this.followLength;
		this._y += $yDiff/this.followLength;
	}
	private function setRotation():Void
	{
		var rads:Number = Math.atan2(this._parent._ymouse - this._y, this._parent._xmouse - this._x);
		var degrees:Number = rads*180/Math.PI;
		this._rotation = degrees;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setFollowAndPoint($do:Boolean):Void
	{
		this.followAndPoint = $do;
	}
	public function getFollowAndPoint():Boolean
	{
		return this.followAndPoint;
	}
	public function setFollowLength($length:Number):Void
	{
		$length = ($length == undefined || $length < 1)?1:$length;
		this.followLength = $length;
	}
	public function getFollowLength():Number
	{
		return this.followLength;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}