/*								NumericStepper
**
** NumericStepper
** Le MovieClip doit comporter:
**	-Un TextField nommé "number"
**	-Un MovieClip nommé "btn_up" et un nommé "btn_down"
**
** Exemple:
** 
**
*********Properties****************************Description******

*********Methods****************************Description*******
**getValue():Number								//
**setValue($value:Number):Void					//
**setLowestValue($value:Number):Void			//
**setHighestValue($value:Number):Void			//
**setIncrements($value:Number):Void				//
**
*********Events*****************************Description*******
**onSetValue									//
**onChange										//
**onLowestValue									//
**onHighestValue								//
**
*********TODO*************************************************
*/
[IconFile("icons/NumericStepper.png")]
class com.tap4fun.components.ui.NumericStepper extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "NumericStepper";
	static var symbolOwner:Object = NumericStepper;
	var className:String = "NumericStepper";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=0)]
	public var value:Number;
	[Inspectable(defaultValue=0)]
	public var minValue:Number;
	[Inspectable(defaultValue=10)]
	public var maxValue:Number;
	[Inspectable(defaultValue=1)]
	public var increments:Number;
	
	private var btn_prev:com.tap4fun.components.ui.Button;
	private var btn_next:com.tap4fun.components.ui.Button;
	private var number:TextField;
	private var _oldValue:Number = 0;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function NumericStepper()
	{
		this.stop();
		this.onLoad = function():Void
		{
			this.setElementsEventsHandlers();
			if(this.minValue == undefined) this.minValue = 0;
			if(this.maxValue == undefined) this.maxValue = 1;
			if(this.value == undefined) this.value = this.minValue;
			if(this.increments == undefined) this.increments = 1;
			
			this.setValue(this.value);
			this.setMinValue(this.minValue);
			this.setMaxValue(this.maxValue);
			this.setIncrements(this.increments);
			
			if(this.value >= this.maxValue)
			{
				if(this.btn_next.setDisabled) this.btn_next.setDisabled(true);
				else this.btn_next.disabled = true;
				this.value = this.maxValue;
				if(this.onHighestValue) this.onHighestValue();
			}
			else if(this.value <= this.minValue)
			{
				if(this.btn_prev.setDisabled) this.btn_prev.setDisabled(true);
				else this.btn_prev.disabled = true;
				this.value = this.minValue;
				if(this.onLowestValue) this.onLowestValue();
			}
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function setElementsEventsHandlers():Void
	{
		this.btn_prev.onRelease = function():Void
		{
			if(!this.getDisabled())
			{
				this._parent.goToPrevious();
			}
			this.onReleaseAction();
		};
		this.btn_next.onRelease = function():Void
		{
			if(!this.getDisabled())
			{
				this._parent.goToNext();
			}
			this.onReleaseAction();
		};
		
		//ControllerInput
		this.btn_prev.onNavigatorDown = function():Void
		{
			this.onRelease();
		};
		this.btn_next.onNavigatorUp = function():Void
		{
			this.onRelease();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function goToNext():Void
	{
		this.setValue(this.value+this.increments);
	}
	public function goToPrevious():Void
	{
		this.setValue(this.value-this.increments);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setValue($value:Number):Void
	{
		if(this.btn_prev.setDisabled) this.btn_prev.setDisabled(false);
		else this.btn_prev.disabled = false;
		if(this.btn_next.setDisabled) this.btn_next.setDisabled(false);
		else this.btn_next.disabled = false;
		
		if($value >= this.maxValue)
		{
			if(this.btn_next.setDisabled) this.btn_next.setDisabled(true);
			else this.btn_next.disabled = true;
			$value = this.maxValue;
			if(this.onHighestValue) this.onHighestValue();
		}
		else if($value <= this.minValue)
		{
			if(this.btn_prev.setDisabled) this.btn_prev.setDisabled(true);
			else this.btn_prev.disabled = true;
			$value = this.minValue;
			if(this.onLowestValue) this.onLowestValue();
		}
		this.value = $value;
		this.number.text = String(this.value);
		if(this._oldValue != $value && this.onChange) this.onChange(this.value);
		this._oldValue = this.value;
	}
	public function getValue():Number
	{
		return this.value;
	}
	public function setMinValue($value:Number):Void
	{
		this.minValue = $value;
	}
	public function getMinValue():Number
	{
		return this.minValue;
	}
	public function setMaxValue($value:Number):Void
	{
		this.maxValue = $value;
	}
	public function getMaxValue():Number
	{
		return this.maxValue;
	}
	public function setIncrements($inc:Number):Void
	{
		this.increments = $inc;
	}
	public function getIncrements():Number
	{
		return this.increments;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onLowestValue():Void{}
	function onHighestValue():Void{}
}