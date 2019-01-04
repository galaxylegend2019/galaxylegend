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
**
*/
[IconFile("icons/CheckBox.png")]
class com.tap4fun.components.ui.RadioButton extends com.tap4fun.components.ui.CheckBox
{
	static var symbolName:String = "RadioButton";
	static var symbolOwner:Object = RadioButton;
	var className:String = "RadioButton";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=false)]
	public var checked:Boolean;
	[Inspectable(defaultValue="")]
	public var value:String;
	
	private var varName:Boolean;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function RadioButton()
	{
		if(this.value=="")this.value = this._name;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function check():Void
	{
		super.check();
		this.onNotifyingCheck();
	}
	public function uncheck():Void
	{
		super.uncheck();
		this.onNotifyingUncheck();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getValue():String
	{
		return (this.checked)?this.value:null;
	}
	public function setValue($value:String):Void
	{
		this.value = $value;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Don't use those events, they're handled by RadioButtonsGroup, use onCheck and onUncheck instead
	public function onNotifyingCheck():Void{}
	public function onNotifyingUncheck():Void{}
}