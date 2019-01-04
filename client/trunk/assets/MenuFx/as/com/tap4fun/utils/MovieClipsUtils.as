import flash.geom.Point;

class com.tap4fun.utils.MovieClipsUtils
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var activeMovieClips:Array;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function MovieClipsUtils()
	{
		
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function findActiveMovieClips($startMc:MovieClip, $childMaxDepth:Number):Void
	{
		this.activeMovieClips = new Array();
		
	}
	public function findActiveMcUnderMouse():MovieClip
	{
		var $curMc:MovieClip;
		
		for(var $i:Number = 0; $i<this.activeMovieClips.length; $i++)
		{
			$curMc = this.activeMovieClips[$i];
			if(MovieClipsUtils.mouseContactWithMovieClip($curMc, true, true))
			{
				return $curMc;
			}
		}
		return null;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Static Functions										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public static function isMovieClip($mc):Boolean
	{
		return $mc instanceof MovieClip;
	}
	public static function isMouseOver($mc:MovieClip, $checkForHitzone:Boolean):Boolean
	{
		if ($checkForHitzone)
		{
			if ($mc.hitzone instanceof MovieClip) $mc = $mc.hitzone;
		}
		
		var $coords:Object = new Object();
		$coords = $mc.getBounds(_root);
		var $min:Point = new Point($coords.xMin, $coords.yMin);
		var $max:Point = new Point($coords.xMax, $coords.yMax);
		
		return(_root._xmouse >= $min.x && _root._xmouse <= $max.x && _root._ymouse >= $min.y && _root._ymouse <= $max.y);
	}
	public static function containsEventHandler($mc:MovieClip):Boolean
	{
		return ($mc.onPress || $mc.onRelease || $mc.onReleaseOutside || $mc.onRollOver || $mc.onRollOut || $mc.on_focus_in || $mc.on_focus_out);
	}
	public static function mouseContactWithMovieClip($mc, $mustContainHandler:Boolean, $checkForHitzone:Boolean):Boolean
	{
		var $handlerOk:Boolean = (!$mustContainHandler || MovieClipsUtils.containsEventHandler($mc));
		
		return ($handlerOk && MovieClipsUtils.isMovieClip($mc) && MovieClipsUtils.isMouseOver($mc, $checkForHitzone));
	}

	public static function getGlobalPosition($mc:MovieClip):Object
	{
		var $pt:Object = { x : 0, y : 0 };
		$mc.localToGlobal($pt);
		return $pt;
	}

	public static function getRelativePosition($mc:MovieClip, $refMc:MovieClip):Object
	{
		var $pt = getGlobalPosition($mc);
		$refMc.globalToLocal($pt);
		return $pt;
	}

	public static function getFullPathName($mc):String
	{
		var $pathName:String = '';
		while ($mc != null)
		{
			if ($mc._name.length > 0)
			{
				$pathName = $mc._name + '.' + $pathName;
			}
			$mc = $mc._parent;
		}
		
		var $begin = $pathName.charAt(0) == '.' ? 1 : 0
		var $end = $pathName.charAt($pathName.length - 1) == '.' ? $pathName.length - 1 : $pathName.length;
		return $pathName.slice($begin, $end);
	}	

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setActiveMcs($mcs:Array):Void
	{
		this.activeMovieClips = $mcs;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
}