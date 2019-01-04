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
[IconFile("icons/Draggable.png")]
class com.tap4fun.components.ui.Draggable extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "Draggable";
	static var symbolOwner:Object = Draggable;
	var className:String = "Draggable";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var duplicate:Boolean;
	[Inspectable(defaultValue=true)]
	public var snapBack:Boolean;
	[Inspectable(defaultValue=false)]
	public var disappearOnTarget:Boolean;
	
	private var _origX:Number;
	private var _origY:Number;
	private var _onTarget:Boolean;
	public var dropTarget:com.tap4fun.components.ui.DropTarget;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Draggable()
	{
		this.stop();
		this.onLoad = function():Void
		{
			this._origX = this._x;
			this._origY = this._y;
			this.setDisabled(this.disabled);
			this.setDuplicate(this.duplicate);
			this.setSnapBack(this.snapBack);
			this.setDisappearOnTarget(this.disappearOnTarget);
			this.applyEventsHandlers();
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function applyEventsHandlers():Void
	{
		this.onPress = function():Void
		{
			if(this.onDown) this.onDown();
			
			if(this.disabled) return;
			
			this.swapDepths(this._parent.getNextHighestDepth());
			if(this._onTarget)
			{
				//S'il était placé dans un DropTarget
				this.gotoAndPlay("dragged_from_target");
				this.removeFromTarget();
			}
			else
			{
				this.gotoAndPlay("dragged");
			}
			
			if(this._parent["duplicated"]) this._parent["duplicated"].removeMovieClip();
			
			if(this.duplicate)
			{
				//Mode duplicate ON, crée une copie du MovieClip placé à l'origine
				this.duplicateMovieClip("duplicated", this._parent.getNextHighestDepth());
				this.swapDepths(this._parent["duplicated"]);
				var $drag:MovieClip = this._parent["duplicated"];
				$drag.onRelease = $drag.onReleaseOutside = $drag.onPress = function():Void{};
				$drag._x = this._origX;
				$drag._y = this._origY;
			}
			this.startDrag();
			this.onEnterFrame = function():Void
			{
				for(var $mc_name in this._parent)
				{
					//Vérifie s'il y a contact avec un DropTarget
					var $mc:MovieClip = this._parent[$mc_name];
					if($mc instanceof com.tap4fun.components.ui.DropTarget && this.hitTest($mc))
					{
						//Il y a contact!
						if($mc.hitzone)
						{
							if(this.hitTest($mc.hitzone))
							{
								if(!$mc.playing_dragging_over) $mc.gotoAndPlay("dragging_over");
								$mc.playing_dragging_over = true;
								break;
							}
						}
						else
						{
							if(!$mc.playing_dragging_over) $mc.gotoAndPlay("dragging_over");
							$mc.playing_dragging_over = true;
							break;
						}
					}
				}
			};
		};
		this.onRelease = this.onReleaseOutside = function():Void
		{
			if(this.onUp) this.onUp();
			if(this.disabled) return;
			
			this.gotoAndPlay("dropped");
			
			if(this._parent["duplicated"]) this._parent["duplicated"].removeMovieClip();
			this.stopDrag();
			delete this.onEnterFrame;
			
			this.checkOverlapping();
			
			if(!this._onTarget)
			{
				//Relâché en-dehors d'un DropTarget
				if(this.snapBack)
				{
					//Mode snapBack ON
					this.doSnapBack();
				}
			}
			if(this.onDropped)this.onDropped(this._x, this._y);
		};
	}
	private function removeFromTarget():Void
	{
		this._onTarget = false;
		trace("onTarget, Drop Target = " + this.dropTarget);
		var $target:com.tap4fun.components.ui.DropTarget = this.dropTarget;
		$target.removeDroppedIn(this);
		this.dropTarget = undefined;
		if(this.onRemovedFromTarget)this.onRemovedFromTarget($target);
	}
	private function defaultOnAnimationEnd():Void
	{
		this.stop();	
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function doSnapBack():Void
	{
		this._x = this._origX;
		this._y = this._origY;
		if(this._onTarget)
		{
			//S'il était placé dans un DropTarget
			this.gotoAndPlay("focus_out");
			this.removeFromTarget();
		}
	}
	public function checkOverlapping():Void
	{
		for(var $mc_name in this._parent)
		{
			//Vérifie si relâché au-dessus d'un DropTarget
			var $mc:MovieClip = this._parent[$mc_name];
			if(this.hitTest($mc) && $mc != this)
			{
				if(this.onOverlap) this.onOverlap($mc);
			}
			if((!$mc.hitzone && $mc instanceof com.tap4fun.components.ui.DropTarget && this.hitTest($mc))
				|| ($mc.hitzone && $mc instanceof com.tap4fun.components.ui.DropTarget && this.hitTest($mc.hitzone)))
			{
				//Relâché au-dessus d'un DropTarget
				var $mc:com.tap4fun.components.ui.DropTarget = this._parent[$mc_name];
				this.gotoAndPlay("dropped_on_target");
				this._onTarget = true;
				$mc.addDroppedIn(this);
				
				$mc.playing_dragging_over = false;
				$mc.gotoAndPlay("drop");
				
				if(this.disappearOnTarget)
				{
					//Mode disappearOnTarget ON
					if(this.duplicate)
					{
						this._x = this._origX;
						this._y = this._origY;
					}
					else
					{
						this.onAnimationEnd = function():Void
						{
							this._visible = false;
							this.defaultOnAnimationEnd();
							//this.removeMovieClip();
							this.onAnimationEnd = function():Void
							{
								this.defaultOnAnimationEnd();
							};
						};
					}
				}
				else
				{
					//Mode disappearOnTarget OFF
					this._x = $mc._x;
					this._y = $mc._y;
				}
				if(this.onDroppedInTarget) this.onDroppedInTarget($mc);
				break;
			}
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setDisabled($disabled:Boolean):Void
	{
		//trace("Setting disabled to: " + $disabled);
		var $wasDisabled:Boolean = this.disabled;
		this.disabled = $disabled;
		if($wasDisabled && !this.disabled)
		{
			//Was disabled, reanabling it...
			this.gotoAndPlay("activated");
		}
		if(this.disabled)
		{
			//Was enabled, disabling it...
			this.gotoAndPlay("disabled");
		}
	}
	public function setDuplicate($dup:Boolean):Void
	{
		this.duplicate = $dup;
	}
	public function setSnapBack($snap:Boolean):Void
	{
		this.snapBack = $snap;
	}
	public function setDisappearOnTarget($dis:Boolean):Void
	{
		this.disappearOnTarget = $dis;
	}
	public function setDropTarget($dropTarget:com.tap4fun.components.ui.DropTarget):Void
	{
		this.dropTarget = $dropTarget;
	}
	public function getDropTarget():com.tap4fun.components.ui.DropTarget
	{
		return 	this.dropTarget;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onDropped($x:Number, $y:Number):Void{}
	function onDroppedInTarget($target):Void{}
	function onRemovedFromTarget($target):Void{}
	function onOverlap($underlying):Void{}
	function onDown():Void{}
	function onUp():Void{}
}