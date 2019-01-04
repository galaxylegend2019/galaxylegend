
class common.CTextAutoSizeTool
{
	static private var isDebug:Boolean = false;

	// content 必需是不包含</font>标签的纯文本
	// maxTextHeight参数可以不传或null,这时自动从元件上取文本框最大高度
	static public function SetMultiLineText(textMC:MovieClip, content:String, maxFontSize:Number, minFontSize:Number, maxTextHeight:Number)
	{
		var mc_y = textMC._y;
		// 入参判断
		if(null == textMC || null == content)
		{
			if(isDebug)
			{
				trace("TextAutoSize textMC or content is null.");
			}
			
			return;
		}

		if(HasFontLabel(content))
		{ // 如果文本内容已含有</font>标签，则不做自动放缩处理
			if(isDebug)
			{
				trace("TextAutoSize content HasFontLabel.");
			}
			textMC.htmlText = content;
			return;
		}
		else
		{
			if(null == maxTextHeight)
			{
				maxTextHeight = textMC._height;
			}

			for(var fontSize = maxFontSize; fontSize >= minFontSize; fontSize--)
			{
				textMC.htmlText  = "<font size='" + String(fontSize) + "' >" + content + "</font>";

				if(textMC.textHeight <= maxTextHeight)
				{
					if(isDebug)
					{
						trace("TextAutoSize fontSize : " + String(fontSize));
					}
					//mc_y = mc_y + maxFontSize - fontSize;
					break;
				}
			}
		}
		textMC._y = mc_y;
	}

	// content 必需是不包含<font>标签的纯文本
	// maxTextWidth参数可以不传或null,这时自动从元件上取文本框最大宽度
	static public function SetSingleLineText(textMC:MovieClip, content:String, maxFontSize:Number, minFontSize:Number, maxTextWidth:Number)
	{
		var mc_y = textMC._y;
		// 入参判断
		if(null == textMC || null == content)
		{
			if(isDebug)
			{
				trace("TextAutoSize textMC or content is null.");
			}
			return;
		}

		if(HasFontLabel(content))
		{ // 如果文本内容已含有</font>标签，则不做自动放缩处理
			if(isDebug)
			{
				trace("TextAutoSize content HasFontLabel.");
			}
			textMC.htmlText = content;
			return;
		}
		else
		{
			if(null == maxTextWidth)
			{
				maxTextWidth = textMC._width;
			}

			for(var fontSize = maxFontSize; fontSize >= minFontSize; fontSize--)
			{
				textMC.htmlText  = "<font size='" + String(fontSize) + "' >" + content + "</font>";

				if(textMC.textWidth <= maxTextWidth)
				{
					if(isDebug)
					{
						trace("TextAutoSize fontSize : " + String(fontSize));
					}
					//mc_y = mc_y + maxFontSize - fontSize;
					break;
				}
			}
		}
		textMC._y = mc_y;		
	}

	// 判断字符串中是否含有</font>标签
	static public function HasFontLabel(str:String):Boolean
	{
		if(null == str)
		{
			return false;
		}

		var strArray = str.split("</font>");
		if(strArray.length >= 2)
		{
			return true;
		}

		return false;
	}
}
