UpdateIcon();

function UpdateIcon(){
	if(this.IconData == undefined){
		this.icons.hero_icons.gotoAndStop(1);
	}
	else{
		this.icons.gotoAndStop(this.IconData.icon_index);
	}
}
