/*								ComponentName
**
//Note: Frames inside of digits symbols must be set this way:
// frame 1: "0" symbol, frame 2: "1" symbol, ... frame 10: "9" symbol
// the less significant digit MovieClip must have an instance name of "d0", than comes "d1"... up to the most significant
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
**Could store digits in Array and allow starting from left / starting from right
*/
[IconFile("icons/Text.png")]

class com.tap4fun.components.elements.TexturedNumber extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "TexturedNumber";
	static var symbolOwner:Object = TexturedNumber;
	var className:String = "TexturedNumber";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Properties											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	[Inspectable(defaultValue=0)]
	public var value:Number;
	
	[Inspectable(defaultValue=0)]
	public var numberOfDigitsMin:Number;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function TexturedNumber()
	{
		if(!this.numberOfDigitsMin) this.numberOfDigitsMin = 0;
		this.setValue(this.value);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getValue():Number
	{
		return this.value;
	}
	public function setValue($number:Number):Void
	{
		var $curCount:Number = 0;
		var $curDigitIndex = 0;
		var $divider:Number;
		var $reminder:Number;
		
		if(!$number)$number = 0;
		$number = Math.floor($number);
		$reminder = $number;
		$divider = 10;
		
		this.value = $number;
		
		do
		{
			$curCount = $reminder%$divider;
			$reminder /= $divider;
			$reminder = Math.floor($reminder);
			this["d"+$curDigitIndex]._visible = true;
			this["d"+$curDigitIndex].gotoAndStop($curCount+1);
			$curDigitIndex++;
		}
		while($reminder>0 && this["d"+$curDigitIndex] instanceof MovieClip);
		
		while(this["d"+$curDigitIndex])
		{
			if($curDigitIndex >= this.numberOfDigitsMin)
			{
				this["d"+$curDigitIndex]._visible = false;
			}
			else
			{
				this["d"+$curDigitIndex].gotoAndStop(1);
			}
			$curDigitIndex++;
		}
		
		if(this.onChange) this.onChange(this.value);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onChange($newValue:Number):Void{}
}