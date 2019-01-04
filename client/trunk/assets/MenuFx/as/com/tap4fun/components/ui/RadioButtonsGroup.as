class com.tap4fun.components.ui.RadioButtonsGroup extends MovieClip
{
	/////////////////////////////////////////////////////////////////////////////
	//				Variables
	/////////////////////////////////////////////////////////////////////////////
	
	/*[Inspectable(defaultValue="",name="Checkbox list")]
	public var checkbox_names_list:Array;
	[Inspectable(defaultValue="",name="Add mc starting with...")]
	public var prefix:String;
	[Inspectable(defaultValue="",name="Value")]
	public var overrideValueName:String;*/
	[Inspectable(defaultValue="")]
	public var varName:String;
	
	private var radiobuttons_mc_list:Array = new Array();
	private var currentValue:MovieClip;
	
	/////////////////////////////////////////////////////////////////////////////
	//				Constructor
	/////////////////////////////////////////////////////////////////////////////
	
	function RadioButtonsGroup()
	{
		if(this.varName=="")this.varName = this._name;
		
		this.onLoad = function():Void
		{
			this.RadioButtonsGroupOnLoad();
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////
	//				Private functions
	/////////////////////////////////////////////////////////////////////////////
	
	private function RadioButtonsGroupOnLoad():Void
	{
		this.findRelatedMovieClips();
		this.applyEventsHandlers();
		/*if(overrideValueName == "")
		{
			this.currentValue.check();
		}
		else
		{
			trace("found this.overrideValueName = "+this.overrideValueName)
			this.byName(this.overrideValueName).check();
		}*/
	}
	 
	private function findRelatedMovieClips():Void
	{
		//trace("Starting findRelatedMovieClips in "+this._name)
		/*var find_mc:Number = 0;
		var found_mc:Number = 0;
		var mc:MovieClip;
		while(find_mc < this.checkbox_names_list.length)
		{
			for(mc in _parent)
			{
				//trace("checking if "+_parent[mc]._name+" is "+this.checkbox_names_list[find_mc]);
				if(_parent[mc]._name == this.checkbox_names_list[find_mc])
				{
					//trace("it IS!");
					this.radiobuttons_mc_list[found_mc] = _parent[mc];
					if(mc.checked)
					{
						this.currentValue = _parent[mc];
					}
					found_mc++;
				}
			}
			if(this.radiobuttons_mc_list[find_mc] == undefined)
			{
				trace("***FLASH : RADIO BUTTON NOT FOUND*** The radioButtonGroup "+this._name+" could not find the radio button "+this.checkbox_names_list[find_mc]+" mentionned in its Checkbox list")
			}
			find_mc++
		}
		if(this.prefix != "")
		{
			this.findRelatedMovieClipsByPrefix();
		}*/
		var $curRadio:com.tap4fun.components.ui.RadioButton;
		var $foundChecked:MovieClip;
		
		this.radiobuttons_mc_list = new Array();
		
		for(var $mc in this)
		{
			if(this[$mc] instanceof com.tap4fun.components.ui.RadioButton)
			{
				$curRadio = this[$mc];
				this.radiobuttons_mc_list.push($curRadio);
				//If checked and a previous one was checked, uncheck previous
				if($foundChecked && $curRadio.getChecked())$foundChecked.uncheck();
				if($curRadio.getChecked())$foundChecked = $curRadio;
			}
		}
		if(!$foundChecked)this.radiobuttons_mc_list[this.radiobuttons_mc_list.length-1].check();
	}
	 
	/*private function findRelatedMovieClipsByPrefix():Void
	{
		var found_mc:Number = this.radiobuttons_mc_list.length;
		var prefixLength:Number = this.prefix.length;
		var i:Number;
		var InsertIt:Boolean;
		var mc:MovieClip;
		for(mc in _parent)
		{
			//trace("checking if "+_parent[mc]._name+" is starting with "+this.prefix);
			if(_parent[mc]._name.substr(0,prefixLength) == this.prefix)
			{
				//trace("it IS!");
				InsertIt = true;
				i = 0
				while((i < this.radiobuttons_mc_list.length) && (InsertIt))
				{
					if(_parent[mc] == this.radiobuttons_mc_list[i])
					{
						 InsertIt = false;
					}
					i++;
				}
				if(InsertIt){
					this.radiobuttons_mc_list[found_mc] = _parent[mc];
					if(mc.checked)
					{
						this.currentValue = _parent[mc];
					}
					found_mc++;
				}
			}
		}
	}*/
	 
	private function applyEventsHandlers():Void
	{
		var i:Number; //counter
		for(i = 0; i < this.radiobuttons_mc_list.length; i++)
		{
			//trace(this.radiobuttons_mc_list[i]._name)
			this.radiobuttons_mc_list[i].onNotifyingCheck = function():Void
			{
				this._parent.applyCheck(this);
			}
		}
	}
	
	private function applyCheck(mc:MovieClip):Void
	{
		//trace("applying check to : "+mc._name) 
		var i:Number = 0;
		mc.setDisabled(true);
		var $previousValue = this.currentValue;
		this.currentValue = mc;
		 
		for(i = 0; i < this.radiobuttons_mc_list.length; i++)
		{
			if(this.radiobuttons_mc_list[i] != mc)
			{
				this.radiobuttons_mc_list[i].setDisabled(false);
				if(this.radiobuttons_mc_list[i].checked)
				{
					this.radiobuttons_mc_list[i].setChecked(false);
				}
			}
		}
		if(this.currentValue != $previousValue)this.onChange(this.getValue());
	}
	
	private function byName(mcName:String):MovieClip
	{
		//trace("received name : "+mcName)
		var i:Number = 0;
		var found:Boolean = false;
		//trace("length of radiobuttons_mc_list array : "+this.radiobuttons_mc_list.length)
		while((i < this.radiobuttons_mc_list.length) && (!found))
		{
			//trace("checking if "+this.radiobuttons_mc_list[i]._name+" is "+mcName)
			if(this.radiobuttons_mc_list[i]._name == mcName)
			{
				found = true;
				//trace("found override value: "+this.radiobuttons_mc_list[i]._name);
				return this.radiobuttons_mc_list[i];
			}
			i++;
		}
	}
	private function byValue($mcValue:String):MovieClip
	{	
		for(var $i:Number=0; $i<this.radiobuttons_mc_list.length; $i++)
		{
			if(this.radiobuttons_mc_list[$i].getValue() == $mcValue)
				return this.radiobuttons_mc_list[$i]
		}
		trace("ERROR! Couldn't find RadioButton with value " + $mcValue + " in RadioButtonsGroup " + this._name);
	}
	 
	/////////////////////////////////////////////////////////////////////////////
	//				Getters and setters
	/////////////////////////////////////////////////////////////////////////////
	
	public function getValue():String
	{
		//return this.currentValue.getValue();
		for(var $i:Number=0; $i<this.radiobuttons_mc_list.length; $i++)
		{
			if(this.radiobuttons_mc_list[$i].getChecked())
				return this.radiobuttons_mc_list[$i].getValue();
		}
	}
	
	public function setValue($value:String):Void
	{
		//this.byName(mcName).check();
		this.byValue($value).check();
	}
	
	public function getValue_mc():MovieClip
	{
		return this.currentValue;
	}
		
	public function setValue_mc(mc:MovieClip)
	{
		mc.check();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onChange($value:String):Void{}
}