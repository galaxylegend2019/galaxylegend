/*
 * 
 * 
 * 
 * Flow file Example:
 * 
 * flow_schema=

	menu_splash
	[
		@btn_continue:
			perform(doSome,1,2);
			go(menu_mainmenu);
	]

	menu_mainmenu
	[
		@btn_continue:
			evaluate(canGoPassMain,1,2,3)
				<
				-true:go(menu_postmainmenu)
				-false:alert(str_symbol_alert_something)
				>
		@btn_back:
			back();
	]
 * 
 * */

import com.tap4fun.utils.StringUtilities;

class com.tap4fun.components.menus.MenusFlow
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var builtInActions:Object;
	private var _loadVar:LoadVars;
	
	public var menus:Object;
	
	public static var CHAR_MENU_BEGIN:String = "[";
	public static var CHAR_MENU_END:String = "]";
	public static var CHAR_TARGET_BUTTON:String = "@";
	public static var CHAR_CONDITION_BEGIN:String = "<";
	public static var CHAR_CONDITION_END:String = ">";
	public static var CHAR_ACTION:String = ":";
	public static var CHAR_VALUES_SEPARATOR:String = ",";
	public static var CHAR_PARAMS_BEGIN:String = "(";
	public static var CHAR_PARAMS_END:String = ")";
	public static var CHAR_ACTIONS_SEPARATOR:String = ";";
	public static var CHAR_POSSIBILITY:String = "-";
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function MenusFlow()
	{
		this.builtInActions = new Object();
		this.builtInActions.go = this.go;
		this.builtInActions.back = this.back;
		this.builtInActions.evaluate = this.evaluate;
		this.builtInActions.perform = this.perform;
		this.builtInActions.alert = this.alert;
		this.builtInActions.confirm = this.confirm;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Built-in actions
	public function go($menu:String):Void
	{
		trace("go(" + $menu + ")");
		_global.pushMenu($menu);
	}

	public function back($menu:String):Void
	{
		trace("back(" + $menu + ")");
		if ($menu == "all") _global.popAllMenus();
		else if ($menu) _global.popAllAbove($menu);
		else _global.popMenu();
	}

	public function evaluate($params:String,  $answerChoices:String):Void
	{
		trace("evaluate(" + $params + ", " + $answerChoices + ")");
		
		var $func:String = $params.split(CHAR_VALUES_SEPARATOR, 1)[0];
		var $vars:Array = ($params.slice($params.indexOf(CHAR_VALUES_SEPARATOR)+1, $params.indexOf(CHAR_PARAMS_END))).split(CHAR_VALUES_SEPARATOR);
		
		var $scope:Object = _root; //TODO: Find real scope... going from and to: button, menu, _root, _global
		
		var $response = eval($func).call($scope, $vars[0], $vars[1], $vars[2], $vars[3], $vars[4], $vars[5]);
		
		var $possibilitiesSplit:Array = $answerChoices.split(CHAR_POSSIBILITY);
		var $possibilities:Object = new Object();
		
		for(var $i:Number = 0; $i<$possibilitiesSplit.length; $i++)
		{
			var $cur:String = $possibilitiesSplit[$i];
			
			var $possibilitieValue:String = $cur.slice(0, $cur.indexOf(CHAR_ACTION));
			var $possibilitieAction:String = $cur.slice($cur.indexOf(CHAR_ACTION) + 1);
			
			if($possibilitieValue.length <= 0 || $possibilitieAction.length <= 0) continue;
			
			$possibilities[$possibilitieValue] = new Object();
			$possibilities[$possibilitieValue].action = $possibilitieAction;
		}
		
		this.evaluateAndPerformAction($possibilities[$response.toString()].action, this);
	}

	public function perform($params:String):Void
	{
		trace("perform(" + $params + ")");
		
		var $func:String = $params.split(CHAR_VALUES_SEPARATOR, 1)[0];
		var $vars:Array = ($params.slice($params.indexOf(CHAR_VALUES_SEPARATOR)+1)).split(CHAR_VALUES_SEPARATOR);
		
		var $scope:Object = _root; //TODO: Find real scope... going from and to: button, menu, _root, _global
		
		eval($func).call($scope, $vars[0], $vars[1], $vars[2], $vars[3], $vars[4], $vars[5]);
	}

	public function alert($msgSymbol:String):Void
	{
		trace("alert(" + $msgSymbol + ")");
	}
	public function confirm($msgSymbol:String,  $answerChoices:String):Void
	{
		trace("confirm(" + $msgSymbol + ")");
	}
	public function prompt($msgSymbol:String):Void
	{
		trace("prompt(" + $msgSymbol + ")");
	}
	//ENDOF Built-in actions
	
	
	public function loadFlowSchema($textfile:String):Void
	{
		this._loadVar = new LoadVars();
		this._loadVar.load($textfile);
		this._loadVar.MenusFlow = this;
		
		this._loadVar.onLoad = function($success)
		{
			if ($success)
			{
				if (!this.flow_schema)
				{
					trace("ERROR! " + $textfile + " is missing \"flow_schema=\" at beginning");
				}
				else
				{
					this.MenusFlow.parseFlowSchema(this.flow_schema);
				}
			}
			else
			{
				_global.trace("ERROR! Couldn't load schema file " + $textfile);
			}
		};
	}
	
	public function removeComments($txt:String):String
	{
		while ($txt.indexOf("//")>-1)
		{
			$txt = $txt.slice(0, $txt.indexOf("//")).concat($txt.slice($txt.indexOf("\n", $txt.indexOf("//"))));
		}
		
		while ($txt.indexOf("/*")>-1 && $txt.indexOf("*/")>-1)
		{
			$txt = $txt.slice(0, $txt.indexOf("/*")).concat($txt.slice($txt.indexOf("*/") + 2));
		}
		return $txt;
	}
	public function parseFlowSchema($flowtxt:String):Void
	{
		this.menus = new Object();
		
		$flowtxt = removeComments($flowtxt);
		$flowtxt = StringUtilities.removeWhite($flowtxt);
		
		var $splitMenus:Array = $flowtxt.split(CHAR_MENU_END);
		
		for(var $i:Number = 0; $i<$splitMenus.length; $i++)
		{
			var $cur:String = $splitMenus[$i];
			var $menu_name:String = $cur.slice(0, $cur.indexOf(CHAR_MENU_BEGIN));
			$cur = $cur.slice($cur.indexOf(CHAR_MENU_BEGIN) + 1);
			
			var $buttons:Array = $cur.split(CHAR_TARGET_BUTTON);
			
			this.menus[$menu_name] = new Object();
			this.menus[$menu_name].menu_name = $menu_name;
			this.menus[$menu_name].buttons = new Array();
			
			for(var $j:Number = 0; $j<$buttons.length; $j++)
			{
				var $curBtn_str:String = $buttons[$j];
				var $curBtn_name:String = $curBtn_str.slice(0, $curBtn_str.indexOf(CHAR_ACTION));
				if($curBtn_name.length <= 0) continue;
				
				var $curBtn_actions:String = $curBtn_str.slice($curBtn_str.indexOf(CHAR_ACTION)+1);
				
				this.menus[$menu_name].buttons[$curBtn_name] = new Object();
				this.menus[$menu_name].buttons[$curBtn_name].button_name = $curBtn_name;
				this.menus[$menu_name].buttons[$curBtn_name].actions = $curBtn_actions.split(CHAR_ACTIONS_SEPARATOR);
			}
		}
	}
	
	public function evaluateAndPerformAction($actionStr:String, $topScope:Object):Void
	{
		var $actionName:String = $actionStr.split(CHAR_PARAMS_BEGIN, 1)[0];
		
		if($actionName != "evaluate" && $actionName != "confirm")
		{
			var $argsBeginIndex:Number = $actionStr.indexOf(CHAR_PARAMS_BEGIN)+1;
			var $argsEndIndex:Number = $actionStr.lastIndexOf(CHAR_PARAMS_END);
			
			var $args:String = $actionStr.slice($argsBeginIndex, $argsEndIndex);
		}
		else
		{
			var $argsBeginIndex:Number = $actionStr.indexOf(CHAR_PARAMS_BEGIN)+1;
			var $argsEndIndex:Number = $actionStr.indexOf(CHAR_PARAMS_END);
			var $answerChoicesBeginIndex:Number = $actionStr.indexOf(CHAR_CONDITION_BEGIN)+1;
			var $answerChoicesEndIndex:Number = $actionStr.lastIndexOf(CHAR_CONDITION_END);
			
			var $args:String = $actionStr.slice($argsBeginIndex, $argsEndIndex);
			var $answerChoices:String = $actionStr.slice($answerChoicesBeginIndex, $answerChoicesEndIndex);
			
			this.builtInActions[$actionName].call(this, $args, $answerChoices);
			return;
		}
		
		if(this.builtInActions[$actionName])
		{
			this.builtInActions[$actionName].call(this, $args);
			return;
		}
		
		//Custom Action
		
	}
	
	public function buttonAction($btn:MovieClip):Void
	{
		var $actionsList:Array = this.menus[$btn.parentMenu].buttons[$btn._name].actions;
		for(var $i:Number = 0; $i<$actionsList.length; $i++)
		{
			var $curAction:String = $actionsList[$i];
			this.evaluateAndPerformAction($curAction, $btn);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
}