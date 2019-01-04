import TextField.StyleSheet;

class com.tap4fun.components.elements.TextStyle extends Object
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public static var FONT_FACE_0:String = "Arial";
	
	public static var FONT_SIZE_MULTIPLIER:Number = 1;
	
	public static var FONT_SIZE_0:Number = 26	*	FONT_SIZE_MULTIPLIER;
	public static var FONT_SIZE_1:Number = 22	*	FONT_SIZE_MULTIPLIER;
	public static var FONT_SIZE_2:Number = 20	*	FONT_SIZE_MULTIPLIER;
	public static var FONT_SIZE_3:Number = 16	*	FONT_SIZE_MULTIPLIER;
	public static var FONT_SIZE_4:Number = 14	*	FONT_SIZE_MULTIPLIER;
	public static var FONT_SIZE_5:Number = 12	*	FONT_SIZE_MULTIPLIER;
	
	public static var DECLARATION_FONT_FAMILY_0:String = "font-family: " + FONT_FACE_0 + "; ";
	public static var DECLARATION_FONT_SIZE_0:String = "font-size: " + FONT_SIZE_0 + "px; ";
	public static var DECLARATION_FONT_SIZE_1:String = "font-size: " + FONT_SIZE_1 + "px; ";
	public static var DECLARATION_FONT_SIZE_2:String = "font-size: " + FONT_SIZE_2 + "px; ";
	public static var DECLARATION_FONT_SIZE_3:String = "font-size: " + FONT_SIZE_3 + "px; ";
	public static var DECLARATION_FONT_SIZE_4:String = "font-size: " + FONT_SIZE_4 + "px; ";
	public static var DECLARATION_FONT_SIZE_5:String = "font-size: " + FONT_SIZE_5 + "px; ";
	public static var DECLARATION_FONT_WEIGHT_BOLD:String = "font-weight: bold; ";
	
	public static var DECLARATION_FONT_STYLE_0:String = DECLARATION_FONT_FAMILY_0 + DECLARATION_FONT_SIZE_0 + DECLARATION_FONT_WEIGHT_BOLD;
	public static var DECLARATION_FONT_STYLE_1:String = DECLARATION_FONT_FAMILY_0 + DECLARATION_FONT_SIZE_1 + DECLARATION_FONT_WEIGHT_BOLD;
	public static var DECLARATION_FONT_STYLE_2:String = DECLARATION_FONT_FAMILY_0 + DECLARATION_FONT_SIZE_2 + DECLARATION_FONT_WEIGHT_BOLD;
	public static var DECLARATION_FONT_STYLE_3:String = DECLARATION_FONT_FAMILY_0 + DECLARATION_FONT_SIZE_3;
	public static var DECLARATION_FONT_STYLE_4:String = DECLARATION_FONT_FAMILY_0 + DECLARATION_FONT_SIZE_4;
	public static var DECLARATION_FONT_STYLE_5:String = DECLARATION_FONT_FAMILY_0 + DECLARATION_FONT_SIZE_5;
	
	public var styleSheet:StyleSheet;
	
	public static var STYLE_SHEET:StyleSheet = defineAndGetStyle();
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public static function defineAndGetStyle():StyleSheet
	{
		var $css:StyleSheet = new StyleSheet();
		
		var $css_str:String = "";
		$css_str += " .header1 {" + DECLARATION_FONT_STYLE_0 + " color:#FF0000; }";
		$css_str += " .header2 {" + DECLARATION_FONT_STYLE_1 + "}";
		$css_str += " .header3 {" + DECLARATION_FONT_STYLE_2 + "}";
		$css_str += " .paragraph1 {" + DECLARATION_FONT_STYLE_3 + "}";
		$css_str += " .paragraph2 {" + DECLARATION_FONT_STYLE_4 + "}";
		$css_str += " .small {" + DECLARATION_FONT_STYLE_5 + "}";
		
		$css.parseCSS($css_str);
		
		return $css;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
}