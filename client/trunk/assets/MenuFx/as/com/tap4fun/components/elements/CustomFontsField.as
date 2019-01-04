/*CustomFontsField
**
** com.tap4fun.components.elements.CustomFontsField
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
**
*/
//[IconFile("icons/ChoicesBox.png")]
[IconFile("icons/Text.png")]

class com.tap4fun.components.elements.CustomFontsField extends com.tap4fun.components.ComponentBase
{
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Properties											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//constants
	public static var symbolName:String = "CustomFontsField";
	public static var symbolOwner:Object = CustomFontsField;
	public var className:String = "CustomFontsField";
	public static var CLASS_REF = com.tap4fun.components.elements.CustomFontsField;
	public static var LINKAGE_ID:String = "com.tap4fun.components.elements.CustomFontsField";
	
	//public
	//[Inspectable(defaultValue="")]
	//[Inspectable(name="property",enumeration="value1,value2,value3",defaultValue="value1")]
	[Inspectable(name="Texte", defaultValue="")]
	private var _text:String;
	[Inspectable(defaultValue="")]
	public var textID:String;
	[Inspectable(defaultValue="")]
	public var font:String;
	[Inspectable(defaultValue=1)]
	public var fontSize:Number;
	[Inspectable(defaultValue=0)]
	public var letterSpacing:Number;
	[Inspectable(defaultValue=0)]
	public var lineSpacing:Number;
	[Inspectable(enumeration="left,right,center,justify", defaultValue="left")]
	public var align:String;
	[Inspectable(defaultValue=false)]
	public var bold:Boolean;
	[Inspectable(defaultValue=false)]
	public var italic:Boolean;
	
	//private
	private var _currentX:Number;
	private var _currentY:Number;
	private var _fontHeight:Number;
	private var _spaceWidth:Number;
	private var _fieldWidth:Number;
	private var _fieldHeight:Number;
	private var _properties:String;
	private var _currentWordLetters:Array;
	private var _currentLineLetters:Array;
	private var _currentLineWidth:Number;
	
	//MovieClips
	private var _textContainer:MovieClip;
	private var container:MovieClip;
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function CustomFontsField()
	{
		this._currentWordLetters = new Array();
		this._fontHeight = 0;
		this._spaceWidth = 0;
		this._fieldWidth = this._width;
		this._fieldHeight = this._height;
		this.generatePropertiesString();
		this.refreshText();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function insertText($text:String, $continue:Boolean)
	{
		var $splitString:Array = $text.split("");
		var $newLetterMc:MovieClip;
		var $curLetter:String;
		
		this.generatePropertiesString();
		
		if(!$continue)
		{
			//When starting fresh
			/*if(this.textID != undefined && this.textID != "" && this.textID != null && _global.$version=="gameSWF")
			{
				this.setText(_global.getString(this.textID));
			}
			else
			{
				this.setText(this._text);
			}*/
			
			if(this._textContainer)this._textContainer.removeMovieClip();
			this._textContainer = this.createEmptyMovieClip("container", this.getNextHighestDepth());
			
			this._currentWordLetters = new Array();
			this._currentLineLetters = new Array();
			this._currentLineWidth = 0;
			this._currentX = 0;
			this._currentY = 0;
		}
		else
		{
			if(this.align!="left")this.realignLastLineLeft();
		}
		
		for(var $i:Number = 0; $i < $splitString.length; $i++)
		{
			$curLetter = $splitString[$i];
			
			if($curLetter == " ")
			{
				//Space char
				this._currentX += this._spaceWidth + this.letterSpacing;
				this._currentWordLetters = new Array();
				continue;
			}
			else if($curLetter == "\n")
			{
				//New Line char
				this._currentLineWidth = this._currentX;
				this.alignLine();
				this._currentY += this._fontHeight + this.lineSpacing;
				this._currentX = 0;
				this._currentWordLetters = new Array();
				this._currentLineLetters = new Array();
				this._currentLineWidth = 0;
				continue;
			}
			
			//Insert Letter
			$newLetterMc = this.insertLetter($curLetter);
			this._currentLineLetters.push($newLetterMc);
			this._currentLineWidth = this._currentX;
			
			if(($newLetterMc._x + $newLetterMc._width)>this._fieldWidth)
			{
				//To next line
				//this._currentLineWidth -= this._spaceWidth;
				this.currentWordToNextLine();
			}
		}
		this.alignLine();
	}
	private function generatePropertiesString():String
	{
		if(!this.bold && !this.italic)
		{
			this._properties = "";
		}
		else
		{
			this._properties = "_";
			this._properties += (this.bold)?"B":"";
			this._properties += (this.italic)?(this.bold?",i":"i"):"";
		}
		return this._properties;
	}
	private function insertLetter($letter:String):MovieClip
	{
		var $letterCase:String;
		var $letterName:String;
		var $newLetterMc:MovieClip;
		var $letterWidth:Number;
		var $nextDepth:Number;
		
		$letterCase = ($letter.toLowerCase()==$letter)?"LC":"UC";
		$letterName = this.font + "_" + $letter + "_" + $letterCase + this._properties;
		$nextDepth = this._textContainer.getNextHighestDepth();
		$newLetterMc = this._textContainer.attachMovie($letterName, $letterName + $nextDepth, $nextDepth);
		this._currentWordLetters.push($newLetterMc);
		
		$newLetterMc._x = this._currentX;
		$newLetterMc._y = this._currentY;
		$newLetterMc._xscale = $newLetterMc._yscale = this.fontSize * 100;
		
		if($newLetterMc._width == undefined)
			trace("ERROR! Can't find letter \"" + $letterName + "\" in Custom Font \"" + this.font + "\""
			+ ((this.bold||this.italic)?(" with attribute" + ((this.bold&&this.italic)?"s":"") + " "
			+ (this.bold?"B":"") + (this.italic?(this.bold?",i":"i"):"")):"")
			);
		$letterWidth = ($newLetterMc._width)?$newLetterMc._width:0;
		this._currentX += $letterWidth + this.letterSpacing;
		
		if(this._fontHeight == 0)
		{
			this._fontHeight = $newLetterMc._height;
		}
		if(this._spaceWidth == 0)
		{
			this._spaceWidth = $letterWidth;
		}
		
		return $newLetterMc;
	}
	private function currentWordToNextLine():Void
	{
		var $curLetterMc:MovieClip;
		var $letterWidth:Number = 0;
		var $lettersToNextLine:Array = new Array();
		
		this._currentY += this._fontHeight + this.lineSpacing;
		this._currentLineWidth = this._currentX;
		this._currentX = 0;
		for(var $j:Number = 0; $j < this._currentWordLetters.length; $j++)
		{
			$curLetterMc = this._currentWordLetters[$j];
			$curLetterMc._x = this._currentX;
			$curLetterMc._y = this._currentY;
			
			this._currentLineLetters.pop();
			$lettersToNextLine.push($curLetterMc);
			
			$letterWidth = ($curLetterMc._width)?$curLetterMc._width:0;
			this._currentLineWidth -= $letterWidth;
			this._currentX += $letterWidth + this.letterSpacing;
		}
		//this._currentLineWidth -= this._spaceWidth;
		this.alignLine();
		this._currentWordLetters = new Array();
		this._currentLineLetters = $lettersToNextLine;
	}
	private function realignLastLineLeft():Void
	{
		this.alignLine(true);
	}
	private function alignLine($invert:Boolean):Void
	{
		if(this.align != "left")
		{
			//Align
			switch(this.align)
			{
				case "right":
				var $decalBy:Number = (this._fieldWidth - this._currentLineWidth);
				for(var $i:Number=0; $i<this._currentLineLetters.length; $i++)
				{
					if($invert)this._currentLineLetters[$i]._x -= $decalBy;
					else this._currentLineLetters[$i]._x += $decalBy;
				}
				break;
				
				case "center":
				var $decalBy:Number = (this._fieldWidth - this._currentLineWidth)/2;
				for(var $i:Number=0; $i<this._currentLineLetters.length; $i++)
				{
					if($invert)this._currentLineLetters[$i]._x -= $decalBy;
					else this._currentLineLetters[$i]._x += $decalBy;
				}
				break;
				
				case "justify":
				var $decalBy:Number = (this._fieldWidth - this._currentLineWidth)/this._currentLineLetters.length;
				for(var $i:Number=0; $i<this._currentLineLetters.length; $i++)
				{
					if($invert)this._currentLineLetters[$i]._x -= $decalBy*$i;
					else this._currentLineLetters[$i]._x += $decalBy*$i;
				}
				break;
			}
		}
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
	public function onChangeLanguage():Void
	{
		this.refreshText();
	}
	public function appendText($text:String):Void
	{
		this._text += $text;
		this.insertText($text, true);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function set text($text:String):Void
	{
		this._text = $text;
		this.insertText(this._text, false);
	}
	public function get text():String
	{
		return this._text;
	}
	public function setText($text:String):Void
	{
		this._text = $text;
		this.insertText(this._text, false);
	}
	public function getText():String
	{
		return this._text;
	}
	public function setTextID($id:String):Void
	{
		this.textID = $id;
		this.refreshText();
	}
	public function getTextID():String
	{
		return this.textID;
	}
	public function setFont($font:String):Void
	{
		this.font = $font;
		this.refreshText();
	}
	public function getFont():String
	{
		return this.font;
	}
	public function setAlign($align:String):Void
	{
		this.align = $align;
		this.refreshText();
	}
	public function getAlign():String
	{
		return this.align;
	}
	public function setBold($bold:Boolean):Void
	{
		this.bold = $bold;
		this.refreshText();
	}
	public function getBold():Boolean
	{
		return this.bold;
	}
	public function setItalic($italic:Boolean):Void
	{
		this.italic = $italic;
		this.refreshText();
	}
	public function getItalic():Boolean
	{
		return this.italic;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	

}