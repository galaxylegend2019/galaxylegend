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
[IconFile("icons/MenuStack.png")]
import com.tap4fun.components.Events;
import com.tap4fun.input.Controller;
class com.tap4fun.components.menus.Transition extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "Transition";
	static var symbolOwner:Object = Transition;
	var className:String = "Transition";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private var _currentMenu:MovieClip = null;
	private var _nextMenu:MovieClip = null;
	
	private var currentRef:MovieClip;
	private var nextRef:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Transition()
	{
		this.currentRef._visible = false;
		this.nextRef._visible = false;
		this._visible = false;
		_global.MenusStack.addListener(Events.CHANGE_MENU, this, this.onChangeMenu);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private function onChangeMenu():Void
	{
		trace("onChangeMenu");
		
		// replace onAnimationEnd to wait
		if(this._currentMenu != null)
		{
			this._nextMenu = _global.MenusStack.getCurrentMenu();
			// reset transforms
			this._nextMenu.transform.colorTransform = new flash.geom.ColorTransform();
			this._nextMenu.transform.matrix = new flash.geom.Matrix();
			
			this._currentMenu._transitionOnAnimationEnd = this._currentMenu.onAnimationEnd;
			//this._currentMenu._waitingTransition = false;
			this._currentMenu.onAnimationEnd = function():Void
			{
				// menu anim ended
				//this._waitingTransition = true;
			};
		}
		this.onAnimationEnd = animDone;
	}
	
	private function animSync():Void
	{
		trace("animSync");
		
		this._currentMenu._transitionOnAnimationEnd();
		delete this._currentMenu._transitionOnAnimationEnd;
	}
	
	private function animDone():Void
	{
		trace("animDone");
		
		Controller.setLocked(false);
		this._visible = false;
		this.defaultOnAnimationEnd();
		this._currentMenu = null;
		this._nextMenu = null;
		delete this.onEnterFrame;
	}
	
	private function update():Void
	{
		// update transforms
		this._currentMenu.transform = this.currentRef.transform;
		this._nextMenu.transform = this.nextRef.transform;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function start($sync:Boolean):Void
	{
		if($sync)
		{
			this._currentMenu = _global.MenusStack.getCurrentMenu();
			
			if(this.currentRef != undefined && this.nextRef != undefined)
			{
				this.onEnterFrame = update;
			}
			
			trace(this._target + ".start " + this._currentMenu);
		}
		else
		{
			this._currentMenu = null;
		}
		
		this._visible = true;
		this.gotoAndPlay("start");
		Controller.setLocked(true);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////

}