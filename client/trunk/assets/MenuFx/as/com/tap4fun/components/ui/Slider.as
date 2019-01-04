/*								Slider
**
** Le MovieClip doit comporter:
**	-Un MovieClip nommé "handle" et ayant comme frame labels: "out", "over", "press", "release"
**	-Un MovieClip nommé "slot" (servant de base pour établir les limites)
**
** Exemple:
** 
** 	import com.tap4fun.components.ui.Slider;
** 	
** 	var mySlider:MovieClip = Slider.construct(this, 0, 100, true);
** 	mySlider.onChange = function():Void
** 	{
** 		trace(this.value());
** 	};
** 	mySlider.onSliding = function():Void
** 	{
** 		trace(this.value());
** 	};
** 	mySlider.value = 78;
*********Properties****************************Description******

*********Methods****************************Description*******
**getValue():Number								//
**setValue($value:Number):Void					//
**setMinValue($value:Number):Void			//
**setMaxValue($value:Number):Void			//

*********Events*****************************Description*******
**onQuitDrag			//
**onSliding				//
**onChange				//

*********TODO*************************************************
*/

class com.tap4fun.components.ui.Slider extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "Slider";
	static var symbolOwner:Object = Slider;
	var className:String = "Slider";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=0)]
	public var minValue:Number;
	[Inspectable(defaultValue=1)]
	public var maxValue:Number;
	[Inspectable(defaultValue=0)]
	public var value:Number;
	
	private var handle:com.tap4fun.components.ui.Button;
	private var slot:MovieClip;
	private var _oldValue:Number;
	private var _range:Number;
	private var _xoffset:Number;
	private var _yoffset:Number;
	private var _lowPos:Number;
	private var _highPos:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Slider()
	{
		this.onLoad = function():Void
		{
			this.setValue(this.value);
			this.setElementsEventsHandlers();
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function setElementsEventsHandlers():Void
	{
		this.handle.onPress = function():Void 
		{
			this.onPressAction();
			if(!this.disabled)
			{
				_global.forceFlashInputBehavior(true);
				this._parent.enterDrag();
			}
		};
		this.handle.onReleaseOutside = function():Void 
		{
			_global.forceFlashInputBehavior(false);
			this.onReleaseOutsideAction();
			this._parent.quitDrag();
		};
		this.handle.onRelease = function():Void 
		{
			_global.forceFlashInputBehavior(false);
			this.onReleaseAction();
			this._parent.quitDrag();
		};
		this.slot.onRelease= function():Void
		{
			this._parent.sendHandleToMouse();
		}
		
		this.listenToControllerInput();
	}
	
	private function sendHandleToMouse():Void
	{
		// used by children
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
	
	private function placeHandleToValue($value:Number):Void
	{
		this._range = this.maxValue - this.minValue;
	}
	private function checkIfValueChanged():Boolean
	{
		var $changed:Boolean = false;
		if(this._oldValue != this.value)
		{
			$changed = true;
			if(this.onChange) this.onChange(this.value);
		}
		this._oldValue = this.value;
		return $changed;
	};
	public function enterDrag():Void
	{
		//Used in children classes
	}
	public function quitDrag():Void
	{
		this.checkIfValueChanged();
		delete this.onEnterFrame;
		if(this.onQuitDrag) this.onQuitDrag();
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setValue($value:Number):Void
	{
		if($value > this.maxValue) $value = this.maxValue;
		if($value < this.minValue) $value = this.minValue;
		this.value = $value;
		this.placeHandleToValue($value);
		this.checkIfValueChanged();
		//this.onSetValue();
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
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onQuitDrag():Void{}
	public function onSliding():Void{}
	public function onChange():Void{}
	public function onEnterFrame():Void{}
	public function onEnterDrag():Void{}
}