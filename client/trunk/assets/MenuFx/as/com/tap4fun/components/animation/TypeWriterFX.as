/*								AnimatedLetters
** Note: Use device fonts for accuracy! textWidth is screwed when anti-aliasing is ON!
**
*********Properties****************************Description******
**
*********Methods****************************Description*******
**
*********Events*****************************Description*******
**
*********TODO*************************************************
** HTML Support
** Force Main TextField anti-aliasing to none and letter to "for animation"
*/
import com.tap4fun.StaticFunctions;

[IconFile("icons/Credits.png")]

class com.tap4fun.components.animation.TypeWriterFX extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "TypeWriterFX";
	static var symbolOwner:Object = TypeWriterFX;
	var className:String = "TypeWriterFX";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public var speed:Number;
	public var text:String;
	
	private var _words:Array;
	private var _currentWordIndex:Number;
	private var _isNewWord:Boolean;
	private var _lineIsBreaking:Boolean;
	
	private var _currentLetter:Object;
	private var _currentLine:Object;
	
	private var _letterspacing:Number;
	private var _linespacing:Number;
	
	private var _spaceWidth:Number;
	
	private var _ref_tf:TextField;
	private var _currentLetterAnim:MovieClip;
	
	private var _letters_mcs:Array;
	
	//MovieClips
	public var fulltf:TextField;
	public var mask:MovieClip;
	public var tf_anim:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function TypeWriterFX()
	{
		trace("\n\n!!Warning!!: We are experiencing issues with masks placement of \"TypeWriterFX\" component in GameSWF. Still not acting the way it should...\n\n");
		this.setSpeed(this.speed);
		
		this._words = new Array();
		this._letters_mcs = new Array();
		this._ref_tf = this.tf_anim.tf_symbol.tf;
		this._ref_tf.autoSize = "left";
		
		this.fulltf.html = true;
		
		this.setText(this.text);
		
		this._currentLetter = new Object();
		this._currentLetter.x = this.fulltf._x;
		this._currentLetter.y = this.fulltf._y;
		this._currentLetter.width = 0;
		this._currentLetter.height = 0;
		this._currentLetter.index = 0;
		
		this._currentLine = new Object();
		this._currentLine.x = this.fulltf._x;
		this._currentLine.y = this.fulltf._y;
		this._currentLine.width = 0;
		this._currentLine.height = 0;
		
		this._letterspacing = fulltf.getTextFormat().letterSpacing;
		this._linespacing = fulltf.getTextFormat().leading;
		
		//Apply TextField style to letter anim
		//this.tf_anim.tf_symbol.tf.setNewTextFormat(this.fulltf.getTextFormat());
		this.tf_anim._visible = false;
		
		this.resetMask();
		this.findSpaceWidth();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Methods											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function findSpaceWidth():Void
	{
		//Finding the width of a space
		this._ref_tf.text = "W";
		this._ref_tf.setTextFormat(this.fulltf.getTextFormat());
		var $refLetterWidth:Number = this._ref_tf.textWidth;
		this._ref_tf.text = "W W";
		this._ref_tf.setTextFormat(this.fulltf.getTextFormat());
		this._spaceWidth = this._ref_tf.textWidth - ($refLetterWidth*2);
		delete $refLetterWidth;
	}
	private function resetMask():Void
	{
		//Preset Mask
		this.mask._x = this.mask._y = 0;
		this.mask.mask_letter._width = 0;
		this.mask.mask_letter._height = 0;
		this.mask.mask_letter._x = 0;
		this.mask.mask_letter._y = 0;
		this.mask.mask_letter._width = this._currentLetter.width = this._letterspacing;
		
		this.mask.mask_letter._x = this._currentLine.x;
		this.mask.mask_letter._y = this._currentLine.y;
		
		this.mask.mask_line._height = 0;
		this.mask.mask_line._width = this.fulltf._width;
		this.mask.mask_line._x = this.fulltf._x;
		this.mask.mask_line._y = this.fulltf._y;
	}
	private function addLetter():Void
	{
		this._currentLetter.letter = this.text.charAt(this._currentLetter.index);
		
		this._currentLetter.x += this._currentLetter.width;
		
		if(this._isNewWord)
		{
			//Determine if new word causes line break
			this._isNewWord = false;
			this._ref_tf.text = this._words[this._currentWordIndex];
			this._ref_tf.setTextFormat(this.fulltf.getTextFormat());
			this._lineIsBreaking = (this._ref_tf.textWidth + this._currentLine.width) > this.fulltf._width-(this._letterspacing)-2;
		}
		
		//Begin of future support for HTML...
		/*if(nextLetter == "<")
		{
			checkedLetter = nextLetter;
			htmltext = checkedLetter;
			while(checkedLetter != "/")
			{
				_currentLetterIndex++;
				checkedLetter = this.$text.charAt(_currentLetterIndex);
				htmltext += checkedLetter;
			}
			while(checkedLetter != ">")
			{
				_currentLetterIndex++;
				checkedLetter = this.$text.charAt(_currentLetterIndex);
				htmltext += checkedLetter;
			}
			this._ref_tf.htmlText = htmltext;
		}
		else
		{*/
			/*this._ref_tf.text = "";
			this._ref_tf._width = 1;*/
			//this._ref_tf._height = 1;
			this._ref_tf.text = this._currentLetter.letter;
			this._ref_tf.setTextFormat(this.fulltf.getTextFormat());
			//this._ref_tf._x = 0;
		/*}*/
		
		//Determining width of the current letter
		if(this._currentLetter.letter == " ")
		{
			this._currentWordIndex++;
			this._isNewWord = true;
			this._currentLetter.width = this._spaceWidth;
		}
		else
		{
			this._currentLetter.width = this._ref_tf.textWidth;
		}
		
		this._currentLetter.height = this._ref_tf.textHeight;
		
		//this._ref_tf._y = this.fulltf._y + this.mask.mask_line._height - textheight;
		
		//this.mask.mask_letter._width = this._currentLine.width + 1;
		this.mask.mask_letter._height = this._currentLine.height + (this._currentLetter.height/3);
		
		this._currentLine.width += (this._currentLetter.width+this._letterspacing);
		this._currentLine.height = this._currentLetter.height;
		
		//Next Line
		if(this._lineIsBreaking)
		{
			//trace("Wo! Line breaks to word " + this._words[this._currentWordIndex]);
			//this._lineIsBreaking = false;
			
			this._currentLine.y += this._currentLetter.height + this._linespacing;
			
			//this.mask.mask_line._height += (this._currentLetter.height + (this._currentLetter.height/18));
			
			this._currentLine.width = this._currentLetter.width;
			this._currentLine.height = this._currentLetter.height;
			
			//this.mask.mask_letter._x = this._currentLine.x;
			//this.mask.mask_letter._y = this._currentLine.y;
			//this.mask.mask_letter._width = this._letterspacing;
			
			this._currentLetter.x = this._currentLine.x + this._letterspacing;
			this._currentLetter.y = this._currentLine.y;
		}
		
		if(this._lineIsBreaking)
		{
			this._currentLetterAnim.lastOfLine = true;
			this._lineIsBreaking = false;
		}
		
		//TODO: Don't remove, re-use those duplicated MovieClips when free!
		if(this._letters_mcs.length > 0)
		{
			this._currentLetterAnim = this._letters_mcs[this._letters_mcs.length-1];
			//this.removeAvailableLetter(this._letters_mcs[0]);
			this._letters_mcs.pop();
			this._currentLetterAnim._visible = true;
			this._currentLetterAnim.gotoAndStop("init");
		}
		else
		{
			this._currentLetterAnim = this.tf_anim.duplicateMovieClip("tf_anim" + this._currentLetter.index, this.getNextHighestDepth());
		}
		this._currentLetterAnim._x = this._currentLetter.x;
		this._currentLetterAnim._y = this._currentLetter.y;
		this._currentLetterAnim.tf_symbol.tf.autoSize = true;
		//this._currentLetterAnim.tf_symbol.tf.setNewTextFormat(this.tf_anim.tf_symbol.tf.getTextFormat());
		this._currentLetterAnim.tf_symbol.tf.text = this._currentLetter.letter;
		this._currentLetterAnim.tf_symbol.tf.setTextFormat(this.tf_anim.tf_symbol.tf.getTextFormat());
		
		
		//Determines if last letter
		if(this._currentLetter.index >= this.text.length-1)
		{
			//trace("Last letter: " + this._currentLetter.index);
			this._currentLetterAnim.isLastLetter = true;
		}
		
		this._currentLetterAnim.gotoAndPlay("anim_speed_" + this.speed);
		this._currentLetterAnim.addLetter = function():Void
		{
			if(!this.isLastLetter) this._parent.addLetter();
		};
		this._currentLetterAnim.onAnimationEnd = function():Void
		{
			//this._parent.adjustMask((this._x + this._width + this._parent._x), this._parent._y + this._y);
			this._parent.adjustMask(this);
			this.stop();
			this._visible = false;
			this._parent.addAvailableLetter(this);
			//this.removeMovieClip();
		};
		
		/*this.tf_anim._x = this._currentLetter.x;
		this.tf_anim._y = this._currentLetter.y;
		this.tf_anim.gotoAndPlay("anim");*/
		if(this.onAddLetter) this.onAddLetter();
		
		this._currentLetter.index++;
	}
	public function addAvailableLetter($letter:MovieClip):Void
	{
		$letter.lastOfLine = false;
		$letter.isLastLetter = false;
		this._letters_mcs.push($letter);
	}
	public function removeAvailableLetter($letter:MovieClip):Void
	{
		StaticFunctions.removeElement(this._letters_mcs, $letter);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Methods											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function start():Void
	{
		this._currentLetter.x = this.fulltf._x;
		this._currentLetter.y = this.fulltf._y;
		this._currentLetter.width = 0;
		this._currentLetter.height = 0;
		this._currentLetter.index = 0;
		
		this._currentLine.x = this.fulltf._x;
		this._currentLine.y = this.fulltf._y;
		this._currentLine.width = 0;
		this._currentLine.height = 0;
		
		this.resetMask();
		this.findSpaceWidth();
		
		this._currentWordIndex = 0;
		this._currentLine.index = 0;
		this._currentLetter.index = 0;
		this._isNewWord = false;
		
		this.addLetter();
	}
	public function adjustMask($letter:MovieClip):Void
	{
		this.mask.mask_letter._x = this.fulltf._x;
		this.mask.mask_letter._y = $letter._y;
		this.mask.mask_letter._width = ($letter._x + $letter._width - this.fulltf._x);
		
		if($letter.lastOfLine)
		{
			this.mask.mask_line._x = this.fulltf._x;
			this.mask.mask_line._height = $letter._y + $letter._height - this.mask.mask_line._y;
		}
		if($letter.isLastLetter)
		{
			//this.mask.mask_line._height = this.fulltf._height;
			if(this.onComplete) this.onComplete();
		}
		/*else
		{
			this.mask.mask_line._height = $letter._parent._y + $letter._y;
		}*/
	}
	public function complete():Void
	{
		this._currentLetter.index = this.text.length-1;
		this.mask.mask_line._height = this.fulltf._height;
		//if(this.onComplete) this.onComplete();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//									Getters and Setters											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setText($text:String):Void
	{
		this.text = $text;
		this._words = $text.split(" ");
		this._currentWordIndex = 0;
		this._currentLine.index = 0;
		this._currentLetter.index = 0;
		this._isNewWord = false;
		this._ref_tf.gotoAndStop("init");
		this.fulltf.htmlText = this.text;
		this.resetMask();
	}
	public function setSpeed($speed:Number):Void
	{
		this.speed = $speed;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Events												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onComplete():Void{}
	public function onAddLetter():Void{}
}