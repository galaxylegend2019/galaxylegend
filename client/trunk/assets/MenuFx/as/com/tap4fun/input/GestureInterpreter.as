/*								GestureInterpreter
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

import com.tap4fun.input.Controller;
import com.tap4fun.components.Events;
import com.tap4fun.input.DisplacementDeltas;
import flash.geom.Point;

class com.tap4fun.input.GestureInterpreter extends com.tap4fun.components.ComponentBase
{
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										CONSTANTS												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private static var _i:Number = -1;
	
	public static var LEFT:Number = ++_i;
	public static var RIGHT:Number = ++_i;
	public static var UP:Number = ++_i;
	public static var DOWN:Number = ++_i;
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//public var captureRate:Number = 33; //Maybe later if more complex gestures are required
	public var minimumDuration:Number;
	public var minimumLength:Number;
	public var angleRange:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var _intervalID:Number;
	private var _startPoint:Point;
	private var _beginTime:Number;
	private var _endPoint:Point;
	private var _endTime:Number;
	private var _vect:DisplacementDeltas;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function GestureInterpreter()
	{
		_startPoint = new Point();
		_endPoint = new Point();
		this._vect = new DisplacementDeltas();
		
		this.minimumDuration = 500;
		this.minimumLength = 100;
		this.angleRange = 20;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function capturePosition($controller:Controller):Void
	{
		//Maybe later if more complex gestures are required
	}
	private function onCursorDown($controller:Controller, $state):Void
	{
		_startPoint.x = $controller.getCursor().x;
		_startPoint.y = $controller.getCursor().y;
		
		this._vect.forceStartingPoint($controller.getCursor().x, $controller.getCursor().y);
		_beginTime = getTimer();
		//_intervalID = setInterval(this, "capturePosition", captureRate, $controller); //Maybe later if more complex gestures are required
	}
	private function onCursorUp($controller:Controller, $state):Void
	{
		this._vect.forceEndingPoint($controller.getCursor().x, $controller.getCursor().y);
		
		_endPoint.x = $controller.getCursor().x;
		_endPoint.y = $controller.getCursor().y;
		var $length:Number = this._vect.getForcedVectorLength();
		_endTime = getTimer();
		
		//Maybe later if more complex gestures are required
		//clearInterval(_intervalID);
		//_intervalID = null;
		
		if (this.getDuration() < this.minimumDuration && $length > this.minimumLength)
		{
			var $angle:Number = _vect.getForcedAngle(true);
			
			if(Math.abs($angle) < 180 + this.angleRange && Math.abs($angle) > 180 - this.angleRange)
			{
				this.onGesture(LEFT);
			}
			else if($angle < 0 + this.angleRange && $angle > 0 - this.angleRange)
			{
				this.onGesture(RIGHT);
			}
			else if($angle < -90 + this.angleRange && $angle > -90 - this.angleRange)
			{
				this.onGesture(UP);
			}
			else if ($angle < 90 + this.angleRange && $angle > 90 - this.angleRange)
			{
				this.onGesture(DOWN);
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function start():Void
	{
		Controller.addListener(Events.CURSOR_UP, this, onCursorUp);
		Controller.addListener(Events.CURSOR_DOWN, this, onCursorDown);
	}
	public function end():Void
	{
		Controller.removeListener(Events.CURSOR_UP, this, onCursorUp);
		Controller.removeListener(Events.CURSOR_DOWN, this, onCursorDown);
	}
	public function getLength():Number
	{
		return this._vect.getForcedVectorLength();
	}
	public function getAngle($degrees:Boolean):Number
	{
		return this._vect.getForcedAngle($degrees);
	}
	public function getStartingPoint():Point
	{
		return this._startPoint;
	}
	public function getEndingPoint():Point
	{
		return this._endPoint;
	}
	public function getDuration():Number
	{
		return this._endTime - this._beginTime;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Static Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onGesture($gesture:Number):Void{}
}


