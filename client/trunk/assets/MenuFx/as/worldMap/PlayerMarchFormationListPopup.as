var m_march_datas = new Array();
var g_listInited = false;


_root.onLoad=function()
{
	reset();
	//refreash_march_info([[],[],[]])
	//move_in();
}

_root.main_ui.btn_close.onRelease = function(){
	move_out();		
}

function reset(){
	_root.main_ui.gotoAndStop("opening_ani");
	_root.main_ui.btn_list.onRelease = function(){
		fscommand("MyMarchMgrCommand","ShowMyMarchDetailUI");
	}
}


function move_in(){
	_root.main_ui.gotoAndPlay("opening_ani");
	_root.main_ui.onMovedIn = function(){
		_root.main_ui.btn_list.onRelease = function(){
			move_out();
		}
	}
}

function move_out(){
	_root.main_ui.gotoAndPlay("closing_ani");
	_root.main_ui.OnMoveOutOver = function(){
		reset();
		fscommand("MyMarchMgrCommand","OnMyMarchDetailUIClosed");
	}
}


var march_frame_mc = undefined;
var showed_march_mc = undefined;
var next_show_march_mc = undefined;
function ShowMarchHeros(march_mc){
	if (showed_march_mc != undefined){
		next_show_march_mc = march_mc;
		HideMarchHeros(showed_march_mc,function(){
			ShowMarchHeros(next_show_march_mc);
		});
	}
	else{
		march_frame_mc.gotoAndPlay("open_" + march_mc.march_data.march_index)
		march_mc.board.gotoAndPlay("opening_ani");
		showed_march_mc = march_mc;
	}
}

function HideMarchHeros(march_mc,cb){
	march_frame_mc.gotoAndPlay("close_" + march_mc.march_data.march_index)
	march_mc.board.gotoAndPlay("closing_ani");
	showed_march_mc = undefined;
	if(cb){
		march_frame_mc.OnMoveOutOver = cb;
	}
	else{
		march_frame_mc.OnMoveOutOver = function(){
			this.stop();
		}
	}
}

function ControlMarchHeroShow(march_mc){
	if(showed_march_mc == march_mc){
		HideMarchHeros(march_mc,undefined);
	}
	else{
		ShowMarchHeros(march_mc);
	}
}

function RefreashFormations(){
	march_frame_mc = undefined;
	showed_march_mc = undefined;
	next_show_march_mc = undefined;
	var FormationsView = _root.main_ui.board.location_list;
	if(not g_listInited)
	{
		g_listInited = true;
		FormationsView.clearListBox();
		FormationsView.initListBox("march_board_all_anim",0,true,true);
		FormationsView.enableDrag( true );
		FormationsView.onEnterFrame = function(){
			this.OnUpdate();
		}

		FormationsView.onItemEnter = function(mc,index_item){
			march_frame_mc = mc;
			for(var i = 1; i <= 5 ;i ++){
				var march_mc = mc["board_" + i];
				march_mc.march_data = m_march_datas[i - 1];
				march_mc.march_data.march_index = i;
				refreash_march_item_view(march_mc);
			}
		}

		FormationsView.addListItem(1, false, false);
	}
	else
	{
		var mc = FormationsView.getMcByItemKey(1);
		if(mc)
		{
			march_frame_mc = mc;
			for(var i = 1; i <= 5 ;i ++){
				var march_mc = mc["board_" + i];
				march_mc.march_data = m_march_datas[i - 1];
				march_mc.march_data.march_index = i;
				refreash_march_item_view(march_mc);
			}
		}
	}
}

function refreash_march_item_view(mc){
	if (mc.march_data == undefined){
		mc.gotoAndStop("type_lock");
	}
	else{
		mc.gotoAndStop('type_' + mc.march_data.type);
	}

	if(mc.board.index_plane){
		mc.board.index_plane.index_value.gotoAndStop(mc.march_data.march_index + 1);
	}

	if ( mc.march_data.march_countdown_sec >= 0 ){
		mc.board.countdown_text.text = format_time( mc.march_data.march_countdown_sec )
		var progress_percent = mc.march_data.march_totle_sec == 0 ? 0 : Math.floor((mc.march_data.march_totle_sec - mc.march_data.march_countdown_sec) / mc.march_data.march_totle_sec * 100);
		mc.board.progressbar.gotoAndStop(progress_percent + 1);
	}

	var m_btn_return = mc.btn_return;
	var m_btn_location = mc.btn_location;
	if ( mc.march_data.type == 'march'){
		if (mc.march_data.is_can_ReCall){
			mc.btn_location._visible = true;
			mc.btn_return._visible = true;
			mc.btn_mid_location._visible = false;
			m_btn_return = mc.btn_return;
			m_btn_location = mc.btn_location;
		}
		else{
			mc.btn_location._visible = false;
			mc.btn_return._visible = false;
			mc.btn_mid_location._visible = true;
			m_btn_return = undefined;
			m_btn_location = mc.btn_mid_location;
		}
	}
	else if(mc.march_data.type == 'lock')
	{
		mc.board.txt_unlockLevel.text = mc.march_data.unlockLevelTxt;
	}

	if (m_btn_return != undefined){
		m_btn_return.onRelease = function(){
			fscommand("MyMarchMgrCommand","ReCallMarch\2" + this._parent.march_data.troops_id)
		}
	}

	if (m_btn_location != undefined){
		m_btn_location.onRelease = function(){
			fscommand("MyMarchMgrCommand","SeeMarch\2" + this._parent.march_data.troops_id)
		}
	}

	if (mc.btn_config != undefined){
		mc.btn_config.onRelease = function(){
			fscommand('WorldMapCmd','ShowTroopsConfigure')
		}
	}

	if(mc.march_data.type == "wait_monster_battle")
	{
		mc.start_battle_anim.btn_start_battle.onRelease = function()
		{
			fscommand("MyMarchMgrCommand","StartBattle\2" + this._parent._parent.march_data.troops_id)
		}
	}

	if ( mc.march_data.troop_heros.length > 0 ){
		mc.board.hitzone.onPress = function(){
			this._parent._parent._parent._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}

		mc.board.hitzone.onReleaseOutside = function(){
			this._parent._parent._parent._parent.onReleasedInListbox();
		}

		mc.board.hitzone.onRelease = function(){
			this._parent._parent._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) < this._width / 2 &&  Math.abs(this.Press_y - _root._ymouse) < this._height / 2){ 
				ControlMarchHeroShow(this._parent._parent);
			}
		}
		var totle_combat_num = 0;
		var hero_data_list = mc.march_data.troop_heros;
		for ( var i = 1 ; i <= 6 ; i ++ ){
			var hero_view_item = mc.board.item["item" + i]
			var hero_data = hero_data_list[i - 1];
			hero_view_item.gotoAndStop((hero_data != undefined && hero_data.hp_percent == 0) ? "dead" : "normal");
			if (hero_view_item.hero_icon.icon_info.icon_info.icons == undefined){
				hero_view_item.hero_icon.icon_info.icon_info.loadMovie("CommonHeros.swf");
			}
			if (hero_data == undefined){
				// hero_view_item.blood.gotoAndStop(1);
				// hero_view_item.shield.gotoAndStop(1);
				hero_view_item.hero_icon.blood._visible = false;
				hero_view_item.hero_icon.shield._visible = false;
				hero_view_item.hero_icon.icon_info.icon_info.IconData = undefined;
				hero_view_item.hero_icon.star_plane._visible = false;
			}
			else{
				hero_view_item.hero_icon.icon_info.gotoAndStop( hero_data.hp_percent == 0 ? "gray" : "normal");
				hero_view_item.hero_icon.blood._visible = true;
				hero_view_item.hero_icon.shield._visible = true;
				hero_view_item.hero_icon.blood.gotoAndStop(Math.ceil(hero_data.hp_percent / 20) + 1);
				hero_view_item.hero_icon.shield.gotoAndStop(Math.ceil(hero_data.sheild_percent / 20) + 1);
				hero_view_item.hero_icon.icon_info.icon_info.IconData = hero_data.icon_data;
				hero_view_item.hero_icon.star_plane._visible = true;
				hero_view_item.hero_icon.star_plane.star.gotoAndStop(hero_data.star);
				totle_combat_num += hero_data.combat;
			}
			if(hero_view_item.hero_icon.icon_info.icon_info.UpdateIcon) { hero_view_item.hero_icon.icon_info.icon_info.UpdateIcon(); }
		}
		mc.board.combat_text.text = totle_combat_num;
	}
	
}

function set_btn_list_highlight(isHighlight)
{
	if(isHighlight)
	{
		_root.main_ui.btn_list.play();
	}
	else
	{
		_root.main_ui.btn_list.gotoAndStop(1);
	}
}

function tick_sec(curTime){
	for (var i = 1; i <= 5;i++){
		var view_item = march_frame_mc["board_" + i];
		if (view_item.march_data.march_countdown_sec > 0){
			// view_item.march_data.march_countdown_sec -- ;
			view_item.march_data.march_countdown_sec = Math.ceil(view_item.march_data.march_endTimeStamp - curTime)
			view_item.board.countdown_text.text = format_time( view_item.march_data.march_countdown_sec )
			var progress_percent = Math.floor((view_item.march_data.march_totle_sec - view_item.march_data.march_countdown_sec) / view_item.march_data.march_totle_sec * 100);
			view_item.board.progressbar.gotoAndStop(progress_percent + 1);
		}
	}
}

function refreash_march_info( list_data:Array , flagship_data:Object ){
	m_march_datas = list_data;
	if ( flagship_data != undefined ){
		m_march_datas.unshift(flagship_data);
	}
	RefreashFormations();
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