/*								Joystick
**
** Le MovieClip doit comporter:
**	-Un MovieClip nommé "stick" avec reference points au centre ayant comme frame labels: "out", "over", "press", "release"
**	-Un MovieClip nommé "bg" avec reference points au centre (servant de base pour établir les limites (width))
**
** Exemple:
** 
** 	myJoystick.onMoving = function():Void
** 	{
** 		this.hero._rotation = this.angle;
** 		this.hero._x += this.xDisplacement*5;
** 		this.hero._y += this.yDisplacement*5;
** 		this.hero.speedtrail._alpha = this.velocity*100;
** 		this.stick_under._rotation = this.angle;
** 	};
** 	myJoystick.onEnterDrag = function():Void
** 	{
** 		hero.gotoAndStop("speedtrail");
** 	};
** 	myJoystick.onQuitDrag = function():Void
** 	{
** 		hero.gotoAndStop("nospeedtrail");
** 	};
**
*********Properties****************************Description******
**
*********Methods****************************Description*******
**getAngle():Number								//
**getVelocity():Number							//
**getXDisplacement():Number						//
**getYDisplacement():Number						//
**
*********Events*****************************Description*******
**onSetValue									//
**onChange										//
**onLowestValue									//
**onHighestValue								//
**onMoving										//
**onEnterDrag										//
**onQuitDrag										//
**
*********TODO*************************************************
*/
[IconFile("icons/Joystick.png")]

import com.tap4fun.input.CursorMix;

class com.tap4fun.components.ui.Joystick extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "Joystick";
	static var symbolOwner:Object = Joystick;
	var className:String = "Joystick";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=1)]
	public var speed:Number = 1;
	
	private var stick:MovieClip;
	private var bg:MovieClip;
	private var _limitX:Number;
	private var _limitY:Number;
	public var _touch:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Joystick()
	{
		this._limitX = this._limitY = this.bg._width/2;
		this.setSpeed(this.speed);
		
		this.setElementsEventsHandlers();
		CursorMix.mixCursorMethods(this);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getCursorCoord($coord:String, $from:String):Number {return 0;}
	
	private function setElementsEventsHandlers():Void
	{
		//Stick States
		this.stick.gotoAndStop("out");
		this.stick.onRollOut = function():Void
		{
			this.gotoAndStop("out");
		};
		this.stick.onRollOver = function():Void
		{
			this.gotoAndStop("over");
		};
		this.stick.onPress = function():Void
		{
			this._touch = _global.getActiveController();
			this._parent._touch = this._touch;
			this.gotoAndStop("press");
			this.enterDrag();
		};
		this.stick.onRelease = function():Void
		{
			this.gotoAndStop("release");
			this.quitDrag();
		};
		this.stick.onReleaseOutside = function():Void
		{
			this.gotoAndStop("out");
			this.quitDrag();
		};
		
		//CursorMix.mixStdCursorMethods(this.stick);
		CursorMix.mixCursorMethods(this.stick);
		
		//Setting stick functions
		this.stick.enterDrag = function():Void
		{
			this.xoffset = this.getCursorCoord("x");
			this.yoffset = this.getCursorCoord("y");
			
			//Temp patch for pressing a button with another finger while moving joystick
			/*this._oldXTarget = this.getCursorCoord("x", "_parent")-this.xoffset;
			this._oldYTarget = this.getCursorCoord("y", "_parent")-this.yoffset;*/
			
			this.onEnterFrame = function():Void 
			{
				var $nextX:Number = this.getCursorCoord("x", "_parent")-this.xoffset;
				var $nextY:Number = this.getCursorCoord("y", "_parent")-this.yoffset;
				
				//Temp patch for pressing a button with another finger while moving joystick
				//if(Math.abs($nextX - this._oldXTarget) > this._width*2 || Math.abs($nextY - this._oldYTarget) > this._width*2)return;
				this._oldXTarget = $nextX;
				this._oldYTarget = $nextY;
				
				if ($nextX>=(this._parent._limitX * -1) && $nextX<=(this._parent._limitX))
				{
					this._x = $nextX;
				}
				else
				{
					if ($nextX<(this._parent._limitX * -1))
					{
						this._x = this._parent._limitX * -1;
					}
					else
					{
						this._x = this._parent._limitX;
					}
				}
				if ($nextY>=(this._parent._limitY * -1) && $nextY<=(this._parent._limitY))
				{
					this._y = $nextY;
				}
				else
				{
					if ($nextY<(this._parent._limitY * -1))
					{
						this._y = this._parent._limitY * -1;
					}
					else
					{
						this._y = this._parent._limitY;
					}
				}
				if(this._parent.getVelocity()>1)
				{
					var $rad_angle:Number = this._parent.getMouseAngleRadians();
					var $deg_angle:Number = $rad_angle * 180/Math.PI;
					this._y = this._parent._limitY * Math.sin($rad_angle);
					this._x = this._parent._limitX * Math.cos($rad_angle);
				}
				this._parent.onMoving();
			};
			this._parent.onEnterDrag();
		};
		this.stick.quitDrag = function():Void 
		{
			this._x = 0;
			this._y = 0;
			this._parent.onMoving();
			delete this.onEnterFrame;
			this._parent.onQuitDrag();
		};
	}
	private function getMouseAngle():Number 
	{
		var $angle:Number = 0;
		$angle = Math.atan2(this.getCursorCoord("y"), this.getCursorCoord("x"))*180/Math.PI;
		return $angle;
	}
	private function getMouseAngleRadians():Number 
	{
		var $angle:Number = 0;
		$angle = Math.atan2(this.getCursorCoord("y"), this.getCursorCoord("x"));
		return $angle;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getSpeed():Number
	{
		return this.speed;
	}
	public function setSpeed($speed:Number):Void
	{
		this.speed = $speed;
	}
	public function getAngle():Number
	{
		var $angle:Number = 0;
		$angle = Math.atan2(this.stick._y, this.stick._x)*180/Math.PI;
		return $angle;
	};
	public function getVelocity():Number
	{
		var $velocity:Number = 0;
		$velocity = Math.sqrt(this.stick._x * this.stick._x + this.stick._y * this.stick._y)/this._limitX;
		return $velocity;
	};
	public function getXDisplacement():Number
	{
		return (this.stick._x / (this.bg._width/2)) * this.speed;
	};
	public function getYDisplacement():Number
	{
		return (this.stick._y / (this.bg._height/2)) * this.speed;
	};
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onMoving():Void{}
	public function onEnterDrag():Void{}
	public function onQuitDrag():Void{}
}