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
[IconFile("icons/OnOffSlider.png")]
class com.tap4fun.components.ui.OnOffSlider extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "OnOffSlider";
	static var symbolOwner:Object = OnOffSlider;
	var className:String = "OnOffSlider";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(name="OFF Label", defaultValue="OFF")]
	public var offLabel:String;
	[Inspectable(name="ON Label", defaultValue="ON")]
	public var onLabel:String;
	[Inspectable(defaultValue=false)]
	public var value:Boolean;
	[Inspectable(defaultValue=5)]
	public var slideSpeed:Number;
	
	private var btn_switch:com.tap4fun.components.ui.Button;
	private var bg:MovieClip;
	private var _xSlide:Boolean;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function OnOffSlider()
	{
		this._xSlide = true;
		this.onLoad = function():Void
		{
			if(this.bg._width < this.bg._height)
			{
				this._xSlide = false;
			}
			this.applyEventsHandlers();
			this.setOffLabel(this.offLabel);
			this.setOnLabel(this.onLabel);
			this.setSlideSpeed(this.slideSpeed);
			
			this.defaultOnLoad();
		};
		this.btn_switch.onLoad = function():Void
		{
			this._parent.setValue(this._parent.value);
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function applyEventsHandlers():Void
	{
		this.btn_switch.onPress = function():Void
		{
			_global.forceFlashInputBehavior(true);
			
			this.onEnterFrame = function():Void
			{
				if(this._parent.getXSlide())
				{
					var $nextX:Number = this._parent._xmouse;
					if($nextX > (this._parent.bg._width - (this._width/2)))
					{
						$nextX = this._parent.bg._width - (this._width/2);
					}
					else if($nextX < 0 + (this._width/2))
					{
						$nextX = 0 + (this._width/2);
					}
					this._x = $nextX;
				}
				else
				{
					var $nextY:Number = this._parent._ymouse;
					if($nextY > this._parent.bg._height - (this._height/2))
					{
						$nextY = this._parent.bg._height - (this._height/2);
					}
					else if($nextY < 0 + (this._height/2))
					{
						$nextY = 0 + (this._height/2);
					}
					this._y = $nextY;
				}
			};
			this.onPressAction();
		};
		this.btn_switch.onRelease = this.btn_switch.onReleaseOutside = function():Void
		{
			_global.forceFlashInputBehavior(false);
			delete this.onEnterFrame;
			if(this._parent.getXSlide())
			{
				//X Mode
				this._parent.setValue(this._x > this._parent.bg._width/2);
			}
			else
			{
				//Y Mode
				this._parent.setValue(this._y < this._parent.bg._height/2);	
			}
			this.onReleaseAction();
		};
		
		//ControllerInput
		this.btn_switch.onNavigatorLeft = function():Void
		{
			this._parent.setValue(false);
		};
		this.btn_switch.onNavigatorRight = function():Void
		{
			this._parent.setValue(true);
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getXSlide():Boolean
	{
		return this._xSlide;
	}
	public function setOffLabel($label:String):Void
	{
		this.offLabel = $label;
	}
	public function getOffLabel():String
	{
		return this.offLabel;
	}
	public function setOnLabel($label:String):Void
	{
		this.onLabel = $label;
	}
	public function getOnLabel():String
	{
		return this.onLabel;
	}
	public function setSlideSpeed($speed:Number):Void
	{
		this.slideSpeed = $speed;
	}
	public function getSlideSpeed():Number
	{
		return this.slideSpeed;
	}
	public function setValue($value:Boolean):Void
	{
		var $oldValue = this.value;
		this.value = $value;
		
		this.btn_switch.setLabel(this.value?this.getOnLabel():this.getOffLabel());
		
		if(this.getXSlide())
		{
			//X Mode
			if(!this.value)
			{
				//OFF
				this.btn_switch.onEnterFrame = function():Void
				{
					this._x-=this._parent.getSlideSpeed();
					if(this._x <= 0 + (this._width/2))
					{
						this._x = 0 + (this._width/2);
						delete this.onEnterFrame;
					}
				};
			}
			else
			{
				//ON
				this.btn_switch.onEnterFrame = function():Void
				{
					this._x+=this._parent.getSlideSpeed();
					if(this._x >= this._parent.bg._width - (this._width/2))
					{
						this._x = this._parent.bg._width - (this._width/2);
						delete this.onEnterFrame;
					}
				};
			}
		}
		else
		{
			//Y Mode
			if(!this.value)
			{
				//OFF
				this.btn_switch.onEnterFrame = function():Void
				{
					this._y+=this._parent.getSlideSpeed();
					if(this._y >= this._parent.bg._height - (this._height/2))
					{
						this._y = this._parent.bg._height - (this._height/2);
						delete this.onEnterFrame;
					}
				};
			}
			else
			{
				//ON
				this.btn_switch.onEnterFrame = function():Void
				{
					this._y-=this._parent.getSlideSpeed();
					if(this._y <= 0 + (this._height/2))
					{
						this._y = 0 + (this._height/2);
						delete this.onEnterFrame;
					}
				};
			}
		}
		
		
		if($oldValue != this.value && this.onChange) this.onChange(this.getValue());
	}
	public function getValue():Boolean
	{
		if(this.getXSlide())
		{
			return (this.btn_switch._x > this.bg._width/2)
		}
		else
		{
			return (this.btn_switch._y < this.bg._height/2);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}