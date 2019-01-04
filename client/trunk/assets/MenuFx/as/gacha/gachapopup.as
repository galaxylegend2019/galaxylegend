var all_view_mov_object_list : Array = [ _root.gacha_popup];
var all_view_static_object_list : Array = [ ];
var Is_MovedIn : Boolean = false;

this.onLoad = function(){
	init();
	refresh_hero_data(create_test_hero_data());
	//move_in();
}

function init(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndStop("opening_ani");
		all_view_mov_object_list[i]._visible = false;
	}
}

function move_in(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i]._visible = true;
		all_view_mov_object_list[i].gotoAndPlay("opening_ani");
	}
}


function move_out(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndPlay("closing_ani");
	}
}

function create_test_hero_data(){
	var hero_data = new Object();
	hero_data.id = "Clotho";
	hero_data.name = "Clotho";
	hero_data.level = 20;
	hero_data.star = 4;
	return hero_data;
}

function refresh_hero_data(hero_data:Object){
	var popup_view = _root.gacha_popup;
	popup_view.hero_text_info_plane.text_name.text = hero_data.name;
	popup_view.hero_text_info_plane.text_level.text = hero_data.level;
	popup_view.hero_view.hero_icons.gotoAndStop("hero_activited");
	//if(popup_view.hero_view.hero_icons.icons == undefined){
	//	popup_view.hero_view.hero_icons.loadMovie("CommonHeros.swf");
	//}
	//popup_view.hero_view.hero_icons.icons.gotoAndStop("hero_" + hero_data.id);
}