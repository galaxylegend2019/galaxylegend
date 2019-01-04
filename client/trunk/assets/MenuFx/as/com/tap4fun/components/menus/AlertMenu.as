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
[IconFile("icons/AlertMenu.png")]
class com.tap4fun.components.menus.AlertMenu extends com.tap4fun.components.menus.Menu
{
	static var symbolName:String = "AlertMenu";
	static var symbolOwner:Object = AlertMenu;
	var className:String = "AlertMenu";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	var _selection:String;
	//var lock:MovieClip;
	var description:MovieClip;
	
	[Inspectable(defaultValue=true)]
	public var keepBelowVisible:Boolean;
	[Inspectable(defaultValue=true)]
	public var placeLockBelow:Boolean;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function AlertMenu()
	{
		this.lockBelow();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function onButtonCallback():Void
	{
		this["_alertMenu"]._selection = this._name;
		// trace("button clicked " + this._name);
		_global.popMenu();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function display($description:String):Void
	{
		_selection = null;
		
		// stretch background lock
		/*var localRect:Object = getBounds(this);
		var worldRect:Object = getBounds(_root);
		lock._x = localRect.xMin - worldRect.xMin;
		lock._y = localRect.yMin - worldRect.yMin;
		lock._width = Stage.width;
		lock._height = Stage.height;
		lock.onPress = function():Void {}*/
		
		// collect buttons
		for(var $btn in this)
		{
			//trace(this[$btn]._name);
			if(this[$btn] instanceof com.tap4fun.components.ui.SimpleButton)
			{
				this[$btn]._alertMenu = this;
				this[$btn].onUp = this.onButtonCallback;
				// trace("found button " + $btn);
			}
		}
		
		// set description
		if($description != undefined)
		{
			this.description.text = $description;
		}
		
		_global.pushMenu(this._name);
	}
	
	public function getSelection():String
	{
		return _selection;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	/*public function onFocusIn():Void{}
	public function onFocusOut():Void{}
	public function onShow():Void{}
	public function onHide():Void{}
	public function onPush():Void{}
	public function onPop():Void{}*/
}