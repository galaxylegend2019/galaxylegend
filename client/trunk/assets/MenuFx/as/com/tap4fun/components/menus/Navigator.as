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
[IconFile("icons/Navigator.png")]
import com.tap4fun.input.Controller;
import com.tap4fun.components.Events;
import com.tap4fun.components.menus.MenusStack;

class com.tap4fun.components.menus.Navigator
{
	static var symbolName:String = "Navigator";
	static var symbolOwner:Object = Navigator;
	var className:String = "Navigator";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var _components:Array = new Array();
	public var _updateComponents:Boolean = true;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function Navigator()
	{
		Controller.addListener(Events.KEY_DOWN, this, onKeyDown);
		Controller.addListener(Events.KEY_UP, this, onKeyUp);

		if(_global.MenusStack)
		{
			_global.MenusStack.addListener(Events.CHANGE_MENU, this, this.onNewContext);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	private function collectComponents($context:MovieClip):Void
	{
		//trace($context._target);
	
		var $i:String;
		for($i in $context)
		{
			var $mc:MovieClip = $context[$i];
		
			if($mc != undefined && $mc._parent == $context && $mc._visible)
			{
				//trace("   " + $mc._target);
				if($mc instanceof com.tap4fun.components.ui.SimpleButton)
				{
					$mc._worldBounds = $mc.getBounds(_root);
					_components.push($mc);
					//trace("   found component " + $mc._target);
				}
				
				collectComponents($context[$i]);
			}
		}
	}
	
	function debug($line):Void
	{
		//trace($line);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onNewContext($menusStack, $menu):Void
	{
		if($menu == undefined || $menu == null) return;
		//if(_global.MenusStack.debug) trace("Navigator Context changed to... " + $menu._name);
		
		this.updateLayout();
	}
	private function componentCaptureInput($key:Number):Boolean
	{
		switch($key)
		{
			case Controller.DPAD_UP:
				if(_global.componentWithFocus.onNavigatorUp)
				{
					_global.componentWithFocus.onNavigatorUp();
					return true;
				}
				break;
			case Controller.DPAD_DOWN:
				if(_global.componentWithFocus.onNavigatorDown)
				{
					_global.componentWithFocus.onNavigatorDown();
					return true;
				}
				break;
			case Controller.DPAD_LEFT:
				if(_global.componentWithFocus.onNavigatorLeft)
				{
					_global.componentWithFocus.onNavigatorLeft();
					return true;
				}
				break;
			case Controller.DPAD_RIGHT:
				if(_global.componentWithFocus.onNavigatorRight)
				{
					_global.componentWithFocus.onNavigatorRight();
					return true;
				}
				break;
		}
		return false;
	}
	public function onKeyDown($controller, $key, $state):Void
	{
		if($key == Controller.PS3_CROSS && _global.componentWithFocus)
		{
			if(_global.componentWithFocus.hitzone) _global.componentWithFocus.hitzone.onPress();
			else _global.componentWithFocus.onPress();
		}
		else
		{
			updateLayoutIfNeeded();
			if(!this.componentCaptureInput($key))
			{
				updateNavigation($key == Controller.DPAD_UP, $key == Controller.DPAD_DOWN, $key == Controller.DPAD_LEFT, $key == Controller.DPAD_RIGHT);
			}
		}	
	}

	public function onKeyUp($controller, $key, $state):Void
	{
		if($key == Controller.PS3_CROSS && _global.componentWithFocus)
		{
			if(_global.componentWithFocus.hitzone) _global.componentWithFocus.hitzone.onRelease();
			else _global.componentWithFocus.onRelease();
		}
	}
	
	function setFocus($mc:MovieClip):Void
	{
		if(_global.componentWithFocus == $mc) return;
		
		if(_global.componentWithFocus != null)
		{
			if(_global.componentWithFocus.onRollOut != null || _global.componentWithFocus.hitzone.onRollOut != null)
			{
				if(_global.componentWithFocus.hitzone) _global.componentWithFocus.hitzone.onRollOut();
				else _global.componentWithFocus.onRollOut();
			}
		}
			
		if($mc != null)
		{
			if($mc.hitzone)
			{
				if($mc.hitzone.onRollOver) $mc.hitzone.onRollOver();
				else _global.componentWithFocus = $mc;
			}
			else
			{
				if($mc.onRollOver) $mc.onRollOver();
				else _global.componentWithFocus = $mc;
			}
		}
			
		/*var $bounds:Object = _global.componentWithFocus.getBounds(_root);
		_root.focus.swapDepths(_root.getNextHighestDepth());
		_root.focus._x = $bounds.xMin;
		_root.focus._y = $bounds.yMin;
		_root.focus._width = $bounds.xMax - $bounds.xMin;
		_root.focus._height = $bounds.yMax - $bounds.yMin;*/
	}
	
	function updateLayout():Void
	{
		_updateComponents = true;
	}
	
	function updateLayoutIfNeeded():Void
	{
		if(_updateComponents)
		{
			_components = new Array();
			
			if(_global.MenusStack)
			{
				var $stack:Array = _global.MenusStack.stack;
				for(var $i:Number = $stack.length - 1; $i >= 0; $i--)
				{
					if($stack[$i]._visible)
						collectComponents($stack[$i]);
					
					if($stack[$i].lock._visible)
						break;
				}
			}
			else
			{
				// scan everything
				collectComponents(_root);
			}
			_updateComponents = false;
		}		
	}
	
	function updateNavigation($up, $down, $left, $right):Void
	{
		if(_global.componentWithFocus == null)
			setFocus(_components[0]);
		
		//debug(_global.componentWithFocus);
		
		if(!_global.componentWithFocus)
			return;
		
		var $horizontal:Boolean = $left || $right;
		var $scaleX:Number = $horizontal ? 1.0 : 2.0;
		var $scaleY:Number = $horizontal ? 2.0 : 1.0;
		//debug("scaleX=" + $scaleX);
		//debug("scaleY=" + $scaleY);

		var $focusPos:Object = _global.componentWithFocus._worldBounds;
		//if($focusPos == null || $focusPos == undefined)
		//	return;
		
		$focusPos.x = ($focusPos.xMin + $focusPos.xMax)/2; //_global.componentWithFocus._x;
		$focusPos.y = ($focusPos.yMin + $focusPos.yMax)/2; //_global.componentWithFocus._y;
		//debug("focus=" + _global.componentWithFocus._target + ": " + $focusPos.x + ", " + $focusPos.y);
		
		//-------------------------------
		// check direction edge
		//-------------------------------
		var $focusEdge:Object = new Object();
		$focusEdge.x = $focusPos.x;
		$focusEdge.y = $focusPos.y;
		//debug("focusEdge: " + $focusEdge.x + ", " + $focusEdge.y);
		
		if($up)
			$focusEdge.y = $focusPos.yMin;
		else if($down)
			$focusEdge.y = $focusPos.yMax;
		else if($left)
			$focusEdge.x = $focusPos.xMin;
		else if($right)
			$focusEdge.x = $focusPos.xMax;
		//-------------------------------
		
		var $nearestUp:Object = new Object();
		var $nearestDown:Object = new Object();
		var $nearestLeft:Object = new Object();
		var $nearestRight:Object = new Object();
		$nearestUp.dist = $nearestDown.dist = $nearestLeft.dist = $nearestRight.dist = 0x7fffffff;
		
		var $edge:Object = new Object();
		var $mc:Object;
		var $dx:Number;
		var $dy:Number;
		var $dxEdge:Number;
		var $dyEdge:Number;
		var $dist:Number;
		
		for(var $i in _components)
		{
			$mc = _components[$i];
			
			if(_global.componentWithFocus == $mc)
				continue;
			
			var $pos = $mc._worldBounds;
			//if($pos == null || $pos == undefined)
			//	continue;
			
			$pos.x = ($pos.xMin + $pos.xMax)/2; // $mc._x;
			$pos.y = ($pos.yMin + $pos.yMax)/2; // $mc._y;
			
			//-------------------------------
			// check direction edge
			//-------------------------------
			$edge.x = $pos.x;
			$edge.y = $pos.y;
			
			if($up)
				$edge.y = $pos.yMax;
			else if($down)
				$edge.y = $pos.yMin;
			else if($left)
				$edge.x = $pos.xMax;
			else if($right)
				$edge.x = $pos.xMin;
			
			//debug("pos=" + $pos.x + ", " + $pos.y);
			//debug("edge=" + $edge.x + ", " + $edge.y);
			
			$dx = ($pos.x - $focusPos.x);
			$dy = ($pos.y - $focusPos.y);
			
			$dxEdge = ($edge.x - $focusEdge.x) * $scaleX;
			$dyEdge = ($edge.y - $focusEdge.y) * $scaleY;
			$dist = ($dxEdge * $dxEdge) + ($dyEdge * $dyEdge);
			
			//if(_global.componentWithFocus._parent != $mc._parent)
			//	$dist *= 10;
			
			//debug("mc=" + $mc._target + ": " + $dxEdge + ", " + $dyEdge);
			//debug("dist=" + $dist);
			
			if($dy < 0 && $dist < $nearestUp.dist)
			{
				//debug("nearestUp");
				$nearestUp.dist = $dist;
				$nearestUp.mc = $mc;
			}
			if($dy > 0 && $dist < $nearestDown.dist)
			{
				//debug("nearestDown");
				$nearestDown.dist = $dist;
				$nearestDown.mc = $mc;
			}
			if($dx < 0 && $dist < $nearestLeft.dist)
			{
				//debug("nearestLeft");
				$nearestLeft.dist = $dist;;
				$nearestLeft.mc = $mc;
			}
			if($dx > 0 && $dist < $nearestRight.dist)
			{
				//debug("nearestRight");
				$nearestRight.dist = $dist;;
				$nearestRight.mc = $mc;
			}
			//debug("");
		}
	
		//debug("up=" + $nearestUp.mc._target);
		//debug("down=" + $nearestDown.mc._target);
		//debug("left=" + $nearestLeft.mc._target);
		//debug("right=" + $nearestRight.mc._target);
	
		//trace("update...");
		if($up && $nearestUp.mc)
			setFocus($nearestUp.mc);
		else if($down && $nearestDown.mc)
			setFocus($nearestDown.mc);
		else if($left && $nearestLeft.mc)
			setFocus($nearestLeft.mc);
		else if($right && $nearestRight.mc)
			setFocus($nearestRight.mc);
	}
}