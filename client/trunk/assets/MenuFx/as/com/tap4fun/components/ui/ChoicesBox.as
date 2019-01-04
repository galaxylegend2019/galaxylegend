/*								ChoicesBox
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
import com.tap4fun.components.Events;
import com.tap4fun.StaticFunctions;

[IconFile("icons/ChoicesBox.png")]
class com.tap4fun.components.ui.ChoicesBox extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "ChoicesBox";
	static var symbolOwner:Object = ChoicesBox;
	var className:String = "ChoicesBox";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue="")]
	public var options:Array;
	public var value;
	[Inspectable(defaultValue=0)]
	public var optionIndex:Number;
	
	public var animating:Boolean;
	
	private var btn_prev:com.tap4fun.components.ui.Button;
	private var btn_next:com.tap4fun.components.ui.Button;
	private var option:MovieClip;
	private var option_before:MovieClip;
	private var option_after:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ChoicesBox()
	{
		this.option.option_label.text = this.options[0];
		this.onLoad = function():Void
		{
			this.setElementsEventsHandlers();
			this.setOptions(this.options);
			this.setOptionIndex(this.optionIndex);
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
		this.btn_prev.onNavigatorLeft = function():Void
		{
			this.onRelease();
		};
		this.btn_next.onNavigatorRight = function():Void
		{
			this.onRelease();
		};
	}
	private function getLabel($index:Number):String
	{
		if(this.options[$index].textID != undefined)
			return _global.getString(this.options[$index].textID);
		
		if(this.options[$index].text != undefined)
			return this.options[$index].text;
			
		if(this.options[$index] != undefined)
			return this.options[$index];
			
		return "";
	}
	public function updateValues():Void
	{
		this.option_before.option_label.htmlText = getLabel(this.optionIndex - 1);
		this.option.option_label.htmlText = getLabel(this.optionIndex);
		this.option_after.option_label.htmlText = getLabel(this.optionIndex + 1);
		this.value = this.options[this.optionIndex].value != undefined ? this.options[this.optionIndex].value : getLabel(this.optionIndex);
		
		//Disabling buttons on limits reached
		if(this.optionIndex <= 0)
		{
			if(this.btn_prev.setDisabled) this.btn_prev.setDisabled(true);
			else this.btn_prev.disabled = true;
		}
		else
		{
			if(this.btn_prev.setDisabled) this.btn_prev.setDisabled(false);
			else this.btn_prev.disabled = false;
		}
		if(this.optionIndex >= this.options.length-1)
		{
			if(this.btn_next.setDisabled) this.btn_next.setDisabled(true);
			else this.btn_next.disabled = true;
		}
		else
		{
			if(this.btn_next.setDisabled) this.btn_next.setDisabled(false);
			else this.btn_next.disabled = false;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function goToPrevious():Void
	{
		if(this.optionIndex > 0)
		{
			this.setOptionIndex(this.getOptionIndex()-1);
		}
	}
	public function goToNext():Void
	{
		if(this.optionIndex < this.options.length-1)
		{
			this.setOptionIndex(this.getOptionIndex()+1);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setOptions($options:Array):Void
	{
		this.options = $options;
		this.option.option_label.text = this.options[0];
		this.updateValues();
	}
	public function getOptions():Array
	{
		return this.options
	}
	public function getValue():Object
	{
		return this.value
	}
	public function setOptionIndex($index:Number):Void
	{
		//Setting properties
		if($index == undefined) $index = 0;
		var $prev_index = this.optionIndex;
		this.optionIndex = $index;
		if(this.optionIndex <= 0) this.optionIndex = 0;
		if(this.optionIndex >= this.options.length-1) this.optionIndex = this.options.length-1;
		this.value = this.options[this.optionIndex].value != undefined ? this.options[this.optionIndex].value : getLabel(this.optionIndex);
		
		if($prev_index != this.optionIndex)
		{
			this.animating = true;
			if(this.onChange)this.onChange(this.getValue());
			this.animating = false;
		}
		
		//Animation
		if(this.animating)
		{
			this.updateValues();
		}
		if(this.optionIndex < $prev_index)
		{
			this.gotoAndPlay("change_previous");
			this.animating = true;
		}
		else if(this.optionIndex > $prev_index)
		{
			this.gotoAndPlay("change_next");
			this.animating = true;
		}
		this.onAnimationEnd = function():Void
		{
			this.animating = false;
			this.updateValues();
			this.defaultOnAnimationEnd();
			this.onAnimationEnd = this.defaultOnAnimationEnd;
		}
	}
	public function getOptionIndex():Number
	{
		return this.optionIndex;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	function onChangeLanguage($lang:String):Void
	{
		if(this.animating != true)
		{
			updateValues();
		}
	}
}