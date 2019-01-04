/*								MultitouchGenericUsage
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
import com.tap4fun.input.Controller;
import com.tap4fun.components.Events;
import com.tap4fun.StaticFunctions;
import com.tap4fun.input.CursorMix;
import flash.geom.Point;

class com.tap4fun.input.MultitouchGenericUsage extends com.tap4fun.components.ComponentBase
{
	
	private var touchs:Array;
	private var broadcastingMove:Array;
	private var touchsActiveTargets:Array;
	
	static private var i:Number = -1;
	
	static public var TOUCH_DOWN = ++i;
	static public var TOUCH_UP = ++i;
	static public var TOUCH_MOVE = ++i;
	
	static public var PRESS = ++i;
	static public var RELEASE = ++i;
	static public var RELEASE_OUTSIDE = ++i;
	
	//Update frequency for overriden methods displacing MovieClips
	static public var INTERVAL_TIME = 33.3333333333;
	
	//Not used, just for overridenGetMouseCoord, referring to mc's _touch;
	private var _touch:Object;
	
	function MultitouchGenericUsage()
	{
		touchs = new Array();
		broadcastingMove = new Array();
		touchsActiveTargets = new Array(null, null);
		
		Controller.addListener(Events.CURSOR_UP, this, onCursorEvent);
		Controller.addListener(Events.CURSOR_DOWN, this, onCursorEvent);
	}
	
	private function broadcastMove():Void
	{
		for(var $i:Number = 0; $i<broadcastingMove.length; $i++)
		{
			//trace("On touch Move " + broadcastingMove[$i].getID());
			//checkContactAndCallAction(broadcastingMove[$i], _root, PRESS);
		}
	}
	private function startBroadcastingMove($controller):Void
	{
		this.broadcastingMove.push($controller);
		if(!this.onEnterFrame)
		{
			this.onEnterFrame = broadcastMove;
		}
	}
	private function stopBroadcastingMove($controller):Void
	{
		StaticFunctions.removeElement(broadcastingMove, $controller);
	}
	private function onCursorEvent($controller, $state):Void
	{
		trace("Received cursor event from ctrl " + $controller.getID() + " with state " + (($state==1)?"DOWN":"UP") + " at x = " + $controller.getCursor().x + "; y = " + $controller.getCursor().y);
		if($state == 1)
		{
			var $touchInfos:Object = $controller.getCursor();
			checkContactAndCallAction($controller, _root, PRESS);
			startBroadcastingMove($controller);
		}
		else if($state == 0)
		{
			stopBroadcastingMove($controller);
			checkContactAndCallAction($controller, _root, RELEASE);
		}
	}
	
	
	private function checkIfInMCBounds($touch:Object, $mc:MovieClip):Boolean
	{
		var $touchInfos:Object = $touch.getCursor();
		//trace("hitTest performed on " + $mc._name);
		var $isInBounds:Boolean = false;
		
		var $bounds:Object = $mc.getBounds();
		var $ptMin:Object = {x:$bounds.xMin, y:$bounds.yMin};
		var $ptMax:Object = {x:$bounds.xMax, y:$bounds.yMax};
		/*$mc.localToGlobal($ptMin);
		$mc.localToGlobal($ptMax);*/
		
		//trace("xMin = " + $ptMin.x + "; yMin = " + $ptMin.y + "; xMax = " + $ptMax.x + "; yMax = " + $ptMax.y);
		
		//$mc.globalToLocal($touchInfos);
		$isInBounds = ($touchInfos.x > $ptMin.x && $touchInfos.x < $ptMax.x && $touchInfos.y > $ptMin.y && $touchInfos.y < $ptMax.y);
		
		//trace("Contact with " + $mc._name + " at " + $touchInfos.x + ", " + $touchInfos.y + " = " + $mc.hitTest($touchInfos.x, $touchInfos.y, false));
		
		//return $isInBounds;
				
		return $mc.hitTest($touchInfos.x, $touchInfos.y, false);
	}
	
	private function checkContactAndCallAction($touch:Object, $mc:MovieClip, $action:Number):Boolean
	{
		var $actionFound:Boolean = true;
		//trace("Checking " + $mc._name);
		//Release...
		if($action == RELEASE)
		{
			if(!this.touchsActiveTargets[$touch.getID()]) return;
			if(checkIfInMCBounds($touch, this.touchsActiveTargets[$touch.getID()]))
			{
				executeAction($touch, this.touchsActiveTargets[$touch.getID()], RELEASE);
			}
			else
			{
				executeAction($touch, this.touchsActiveTargets[$touch.getID()], RELEASE_OUTSIDE);
			}
			this.touchsActiveTargets[$touch.getID()] = null;
			return;
		}
		
		//Press...
		for(var $child in $mc)
		{
			if(!$mc[$child]._visible || $mc[$child].ignoreMultitouch || ($mc[$child].getDisabled && $mc[$child].getDisabled())) continue;
			if($mc[$child] instanceof MovieClip && !($mc[$child] instanceof com.tap4fun.input.MultitouchEmulator) && !($mc[$child].isMultitouchEmu))
			{
				if(checkIfInMCBounds($touch, $mc[$child]))
				{
					if($action == PRESS)
					{
						$actionFound = executeAction($touch, $mc[$child], $action);
						if($actionFound)
						{
							this.touchsActiveTargets[$touch.getID()] = $mc[$child];
							trace("--------ACTION FOUND ON " + $child + " exiting loop...");
							return true;
						}
					}
					
					if(!$actionFound)
					{
						//Check children...
						if(checkContactAndCallAction($touch, $mc[$child], $action))
						{
							return true;
						}
					}
					//return;
				}
				else
				{
					
				}
			}
		}
		return false;
	}
	private function executeAction($touch:Object, $mc:MovieClip, $action:Number):Boolean
	{
		//Check if contains events handlers...
		var $containsHandler = (typeof($mc.onPress) == "function" || typeof($mc.onRelease) == "function" || typeof($mc.onRollOver) == "function" || typeof($mc.onRollOut) == "function" || typeof($mc.onReleaseOutside) == "function");
		//trace($mc._name + " contains handler? " + $containsHandler);
		if(!$containsHandler) return false;
		
		switch($action)
		{
			case PRESS:
				$mc.gotoAndPlay("pressed");
				if($mc.onPress)
				{
					trace("Pressing " + $mc._name);
					$mc._touch = $touch;
					overrideMouseDependentMethods($mc);
					$mc.onPress();
				}
				//else return false;
			break;
			
			case RELEASE:
				$mc.gotoAndPlay("released");
				if($mc.onRelease)
				{
					trace("Releasing " + $mc._name);
					$mc.onRelease();
				}
				$mc._touch = null;
				//else return false;
			break;
			
			case RELEASE_OUTSIDE:
				$mc.gotoAndPlay("released");
				if($mc.onReleaseOutside)
				{
					$mc.onReleaseOutside();
				}
				$mc._touch = null;
				//else return false;
			break;
			
			default:
			//return false;
		}
		return true;
	}
	
	private function overrideMouseDependentMethods($mc:MovieClip):Void
	{
		//Overriding getCursorCoord
		if($mc.getCursorCoord)
		{
			CursorMix.mixMultitouchCursorMethods($mc);
		}
		if($mc._parent.getCursorCoord)
		{
			$mc._parent._touch = $mc._touch;
			CursorMix.mixMultitouchCursorMethods($mc._parent);
		}
		if($mc._parent._parent.getCursorCoord)
		{
			$mc._parent._parent._touch = $mc._touch;
			CursorMix.mixMultitouchCursorMethods($mc._parent._parent);
		}
		
		$mc.startDrag = function($lockCenter:Boolean, $left:Number, $top:Number, $right:Number, $bottom:Number):Void
		{
			this._xmouse = this._touch.getCursor().x;
			this._ymouse = this._touch.getCursor().y;
			
			//trace("Starting to drag xmouse = " + this._xmouse + " ymouse = " + this._ymouse);
			this._lockCenter = ($lockCenter!=undefined)?$lockCenter:false;
			if(!this._lockCenter)
			{
				this._xOffset = this._x - this._touch.getCursor().x;
				this._yOffset = this._y - this._touch.getCursor().y;
			}
			else
			{
				this._xOffset = 0;
				this._yOffset = 0;
			}
			this._intervalID = setInterval(this, "onMultiTouchInterval", MultitouchGenericUsage.INTERVAL_TIME); 
			this.onMultiTouchInterval = function():Void
			{
				//Should use setInterval instead to leave enter frame...
				var $pt:Object = {x:this._touch.getCursor().x, y:this._touch.getCursor().y};
				this._x = $pt.x + this._xOffset;
				this._y = $pt.y + this._yOffset;
			};
		};
		$mc.stopDrag = function():Void
		{
			this.clearInterval(this._intervalID);
			delete this.onMultiTouchInterval;
		};
	}
}


