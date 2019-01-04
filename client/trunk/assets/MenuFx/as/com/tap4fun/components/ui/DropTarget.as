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
import com.tap4fun.StaticFunctions;

[IconFile("icons/DropTarget.png")]
class com.tap4fun.components.ui.DropTarget extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "DropTarget";
	static var symbolOwner:Object = DropTarget;
	var className:String = "DropTarget";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var _droppedIn:Array;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DropTarget()
	{
		this.stop();
		this._droppedIn = new Array();
		this.onLoad = function():Void
		{
			this.applyEventsHandlers();
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function applyEventsHandlers():Void
	{
		
	}
	private function defaultOnAnimationEnd():Void
	{
		this.stop();
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function addDroppedIn($mc:com.tap4fun.components.ui.Draggable):Void
	{
		//trace("Adding " + $mc._name + " to " + this._name);
		this._droppedIn.push($mc);
		//$mc.setDropTarget(this);
		$mc.dropTarget = this;
		//trace("Stack = " + this._droppedIn);
		if(this.onDroppedIn) this.onDroppedIn($mc);
	}
	public function removeDroppedIn($mc:com.tap4fun.components.ui.Draggable):Boolean
	{
		trace("Removing " + $mc._name);
		var $pre_length:Number = this._droppedIn.length;
		this._droppedIn = StaticFunctions.removeElement(this._droppedIn, $mc);
		
		if($pre_length != this._droppedIn.length)
		{
			if(this.onRemovedFrom) this.onRemovedFrom($mc);
			return true;
		}
		return false;
		/*for(var $i:Number = 0; $i<this._droppedIn.length; $i++)
		{
			var $cur = this._droppedIn[$i];
			if($cur == $mc)
			{
				this._droppedIn = StaticFunctions.removeElementAtIndex(this._droppedIn, $i);
				if(this.onRemovedFrom) this.onRemovedFrom($mc);
				return true;
			}	
		}*/
		return false;
		if(this.onRemovedFrom) this.onRemovedFrom($mc);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getDroppedIn():Array
	{
		return this._droppedIn;	
	}
	public function setDroppedIn($drop:Array):Void
	{
		this._droppedIn = $drop;	
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onDroppedIn($draggable):Void{}
	function onRemovedFrom($draggable):Void{}
}