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
*/
/*[IconFile("icons/ValueBar.png")]*/
class com.tap4fun.components.ui.Zoomer extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "Zoomer";
	static var symbolOwner:Object = Zoomer;
	var className:String = "Zoomer";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=1.5)]
	public var zoomFactor:Number;
	[Inspectable(defaultValue=5)]
	public var zoomingLength:Number;
	
	public var zoomTarget:MovieClip;
	
	public var _tempZoomFactor:Number;
	private var _zoomIncrements:Number;
	private var _zooming:Boolean;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Zoomer()
	{
		this._x = this._y = 0;
		if(this.zoomingLength == undefined) this.zoomingLength = 20;
		this.setZoomingLength(this.zoomingLength);
		this.setZoomFactor(this.zoomFactor);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function setMovieClips():Void
	{
		for(var $mc_name in this.zoomTarget)
		{
			var $cur:Object = this.zoomTarget[$mc_name];
			if($cur instanceof MovieClip && $cur.depth != 0 && $cur.depth != undefined)
			{
				$cur.origX = $cur._x;
				$cur.origY = $cur._y;
				$cur.origXScale = $cur._xscale;
				$cur.origYScale = $cur._yscale;
				$cur._xscale = $cur.origXScale * $cur.depth * this._tempZoomFactor;
				$cur._yscale = $cur.origYScale * $cur.depth * this._tempZoomFactor;
				$cur._x = $cur.origX - ($cur._xmouse * (($cur.depth * this._tempZoomFactor) - 1));
				$cur._y = $cur.origY - ($cur._ymouse * (($cur.depth * this._tempZoomFactor) - 1));
			}
		}
	};
	private function moveMovieClips():Void
	{
		for(var $mc_name in this.zoomTarget)
		{
			var $cur:Object = this.zoomTarget[$mc_name];
			if($cur instanceof MovieClip && $cur.depth != 0 && $cur.depth != undefined)
			{
				$cur._xscale = $cur.origXScale * $cur.depth * this._tempZoomFactor;
				$cur._yscale = $cur.origYScale * $cur.depth * this._tempZoomFactor;
				$cur._x = $cur.origX - ($cur._xmouse * (($cur.depth * this._tempZoomFactor) - 1));
				$cur._y = $cur.origY - ($cur._ymouse * (($cur.depth * this._tempZoomFactor) - 1));
			}
		}
	};
	private function resetMovieClips():Void
	{
		for(var $mc_name in this.zoomTarget)
		{
			var $cur:Object = this.zoomTarget[$mc_name];
			if($cur instanceof MovieClip && $cur.depth != 0 && $cur.depth != undefined)
			{
				$cur._x = $cur.origX;
				$cur._y = $cur.origY;
				$cur._xscale = $cur.origXScale;
				$cur._yscale = $cur.origYScale;
			}
		}
	};
	private function zoom():Void
	{
		this.zoomTarget._x = this.zoomTarget.origX - _xmouse*(this._tempZoomFactor-1);
		this.zoomTarget._y = this.zoomTarget.origY - _ymouse*(this._tempZoomFactor-1);
		this.zoomTarget._xscale = this.zoomTarget._yscale = 100 * this._tempZoomFactor;
		if(this.onChange)this.onChange(100 * this._tempZoomFactor);
	};
	private function unZoom():Void
	{
		this.zoomTarget._xscale = this.zoomTarget._yscale = 100;
		this.zoomTarget._x = this.zoomTarget.origX;
		this.zoomTarget._y = this.zoomTarget.origY;
		if(this.onChange)this.onChange(100);
	};
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function startZoom():Void
	{
		if(this._zooming) return;
		this._zooming = true;
		
		this._tempZoomFactor = 1;
		
		this.zoom();
		this.setMovieClips();
		this.moveMovieClips();
		this.onEnterFrame = function():Void
		{
			this._tempZoomFactor += this._zoomIncrements;
			if(this._tempZoomFactor >= this.zoomFactor) this._tempZoomFactor = this.zoomFactor;
			this.zoom();
			this.moveMovieClips();
		};
	};
	public function stopZoom():Void
	{
		if(!this._zooming) return;
		this._zooming = false;
		this.unZoom();
		this.resetMovieClips();
		delete this.onEnterFrame;
	};
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setTarget($target:MovieClip):Void
	{
		this.zoomTarget = $target;
		this.zoomTarget.origX = this.zoomTarget._x;
		this.zoomTarget.origY = this.zoomTarget._y;
	}
	public function getTarget():MovieClip
	{
		return this.zoomTarget;
	}
	public function setZoomFactor($factor:Number):Void
	{
		this.zoomFactor = $factor;
		this._zoomIncrements = $factor/this.zoomingLength;
		this._tempZoomFactor = 0;
	}
	public function getZoomFactor():Number
	{
		return this.zoomFactor;
	}
	public function setZoomingLength($length:Number):Void
	{
		this.zoomingLength = $length;
	}
	public function getZoomingLength():Number
	{
		return this.zoomingLength;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}
