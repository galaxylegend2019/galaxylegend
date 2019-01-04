/*								VSlider
**
*********Properties****************************Description******

*********Methods****************************Description*******

*********Events*****************************Description*******

*********TODO*************************************************
*/
/*[IconFile("icons/ValueBar.png")]*/
class com.tap4fun.components.ui.ScrollbarsEnvironment extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "ScrollbarsEnvironment";
	static var symbolOwner:Object = ScrollbarsEnvironment;
	var className:String = "ScrollbarsEnvironment";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	/*[Inspectable(defaultValue=true)]
	public var determineIfScrollbarsNeeded:Boolean;*/
	
	//MovieClips
	public var scrollbarH_bg:MovieClip;
	public var scrollbarH_handle:MovieClip;
	public var scrollbarW_bg:MovieClip;
	public var scrollbarW_handle:MovieClip;
	public var content:MovieClip;
	public var limits:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ScrollbarsEnvironment()
	{
		this.content._x = this.limits._x;
		this.content._y = this.limits._y;
		if(this.getHasScrollH())
		{
			/*if(this.content._height < this.limits._height)
			{
				this.scrollbarH_bg._visible = false;
				this.scrollbarH_handle._visible = false;
			}*/
			this.scrollbarH_handle._y = this.scrollbarH_bg._y + (this.scrollbarH_handle._height/2);
		}
		if(this.getHasScrollW())
		{
			/*if(this.content._width < this.limits._width)
			{
				this.scrollbarW_bg._visible = false;
				this.scrollbarW_handle._visible = false;
			}*/
			this.scrollbarW_handle._x = this.scrollbarW_bg._x + (this.scrollbarW_handle._width/2);
		}
		this.applyMovieClipsEventsHandlers();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function applyMovieClipsEventsHandlers():Void
	{
		if(this.getHasScrollH())
		{
			this.scrollbarH_handle.onPress = function():Void
			{
				_global.forceFlashInputBehavior(true);
				
				this.gotoAndStop("pressed");
				this.onEnterFrame = function():Void
				{
					this._y = this._parent._ymouse;
					if(this._y < this._parent.scrollbarH_bg._y + (this._height/2))  this._y = this._parent.scrollbarH_bg._y + (this._height/2);
					else if(this._y > this._parent.scrollbarH_bg._y + this._parent.scrollbarH_bg._height - (this._height/2)) this._y = this._parent.scrollbarH_bg._y + this._parent.scrollbarH_bg._height - (this._height/2);
					this._parent.positionContentY();
				};
			};
			this.scrollbarH_handle.onRelease = this.scrollbarH_handle.onReleaseOutside = function():Void
			{
				_global.forceFlashInputBehavior(false);
				
				this.gotoAndStop("released");
				delete this.onEnterFrame;
			};
		}
		if(this.getHasScrollW())
		{
			this.scrollbarW_handle.onPress = function():Void
			{
				_global.forceFlashInputBehavior(true);
				
				this.gotoAndStop("pressed");
				this.onEnterFrame = function():Void
				{
					this._x = this._parent._xmouse;
					if(this._x < this._parent.scrollbarW_bg._x + (this._width/2))  this._x = this._parent.scrollbarW_bg._x + (this._width/2);
					else if(this._x > this._parent.scrollbarW_bg._x + this._parent.scrollbarW_bg._width - (this._width/2)) this._x = this._parent.scrollbarW_bg._x + this._parent.scrollbarW_bg._width - (this._width/2);
					this._parent.positionContentX();
				};
			};
			this.scrollbarW_handle.onRelease = this.scrollbarW_handle.onReleaseOutside = function():Void
			{
				_global.forceFlashInputBehavior(false);
				
				this.gotoAndStop("released");
				delete this.onEnterFrame;
			};
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function updateHandlesPosition():Void
	{
		if(this.getHasScrollH())
		{
			this.scrollbarH_handle._y = (((this.content._y - this.limits._y) * (this.scrollbarH_bg._height - this.scrollbarH_handle._height)) / ((this.content._height - this.limits._height) * -1)) + (this.scrollbarH_handle._height/2) + this.scrollbarH_bg._y;
		}
		if(this.getHasScrollW())
		{
			this.scrollbarW_handle._x = (((this.content._x - this.limits._x) * (this.scrollbarW_bg._width - this.scrollbarW_handle._width)) / ((this.content._width - this.limits._width) * -1)) + (this.scrollbarW_handle._width/2) + this.scrollbarW_bg._x;
		}
	}
	public function positionContentY():Void
	{
		if(this.content._height > this.limits._height)
		{
			this.content._y = ((this.scrollbarH_handle._y - this.scrollbarH_bg._y - (this.scrollbarH_handle._height/2)) * (this.content._height - this.limits._height) * -1 / (this.scrollbarH_bg._height - this.scrollbarH_handle._height)) + this.limits._y;
		}
	}
	public function positionContentX():Void
	{
		if(this.content._width > this.limits._width)
		{
			this.content._x = ((this.scrollbarW_handle._x - this.scrollbarW_bg._x - (this.scrollbarW_handle._width/2)) * (this.content._width - this.limits._width) * -1 / (this.scrollbarW_bg._width - this.scrollbarW_handle._width)) + this.limits._x;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getHasScrollH():Boolean
	{
		return (this.scrollbarH_bg != undefined && this.scrollbarH_handle != undefined);
	}
	public function getHasScrollW():Boolean
	{
		return (this.scrollbarW_bg != undefined && this.scrollbarW_handle != undefined);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}