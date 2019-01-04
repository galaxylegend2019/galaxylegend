/*								AnimatedLetters
**
*********Properties****************************Description******
**
*********Methods****************************Description*******
**
*********Events*****************************Description*******
**
*********TODO*************************************************
**
*/
[IconFile("icons/Credits.png")]
class com.tap4fun.components.animation.AnimatedLetters extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "AnimatedLetters";
	static var symbolOwner:Object = AnimatedLetters;
	var className:String = "AnimatedLetters";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=0)]
	public var lettersSpacing:Number;
	[Inspectable(defaultValue=0)]
	public var linesSpacing:Number;
	
	public var playFaster:Boolean;
	
	private var _splittedText:Array;
	
	private var _letterIndex:Number;
	private var _lineIndex:Number;
	
	//MovieClips
	var letter_anim:MovieClip;
	var limits:MovieClip;
	var fulltext:TextField;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function AnimatedLetters()
	{
		this.letter_anim._visible = false;
		this.letter_anim.stop();
		this._splittedText = new Array();
		this.lettersSpacing = this.letter_anim.letter._width + this.lettersSpacing;
		this.linesSpacing = this.letter_anim.letter._height + this.linesSpacing;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function animateText($text:String):Void
	{
		this.fulltext.text = $text;
		for(var $letter_mc in this)
		{
			if(this[$letter_mc].isLetter)this[$letter_mc].removeMovieClip();
		}
		this._splittedText = $text.split("");
		this._letterIndex = 0;
		this._lineIndex = 0;
		this.addLetter();
	}
	public function addLetter():Boolean
	{
		if(this._splittedText.length <= 0)
		{
			return false;
		}
		
		var $letter:String = this._splittedText[0];
		this._splittedText.reverse();
		this._splittedText.pop();
		this._splittedText.reverse();
		//this._splittedText = this._splittedText.slice(1);
		
		//New line
		if($letter == "\n")
		{
			this._letterIndex = 0;
			this._lineIndex++;
			this.addLetter();
			return true;
		}
		
		var $current:MovieClip = this.letter_anim.duplicateMovieClip("letter" + this._lineIndex + "_" + this._letterIndex, this.getNextHighestDepth());
		
		$current.isLetter = true;
		if(this._splittedText.length <= 0)
		{
			trace("Adding last letter!");
			$current.isLastLetter = true;
		}
		
		$current._x = this.limits._x + (this.lettersSpacing * this._letterIndex);
		if($current._x + this.lettersSpacing > this.limits._x + this.limits._width)
		{
			this._letterIndex = 0;
			this._lineIndex++;
			$current._x = this.limits._x + (this.lettersSpacing * this._letterIndex);
		}
		$current._y = this.limits._y + (this.linesSpacing * this._lineIndex);
		this._letterIndex++;
		$current.letter.text.text = $letter;
		$current.letter.text.autoSize = "left";
		
		//Go directly to next if space
		if($letter == " ")
		{
			this.addLetter();
			return true;
		}
		
		if(this.playFaster) $current.gotoAndPlay("anim_fast");
		else $current.gotoAndPlay("anim");
		
		$current.addNewLetter = function():Void
		{
			this._parent.addLetter();
		};
		$current.onAnimationEnd = function():Void
		{
			if(this.isLastLetter) this._parent.onAnimationEnd();
			this.stop();
			this.removeMovieClip();
		};
		return true;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//									Getters and Setters											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Events												//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onAnimationEnd():Void{}
}