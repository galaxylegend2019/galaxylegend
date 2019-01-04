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
import com.tap4fun.components.Events;

[IconFile("icons/Button.png")]
dynamic class com.tap4fun.components.ui.SimpleButton extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "SimpleButton";
	static var symbolOwner:Object = SimpleButton;
	var className:String = "SimpleButton";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	var hitzone:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function SimpleButton()
	{
		this.setDisabled(this.disabled);
		this.setCanGetFocus(this.canGetFocus);
		
		this.applyEventsHandlers();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function applyEventsHandlers():Void
	{
		this.onLoad = function():Void
		{
			this.buttonOnLoad();
		};
		if(this.hitzone)
		{
			if(!this.hitzone.onRollOver) this.hitzone.onRollOver = function():Void
			{
				this._parent.onRollOverAction();
			};
			if(!this.hitzone.onRollOut) this.hitzone.onRollOut = function():Void
			{
				this._parent.onRollOutAction();
			};
			if(!this.hitzone.onPress) this.hitzone.onPress = function():Void
			{
				this._parent.onPressAction();
			};
			if(!this.hitzone.onRelease) this.hitzone.onRelease = function():Void
			{
				this._parent.onReleaseAction();
			};
			if(!this.hitzone.onReleaseOutside) this.hitzone.onReleaseOutside = function():Void
			{
				this._parent.onReleaseOutsideAction();
			};
		}
		else
		{
			if(!this.onRollOver) this.onRollOver = function():Void
			{
				this.onRollOverAction();
			};
			if(!this.onRollOut) this.onRollOut = function():Void
			{
				this.onRollOutAction();
			};
			if(!this.onPress) this.onPress = function():Void
			{
				this.onPressAction();
			};
			if(!this.onRelease) this.onRelease = function():Void
			{
				this.onReleaseAction();
			};
			if(!this.onReleaseOutside) this.onReleaseOutside = function():Void
			{
				this.onReleaseOutsideAction();
			};
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function giveFocus():Void
	{
		if(_global.componentWithFocus != this && this.canGetFocus)
		{
			//Remove focus from previous component with focus
			if(_global.componentWithFocus)
			{
				_global.componentWithFocus.removeFocus();
			}
			//Give focus to the new one
			if(this.onFocusIn) this.onFocusIn();
			_global.componentWithFocus = this;
			this.gotoAndPlay("focus_in");
		}
	}
	public function removeFocus():Void
	{
		if(_global.componentWithFocus == this)
		{
			if(this.onFocusOut) this.onFocusOut();
			_global.componentWithFocus = null;
			if(!this.disabled) this.gotoAndPlay("focus_out");
		}
	}
	
	//Events Actions
	public function buttonOnLoad():Void
	{
		this.defaultOnLoad();
	}
	public function onRollOverAction():Void
	{
		if(!this.disabled)
		{
			this.giveFocus();
			this.broadcastEvent(Events.ROLL_OVER);
			if(this.onOver) this.onOver();
		}
		else
		{
			this.gotoAndPlay("disabled");
		}
	}
	public function onRollOutAction():Void
	{
		if(!this.disabled)
		{
			this.removeFocus();
			
			this.broadcastEvent(Events.ROLL_OUT);
			if(this.onOut) this.onOut();
			if(this.onLeave) this.onLeave();
		}
	}
	public function onPressAction():Void
	{
		if(!this.disabled)
		{
			this.giveFocus();
			this.gotoAndPlay("pressed");
			this.broadcastEvent(Events.PRESS);
			if(this.onDown)this.onDown();
		}
		else
		{
			this.gotoAndPlay("disabled");
		}
	}
	public function onReleaseAction():Void
	{
		if(!this.disabled)
		{
			this.gotoAndPlay("released");
			this.broadcastEvent(Events.RELEASE);
			if(this.onUp) this.onUp();
			this.onAnimationEnd = function():Void
			{
				this.stop();
				this.gotoAndPlay("clicked");
				this.broadcastEvent(Events.CLICK);
				if(this.onClicked) this.onClicked();
				this.onAnimationEnd = this.defaultOnAnimationEnd;
			};
		}
		else
		{
			this.gotoAndPlay("disabled");
		}
	}
	public function onReleaseOutsideAction():Void
	{
		if(!this.disabled)
		{
			this.removeFocus();
			
			this.broadcastEvent(Events.RELEASE_OUTSIDE);
			if(this.onUpOutside) this.onUpOutside();
			if(this.onLeave) this.onLeave();
		}
		else
		{
			this.gotoAndPlay("disabled");
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setDisabled($disabled:Boolean):Void
	{
		var $previousDisabled = this.disabled;
		this.disabled = $disabled;
		this.useHandCursor = !$disabled;
		
		if($previousDisabled != $disabled)
		{
			if($disabled)
			{
				this.gotoAndPlay("disabled");
				if(this.onDisabled) this.onDisabled();
			}
			else
			{
				this.gotoAndPlay("activated");
				if(this.onActivated) this.onActivated();
			}
		}
	}
	public function getDisabled():Boolean
	{
		return this.disabled;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onOver():Void{}
	function onOut():Void{}
	function onUp():Void{}
	function onDown():Void{}
	function onFocusIn():Void{}
	function onFocusOut():Void{}
	function onUpOutside():Void{}
	function onClicked():Void{}
	function onLeave():Void{}
	function onDisabled():Void{}
	function onActivated():Void{}
}