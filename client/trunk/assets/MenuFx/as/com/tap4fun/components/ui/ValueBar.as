/*								ValueBar
**
** my_valuebar = ValueBar.construct($target:MovieClip, $minValue:Number, $maxValue:Number, $heightBased:Boolean);
** Le MovieClip doit comporter:
**	-Un MovieClip nommé "indicator"
**	-Un MovieClip nommé "bg" (servant de base pour établir les limites)
**
** Exemple:
** 
** 	import com.tap4fun.components.ui.ValueBar;
** 	
** 	var myValueBar:MovieClip = ValueBar.construct(this, 0, 100, true);
** 	myValueBar.onSetValue = function():Void
** 	{
** 		trace(this.getValue());
** 	};
**
** 	myValueBar.setValue(78);
**
*********Properties****************************Description******

*********Methods****************************Description*******
**getValue():Number								//
**setValue($value:Number):Void					//
**setMinValue($value:Number):Void			//
**setMaxValue($value:Number):Void			//
**
*********Events*****************************Description*******
**onSetValue									//
**onChange										//
**onLowestValue									//
**onHighestValue								//
**
*********TODO*************************************************
*/
/*[IconFile("icons/ValueBar.png")]*/
class com.tap4fun.components.ui.ValueBar extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "ValueBar";
	static var symbolOwner:Object = ValueBar;
	var className:String = "ValueBar";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=0)]
	public var value:Number;
	[Inspectable(defaultValue=0)]
	public var minValue:Number;
	[Inspectable(defaultValue=1)]
	public var maxValue:Number;
	[Inspectable(defaultValue=false)]
	public var heightBased:Boolean;
	
	private var indicator:MovieClip;
	private var _origBarW:Number = 0;
	private var _origBarH:Number = 0;
	private var _origBarY:Number = 0;
	private var _oldValue:Number = 0;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ValueBar()
	{
		this._origBarW = this.indicator._width;
		this._origBarH = this.indicator._height;
		this._origBarY = this.indicator._y;
		
		this.setMinValue(this.minValue);
		this.setMaxValue(this.maxValue);
		this.setHeightBased(this.heightBased);
		this.setValue(this.value);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function placeIndicatorToValue($value:Number):Void
	{
		this.value = $value;
		var $range:Number = this.maxValue - this.minValue;
		if(!this.heightBased)
			this.indicator._xscale = (($value-this.minValue)/$range) * 100;
		else
		{
			this.indicator._yscale = (($value-this.minValue)/$range) * 100;
			var $newY:Number = Number(this._origBarY) + Number(this._origBarH) - (this.indicator._height);
			this.indicator._y = $newY;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function getValue():Number 
	{
		return this.value;
	}
	function setValue($value:Number):Void
	{
		if($value >= this.maxValue)
		{
			$value = this.maxValue;
			this.placeIndicatorToValue($value);
			this.onHighestValue();
		}
		else if($value <= this.minValue)
		{
			$value = this.minValue;
			this.placeIndicatorToValue($value);
			this.onLowestValue();
		}
		else
		{
			this.placeIndicatorToValue($value);
		}
		if($value != this._oldValue)
		{
			if(this.onChange)this.onChange($value);
		}
		this._oldValue = this.getValue();
		if(this.onSetValue)this.onSetValue($value);
	}
	function getMinValue():Number
	{
		return this.minValue;
	}
	function setMinValue($value:Number):Void
	{
		this.minValue = $value;
	}
	function getMaxValue():Number
	{
		return this.maxValue;
	}
	function setMaxValue($value:Number):Void
	{
		this.maxValue = $value;
	}
	function getHeightBased():Boolean
	{
		return this.heightBased;
	}
	function setHeightBased($hBased:Boolean):Void
	{
		this.heightBased = $hBased;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onSetValue():Void{}
	function onLowestValue():Void{}
	function onHighestValue():Void{}
}