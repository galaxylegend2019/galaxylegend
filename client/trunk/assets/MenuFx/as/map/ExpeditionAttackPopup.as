var m_TaskInfo = undefined;

this.onLoad = function(){
	init();
	//move_in();
}

function init(){

	_root.info.OnMoveOutOver = function(){
		this._visible = false;
		_root.btn_bg._visible = false;
		if(_root.onMovedOut != undefined){
			_root.onMovedOut();
		}
	}
	

	_root.info.tab_bottom.btn_attack.onRelease = function(){
		move_out();
		fscommand("ExpeditionCmd","AttackCurTask");
	}


	_root.btn_bg.onRelease = function(){
		move_out();
	}

	reset();
}

function reset(){
	_root.btn_bg._visible = false;
	_root.info.gotoAndStop(1);
	_root.info._visible = false;
}

function setTaskInfo(task_info){
	m_TaskInfo = task_info
}

function refresh_TaskInfo(){
	_root.info.desc_title.combat_text.text = m_TaskInfo.Combat_value;
	_root.info.tab_bottom.level_text.text = m_TaskInfo.level_desc;
	_root.info.tab_bottom.Enemy_name.text = m_TaskInfo.Enemy_name;
	_root.info.tab_bottom.Union_text.text = m_TaskInfo.Union_name;

	var head_view = _root.info.tab_bottom.headIcon;
	if (head_view.hero_icons.icons == undefined){
		head_view.hero_icons.loadMovie("CommonPlayerIcons.swf");
	}
	head_view.hero_icons.IconData = m_TaskInfo.head_data;
	if(head_view.hero_icons.UpdateIcon) { head_view.hero_icons.UpdateIcon(); }

	var hero_plane = _root.info.tab_bottom.hero_view;
	for(var i = 1; i <= 6 ; ++i){
		var hero_item = hero_plane["item" + i];
		var heroItem_data = m_TaskInfo.heroData_list[i - 1];
		if (hero_item.icon_info.icon_info.icons == undefined){
			hero_item.icon_info.icon_info.loadMovie("CommonHeros.swf");
		}

		if(heroItem_data == undefined){
			hero_item.blood.gotoAndStop(1);
			hero_item.shield.gotoAndStop(1);
			hero_item.star_plane._visible = false;
			hero_item.icon_info.icon_info.IconData = undefined;
		}
		else{
			var hp_frame = Math.floor(heroItem_data.hp_percent / 20) + 1;
			var shield =  Math.floor(heroItem_data.sheild_percent / 20) + 1;
			hero_item.blood.gotoAndStop(hp_frame);
			hero_item.shield.gotoAndStop(shield);
			hero_item.star_plane._visible = true;
			hero_item.star_plane.star.gotoAndStop(heroItem_data.star);
			hero_item.icon_info.gotoAndStop( heroItem_data.hp_percent == 0 ? "gray" : "normal");
			hero_item.icon_info.icon_info.IconData = heroItem_data.icon_data;
		}
		if(hero_item.icon_info.icon_info.UpdateIcon) { hero_item.icon_info.icon_info.UpdateIcon(); }
	}
}


function move_in(){
	refresh_TaskInfo();
	_root.btn_bg._visible = true;
	_root.info.gotoAndPlay("opening_ani");
	_root.info._visible = true;
}


function move_out(){
	if (_root.info._visible ){
		_root.info.gotoAndPlay("closing_ani");
	}
}