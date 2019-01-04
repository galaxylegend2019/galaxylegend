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
import com.tap4fun.components.elements.TextWithStyle;
import com.tap4fun.components.Events;

[IconFile("icons/Button.png")]
dynamic class com.tap4fun.components.ui.ButtonLabeled extends com.tap4fun.components.ui.SimpleButton
{
	static var symbolName:String = "ButtonLabeled";
	static var symbolOwner:Object = ButtonLabeled;
	var className:String = "ButtonLabeled";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue="Label")]
	public var label:String;
	[Inspectable(defaultValue="")]
	public var labelID:String;
	[Inspectable(name="Icon frame label",defaultValue="")]
	public var iconFrameLabel:String;
	
	
	private var mc_label:MovieClip;
	private var mc_icon:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ButtonLabeled()
	{
		//Set icon
		if(this.mc_icon)
		{
			if(this.iconFrameLabel != "")
			{
				this.setIconFrameLabel(this.iconFrameLabel);
			}
			else
			{
				this.mc_icon.gotoAndStop("no_icon");
				//if there's no frame labeled "no_icon", at least, stop...
				this.mc_icon.stop();
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function buttonOnLoad():Void
	{
		//Set Label
		this.setLabelID(this.labelID);
		
		if (this.mc_label instanceof TextWithStyle)
		{
			this.mc_label.stringID = this.labelID;
			this.mc_label.refreshText();
		}
		else if(this.getLabelID() != undefined && this.getLabelID() != "" && this.getLabelID() != null && _global.$version=="gameSWF")
		{
			this.setLabel(_global.getString(this.getLabelID()));
		}
		else
		{
			this.setLabel(this.label);
		}
		this.defaultOnLoad();
	}
	
	public function refreshText():Void
	{
		if (this.mc_label instanceof TextWithStyle)
		{
			this.mc_label.refreshText();
		}
		else if(this.getLabelID() != undefined && this.getLabelID() != "" && this.getLabelID() != null)
		{
			this.setLabel(_global.getString(this.getLabelID()));
		}
	}
	
	//Events Actions
	public function onChangeLanguage($lang:String):Void
	{
		this.refreshText();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setLabel($label):Void
	{
		this.label = $label;
		if(this.mc_label instanceof com.tap4fun.components.elements.Text)
		{
			this.mc_label.text = $label;
			this.mc_label.refreshText();
		}
		else if (this.mc_label instanceof TextWithStyle)
		{
			this.mc_label.text = $label;
		}
		else this.mc_label.txt_label.htmlText = $label;
	}
	public function getLabel():Object
	{
		return this.label;
	}
	public function setLabelID($id):Void
	{
		this.labelID = $id;
		
		if (this.mc_label instanceof TextWithStyle)
		{
			this.mc_label.stringID = this.labelID;
		}
	}
	public function getLabelID():Object
	{
		return this.labelID;
	}
	public function setIconFrameLabel($lbl:String):Void
	{
		this.iconFrameLabel = $lbl;
		if(!this.mc_icon) trace("Error: No movie clip with id \"mc_icon\" found in "+this);
		if($lbl=="" || $lbl==undefined || $lbl == null) 
		{
			this.mc_icon.gotoAndStop("no_label");
			this.mc_icon.stop();
		}
		else
		{
			this.mc_icon.gotoAndStop(this.iconFrameLabel);
		}
	}
	public function getIconFrameLabel():String
	{
		return this.iconFrameLabel;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function onOver():Void{}
	function onOut():Void{}
	function onUp():Void{}
	function onDown():Void{}
	function onFocusIn():Void{}
	function onFocusOut():Void{}
	function onUpOutside():Void{}
	function onClicked():Void{}
	function onLeave():Void{}
	function onDisabled():Void{}
	function onActivated():Void{}
}