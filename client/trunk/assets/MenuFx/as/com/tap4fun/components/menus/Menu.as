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
** AutoLock-Below option
*/
//The image must measure 18 pixels square, and you must save it in PNG format. It must be bit with alpha transparency, and the upper left pixel must be transparent to support masking.
[IconFile("icons/Menu.png")]

//Write the next two lines of code: [Event("onLoadComplete")] and [Event("onProgress")]. The [Event("YourEventName")] represents the events that the component will trigger during the loading process (onProgress) and when the loading process is completed (onLoadComplete).
[Event("onLoadComplete")]
[Event("onProgress")]

dynamic class com.tap4fun.components.menus.Menu extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "Menu";
	static var symbolOwner:Object = Menu;
	var className:String = "Menu";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	[Inspectable(defaultValue="")]
	public var firstFocus:String;
    
    [Inspectable(defaultValue=false)]
	public var keepBelowVisible:Boolean;
	[Inspectable(defaultValue=false)]
	public var placeLockBelow:Boolean;
	
	var stackIndex:Number;
	public var nextMenu:MovieClip;
	
	private var lock:MovieClip;
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Menu()
	{
		if(_global.MenusStack)
		{
			this.setFirstFocus(this.firstFocus);
			this.setKeepBelowVisible(this.keepBelowVisible);
			this.setPlaceLockBelow(this.placeLockBelow);
			this.removeLock();
			_global.MenusStack.registerMenu(this);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function placeLock():Void
	{
		// stretch lock
		var localRect:Object = getBounds(this);
		var worldRect:Object = getBounds(_root);
		this.lock._x = localRect.xMin - worldRect.xMin;
		this.lock._y = localRect.yMin - worldRect.yMin;
		this.lock._width = Stage.width;
		this.lock._height = Stage.height;
		this.lock.onPress = function():Void {};
		this.lock.useHandCursor = false;
		this.lock._visible = true;
	}
	private function removeLock():Void
	{
		delete this.lock.onPress;
		this.lock._x = -100;
		this.lock._y = -100;
		this.lock._width = 1;
		this.lock._height = 1;
		this.lock._visible = false;
	}
	private function disableChilds($target:MovieClip, $disable:Boolean):Void
	{
		for(var $mc_name:String in $target)
		{
			var $current = $target[$mc_name];
			if($current instanceof MovieClip)
			{
				if($current.setDisabled)
				{
					//trace($mc_name + " disable = " + $disable);
					$current.setDisabled($disable);
				}
				this.disableChilds($current, $disable);
			}
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function giveFocusToFirstFocus():Void
	{
		//trace("Giving focus to FirstFocus-> " + this.getFirstFocus());
		if(this.getFirstFocus().onRollOver) this.getFirstFocus().onRollOver();
	}
	public function lockBelow():Void
	{
		this.placeLock();
	}
	public function unlockBelow():Void
	{
		this.removeLock();
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setStackIndex($index:Number):Void
	{
		this.stackIndex = $index;
	}
	public function getStackIndex():Number
	{
		var $stack = _global.MenusStack.getStack();
		for(var $i:Number = 0; $i<$stack.length; $i++)
		{
			if($stack[$i] == this)
			{
				if(_global.MenusStack.debug) trace(this._name + " is at index " + $i);
				return $i;
			}
		}
		return null;
	}
	public function setDisabled($disabled:Boolean):Void
	{
		var $previousDisabled = this.disabled;
		this.disabled = $disabled;
		
		//Changing state
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
		this.disableChilds(this, $disabled);
	}
	public function setFirstFocus($first:String):Void
	{
		this.firstFocus = $first;
	}
	public function getFirstFocus():MovieClip
	{
		if(this.firstFocus == "" || !this.firstFocus) return undefined;
		
		if(this.firstFocus.indexOf(".")>-1)
		{
			//MovieClip in container(s)
			var $path:Array = this.firstFocus.split(".");
			var $firstFocus:MovieClip = this;
			
			for(var $i:Number = 0; $i < $path.length; $i++)
			{
				var $current = $path[$i];
				$firstFocus = $firstFocus[$current];
			}
			return $firstFocus;
		}
		else
		{
			return this[this.firstFocus];
		}
	}
	
	public function setKeepBelowVisible($visible:Boolean):Void
	{
		this.keepBelowVisible = $visible;
	}
	public function getKeepBelowVisible():Boolean
	{
		return this.keepBelowVisible;
	}
	public function setPlaceLockBelow($lock:Boolean):Void
	{
		this.placeLockBelow = $lock;
		if(this.placeLockBelow)
		{
			this.lockBelow();
		}
		else
		{
			this.removeLock();
		}
	}
	public function getPlaceLockBelow():Boolean
	{
		return this.placeLockBelow;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onFocusIn():Void{}
	public function onFocusOut():Void{}
	/*public function onShow():Void{}
	public function onHide():Void{}*/
	public function onPush():Void{}
	public function onPop():Void{}
}