/*								CursorMix
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

dynamic class com.tap4fun.input.CursorMix
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public static function getCursorCoord($mc:Object):Void
	{
		if(_global.getActiveController() == undefined)
		{
			CursorMix.getStdCursorCoord($mc);
		}
		else
		{
			CursorMix.getMultiCursorCoord($mc);
		}
	}
	public static function getStdCursorCoord($mc:Object):Void
	{
		//The utility of this method is to have a simple "getMouseCoordinates" method
		//that can easily be overidden by MultitouchGenericUsage
		$mc.getCursorCoord = function($coord:String, $from:String):Number
		{
			if($from == "_root")
			{
				switch($coord)
				{
					case "x":
					return _root._xmouse;
					case "y":
					return _root._ymouse;
				}
			}
			else if($from == "_parent")
			{
				switch($coord)
				{
					case "x":
					return this._parent._xmouse;
					case "y":
					return this._parent._ymouse;
				}
			}
			else if($from == "_parent._parent")
			{
				switch($coord)
				{
					case "x":
					return this._parent._parent._xmouse;
					case "y":
					return this._parent._parent._ymouse;
				}
			}
			else
			{
				switch($coord)
				{
					case "x":
					return this._xmouse;
					case "y":
					return this._ymouse;
				}
			}
		};
	}
	public static function getMultiCursorCoord($mc:Object):Void
	{
		$mc.getCursorCoord = function($coord:String, $from:String):Number
		{
			var $pt:Object = new Object();
			$pt.x = _global.getCursorState(this._touch).x;
			$pt.y = _global.getCursorState(this._touch).y;
			
			switch($from)
			{
				case "_root":
					break;
				case "_parent":
					this._parent.globalToLocal($pt);
					break;
				case "_parent._parent":
					this._parent._parent.globalToLocal($pt);
					break;
				default:
					this.globalToLocal($pt);
					break;
			}
			switch($coord)
			{
				case "x":
					return $pt.x;
				case "y":
					return $pt.y;
			}
		};
	}
	
	
	public static function mixStdCursorMethods($mc:Object):Void
	{
		CursorMix.getStdCursorCoord($mc);
	}
	public static function mixMultitouchCursorMethods($mc:Object):Void
	{
		CursorMix.getMultiCursorCoord($mc);
	}
	public static function mixCursorMethods($mc:Object):Void
	{
		CursorMix.getCursorCoord($mc);
	}
}