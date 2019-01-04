import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;


var all_view_mov_object_list : Array = [ _root.troops_title , _root.filter_contral ,  _root.tropps_bottom , _root.troops_bg ];
var all_view_static_object_list : Array = [ _root.tab_bg ]
var Is_MovedIn : Boolean = false;
var Is_ForCollection : Boolean = false;

this.onLoad = function(){
	init();
	initData();
	//move_in(true);
}

function init()
{
	init_function_area();
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = false;
		view_object.is_moved_out = false;
		view_object.OnMoveOutOver = function(){
			this.is_moved_out = true;
			// var all_moved_out = true;
			// for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
			// 	all_moved_out &= all_view_mov_object_list[i].is_moved_out;
			// }
			// if(all_moved_out){
			// 	trace("_root.OnAllMovedOut");
			// 	_root.OnAllMovedOut();
			// }
		}
	}
	_root.tropps_bottom.OnMoveOutOver = function()
	{
		this.is_moved_out = true;
		_root.OnAllMovedOut();
	}

	for(var i = 0 ; i < all_view_static_object_list.length ; i++){
		all_view_static_object_list[i]._visible = false;
	}

	_root.troops_middle_s._visible = false;
	_root.troops_middle_b._visible = false;
}


function move_in(ForCollection:Boolean){
	if( Is_MovedIn ) { return; }

	_root.Is_ForCollection = ForCollection;
	_root.troops_middle = ForCollection == true ? _root.troops_middle_s : _root.troops_middle_b;
	_root.tropps_bottom.mine_income._visible = ForCollection;
	_root.tropps_bottom.mine_time._visible = ForCollection;
	_root.tropps_bottom.tab_bottom_frame_s._visible = ForCollection;
	_root.tropps_bottom.tab_bottom_frame_b._visible = !ForCollection;

	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = true;
		view_object.is_moved_out = false;
		view_object.gotoAndPlay("opening_ani");
	}

	_root.troops_middle._visible = true;
	_root.troops_middle.gotoAndPlay("opening_ani");

	for(var i = 0 ; i < all_view_static_object_list.length ; i++){
		all_view_static_object_list[i]._visible = true;
	}

	Is_MovedIn = true;

	showAllHero(0);
	refer_intoBattle_info(false);
}

function move_out(goBattle:Boolean){
	if( !Is_MovedIn ) { return; }

	if (goBattle){
		if(_root.Is_ForCollection)
		{
			_root.OnAllMovedOut = function(){
				fscommand("GoToNext");
			}
		}
		else
		{
			_root.OnAllMovedOut = function(){
				var battle_member_parms = undefined;
				for(var i = 0 ; i < m_heroIntoBattle_list.length ; i++){
					battle_member_parms =  battle_member_parms == undefined ? m_heroIntoBattle_list[i].id : battle_member_parms + '\2' + m_heroIntoBattle_list[i].id;
				}
				fscommand("SetBattleFormation",battle_member_parms);
				fscommand("ExitBack");
			}
		}
	}
	else{
		_root.OnAllMovedOut = function(){
			fscommand("ExitBack");
		}
	}

	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object.is_moved_out = false;
		view_object.gotoAndPlay("closing_ani");
	}
	_root.troops_middle.gotoAndPlay("closing_ani");

	for(var i = 0 ; i < all_view_static_object_list.length ; i++){
		all_view_static_object_list[i]._visible = false;
	}
	
}

function initData(){
	var default_hero_data = CreateAllHeroTest();
	// initHeroList(default_hero_data);
	init_intoBattle_info();
}


function init_function_area(){
	init_filter_contral();

	_root.troops_bg.button_exit.onRelease = function(){
		move_out(false);
	}

	_root.tropps_bottom.button_complate.onRelease = function(){
		move_out(true);
	}


}



function CreateAllHeroTest(){
	var test_hero_id_list = ["Clotho","Apollo","Crius","Prometheus","takezo","Avatar","Hero","Medic","Rhinoceros","Tenzai","Zero"];
	var test_hero_rankvalue_list = [1000100,3010000,2000009,2000008,3999999,2000002,2000010,1000111,3999998,2000055,2000005];
	var rankvalue_localmode_map = [0,3,2,1];
	var default_hero_data = Array();
	for(var i = 0; i < test_hero_id_list.length ; i++){
		var hero_item = Object();
		hero_item.id = test_hero_id_list[i];
		hero_item.name = test_hero_id_list[i];
		hero_item.rank_value = test_hero_rankvalue_list[i];
		hero_item.level = i * 10;
		hero_item.star = i < 6 ? 2 : 3;
		hero_item.combat = hero_item.star * 100;
		hero_item.local_mode = rankvalue_localmode_map[Math.floor(hero_item.rank_value / 1000000)];
		hero_item.is_outside = i  <= 15 ? false : true;
		hero_item.is_actived = i < 6 ? true : false;
		default_hero_data[i] = hero_item;
	}
	return default_hero_data;
}


var m_hero_list : Array;
var s_list_all : Number = 0;
var s_list_front : Number = 1;
var s_list_middle : Number = 2;
var s_list_back : Number = 3;
var s_list_outside : Number = 4;
function initHeroList(input_hero_data:Array){
	if ( m_hero_list == undefined ){
		m_hero_list = new Array();
		for (var i = s_list_all ; i <= s_list_outside ; i++ ){
			m_hero_list[i] = new Array();
		}
	}
	for (var i = s_list_all ; i <= s_list_outside ; i++ ){
			m_hero_list[i].splice(0);
		}
	for (var i = 0; i < input_hero_data.length ; i++){
		var m = input_hero_data[i];
		if (m.is_outside){
			m_hero_list[s_list_outside].push(m);
		}
		else{
			m_hero_list[s_list_all].push(m);
			m_hero_list[m.local_mode].push(m);
		}
	}
}


function showAllHero(hero_list_sign:Number){
	var AllheroList = _root.troops_middle.HeroView.ViewList;
	hero_show_list = m_hero_list[hero_list_sign];
	var filter_button = _root.filter_contral["filter_button_" + (hero_list_sign + 1)];
	filter_button.gotoAndStop("released");
	AllheroList.clearListBox();
	AllheroList.initListBox("item_choose_hero_list",0,true,true);
	AllheroList.enableDrag( true );
	AllheroList.onEnterFrame = function(){
		this.OnUpdate();

	}
	if (AllheroList.CloseList == undefined){
		AllheroList.CloseList = function(){
			for(var i = 1; i <= this.getItemListLength() ; i++){
				var list_item = this.getMcByItemKey(i);
				list_item.item_1.gotoAndPlay("closing_ani");
				list_item.item_2.gotoAndPlay("closing_ani");
				list_item.item_3.gotoAndPlay("closing_ani");
			}
		}
	}

	AllheroList.onItemEnter = function(mc,index_item){
		for(var i = 0; i < 3 ; i++ ){
			var hero_data = hero_show_list[(index_item - 1) * 3 + i ];
			var hero_item_mc = mc["item_" + (i + 1)];
			if(hero_data){
				hero_item_mc._visible = true;
				hero_item_mc.hero_data = hero_data;
				hero_item_mc.hero_info.hero_name.text = hero_data.name;
				hero_item_mc.hero_info.level_num.text = hero_data.level;
				if (hero_item_mc.hero_icon.hero_icon.icons == undefined){
					hero_item_mc.hero_icon.hero_icon.loadMovie("CommonHeros.swf");
				}
				hero_item_mc.hero_icon.hero_icon.icons.gotoAndStop("hero_" + hero_data.id);
				hero_item_mc.hero_icon.gotoAndStop(hero_data.is_actived ? "activited" : "normal");
				//star
				for(var j = 1 ; j <= 5 ; j++){
					hero_item_mc.hero_info["star_" + j].gotoAndStop( hero_data.star >= j ? "normal" : "Idle" );
				}
				hero_item_mc.onRelease = function(){
					this._parent._parent.onReleasedInListbox();
					if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
						heroMC_select(this);
					}
				}
				hero_item_mc.onReleaseOutside = function(){
					this._parent._parent.onReleasedInListbox();
				}
				hero_item_mc.onPress = function(){
					this._parent._parent.onPressedInListbox();
					this.Press_x = _root._xmouse;
					this.Press_y = _root._ymouse;
				}
			}
			else{
				hero_item_mc._visible = false;
			}
		}
	}

	AllheroList.onItemMCCreate = function(mc){
		for(var i = 0; i < 3 ; i++ ){
			var hero_item_mc = mc["item_" + (i + 1)];
			hero_item_mc.gotoAndPlay("opening_ani");
		}
	}

	AllheroList.onListboxMove = undefined;


	for( var i=1; i <= (hero_show_list.length + 2) / 3; i++ )
	{   
	    AllheroList.addListItem(i, false, false);
	}
}

function heroMC_select(this_mc:Object){
	if (this_mc.hero_data.is_actived){
		this_mc.hero_data.is_actived = false;
		this_mc.hero_icon.gotoAndStop("normal");
		refer_intoBattle_info(true);
	}
	else if(m_heroIntoBattle_list.length < 6){
		this_mc.hero_data.is_actived = true;
		this_mc.hero_icon.gotoAndStop("activited");
		m_heroIntoBattle_list.push(this_mc.hero_data);
		refer_intoBattle_info(false);
	}
	else{
		//intobattle list is full ! do nothing
	}
}



function init_filter_contral(){
	for(var j = 1; j <= 5 ; j++){
		var filter_button = _root.filter_contral["filter_button_" + j];
		filter_button.onRelease = function(){
			for(var i = 1; i <= 5 ; i++){
				this._parent["filter_button_" + i].gotoAndStop("Idle");
				showAllHero(this.filter_sign);
			}
		}
		filter_button.filter_sign = j - 1;
	}
}


var m_heroIntoBattle_list : Array;
function init_intoBattle_info(){
	m_heroIntoBattle_list = new Array();
	for (var i = 0; i < m_hero_list[s_list_all].length ; i++){
		if (m_hero_list[s_list_all][i].is_actived){
			m_heroIntoBattle_list.push(m_hero_list[s_list_all][i]);
		}
	}
	for (var i = 0; i < m_hero_list[s_list_outside].length ; i++){
		if (m_hero_list[s_list_outside][i].is_actived){
			m_heroIntoBattle_list.push(m_hero_list[s_list_outside][i]);
		}
	}

	//init intobattle contral button
	for (var i = 0; i < 6 ;i ++){
		var view_item = _root.tropps_bottom["intoBattle_item_" + i];
		view_item.IntoBattle_index = i;
		view_item.onRelease = function(){
			var item_hero = m_heroIntoBattle_list[this.IntoBattle_index];
			if(item_hero){
				item_hero.is_actived = false;
				refer_intoBattle_info(true);
				refer_selectHero_Viewlist();
			}
			else{
				return;
			}
		}
	}
}


function refer_selectHero_Viewlist(){
	var AllheroList = _root.troops_middle.HeroView.ViewList;
	for(var i = 1; i <= AllheroList.getItemListLength() ; i ++){
		var hero_line = AllheroList.getMcByItemKey(i);
		for(item_index = 1 ; item_index <= 3 ; item_index ++)
		{
			if (hero_line["item_" + item_index]._visible){
				hero_line["item_" + item_index].hero_icon.gotoAndStop(hero_line["item_" + item_index].hero_data.is_actived ? "activated" : "normal");
			}
		}
	}
}


function refer_intoBattle_info(need_remove : Boolean){
	//remove unintoBattle list
	if(need_remove){
		for (var i = 0; i < m_heroIntoBattle_list.length ; i++){
			if (!m_heroIntoBattle_list[i].is_actived){
				m_heroIntoBattle_list.splice(i,1);
			}
		}
	}
	//sort intoBattle list by local mode
	m_heroIntoBattle_list.sort(
		function(a,b) { return a.rank_value > b.rank_value ? 1 : -1;} 
		);

	//show intoBattle list
	var IntoBattleList_view = _root.tropps_bottom;
	for(var i = 0 ; i < 6 ; i ++){
		var view_item = IntoBattleList_view["intoBattle_item_" + i];
		if( m_heroIntoBattle_list[i]){
			var m_hero_info = m_heroIntoBattle_list[i];
			view_item.hero_icons.gotoAndStop("hero_activited");
			view_item.hero_icons.hero_info.lv_num.text = m_hero_info.level;
			for(var star_num = 1 ; star_num < 6 ; star_num++){
				view_item.hero_icons.hero_info["info_star_" + star_num]._visible = (star_num <= m_hero_info.star);
			}

			if(view_item.hero_icons.hero_icon.icons == undefined){
				view_item.hero_icons.hero_icon.loadMovie("CommonHeros.swf");
			}
			view_item.hero_icons.hero_icon.icons.gotoAndStop("hero_" + m_hero_info.id);
		}
		else{
			view_item.hero_icons.gotoAndStop("hero_empty");
		}
	}

	//show total combat!
	var total_combat = 0;
	for(var i = 0 ; i < 6 ; i ++){
		if( m_heroIntoBattle_list[i]){
			total_combat += m_heroIntoBattle_list[i].combat;
		}
	}
	IntoBattleList_view.combat_num.num.text = total_combat;

}