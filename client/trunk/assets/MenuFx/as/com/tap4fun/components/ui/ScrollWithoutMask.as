/*								ScrollWithoutMask
**
** 
*********Properties****************************Description******

*********Methods****************************Description*******
**

*********Events*****************************Description*******
**

*********TODO*************************************************
*/
[IconFile("icons/DragScrollControls.png")]
class com.tap4fun.components.ui.ScrollWithoutMask extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "ScrollWithoutMask";
	static var symbolOwner:Object = ScrollWithoutMask;
	var className:String = "ScrollWithoutMask";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var scrollDir:Number;
	[Inspectable(defaultValue=0.25)]
	var scrollAcceleration:Number;
	[Inspectable(defaultValue=10)]
	var scrollSpeedMax:Number;
	[Inspectable(defaultValue=0.5)]
	var scrollSpeedInit:Number;
	private var scrollSpeed:Number;
	private var decal:Number;
	
	//MovieClips
	[Inspectable(defaultValue="scrollTarget")]
	var scrollTarget:String;
	private var _scrollTarget:MovieClip;
	[Inspectable(defaultValue="boundsRef")]
	var boundsRef:String;
	private var _boundsRef:MovieClip;
	private var name:TextField;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ScrollWithoutMask()
	{
		//Setting vars
		this.scrollDir = 1;
		this.scrollSpeed = scrollSpeedInit;
		this.decal = 0;
		
		//Setting Target Mcs
		this._scrollTarget = this._parent[this.scrollTarget];
		this._boundsRef = this._parent[this.boundsRef];
		
		//Make the component
		this.name._visible = false;
		this.name.text = "";
		
		//Init Methods calls
		this.adjustClipsVisibility();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function adjustClipsVisibility():Void
	{
		for(var mc in this._scrollTarget)
		{
			if(!(this._scrollTarget[mc] instanceof MovieClip)) continue;
			this._scrollTarget[mc]._visible = this._scrollTarget[mc]._y >= (0-this._scrollTarget[mc]._height/2) && this._scrollTarget[mc]._y <= ((this._boundsRef._height))-this._scrollTarget[mc]._height/2;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function startScroll($dir:Number):Void
	{
		if(this.disabled)return;
		this.scrollDir = $dir;
		this.onEnterFrame = this.scroll;
	}
	public function stopScroll():Void
	{
		this.scrollSpeed = this.scrollSpeedInit;
		delete this.onEnterFrame;
	}
	
	public function scroll($dir:Number):Void
	{
		if(this.disabled)return;
		if($dir!=undefined)this.scrollDir = $dir;
		
		var $nextDecal:Number = this.decal + (this.scrollSpeed*this.scrollDir);
		var $limitLow:Number = ((this._scrollTarget._height - this._boundsRef._height))*-1;
		var $limitHigh:Number = 0;
		
		if($nextDecal == $limitHigh || $nextDecal == $limitLow) return;
		
		if($nextDecal < $limitHigh && $nextDecal > $limitLow)
		{
			for(var mc in this._scrollTarget)
			{
				if(!(this._scrollTarget[mc] instanceof MovieClip)) continue;
				this._scrollTarget[mc]._y += this.scrollSpeed*this.scrollDir;
			}
			this.decal += this.scrollSpeed*this.scrollDir;
			this.scrollSpeed+=this.scrollAcceleration;
			if(this.scrollSpeed > this.scrollSpeedMax) this.scrollSpeed = this.scrollSpeed;
		}
		else if($nextDecal >= $limitHigh)
		{
			var $adjust:Number = ($nextDecal)*-1;
			for(var mc in this._scrollTarget)
			{
				if(!(this._scrollTarget[mc] instanceof MovieClip)) continue;
				this._scrollTarget[mc]._y += $adjust + this.scrollAcceleration;
			}
			this.decal += $adjust + this.scrollAcceleration;
			this.scrollSpeed=this.scrollSpeedInit;
			
			var $nextDecal:Number = this.decal + (this.scrollSpeed*this.scrollDir);
		}
		else if($nextDecal <= $limitLow)
		{
			var $adjust = (($limitLow)-$nextDecal);
			
			for(var mc in this._scrollTarget)
			{
				if(!(this._scrollTarget[mc] instanceof MovieClip)) continue;
				this._scrollTarget[mc]._y += $adjust - this.scrollAcceleration;
			}
			
			this.decal += $adjust - this.scrollAcceleration;
			this.scrollSpeed=this.scrollSpeedInit;
			
			var $nextDecal:Number = this.decal + (this.scrollSpeed*this.scrollDir);
		}
		this.adjustClipsVisibility();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}