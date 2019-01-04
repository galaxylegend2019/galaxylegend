/*								Credits
**
*********Properties****************************Description******
**
*********Methods****************************Description*******
**
*********Events*****************************Description*******
**
*********TODO*************************************************
**
*/
import com.tap4fun.input.DisplacementDeltas;

[IconFile("icons/Credits.png")]
class com.tap4fun.components.animation.Credits extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "Credits";
	static var symbolOwner:Object = Credits;
	var className:String = "Credits";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=true)]
	public var loop:Boolean;
	[Inspectable(defaultValue="2:00")]
	public var duration:String;
	[Inspectable(name="credits", defaultValue="")]
	public var creditsString:String;
	
	private var _target:MovieClip;
	private var creditLine:MovieClip;
	private var _credits:String;
	private var _splittedCredits:Array;
	private var _targetHeight:Number;
	private var _targetWidth:Number;
	private var _totalCreditsHeight:Number;
	private var _lineHeight:Number;
	public var _trueFpsFound:Boolean;
	public var _fps:Number;
	private var _speed:Number;
	private var _dragLength:Number;
	private var _duration:Number;
	private var _durationMin:Number;
	private var _durationSec:Number;
	private var _setted:Boolean;
	private var _scrollEnabled:Boolean;
	private var _displaceDeltas:DisplacementDeltas;
	private var _isDragging:Boolean;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Credits()
	{
		//this._credits = "";
		this.creditLine._visible = false;
		this._splittedCredits = new Array();
		this._targetHeight = this._height;
		this._targetWidth = this._width;
		this._totalCreditsHeight = 0;
		this._lineHeight = 0;
		this._trueFpsFound = false;
		this._fps = 30;
		this._setted = false;
		_scrollEnabled = false;
		_isDragging = false;
		
		this.setCreditsString(this.creditsString);
		this.setLoop(this.loop);
		this.setDuration(this.duration);
		
		//Events
		this.onFpsFound = function():Void{};
		this.onLineAttached = function($line:MovieClip):Void{};
		this.onLoop = function():Void{};
		this.onFinished = function():Void{};
		this.onStarted = function():Void { };
		//this.init();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function findLineHeight():Number
	{
		return this.creditLine._height;
	}
	private function _onFpsFound():Void
	{
		this.setDuration(this.duration);
		this.onFpsFound();
	}
	private function findTotalCreditsHeight():Number
	{
		this._totalCreditsHeight = this._lineHeight * this.getNumberOfLines();
		return this._totalCreditsHeight;
	}
	private function attachLine($index:Number):MovieClip
	{
		var $next_depth:Number = this.getNextHighestDepth();
		var $currentString:String = this._splittedCredits[$index];
		var $current_line:MovieClip = this.creditLine.duplicateMovieClip("credits_line_" + $next_depth, $next_depth);
		
		$current_line.gotoAndStop("init");
		if (!$currentString)
		{
			$current_line.container.tf.htmlText = "";
		}
		else
		{
			$current_line.container.tf.htmlText = $currentString;
			$current_line.gotoAndPlay("show");
			$current_line.onAnimationEnd = function():Void
			{
				this.gotoAndPlay("scrolling");
				this.onAnimationEnd = function():Void
				{
					this.gotoAndPlay("scrolling");
				};
			};
		}
		$current_line._x = 0;
		$current_line._y = this._targetHeight;
		
		$current_line._index = $index;
		$current_line._credits = this;
		
		this.onLineAttached($current_line);
		
		$current_line.onEnterFrame = function():Void
		{
			this._credits.updateLine(this);
		};
		return $current_line;
	}
	private function updateLine($line:MovieClip):Void
	{
		if (_scrollEnabled && _isDragging)
		{
			$line._y += _dragLength;
		}
		else
		{
			$line._y -= this._speed;
		}
		
		if($line._y <= (this._targetHeight - $line._height))
		{
			var $numLines:Number = this.getNumberOfLines();
			
			if(!$line._nextLineAttached && $line._index < $numLines)
			{
				//Nouvelle ligne ajoutée
				this.attachLine(++$line._index);
				$line._nextLineAttached = true;
			}
			else if($line._index >= $numLines && !$line._nextLineAttached  && this.loop)
			{
				//Loop
				this.onLoop();
				this.attachLine(0);
				$line._nextLineAttached = true;
			}
		}
		if($line._y <= 0 + $line._height && !$line.playing_hide)
		{
			$line.gotoAndPlay("hide");
			$line.playing_hide = true;	
			$line.hide_frame = $line._currentFrame;
			
			$line.onAnimationEnd = function():Void
			{
				if(this._currentframe != this["hide_frame"])
				{
					this.swapDepths(15000);
					this.removeMovieClip();
				}
			};
		}
	}
	private function onStartDrag():Void
	{
		_isDragging = true;
		_displaceDeltas.setStartingPoint();
		onEnterFrame = onDragUpdate;
	}
	private function onStopDrag():Void
	{
		_isDragging = false;
		_displaceDeltas.setStartingPoint();
		_dragLength = 0;
		onEnterFrame = null;
	}
	private function onDragUpdate():Void
	{
		_dragLength = _displaceDeltas.getDeltas().y;
		if (_dragLength > 0) _dragLength = 0;
		_displaceDeltas.setStartingPoint();
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setAndStart($creditsString:String, $duration_minutes:Number, $duration_seconds:Number, $loop:Boolean):Boolean
	{
		//TODO: Not quite working... recheck later...
		if(!this._setted)
		{
			trace("Credits Not set");
			this.setCreditsString($creditsString);
			this.findLineHeight();
			this.findTotalCreditsHeight();
			this.setDuration(this.duration);
			this.loop = $loop;
			this.start();
			this._setted = true;
			return true;
		}
		else
		{
			trace("Credits Set");
			return false;
		}
	}
	public function start():Void
	{
		stop();
		
		if(!this._setted)
		{
			this.setDuration(this.duration);
			this.onStarted();
			this.attachLine(0);
			this._setted = true;
		}
	}
	public function stop():Void
	{
		for(var $i in this)
		{
			if(this[$i]._name != undefined && this[$i]._name.indexOf("credits_line_") == 0)
				this[$i].removeMovieClip();
		}
		
		this._setted = false;
	}
	public function findFPS():Void
	{
		var $fps_counter:MovieClip =_root.createEmptyMovieClip("_FPS_Counter",_root.getNextHighestDepth()); 
		
		$fps_counter._credits = this;
		$fps_counter.iteration = 0;
		$fps_counter.frameRates = Array();
		
		$fps_counter.onEnterFrame = function()
		{
			if(this.iteration < 5)
			{
				this.t = getTimer();
				if(this.iteration > 0)
				{
					this.frameRates[this.iteration] = Math.round(1000 / (this.t - this.o));
				}
				this.o = this.t;
				this.iteration++;
			}
			else
			{
				var $totFps:Number = 0;
				for(var $i:Number = 1; $i < this.frameRates.length; $i++)
				{
					$totFps += this.frameRates[$i];
				}
				this._credits._fps = $totFps / (this.frameRates.length-1);
				this._credits._trueFpsFound = true;
				this._credits._onFpsFound();
				delete this.onEnterFrame;
				this.removeMovieClip();
			}
		};
	}
	public function setCreditsString($str:String):Void
	{
		this._credits = new String($str);
		this._splittedCredits = this._credits.split("\n");
		this.findTotalCreditsHeight();
	}
	public function getCreditsString():String
	{
		return this._credits;
	}
	public function getNumberOfLines():Number
	{
		return this._splittedCredits.length;
	}
	public function setDuration($duration:String):Void
	{
		this.duration = $duration;
		var $split:Array = $duration.split(":");
		var $min:Number = Number($split[0]);
		var $sec:Number = Number($split[1]);
		this._durationMin = $min;
		this._durationSec = $sec;
		var $sec_b100:Number = $sec * 0.6;
		this._duration = $min + ($sec/60);
		this._speed = (this._totalCreditsHeight+this._targetHeight)/(this._duration*this._fps*60);
	}
	public function setSpeed($speed:Number):Void
	{
		this._speed = $speed;
	}
	public function getSpeed():Number
	{
		return this._speed;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//									Getters and Setters											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	/*public function get targetHeight():Number
	{
		return this._targetHeight;
	}*/
	/*public function get creditsString():String
	{
		return this._credits;
	}
	public function set creditsString($str:String):Void
	{
		this.setCreditsString($str);
	}*/
	
	public function setLoop($loop:Boolean):Void
	{
		this.loop = $loop;
	}
	public function getLoop():Boolean
	{
		return this.loop;
	}
	public function setScrollEnabled($enable:Boolean):Void
	{
		_scrollEnabled = $enable;
		
		if ($enable)
		{
			this.onPress = onStartDrag;
			this.onRelease = this.onReleaseOutside = onStopDrag;
			_displaceDeltas = new DisplacementDeltas();
		}
		else
		{
			this.onRelease = this.onReleaseOutside = this.onPress = null;
			if (_displaceDeltas) _displaceDeltas = null;
		}
	}
	public function getScrollEnabled():Boolean
	{
		return _scrollEnabled;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Events												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onFpsFound():Void{}
	public function onLineAttached($line:MovieClip):Void{}
	public function onLoop():Void{}
	public function onFinished():Void{}
	public function onStarted():Void{}
}