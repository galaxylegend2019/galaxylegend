var m_quality = 'empty';

UpdateIcon();
SelectIcon();

function UpdateIcon(){
	if(this.m_OnlyIcon == undefined){
		m_OnlyIcon = false;
	}
	if(this.IconData == undefined){
		this.icons.gotoAndStop("normal");
		this.icons.icons.gotoAndStop("empty");
		if(this.m_OnlyIcon){
			this.icons.frame._visible = false;
			this.icons.bg._visible = false;
		}
		else{
			this.icons.frame._visible = true;
			this.icons.bg._visible = true;
			this.icons.frame.gotoAndStop("quality_empty");
			this.icons.bg.gotoAndStop("quality_empty");
		}
	}
	else{
		m_quality = this.IconData.icon_quality;
		this.icons.gotoAndStop("normal");
		this.icons.icons.gotoAndStop("empty");
		this.icons.icons.gotoAndStop(this.IconData.icon_index);
		//trace(this.IconData.icon_index);
		if(this.m_OnlyIcon){
			this.icons.frame._visible = false;
			this.icons.bg._visible = false;
		}
		else{
			this.icons.frame._visible = true;
			this.icons.bg._visible = true;
			this.icons.frame.gotoAndStop("quality_" + m_quality);
			this.icons.bg.gotoAndStop("quality_" + m_quality);
		}
	}
}

function SelectIcon(is_selected){
	if (is_selected == undefined){
		is_selected = this.m_selected;
	} 
	this.icons.gotoAndStop(is_selected ? "selected" : "normal");
	this.icons.frame.gotoAndStop("quality_" + m_quality);
	this.icons.bg.gotoAndStop("quality_" + m_quality);
}