/**
 /*								VirtualKeyboard
** Exemple:
** Avec un MovieClip id="bg" servant à délimiter la largeur et la hauteur et
** un com.tap4fun.components.ui.Button id="key"
** 
** 	var set1:Array = new Array(["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
** 	["A", "S", "D", "F", "G", "H", "J", "K", "L"],
** 	["Z", "X", "C", "V", "B", "N", "M", "&nbsp;"+VirtualKeyboard.VALUE_KEY_SEPARATOR+" ", '<br />'+VirtualKeyboard.VALUE_KEY_SEPARATOR+'<-']);
** 	var set2:Array = new Array(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
** 	["a", "s", "d", "f", "g", "h", "j", "k", "l"],
** 	["z", "x", "c", "v", "b", "n", "m", ",", "."]);
** 	my_keyboard.addKeySet(set1, 0);
** 	my_keyboard.addKeySet(set2, 1);
** 	my_keyboard.showKeySet(0);
** 	my_keyboard.setTextTarget(tf);
** 	switchcase.onUp = function():Void
** 	{
** 		if(this._parent.my_keyboard.getCurrentKeySetIndex() == 0) this._parent.my_keyboard.showKeySet(1);
** 		else this._parent.my_keyboard.showKeySet(0);
** 	};
*********Properties****************************Description******
**padding:Number		//Espace haut-bas-gauche-droite
**keysets:Array			//Array contenant les differents keysets

*********Methods****************************Description*******
**addKeySet($keyset:Array, $index:Number):Void	//
**setKeySet($keyset:Array, $index:Number):Void	//
**getKeySet($index:Number):Array				//
**getCurrentKeySetIndex():Number				//
**showKeySet($index:Number):Void 				//
**setTextTarget($target:TextField):Void			//
**getKeysMovieClips():Array						//
**setPadding($padding:Number):Void				//

*********Events*****************************Description*******
**onKeyPressed			//

*********TODO*************************************************
** Pre-setted keysets, multilang
*/
/*[IconFile("icons/ValueBar.png")]*/
class com.tap4fun.components.ui.VirtualKeyboard extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "VirtualKeyboard";
	static var symbolOwner:Object = VirtualKeyboard;
	var className:String = "VirtualKeyboard";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	static var VALUE_KEY_SEPARATOR:String = "=>";
	
	public var keysets:Array;
	[Inspectable(defaultValue=10)]
	public var padding:Number;
	
	public var keyset1:Array;
	public var keyset2:Array;
	public var keyset3:Array;
	public var keyset4:Array;
	public var keyset5:Array;
	
	private var key:com.tap4fun.components.ui.Button;
	private var bg:MovieClip;
	private var _mcKeyId:String;
	private var _currentKeySet:Number;
	private var _textTarget:TextField;
	private var _typedText:String;
	private var _mcKeysArray:Array;
			
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function VirtualKeyboard()
	{
		this.keysets = new Array();
		this._mcKeysArray = new Array();
		this.setPadding(this.padding);
		this._typedText = "";
		
		this.onLoad = function():Void
		{
			this.key._visible = false;
			this.defaultOnLoad();
		};
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function addKeySet($keyset:Array, $index:Number):Void 
	{
		if ($index == undefined)
		{
			this.keysets.push($keyset);
		}
		else
		{
			this.setKeySet($keyset, $index);
		}
	}
	public function showKeySet($index:Number):Void 
	{
		//trace("Key Array now " + this._mcKeysArray.length + " long");
		for(var $i:Number = 0; $i<this._mcKeysArray.length; $i++)
		{
			var $cur_key:MovieClip = this._mcKeysArray[$i];
			//trace("Removing MovieClip " + this._mcKeysArray[$i]._name);
			$cur_key.removeMovieClip();
			delete $cur_key;
			//trace("Removed MovieClip = " + this._mcKeysArray[$i]._name);
		}
		this._mcKeysArray = new Array();
		this._currentKeySet = $index;
		var $current_key_set:Array = this.keysets[$index];
		var $new_key:MovieClip = this.key.duplicateMovieClip("_mcKey0-0", this.getNextHighestDepth());
		var $key_width:Number = $new_key._width;
		var $key_height:Number = $new_key._height;
		//trace("Removing MovieClip " + this["_mcKey0-0"]._name);
		//$new_key.removeMovieClip();
		$new_key.removeMovieClip();
		delete $new_key;
		//trace("Removed MovieClip = " + this["_mcKey0-0"]._name);
		var $hspace:Number = ( this.bg._height-(this.padding*2)-($key_height * $current_key_set.length) )/ ($current_key_set.length - 1);
		
		for (var $i:Number = 0; $i<$current_key_set.length; $i++)
		{
			var $current_row:Array = $current_key_set[$i];
			var $wspace:Number = ( this.bg._width-(this.padding*2)-($key_width * $current_row.length) )/ ($current_row.length - 1);
			for (var $j:Number = 0; $j<$current_row.length; $j++)
			{
				var $xpos:Number = ($j*$wspace) + ($key_width * $j) + this.padding + ($key_width/2) + this.bg._x;
				var $ypos:Number = ($i*$hspace) + ($key_height * $i) + this.padding + ($key_height/2) + this.bg._y;
				var $current_char:String = $current_row[$j];
				var $new_key:MovieClip = this.key.duplicateMovieClip("_mcKey"+$i+"-"+$j, this.getNextHighestDepth());
				this._mcKeysArray.push($new_key);
				if($current_char.indexOf(com.tap4fun.components.ui.VirtualKeyboard.VALUE_KEY_SEPARATOR)!=-1)
				{
					var $splitted_key = $current_char.split(com.tap4fun.components.ui.VirtualKeyboard.VALUE_KEY_SEPARATOR);
					var $value:String = $splitted_key[0];
					var $displayed:String = $splitted_key[1];
					$new_key.setLabel($displayed);
					$new_key.value = $value;
				}
				else
				{
					$new_key.value=$current_char;
					$new_key.setLabel($new_key.value);
				}
				$new_key._x = $xpos;
				$new_key._y = $ypos;
				$new_key.keyboard = this;
				
				$new_key.onPress = function():Void
				{
					this.keyboard.onKeyDown();
					this.onPressAction();
				};
				$new_key.onRelease = function():Void 
				{
					this.keyboard.typeText(this.value);
					this.keyboard.onKeyUp(this);
					this.keyboard.onKeyPressed(this);
					this.onReleaseAction();
				};	
				$new_key.onReleaseOutside = function():Void
				{
					this.keyboard.onKeyUp(this);
					this.onReleaseOutsideAction();
				};
			}
		}
	}
	public function typeText($char:String):Void
	{
		if(this._textTarget!=null)
		{
			if(this._textTarget.html)
			{
				this._typedText += $char;
				this._textTarget.htmlText = this._typedText;
			}
			else
			{
				this._typedText += $char;
				this._textTarget.text = this._typedText;
			}
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getKeySet($index:Number):Array 
	{
		return (this.keysets[$index]);
	};
	public function setKeySet($keyset:Array, $index:Number):Void
	{
		this.keysets[$index] = $keyset;
	};
	public function getCurrentKeySetIndex():Number 
	{
		return this._currentKeySet;
	};
	public function setTextTarget($target:TextField):Void
	{
		this._textTarget = $target;
	};
	public function getKeysMovieClips():Array
	{
		return this._mcKeysArray;
	};
	public function setPadding($padding:Number):Void
	{
		this.padding = $padding;
	};
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onKeyPressed():Void{}
	function onKeyDown():Void{}
	function onKeyUp():Void{}
}