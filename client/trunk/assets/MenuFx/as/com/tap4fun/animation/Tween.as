//****************************************************************************
//Copyright (C) 2003-2005 Macromedia, Inc. All Rights Reserved.
//The following is Sample Code and is subject to all restrictions on
//such code as contained in the End User License Agreement accompanying
//this product.
//import mx.transitions.OnEnterFrameBeacon;
//TODO: Hmmmm... Why isn't it workin in GameSWF... anymore
class com.tap4fun.animation.Tween
{
	//static var __initBeacon = OnEnterFrameBeacon.init();
	/////////////////////////////////////////////////////////////////////////
	/*  constructor for Tween class
	$target: reference - the object which the Tween targets
	$prop: string - name of the property (in $target) that will be affected
	$begin: number - the starting value of prop
	$duration: number - the length of time of the motion; set to infinity if negative or omitted
	$useSeconds: boolean - a flag specifying whether to use seconds instead of frames
	
	myTween = Tween.animate(target, "_property", TypeOfTween.easeMethod, start_val, end_val, duration, useSeconds:Bool);
	propeties: "_alpha", "_xscale", "_yscale", "_x", "_y", "_rotation", "_height", "_width"
	TypeOfTweens: Back, Bounce, Elastic, Regular, Strong, None
	easeMethods: easeIn, easeOut, easeInOut
	
	//Methods
	continueTo
	yoyo
	startEnterFrame
	stopEnterFrame
	start
	stop
	resume
	rewind
	fforward
	nextFrame
	onEnterFrame
	prevFrame
	toString
	
	//Explicit getters and setters
	setTime
	getTime
	setDuration
	getDuration
	setFPS
	getFPS
	setPosition
	getPosition
	setFinish
	getFinish
	
	//Events
	onMotionLooped
	onMotionFinished
	onMotionChanged
	onMotionStarted
	onMotionStopped
	onMotionResumed
	
	//Example:
	import mx.transitions.easing.*;
	import com.tap4fun.animation.Tween;
	myTween = Tween.animate(mcTweenTarget, "_rotation", Bounce.easeInOut, 0, 360, 400, false);
	*/
	static function animate($target:MovieClip, $prop:String, $func:Function, $begin:Number, $finish:Number, $duration:Number, $useSeconds:Boolean):MovieClip
	{
		//var $object_name:String = $target._name + $target.getNextHighestDepth() + Math.random(1000);
		var $object_name:String = "com.tap4fun.Tween." + $prop;
		$target[$object_name].removeMovieClip();
		var $object:MovieClip = $target.createEmptyMovieClip($object_name, $target.getNextHighestDepth());
		//This object is returned by animate(), you can use it if you want to reference this tween
		
		$object._construct = function():Void 
		{
			/*__initBeacon = OnEnterFrameBeacon.init();
			OnEnterFrameBeacon.init();*/
			/*AsBroadcaster.initialize(this);
			this.addListener(this);*/
			
			//Applying methods
			this.continueTo = continueTo;
			this.yoyo = yoyo;
			this.startEnterFrame = startEnterFrame;
			this.stopEnterFrame = stopEnterFrame;
			this.start = start;
			this.stop = stop;
			this.resume = resume;
			this.rewind = rewind;
			this.fforward = fforward;
			this.nextFrame = nextFrame;
			this.onEnterFrame = onEnterFrame;
			this.prevFrame = prevFrame;
			this.toString = toString;
			this.fixTime = fixTime;
			this.update = update;
			this.destruct = destruct;
			
			//Applying Getters and Setters
			this.setTime = setTime;
			this.getTime = getTime;
			this.setDuration = setDuration;
			this.getDuration = getDuration;
			this.setFPS = setFPS;
			this.getFPS = getFPS;
			this.setPosition = setPosition;
			this.getPosition = getPosition;
			this.setFinish = setFinish;
			this.getFinish = getFinish;
			
			//Setting properties
			this.obj = $target;
			this.prop = $prop;
			this.begin = $begin;
			
			//Events
			this.onMotionLooped = function(){};
			this.onMotionFinished = function(){};
			this.onMotionChanged = function(){};
			this.onMotionStarted = function(){};
			this.onMotionStopped = function(){};
			this.onMotionResumed = function(){};
			
			this.useSeconds = $useSeconds;
			if ($func)this.func = $func;
			this.setPosition($begin);
			this.setDuration($duration);
			this.setFinish($finish);
			
			this._listeners = [];
			this.addListener (this);
			this.start();
		};
		function destruct():Void
		{
			delete this.onMotionLooped;
			delete this.onMotionFinished;
			delete this.onMotionChanged;
			delete this.onMotionStarted;
			delete this.onMotionStopped;
			delete this.onMotionResumed;
			//delete __initBeacon;
			delete this._listeners;
			this.removeMovieClip();
			delete this;
		};
		//Calling the constructor
		$object._construct();
		
		//////////////////////////////////////////////////////////////////////
		//						Getters and Setters							//
		//////////////////////////////////////////////////////////////////////
		function setTime(t:Number):Void
		{
			this.prevTime = this._time;
			if (t>this.getDuration())
			{
				if (this.looping)
				{
					this.rewind(t-this._duration);
					this.update();
					//this.broadcastMessage("onMotionLooped", this);
					this.onMotionLooped(this);
				}
				else
				{
					if (this.useSeconds)
					{
						this._time = this._duration;
						this.update();
					}
					this.stop();
					//this.broadcastMessage("onMotionFinished", this);
					this.onMotionFinished(this);
				}
			}
			else if (t<0)
			{
				this.rewind();
				this.update();
			}
			else
			{
				this._time = t;
				this.update();
			}
		}
		function getTime():Number
		{
			return this._time;
		}
		function setDuration(d:Number):Void
		{
			this._duration = (d == null || d<=0) ? _global.Infinity : d;
		}
		function getDuration():Number
		{
			return this._duration;
		}
		function setFPS(fps:Number):Void
		{
			var oldIsPlaying = this.isPlaying;
			this.stopEnterFrame();
			this._fps = fps;
			if (oldIsPlaying)
			{
				this.startEnterFrame();
			}
		}
		function getFPS():Number
		{
			return this._fps;
		}
		function setPosition(p:Number):Void
		{
			this.prevPos = this._pos;
			this.obj[this.prop] = this._pos=p;
			//this.broadcastMessage("onMotionChanged", this, this._pos);
			this.onMotionChanged(this, this._pos);
			// added updateAfterEvent for setInterval-driven motion
			// updateAfterEvent();
		}
		function getPosition(t:Number):Number
		{
			if (t == undefined)
			{
				t = this._time;
			}
			return this.func(t, this.begin, this.change, this._duration);
		}
		function setFinish(f:Number):Void
		{
			this.change = f-this.begin;
		}
		function getFinish():Number
		{
			return this.begin+this.change;
		}
		//////////////////////////////////////////////////////////////////////
		//								Methods								//
		//////////////////////////////////////////////////////////////////////
		function continueTo($finish:Number, $duration:Number):Void
		{
			this.begin = this.getPosition();
			this.setFinish($finish);
			if ($duration != undefined)
			{
				this.setDuration($duration);
			}
			this.start();
		}
		function yoyo():Void
		{
			this.continueTo(this.begin, this.getTime());
		}
		function startEnterFrame():Void
		{
			if (this._fps == undefined)
			{
				// original frame rate dependent way
				_global.MovieClip.addListener(this);
			}
			else
			{
				// custom frame rate
				this._intervalID = setInterval(this, "onEnterFrame", 1000/this._fps);
			}
			this.isPlaying = true;
		}
		function stopEnterFrame():Void
		{
			if (this._fps == undefined)
			{
				// original frame rate dependent way:
				_global.MovieClip.removeListener(this);
			}
			else
			{
				// custom frame rate
				clearInterval(this._intervalID);
			}
			this.isPlaying = false;
		}
		function start():Void
		{
			this.rewind();
			this.startEnterFrame();
			//this.broadcastMessage("onMotionStarted", this);
			this.onMotionStarted(this);
		}
		function stop():Void
		{
			this.stopEnterFrame();
			//this.broadcastMessage("onMotionStopped", this);
			this.onMotionStopped(this);
		}
		function resume():Void
		{
			this.fixTime();
			this.startEnterFrame();
			//this.broadcastMessage("onMotionResumed", this);
			this.onMotionResumed(this);
		}
		function rewind(t):Void
		{
			this._time = (t == undefined) ? 0 : t;
			this.fixTime();
			this.update();
			// added Mar. 18, 2003
		}
		function fforward():Void
		{
			this.setTime(this._duration);
			this.fixTime();
		}
		function nextFrame():Void
		{
			if (this.useSeconds)
			{
				this.setTime((getTimer()-this._startTime)/1000);
			}
			else
			{
				this.setTime(this._time+1);
			}
		}
		function onEnterFrame():Void
		{
			this.nextFrame();
		}
		function prevFrame():Void
		{
			if (!this.useSeconds)
			{
				this.time = this._time-1;
			}
		}
		function toString():String
		{
			return "[Tween]";
		}
		//////////////////////////////////////////////////////////////////////
		//							Private Methods							//
		//////////////////////////////////////////////////////////////////////
		function fixTime():Void
		{
			if (this.useSeconds)
			{
				this._startTime = getTimer()-this._time*1000;
			}
		}
		function update():Void
		{
			this.setPosition(this.getPosition(this._time));
		}
		return $object;
	}
}