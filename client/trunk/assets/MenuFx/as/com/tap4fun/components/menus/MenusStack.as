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
[IconFile("icons/MenusStack.png")]
import com.tap4fun.StaticFunctions;
import com.tap4fun.components.Events;
import com.tap4fun.components.menus.Menu;

class com.tap4fun.components.menus.MenusStack extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "MenusStack";
	static var symbolOwner:Object = MenusStack;
	var className:String = "MenusStack";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var currentMenu:com.tap4fun.components.menus.Menu;
	public var stack:Array = new Array();
	
	[Inspectable(defaultValue=false)]
	public var debug:Boolean;
	
	[Inspectable(defaultValue=true)]
	public var transitionsOverlay:Boolean;
	
	[Inspectable(defaultValue="")]
	public var firstMenu:String;
	
	private var _inPopAll:Boolean;
	
	private var _menus:Array = new Array();
	private var _visible:Boolean;
	
	private var _lowestDepth:Number;
	private var _highestDepth:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function MenusStack()
	{
		this.currentMenu = null;
		this._highestDepth = -999999999999999;
		this._lowestDepth = 999999999999999;
		
		//this.findMenus(_root);
		if(this.debug == undefined) this.debug = false;
		this.setDebug(this.debug);
		this.setTransitionsOverlay(this.transitionsOverlay);
		_global.MenusStack = this;
		
		_inPopAll = false;
		
		_global.pushMenu = function($menu:String, $transition:String):Void {_global.MenusStack.pushMenu($menu, $transition)};
		_global.popMenu = function($menu:String, $transition:String):Void{_global.MenusStack.popMenu($menu, $transition)};
		_global.switchMenu = function($menu:String, $transition:String):Void {_global.MenusStack.switchMenu($menu, $transition)};
		_global.lockAll = function():Void{_global.MenusStack.lockAll()};
		_global.unlockAll = function():Void{_global.MenusStack.unlockAll()};
		
		_global.getCurrentMenu = function():MovieClip{return _global.MenusStack.getCurrentMenu()};
		_global.registerState = function():Void{_global.MenusStack.registerState()};
		_global.registerMenu = function($menu:MovieClip):Void { _global.MenusStack.registerMenu($menu) };
		_global.unregisterMenu = function($menu:MovieClip):Void{_global.MenusStack.unregisterMenu($menu)};
		_global.setDebugMode = function():Void{_global.MenusStack.setDebugMode()};
		_global.bringToFront = function($menu:MovieClip):Void{_global.MenusStack.bringToFront($menu)};
		_global.sendToBack = function($menu:MovieClip):Void{_global.MenusStack.sendToBack($menu)};
		_global.popAllMenus = function():Void { _global.MenusStack.popAllMenus() };
		_global.popAllAbove = function($menu:String):Void { _global.MenusStack.popAllAbove($menu) };
		
		_global.getMenuIndexInStack = function($menu:MovieClip):Number { return(_global.MenusStack.getMenuIndexInStack($menu)) };
		
		
		//Native Global functions flash emulation
		if(_global.$version != "gameSWF")
		{
			this.emulateNativeCommands();
		}
		
		//this.removeLock();
		this.hideAllMenus();
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function emulateNativeCommands():Void
	{
		if(!_global.getString)
		{
			_global.getString = function($stringID:Object):String
			{
				return String($stringID);
			};
		}
		if(!_global.playSound)
		{
			_global.sounds = new Object();
			
			_global.playSound = function($sound:String, $volume:Number):Void
			{
				if (!_root.pathToSounds) _root.pathToSounds = "";
				
				_global.sounds[$sound] = new Sound();
				_global.sounds[$sound].loadSound(_root.pathToSounds + $sound, false);
				
				_global.sounds[$sound].onLoad = function($success:Boolean):Void
				{
					if($success)
					{
						if($sound.indexOf(".wav") != -1)
						{
							trace("Sorry! Flash can't play wav files");
						}
						if($volume!=undefined) this.setVolume($volume);
						this.start();
					}
					else
					{
						trace("Failed loading sound " + _root.pathToSounds + "" + $sound);	
					}
				};
				
			};
		}
		if(!_global.stopSound)
		{
			_global.stopSound = function():Void
			{
				for (var $sound in _global.sounds)
				{
					_global.sounds[$sound].stop();
				}
			};
		}
	}
	private function findMenus($target:MovieClip):Boolean
	{
		var $menus:Array = new Array();
		for(var mc in $target)
		{
			var $target_mc = $target[mc];
			var $is_Navigator = $target_mc instanceof com.tap4fun.components.menus.Navigator;
			if($is_Navigator) trace("Found Navigator " + mc);
			
			if(($target_mc instanceof MovieClip)
				&& $target_mc !=this
				&& $target_mc._name != "com_gameloft_menus_list"
				&& $target_mc._name != "com_gameloft_infosBox"
				&& !$is_Navigator
				)
			{
				$menus.push(mc);
				if(this.debug) trace("Found menu " + mc);
			}
		}
		this.setMenusNames($menus);
		return $menus.length > 0;
	}
	private function setMenusNames($menus:Array):Void
	{
		this._menus = $menus;
	}
	private function hideAllMenus():Void
	{
		for(var $i:Number=0; $i<this._menus.length; $i++)
		{
			var $current_menu_name = this._menus[$i];
			this.removeMenu(_root[$current_menu_name]);
		}
		this.currentMenu = null;
	}
	
	//Lock
	private function placeLock():Void
	{
		// stretch lock
		for(var $i:Number = 0; $i<this.stack.length; $i++)
		{
			var $cur:MovieClip = this.stack[$i];
			$cur.setDisabled(true);
		}
	}
	private function removeLock():Void
	{
		for(var $i:Number = 0; $i<this.stack.length; $i++)
		{
			var $cur:MovieClip = this.stack[$i];
			$cur.setDisabled(false);
		}
	}
	public function refreshDebugMenusListButtons():Void
	{
		var $menuList:MovieClip = _root.com_gameloft_menus_list;
		var $menuListWidth:Number = 150;
		var $menuListHeight:Number = 300;
		
		for (var $element:String in $menuList)
		{
			if ($menuList[$element] instanceof MovieClip && $element.indexOf("button_") >= 0)
			{
				$menuList[$element].removeMovieClip();
			}
		}
		
		//Adding Menus
		for(var $i:Number = 0; $i<this._menus.length; $i++)
		{
			var $btn = $menuList.createEmptyMovieClip("button_" + this._menus[$i]._name, $i);
			var $menuIsInStack:Boolean = StaticFunctions.isInArray(_global.MenusStack.stack, this._menus[$i]);
			var $btnHeight:Number = 20;
			$btn._x = 0;
			$btn._y = $btnHeight * $i;
			$btn.lineStyle(1, 0xFFFFFF, 100);
			$btn.beginFill($menuIsInStack?0xFF0000:0xFFFFFF, $menuIsInStack?100:80);
			$btn.moveTo(0, 0);
			$btn.lineTo($menuListWidth, 0);
			$btn.lineTo($menuListWidth, $btnHeight);
			$btn.lineTo(0, $btnHeight);
			$btn.lineTo(0, 0);
			$btn.endFill();
			$btn._width = $menuListWidth;
			$btn._height = $btnHeight;
			$btn._alpha = 60;
			var $tf = $btn.createTextField("tf", $btn.getNextHighestDepth(), 0, 0, $menuListWidth, $btnHeight);
			$tf.htmlText = this._menus[$i]._name;
			
			$btn.onRollOver = function():Void
			{
				this._alpha = 100;
			};
			$btn.onPress = function():Void
			{
				
			};
			$btn.MenusStack = this;
			$btn.onRelease = function():Void
			{
				this.MenusStack.popAllMenus();
				this.MenusStack.pushMenu(this.tf.text);
				this.MenusStack.refreshDebugMenusListButtons();
			};
			$btn.onRollOut = $btn.onReleaseOutside = function():Void
			{
				this._alpha = 60;
			};
		}
		///////"Clear all" button
		var $btn = $menuList.createEmptyMovieClip("button_ClearAll", $i);
		var $btnHeight:Number = 20;
		$btn._x = 0;
		$btn._y = $btnHeight * $i;
		$btn.lineStyle(1, 0xFFFFFF, 100);
		$btn.beginFill(0xFFFFFF, 70);
		$btn.moveTo(0, 0);
		$btn.lineTo($menuListWidth, 0);
		$btn.lineTo($menuListWidth, $btnHeight);
		$btn.lineTo(0, $btnHeight);
		$btn.lineTo(0, 0);
		$btn.endFill();
		$btn._width = $menuListWidth;
		$btn._height = $btnHeight;
		$btn._alpha = 60;
		var $tf = $btn.createTextField("tf", $btn.getNextHighestDepth(), 0, 0, $menuListWidth, $btnHeight);
		$tf.htmlText = "Clear All (Space)";
		
		$btn.onRollOver = function():Void
		{
			this._alpha = 100;
		};
		$btn.MenuStack = this;
		$btn.onRelease = function():Void
		{
			this.MenuStack.popAllMenus();
		};
		$btn.onRollOut = $btn.onReleaseOutside = function():Void
		{
			this._alpha = 60;
		};
		////////End ClearAll Button
	}
	public function buildDebugMenusList():Void
	{
		var $infosBox = _root.createEmptyMovieClip("com_gameloft_infosBox", _root.getNextHighestDepth());
		var $tf = $infosBox.createTextField("tf", $infosBox.getNextHighestDepth(), 0, 0, 320, 20);
		$tf.selectable = false;
		$tf.bold = true;
		$tf.htmlText = "DEBUG MODE: Click Shift +  Enter to display the Menus List";
		$infosBox._x = Stage.width - $infosBox._width;
		$infosBox._y = 0;
		$infosBox.currentFrame = 0;
		
		$infosBox.onEnterFrame = function():Void
		{
			if(this.currentFrame > 150)
			{
				this._y--;
				if(this._y <= this._height*-1)
				{
					this.removeMovieClip();
				}
			}
			this.currentFrame++;
		};
		
		var $menuList = _root.createEmptyMovieClip("com_gameloft_menus_list", _root.getNextHighestDepth());
		
		$menuList._x = 0;
		$menuList._y = 0;
		
		$menuList._visible = false;
		$menuList.MenuStack = this;
		$menuList.onKeyDown = function():Void
		{
			if(Key.isDown(Key.SHIFT) && Key.isDown(Key.ENTER))
			{
				this._visible = !this._visible;
			}
			if(this._visible)
			{
				this.MenuStack.refreshDebugMenusListButtons();
				trace("The current Menu stack looks like:\n");
				for(var $i:Number = 0; $i<this.MenuStack.stack.length; $i++)
				{
					trace($i + "-->" + this.MenuStack.stack[$i]._name);
				}
				
				if(Key.isDown(Key.UP))
				{
					if(this._y < 0)this._y+=10;
				}
				if(Key.isDown(Key.DOWN))
				{
					if(this._y > Stage.height - this._height) this._y-=10;
				}
				if(Key.isDown(Key.SPACE))
				{
					this.button_ClearAll.onRelease();
				}
			}
		};
		Key.addListener($menuList);
	}
	private function setWaitTransition($menu1:MovieClip, $menu2:MovieClip, $menu2Anim:String, $visible_at_the_end:Boolean):Void
	{
		$menu1.nextMenu = $menu2;
		$menu1.anim_to_play = $menu2Anim;
		$menu1.visible_at_the_end = $visible_at_the_end;
		
		$menu1.onAnimationEnd = function():Void
		{
			if (StaticFunctions.isInArray(_global.MenusStack.stack, this.nextMenu))
			{
				//Playing anim if menu still in stack
				this.nextMenu._visible = true;
				if(!(this.nextMenu.nextMenu instanceof MovieClip)) this.nextMenu.gotoAndPlay(this.anim_to_play); //if a setWaitTransition has not been set on next menu...
			}
			//_global.MenusStack.swapToHighestDepth(this.nextMenu);
			this.nextMenu = null;
			this.anim_to_play = null;
			this.defaultOnAnimationEnd();
			this._visible = this.visible_at_the_end;
			this.visible_at_the_end = true;
			this.onAnimationEnd = this.defaultOnAnimationEnd;
		};
	}
	private function startTransition($action:String, $targetMenu:com.tap4fun.components.menus.Menu):Void
	{
		var $isInStack:Boolean = StaticFunctions.isInArray(this.stack, $targetMenu);
		var $overlay:Boolean = this.getTransitionsOverlay();
		var $previousMenu:MovieClip = null;
		
		switch($action)
		{
			case "push":
			
				/////////////////////////////////Push//////////////////////////////////////
				$previousMenu = this.currentMenu;
				//$targetMenu._visible = true;
				if($previousMenu == $targetMenu) return;
				if($overlay)
				{
					$previousMenu.visible_at_the_end = $targetMenu.keepBelowVisible;
					$previousMenu.onAnimationEnd = function():Void
					{
						this._visible = this.visible_at_the_end;
						this.defaultOnAnimationEnd();
						this.onAnimationEnd = this.defaultOnAnimationEnd;
					};
				}
				
				if(!$isInStack)
				{
					//Menu newly added to the stack
					if($previousMenu)
					{
						$previousMenu.gotoAndPlay("focus_out");
						
						if(!$overlay)
						{
							this.setWaitTransition($previousMenu, $targetMenu, "show", $targetMenu.keepBelowVisible);
						}
						else
						{
							$targetMenu.onAnimationEnd = defaultOnAnimationEnd;
							$targetMenu._visible = true;
							$targetMenu.gotoAndPlay("show");
							//this.bringToFront($targetMenu);
						}
					}
					else
					{
						//No menu in stack
						$targetMenu.onAnimationEnd = defaultOnAnimationEnd;
						$targetMenu.gotoAndPlay("show");
						$targetMenu._visible = true;
						//this.bringToFront($targetMenu);
					}
				}
				else
				{
					//Menu already in stack
					if($previousMenu)
					{
						$previousMenu.gotoAndPlay("focus_out");
						if(!$overlay)
						{
							this.setWaitTransition($previousMenu, $targetMenu, "focus_in", $targetMenu.keepBelowVisible);
						}
						else
						{
							$targetMenu.onAnimationEnd = defaultOnAnimationEnd;
							$targetMenu._visible = true;
							$targetMenu.gotoAndPlay("focus_in");
							//this.bringToFront($targetMenu);
						}
					}
					else
					{
						$targetMenu.onAnimationEnd = defaultOnAnimationEnd;
						$targetMenu.gotoAndPlay("focus_in");
						//this.bringToFront($targetMenu);
					}
				}
				break;
			
			case "pop":
			
				/////////////////////////////////Pop//////////////////////////////////////
				$targetMenu._visible = true;
				$targetMenu.gotoAndPlay("hide");
				var $currentIndex:Number = StaticFunctions.getElementIndex(this.stack, $targetMenu);
				
				if($targetMenu == this.currentMenu && this.stack.length > 1)
				{
					//Menu is on top of stack with menus under
					var $nextMenu:com.tap4fun.components.menus.Menu = this.stack[this.stack.length-2];
					if(!$overlay)
					{
						this.setWaitTransition($targetMenu, $nextMenu, "focus_in", false);
					}
					else
					{
						$nextMenu._visible = true;
						$nextMenu.gotoAndPlay("focus_in");
						$nextMenu.onAnimationEnd = defaultOnAnimationEnd;
						$targetMenu.onAnimationEnd = function():Void
						{
							this.defaultOnAnimationEnd();
							this._visible = false;
							this.onAnimationEnd = this.defaultOnAnimationEnd;
						};
					}
				}
				else if(this.stack.length > 1 && $currentIndex != 0)
				{
					// Menu is in stack and not the last, but not on top
					var $topMenu:com.tap4fun.components.menus.Menu = this.stack[$currentIndex+1];
					var $botMenu:com.tap4fun.components.menus.Menu = this.stack[$currentIndex-1];
					
					if ($topMenu.keepBelowVisible && $topMenu._visible)
					{
						$botMenu._visible = true;
						$targetMenu.onAnimationEnd = function():Void
						{
							this.defaultOnAnimationEnd();
							this._visible = false;
							this.onAnimationEnd = this.defaultOnAnimationEnd;
						};
					}
				}
				else
				{
					//The menu is alone in the stack or on the bottom of the stack
					if(this.debug) trace("Warning: Last menu of stack poped!");
					$targetMenu.onAnimationEnd = function():Void
					{
						this.defaultOnAnimationEnd();
						this._visible = false;
						this.onAnimationEnd = this.defaultOnAnimationEnd;
					};
				}
				break;
			
			case "switch":
			
				/////////////////////////////////Switch//////////////////////////////////////
				$previousMenu = this.currentMenu;
				if($previousMenu == $targetMenu)
				{
					$targetMenu.gotoAndPlay("focus_in");
					return;
				}
				$previousMenu.gotoAndPlay("hide");
				
				if($isInStack)
				{
					//Was in the stack
					if(!$overlay)
					{
						this.setWaitTransition($previousMenu, $targetMenu, "focus_in", false);
					}
					else
					{
						$targetMenu._visible = true;
						//swapToHighestDepth($targetMenu);
						$targetMenu.gotoAndPlay("focus_in");
						$targetMenu.onAnimationEnd = $targetMenu.defaultOnAnimationEnd;
						$previousMenu.onAnimationEnd = function():Void
						{
							this._visible = false;
							this.defaultOnAnimationEnd();
							this.onAnimationEnd = this.defaultOnAnimationEnd;
						};
						//$targetMenu.swapDepths(_root.getNextHighestDepth());
						//swapToHighestDepth($targetMenu);
					}
				}
				else
				{
					//Not in the stack
					if(!$overlay)
					{
						this.setWaitTransition($previousMenu, $targetMenu, "show", false);
					}
					else
					{
						$targetMenu._visible = true;
						//$targetMenu.swapDepths(_root.getNextHighestDepth());
						//this.swapToHighestDepth($targetMenu);
						$targetMenu.gotoAndPlay("show");
						$targetMenu.onAnimationEnd = $targetMenu.defaultOnAnimationEnd;
						$previousMenu.onAnimationEnd = function():Void
						{
							this._visible = false;
							this.defaultOnAnimationEnd();
							this.onAnimationEnd = this.defaultOnAnimationEnd;
						};
					}
				}
				break;
				
			default:
				trace("Error: Unknown action MenusStack: " + $action);
				break;
		}
	}
	private function broadcastAllEvents($event:Object, $menu:MovieClip):Void
	{
		switch($event)
		{
			case Events.PUSH_MENU:
				//Root	
				if(_root.onPushMenu) _root.onPushMenu($menu);
				//MenusStack
				if(this.onPushMenu) this.onPushMenu($menu);
				this.broadcastEvent(Events.PUSH_MENU, $menu);
				//Menu
				if($menu.onPush) $menu.onPush();
				$menu.broadcastEvent(Events.PUSH_MENU);
				break;
			
			case Events.POP_MENU:
				//Root
				if(_root.onPopMenu) _root.onPopMenu($menu);
				//MenusStack
				if(this.onPopMenu) this.onPopMenu($menu);
				this.broadcastEvent(Events.POP_MENU, $menu);
				//Menu
				if($menu.onPop) $menu.onPop();
				$menu.broadcastEvent(Events.POP_MENU);
				break;
			
			case Events.CHANGE_MENU:
				//Root
				if(_root.onChangeMenu) _root.onChangeMenu($menu);
				//MenusStack
				if(this.onChangeMenu) this.onChangeMenu($menu);
				this.broadcastEvent(Events.CHANGE_MENU, $menu);
				break;
			
			case Events.FOCUS_IN:
				//Menu
				if($menu.onFocusIn) $menu.onFocusIn();
				$menu.broadcastEvent(Events.FOCUS_IN);
				break;
			
			case Events.FOCUS_OUT:
				//Menu
				if($menu.onFocusOut) $menu.onFocusOut();
				$menu.broadcastEvent(Events.FOCUS_OUT);
				break;
			
			case Events.DISABLE:
				break;
			
			case Events.ENABLE:
				break;
		}
	}
	private function setAndStartExternalTransition($transition:String):Void
	{
		//Setting External Transition
		if($transition != undefined && _root[$transition] instanceof com.tap4fun.components.menus.Transition)
		{
			//trace("Specifying an external transition => " + $transition);
			_root[$transition].start(true);
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function registerMenu($menu:MovieClip):Void
	{
		if(_global.MenusStack.debug)trace("Registering menu: " + $menu._name);
		
		if(_root[$menu._name] != $menu) _root[$menu._name] = $menu; // Declaring menu on root if !found
		this._menus.push($menu);
		$menu._visible = false;
		this._highestDepth = Math.max(this._highestDepth, $menu.getDepth());
		this._lowestDepth = Math.min(this._lowestDepth, $menu.getDepth());
	}
	public function unregisterMenu($menu:MovieClip):Void
	{
		if(_global.MenusStack.debug)trace("Unregistering menu: " + $menu._name);
		
		var $menu_name:String = $menu._name;
		this.popMenu($menu_name);
		this._menus = StaticFunctions.removeElement(this._menus, $menu);
		delete _root[$menu_name];
	}
	public function removeMenu($menu:MovieClip):Void
	{
		//trace("Removing Menu " + $menu._name);
		$menu._visible = false;
		this.stack = StaticFunctions.removeElement(this.stack, $menu);
	}
	public function registerState($state:String):Void
	{
		//insert a state in the menu stack
	}
	public function pushMenu($menu_name:String, $transition:String):Void
	{
		_global.componentWithFocus = null;
		//MenusStack disabled, no push
		if(this.disabled) return;
		
		//Setting External Transition
		this.setAndStartExternalTransition($transition);
		
		/*if(this.debug) trace("Pushing Menu " + $menu_name);*/
		
		this.startTransition("push", _root[$menu_name]);
		
		//Removing focus from underlying menu
		if((this.stack.length > 0) && this.getMenuOnTopOfStack().removeFocus) this.getMenuOnTopOfStack().removeFocus();
		
		//Hiding previous menu
		var $prevMenu = this.currentMenu;
		
		this.currentMenu = _root[$menu_name];
		if(this.currentMenu.getPlaceLockBelow()===true)this.currentMenu.lockBelow();
		
		if(StaticFunctions.isInArray(this.stack, this.currentMenu))
		{
			//Removing from the stack if he was already in
			this.stack = StaticFunctions.removeElement(this.stack, this.currentMenu);
			this.broadcastAllEvents(Events.FOCUS_IN, this.currentMenu);
		}
		else
		{
			//Newly added
		}
		this.currentMenu.giveFocusToFirstFocus();
		//Adding new menu on top of the stack
		this.stack.push(this.currentMenu);
		
		//Events
		if($prevMenu) this.broadcastAllEvents(Events.FOCUS_OUT, $prevMenu);
		this.broadcastAllEvents(Events.PUSH_MENU, this.currentMenu);
		this.broadcastAllEvents(Events.FOCUS_IN, this.currentMenu);
		
		this.broadcastAllEvents(Events.CHANGE_MENU, this.currentMenu);
		
		_global.preloadGlyphs(this.currentMenu);
	}
	public function popMenu($menu_name:String, $transition:String):Void
	{
		if ($menu_name && !StaticFunctions.isInArray(this.stack, _root[$menu_name]))
		{
			//menu_name specified but menu !isInStack
			trace("Trying to pop menu " + $menu_name + " which isn't part of the actual stack, exiting popMenu...");
			return;
		}
		
		_global.componentWithFocus = null;
		//MenusStack disabled, no pop
		if(this.disabled) return;
		
		//if(this.debug)
		
		//No parameter passed or menu on top of stack, poping menu on top of the stack
		if($menu_name == undefined || $menu_name == this.currentMenu._name || $menu_name == "")
		{
			//Setting External Transition
			this.setAndStartExternalTransition($transition);
			
			this.startTransition("pop", this.currentMenu);
			
			//Pop Menu Event
			var $menuPoped = this.currentMenu;
			
			//Removing Menu at top of the stack
			this.stack.pop();
			
			//Giving Focus to underlying Menu
			this.currentMenu = this.getMenuOnTopOfStack();
			if(this.currentMenu) this.currentMenu.giveFocusToFirstFocus();
			
			this.broadcastAllEvents(Events.FOCUS_OUT, $menuPoped);
			this.broadcastAllEvents(Events.POP_MENU, $menuPoped);
			if(this.currentMenu) this.broadcastAllEvents(Events.FOCUS_IN, this.currentMenu);
			
			//Change Menu Event
			this.broadcastAllEvents(Events.CHANGE_MENU, this.currentMenu);
		}
		else
		{
			if (_root[$menu_name]._visible)
			{
				this.startTransition("pop", _root[$menu_name]);
			}
			
			//Removing menu from somewhere in the stack
			var $menu_to_remove = _root[$menu_name];
			
			if(StaticFunctions.isInArray(this.stack, $menu_to_remove))
			{
				//Pop Menu Event
				
				this.broadcastAllEvents(Events.POP_MENU, $menu_to_remove);
				//this.broadcastEvent(Events.POP_MENU, $menu_to_remove);
				
				//Removing Menu from the stack
				this.stack = StaticFunctions.removeElement(this.stack, $menu_to_remove);
			}
			else
			{
				trace("Error: Trying to pop a menu not found in the stack: " + $menu_name);	
			}
		}
		
		
		_global.preloadGlyphs(this.currentMenu);
	}
	public function switchMenu($menu_name:String, $transition:String):Void
	{
		if(this.disabled) return;
		_global.componentWithFocus = null;
		/*if(this.debug) trace("Switching Menu to " + $menu_name);*/

		//Setting External Transition
		this.setAndStartExternalTransition($transition);
		
		if(this.stack.length < 1)
		{
			//No menu in stack, pushing menu...
			this.pushMenu($menu_name);
			return;
		}
		if(_root[$menu_name] == this.getCurrentMenu())
		{
			//Switching to menu on top of the stack
			trace("Warning: Switching to menu already on top of the stack!");
			return;
		}
		this.startTransition("switch", _root[$menu_name]);
		
		//Removing this.stack[this.stack.length-1]._name from the stack;
		this.stack.pop();
		
		//Event of previous menu
		if(this.currentMenu.onPop)this.currentMenu.onPop();
		
		//Changing current menu with new one
		this.currentMenu = _root[$menu_name];
		
		if(StaticFunctions.isInArray(this.stack, this.currentMenu))
		{
			//Next Menu was in stack, removing it
			this.stack = StaticFunctions.removeElement(this.stack, this.currentMenu);
		}
		
		//Adding $menu_name on top of the stack
		this.stack.push(_root[$menu_name]);
		this.currentMenu.giveFocusToFirstFocus();
		
		//Event of nextMenu
		
		if(this.currentMenu.onPush) this.currentMenu.onPush();
		//Change Menu Event
		this.broadcastEvent(Events.CHANGE_MENU, this.currentMenu);
		if(this.onChangeMenu) this.onChangeMenu(this.currentMenu);
		if(_root.onChangeMenu) _root.onChangeMenu(this.currentMenu);
		
		_global.preloadGlyphs(this.currentMenu);
	}
	public function popAllMenus():Void
	{
		if (this.disabled) return;
		
		this._inPopAll = true;
		while(this.stack.length > 0)
		{
			this.popMenu();
		}
		this._inPopAll = false;
	}
	public function popAllAbove($menu_name:String):Void
	{
		if(this.disabled) return;
		if (!StaticFunctions.isInArray(_global.MenusStack.stack, _root[$menu_name]))
		{
			trace("Error! Trying to pop all menu above a menu not found in the stack (" + $menu_name + "), extiting popAllAbove");
			return;
		}
		
		this._inPopAll = true;
		while((this.getMenuOnTopOfStack() != _root[$menu_name]) && (this.stack.length > 0))
		{
			this.popMenu();
		}
		this._inPopAll = false;
	}
	public function swapToHighestDepth($mc:MovieClip):Void
	{
		var $swappedMc:MovieClip = _root.getInstanceAtDepth(this._highestDepth);
		$mc.swapDepths($swappedMc);
		
		while($swappedMc.getDepth() < $mc.getDepth()-1)
		{
			var $nextDepth:Number = $swappedMc.getDepth() + 1;
			$swappedMc.swapDepths($nextDepth);
		}
	}
	public function swapToLowestDepth($mc:MovieClip):Void
	{
		if(this.stack[0] == $mc) return;
		var $swappedMc:MovieClip = this.stack[0];
		$mc.swapDepths($swappedMc);
		
		while($swappedMc.getDepth() > $mc.getDepth()+1)
		{
			var $nextDepth:Number = $swappedMc.getDepth() - 1;
			$swappedMc.swapDepths($nextDepth);
		}
	}
	public function onLoad():Void
	{
		this.defaultOnLoad();
	}
	public function defaultOnLoad():Void
	{
		if(this.firstMenu != "" && this.firstMenu != undefined)
		{
			if(this.debug) trace("Pushing first menu " + this.firstMenu);
			this.pushMenu(this.firstMenu);
		}
	}
	
	//Explicit Getters and Setters
	public function setDebugMode($debug:Boolean):Void
	{
		this.debug = $debug;
		if($debug)
		{
			trace("!!--> Warning! MenusStack's Debug Mode is ON! <--!!");
			this.onLoad = function():Void
			{
				_global.MenusStack.buildDebugMenusList();
				this.defaultOnLoad();
			};
			//this.buildDebugMenusList();
			this.hideAllMenus();
		}
	}
	public function bringToFront($menu:MovieClip):Void
	{
		if($menu == undefined) $menu = _global.MenusStack.currentMenu;
		this.swapToHighestDepth($menu);
	}
	public function sendToBack($menu:MovieClip):Void
	{
		if($menu == undefined) $menu = _global.MenusStack.currentMenu;
		this.swapToLowestDepth($menu);
	}
	public function lockAll():Void
	{
		this.placeLock();
	}
	public function unlockAll():Void
	{
		this.removeLock();
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setDebug($debug:Boolean):Void
	{
		this.setDebugMode($debug);
	}
	public function getDebug():Boolean
	{
		return this.debug;
	}
	public function setDisabled($disabled:Boolean):Void
	{
		this.disabled = $disabled;
	}
	public function getCurrentMenu():MovieClip
	{
		return this.currentMenu;
	}
	public function getStack():Array
	{
		return this.stack;
	}
	public function setStack($stack:Array):Void
	{
		this.stack = $stack;
	}
	public function setTransitionsOverlay($trans:Boolean):Void
	{
		this.transitionsOverlay = $trans;
	}
	public function getTransitionsOverlay():Boolean
	{
		return this.transitionsOverlay;
	}
	public function getIsInPopAll():Boolean
	{
		return this._inPopAll;
	}
	public function getMenuOnTopOfStack():Menu
	{
		return this.stack[this.stack.length - 1];
	}
	public function isOnTopOfStack($menu:MovieClip):Boolean
	{
		return $menu == this.getMenuOnTopOfStack();
	}
	public function getMenuIndexInStack($menu):Number
	{
		var $checkedMenu:MovieClip = ($menu instanceof MovieClip)? $menu : _root[$menu];
		for (var $i:Number = 0; $i < this.stack.length; ++$i)
		{
			if (this.stack[$i] == $checkedMenu) return $i;
		}
		return -1;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function onChangeMenu($menu):Void{}
	public function onPushMenu($menu):Void{}
	public function onPopMenu($menu):Void { }
	
	
	//Useless and temporary, just to make sur DH3 updates its flash_library...
	public function updatedFine():Boolean
	{
		return true;
	}
}