var is_march_show:Boolean = false;

_root.onLoad = function(){
	reset();
	//refreash_march_info([undefined,undefined,undefined,undefined])
	//move_in();

	_root.main_ui.event_list.btn_hide_show.onRelease = function(){
		is_march_show == true ? hide_march() : show_march() ;
	}
}

function move_in(){
	_root.main_ui._visible = true;
	_root.main_ui.gotoAndPlay("opening_ani");
}


function move_out(){
	_root.main_ui.OnMoveOutOver = function(){
		reset();
	}
	_root.main_ui.gotoAndPlay("closing_ani");
}

function reset(){
	show_march();
	_root.main_ui.gotoAndStop("opening_ani");
	_root.main_ui._visible = false;
}

function show_march(){
	is_march_show = true;
	_root.main_ui.event_list.gotoAndPlay("opening_ani");
	_root.main_ui.event_list.mc_list.onRelease = function(){
		fscommand('MyMarchMgrCommand','ShowMyMarchDetailUI');
	}
}


function hide_march(){
	is_march_show = false;
	_root.main_ui.event_list.gotoAndPlay("closing_ani");
	_root.main_ui.event_list.mc_list.onRelease = undefined;
}


function refreash_march_info(march_list_data){
	var march_info_plane = _root.main_ui.event_list.mc_list;
	for ( var i = 0 ; i < 4 ; i ++ ){
		march_info_plane["item_" + (i + 1)].march_data = march_list_data[i];
		refresh_march_item_view(march_info_plane["item_" + (i + 1)]);
	}
}

function format_time(sec_number:Number){
	if (sec_number > 0 ){
		var ss = sec_number % 60;
		sec_number = Math.floor(sec_number / 60);
		var mm = sec_number % 60;
		var hh = Math.floor(sec_number / 60);

		var ss_str:String = ss >= 10 ? ss : '0' + ss;
		var mm_str:String = mm >= 10 ? mm : '0' + mm;
		var hh_str:String = hh >= 10 ? hh : '0' + hh;

		return hh_str + ':' + mm_str + ':' + ss_str;
	}
	else{
		return '00:00:00';
	}
}

function refresh_march_item_view(item_view){
	item_view.gotoAndStop('type_' + item_view.march_data.type);

	if (item_view.march_data.march_countdown_sec < 0 ){
		item_view.content_view.des_text.text = item_view.march_data.des_text;
		if ( item_view.content_view.progressbar ) { item_view.content_view.progressbar.gotoAndStop(1); }
	}
	else{
		item_view.content_view.des_text.text = format_time(item_view.march_data.march_countdown_sec);
		var progress_percent = Math.floor((item_view.march_data.march_totle_sec - item_view.march_data.march_countdown_sec) / item_view.march_data.march_totle_sec * 100);
		if ( item_view.content_view.progressbar ) { item_view.content_view.progressbar.gotoAndStop(progress_percent + 1); }
	}
}

function tick_sec(){
	var march_info_plane = _root.main_ui.event_list.mc_list;
	for (var i = 0 ; i < 4 ; i ++){
		var item_view = march_info_plane["item_" + (i + 1)];
		if ( item_view.march_data.march_countdown_sec > 0 ){
			item_view.march_data.march_countdown_sec -- ;
			item_view.content_view.des_text.text = format_time(item_view.march_data.march_countdown_sec);
			var progress_percent = Math.floor((item_view.march_data.march_totle_sec - item_view.march_data.march_countdown_sec) / item_view.march_data.march_totle_sec * 100);
			if ( item_view.content_view.progressbar ) { item_view.content_view.progressbar.gotoAndStop(progress_percent + 1); }
		}
	}
}