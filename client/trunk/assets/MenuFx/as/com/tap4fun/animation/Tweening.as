import mx.transitions.easing.*;
import com.tap4fun.StaticFunctions;

class com.tap4fun.animation.Tweening
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	var func:Function;
	var frames:Number;
	var currentTick:Number;
	var frameDuration:Number;
	var targets:Array;
	var intervalId:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Tweening()
	{
		this.targets = new Array();
		this.setFPS(30);
		this.frames = 60;
		this.func = Regular.easeOut;
		this.currentTick = 0;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onTick():Void
	{
		for(var $i = 0; $i < this.targets.length; $i++)
		{
			var $target  = this.targets[$i];
			var $currentTick = $target.tweeningInfos.currentTick;
			
			for(var $prop in $target.tweeningInfos.from)
			{
				$target[$prop] = $target.tweeningInfos.func($target.tweeningInfos.currentTick, $target.tweeningInfos.from[$prop], $target.tweeningInfos.to[$prop] - $target.tweeningInfos.from[$prop], $target.tweeningInfos.frames);
			}
			if(++$target.tweeningInfos.currentTick > $target.tweeningInfos.frames)
			{
				if ($target.onDestination) $target.onDestination();
				delete $target.tweeningInfos;
				StaticFunctions.removeElement(this.targets, $target);
			}
		}
		if(this.targets.length <= 0) stopAnimating();
		//updateAfterEvent();
	}
	public function startAnimating():Void
	{
		if (this.intervalId != null || this.intervalId != undefined) this.stopAnimating();
		this.onTick();
		this.intervalId = setInterval(this, "onTick", this.frameDuration);
	}
	public function stopAnimating():Void
	{
		clearInterval(this.intervalId);
		this.intervalId = null;
	}
	public function addTweened($target:MovieClip, $func:Function, $from:Object, $to:Object, $frames:Number):Void
	{
		if ($target.tweeningInfos == undefined)
		{
			$target.tweeningInfos = {func:$func, from:$from, to:$to, frames:$frames, currentTick:0};
		}
		else
		{
			//Already a tween target, appending / replacing tween properties
			$target.tweeningInfos.func = $func;
			for (var $i in $from)
			{
				$target.tweeningInfos.from[$i] = $from[$i];
			}
			for (var $i in $to)
			{
				$target.tweeningInfos.to[$i] = $to[$i];
			}
			$target.tweeningInfos.frame = $frames;
			$target.tweeningInfos.currentTick = 0;
		}
		if(!StaticFunctions.isInArray(this.targets, $target))this.targets.push($target);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setFPS($fps:Number):Void
	{
		this.frameDuration = 1000/$fps;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Events												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}