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
import com.tap4fun.StaticFunctions;

class com.tap4fun.components.ComponentBase extends MovieClip
{
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var canGetFocus:Boolean = true;
	[Inspectable(defaultValue=false)]
	public var disabled:Boolean;
	
	private var _listeners:Array;
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ComponentBase()
	{
		this._listeners = new Array();
		this.onAnimationEnd = this.defaultOnAnimationEnd;
		if(!this.onLoad) this.onLoad = function():Void
		{
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function defaultOnAnimationEnd():Void
	{
		this.stop();
		this.broadcastEvent(Events.ANIMATION_END);
	}
	public function defaultOnLoad():Void
	{
		//trace(this._name + " on Load");
		this.broadcastEvent(Events.READY);
		if(this.onReady)this.onReady();
	}
	private function broadcastEvent($evt, $arg1, $arg2, $arg3, $arg4, $arg5):Void
	{
		if(this._listeners[$evt])
		{
			//trace("We have "+ this._listeners[$evt].length +" listeners to event number " + $evt);
			for(var $i:Number=0; $i<this._listeners[$evt].length; $i++)
			{
				//if(_global.MenusStack.debug) trace("Listener found!" + this._listeners[$evt][$i].listener);
				var $cur = this._listeners[$evt][$i];
				$cur.fctn.call($cur.listener, this, $arg1, $arg2, $arg3, $arg4, $arg5);
			}
		}
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function addListener($evt, $listener:Object, $fctn:Function):Void
	{
		//if(_global.MenusStack.debug)trace("Adding event listener to " + this._name + " event " + $evt);
		if(!this._listeners[$evt]) this._listeners[$evt] = new Array();
		var $obj = new Object();
		$obj.listener = $listener;
		$obj.fctn = $fctn;
		this._listeners[$evt].push($obj);
	}
	
	public function removeListener($evt, $listener:Object, $fctn:Function):Void
	{
		for(var $i:Number = 0; $i<this._listeners[$evt].length; $i++)
		{
			var $cur = this._listeners[$evt][$i];
			if($cur.listener == $listener && $cur.fctn == $fctn)
			{
				this._listeners[$evt] = StaticFunctions.removeElementAtIndex(this._listeners[$evt], $i);
				if(this._listeners[$evt].length <= 0) delete this._listeners[$evt];
				return;
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setCanGetFocus($can):Void
	{
		this.canGetFocus = $can;
	}
	public function getCanGetFocus():Boolean
	{
		return this.canGetFocus;
	}
	public function setDisabled($disabled:Boolean):Void
	{
		var $previousDisabled = this.disabled;
		this.disabled = $disabled;
		
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
	function onAnimationEnd():Void{} // Don't use this please! It is mine!
	public function onChange():Void{}
	public function onDisabled():Void{}
	public function onActivated():Void{}
	public function onReady():Void{}
	
}