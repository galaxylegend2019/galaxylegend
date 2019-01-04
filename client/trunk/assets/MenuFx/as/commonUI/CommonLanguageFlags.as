
UpdateIcon();
// SelectIcon();

function UpdateIcon(){
	if(this.IconData == undefined){
		this.icons.gotoAndStop(1);
	}
	else{
		this.icons.gotoAndStop(this.IconData.flag);
	}
}

// function SelectIcon(is_selected){
// 	if (is_selected == undefined){
// 		is_selected = this.m_selected;
// 	} 
// 	this.icons.gotoAndStop(is_selected ? "selected" : "normal");
// 	this.icons.frame.gotoAndStop("quality_" + m_quality);
// 	this.icons.bg.gotoAndStop("quality_" + m_quality);
// }