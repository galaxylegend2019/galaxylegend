import com.tap4fun.utils.MovieClipsUtils;
import com.tap4fun.StaticFunctions;
/**
 * ...
 * @author zhuyubin
 */
class common.CTextEdit extends MovieClip
{
	private var m_changeHeight : Number = 0;
	private var m_inputType : String = '';
	private var m_sFxName : String = '';
	private var m_hitzone : MovieClip = null;
	private var m_inputzone : MovieClip = null;
	private var m_textHint : MovieClip = null;
	private var m_textField : MovieClip = null;
	private var m_this : MovieClip = null;
	private var m_cleanText : Boolean = true;
	private var m_needShowStarChar : Boolean = false;
	private var m_inputString : String = '';
	private var m_inputHtmlString: String = '';
	private var m_defaultText : String = '';
	private var m_maxLength : Number = 0;
	private var m_keyboardHeight:Number = 0;
	private var m_minNumber : Number = 0;
	private var m_maxNumber : Number = -1;
	private var m_classType : String = '';
	public var m_bEnableInput : Boolean = false;
	private var m_useFor:String = '';
	public var onShowKeyboard:Function = null;
	public var onHideKeyboard:Function = null;
	public var onReturnPressed:Function = null;
	public var beginHideKeyboard:Function = null;
	public var onChangeKeyBoardHeight:Function = null;
	
	private var m_nTextLineMax:Number = 1;
	private var m_nTextLineDis:Number = 2;
	private var m_nOneLineHeight:Number;
	private var m_nTextDefaultPosY:Number;
	//private var m_nRootDefaultPosY:Number;
	public var m_nRootDefaultPosY:Number;
	public var g_enableEmoji:Boolean;
	public var m_TxtNumber:MovieClip = null;
	public function CTextEdit() 
	{
		//_global.IsWin32 = (getVersion().length > 3 && -1 != getVersion().indexOf("WIN"));
		_global.IsWin32 = getVersion() == "GameSwfWIN";
		this.m_this = this;
		this.m_nRootDefaultPosY = this._y;
		
	}
	public function setTextShow(Txt, isEmoji)
	{
		trace("setTextShow txt = " + Txt)
			m_textField.htmlText = Txt;
	}

	/*
	   inputTypes: 
			ASCIICapable
			NumbersAndPunctuation
			URL
			NumberPad
			PhonePad
			NamePhonePad
			EmailAddress
	*/
	public function init(
			inputType : String,
			fxName:String,
			hitzoneName : String,
			textHintName : String,
			textFieldName : String, 
			cleanText : Boolean,
			needshowStarChar : Boolean, 
			defaultText : String,			
			classType : String,			
			useFor:String,
			inputZone : MovieClip,
			_htmlText:String,
			enableEmoji : Boolean)
	{
		m_useFor = useFor;
		if(m_useFor == null)
		  m_useFor = "notused"
		if (m_useFor == ' ')
			m_useFor = "notused"
		this.m_sFxName = fxName;
		if (defaultText == null)
		{
			defaultText = ''
		}
		if (classType == null)
		{
			classType = 'TextField'
		}

		if (enableEmoji == undefined){
			enableEmoji = false;
		}
		g_enableEmoji = enableEmoji;
		g_enableEmoji = false;
		m_inputType = inputType
		m_cleanText = cleanText
		m_needShowStarChar = needshowStarChar
		m_defaultText = defaultText
		m_classType = classType

		m_hitzone = this[hitzoneName];
		m_inputzone = m_hitzone.inputzone
		m_textHint = this[textHintName];
		m_textField = this[textFieldName];

		if ( m_inputzone == null )
		{
			trace("1111")
			m_inputzone = inputZone
		}
		if (m_inputzone == null)
		{
			trace("222")
			m_inputzone = m_hitzone;        
		}
		trace("---------====================m_inputzone._width = ")
		trace(m_inputzone._width)
		setTextShow("HeightCheck", false);
		m_nOneLineHeight = m_textField.textHeight + 2;
		m_nTextDefaultPosY = m_textField._y;
		trace("init in lua2fs _htmlText = " + _htmlText)
		lua2fs_setText(m_defaultText, m_defaultText.length, _htmlText);
	//	if(classType != "TextView")
		{
			/*
			this.m_hitzone.onRelease = function()
			{
				if (_global.IsWin32)
				{
					this.gotoAndPlay("released");
				}
				//fscommand("PlaySfxByType", "sfxTypeSelect");
			}
			*/
			this.m_hitzone.onRelease = function()
			{
				this._parent.onHitZoneRelease();
			}
		}
		m_TxtNumber = this["TxtNum"];
		m_TxtNumber._visible = false;
	}
	
	//public function 

	public function setDefaultText(defaultText)
	{
		m_defaultText = defaultText
		lua2fs_setText(m_defaultText)
	}
	private function ShowTextTitleStr()
	{
		var strLength = getInputString().length;
		if (Number(getInputString().length) > m_maxLength)
		{
			strLength = m_maxLength;
		}
		m_TxtNumber.text = (/**m_maxLength - */Number(strLength)) + "/" + m_maxLength;
	}
	public function setMaxLength(maxLength : Number)
	{
		m_maxLength = maxLength;
		m_TxtNumber._visible = true;
		ShowTextTitleStr();
	}
	
	public function  setTextLineInfo(maxLine:Number, disLine:Number):Void 
	{
		this.m_nTextLineMax = Math.max(1, maxLine);
		this.m_nTextLineDis = Math.max(1, disLine);
	}

	public function setNumberRange(minNum : Number, maxNum : Number)
	{
		if (m_inputType == 'NumberPad') {
			m_minNumber = minNum
			m_maxNumber = maxNum
		}
	}

	private function _onShowKeyboard()
	{
		this.m_bEnableInput = true;
		if (m_cleanText)
		{
			this.lua2fs_setText('');
		}
		else
		{
			this.lua2fs_setText(this.m_inputString, this.m_inputString.length, this.m_inputHtmlString);
		}
		StaticFunctions.TraceLog("_onShowKeyboard: onShowKeyboard = " + this.onShowKeyboard);
		if (this.onShowKeyboard != null)
		{
			onShowKeyboard()
		}
		
	}

	private function _onHideKeyboard()
	{
		this.m_bEnableInput = false;

		if (getInputString().length == 0) {
			lua2fs_setText(m_defaultText)
		}

		if (m_inputType == 'NumberPad' && m_minNumber <= m_maxNumber) {
			var num : Number = Number(getInputString())
			num = Math.max(Math.min(num, m_maxNumber), m_minNumber)
			lua2fs_setText(String(num))
		}

		StaticFunctions.TraceLog("_onHideKeyboard: onHideKeyboard = " + this.onHideKeyboard);
		if (onHideKeyboard != null) onHideKeyboard()

		_root._y = 0;
		//this._y = this.m_nRootDefaultPosY;
		if (this.onChangeKeyBoardHeight)
		{
			this.onChangeKeyBoardHeight();
		}
		m_textField._visible = !this.m_bEnableInput;
	}
	
	public function _onSendMessage():Void
	{
		this["holder"].SendMessage();
	}
	
	public function _onFakeChangeKeyBoardHeight(x:Number, y:Number)
	{
		this._y = this.m_nRootDefaultPosY;
		m_keyboardHeight = Math.ceil(Math.max(0, (1 - y) * Stage.height));
		var hitzoneGPos = MovieClipsUtils.getGlobalPosition(this)
		var editBottom = Math.min(Stage.height, hitzoneGPos.y + this.m_hitzone._height);
		if (editBottom > m_keyboardHeight)
		{
			this._y = this.m_nRootDefaultPosY - Math.min((editBottom - m_keyboardHeight + 2), this.m_nRootDefaultPosY);
			m_changeHeight = this._y - this.m_nRootDefaultPosY;
			trace("_onFakeChangeKeyBoardHeight")
			this._y = this.m_nRootDefaultPosY;
		}
		//fscommand("TextEdit", "hitzoneGPos.x = " + hitzoneGPos.x + " hitzoneGPos.y = " + hitzoneGPos.y + " editBottom = " + editBottom + " m_keyboardHeight = " + m_keyboardHeight + "  this.m_hitzone._height = " + this.m_hitzone._height + "  this.m_nRootDefaultPosY = " + this.m_nRootDefaultPosY + "  this._y = " + this._y);

		var newHitzoneGPos = MovieClipsUtils.getGlobalPosition(m_inputzone)
		var newHeight = newHitzoneGPos.y + m_inputzone._height
		if (newHeight > m_keyboardHeight)
		{
			newHeight = m_keyboardHeight - newHitzoneGPos.y;
		}
		fscommand('FS_TEXTEDIT,changeKeyBoardHeight',
				 newHitzoneGPos.x + '\1' + newHitzoneGPos.y + '\1' + m_inputzone._width + '\1' + Math.min(newHeight, m_inputzone._height))
				 
		if (this.onChangeKeyBoardHeight)
		{
			this.onChangeKeyBoardHeight();
		}
	}
	
	public function _onChangeKeyBoardHeight(x:Number, y:Number)
	{
		trace("_onChangeKeyBoardHeight x = " + x)
		trace("_onChangeKeyBoardHeight y = " + y)
		trace("_onChangeKeyBoardHeight stage height = " + Stage.height)
		var MIN_DIS = 10;

		//this._y = this.m_nRootDefaultPosY;
		m_keyboardHeight = Math.ceil(Math.max(0, (1 - y) * Stage.height));
		var hitzoneGPos = MovieClipsUtils.getGlobalPosition(this.m_hitzone)

		trace("hitzoneGPos x = " + hitzoneGPos.x)
		trace("hitzoneGPos y = " + hitzoneGPos.y)
		trace("this.m_hitzone._height  = " + this.m_hitzone._height)


		var editBottom = hitzoneGPos.y + this.m_hitzone._height + MIN_DIS - _root._y;
		trace("editBottom = " + editBottom)
		trace("m_keyboardHeight = " + m_keyboardHeight)
		var maxMoveOff = hitzoneGPos.y - 1 - _root._y
		trace("_root._y = " + _root._y)
		if (editBottom > m_keyboardHeight)
		{
			trace("key board change editBottom > m_keyboardHeight")
			_root._y =  - Math.min((editBottom - m_keyboardHeight), maxMoveOff);
		}
		else
		{
			trace("_root._y = 0")
			_root._y = 0;
		}
		//fscommand("TextEdit", "hitzoneGPos.x = " + hitzoneGPos.x + " hitzoneGPos.y = " + hitzoneGPos.y + " editBottom = " + editBottom + " m_keyboardHeight = " + m_keyboardHeight + "  this.m_hitzone._height = " + this.m_hitzone._height + "  this.m_nRootDefaultPosY = " + this.m_nRootDefaultPosY + "  this._y = " + this._y);

		var newHitzoneGPos = MovieClipsUtils.getGlobalPosition(m_inputzone)
		var newHeight = newHitzoneGPos.y + m_inputzone._height - MIN_DIS
		if (newHeight > m_keyboardHeight)
		{
			newHeight = m_keyboardHeight - newHitzoneGPos.y;
		}
		trace("m_inputzone._height = " + m_inputzone._height)
		trace("newHitzoneGPos x = " + newHitzoneGPos.x)
		trace("newHitzoneGPos y = " + newHitzoneGPos.y)
		trace("newHeight  = " + newHeight)

		fscommand('FS_TEXTEDIT,changeKeyBoardHeight',
				 newHitzoneGPos.x + '\1' + newHitzoneGPos.y + '\1' + m_inputzone._width + '\1' + Math.min(newHeight, m_inputzone._height))
		
		if (this.onChangeKeyBoardHeight)
		{
			//this.onChangeKeyBoardHeight();
		}
	}
	private var m_prelineNum:Number = 0;
	public function _onChangeInputBoxWidthHeight(lineNumber:Number) {
		if(m_prelineNum == lineNumber)
			return;
			
		m_prelineNum = lineNumber;	
		if (this._currentframe != lineNumber)
		{
			this.gotoAndPlay(lineNumber);
		}
		this._y = this.m_nRootDefaultPosY;
		var hitzoneGPos = MovieClipsUtils.getGlobalPosition(this)
		var editBottom = Math.min(Stage.height, hitzoneGPos.y + this.m_hitzone._height);
		if (editBottom > m_keyboardHeight)
		{
			this._y = this.m_nRootDefaultPosY - Math.min((editBottom - m_keyboardHeight + 2), this.m_nRootDefaultPosY);
		}

		var newHitzoneGPos = MovieClipsUtils.getGlobalPosition(m_inputzone)
		var newHeight = newHitzoneGPos.y + m_inputzone._height
		if (newHeight > m_keyboardHeight)
		{
			newHeight = m_keyboardHeight - newHitzoneGPos.y;
		}
		fscommand('FS_TEXTEDIT,changeKeyBoardHeight',
				 newHitzoneGPos.x + '\1' + newHitzoneGPos.y + '\1' + m_inputzone._width + '\1' + Math.min(newHeight, m_inputzone._height))
		
		if (this.onChangeKeyBoardHeight)
		{
			this.onChangeKeyBoardHeight();
		}
	}
	public function getInputString()
	{
		if (m_needShowStarChar)
		{
			return m_inputString;
		}
		else
		{			
			return m_inputString;
		}
	}
	public function setInputEnable(enable)
	{
		this.m_bEnableInput = enable;
		m_textHint._visible = !this.m_bEnableInput;
	}
	public function lua2fs_noitfyShowKeyboard(show)
	{
		if (show)
			_onShowKeyboard();
		else
			_onHideKeyboard();
	}
    public function lua2fs_setHintShow(showorhide)
	{
		m_textHint._visible = showorhide;
	}
	public function onTextChange():Void {}
	public function lua2fs_setText(_text, textLength, _htmlText)
	{
		//trace(_text);
		//for (var i = 0; i < textLength; ++i )
		//{
			//m_inputString += _text.charAt(i) + "\n";
		//}
		trace("lua2fs_setText _text : " + _text)
		trace("_htmlText init _htmlText : " + _htmlText)
		var hasEmojiChar = false;
		/*if (_htmlText != undefined && _htmlText != "")
		{
			hasEmojiChar = true;
			m_inputString = _text;
			m_inputHtmlString = _htmlText;
		}
		else*/ if (m_inputType == 'NumberPad' && m_minNumber <= m_maxNumber)
		{
			var num : Number = Number(_text);
			num = Math.max(Math.min(num, m_maxNumber), m_minNumber);
			m_inputString = String(num);	
			m_inputHtmlString = _htmlText;		
			_htmlText = String(num);;
		}
		else
		{
			trace("m_inputString = " + m_inputString)
			m_inputString = _text	
			m_inputHtmlString = _htmlText;		
			_htmlText = _text;
			trace("_text111111 = " + _text)
			trace("_htmlText11111 = " + _htmlText)
		}
		trace("lua2fs_setText _text : " + _text)
		if (m_needShowStarChar)
		{   
			var tempString:String = '';
			for(var i = 0; i < textLength; i++)
			{
				tempString += '*' 
			}
			trace("asdfasf _text : " + tempString)
			setTextShow(tempString,  hasEmojiChar);
		}
		else
		{
			trace("_htmlText asdfasdfas_text : " + _htmlText)
			setTextShow(_htmlText, hasEmojiChar);
		}
		trace("lua2fs_setText _text : " + _text)
		trace("_htmlText = " + _htmlText)
		trace("tempString = " + tempString)
		var _txtLenIs0 = false;
		
		if (hasEmojiChar){
			_txtLenIs0 = (0 == m_textField.htmlText.length);
		}else{
			_txtLenIs0 = (0 == m_textField.htmlText.length);
		}

		m_textHint._visible = (_txtLenIs0 && !this.m_bEnableInput);
		m_textField._visible = !this.m_bEnableInput;
		trace("m_bEnableInput :" + m_bEnableInput);
		if(_global.IsWin32)
		{
			m_textField._visible = true;
		}		//if (callBack != null)
		//{
		//	callBack(m_keyboardHeight);
		//}
		
		var lines:Number = Math.floor(m_textField.textHeight / m_nOneLineHeight);
		m_textField._y = m_nTextDefaultPosY - Math.max(0, lines - m_nTextLineDis) * m_nOneLineHeight;
		//fscommand("FS_CHAT,TRACE", "m_nOneLineHeight = " + m_nOneLineHeight + "  textHeight = " + m_textField.textHeight + "  lines = " + lines + "  m_textField._x  _y = " + m_textField._x + " " + m_textField._y);
		
		if (textLength != null && beginHideKeyboard != null)
		{
			beginHideKeyboard(m_inputString);        
		}
		
		trace(m_textField.htmlText);
		ShowTextTitleStr();
		if( this.onTextChange )
        {
            this.onTextChange(m_inputString);
        }
		
	}
	
	public function onHitZoneRelease():Void 
	{
		var initText = m_cleanText ? '' : getInputString()
		var hitzoneGPos = MovieClipsUtils.getGlobalPosition(m_hitzone);
		trace("m_hitzone = " + m_hitzone)

		var inputzoneGPos = MovieClipsUtils.getGlobalPosition(m_inputzone);
		trace("inputzoneGPos = " + inputzoneGPos.x)
		trace("inputzoneGPos = " + inputzoneGPos.y)
		trace("m_inputzone._width = " + m_inputzone._width)
		trace("m_inputzone._height = " + m_inputzone._height)
		fscommand('FS_TEXTEDIT,onRelease', 
				m_inputType + '\1' + m_maxLength + '\1' + this.m_sFxName + '\1' + 
				MovieClipsUtils.getFullPathName(m_this) + '\1' + MovieClipsUtils.getFullPathName(m_textField) + '\1' +
				inputzoneGPos.x + '\1' + inputzoneGPos.y + '\1' + m_inputzone._width + '\1' + m_inputzone._height + '\1' + 
				m_classType + '\1' + m_useFor + '\1' + initText);
				
	}
	public function ShowEditBox():Void
	{
		var initText = m_cleanText ? '' : getInputString()
		var hitzoneGPos = MovieClipsUtils.getGlobalPosition(m_hitzone);
		var inputzoneGPos = MovieClipsUtils.getGlobalPosition(m_inputzone);
		fscommand('FS_TEXTEDIT,ShowEditBox', 
				m_inputType + '\1' + m_maxLength + '\1' + this.m_sFxName + '\1' + 
				MovieClipsUtils.getFullPathName(m_this) + '\1' + MovieClipsUtils.getFullPathName(m_textField) + '\1' +
				inputzoneGPos.x + '\1' + inputzoneGPos.y + '\1' + m_inputzone._width + '\1' + m_inputzone._height + '\1' + 
				m_classType + '\1' + m_useFor + '\1' + initText);
	}
	public function GetHeightChange():Number 
	{
		var heightChange =  Math.max(Math.abs(m_changeHeight), Math.abs(this._y - this.m_nRootDefaultPosY));
		m_changeHeight = 0;
		
		return Math.abs(heightChange);
	}
	public function SetKeyBoardText(str:String) : Void
	{
		m_inputString = str;
	}
}