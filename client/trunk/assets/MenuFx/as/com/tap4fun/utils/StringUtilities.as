class com.tap4fun.utils.StringUtilities
{
	
	public static function toHtmlSafeString($str:String):String
	{
		var $str_array:Array = new Array();
		var $chars_to_replace:Array = new Array('&', "'", '"', '>', '<');
		var $chars_replace_with:Array = new Array('&amp;', '&apos;', '&quot;', '&gt;', '&lt;');
		
		for (var $i:Number = 0; $i < $chars_to_replace.length; $i++)
		{
			$str_array = $str.split($chars_to_replace[$i]);		
			$str = $str_array.join($chars_replace_with[$i]);
		}
		return $str;
	}
	
	public static function upperFirst($str:String):String
	{
		//hack to bypass this in Japanese...
		if (_global.NativeIsJapanBuild()) return $str;
		
		$str = $str.toLowerCase();
		$str = $str.slice(0, 1).toUpperCase() + $str.slice(1);
		return $str;
	}
	
	public static function trimWhiteSpace($str:String):String
	{
		if($str.length == 0)
		{
			return "";
		}
		else if($str.indexOf(" ") == 0)
		{
			$str = $str.substr(1);
			$str = trimWhiteSpace($str);
		}
		else if($str.lastIndexOf(" ") == $str.length-1)
		{
			$str = $str.substr(0, $str.length-1);
			$str = trimWhiteSpace($str);
		}
		else if($str.indexOf("\n") == 0)
		{
			$str = $str.substr(1);
			$str = trimWhiteSpace($str);
		}
		else if($str.lastIndexOf("\n") == $str.length-1)
		{
			$str = $str.substr(0, $str.length-1);
			$str = trimWhiteSpace($str);
		}
		else if($str.indexOf("\t") == 0)
		{
			$str = $str.substr(1);
			$str = trimWhiteSpace($str);
		}
		else if($str.lastIndexOf("\t") == $str.length-1)
		{
			$str = $str.substr(0, $str.length-1);
			$str = trimWhiteSpace($str);
		}
		else if($str.indexOf("\r") == 0)
		{
			$str = $str.substr(1);
			$str = trimWhiteSpace($str);
		}
		else if($str.lastIndexOf("\r") == $str.length-1)
		{
			$str = $str.substr(0, $str.length-1);
			$str = trimWhiteSpace($str);
		}
		return $str;
	}

	public static function removeWhite($str:String):String
	{
		$str = $str.split("\r").join("");
		$str = $str.split("\n").join("");
		$str = $str.split("\t").join("");
		$str = $str.split(" ").join("");
		return($str);
	}
	
	public static function toNumber($numStr:String):Number
	{
		if ($numStr.length == undefined)
		{
			return Number($numStr);
		}
		var pureNumStr:String = "0";
		for (var i:Number = 0; i < $numStr.length; i++)
		{
			if ($numStr.charCodeAt(i) >= 48 && $numStr.charCodeAt(i) <= 57)
			{
				pureNumStr = pureNumStr.concat($numStr.charAt(i));
			}
		}
		return Number(pureNumStr);
	}
	
	public static function cutShort($textMc:TextField, $str:String, $maxWidth:Number, $postfix:String):Void 
	{
		$textMc.text = "123";
		var height = $textMc.textHeight;		
		$textMc.text = $str;
		if ($textMc.textHeight <= height * 3 / 2)
		{
			if ($textMc.textWidth <= $maxWidth)
			{
				return;
			}
		}
		
		$textMc.text = $postfix;
		$maxWidth = Math.max(1, $maxWidth - $textMc.textWidth);
		
		var $lastPos:Number = 1;
		var $length:Number = $str.length;
		do
		{
			if ($str.charAt($lastPos) == "\n")
			{
				break;
			}
			$textMc.text = $str.substring(0, $lastPos);
			$lastPos ++;
			
		}
		while ($textMc.textWidth <= $maxWidth && $lastPos < $length);
		
		$textMc.text = $textMc.text + $postfix;
	}
	
	/**************************************************************
	parameter:
		$str: 		original string.
		$replace:	be replaced string.
		$replaceWith:
	**************************************************************/
	static function replaceStr ($str:String, $replace:String, $replaceWith:String):String
	{
		var outStr:String = ""; 
		var found:Boolean = false;
		for (var i = 0; i < $str.length; i++)
		{
			if($str.charAt(i) == $replace.charAt(0))
			{   
				found = true;
				for(var j = 0; j < $replace.length; j++)
				{
					if($str.charAt(i + j) != $replace.charAt(j))
					{
						found = false;
						break;
					}
				}
				if(found)
				{
					outStr += $replaceWith;
					i = i + ($replace.length - 1);
					continue;
				}
			}
			outStr += $str.charAt(i);
		}
		return outStr;
	}
	
	public static function SplitWith1(str:String):Array
	{
		var i:Number = 0, lastPos:Number = 0;
		var strAry:Array = new Array();
		for ( ; i < str.length; ++i)
		{
			if (str.charCodeAt(i) == 1)
			{
				var strtmp:String = str.substr(lastPos, i - lastPos);
				strAry.push(strtmp);
				lastPos = i + 1;
			}
			else if (i == str.length - 1)
			{
				var strtmp:String = str.substr(lastPos, i - lastPos + 1);
				strAry.push(strtmp);
				lastPos = i + 1;
			}
		}
		return strAry;
	}
}