import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;


var all_view_mov_object_list : Array = [ _root.tropps_Title ,  _root.troops_selectHero , _root.dispatch_view , _root.dispatch_view_withenemy , _root.troops_hero_view ];
var Is_MovedIn : Boolean = false;
var Is_HasEnemy : Boolean = false;
var Is_Tutoria : Boolean  = false;
var Is_supportOutsideHero : Boolean = false;
var m_Custom_Enemy_Combat : Number = undefined
var m_new_selected_rid : Number = -1;

var m_has_employ = false;

this.onLoad = function(){
	/*******FTE*******/
	fscommand("TutorialCommand","Activate" + "\2" + "TroopsBattleUILoad");
	/*******End*******/	
	init();
	//move_in(false);
}

function init()
{
	init_function_area();
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = false;
	}

	_root.btn_bg._visible = false;
}

function move_in(has_enemy:Boolean){
	if( Is_MovedIn ) { return; }
	m_has_employ = false;
	Is_HasEnemy = has_enemy;
	_root.tropps_Title._visible = true;
	_root.tropps_Title.gotoAndPlay("opening_ani");
	_root.troops_hero_view._visible = true;
	_root.troops_hero_view.gotoAndPlay("opening_ani");

	init_intoBattle_info();
	refer_intoBattle_info(false);
	refer_intoBattle_plus_btn(true);

	if(Is_HasEnemy){
		_root.dispatch_view_withenemy._visible = true;
		_root.dispatch_view_withenemy.gotoAndPlay("opening_ani");
		refer_Enemys(_root.dispatch_view_withenemy.troops_defense, _root.dispatch_view_withenemy.defense_combat_plane.combat_num_text);
		refer_PlayerTroops(_root.dispatch_view_withenemy.troops_attack, _root.dispatch_view_withenemy.attack_combat_plane.combat_num_text);

		_root.dispatch_view.goBtn.btn_attack._visible = true;
		_root.dispatch_view.goBtn.btn_attack.onRelease = select_hero_done;
		_root.dispatch_view.goBtn.btn_sure._visible = false;
		_root.dispatch_view.goBtn.btn_sure.onRelease = undefined;
		_root.dispatch_view_withenemy.goBtn.btn_attack._visible = true;
		_root.dispatch_view_withenemy.goBtn.btn_attack.onRelease = select_hero_done;
		_root.dispatch_view_withenemy.goBtn.btn_sure._visible = false;
		_root.dispatch_view_withenemy.goBtn.btn_sure.onRelease = undefined;
		_root.troops_selectHero.goBtn.btn_attack._visible = true;
		_root.troops_selectHero.goBtn.btn_attack.onRelease = select_hero_done;
		_root.troops_selectHero.goBtn.btn_sure._visible = false;
		_root.troops_selectHero.goBtn.btn_sure.onRelease = undefined;
	}
	else{
		_root.dispatch_view._visible = true;
		_root.dispatch_view.gotoAndPlay("opening_ani");
		refer_PlayerTroops(_root.dispatch_view.troops_defense, _root.dispatch_view.defense_combat_plane.combat_num_text);

		_root.dispatch_view.goBtn.btn_attack._visible = false;
		_root.dispatch_view.goBtn.btn_attack.onRelease = undefined;
		_root.dispatch_view.goBtn.btn_sure._visible = true;
		_root.dispatch_view.goBtn.btn_sure.onRelease = select_hero_done;
		_root.dispatch_view_withenemy.goBtn.btn_attack._visible = false;
		_root.dispatch_view_withenemy.goBtn.btn_attack.onRelease = undefined;
		_root.dispatch_view_withenemy.goBtn.btn_sure._visible = true;
		_root.dispatch_view_withenemy.goBtn.btn_sure.onRelease = select_hero_done;
		_root.troops_selectHero.goBtn.btn_attack._visible = false;
		_root.troops_selectHero.goBtn.btn_attack.onRelease = undefined;
		_root.troops_selectHero.goBtn.btn_sure._visible = true;
		_root.troops_selectHero.goBtn.btn_sure.onRelease = select_hero_done;
	}

	m_new_selected_rid = -1;
	_root.btn_bg._visible = true;

	fscommand("ChatMgrCmd","Hide");
	Is_MovedIn = true;
}

function select_hero_done(){
	//trace(this);
	if(m_heroIntoBattle_list.length == 0){
		fscommand("PlaySound", "sfx_ui_menu_appears");
		fscommand("ShowMessageBoxTimer","3000" + "\2" + "LC_ERROR_TROOPS_HERO_IS_EMPTY");
	}
	else if(m_heroIntoBattle_list.length < m_hero_list[s_list_all].length && m_heroIntoBattle_list.length < 6){
		fscommand("PlaySound", "sfx_ui_menu_appears");
		fscommand("TroopsMgrCmd","CheckNotFullFormation");
	}
	else{
		fscommand("PlaySound", "sfx_ui_selection_1");
		RealgoBattle();
	}
}

function move_out(goBattle:Boolean){
	if( !Is_MovedIn ) { return; }

	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		if(view_object._visible){
			view_object.gotoAndPlay("closing_ani");
			view_object.OnMoveOutOver = function(){
				this._visible = false;
			}
		}
	}

	_root.tropps_Title.OnMoveOutOver = function(){
		this._visible = false;
		_root.OnAllMovedOut();
	}

	if (goBattle){
			_root.OnAllMovedOut = function(){
			var battle_member_parms = undefined;
			for(var i = 0 ; i < m_heroIntoBattle_list.length ; i++){
				fscommand("ChatMgrCmd","Show");
				battle_member_parms =  battle_member_parms == undefined ? m_heroIntoBattle_list[i].rid : battle_member_parms + '\2' + m_heroIntoBattle_list[i].rid;
			}
			fscommand("TroopsMgrCmd","SetCurFormation\2" + battle_member_parms);
			// fscommand("GotoNextMenu", "GS_Battle");
			_root.btn_bg._visible = false;
			fscommand("GoToNext");
			/*******FTE*******/
			fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickGoFightBtn");
			/*******End*******/
		}
	}
	else{
		_root.OnAllMovedOut = function(){
			_root.btn_bg._visible = false;
			fscommand("ChatMgrCmd","Show");
			fscommand("ExitBack");
		}
	}


	Is_MovedIn = false;
}

function initData(){
	//var default_hero_data = CreateAllHeroTest();
	//initHeroList(default_hero_data);
	//initEnemyList(CreateEnemyTest());
}


function init_function_area(){
	init_filter_contral();
	_root.tropps_Title.btn_close.onRelease = function(){
        // FTEClickedListItem_One();
        fscommand("PlaySound", "sfx_ui_cancel");
        move_out(false);
	}

	_root.dispatch_view.btn_fleet.onRelease = _root.dispatch_view_withenemy.btn_fleet.onRelease = function(){
		fscommand("PlaySound", "sfx_ui_selection_1");
		this._parent.gotoAndPlay("closing_ani");
		this._parent.OnMoveOutOver = function(){
			refer_intoBattle_plus_btn(false);
			this._visible = false;
			_root.troops_selectHero._visible = true;
			_root.troops_selectHero.gotoAndPlay("opening_ani");
			if(Is_HasEnemy){
				_root.troops_selectHero.troops_info._visible = false;
				_root.troops_selectHero.troops_info_withEnemys._visible = true;
				refer_Enemys(_root.troops_selectHero.troops_info_withEnemys.troops_defense,_root.troops_selectHero.troops_info_withEnemys.defense_combat_plane.combat_num_text);
			}
			else{
				_root.troops_selectHero.troops_info._visible = true;
				_root.troops_selectHero.troops_info_withEnemys._visible = false;
			}
			showAllHero(0);
		}
		/*******FTE*******/
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickTroopsBtn");
		/*******End*******/	
	}

	var troops_hero_plane = _root.troops_hero_view.troops_hero_plane;
	for(var i = 0;i < 6; i++ ){
		troops_hero_plane["troops_" + i].plus_btn.onRelease = function(){
			if(_root.troops_selectHero._visible == false){
				if(Is_HasEnemy){
					_root.dispatch_view_withenemy.btn_fleet.onRelease();
				}
				else{
					_root.dispatch_view.btn_fleet.onRelease();
				}
			}
		}
	}

	_root.troops_selectHero.back_plane.onRelease = function(){
		fscommand("PlaySound", "sfx_ui_selection_1");
		this._parent.gotoAndPlay("closing_ani");
		this._parent.OnMoveOutOver = function(){
			this._visible = false;
			refer_intoBattle_plus_btn(true);
			if(Is_HasEnemy){
				_root.dispatch_view_withenemy._visible = true;
				_root.dispatch_view_withenemy.gotoAndPlay("opening_ani");
				refer_PlayerTroops(_root.dispatch_view_withenemy.troops_attack, _root.dispatch_view_withenemy.attack_combat_plane.combat_num_text);
			}
			else{
				_root.dispatch_view._visible = true;
				_root.dispatch_view.gotoAndPlay("opening_ani");
				refer_PlayerTroops(_root.dispatch_view.troops_defense, _root.dispatch_view.defense_combat_plane.combat_num_text);
			}
		}
	}
}


function RealgoBattle(){
	move_out(true);
}


function CreateAllHeroTest(){
	var test_hero_id_list = ["Clotho","Apollo","Crius","Prometheus","takezo","Avatar","Hero","Medic","Rhinoceros","Tenzai","Zero"];
	var test_hero_rankvalue_list = [1000100,3010000,2000009,2000008,3999999,2000002,2000010,1000111,3999998,2000055,2000005];
	var rankvalue_localmode_map = [0,3,2,1];
	var default_hero_data = Array();
	for(var i = 0; i < test_hero_id_list.length ; i++){
		var hero_item = Object();
		hero_item.id = test_hero_id_list[i];
		hero_item.rid = "test"
		hero_item.name = test_hero_id_list[i];
		hero_item.head_id = "hero_" + hero_item.name;
		hero_item.rank_value = test_hero_rankvalue_list[i];
		hero_item.level = i * 10;
		hero_item.star = i < 6 ? 2 : 3;
		hero_item.combat = hero_item.star * 100;
		hero_item.local_mode = rankvalue_localmode_map[Math.floor(hero_item.rank_value / 1000000)];
		hero_item.is_outside = i  <= 15 ? false : true;
		hero_item.is_actived = i < 4 ? true : false;
		default_hero_data[i] = hero_item;
	}
	return default_hero_data;
}

function CreateEnemyTest(){
	var test_enemy_id_list = ["Clotho","Apollo","Crius","Prometheus","takezo","Avatar","hero","Medic"];
	var testEnemyData = Array();
	for (var i = 0; i < 6 ; i++){
		var enemy_item = Object();
		enemy_item.id = test_enemy_id_list[i];
		enemy_item.name = test_enemy_id_list[i];
		enemy_item.level = 20 + i;
		enemy_item.star = i % 5 + 1;
		enemy_item.combat = enemy_item.star * 100;
		testEnemyData.push(enemy_item);
	}
	return testEnemyData;
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
	if(m_hero_list[s_list_outside].length > 0){
		Is_supportOutsideHero = true;
	}
	else{
		Is_supportOutsideHero = false;
	}
}

var m_enemy_list = undefined;
function initEnemyList(input_enemyList:Array , Custom_Enemy_Combat:Number){
	m_enemy_list = input_enemyList;
	m_Custom_Enemy_Combat = Custom_Enemy_Combat;
}

function refer_Enemys(EnemyInfoPlane:Object,CombatInfoPlane:Object){
	for( var i = 0; i < 6 ;i ++){
		var EnemyInfo = m_enemy_list[i];
		var EnemyViewItem = EnemyInfoPlane["Hero_item_" + i];
		if(EnemyViewItem.hero_icon.hero_icon.icons == undefined){
			EnemyViewItem.hero_icon.hero_icon.loadMovie("CommonHeros.swf");
		}
		if(EnemyInfo){
			EnemyViewItem.hero_icon.level_info._visible = true;
			EnemyViewItem.hero_icon.level_info.level_text.text = EnemyInfo.level;
			EnemyViewItem.hero_icon.star_plane._visible = true;
			EnemyViewItem.hero_icon.star_plane.star_view.gotoAndStop(EnemyInfo.star);
			if (EnemyInfo.hp_percent != undefined){
				EnemyViewItem.bloodbar._visible = true;
				var hp_frame = Math.floor(EnemyInfo.hp_percent / 20) + 1;
				var shield =  Math.floor(EnemyInfo.sheild_percent / 20) + 1;
				EnemyViewItem.bloodbar.shield.gotoAndStop(shield);
				EnemyViewItem.bloodbar.blood.gotoAndStop(hp_frame);
				EnemyViewItem.bloodbar.energy.gotoAndStop(EnemyInfo.mp_percent);
			}
			else{
				EnemyViewItem.bloodbar._visible = false;
			}

			EnemyViewItem.hero_icon.hero_icon.IconData = EnemyInfo.icon_data;
			if(EnemyViewItem.hero_icon.hero_icon.UpdateIcon) { EnemyViewItem.hero_icon.hero_icon.UpdateIcon(); }
		}
		else{
			EnemyViewItem.bloodbar._visible = false;
			EnemyViewItem.hero_icon.star_plane._visible = false;
			EnemyViewItem.hero_icon.level_info._visible = false;
			EnemyViewItem.hero_icon.hero_icon.IconData = undefined;
			if(EnemyViewItem.hero_icon.hero_icon.UpdateIcon) { EnemyViewItem.hero_icon.hero_icon.UpdateIcon(); }
		}
	}

	if(CombatInfoPlane != undefined){
		if (m_Custom_Enemy_Combat != undefined){
			CombatInfoPlane.text = m_Custom_Enemy_Combat;
		}
		else{
			var enemy_totle_combatnumb = 0;
			for (var i = 0 ;i < m_enemy_list.length ; i++){
				enemy_totle_combatnumb += m_enemy_list[i].combat;
			}
			CombatInfoPlane.text = enemy_totle_combatnumb;
		}
	}
}


var hero_show_list = undefined;
function showAllHero(hero_list_sign:Number){
	var filter_button_view;
	if (Is_supportOutsideHero){
		filter_button_view = _root.troops_selectHero.hero_filter_withoutside;
		_root.troops_selectHero.hero_filter._visible = false;
	}
	else{
		filter_button_view = _root.troops_selectHero.hero_filter;
		_root.troops_selectHero.hero_filter_withoutside._visible = false;
	}
	filter_button_view._visible = true;
	for (var i = s_list_all;i <= s_list_outside;++i){
		var fbtn = filter_button_view["filter_button_" + (i + 1)];
		if(fbtn){
			fbtn.gotoAndStop("Idle");
		}
	}

	var filter_button = filter_button_view["filter_button_" + (hero_list_sign + 1)];
	filter_button.gotoAndStop("release");
	var AllheroList = _root.troops_selectHero.HeroView.ViewList;
	AllheroList.clearListBox();
	AllheroList.initListBox("item_choose_hero_list",0,false,true);
	AllheroList.enableAutoArrowSet(true,AllheroList._parent._parent.last_arrow,AllheroList._parent._parent.next_arrow);
	AllheroList.enableDrag( true );
	AllheroList.onEnterFrame = function(){
		this.OnUpdate();
	}

	hero_show_list = m_hero_list[hero_list_sign];
	if(hero_show_list == undefined){
		hero_show_list = new Array();
	}

	AllheroList.onItemEnter = function(mc,index_item){
		var hero_data = hero_show_list[(index_item - 1)];
		var hero_item_mc = mc.hero_item;
		hero_item_mc.hero_data = hero_data;

		hero_item_mc.gotoAndStop( hero_data.is_enable ? "normal" : "disabled");
		if ( hero_data.hp_percent == 0 ){

			hero_item_mc.hero_icon.LC_UI_DEAD_CHAR._visible = true;
		}
		else{
			hero_item_mc.hero_icon.LC_UI_DEAD_CHAR._visible = false;
		}
		
		//hero_item_mc.level_info.level_text.text = hero_data.level;
		if (hero_item_mc.hero_icon.hero_icon.icons == undefined){
			hero_item_mc.hero_icon.hero_icon.loadMovie("CommonHeros.swf");
		}
		hero_item_mc.hero_icon.hero_icon.IconData = hero_data.icon_data;
		hero_item_mc.hero_icon.hero_icon.m_selected = hero_data.is_actived;
		if(hero_item_mc.hero_icon.hero_icon.UpdateIcon) { hero_item_mc.hero_icon.hero_icon.UpdateIcon(); }
		if(hero_item_mc.hero_icon.hero_icon.SelectIcon) { hero_item_mc.hero_icon.hero_icon.SelectIcon(); }

		hero_item_mc.hero_icon.level_info.level_text.text = hero_data.level;
		hero_item_mc.hero_icon.star_plane.star_view.gotoAndStop(hero_data.star);

		if (hero_data.cost != undefined){
			hero_item_mc._parent.outside_cost._visible = true;
			hero_item_mc._parent.outside_cost.cost_value.text = hero_data.cost;
		}
		else{
			hero_item_mc._parent.outside_cost._visible = false;
		}

		if (hero_data.hp_percent != undefined){
			var hp_frame = Math.floor(hero_data.hp_percent / 20) + 1;
			var shield =  Math.floor(hero_data.sheild_percent / 20) + 1;
			hero_item_mc._parent.bloodbar._visible = true;
			hero_item_mc._parent.bloodbar.shield.gotoAndStop(shield);
			hero_item_mc._parent.bloodbar.blood.gotoAndStop(hp_frame);
			hero_item_mc._parent.bloodbar.energy.gotoAndStop(hero_data.mp_percent + 1);
		}
		else{
			hero_item_mc._parent.bloodbar._visible = false;
		}


		hero_item_mc.onRelease = function(){
			this._parent._parent.onReleasedInListbox();
			if(Math.abs(this.Press_x - _root._xmouse) < this._width / 2 &&  Math.abs(this.Press_y - _root._ymouse) < this._height / 2){
				if (Is_Tutoria)
				{
					if (this.is_select == undefined)
					{
						heroMC_select(this);	
						this.is_select = true;
						/*******FTE*******/
						fscommand("TutorialCommand","TutorialComplete" + "\2" + "SelectHero");
						/*******End*******/	
					}
				}else
				{

					heroMC_select(this);
				}
				
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

	for( var i=1; i <= hero_show_list.length ; i++ )
	{   
	    AllheroList.addListItem(i, false, false);
	}
}

function SetTutoriaState( enable )
{
	Is_Tutoria = enable;
}

function heroMC_select(this_mc:Object){
	if (this_mc.hero_data.is_enable == false) {
		if(this_mc.hero_data.hp_percent == 0){
			fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "5");
		}
		else if(this_mc.hero_data.is_outside){
			fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "2");
		}
		else if(this_mc.hero_data.disable_reason != undefined)
		{
			fscommand("TroopsMgrCmd","TipCanNotTroop\2" + this_mc.hero_data.disable_reason);
		}
		else{
			fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "1");
		}
		return;
	}
	if (this_mc.hero_data.is_actived){
		this_mc.hero_data.is_actived = false;
		this_mc.hero_icon.hero_icon.SelectIcon(false);
		m_new_selected_rid = 0;
		refer_intoBattle_info(true);

		if(this_mc.hero_data.is_outside){
			m_has_employ = false;
		}
	}
	else if(m_heroIntoBattle_list.length < 6){
		if ( this_mc.hero_data.is_outside && m_has_employ){
			fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "4");
			return;
		}

		if ( check_heroid_inBattle(this_mc.hero_data.id) ){
			fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "3");
			return;
		}

		this_mc.hero_data.is_actived = true;
		this_mc.hero_icon.hero_icon.SelectIcon(true);
		m_heroIntoBattle_list.push(this_mc.hero_data);
		m_new_selected_rid = this_mc.hero_data.rid;
		refer_intoBattle_info(false);

		if(this_mc.hero_data.is_outside){
			m_has_employ = true;
		}
	}
	else{
		//intobattle list is full ! do nothing
	}
}



function init_filter_contral(){
	for(var j = 1; j <= 4 ; j++){
		var filter_button = _root.troops_selectHero.hero_filter["filter_button_" + j];
		filter_button.onRelease = function(){
			for(var i = 1; i <= 5 ; i++){
				fscommand("PlaySound", "sfx_ui_selection_1");
				//this._parent["filter_button_" + i].gotoAndStop("Idle");
				showAllHero(this.filter_sign);
			}
		}
		filter_button.filter_sign = j - 1;
	}
	for(var j = 1; j <= 5 ; j++){
		var filter_button = _root.troops_selectHero.hero_filter_withoutside["filter_button_" + j];
		filter_button.onRelease = function(){
			for(var i = 1; i <= 5 ; i++){
				fscommand("PlaySound", "sfx_ui_selection_1");
				//this._parent["filter_button_" + i].gotoAndStop("Idle");
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
}



function refer_PlayerTroops(PlayerTroopsInfoPlane:Object,CombatInfoPlane:Object){
	for( var i = 0; i < 6 ;i ++){
		var HeroInfo = m_heroIntoBattle_list[i];
		var HeroViewItem = PlayerTroopsInfoPlane["Hero_item_" + i];
		if(HeroViewItem.hero_icon.hero_icon.icons == undefined){
			HeroViewItem.hero_icon.hero_icon.loadMovie("CommonHeros.swf");
		}
		if(HeroInfo){
			HeroViewItem.hero_icon.level_info._visible = true;
			HeroViewItem.hero_icon.level_info.level_text.text = HeroInfo.level;
			HeroViewItem.hero_icon.star_plane._visible = true;
			HeroViewItem.hero_icon.star_plane.star_view.gotoAndStop(HeroInfo.star);
			HeroViewItem.hero_icon.hero_icon.IconData = HeroInfo.icon_data;
			if(HeroViewItem.hero_icon.hero_icon.UpdateIcon) { HeroViewItem.hero_icon.hero_icon.UpdateIcon(); }

			if (HeroInfo.hp_percent != undefined){
				var hp_frame = Math.floor(HeroInfo.hp_percent / 20) + 1;
				var shield =  Math.floor(HeroInfo.sheild_percent / 20) + 1;
				HeroViewItem.bloodbar.shield.gotoAndStop(shield);
				HeroViewItem.bloodbar.blood.gotoAndStop(hp_frame);
				HeroViewItem.bloodbar.energy.gotoAndStop(HeroInfo.mp_percent);
				HeroViewItem.bloodbar._visible = true;
			}
			else{
				HeroViewItem.bloodbar._visible = false;
			}
		}
		else{
			HeroViewItem.bloodbar._visible = false;
			HeroViewItem.hero_icon.hero_icon.IconData = undefined;
			if(HeroViewItem.hero_icon.hero_icon.UpdateIcon) { HeroViewItem.hero_icon.hero_icon.UpdateIcon(); }
			HeroViewItem.hero_icon.star_plane._visible = false;
			HeroViewItem.hero_icon.level_info._visible = false;
		}
	}

	if(CombatInfoPlane != undefined){
		var enemy_totle_combatnumb = 0;
		for (var i = 0 ;i < m_heroIntoBattle_list.length ; i++){
			enemy_totle_combatnumb += m_heroIntoBattle_list[i].combat;
		}
		CombatInfoPlane.text = enemy_totle_combatnumb;
	}
}

function refer_intoBattle_plus_btn(is_show_btn:Boolean){
	var IntoBattleList_view = _root.troops_hero_view.troops_hero_plane;
	for(var i = 0 ; i < 6 ; i ++){
		var view_item = IntoBattleList_view["troops_" + i];
		if(is_show_btn == false){
			view_item.plus_btn._visible = false;
		}else{
			if( m_heroIntoBattle_list[i]){
				view_item.plus_btn._visible = false;
			}
			else{
				view_item.plus_btn._visible = true;
			}
		}
	}
}


function check_heroid_inBattle(hero_id){
	var m_ret = false;
	for (var i = 0; i < m_heroIntoBattle_list.length ; i++){
		if ( m_heroIntoBattle_list[i].id == hero_id ){
			m_ret = true;
			break;
		}
	}
	return m_ret;
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
	var IntoBattleList_view = _root.troops_hero_view.troops_hero_plane;
	for(var i = 0 ; i < 6 ; i ++){
		var view_item = IntoBattleList_view["troops_" + i];
		if( m_heroIntoBattle_list[i]){
			if(view_item.heros.icons == undefined){
				view_item.heros.loadMovie("CommonHeros_body.swf");
			}
			view_item.heros.icons.gotoAndStop(m_heroIntoBattle_list[i].icon_data.icon_index);
			view_item.heros._visible = true;
			if (m_new_selected_rid == -1 || m_new_selected_rid == m_heroIntoBattle_list[i].rid){
				view_item.gotoAndPlay("hero_show");
			}
			else{
				view_item.gotoAndStop("hero_showed");
			}
			/*if(view_item.plus_btn._visible){
				view_item.plus_btn._visible = false;
				view_item.heros._visible = true;
				view_item.gotoAndPlay("hero_show");
			}*/
			IntoBattleList_view['name_' + i]._visible = true;
			IntoBattleList_view['name_' + i].name.name_text.text = m_heroIntoBattle_list[i].name;
			IntoBattleList_view['name_' + i].gotoAndPlay('hero_show');

			_root.troops_hero_view.troops_index_plane['index_' + i].gotoAndStop('left');
		}
		else{
			view_item.gotoAndStop(1);
			//view_item.plus_btn._visible = true;
			view_item.heros._visible = false;
			IntoBattleList_view['name_' + i]._visible = false;
			_root.troops_hero_view.troops_index_plane['index_' + i].gotoAndStop('middle');
		}
	}
	var PlayerTroopsPlane;
	if(Is_HasEnemy){
		PlayerTroopsPlane = _root.troops_selectHero.troops_info_withEnemys;
	}
	else{
		PlayerTroopsPlane = _root.troops_selectHero.troops_info;
	}
	refer_PlayerTroops(PlayerTroopsPlane.troops_attack, PlayerTroopsPlane.attack_combat_plane.combat_num_text);
}


function TutorialGetValidHeroItem(){
	var AllheroList = _root.troops_selectHero.HeroView.ViewList;
	for(var i = 1; i <= AllheroList.getItemListLength() ; ++ i){
		var mc = AllheroList.getMcByItemKey(i);
		if ( mc.hero_item.hero_data.is_enable && !mc.hero_item.hero_data.is_actived )
		{
			return mc.hero_item;
		}
	}
	return undefined;
}

//FTE
function FTEClickedListItem_One()
{
    var AllheroList = _root.troops_selectHero.HeroView.ViewList;
    var mc = AllheroList.getMcByItemKey(1)
    heroMC_select(mc)
}

function FTEClickedListItem_TWE()
{
    var AllheroList = _root.troops_selectHero.HeroView.ViewList;
    var mc = AllheroList.getMcByItemKey(2)
    heroMC_select(mc)
}