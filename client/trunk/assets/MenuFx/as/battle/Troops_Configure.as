var UIID = undefined;
var Can_SendTroop = false;
var g_listInited = false;

_root.onLoad = function(){
	init();
	reset();
}

function init(){
	_root.main_ui.content.btn_close.onRelease = function(){
		move_out();
	}
}

var m_troops = undefined;
function refresh_Troops(Troops_info:Array){
	m_troops = Troops_info;
	var troops_view = _root.main_ui.content.content_view.content_list.list_view;
	if(not g_listInited)
	{
		g_listInited = true;
		troops_view.clearListBox();
		troops_view.initListBox("march_conf_list_board_all",0,true,true);
		troops_view.enableDrag( true );
		troops_view.onEnterFrame = function(){
			this.OnUpdate();
		}

		troops_view.onItemEnter = function(mc,item_index){
			mc.Troops_data = m_troops[item_index - 1];
			refresh_Troop_item(mc,item_index);
		}

		for( var i=1; i <= m_troops.length ; i++ )
		{   
		    troops_view.addListItem(i, false, false);
		}
	}
	else
	{
		for( var i=1; i <= m_troops.length ; i++ )
		{
			var mc = troops_view.getMcByItemKey(i);
			if(mc)
			{
				mc.Troops_data = m_troops[i - 1];
				refresh_Troop_item(mc, i);
			}
		}
	}

}

function refresh_Troop_item(mc,troops_index){
	if (mc.Troops_data == undefined){
		mc.gotoAndStop("type_lock");
	}
	else{
		mc.gotoAndStop('type_' + mc.Troops_data.type);
	}

	if(mc.item_view.index_plane){
		mc.item_view.index_plane.index_value.gotoAndStop(troops_index + 1);
	}

	mc.item_view.txt_fleet.text = mc.Troops_data.fleet_name;
	mc.item_view.btn_write._visible = false; //TODO

	switch(mc.Troops_data.type){
		case 'empty':
			mc.item_view.btn_setup.onRelease = mc.item_view.setup_hitzone.onRelease = function(){
				fscommand("MyMarchMgrCommand","SetupTroopHeros\2" + this._parent._parent.Troops_data.troops_id);
			}
		break;
		case 'ready':
			mc.item_view.control_plane._visible = false;
			mc.item_view.control_plane.OnMoveOutOver = function(){ this._visible = false ;}
			var m_btn_setting = undefined;
			if (Can_SendTroop){
				mc.item_view.btn_setting._visible = true;
				mc.item_view.btn_send._visible = true;
				mc.item_view.btn_mid_setting._visible = false;
				mc.item_view.btn_send.onRelease = function(){
					fscommand("MyMarchMgrCommand","SendTroop\2" + this._parent._parent.Troops_data.troops_id);
					move_out();
				}
				m_btn_setting = mc.item_view.btn_setting;
			}
			else{
				mc.item_view.btn_setting._visible = false;
				mc.item_view.btn_send._visible = false;
				mc.item_view.btn_mid_setting._visible = true;
				m_btn_setting = mc.item_view.btn_mid_setting;
			}

			m_btn_setting.onRelease = function(){
				if (this._parent.control_plane._visible){
					this._parent.control_plane.gotoAndPlay("closing_ani");
				}
				else{
					this._parent.control_plane._visible = true;
					this._parent.control_plane.gotoAndPlay("opening_ani");
				}
			}
			mc.item_view.control_plane.btn_setup.onRelease = function(){
				this._parent.gotoAndPlay("closing_ani");
				fscommand("MyMarchMgrCommand","SetupTroopHeros\2" + this._parent._parent._parent.Troops_data.troops_id);
			}
			mc.item_view.control_plane.btn_delete.onRelease = function(){
				this._parent.gotoAndPlay("closing_ani");
				fscommand("MyMarchMgrCommand","DeleteTroop\2" + this._parent._parent._parent.Troops_data.troops_id);
			}
			mc.item_view.control_plane.btn_repair.onRelease = function(){
				this._parent.gotoAndPlay("closing_ani");
				fscommand("MyMarchMgrCommand","RepairTroop\2" + this._parent._parent._parent.Troops_data.troops_id);
			}
		break;
		case 'repair':
			mc.item_view.repair_time_view.time_text.text = format_time( mc.Troops_data.march_countdown_sec )
			var progress_percent = Math.floor((mc.Troops_data.march_totle_sec - mc.Troops_data.march_countdown_sec) / mc.Troops_data.march_totle_sec * 100);
			mc.item_view.repair_time_view.gotoAndStop(progress_percent + 1);
		break;
		case 'march':
			var m_btn_return = undefined;
			var m_btn_repair = undefined;
			if(mc.Troops_data.is_can_ReCall){
				mc.item_view.btn_mid_repair._visible = false;
				mc.item_view.btn_repair._visible = true;
				mc.item_view.btn_return._visible = true;
				m_btn_return = mc.item_view.btn_return;
				m_btn_repair = mc.item_view.btn_repair;
			}
			else{
				mc.item_view.btn_mid_repair._visible = true;
				mc.item_view.btn_repair._visible = false;
				mc.item_view.btn_return._visible = false;
				m_btn_repair = mc.item_view.btn_mid_repair;
			}
			if (m_btn_return != undefined){
				m_btn_return.onRelease = function(){
					fscommand("MyMarchMgrCommand","ReCallMarch\2" + this._parent._parent.Troops_data.troops_id);
				}
			}
			m_btn_repair.onRelease = function(){
				fscommand("MyMarchMgrCommand","RepairTroop\2" + this._parent._parent.Troops_data.troops_id);
			}
		break;
		case 'lock':
			// trace("unlock level: " + mc.Troops_data.unlock_level);
		break;
		default:
			mc.item_view.btn_repair.onRelease = function(){
				fscommand("MyMarchMgrCommand","RepairTroop\2" + this._parent._parent.Troops_data.troops_id);
			}

			mc.item_view.btn_return.onRelease = function(){
				fscommand("MyMarchMgrCommand","ReCallMarch\2" + this._parent._parent.Troops_data.troops_id);
			}
		break;
	}

	if ( mc.Troops_data.troop_heros.length > 0 ){
		var totle_combat_num = 0;
		var hero_data_list = mc.Troops_data.troop_heros;
		for ( var i = 1 ; i <= 6 ; i ++ ){
			var hero_view_item = mc.item_view.hero_view["item" + i]
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
				hero_view_item.hero_icon.star_plane._visible = false;
				hero_view_item.hero_icon.icon_info.icon_info.IconData = undefined;
			}
			else{
				var hp_frame = Math.ceil(hero_data.hp_percent / 20) + 1;
				var shield =  Math.ceil(hero_data.sheild_percent / 20) + 1;
				hero_view_item.hero_icon.blood._visible = true;
				hero_view_item.hero_icon.shield._visible = true;
				hero_view_item.hero_icon.blood.gotoAndStop(hp_frame);
				hero_view_item.hero_icon.shield.gotoAndStop(shield);
				hero_view_item.hero_icon.star_plane._visible = true;
				hero_view_item.hero_icon.star_plane.star.gotoAndStop(hero_data.star);
				totle_combat_num += hero_data.combat;
				hero_view_item.hero_icon.icon_info.gotoAndStop( hero_data.hp_percent == 0 ? "gray" : "normal");
				hero_view_item.hero_icon.icon_info.icon_info.IconData = hero_data.icon_data;
			}
			if(hero_view_item.hero_icon.icon_info.icon_info.UpdateIcon) { hero_view_item.hero_icon.icon_info.icon_info.UpdateIcon(); }
		}
		mc.item_view.combat_text.text = totle_combat_num;
	}
}

function SetCanSendTroop(_can_send){
	Can_SendTroop = _can_send;
}

function reset(){
	_root.bg._visible = false;
	_root.main_ui.content.gotoAndStop(1);
	_root.main_ui._visible = false;
}

function move_in(_UIID){
	UIID = _UIID;
	_root.bg._visible = true;
	_root.main_ui.content.gotoAndPlay("opening_ani");
	_root.main_ui.content.bg.gotoAndPlay("opening_ani");
	_root.main_ui._visible = true;
}

function move_out(){
	fscommand("MapCommand","UIClose\2"+UIID);
	fscommand("MyMarchMgrCommand","OnTroopsConfigureClosed");
	_root.main_ui.content.gotoAndPlay("closing_ani");
	_root.main_ui.content.bg.gotoAndPlay("closing_ani");
	_root.main_ui.content.OnMoveOutOver = function(){
		reset();
	}
}

function tick_sec(curTime){
	var troops_view = _root.main_ui.content.content_view.content_list.list_view;
	for (var i = 1; i <= troops_view.getItemListLength() ; ++i){
		var troop_mc = troops_view.getMcByItemKey(i);
		if (troop_mc != null && troop_mc.item_view.repair_time_view != undefined){
			// troop_mc.Troops_data.march_countdown_sec -- ;
			troop_mc.Troops_data.march_countdown_sec = Math.ceil(troop_mc.Troops_data.march_endTimeStamp - curTime)
			troop_mc.item_view.repair_time_view.time_text.text = format_time( troop_mc.Troops_data.march_countdown_sec )
			var progress_percent = Math.floor((troop_mc.Troops_data.march_totle_sec - troop_mc.Troops_data.march_countdown_sec) / troop_mc.Troops_data.march_totle_sec * 100);
			troop_mc.item_view.repair_time_view.gotoAndStop(progress_percent + 1);
		}
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