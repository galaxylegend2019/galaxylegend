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
import text_styles.TextStyles;
[IconFile("icons/Text.png")]

[Event("onLoadComplete")]
[Event("onProgress")]

class com.tap4fun.components.elements.Text extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "Text";
	static var symbolOwner:Object = Text;
	var className:String = "Text";
	//var tstyles:TextStyles = new TextStyles();
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	[Inspectable(defaultValue="")]
	public var text:String;
	[Inspectable(defaultValue="")]
	public var textID:String;
	[Inspectable(enumeration="default,left,right,center,justify",defaultValue="left")]
	public var align:String;
	[Inspectable(enumeration="title1,title2,title3,title4,title5,title6,paragraph1,paragraph2,paragraph3,",defaultValue="paragraph1",name="Style") ]
	public var style:String;
	[Inspectable(defaultValue="", name="Style Custom")]
	public var styleCustom:String;
	[Inspectable(defaultValue=false)]
	public var html:Boolean;
	
	//private var _tformat:TextFormat;
	private var _movieWidth:Number;
	
	private var tf:TextField;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Text()
	{
		
		this.tf.html = this.html;
		this.tf.multiline = true;
		this.tf.wordWrap = true;
		this.tf.autoSize = "center";
		this.tf.selectable = false;
		
		//this.applyTextStyle();
		/*trace(TextStyles.styles[this.style].color);
		trace($tformat.color);
		trace(this.tf.getTextFormat().color);*/
		//this.setText(this.text);
		//this.tf.setNewTextFormat($tformat);
		//this.setAlign(this.align);
		
		refreshText();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function applyTextStyle():Void
	{
		var $tformat = new TextFormat();
		
		for(var $i in TextStyles.styles.baseStyle)
		{
			$tformat[$i] = TextStyles.styles.baseStyle[$i];
		}
		for(var $i in TextStyles.styles[this.style])
		{
			$tformat[$i] = TextStyles.styles[this.style][$i];
		}
		if(this.styleCustom != "" && this.styleCustom != undefined && this.styleCustom != null && TextStyles.styles[this.styleCustom])
		{
			for(var $i in TextStyles.styles[this.styleCustom])
			{
				$tformat[$i] = TextStyles.styles[this.styleCustom][$i];
			}
		}
		this.tf.setTextFormat($tformat);
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function refreshText():Void
	{
		if(this.textID != undefined && this.textID != "" && this.textID != null && _global.$version=="gameSWF")
		{
			this.setText(_global.getString(this.textID));
		}
		else
		{
			this.setText(this.text);
		}
	}
	
	public function onChangeLanguage($lang:String):Void
	{
		refreshText();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setText($text:String):Void
	{
		this.text = $text;
		//var $tformat = this.tf.getTextFormat();
		if(this.html) this.tf.htmlText = $text;
		else this.tf.text = $text;
		//this.tf.setTextFormat($tformat);
		this.applyTextStyle();
		this.setAlign(this.align);
	}
	public function getText():String
	{
		return this.text;
	}
	public function setAlign($align:String):Void
	{
		if($align == "default" || $align == "" || $align == undefined)
		{
			this.align = "default";
			return;
		}
		var $tformat:TextFormat = this.tf.getTextFormat();
		if($align != "left" && $align != "center" && $align != "right" && $align != "justify")
		{
			trace("Error in Text " + this + " (" + this._name + ") unvalid align value: " + $align + ". Defaulting to left.");
			$align = "left";
		}
		this.align = $align;
		$tformat.align = $align;
		this.tf.setTextFormat($tformat);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}