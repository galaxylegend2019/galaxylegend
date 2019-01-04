/*								VSlider
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

*********Events*****************************Description*******
**onQuitDrag			//
**onSliding				//
**onChange				//

*********TODO*************************************************
*/
/*[IconFile("icons/ValueBar.png")]*/

class com.tap4fun.components.ui.VSlider extends com.tap4fun.components.ui.Slider
{
	static var symbolName:String = "VSlider";
	static var symbolOwner:Object = VSlider;
	var className:String = "VSlider";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function VSlider()
	{
		this._highPos = this.slot._y + this.slot._height;
		this._lowPos = this.slot._y;
		
		this.placeHandleToValue(this.value);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function placeHandleToValue($value:Number):Void
	{
		var $range = this.maxValue - this.minValue;
		var $pos = (($value - this.minValue)*(this.slot._height/$range)*-1)+(this.slot._y+this.slot._height);
		this.handle._y = $pos;
	}
	public function enterDrag():Void
	{
		this._xoffset = this.handle._xmouse;
		this._yoffset = this.handle._ymouse;
		
		this.onEnterFrame = function():Void 
		{
			var $nextY:Number = this._ymouse-this._yoffset;
			
			if ($nextY<=this._highPos&& $nextY>=this._lowPos)
			{
				this.handle._y = $nextY;
			}
			else
			{
				if ($nextY>this._highPos)
				{
					this.handle._y = this._highPos;
				}
				else
				{
					this.handle._y = this._lowPos;
				}
			}
			if(this.onChange)this.onChange(this.getValue());
			this.onSliding();
		};
		if(this.onEnterDrag) this.onEnterDrag();
	}
	private function listenToControllerInput():Void
	{
		//ControllerInput
		this.handle.onNavigatorDown = function():Void
		{
			var $new_value = this._parent.getValue();
			$new_value--;
			this._parent.setValue($new_value);
		};
		this.handle.onNavigatorUp = function():Void
		{
			var $new_value = this._parent.getValue();
			$new_value++;
			this._parent.setValue($new_value);
		};
	}
	private function sendHandleToMouse():Void
	{
		this.handle._y = this._ymouse;
		
		if (this.handle._y > this._highPos)
		{
			this.handle._y = this._highPos;
		}
		else if(this.handle._y < this._lowPos)
		{
			this.handle._y = this._lowPos;
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
		$value = ((this.handle._y - (this.slot._y+this.slot._height))/((this.slot._height/this._range)*-1)) +  this.minValue;
		
		return $value;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}