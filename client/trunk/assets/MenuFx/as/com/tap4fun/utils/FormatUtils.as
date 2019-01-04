/**
 * ...
 * @author zhuyubin
 */
class com.tap4fun.utils.FormatUtils
{
	public static var LAN_EN:Number = 0;
	public static var LAN_FR:Number = 1;
	public static var LAN_DE:Number = 2;
	public static var LAN_SP:Number = 3;
	public static var LAN_IT:Number = 4;
	public static var LAN_BR:Number = 5;
	public static var LAN_JP:Number = 6;
	public static var LAN_KR:Number = 7;
	public static var LAN_CN:Number = 8;
	public static var LAN_RU:Number = 9;
	
	public static var s_curLan:Number = 0;
	
	public function FormatUtils() 
	{
	}
	
	public static function formatTimeInSec($inSec:Number):String 
	{
		var timeStr:String = "";
		var tmpNum = Math.floor($inSec / (3600 * 24));		
		if (tmpNum > 0)
		{
			timeStr = String(tmpNum) + "D:";
			$inSec -= tmpNum * 3600 * 24;
		}
		
		tmpNum = Math.floor($inSec / 3600);
		if (tmpNum > 0)
		{
			timeStr = timeStr + (tmpNum >= 10 ? "" : "0") + String(tmpNum) + ":";
		}
		
		tmpNum = Math.floor(($inSec % 3600) / 60);
		timeStr = timeStr + (tmpNum >= 10 ? "" : "0") + String(tmpNum) + ":";
			
		tmpNum = Math.floor($inSec % 60);
		timeStr = timeStr + (tmpNum >= 10 ? "" : "0") + String(tmpNum);
		
		return timeStr;		
	}
		
	/**************************************************************
	parameter:
		$milliseconds:	milliseconds from 1970/1/1 00:00:00.
	return:
		String:			String in format:
						"month/date/year hours:minutes:seconds"
	**************************************************************/
	public static function formatDateToString($milliseconds:Number) : String
	{
		//var $tmpDate = new Date(1970, 0, 1, 0, 0, 0, $milliseconds);
		var $tmpDate = new Date($milliseconds);
		var $tmpStr:String = ($tmpDate.getMonth() + 1) + "/" + $tmpDate.getDate() + "/" + Number($tmpDate.getFullYear() - 2000);
		
		$tmpStr += " " + $tmpDate.getHours() + ":";
		$tmpStr += ($tmpDate.getMinutes() >= 10 ? "" : "0") + $tmpDate.getMinutes();// + ":";
		//$tmpStr += ($tmpDate.getSeconds() >= 10 ? "" : "0") + $tmpDate.getSeconds();
		
		delete $tmpDate;
		
		return $tmpStr;
	}
	
	/**
	 * translate the number to game display format like "789"/"123.45K"/"54.87M"/"5.15B".
	 * @param	$num : will be formated number.
	 * @return	:string in game display format.
	 */
	public static function formatNumberToDisString($num):String 
	{
		var BASE_K:Number = 1000;
		var BASE_M:Number = BASE_K * BASE_K;
		var BASE_B:Number = BASE_K * BASE_K * BASE_K;
		
		var numStr:String = "";
		var unitStr:String = "";
		if ($num >= BASE_B)
		{
			numStr = String($num / BASE_B);
			unitStr = "B";
		}
		else if ($num >= BASE_M)
		{
			numStr = String($num / BASE_M);
			unitStr = "M";
		}
		else if ($num >= BASE_K)
		{
			numStr = String($num / BASE_K);
			unitStr = "K";
		}
		else 
		{
			numStr = String($num);
			unitStr = "";
		}
		
		var pointPos:Number = numStr.indexOf(".");
		if (pointPos > 0 && numStr.length > (pointPos + 3))
		{
			numStr = numStr.substr(0, pointPos + 3);
		}
		
		return (numStr + unitStr);
	}
	
	public static function setCurLan($inLan:Number):Void 
	{
		s_curLan = $inLan;
	}

	/**************************************************************
	parameter:
		$inNum: 			will be formated number.
		$decimalsLen: 	the length of decimals part. if not set, 
						then the return string will no decimals part
	**************************************************************/
	static public function formatLocalNumber($inNum:Number, $decimalsLen:Number):String
	{
		switch(Number(s_curLan))
		{
		case LAN_EN:
		case LAN_JP:
		case LAN_KR:
		case LAN_CN:
			return formatNumber($inNum, ",", 3, ".", $decimalsLen);
		case LAN_FR:
		case LAN_RU:
		case LAN_SP:
			return formatNumber($inNum, " ", 4, ",", $decimalsLen);
		case LAN_DE:
		case LAN_IT:
		case LAN_BR:
			return formatNumber($inNum, ".", 3, ",", $decimalsLen);
		default:
			return $inNum.toString();
		}
	}

	private static function formatNumber($inNum:Number, $separator:String, $minimumSeparateLen:Number, $decPoint:String, $decimalsLen:Number ):String
	{
		var num:Number = Math.abs($inNum);
		var integer:Number = Math.floor(num);
		var decimals:Number = num - integer;
		var lPart:String = integer.toString();
		var rPart:String = decimals.toString().substr(2);
		var outStr:String = "";
		
		
		var len:Number = lPart.length;
		var fLen:Number = lPart.length % 3;
		if( $minimumSeparateLen != undefined && len <= $minimumSeparateLen)
		{
			outStr = lPart;
		}
		else
		{
			while(len > 3)
			{
				len -= 3;
				outStr = $separator + lPart.substr(len, 3) + outStr;
			}
			outStr = lPart.substr(0, ( fLen  == 0 ? 3 : fLen ) ) + outStr;
		}
		
		$decimalsLen = ($decimalsLen == undefined ? 0 : $decimalsLen);
		if(rPart.length > 0 && $decimalsLen > 0)
		{
			if(rPart.length < $decimalsLen)
			{
				outStr += ($decPoint + rPart);
				for(var i:Number = 0; i < $decimalsLen - rPart.length; ++i)
				{
					outStr += "0";
				}
			}
			else
			{
				outStr += ($decPoint + rPart.substr(0, $decimalsLen));
			}
		}

		return (($inNum < 0) ? "-" : "") + outStr;
	}
	
}