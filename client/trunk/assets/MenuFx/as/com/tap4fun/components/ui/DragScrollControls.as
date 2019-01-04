/*								ComponentName
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
*********Note*************************************************
*/
[IconFile("icons/DragScrollControls.png")]
class com.tap4fun.components.ui.DragScrollControls extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "DragScrollControls";
	static var symbolOwner:Object = DragScrollControls;
	var className:String = "DragScrollControls";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue="")]
	public var target:String;
	[Inspectable(defaultValue=false)]
	public var xscroll:Boolean;
	[Inspectable(defaultValue=true)]
	public var yscroll:Boolean;
	[Inspectable(defaultValue=1.5)]
	public var easeOutForce:Number;
	[Inspectable(defaultValue=5)]
	public var clickzone:Number;
	public var toplimit:Number;
	public var bottomlimit:Number;
	public var leftlimit:Number;
	public var rightlimit:Number;
	
	public var targetMc:MovieClip;
	
	private var _pressX:Number;
	private var _pressY:Number;
	private var _initX:Number;
	private var _initY:Number;
	private var _previousXMouse:Number;
	private var _previousYMouse:Number;
	private var _needingRelease:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DragScrollControls()
	{
		if(this.target!="")this.setTarget(this._parent[this.target]);
		
		this.onLoad = function():Void
		{
			this.setXscroll(this.xscroll);
			this.setYscroll(this.yscroll);
			this.setEaseOutForce(this.easeOutForce);
			this.setClickzone(this.clickzone);
			
			this.applyOnPressEventHandler();
			this.applyOnReleaseEventHandler();
			
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function checkContactWithPressableMovieClip($mc:MovieClip):Boolean
	{
		if(this.mouseIsOver($mc) && ($mc.onPress || $mc.onRelease))
		{
			if($mc.onPress) $mc.onPress();
			this._needingRelease = $mc;
			return true;
		}
		else if(this.mouseIsOver($mc))
		{
			//Check childrens...
			for(var $child in $mc)
			{
				if(typeof($mc[$child]) == "movieclip")
				{
					if(this.checkContactWithPressableMovieClip($mc[$child]))
					{
						return true;
						break;
					}
				}
			}
		}
		return false;
	}
	private function mouseIsOver($mc:MovieClip):Boolean
	{
		var $bds:Object = $mc.getBounds(_root);
		var $ptsMin:Object = {x:$bds.xMin, y:$bds.yMin};
		var $ptsMax:Object = {x:$bds.xMax, y:$bds.yMax};
		
		if(_root._xmouse >= $ptsMin.x && _root._xmouse <= $ptsMax.x && _root._ymouse >= $ptsMin.y && _root._ymouse <= $ptsMax.y)
		{
			return true;
		}
		return false;
	}
	private function applyOnPressEventHandler():Void
	{
		this.onPress = function():Void
		{
			_global.forceFlashInputBehavior(true);
			
			if(this.onDown) this.onDown();
			this._initX = this.targetMc._x;
			this._initY = this.targetMc._y;
			
			if(this.xscroll)
			{
				this._pressX = this._parent._xmouse;
			}
			if(this.yscroll)
			{
				this._pressY = this._parent._ymouse;
			}
			
			//Check if child pressed
			this.checkContactWithPressableMovieClip(this.targetMc);
			
			this.onEnterFrame = function():Void
			{
				if(this.onEnteringFrame) this.onEnteringFrame();
				if(this.xscroll && this.targetMc._width > this._width)
				{
					this._previousXMouse = this._parent._xmouse;
					this.targetMc._x = this._parent._xmouse - this._pressX + this._initX;
					if(this.targetMc._x > this.leftlimit)
					{
						this.targetMc._x = this.leftlimit;
						this._stopScrollX = true;
					}
					else if(this.targetMc._x < this.rightlimit)
					{
						this.targetMc._x = this.rightlimit;
						this._stopScrollX = true;
					}
				}
				if(this.yscroll && this.targetMc._height > this._height)
				{
					this._previousYMouse = this._parent._ymouse;
					this.targetMc._y = this._parent._ymouse - this._pressY + this._initY;
					if(this.targetMc._y > this.toplimit)
					{
						this.targetMc._y = this.toplimit;
					}
					else if(this.targetMc._y < this.bottomlimit)
					{
						this.targetMc._y = this.bottomlimit;
					}
				}
				if(this.onScroll) this.onScroll();
			};
		};
	}
	private function applyOnReleaseEventHandler():Void
	{
		this.onRelease = this.onReleaseOutside = function():Void
		{
			_global.forceFlashInputBehavior(false);
			
			this._stopScrollX = false;
			this._stopScrollY = false;
			
			if(this._needingRelease.onRollOut) this._needingRelease.onRollOut();
			
			if(this._initX >= this.targetMc._x - this.clickzone
			   && this._initX <= this.targetMc._x + this.clickzone 
			   && this._initY >= this.targetMc._y - this.clickzone 
			   && this._initY <= this.targetMc._y + this.clickzone)
			{
				if(this.onUp)this.onUp();
				
				if(this.checkContactWithPressableMovieClip(this._needingRelease))
				{
					if(this._needingRelease.onRelease) this._needingRelease.onRelease();
				}
				else
				{
					if(this._needingRelease.onReleaseOutside) this._needingRelease.onReleaseOutside();
				}
			};
			
			this._needingRelease = null;
			
			if(this.xscroll && this.targetMc._width > this._width)
			{
				this._speedX = this._previousXMouse - this._parent._xmouse;
			}
			else
			{
				this._stopScrollX = true;
			}
			if(this.yscroll && this.targetMc._height > this._height)
			{
				this._speedY = this._previousYMouse - this._parent._ymouse;
			}
			else
			{
				this._stopScrollY = true;
			}
			this.onEnterFrame = function():Void
			{
				if(this._stopScrollX && this._stopScrollY)
				{
					delete this.onEnterFrame;
					return;
				}
				if(this.xscroll && this.targetMc._width > this._width)
				{
					this.targetMc._x -= this._speedX;
					this._speedX/=this.easeOutForce;
					if(Math.round(this._speedX)==0)
					{
						this._speedX = 0;
						this._stopScrollX = true;
					}
					if(this.targetMc._x > this.leftlimit)
					{
						this.targetMc._x = this.leftlimit;
						this._stopScrollX = true;
					}
					else if(this.targetMc._x < this.rightlimit)
					{
						this.targetMc._x = this.rightlimit;
						this._stopScrollX = true;
					}
					
				}
				if(this.yscroll && this.targetMc._height > this._height)
				{
					this.targetMc._y -= this._speedY;
					this._speedY/=this.easeOutForce;
					if(Math.round(this._speedY)==0)
					{
						if(Math.round(this._speedY)==0) this._speedY = 0;
						this._stopScrollY = true;
					}
					if(this.targetMc._y > this.toplimit)
					{
						this.targetMc._y = this.toplimit;
						this._stopScrollY = true;
					}
					else if(this.targetMc._y < this.bottomlimit)
					{
						this.targetMc._y = this.bottomlimit;
						this._stopScrollY = true;
					}
				}
				if(this.onScroll) this.onScroll();
			};
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setTarget($target:MovieClip):Void
	{
		this.targetMc = $target;
		this.toplimit = 0 + this._y;
		this.bottomlimit = ($target._height * -1) + this._y + this._height;
		this.leftlimit = 0 + this._x;
		this.rightlimit = ($target._width * -1) + this._x + this._width;;
		this.applyOnPressEventHandler();
		this.applyOnReleaseEventHandler();
	}
	public function getTarget():MovieClip
	{
		return this.targetMc;
	}
	public function setXscroll($scroll:Boolean):Void
	{
		this.xscroll = $scroll;
	}
	public function getXscroll():Boolean
	{
		return this.xscroll;
	}
	public function setYscroll($scroll:Boolean):Void
	{
		this.yscroll = $scroll;
	}
	public function getYscroll():Boolean
	{
		return this.yscroll;
	}
	public function setClickzone($zone:Number):Void
	{
		this.clickzone = $zone;
	}
	public function getClickzone():Number
	{
		return this.clickzone;
	}
	public function setEaseOutForce($force:Number):Void
	{
		if($force <= 1) trace("Warning: You'll have strange behavior with an easeOutForce lower or equal to 1 with a FingerScrollable! (applied to \"" + this._name + "\")");
		this.easeOutForce = $force;
	}
	public function getEaseOutForce():Number
	{
		return this.easeOutForce;
	}
	public function setToplimit($limit:Number):Void
	{
		this.toplimit = $limit;
	}
	public function getToplimit():Number
	{
		return toplimit;
	}
	public function setBottomlimit($limit:Number):Void
	{
		this.bottomlimit = $limit;
	}
	public function getBottomlimit():Number
	{
		return bottomlimit;
	}
	public function setLeftlimit($limit:Number):Void
	{
		this.leftlimit = $limit;
	}
	public function getLeftlimit():Number
	{
		return leftlimit;
	}
	public function setRightlimit($limit:Number):Void
	{
		this.rightlimit = $limit;
	}
	public function getRightlimit():Number
	{
		return rightlimit;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onDown():Void{}
	function onUp():Void{}
	function onEnteringFrame():Void{}
	function onDrag():Void{}
}