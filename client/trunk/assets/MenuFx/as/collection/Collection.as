
var m_IsOreMovedIn = false;
var m_IsFromHome = false;

var m_UIState:Number;
var UI_STATE_MINING:Number = 1;
var UI_STATE_PLUNDER:Number = 2;

this.onLoad = function(){
	init();
	//move_in_to_collection_main();
	//ore_refresh_test();
	//move_in_to_plunder_main();
}

function init(){
	reset();
}

function reset(){
	_root.collection_main_ui.gotoAndStop("opening_ani");
	_root.collection_main_ui._visible = false;
	_root.pluner_main_ui.gotoAndStop("opening_ani");
	_root.pluner_main_ui._visible = false;
	_root.ore_info.gotoAndStop("opening_ani");
	_root.ore_info._visible = false;
	_root.topInfo.gotoAndStop("opening_ani");
	_root.topInfo._visible = false;
	_root.plunder_area_sign._visible = false;
}

function move_in_to_collection_main(IsFromHome:Boolean){
	m_UIState = UI_STATE_MINING;
	m_IsFromHome = IsFromHome;
	_root.collection_main_ui._visible = true;
	_root.collection_main_ui.gotoAndPlay("opening_ani");
	_root.topInfo._visible = true;
	_root.topInfo.gotoAndPlay("opening_ani");

	_root.collection_main_ui.plunder_btn.btn_text.text = "Plunder";
	_root.collection_main_ui.plunder_btn.btn_icon.gotoAndStop("plunder");
	_root.collection_main_ui.plunder_btn.onRelease = function(){
		_root.OnMoveOutOver = function(){
			fscommand("GoToNext","Plunder");
		}
	}

	_root.collection_main_ui.history_btn.btn_text.text = "History";
	_root.collection_main_ui.history_btn.btn_icon.gotoAndStop("history");
	_root.collection_main_ui.history_btn.onRelease = function(){
		_root.OnMoveOutOver = function(){
			fscommand("GoToNext","History");
		}
		move_out();
	}

	_root.collection_main_ui.btn_exit.onRelease = function(){
		_root.OnMoveOutOver = function(){
			fscommand("ExitBack");
		}
		move_out();
	}
}


_root.ore_info.onMoveInOver = function(){
	m_IsOreMovedIn = true;
}


function hero_info_move_in(){
	_root.ore_info._visible = true;
	_root.ore_info.gotoAndPlay("opening_ani");
}

function hero_info_move_out(){
	m_IsOreMovedIn = false;
	_root.ore_info.gotoAndPlay("closing_ani");
}


function move_out(){
	switch(m_UIState){
	case UI_STATE_MINING:
		hero_info_move_out();
		break;
	case UI_STATE_PLUNDER:
		clear_plunder_sign_list();
		break;
	}
	_root.collection_main_ui.gotoAndPlay("closing_ani");
	_root.collection_main_ui.OnMoveOutOver = function(){
		reset();
		if(_root.OnMoveOutOver) _root.OnMoveOutOver();
	}
}

//ore test data
function create_ore_test_data(){
	var test_hero_id_list = ["Clotho","Apollo","Crius","Prometheus","takezo","Avatar","Hero","Medic"];
	var test_ore_type = ["MiningEngry","MiningGas","MiningEngry","MiningGas","MiningEngry","MiningGas"];
	var OreListInfo:Array = new Array();
	for(var i = 0; i < 6 ; i++){
		var ore_area_item = new Object();
		ore_area_item.heros = new Array();
		ore_area_item.ore_type = test_ore_type[i];
		for(var j = (i == 0 ? 1 : 0); j < 6; j++){
			var hero_item = new Object();
			hero_item.hero_id = test_hero_id_list[j];
			hero_item.hero_name =  test_hero_id_list[j];
			hero_item.star = j < 3 ? 3 : 4;
			hero_item.level = j < 3 ? 30 : 40
			ore_area_item.heros.push(hero_item);
		}
		OreListInfo.push(ore_area_item);
	}
	return OreListInfo;
}

function ore_refresh_test(){
	ore_list = create_ore_test_data();
	ore_list_index = 0;
	fscommand("GoToNext",ore_list[ore_list_index].ore_type)
	//ore_move_in();
}
//test


var ore_list = undefined;
var ore_list_index = 0;
function ore_refresh(OreListInfo:Array){
	ore_list = OreListInfo;
	ore_list_index = 0;
	_root.tab_ore._visible = true;
	fscommand("GoToNext",ore_list[ore_list_index].ore_type)
	//ore_move_in();

}

var press_x = 0;
_root.onStagePress = function(){
	if(!m_IsOreMovedIn) return false;
	press_x =  _root._xmouse;
	return false;
}

_root.onStageRelease = function(){
	if(!m_IsOreMovedIn) return false;
	if(_root._xmouse - press_x < - Stage.width * 0.4){
		ore_area_previous();
	}
	else if(_root._xmouse - press_x > Stage.width * 0.4){
		ore_area_next();
	}
	return false;
}

function ore_area_next(){
	if(ore_list_index < ore_list.length - 1){
		_root.ore_info.onMoveOutOver = function(){
			ore_list_index ++;
			fscommand("GoToNext",ore_list[ore_list_index].ore_type)
			//ore_move_in();
		}
		ore_move_out();
	}
}


function ore_area_previous(){
	if(ore_list_index > 0){
		_root.ore_info.onMoveOutOver = function(){
			ore_list_index --;
			fscommand("GoToNext",ore_list[ore_list_index].ore_type)
			//ore_move_in();
		}
		ore_move_out();
	}else{
		if(m_IsFromHome){
			_root.OnMoveOutOver = function(){
				fscommand("ExitBack");
			}
			move_out();
		}
		else{
			_root.OnMoveOutOver = function(){
				fscommand("GoToNext","CollectionSearch");
			}
			move_out();
		}
	}
	
}


function ore_move_in(){
	for(var page_index = 0;page_index < 6;page_index++){
		_root.ore_info.page_view["page_" + page_index].gotoAndStop(page_index == ore_list_index ? "activited" : "normal");
	}

	var hero_plane = _root.ore_info.hero_plane;
	for(var i = 0; i < 6 ; i++){
		var hero_item = ore_list[ore_list_index].heros[i];
		var hero_view_item = hero_plane["hero_info_" + (i + 1)];
		if (hero_item == undefined){
			hero_view_item.level_info._visible = false;
			hero_view_item.star_plane._visible = false;
			hero_view_item.headIcon.gotoAndStop("hero_empty");
		}
		else{
			hero_view_item.level_info._visible = true;
			hero_view_item.level_info.level_text.text = hero_item.level;
			hero_view_item.star_plane._visible = true;
			for(var star_index = 1 ; star_index <= 5 ; star_index ++){
				hero_view_item.star_plane["star_" + star_index].gotoAndStop( star_index <= hero_item.star ? "normal" : "idle" );
			}
			hero_view_item.headIcon.gotoAndStop("hero_activited");
			if(hero_view_item.headIcon.hero_icon.icons == undefined){
				hero_view_item.headIcon.hero_icon.loadMovie("CommonHeros.swf");
			}
			hero_view_item.headIcon.hero_icon.icons.gotoAndStop("hero_" + hero_item.hero_id);
		}
	}
	hero_info_move_in();

}

function ore_move_out(){
	hero_info_move_out();
}



//plunder

function move_in_to_plunder_main(){
	m_UIState = UI_STATE_PLUNDER;
	_root.collection_main_ui._visible = true;
	_root.collection_main_ui.gotoAndPlay("opening_ani");

	_root.collection_main_ui.plunder_btn.btn_text.text = "Refresh";
	_root.collection_main_ui.plunder_btn.btn_icon.gotoAndStop("refresh");
	_root.collection_main_ui.plunder_btn.onRelease = function(){
		_root.AllPlunderSignMoveOutOver = function(){
		 	_root.AllPlunderSignMoveOutOver = undefined;
		 	plunder_refresh();
		}
		clear_plunder_sign_list();
	}

	_root.collection_main_ui.history_btn.btn_text.text = "History";
	_root.collection_main_ui.history_btn.btn_icon.gotoAndStop("history");
	_root.collection_main_ui.history_btn.onRelease = function(){
		_root.OnMoveOutOver = function(){
			fscommand("GoToNext","History");
		}
		move_out();
	}

	_root.collection_main_ui.btn_exit.onRelease = function(){
		_root.OnMoveOutOver = function(){
			fscommand("ExitBack");
		}
		move_out();
	}

	_root.plunder_area_sign._visible = true;
	plunder_refresh();
}

var m_plunder_sign_list:Array = new Array();
function plunder_refresh(){
	fscommand("SendEmptyMsgToUnity","PlunderRaderSearch")
}


function add_plunder_target(X:Number,Y:Number){
	var new_mov =  _root.plunder_area_sign.attachMovie("item_plunder_coord","plunder_sign_" + m_plunder_sign_list.length, _root.plunder_area_sign.getNextHighestDepth());
	new_mov._x = X;
	new_mov._y = Y;

	new_mov.onRelease = function(){
		open_plunder_info(this._x, this._y);
	}

	new_mov.gotoAndPlay("opening_ani");
	m_plunder_sign_list.push(new_mov);
}

function clear_plunder_sign_list(){
	if(m_plunder_sign_list.length == 0){
		if ( _root.AllPlunderSignMoveOutOver ) _root.AllPlunderSignMoveOutOver();
		return;
	}
	while(m_plunder_sign_list.length > 0){
		var mov = m_plunder_sign_list.pop();
		if(m_plunder_sign_list.length == 0){
			mov.OnMoveOutOver = function(){
				this.removeMovieClip();
				if ( _root.AllPlunderSignMoveOutOver ) _root.AllPlunderSignMoveOutOver();
			}
		}
		else{
			mov.OnMoveOutOver = function(){
				this.removeMovieClip();
			}
		}
		mov.gotoAndPlay("closing_ani");
	}
	if(cur_plunder_info != undefined){
		cur_plunder_info.OnMoveOutOver = function(){
			this.OnMoveOutOver = undefined;
			this.removeMovieClip();
			this = undefined;
		}
		cur_plunder_info.gotoAndPlay("closing_ani");
	}
}


var cur_plunder_info = undefined;
var cur_plunder_sign_x:Number = 0;
var cur_plunder_sign_y:Number = 0;
function open_plunder_info(X:Number , Y:Number){
	cur_plunder_sign_x = X;
	cur_plunder_sign_y = Y;
	if(cur_plunder_info != undefined){
		cur_plunder_info.OnMoveOutOver = function(){
			this.OnMoveOutOver = undefined;
			this.removeMovieClip();
			this = undefined;
			real_open_plunder_info();
		}
		cur_plunder_info.gotoAndPlay("closing_ani");
	}
	else{
		real_open_plunder_info();
	}
}

function real_open_plunder_info(){
	var x_sign = cur_plunder_sign_x < (Stage.width / 2) ? "1" : "2";
	var y_sign = cur_plunder_sign_y < (Stage.height / 2) ? "2" : "1";
	var move_id = "item_plunder_content" + x_sign + y_sign;
	var new_mov =  _root.plunder_area_sign.attachMovie(move_id,"plunder_info_plane", _root.plunder_area_sign.getNextHighestDepth());
	new_mov._x = cur_plunder_sign_x;
	new_mov._y = cur_plunder_sign_y;
	
	new_mov.btn_do_plunder.onRelease = function(){
		_root.OnMoveOutOver = function(){
			fscommand("GoToNext","DoPlunder");
		}
		move_out();
	}

	//hero 
	var hero_plane = new_mov.hero_plane;
	for(var i = 1; i <=6 ; i++){
		var hero_item = hero_plane[""].heros[i];
		var hero_view_item = hero_plane["hero_item_" + i];
		if (i == 6){
			hero_view_item.level_info._visible = false;
			hero_view_item.star_plane._visible = false;
			hero_view_item.headIcon.gotoAndStop("hero_empty");
		}
		else{
			hero_view_item.level_info._visible = true;
			hero_view_item.level_info.level_text.text = 20 + i;
			hero_view_item.star_plane._visible = true;
			for(var star_index = 1 ; star_index <= 5 ; star_index ++){
				hero_view_item.star_plane["star_" + star_index].gotoAndStop( star_index <= i ? "normal" : "idle" );
			}
			hero_view_item.headIcon.gotoAndStop("hero_activited");
			if(hero_view_item.headIcon.hero_icon.icons == undefined){
				hero_view_item.headIcon.hero_icon.loadMovie("CommonHeros.swf");
			}
			hero_view_item.headIcon.hero_icon.icons.gotoAndStop(i);
		}
	}
	//end
	cur_plunder_info = new_mov;
	new_mov.gotoAndPlay("opening_ani");
}