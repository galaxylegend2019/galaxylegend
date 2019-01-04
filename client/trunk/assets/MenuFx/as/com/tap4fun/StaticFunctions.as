class com.tap4fun.StaticFunctions
{
	public static function isInArray($array:Array, $element:Object):Boolean
	{
		var $len = $array.length;
		for(var $i:Number = 0; $i < $len; $i++)
		{
			if($array[$i] == $element)
			{
				//trace($element + " is in array!");
				return true;
			}
		}
		//trace($element + " is not in array!");
		return false;
	}
	public static function removeElementAtIndex($array:Array, $index:Number):Array
	{
		//trace("Before --> " + $array);
		$array.splice($index, 1);
		//$array = $array.slice(0, $index).concat($array.slice($index+1));
		//trace("After --> " + $array);
		return $array;
	}
	
	public static function removeElement($array:Array, $element:Object):Array
	{
		var $len = $array.length;
		for(var $i:Number = 0; $i < $len; $i++)
		{
			if($array[$i] == $element)
			{
				removeElementAtIndex($array, $i);
				break;
			}
		}
		return $array;
	}
	
	public static function getElementIndex($array:Array, $element:Object):Number
	{
		var $len = $array.length;
		for(var $i:Number = 0; $i < $len; $i++)
		{
			if($array[$i] == $element)
			{
				return $i;
			}
		}
		return null;
	}
	
	public static function radiansToDegrees($rad:Number):Number
	{
		return $rad*180/Math.PI;
	}
	
	public static function TraceLog(msg:String):Void
	{
		Trace("[AS] " + msg);
	}
}