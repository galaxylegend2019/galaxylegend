/*								HSlider
**
** Le MovieClip doit comporter:
**	-Un MovieClip nommé "handle" et ayant comme frame labels: "out", "over", "press", "release"
**	-Un MovieClip nommé "bg" (servant de base pour établir les limites)
**
** Exemple:
** 
** 	import com.tap4fun.components.ui.Slider;
** 	
** 	var mySlider:MovieClip = Slider.construct(this, 0, 100, true);
** 	mySlider.onSetValue = function():Void
** 	{
** 		trace(this.getValue());
** 	};
** 	mySlider.onSliding = function():Void
** 	{
** 		trace(this.getValue());
** 	};
** 	mySlider.setValue(78);
*********Properties****************************Description******

*********Methods****************************Description*******
**getValue():Number								//
**setValue($value:Number):Void					//
**setLowestValue($value:Number):Void			//
**setHighestValue($value:Number):Void			//

*********Events*****************************Description*******
**onQuitDrag			//
**onSliding				//
**onSetValue			//
**onChange				//

*********TODO*************************************************
*/
[IconFile("icons/HSlider.png")]

class com.tap4fun.components.ui.HSlider extends com.tap4fun.components.ui.Slider
{
	static var symbolName:String = "HSlider";
	static var symbolOwner:Object = HSlider;
	var className:String = "HSlider";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function HSlider()
	{
		this._lowPos = this.slot._x;
		this._highPos = this.slot._x + this.slot._width;
		
		this.placeHandleToValue(this.value);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function placeHandleToValue($value:Number):Void
	{
		var $range = this.maxValue - this.minValue;
		var $pos = this.slot._x + (($value -  this.minValue)*(this.slot._width/$range));
		this.handle._x = $pos;
	}
	public function enterDrag():Void
	{
		//Used in children classes
		this._xoffset = this.handle._xmouse;
		this._yoffset = this.handle._ymouse;
		
		this.onEnterFrame = function():Void 
		{
			var $nextX:Number = this._xmouse - this._xoffset;
			
			if ($nextX>=this._lowPos && $nextX<=this._highPos)
			{
				this.handle._x = $nextX;
			}
			else
			{
				if ($nextX<this._lowPos)
				{
					this.handle._x = this._lowPos;
				}
				else
				{
					this.handle._x = this._highPos;
				}
			}
			this.onChange(this.getValue());
			this.onSliding();
		};
		if(this.onEnterDrag) this.onEnterDrag();
	}
	private function listenToControllerInput():Void
	{
		//ControllerInput
		this.handle.onNavigatorLeft = function():Void
		{
			var $new_value = this._parent.getValue();
			$new_value--;
			this._parent.setValue($new_value);
		};
		this.handle.onNavigatorRight = function():Void
		{
			var $new_value = this._parent.getValue();
			$new_value++;
			this._parent.setValue($new_value);
		};
	}
	
	private function sendHandleToMouse():Void
	{
		this.handle._x = this._xmouse;
		
		if (this.handle._x < this._lowPos)
		{
			this.handle._x = this._lowPos;
		}
		else if(this.handle._x > this._highPos)
		{
			this.handle._x = this._highPos;
		}
		
		this.onChange(this.getValue());
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getValue():Number
	{
		this._range = this.maxValue - this.minValue;
		var $value:Number = 0;
		$value = (((this.handle._x - this.slot._x) / (this.slot._width/this._range))) + this.minValue;
		
		return $value;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}