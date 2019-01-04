/*								ButtonsList
**
**
*********Properties****************************Description******
*********Methods****************************Description*******
**
*********Events*****************************Description*******
**
*********TODO*************************************************
**
*/
import com.tap4fun.input.DragToValue;
import com.tap4fun.utils.MovieClipsUtils;

[IconFile("icons/AlertMenu.png")]
dynamic class com.tap4fun.components.ui.ButtonsList extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "ButtonsList";
	static var symbolOwner:Object = ButtonsList;
	var className:String = "ButtonsList";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	[Inspectable (defaultValue=false)]
	public var loop:Boolean;
	[Inspectable (defaultValue=false)]
	public var xBased:Boolean;
	[Inspectable (defaultValue=0.5)]
	public var dragSensibility:Number;
	[Inspectable (defaultValue=0)]
	public var throwFriction:Number;
	[Inspectable (defaultValue=5)]
	public var releaseArea:Number;
	
	public var indexIncrements:Number = 1;
	
	public var snapBottom:Boolean = false;
	
	public var dataLength:Number = null;
	public var lastIndex:Number;
	
	private var _buttonsQty:Number;
	private var _buttonsQtyPre:Number;
	private var _buttonsQtyPost:Number;
	
	private var _isAnimating:Boolean;
	private var _animatingDirection:Number;
	
	private var _data:Array;
	private var _labelMemberName:String;
	private var _iconMemberName:String;
	
	private var _currentIndex:Number;
	private var _targetIndex:Number;
	
	private var _mainButtons:Array;
	
	//MovieClips
	public var dragHandler:MovieClip;
	public var dragToValue:DragToValue;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ButtonsList()
	{
		this._data = new Array();
		if(!this.loop)this.loop = false;
		this._currentIndex = 0;
		this._targetIndex = 0;
		this._isAnimating = false;
		this._mainButtons = new Array();
		this.calculateButtonsQty();
		this.applyEventsHandlersToButtons();
		
		if(this.dragHandler) this.constructDragHandler();
		
		this.gotoAndStop("idle");
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function calculateButtonsQty():Void
	{
		var $btn:MovieClip;
		var $index:Number;
		var $pos:String;
		
		//Pre
		$pos = "pre";
		$index = 0;
		do
		{
			$btn = this["btn_" + $pos + $index];
			$index++;
		}
		while($btn);
		
		this._buttonsQtyPre = --$index;
		
		//Main
		$pos = "";
		$index = 0;
		do
		{
			$btn = this["btn_" + $pos + $index];
			if($btn instanceof MovieClip) this._mainButtons.push($btn);
			$index++;
		}
		while($btn);
		
		this._buttonsQty = --$index;
		
		//Post
		$pos = "post";
		$index = 0;
		do
		{
			$btn = this["btn_" + $pos + $index];
			$index++;
		}
		while($btn);
		
		this._buttonsQtyPost = --$index;
	}
	private function applyEventsHandlersToButtons():Void
	{
		var $allButtons:Array = this.getAllButtons();
		var $numButtons:Number = $allButtons.length;
		var $curBtn:MovieClip;
		
		for (var $i:Number = 0; $i < $numButtons; ++$i)
		{
			$curBtn = $allButtons[$i];
			
			$curBtn.onPress = function():Void
			{
				if (!this._visible || !this.data) return;
				
				if (this.activeSubClip)
				{
					this.activeSubClip.gotoAndPlay("focus_out");
				}
				
				var $subClip:MovieClip = this._parent.getTargetedSubClip(this);
				
				if ($subClip)
				{
					$subClip.gotoAndPlay("pressed");
					this._parent.onButtonPress(this, this.data, $subClip);
				}
				else this._parent.onButtonPress(this, this.data);
				
				this.activeSubClip = $subClip;
			};
			$curBtn.onRelease = function():Void
			{
				if (!this._visible || !this.data) return;
				
				var $subClip:MovieClip = this._parent.getTargetedSubClip(this);
				
				if ($subClip)
				{
					$subClip.gotoAndPlay("released");
					this._parent.onButtonRelease(this, this.data, $subClip);
				}
				else this._parent.onButtonRelease(this, this.data);
			};
			$curBtn.onReleaseOutside = function():Void
			{
				if (!this._visible || !this.data) return;
				
				if (this.activeSubClip)
				{
					this.activeSubClip.gotoAndPlay("focus_out");
				}
				this._parent.onButtonReleaseOutside(this, this.data);
			};
			$curBtn.on_focus_in = function():Void
			{
				if (!this._visible || !this.data) return;
				
				this._parent.onButtonFocusIn(this, this.data);
			};
			$curBtn.on_focus_out = function():Void
			{
				if (!this._visible || !this.data) return;
				
				if (this.activeSubClip)
				{
					this.activeSubClip.gotoAndPlay("focus_out");
				}
				this._parent.onButtonFocusOut(this, this.data, this.activeSubClip);
			};
		}
	}
	
	private function getValidIndex($index:Number):Number
	{
		var $length:Number = (this.dataLength != null)?this.dataLength:this._data.length;
		
		if(this.loop) $index = $index%$length;
		if($index<0) $index = this.loop?($length+$index):null;
		if($index>=$length) $index = this.loop?($index - $length):null;
		
		if(!this._data[$index] && this.dataLength == null)$index = null;
		
		return $index;
	}
	
	private function setButton($pos:String, $i:Number, $curDataIndex:Number):MovieClip
	{
		var $curBtn:MovieClip;
		var $curData:Object;
		
		$curBtn = this["btn_" + $pos + $i];
		
		if($curDataIndex == null)
		{
			$curBtn._visible = false;
			return $curBtn;
		}
		
		$curBtn._visible = true;
		$curData = this.getData()[$curDataIndex];
		
		$curBtn.dataIndex = $curDataIndex;
		if(this._labelMemberName && $curBtn.text.text) $curBtn.text.text = $curData[this._labelMemberName];
		
		$curBtn.data = (this.dataLength != null)?$curDataIndex:$curData;
		
		this.onButtonSet($curBtn, $curBtn.data);
		
		return $curBtn;
	}
	public function getTargetedSubClip($btn:MovieClip):MovieClip
	{
		if ($btn.interactiveClips)
		{
			var $curClip:MovieClip;
			
			for (var $i:Number = 0; $i < $btn.interactiveClips.length; ++$i)
			{
				$curClip = $btn.interactiveClips[$i];
				
				if (MovieClipsUtils.mouseContactWithMovieClip($curClip, false, true))
				{
					if ($curClip.disabled) return null;
					else return $curClip;
				}
			}
		}
		return null;
	}
	private function constructDragHandler():Void
	{
		var $sensibility:Number = this.dragSensibility;
		this.gotoAndStop("scrollprevious");
		var $prev_frame:Number = this._currentframe;
		this.gotoAndStop("scrollprevious_lastframe");
		var $prev_lastframe:Number = this._currentframe;
		this.gotoAndStop("idle");
		var $base_frame:Number = this._currentframe;
		this.gotoAndStop("scrollnext");
		var $next_frame:Number = this._currentframe;
		this.gotoAndStop("scrollnext_lastframe");
		var $next_lastframe:Number = this._currentframe;
		
		this.dragToValue = new DragToValue(this.dragHandler, $sensibility, $next_lastframe, $next_frame, $base_frame, $prev_frame, $prev_lastframe);
		this.dragToValue.xBased = this.xBased;
		this.dragToValue.throwFriction = this.throwFriction;
		this.dragToValue.releaseArea = this.releaseArea;
		this.dragToValue.tellEventsOnUnderlyingMcs = true;
		this.dragToValue.setUnderlyingMcs(this._mainButtons);
		this.dragToValue["ButtonsList"] = this;
		
		this.dragToValue.onChange = function($value:Number):Void
		{
			if(!this["ButtonsList"].loop)
			{
				 if
					(
					this["ButtonsList"].getCurrentIndex() <= 0
					&& $value >= this.aboveMinValue
					&& $value <= this.aboveMaxValue
					)
				 {
				 	return;
				 }
				 else if
					(
					this["ButtonsList"].getCurrentIndex() >= this["ButtonsList"].lastIndex
					&& $value >= this.belowMaxValue
					&& $value <= this.belowMinValue
					)
					return;
			}
			this["ButtonsList"].gotoAndStop($value);
		};
		this.dragToValue.onNewWhole = function($value:Number):Void
		{
			$value *= this["ButtonsList"].indexIncrements*-1; 	//Reverting it since scrolling up (-1) means we want to go up the list (+1)
			this["ButtonsList"].displayList(this["ButtonsList"].getCurrentIndex() + $value);
		};
		this.dragToValue.onThrowEnd = function():Void
		{
			this.continueToNearestLimit();
		};
		this.dragToValue.onStopDrag = function():Void
		{
			if (this.throwFriction != 0) this.throwEffect();
			else this.continueToNearestLimit();
		};
	}
	
	private function onNextAnimEnd():Void
	{
		this.displayList(this._currentIndex+this.indexIncrements);
		this._isAnimating = false;
		this._animatingDirection = 0;
		if(this.onNextEnd) this.onNextEnd();
	}
	
	private function onPreviousAnimEnd():Void
	{
		this.displayList(this._currentIndex-this.indexIncrements);
		this._isAnimating = false;
		this._animatingDirection = 0;
		if(this.onPreviousEnd) this.onPreviousEnd();
	}
	
	private function onDestroyAnimEnd():Void
	{
		
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function displayList($firstIndex:Number):Void
	{
		$firstIndex = ($firstIndex!=undefined)?
						$firstIndex
						:
						((this._currentIndex!=undefined)?this._currentIndex:0);
		
		
		if (!this.loop && $firstIndex < 0) $firstIndex = 0;
		else if (!this.loop && ($firstIndex > this.lastIndex)) $firstIndex = this.lastIndex;
		
		this._currentIndex = this.getValidIndex($firstIndex);
		if(this._currentIndex == null) this._currentIndex = 0;
		
		var $curBtn:MovieClip;
		var $curData:Object;
		var $curDataIndex:Number;
		
		this.gotoAndStop("idle");
		
		//Pre
		for(var $i:Number = 0; $i<this._buttonsQtyPre; $i++)
		{
			$curDataIndex = this.getValidIndex($firstIndex-$i-1);
			this.setButton("pre", $i, $curDataIndex);
		}
		
		//Main
		for(var $i:Number = 0; $i<this._buttonsQty; $i++)
		{
			$curDataIndex = this.getValidIndex($firstIndex+$i);
			this.setButton("", $i, $curDataIndex);
		}
		
		//Post
		for(var $i:Number = 0; $i<this._buttonsQtyPost; $i++)
		{
			$curDataIndex = this.getValidIndex($firstIndex + this._buttonsQty +$i);
			this.setButton("post", $i, $curDataIndex);
		}
		this.onNewIndex();
	}
	public function gotoNext():Void
	{
		if(this._isAnimating)
		{
			if(!this.loop && (this._targetIndex + this.indexIncrements)>this.lastIndex) return;
			this._targetIndex += this.indexIncrements;
			if(this._animatingDirection == -1) this.onPreviousAnimEnd();
			else this.onNextAnimEnd();
		}
		else
		{
			if(!this.loop && (this._currentIndex + this.indexIncrements)>this.lastIndex) return;
			this._targetIndex = this._currentIndex + this.indexIncrements;
		}
		this._isAnimating = true;
		this._animatingDirection = 1;
		this.gotoAndPlay("next");
	}
	
	public function gotoPrevious($breakLimits:Boolean):Void
	{
		if(this._isAnimating)
		{
			if(!this.loop && this._targetIndex - this.indexIncrements <0) return;
			this._targetIndex-=this.indexIncrements;
			if(this._animatingDirection == 1) this.onNextAnimEnd();
			else this.onPreviousAnimEnd();
		}
		else
		{
			if(!this.loop && (this._currentIndex - this.indexIncrements)<0) return;
			this._targetIndex = this._currentIndex - this.indexIncrements;
		}
		this._isAnimating = true;
		this._animatingDirection = -1;
		this.gotoAndPlay("previous");
	}
	
	public function destroyButton($btn):Void
	{
		this.gotoAndPlay("destroy_" + $btn._name);
		$btn.gotoAndPlay("destroy");
		this.onDestroyAnimEnd = function():Void
		{
			this.gotoAndStop("idle");
			this.onButtonDestroyed($btn, $btn.data);
		};
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setData($data:Array, $labelMemberName:String, $iconMemberName:String):Void
	{
		this._data = $data;
		if($labelMemberName) this._labelMemberName = $labelMemberName;
		if ($iconMemberName) this._iconMemberName = $iconMemberName;
		
		var $reminderAtLast:Number = $data.length % this.indexIncrements;
		
		if (this.snapBottom)
		{
			this.lastIndex = this._data.length - this.getNumberOfMainButtons() - $reminderAtLast;
			if ($reminderAtLast > 0) this.lastIndex += this.indexIncrements;
			this.lastIndex = (this.lastIndex > 0)? this.lastIndex:0;
			trace("Last Index = " + this.lastIndex + " (length = " + this._data.length + ", nButtons = " + this.getNumberOfMainButtons() + ", reminder = " + $reminderAtLast + ")");
		}
		else
		{
			this.lastIndex = ($reminderAtLast > 0)? $data.length - $reminderAtLast : $data.length - this.indexIncrements;
		}
	}
	public function setDataLength($length:Number):Void
	{
		//Alternative version of setData, only set length and get data in the onButtonSet handler based on index passed as 2nd param (Note: will override any setData)
		this.dataLength = $length;
		this.lastIndex = ($reminderAtLast > 0)? $length - $reminderAtLast : $length - this.indexIncrements;
	}
	public function getData():Array
	{
		return this._data;
	}
	public function getCurrentIndex():Number
	{
		return this._currentIndex;
	}
	public function getNumberOfMainButtons():Number
	{
		return this._buttonsQty;
	}
	public function getAllButtons():Array
	{
		var $buttons:Array = new Array();
		var $curBtn:MovieClip;
		
		//Pre
		for(var $i:Number = 0; $i<this._buttonsQtyPre; $i++)
		{
			$curBtn = this["btn_pre" + $i];
			$buttons.push($curBtn);
		}
		
		
		//Main
		for(var $i:Number = 0; $i<this._buttonsQty; $i++)
		{
			$curBtn = this["btn_" + $i];
			$buttons.push($curBtn);
		}
		
		//Post
		for(var $i:Number = 0; $i<this._buttonsQtyPost; $i++)
		{
			$curBtn = this["btn_post" + $i];
			$buttons.push($curBtn);
		}
		
		return $buttons;
	}
	private function sortElementsByDepth($a:MovieClip, $b:MovieClip):Number
	{
		var $aDepth:Number = $a.getDepth();
		var $bDepth:Number = $b.getDepth();
		
		if ($aDepth > $bDepth)
		{
			//Higher depth will be checked first
			return -1;
		}
		else
		{
			return 1;
		}
	}
	public function setInteractiveClips($btn:MovieClip, $clips:Array, $doDepthSorting:Boolean):Void
	{
		if($doDepthSorting) $clips = $clips.sort(sortElementsByDepth);
		$btn.interactiveClips = $clips;
	}
	public function setXBased($xBased:Boolean):Void
	{
		this.xBased = $xBased;
		this.dragToValue.xBased = this.xBased;
	}
	public function setDragSensibility($sensibility:Number):Void
	{
		this.dragSensibility = $sensibility;
		this.dragToValue.sensibility = this.dragSensibility;
	}
	public function setReleaseArea($area:Number):Void
	{
		this.releaseArea = $area;
		this.dragToValue.releaseArea = this.releaseArea;
	}
	public function setThrowFriction($friction:Number):Void
	{
		this.throwFriction = $friction;
		this.dragToValue.throwFriction = this.throwFriction;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onButtonSet($btn:MovieClip, $data:Object):Void{}
	public function onButtonFocusIn($btn:MovieClip, $data:Object, $subClip:MovieClip):Void{}
	public function onButtonFocusOut($btn:MovieClip, $data:Object, $subClip:MovieClip):Void{}
	public function onButtonPress($btn:MovieClip, $data:Object, $subClip:MovieClip):Void{}
	public function onButtonRelease($btn:MovieClip, $data:Object, $subClip:MovieClip):Void { }
	public function onButtonReleaseOutside($btn:MovieClip, $data:Object):Void{}
	public function onButtonDestroyed($btn:MovieClip, $data:Object):Void{}
	public function onNewIndex():Void{}
	public function onNextEnd():Void{}
	public function onPreviousEnd():Void{}
}