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
dynamic class com.tap4fun.components.ui.Button extends com.tap4fun.components.ui.ButtonLabeled
{
	static var symbolName:String = "Button";
	static var symbolOwner:Object = Button;
	var className:String = "Button";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(name="Action",enumeration="none,pushMenu,switchMenu,popMenu,custom",defaultValue="none")]
	public var action:String;
	[Inspectable(name="Action Custom",defaultValue="")]
	public var customAction:String;
	[Inspectable(name="Action Param",defaultValue="")]
	public var actionParam:String;
	[Inspectable(name="Action Transition",defaultValue="")]
	public var actionTransition:String;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Button()
	{
		if(this.mc_icon)
		{
			if(this.iconFrameLabel != "")
			{
				this.setIconFrameLabel(this.iconFrameLabel);
				//this.mc_icon.gotoAndStop(this.iconFrameLabel);
			}
			else
			{
				this.mc_icon.gotoAndStop("no_icon");
				//if there's no frame labeled "no_icon", at least, stop...
				this.mc_icon.stop();
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function executeMenuAction():Void
	{
		if(this.actionTransition != null && this.actionTransition != undefined && this.actionTransition != "")
		{
			// start sync'ed transition
			_root[this.actionTransition].start(true);
		}
		
		switch(this.action)
		{
			case "pushMenu":
			if(this.actionParam!="")_global.MenusStack.pushMenu(this.actionParam);
			break;
			
			case "popMenu":
			if(this.actionParam!="")_global.MenusStack.popMenu(this.actionParam);
			else _global.MenusStack.popMenu();
			break;
			
			case "switchMenu":
			if(this.actionParam!="")_global.MenusStack.switchMenu(this.actionParam);
			break;
			
			case "custom":
			if(this.customAction!="")
			{
				if(typeof(this._parent[this.customAction]) == "function") this._parent[this.customAction].call(this._parent, this.actionParam);
				else if(typeof(_root[this.customAction]) == "function") _root[this.customAction].call(_root, this.actionParam);
				else _global[this.customAction](this.actionParam);
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//Events Actions
	public function onReleaseAction():Void
	{
		super.onReleaseAction();
		if(!this.disabled)
		{
			this.executeMenuAction();
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
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