/*								CheckBox
**
** my_cb = com.tap4fun.components.ui.CheckBox.construct(mc_cb, bChecked);
** Le MovieClip doit comporter:
**	-Un MovieClip nommé box et ayant comme frame labels: "out", "over", "press", "release"
**	-Un MovieClip nommé checkmark ayant comme frame labels: "check", "uncheck"
**
*********Properties****************************Description******
**checked:Boolean		//Retourne true si le checkbox est coché, false sinon
*********Methods****************************Description*******
**check():Void			//Coche le checkbox
**uncheck():Void		//Décoche le checkbox
**toggle():Void			//Coche si décoché et vice versa
*********Events*****************************Description*******
**onChange()
**onCheck()
**onUncheck()
**onToggle()			//Lorsque l'état du checkbox change

*********TODO*************************************************
**varName
*/
[IconFile("icons/CheckBox.png")]
class com.tap4fun.components.ui.CheckBox extends com.tap4fun.components.ui.ButtonLabeled
{
	static var symbolName:String = "CheckBox";
	static var symbolOwner:Object = CheckBox;
	var className:String = "CheckBox";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=false)]
	public var checked:Boolean;
	[Inspectable(defaultValue="")]
	public var varName:String;
	
	private var box:MovieClip;
	private var checkmark:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function CheckBox()
	{
		if(this.varName=="")this.varName=this._name;
		
		this.setChecked(this.checked);
		this.box.gotoAndStop("out");
		/*this.checkmark.stop();
		this.checked = false;*/
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function check():Void
	{
		var $previousValue = this.checked;
		this.checked = true;
		this.checkmark.gotoAndStop("check");
		this.onCheck();
		if(this.checked != $previousValue)
		{
			this.onChange(this.getValue());
		}
	}
	public function uncheck():Void
	{
		var $previousValue = this.checked;
		this.checked = false;
		this.checkmark.gotoAndStop("uncheck");
		this.onUncheck();
		if(this.checked != $previousValue)
		{
			this.onChange(this.getValue());
		}
	}
	public function toggleCheck():Void
	{
		if(this.checked)this.uncheck();
		else this.check();
		this.onToggle();
	}
	
	public function onRollOverAction():Void
	{
		if(!this.disabled)
		{
			this.box.gotoAndStop("over");
		}
		super.onRollOverAction();
	}
	public function onRollOutAction():Void
	{
		if(!this.disabled)
		{
			this.box.gotoAndStop("out");
		}
		super.onRollOutAction();
	}
	public function onPressAction():Void
	{
		if(!this.disabled)
		{
			this.box.gotoAndStop("press");
		}
		super.onPressAction();
	}
	public function onReleaseAction():Void
	{
		if(!this.disabled)
		{
			this.box.gotoAndStop("release");
			this.toggleCheck();
		}
		super.onReleaseAction();
	}
	public function onReleaseOutsideAction():Void
	{
		if(!this.disabled)
		{
			this.box.gotoAndStop("out");
		}
		super.onReleaseOutsideAction();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getChecked():Boolean
	{
		return this.checked;
	}
	public function setChecked($checked:Boolean):Void
	{
		if($checked) this.check();
		else this.uncheck();
	}
	public function getValue():Boolean
	{
		return this.checked;
	}
	public function setValue($checked:Boolean):Void
	{
		if($checked) this.check();
		else this.uncheck();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onChange():Void{}
	public function onCheck():Void{}
	public function onUncheck():Void{}
	public function onToggle():Void{}
}