/*								DisplacementDeltas
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
import flash.geom.Point;
import com.tap4fun.components.Events;

class com.tap4fun.input.DisplacementDeltas extends Object
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
	private var _startingPoint:Point;
	private var _forcedEndingPoint:Point;
	private var _storedDelta:Point;
	
	//StoredSamples
	private var _storedSamples:Array;
	private var _storedSamplesQty:Number = 5;
	private var _storedSamplesCurIndex:Number = 0;
	
	//For Testing Purpose
	private var _drawVectors:Boolean = false;
	private var _drawIntervalID:Number = null;
	private var _drawIntervalDuration:Number = 33;
	private var _drawContainer:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DisplacementDeltas()
	{
		this._startingPoint = new Point();
		this._forcedEndingPoint = new Point();
		this._storedDelta = new Point();
		this._startingPoint.x = 0;
		this._startingPoint.y = 0;
		this.setStoredSamplesQuantity(this._storedSamplesQty);
		
		if (this._drawVectors) this.startDrawingVectors();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function getCurrentPoint():Point
	{
		var $curPt:Point = new Point();
		$curPt.x = _root._xmouse;
		$curPt.y = _root._ymouse;
		
		if (_root._xmouse < 0) $curPt.x = 0;
		if (_root._ymouse < 0) $curPt.y = 0;
		
		return $curPt;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setStartingPoint():Void
	{
		this._startingPoint.x = _root._xmouse;
		this._startingPoint.y = _root._ymouse;
		
		if (this._startingPoint.x < 0) this._startingPoint.x = 0;
		if (this._startingPoint.y < 0) this._startingPoint.y = 0;
	}
	public function getStartingPoint():Point
	{
		return this._startingPoint;
	}
	public function forceStartingPoint($x:Number, $y:Number):Void
	{
		this._startingPoint.x = $x;
		this._startingPoint.y = $y;
	}
	public function forceEndingPoint($x:Number, $y:Number):Void
	{
		this._forcedEndingPoint.x = $x;
		this._forcedEndingPoint.y = $y;
	}
	public function addToForcedEndingPoint($xInc:Number, $yInc:Number):Void
	{
		this._forcedEndingPoint.x += $xInc;
		this._forcedEndingPoint.y += $yInc;
	}
	public function getDeltaOrientation($coord:String):Number
	{
		if($coord != "x" && $coord != "y")
		{
			trace("Error! Invalid coordinate " + $coord + " passed to DisplacementDeltas.getDeltaOrientation($coord). $coord can only be \"x\" or \"y\"");
		}
		if(Math.round(this.getCurrentPoint()[$coord] - this._startingPoint[$coord]) == 0) return 0;
		return (this.getCurrentPoint()[$coord] - this._startingPoint[$coord] > 0)?1:-1;
	}
	public function getForcedDeltaOrientation($coord:String):Number
	{
		if($coord != "x" && $coord != "y")
		{
			trace("Error! Invalid coordinate " + $coord + " passed to DisplacementDeltas.getDeltaOrientation($coord). $coord can only be \"x\" or \"y\"");
		}
		if(Math.round(this._forcedEndingPoint[$coord] - this._startingPoint[$coord]) == 0) return 0;
		return (this._forcedEndingPoint[$coord] - this._startingPoint[$coord] > 0)?1:-1;
	}
	public function getDeltas():Point
	{
		var $deltas:Point = new Point();
		var $currentPoint:Point = this.getCurrentPoint();
		
		$deltas.x = $currentPoint.x - this._startingPoint.x;
		$deltas.y = $currentPoint.y - this._startingPoint.y;
		
		return $deltas;
	}
	public function getForcedDeltas():Point
	{
		var $deltas:Point = new Point();
		$deltas.x = this._forcedEndingPoint.x - this._startingPoint.x;
		$deltas.y = this._forcedEndingPoint.y - this._startingPoint.y;
		return $deltas;
	}
	public function storeCurrentDelta($forced:Boolean):Void
	{
		//HACK FOR C++ TOUCH CANCEL OUTTA SCREEN
		if ((!$forced && (_root._xmouse < 0 || _root._ymouse < 0)))
		{
			var $index:Number = this._storedSamplesCurIndex - 1;
			if ($index < 0) this._storedSamplesCurIndex = this._storedSamplesQty - 1;
			
			var $deltas:Point = new Point();
			if (!_storedSamples[$index])
			{
				$deltas.x = 0;
				$deltas.y = 0;
			}
			else
			{
				$deltas.x = _storedSamples[$index].x - this._startingPoint.x;
				$deltas.y = _storedSamples[$index].y - this._startingPoint.y;
			}
			
			this._storedDelta = $deltas;
		}
		else this._storedDelta = $forced? this.getForcedDeltas():this.getDeltas();
	}
	public function getStoredDelta():Point
	{
		if (Math.abs(_storedDelta.x) > Stage.width) _storedDelta.x = 0;
		if (Math.abs(_storedDelta.y) > Stage.height) _storedDelta.y = 0;
		return this._storedDelta;
	}
	public function getAngle($degrees:Boolean):Number
	{
		var $angle:Number;
		//Angle in radians
		$angle = Math.atan2(this.getDeltas().y, this.getDeltas().x);
		//Angle in degrees
		if($degrees) $angle *= (180/Math.PI);
		return $angle;
	}
	public function getForcedAngle($degrees:Boolean):Number
	{
		var $angle:Number;
		//Angle in radians
		$angle = Math.atan2(this.getForcedDeltas().y, this.getForcedDeltas().x);
		//Angle in degrees
		if($degrees) $angle *= (180/Math.PI);
		return $angle;
	}
	public function getVectorLength():Number
	{
		var $vectorLength:Number;
		$vectorLength = Math.sqrt((this.getDeltas().x * this.getDeltas().x) + (this.getDeltas().y * this.getDeltas().y));
		return $vectorLength;
	}
	public function getForcedVectorLength():Number
	{
		var $vectorLength:Number;
		$vectorLength = Math.sqrt((this.getForcedDeltas().x * this.getForcedDeltas().x) + (this.getForcedDeltas().y * this.getForcedDeltas().y));
		return $vectorLength;
	}
	
	//Stored Samples
	public function setStoredSamplesQuantity($qty:Number):Void
	{
		this._storedSamplesQty = $qty;
		this._storedSamples = new Array();
		this.clearStoredSamples();
	}
	public function addCurrentDeltaToStoredSamples():Void
	{
		this._storedSamples[this._storedSamplesCurIndex] = this.getDeltas();
		this._storedSamplesCurIndex++;
		if (this._storedSamplesCurIndex >= this._storedSamplesQty) this._storedSamplesCurIndex = 0;
	}
	public function clearStoredSamples():Void
	{
		for (var $i:Number = 0; $i < this._storedSamplesQty; ++$i)
		{
			this._storedSamples[$i] = null;
		}
		this._storedSamplesCurIndex = 0;
	}
	public function getNormalizedDeltasFromStoredSamples():Point
	{
		var $x:Number = 0;
		var $y:Number = 0;
		var $qty:Number = 0;
		var $curPt:Point;
		
		for (var $i:Number = 0; $i < this._storedSamplesQty; ++$i)
		{
			$curPt = this._storedSamples[$i];
			if ($curPt.x != null && $curPt.y != null)
			{
				$qty++;
				$x += $curPt.x;
				$y += $curPt.y;
			}
		}
		
		//Normalization
		$x /= $qty;
		$y /= $qty;
		
		return new Point($x, $y);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//For testing purpose
	public function drawVectors():Void
	{
		this._drawContainer.clear();
		
		//Real Vector
		var $startPoint:Point = this.getStartingPoint();
		var $endPoint:Point = this.getCurrentPoint();
		
		this._drawContainer.lineStyle(1, 0x55FF55, 75);
		this._drawContainer.moveTo($startPoint.x - 10, $startPoint.y);
		this._drawContainer.lineTo($startPoint.x + 10, $startPoint.y);
		
		this._drawContainer.lineStyle(1, 0x00FF00, 75);
		this._drawContainer.moveTo($startPoint.x, $startPoint.y);
		this._drawContainer.lineTo($endPoint.x, $endPoint.y);
		
		//Forced Vector
		$startPoint = this.getStartingPoint();
		$endPoint = this._forcedEndingPoint;
		
		this._drawContainer.lineStyle(1, 0xFF5555, 50);
		this._drawContainer.moveTo($startPoint.x - 10, $startPoint.y);
		this._drawContainer.lineTo($startPoint.x + 10, $startPoint.y);
		
		this._drawContainer.lineStyle(1, 0x0FF0000, 50);
		this._drawContainer.moveTo($startPoint.x, $startPoint.y);
		this._drawContainer.lineTo($endPoint.x, $endPoint.y);
	}
	public function startDrawingVectors():Void
	{
		if (this._drawIntervalID != null) this.stopDrawingVectors();
		
		this._drawContainer = _root.createEmptyMovieClip("drawVect" + (random(5000)), _root.getNextHighestDepth());
		this._drawContainer._x = 0;
		this._drawContainer._y = 0;
		this._drawContainer._xscale = this._drawContainer._yscale = 50;
		
		this._drawIntervalID = setInterval(this, "drawVectors", this._drawIntervalDuration);
	}
	public function stopDrawingVectors():Void
	{
		clearInterval(this._drawIntervalID);
		this._drawIntervalID = null;
		this._drawContainer.removeMovieClip();
	}
}