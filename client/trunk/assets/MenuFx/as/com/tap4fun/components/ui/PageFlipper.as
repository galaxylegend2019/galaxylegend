/*								PageFlipper
**
** com.tap4fun.components.ui.PageFlipper, link class to MovieClip or use component
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
** Better support of negative sensibility to allow inverted movements
**
** BUG Alert:
** 1 - Scrolling up to last page and continuing when !loop sometimes goes back to last page -1
** 2 - Scrolling up and then down to first page when !loop sometimes loops page 1 and 2
*/
[IconFile("icons/PageFlipper.png")]

import com.tap4fun.input.DisplacementDeltas;

class com.tap4fun.components.ui.PageFlipper extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "PageFlipper";
	static var symbolOwner:Object = PageFlipper;
	var className:String = "PageFlipper";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=false)]
	public var flipY:Boolean;
	[Inspectable(defaultValue=false)]
	public var loopPages:Boolean;
	[Inspectable(defaultValue=1)]
	public var sensibility:Number;
	[Inspectable(defaultValue=0)]
	public var endAnimFramesToSkip:Number;
	[Inspectable(defaultValue=0)]
	public var minLengthToCompleteScroll:Number;
	
	public var propertiesToApply:Array;
	
	var animation_reference:MovieClip;
	private var _deltas:DisplacementDeltas;
	private var _prevOrientation:Number;
	private var _prevPageDiff:Number;
	private var _flips:Array;
	var flip_left:MovieClip;
	var flip_right:MovieClip;
	var overlay:MovieClip;
	var mcs:Array;
	var page:Number;
	var endingAnim:Boolean;
	var animating:Boolean;
	var endToZero:Boolean;
	var dir:Number;
	var remainingDir:Number;
	
	var target:Array;
	var ref:Array;
	private var _baseIndex:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function PageFlipper()
	{
		this.propertiesToApply = new Array();
		this._deltas = new DisplacementDeltas();
		this.endingAnim = false;
		this.animating = false;
		this.animation_reference.stop();
		this.animation_reference._visible = false;
		this.overlay.stop();
		this.page = 0;
		this.endAnimFramesToSkip = (!this.endAnimFramesToSkip)?0:this.endAnimFramesToSkip;
		
		//Find pages, flips and animation references
		this.findClips();
		
		//Apply first transform
		this.assignTargets();
		this.copyTransform();
		if(this._baseIndex == undefined) trace("Error: no MovieClip with id \"base\" found in PageFlipper " + this + this._baseIndex);
		
		this.applyEventsHandlers();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function findClips():Void
	{
		this.mcs = new Array();
		this.target = new Array();
		this.ref = new Array();
		this._flips = new Array();
		
		for(var $mc in this)
		{
			if(this[$mc] instanceof MovieClip && $mc != "animation_reference" && $mc.indexOf("flip") == -1 && $mc != "overlay")
			{
				//Pages
				var $curMc:MovieClip = this[$mc];
				$curMc.page = this.mcs.length;
				if($curMc.page > 1) $curMc._visible = false;
				this.mcs.push($curMc);
			}
			else if(this[$mc] instanceof MovieClip && $mc.indexOf("flip")==0)
			{
				//Flips
				this._flips.push(this[$mc]);
			}
		}
		
		//Find Animation references
		for(var mc in this.animation_reference)
		{
			if(this.animation_reference[mc] instanceof MovieClip)
			{
				var $ref:MovieClip = this.animation_reference[mc];
				if(mc == "base")
				{
					this._baseIndex = this.ref.length;
				}
				this.ref.push($ref);
			}
		}
	}
	private function assignTargets():Void
	{
		var $refCount:Number;
		var $index:Number;
		
		$refCount = this.ref.length;
		
		//Hiding edges MovieClips
		this.target[0]._visible = false;
		this.target[this.target.length-1]._visible = false;
		
		this.target = new Array();
		
		//Applying base
		this.target[this._baseIndex] = this.mcs[this.page];
		
		//Applying pre-base
		for(var $i:Number = this._baseIndex-1; $i>=0; $i--)
		{
			//trace("page = " + this.page + ", baseIndex = " + this._baseIndex + ", $i = " + $i);
			$index = this.page-(this._baseIndex-$i);
			if($index < 0 && this.loopPages)
			{
				$index = (this.mcs.length + $index);
			}
			this.target[$i] = this.mcs[$index];
			if(this.target[$i]==undefined)trace("Undefined MovieClip in pre-base at " + $index);
		}
		//Applying post-base
		for(var $i:Number=this._baseIndex+1; $i<$refCount; $i++)
		{
			$index = this.page+$i-this._baseIndex;
			if($index>=this.mcs.length && this.loopPages)
			{
				$index = $index - (this.mcs.length);
			}
			if($index == -1 && this.loopPages) $index = this.mcs.length-1;
			this.target[$i] = this.mcs[$index];
			if(this.target[$i]==undefined)trace("Undefined MovieClip in post-base at " + $index + ", mcs length is " + this.mcs.length);
		}
		
		//Turn them all visible
		for(var $i:Number=0; $i<this.target.length; $i++)
		{
			this.target[$i]._visible = true;
		}
	}
	private function copyTransform():Void
	{
		for(var $i:Number = 0; $i < this.ref.length; $i++)
		{
			if(!this.target[$i])continue;
			
			if(this.propertiesToApply.length > 0)
			{
				var $curTarget:MovieClip = this.target[$i];
				var $curRef:MovieClip = this.ref[$i];
				
				for(var $j:Number=0; $j<this.propertiesToApply.length; $j++)
				{
					var $property:String = this.propertiesToApply[$j];
					
					if($property == "transform.matrix")
					{
						$curTarget.transform.matrix = $curRef.transform.matrix;
					}
					else $curTarget[$property] = $curRef[$property];
				}
			}
			else
			{
				this.target[$i].transform = this.ref[$i].transform;
			}
		}
	}
	private function startAnimation():Void
	{
		this._deltas.setStartingPoint();
		this.animating = true;
		this._prevPageDiff = 1;
		this.assignTargets();
		this.onEnterFrame = this.followAnimationReference;
		this.onStartFlipping();
	}
	private function getAnimFrameInfos($delta:Number):Object
	{
		//Returns an object filled with
		// .frame which is the frame the anim must show and
		// .pageDiff which is the number of pages cycled through while scrolling
		
		var $rap:Number;
		var $frame:Number;
		var $pageDiff:Number;
		var $direction:Number;
		var $lastFrame:Number;
		
		$lastFrame = this.animation_reference._totalframes;
		$rap = this.sensibility * ($delta/(this._height));
		$rap = ($rap*-1) + 1;
		$frame = (Math.round($lastFrame * $rap) - $lastFrame);
		$frame = (Math.round($lastFrame * $rap));
		
		$pageDiff = Math.floor($frame/$lastFrame);
		$frame = ($frame%$lastFrame);
		if($frame < 0)
		{
			//Negative frame...
			$frame += $lastFrame;
		}
		
		//Because the frame calculated is from 0 to _totalframes-1...
		$frame += 1;
		
		//Capping if !loop
		if(!this.loopPages)
		{
			if(this.page==0 && $delta>0)
			{
				if($frame>1 && $pageDiff<this._prevPageDiff) $frame = 1;
				return {frame:$frame, pageDiff:this._prevPageDiff};
			}
			if(this.page==this.mcs.length-1 && $delta<=0)
			{
				//To avoid the end animation
				this._deltas.setStartingPoint();
				this.dir = 0;
				return {frame:1, pageDiff:this._prevPageDiff};
			}
		}
		
		return {frame:$frame, pageDiff:$pageDiff};
	}
	private function followAnimationReference():Void
	{
		var $frameInfos:Object;
		var $frame:Number;
		
		$frameInfos = this.getAnimFrameInfos(this.flipY?this._deltas.getDeltas().y:this._deltas.getDeltas().x);
		$frame = $frameInfos.frame;
		this.dir = this._deltas.getDeltaOrientation(this.flipY?"y":"x");
		
		if(this._prevPageDiff != $frameInfos.pageDiff)
		{
			if(this._prevPageDiff > $frameInfos.pageDiff)
			{
				this.page--;
				if(this.page >= 0) this.onChange(this.page);
			}
			else
			{
				this.page++;
				if(this.page < this.mcs.length) this.onChange(this.page);
			}
		}
		if(this.page <= -1)
		{
			//Hmmm... use to be (this.page==-1) but for some mysterious reason, never evaluated to true in GameSWF...
			if(this.loopPages)
			{
				this.page = this.mcs.length-1;
				this.onChange(this.page);
			}
		}
		else if(this.page >= this.mcs.length)
		{
			//Hmmm... use to be (this.page==this.mcs.length) but for some mysterious reason, never evaluated to true in GameSWF...
			if(this.loopPages)
			{
				this.page = 0;
				this.onChange(this.page);
			}
		}
		
		this._prevPageDiff = $frameInfos.pageDiff;
		
		this.animation_reference.gotoAndStop($frame);
		if(this.overlay instanceof MovieClip) this.overlay.gotoAndStop($frame);
		this.assignTargets();
		this.copyTransform();
	}
	private function endAnimation():Void
	{
		//Called every frame after stopAnimation();
		this.endingAnim = true;
		
		if(this.endToZero)
		{
			if(this.animation_reference._currentframe >= this.animation_reference._totalframes)
			{
				if(this.remainingDir == -1)
				{
					this.page++;
					if(this.page < this.mcs.length) this.onChange(this.page);
				}
				if(this.page >= this.mcs.length && this.loopPages)
				{
					this.page = 0;
					this.onChange(this.page);
				}
				else if(this.page >= this.mcs.length && !this.loopPages)
				{
					this.page = this.mcs.length-1;
				}
				this.endingAnim = false;
				this.animation_reference.gotoAndStop(1);
				this.assignTargets();
				this.applyEventsHandlers();
				if(this.overlay instanceof MovieClip) this.overlay.gotoAndStop(this.animation_reference._currentframe);
				this.copyTransform();
				delete this.onEnterFrame;
				
				//Needed for continuous anim when flipToNext() flipToPrevious(),
				//calling flipToNext or flipToPrevious when onChange occurs...
				if(this.onEnterIdle) this.onEnterIdle();
			}
			else
			{
				var $nextFrame:Number = this.animation_reference._currentframe+this.endAnimFramesToSkip+1;
				if($nextFrame > this.animation_reference._totalframes) $nextFrame = this.animation_reference._totalframes;
				this.animation_reference.gotoAndStop($nextFrame);
				this.copyTransform();
			}
		}
		else
		{
			if(this.animation_reference._currentframe <= 1)
			{
				if(this.page < 0 && this.loopPages) this.page = this.mcs.length-1;
				else if(this.page < 0 && !this.loopPages) this.page = 0;
				this.endingAnim = false;
				this.applyEventsHandlers();
				if(this.overlay instanceof MovieClip) this.overlay.gotoAndStop(this.animation_reference._currentframe);
				this.copyTransform();
				delete this.onEnterFrame;
				
				//Needed for continuous anim when flipToNext() flipToPrevious(),
				//calling flipToNext or flipToPrevious when onChange occurs...
				if(this.onEnterIdle) this.onEnterIdle();
			}
			else
			{
				var $nextFrame:Number = this.animation_reference._currentframe-this.endAnimFramesToSkip-1;
				if($nextFrame < 1) $nextFrame = 1;
				this.animation_reference.gotoAndStop($nextFrame);
				this.copyTransform();
			}
		}
		if(this.overlay instanceof MovieClip) this.overlay.gotoAndStop(this.animation_reference._currentframe);
	}
	private function stopAnimation($forceDir:Number):Void
	{
		//Called when flips are released to force the animation to play until the main page is placed correctly
		this.removeEventsHandlers();
		this.animating = false;
		
		//When loopPages is false and page is last
		if(!this.loopPages && this.page==this.mcs.length-1 && $forceDir!=-1 && this.dir!=-1)
		{
			this.endingAnim = false;
			this.animation_reference.gotoAndStop(1);
			if(this.overlay instanceof MovieClip) this.overlay.gotoAndStop(this.animation_reference._currentframe);
			this.assignTargets();
			this.applyEventsHandlers();
			this.copyTransform();
			delete this.onEnterFrame;
			if(this.onEnterIdle) this.onEnterIdle();
			
			return;
		}
		
		if($forceDir!=undefined)var $forceEndToZero:Boolean = ($forceDir==1);
		
		if($forceEndToZero != undefined)
		{
			this.endToZero = $forceEndToZero;
			if(!this.endToZero)
			{
				this.animation_reference.gotoAndStop(this.animation_reference._totalframes-1);
				this.page--;
				if(this.page<0 && this.loopPages) this.page = this.mcs.length-1;
				this.onChange(this.page);
				this.assignTargets();
				this.copyTransform();
			}
		}
		else
		{
			if(this.flipY)
			{
				if (this._deltas.getVectorLength() > this.minLengthToCompleteScroll)
				{
					this.endToZero = this._deltas.getDeltaOrientation("y") < 0;
				}
				else
				{
					this.endToZero = this._deltas.getDeltaOrientation("y") > 0;
					this.dir *= -1;
				}
			}
			else
			{
				if (this._deltas.getVectorLength() > this.minLengthToCompleteScroll)
				{
					this.endToZero = this._deltas.getDeltaOrientation("x") < 0;
				}
				else
				{
					this.endToZero = this._deltas.getDeltaOrientation("x") > 0;
					this.dir *= -1;
				}
			}
		}
		if($forceDir)
		{
			this.remainingDir = $forceDir;
			if($forceDir==1)
			{
				this.page++;
				if(this.page>=this.mcs.length && this.loopPages) this.page = 0;
				this.onChange(this.page);
			}
		}
		else this.remainingDir = this.dir;
		this.onEnterFrame = this.endAnimation;
	}
	private function forceAnim($dir:Number):Void
	{
		this.stopAnimation($dir);
	}
	private function onFlipPress():Void
	{
		if(!this._parent.endingAnim) this._parent.startAnimation();
	}
	private function onFlipRelease():Void
	{
		if(this._parent.animating) this._parent.stopAnimation();
	}
	private function applyEventsHandlers():Void
	{
		var $curFlip:MovieClip;
		
		for(var $i:Number = 0; $i<this._flips.length; $i++)
		{
			$curFlip = this._flips[$i];
			$curFlip.onPress = onFlipPress;
			$curFlip.onRelease = $curFlip.onReleaseOutside = onFlipRelease;
		}
	}
	private function removeEventsHandlers():Void
	{
		var $curFlip:MovieClip;
		
		for(var $i:Number = 0; $i<this._flips.length; $i++)
		{
			$curFlip = this._flips[$i];
			$curFlip.onPress = $curFlip.onRelease = $curFlip.onReleaseOutside = function():Void{};
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function clear():Void
	{
		trace("To implement clear() in " + this);
	}
	public function setItems($values:Array):Void
	{
		trace("To implement setItems() in " + this);
		/*this.clear();
		
		for(var $i = 0; $i < $values.length; $i++)
		{
			 this.addItem($values[$i]);
		}*/
	}
	public function addItem($values:Object):Void
	{
		trace("To implement addItem() in " + this);
		//var $mc:MovieClip = this.attachMovie($mc_id, $mc_id + random(999), this.getNextHighestDepth());
	}
	public function setItem($index:Number, $values:Object):Void
	{
		trace("To implement setItem() in " + this);
	}
	public function getItem($index:Number):MovieClip
	{
		trace("To implement getItem() in " + this);
		return(new MovieClip());
	}
	public function flipToPrevious():Void
	{
		if((this.page-1 < 0 && !this.loopPages) || this.endingAnim)
		{
			return;
		}
		this.forceAnim(-1);
	}
	public function flipToNext():Void
	{
		if((this.page+1 >= this.mcs.length && !this.loopPages) || this.endingAnim)
		{
			return;
		}
		this.forceAnim(1);
	}
	public function setPage($page:Number):Void
	{
		for(var $i:Number=0; $i<this.mcs.length; $i++)
		{
			this.mcs[$i]._visible = false;
		}
		this.page = $page;
		this.animation_reference.gotoAndStop(1);
		this.assignTargets();
		this.copyTransform();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getValue():Number
	{
		return this.page;
	}
	public function getPageMovieClip():MovieClip
	{
		return this.mcs[this.page];
	}
	public function setFlipY($flipY:Boolean):Void
	{
		this.flipY = $flipY;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onChange($page:Number):Void{}
	public function onEnterIdle():Void{}
	public function onStartFlipping():Void{}
}