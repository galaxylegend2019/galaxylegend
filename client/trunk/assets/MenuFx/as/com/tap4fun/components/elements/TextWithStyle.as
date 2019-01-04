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

[IconFile("icons/Text.png")]
import com.tap4fun.components.elements.TextStyle;
import TextField.StyleSheet;

class com.tap4fun.components.elements.TextWithStyle extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "TextWithStyle";
	static var symbolOwner:Object = TextWithStyle;
	var className:String = "TextWithStyle";
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	[Inspectable(defaultValue="")]
	public var string:String;
	[Inspectable(defaultValue="")]
	public var stringID:String;
	[Inspectable(defaultValue="",name="Style (CSS class)") ]
	public var style:String;
	
	public static var GET_STRING_FUNC:Function;
	public static var TEXT_STYLE:StyleSheet = TextStyle.STYLE_SHEET;
	
	private var tf:TextField;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function TextWithStyle()
	{
		if (GET_STRING_FUNC == undefined) GET_STRING_FUNC = _global.getString;
		this.tf.html = true;
		this.tf.selectable = false;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function refreshText():Void
	{
		if(this.stringID != undefined && this.stringID != "" && this.stringID != null)
		{
			this.setText(GET_STRING_FUNC.call(this, this.stringID));
		}
		else
		{
			this.setText(this.string);
		}
	}
	
	public function onChangeLanguage($lang:String):Void
	{
		refreshText();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setText($string:String):Void
	{
		this.string = $string;
		this.tf.htmlText = "<span class='" + this.style + "'>" + $string + "</span>";
	}
	public function getText():String
	{
		return this.string;
	}
	public function setTextFromID($id:String):Void
	{
		this.stringID = $id;
		this.refreshText();
	}
	public function setStyle($style:String):Void
	{
		this.style = $style;
	}
	public function getStyle():String
	{
		return this.style;
	}
	
	public function set text($string:String):Void
	{
		this.setText($string);
	}
	public function get text():String
	{
		return this.string;
	}
	public function set htmlText($string:String):Void
	{
		this.setText($string);
	}
	public function get htmlText():String
	{
		return this.string;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onLoad():Void
	{
		this.tf.styleSheet = TEXT_STYLE;
	}
}