var FormationsQueueData = new Array();
var m_me_index = undefined;

_root.onLoad=function()
{
	_root.main_ui.pop_content.btn_close.onRelease = function(){
		move_out();
	}
	set_goto_me_btn(undefined);
	reset();
}

function reset(){
	_root.main_ui.pop_content.gotoAndStop("opening_ani");
	_root.main_ui._visible = false;
}

function move_in(){
	_root.main_ui._visible = true;
	_root.main_ui.pop_content.gotoAndPlay("opening_ani");
}

function move_out(){
	_root.main_ui.pop_content.OnMoveOutOver = function(){
		reset();
		//move_in();
	}
	_root.main_ui.pop_content.gotoAndPlay("closing_ani");
}

function RefreashFormationsQueue(){
	var FormationsView = _root.main_ui.pop_content.item_origin.hero_list.hero_list;
	FormationsView.clearListBox();
	FormationsView.initListBox("item_list_all",0,true,true);
	FormationsView.enableDrag( true );
	FormationsView.onEnterFrame = function(){
		this.OnUpdate();
	}

	FormationsView.onItemEnter = function(mc,index_item){
		var formation_info = FormationsQueueData[index_item];
		// mc.gotoAndStop( index_item == 1 ? "top" : "normal");
		mc.gotoAndStop( formation_info.isEnemy ? "top" : "normal" );
		// if (index_item > 0){
			mc.list_item.index_plane.index_bar.gotoAndStop(1);
			mc.list_item.index_plane.index_bar.index_bar.gotoAndStop(index_item + 2);
		// }

		mc.list_item.formation_player_info_text.text = formation_info.player_name;
		trace( FormationsQueueData[0].player_name);
		var totle_combat_num = 0;
		var hero_data_list = formation_info.formation_data;
		for ( var i = 1 ; i <= 6 ; i ++ ){
			var hero_view_item = mc.list_item["item" + i]
			var hero_data = hero_data_list[i - 1];
			if (hero_view_item.icon_info.icon_info.icons == undefined){
				hero_view_item.icon_info.icon_info.loadMovie("CommonHeros.swf");
			}
			if (hero_data == undefined){
				// hero_view_item.blood.gotoAndStop(1);
				hero_view_item.blood._visible = false;
				hero_view_item.shield._visible = false;
				hero_view_item.icon_info.icon_info.IconData = undefined;
				hero_view_item.icon_info.star_plane._visible = false;
			}
			else{
				// hero_view_item.blood.gotoAndStop(6);
				hero_view_item.blood._visible = true;
				hero_view_item.shield._visible = true;
				hero_view_item.blood.gotoAndStop(hero_data.hp + 1);
				hero_view_item.shield.gotoAndStop(hero_data.shield + 1);
				hero_view_item.icon_info.icon_info.IconData = hero_data.icon_data;
				hero_view_item.icon_info.star_plane._visible = true;
				hero_view_item.icon_info.star_plane.star.gotoAndStop(hero_data.star);
				totle_combat_num = hero_data.combat;
			}
			if(hero_view_item.icon_info.icon_info.UpdateIcon) { hero_view_item.icon_info.icon_info.UpdateIcon(); }
		}

		if(mc.list_item.headIcon.hero_icons != undefined && mc.list_item.headIcon.hero_icons.icons == undefined)
		{
			var w = mc.list_item.headIcon.hero_icons._width;
			var h = mc.list_item.headIcon.hero_icons._height;
			mc.list_item.headIcon.hero_icons.loadMovie("CommonPlayerIcons.swf");
			mc.list_item.headIcon.hero_icons._width = w;
			mc.list_item.headIcon.hero_icons._height = h;
		}
		mc.list_item.headIcon.hero_icons.IconData = formation_info.playerIconInfo;
    	if (mc.list_item.headIcon.hero_icons.UpdateIcon) { mc.list_item.headIcon.hero_icons.UpdateIcon(); }

		mc.list_item.combat_text.text = totle_combat_num;
	}

	for( var i=0; i < FormationsQueueData.length ; i++ )
	{   
	    FormationsView.addListItem(i, false, false);
	}
}

function SetFormationsQueueData( me_index : Number , info){
	set_goto_me_btn(me_index);
	FormationsQueueData = info.FormationsData;
	RefreashFormationsQueue();

	var queue_info_plane = _root.main_ui.pop_content.item_origin.FormationsQueueInfo;
	queue_info_plane.txt_totalTeam.text = info.totalTeamTxt;

}

function set_goto_me_btn(me_index : Number){
	var queue_info_plane = _root.main_ui.pop_content.item_origin.FormationsQueueInfo;
	if (me_index == undefined){
		queue_info_plane.btn_goto_me._visible = false;
		queue_info_plane.LC_UI_Item_UI_Hero_Level_Limit._visible = false;
		queue_info_plane.LC_UI_My_Team_Where._visible = false;
	}
	else{
		m_me_index = me_index;
		queue_info_plane.LC_UI_Item_UI_Hero_Level_Limit._visible = true;
		queue_info_plane.btn_goto_me._visible = true;
		queue_info_plane.LC_UI_My_Team_Where._visible = true;
	}
}