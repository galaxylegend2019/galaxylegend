

var win_data:Object = undefined;

_root.onLoad = function(){
	//create_test_data();
	init();
	//show_result(true);
}


function create_test_data(){
	var test_hero_id_list = ["Clotho","Apollo","Crius","Prometheus","takezo","Avatar","Hero","Medic","Rhinoceros","Tenzai","Zero"];
	win_data = new Object();
	win_data.star = 2;
	win_data.reward_money = 862;
	win_data.old_player_exp_percent = 50;
	win_data.reward_player_exp = 843;
	win_data.new_player_exp_percent = 90;
	//win_data.old_player_level = 9;
	//win_data.new_player_level = 10;
	win_data.player_level = 9;
	win_data.is_player_uplv = true;
	win_data.heroList = new Array();
	for(var i = 0; i < 5 ; i ++){
		var hero_item = new Object();
		hero_item.head_id = test_hero_id_list[i];
		hero_item.hero_level = 15;
		hero_item.hero_exp = 32;
		hero_item.hero_old_exp_percent = 20; //
		hero_item.hero_new_exp_percent = 20; //
		hero_item.hero_up_level = i; //
		//hero_item.hero_is_uplv = i % 2 == 0 ? true : false; //del
		win_data.heroList.push(hero_item);
	}
	win_data.reward_list = new Array()
	for(var i = 0; i < 4; i++){
		var reward_item = new Object();
		reward_item.item_id = "item_" + (101 + i);
		reward_item.description = "item-" + reward_item.item_id;
		win_data.reward_list.push(reward_item);
	}
}

function init(){
	_root.main_ui.gotoAndStop("init");	
	_root.btn_bg._visible = false;
}

function initWinData(WinData:Object){
	win_data = WinData;
}

//fte call
function ClickWinExitBtn()
{
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickBattleResultBackBtn");
	/*******End*******/
	_root.main_ui.win_ui.gotoAndPlay("closing_ani");
	_root.main_ui.win_ui.OnMoveOutOver = function(){ /*_root.btn_bg._visible = false;*/ fscommand("GoToNext"); }
}
//fte call
function ClickLoseExitBtn()
{
	for(var i = 1; i <= 4 ; i++){ _root.main_ui.lose_ui["button_" + i].gotoAndPlay("closing_ani"); }
	_root.main_ui.lose_ui.gotoAndPlay("closing_ani");
	_root.main_ui.lose_ui.OnMoveOutOver = function(){ /*_root.btn_bg._visible = false;*/ fscommand("GoToNext"); }
}

function show_result(isWin:Boolean,can_Reetry){
	if(isWin){
		_root.main_ui.gotoAndStop("battle_win");
		_root.btn_bg._visible = true;
		fscommand("PlaySound","sfx_ui_victory")
		for(var i = 1; i <= 3 ;i ++){
			_root.main_ui.win_ui["star_" + i]._visible = i <= win_data.star ? true : false;
			_root.main_ui.win_ui["star_s" + i]._visible = i <= win_data.star ? true : false;
		}
		_root.main_ui.win_ui.gotoAndPlay("opening_ani");
		set_player_exp_data();
		set_hero_list();
		set_rewards_item_view();
		_root.main_ui.win_ui.OnEnterStage = function(){
			show_player_exp();
			show_reward_money();
		}
		_root.main_ui.win_ui.OnMoveInOver = function(){
			fscommand("TutorialCommand","Activate\2PVE_BATTLEWIN_READY");
			show_hero_exp();
		}

		_root.main_ui.win_ui.btn_exit.onRelease = function(){
			ClickWinExitBtn();
		}

		if (can_Reetry == true){
			_root.main_ui.win_ui.btn_battle_agin._visible = true;
			_root.main_ui.win_ui.btn_battle_agin.onRelease = function(){
				_root.main_ui.win_ui.gotoAndPlay("closing_ani");
				_root.main_ui.win_ui.OnMoveOutOver = function(){ fscommand("GoToNext","ReEnterGate"); }
			}
		}
		else{
			_root.main_ui.win_ui.btn_battle_agin._visible = false;
		}
		//fscommand("PlaySound","sfx_ui_victory_star_level_up_scoRe")
	}
	else{
		_root.main_ui.gotoAndStop("battle_lose");
		_root.btn_bg._visible = true;
		for(var i = 1; i <= 4 ; i++){
			_root.main_ui.lose_ui["button_" + i].button_icon.gotoAndStop(i);
		}

		_root.main_ui.lose_ui.OnMoveInOver = function(){
			fscommand("TutorialCommand","Activate\2PVE_BATTLELOSE_READY");
		}

		_root.main_ui.lose_ui.btn_exit.onRelease = function(){
			ClickLoseExitBtn();
		}

		_root.main_ui.lose_ui.button_1.onRelease = function(){
			for(var i = 1; i <= 4 ; i++){ _root.main_ui.lose_ui["button_" + i].gotoAndPlay("closing_ani"); }
			_root.main_ui.lose_ui.gotoAndPlay("closing_ani");
			_root.main_ui.lose_ui.OnMoveOutOver = function(){ fscommand("GotoNextMenu","GS_Gacha"); }
		}

		_root.main_ui.lose_ui.button_2.onRelease = function(){
			for(var i = 1; i <= 4 ; i++){ _root.main_ui.lose_ui["button_" + i].gotoAndPlay("closing_ani"); }
			_root.main_ui.lose_ui.gotoAndPlay("closing_ani");
			_root.main_ui.lose_ui.OnMoveOutOver = function(){ fscommand("HeroCommand","SetHeroPath\2skill"); /*fscommand("GotoNextMenu","GS_HeroPage");*/ }
		}

		_root.main_ui.lose_ui.button_3.onRelease = function(){
			/*******FTE*******/
			fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickGoToEquipBtn");
			/*******End*******/
			for(var i = 1; i <= 4 ; i++){ _root.main_ui.lose_ui["button_" + i].gotoAndPlay("closing_ani"); }
			_root.main_ui.lose_ui.gotoAndPlay("closing_ani");
			_root.main_ui.lose_ui.OnMoveOutOver = function(){ fscommand("HeroCommand","SetHeroPath\2equip"); /*fscommand("GotoNextMenu","GS_HeroPage");*/ }
		}
	}
}

function set_player_exp_data(){
	var player_exp_plane = _root.main_ui.win_ui.player_exp_plane;
	player_exp_plane.gotoAndStop(win_data.old_player_exp_percent + 1);
	player_exp_plane.over_frame = win_data.new_player_exp_percent + 1;
}

function set_hero_list(){
	var reward_hero_plane = _root.main_ui.win_ui.rewards_ui_one;
	for(var i = 0; i < 6 ; i++){
		var hero_item_ui = reward_hero_plane["hero_item_" + (i + 1)];
		
		if(i < win_data.heroList.length){
			//exp bar
			hero_item_ui.hero_exp_bar._visible = true;
			hero_item_ui.hero_exp_bar.gotoAndStop(win_data.heroList[i].hero_old_exp_percent + 1);
			hero_item_ui.hero_exp_bar.over_frame = win_data.heroList[i].hero_new_exp_percent + 1;
			//trace("hero : " + i + " new_exp_percent : " + win_data.heroList[i].hero_new_exp_percent);

			hero_item_ui.hero_exp_bar.onEnterFrame = function(){
				if(this._currentframe >= this.over_frame && this._parent.up_level_time <= 0){
					this.stop();
				}
			}

			hero_item_ui.HeroUpLv = function(){
				this.level_data ++;
				this.hero_icon.level_info.level_text.text = this.level_data;
				this.hero_exp_bar.gotoAndPlay(1);
				this.hero_lv_up_plane.gotoAndPlay(1);
				this.up_level_time --;
				//trace("up_level_time : " + this.up_level_time);
			}

			hero_item_ui.hero_lv_up_plane._visible = true;
			hero_item_ui.hero_lv_up_plane.gotoAndStop(1);

			hero_item_ui.exp_num_plane._visible = true;
			hero_item_ui.exp_num_plane.gotoAndStop(1);

			hero_item_ui.hero_icon.level_info._visible = true;
			hero_item_ui.level_data = win_data.heroList[i].hero_level;
			hero_item_ui.up_level_time = win_data.heroList[i].hero_up_level;

			hero_item_ui.hero_icon.level_info.level_text.text = win_data.heroList[i].hero_level;
			//hero_item_ui.hero_icon.headIcon.gotoAndStop("hero_activited");
			if (hero_item_ui.hero_icon.headIcon.icons == undefined){
				hero_item_ui.hero_icon.headIcon.loadMovie("CommonHeros.swf");
			}
			hero_item_ui.hero_icon.headIcon.IconData = win_data.heroList[i].icon_data;
			if (hero_item_ui.hero_icon.headIcon.UpdateIcon) { hero_item_ui.hero_icon.headIcon.UpdateIcon(); }
			//hero_item_ui.hero_icon.headIcon.icons.gotoAndStop(win_data.heroList[i].head_id);

			var hero_exp = win_data.heroList[i].hero_exp;
			if (hero_exp > 0)
			{
				var hero_exp_num_stack = new Array();
				while(hero_exp > 0){
					hero_exp_num_stack.push(hero_exp % 10);
					hero_exp = Math.floor(hero_exp / 10);
				}
				for(var hero_exp_num_item_index = 1 ; hero_exp_num_item_index <= 3; hero_exp_num_item_index ++){
					if(hero_exp_num_stack.length > 0){
						hero_item_ui.exp_num_plane.exp_num_plane["exp_num_" + hero_exp_num_item_index]._visible = true;
						hero_item_ui.exp_num_plane.exp_num_plane["exp_num_" + hero_exp_num_item_index].gotoAndStop(hero_exp_num_stack.pop() + 1);
					}
					else{
						hero_item_ui.exp_num_plane.exp_num_plane["exp_num_" + hero_exp_num_item_index]._visible = false;
					}
				}
				hero_item_ui.exp_num_plane._visible = true;
			}else
			{
				hero_item_ui.exp_num_plane._visible = false;
			}
			
		}
		else{
			hero_item_ui.hero_icon.level_info._visible = false;
			hero_item_ui.hero_icon.headIcon.gotoAndStop("hero_empty");
			hero_item_ui.hero_lv_up_plane._visible = false;
			hero_item_ui.exp_num_plane._visible = false;
			hero_item_ui.hero_exp_bar._visible = false;
			hero_item_ui.Hero_up_lv = undefined;
		}
	}
}

function set_rewards_item_view(){
	var rewards_view = _root.main_ui.win_ui.rewards_ui_two;
	for(var i = 1;i <= 6 ; i++){
		var reward_item_data = win_data.reward_list[i - 1];
		if(reward_item_data == undefined){
			rewards_view["item_" + i]._visible = false;
		}
		else{
			rewards_view["item_" + i]._visible = true;
			rewards_view["item_" + i].text_plane.text = reward_item_data.description;
			if (rewards_view["item_" + i].item_icon.icons == undefined){
				rewards_view["item_" + i].item_icon.loadMovie("CommonIcons.swf");
			}
			rewards_view["item_" + i].item_icon.IconData = reward_item_data.icon_data;
			if (rewards_view["item_" + i].item_icon.UpdateIcon) { rewards_view["item_" + i].item_icon.UpdateIcon(); }
			rewards_view["item_" + i].item_id = reward_item_data.item_id;
			rewards_view["item_" + i].onRelease = function(){
				fscommand("PopupBoxMgrCmd","PopupItemInfo\2item\2" + this.item_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
			}
		}
	}
	rewards_view.gotoAndPlay(1);
}

function show_hero_exp(){
	//fscommand("PlaySound","sfx_ui_victory_star")
	var reward_hero_plane = _root.main_ui.win_ui.rewards_ui_one;
	for(var i = 0; i < 6 ; i++){
		var hero_item_ui = reward_hero_plane["hero_item_" + (i + 1)];
		//if(hero_item_ui.hero_lv_up_plane._visible) hero_item_ui.hero_lv_up_plane.gotoAndPlay(1);
		if(hero_item_ui.exp_num_plane._visible) hero_item_ui.exp_num_plane.gotoAndPlay(1);
		if(hero_item_ui.hero_exp_bar._visible){
			if(hero_item_ui.hero_exp_bar._currentframe != hero_item_ui.hero_exp_bar.over_frame || hero_item_ui.up_level_time != 0){
				hero_item_ui.hero_exp_bar.play();
			}
		}
	}
}

var plyer_exp_num_queue:Array = undefined;
var plyer_exp_num_item_stack:Array = undefined;
function show_player_exp(){
	var exp_num = win_data.reward_player_exp;
	plyer_exp_num_queue = new Array();
	plyer_exp_num_item_stack = new Array();
	do{
		plyer_exp_num_queue.push(exp_num % 10);
		exp_num = Math.floor(exp_num / 10);
	}while(exp_num > 0);

	var player_exp_num_plane = _root.main_ui.win_ui.player_exp_plane.num_plane.exp_num_plane;
	player_exp_num_plane._visible=exp_num>0
	for(var i = 1; i <= 3 ;i ++){
		if( i <= plyer_exp_num_queue.length ){
			player_exp_num_plane["exp_num_" + i]._visible = true;
			player_exp_num_plane["exp_num_" + i].gotoAndStop(1);
			plyer_exp_num_item_stack.push(player_exp_num_plane["exp_num_" + i]);
		}
		else{
			player_exp_num_plane["exp_num_" + i]._visible = false;
		}
	}

	if(win_data.is_player_uplv){
		while(plyer_exp_num_item_stack.length > 0){
			plyer_exp_num_item_stack.pop().gotoAndStop(plyer_exp_num_queue.shift() + 1);
		}
	}
	else{
		var cur_player_exp_num_item = plyer_exp_num_item_stack.pop();
		cur_player_exp_num_item.over_num = plyer_exp_num_queue.shift() + 1;
		cur_player_exp_num_item.onEnterFrame = function(){
			if(this._currentframe >= this.over_num){
				if(plyer_exp_num_item_stack.length > 0){
					var next_cur_player_exp_num_item = plyer_exp_num_item_stack.pop();
					next_cur_player_exp_num_item.over_num = plyer_exp_num_queue.shift() + 1;
					next_cur_player_exp_num_item.onEnterFrame = this.onEnterFrame;
					next_cur_player_exp_num_item.gotoAndPlay(1);
				}
				this.onEnterFrame = undefined;
				this.stop();
			}
		}
		cur_player_exp_num_item.gotoAndPlay(1);
	}
	player_exp_plane.num_plane.gotoAndPlay("exp_movein");

	var player_exp_plane = _root.main_ui.win_ui.player_exp_plane;

	if(win_data.is_player_uplv){
		player_exp_plane.is_last_loop = false;
	}
	else{
		player_exp_plane.is_last_loop = true;
	}


	player_exp_plane.level_text.text = win_data.player_level;
	//player_exp_plane.next_level_text.text = "LV " + (win_data.player_level + 1);
	player_exp_plane.Do_levelup = function(){
		this.is_last_loop = true;
		this.gotoAndPlay(1);
		this.level_text.text = win_data.player_level + 1;
		//this.next_level_text.text = win_data.player_level + 2;
	}



	if(win_data.old_player_exp_percent != win_data.new_player_exp_percent || win_data.is_player_uplv){
			player_exp_plane.onEnterFrame = function(){
			if(this._currentframe >= this.over_frame && this.is_last_loop){
				this.onEnterFrame = undefined;
				this.stop();
				this.num_plane.gotoAndPlay("exp_moveout");
			}
		}
		player_exp_plane.play();
	}
}


var money_num_queue:Array = undefined;
var money_num_item_stack:Array = undefined;
function show_reward_money(){
	var money_num = win_data.reward_money;
	var money_plane = _root.main_ui.win_ui.reward_money_plane;
	if(money_num == 0){
		money_plane._visible = false;
		return;
	}
	else{
		money_plane._visible = true;
	}
	money_num_queue = new Array();
	money_num_item_stack = new Array();
	do{
		money_num_queue.push(money_num % 10);
		money_num = Math.floor(money_num / 10);
	}while(money_num > 0);

	for(var i = 1; i <= 5 ;i ++){
		if( i <= money_num_queue.length ){
			money_plane["money_num_" + i]._visible = true;
			money_plane["money_num_" + i].gotoAndStop(1);
			money_num_item_stack.push(money_plane["money_num_" + i]);
		}
		else{
			money_plane["money_num_" + i]._visible = false;
		}
	}

	var cur_money_num_item = money_num_item_stack.pop();
	cur_money_num_item.over_num = money_num_queue.shift() + 1;
	cur_money_num_item.onEnterFrame = function(){
		if(this._currentframe == this.over_num){
			if(money_num_item_stack.length > 0){
				var next_cur_money_num_item = money_num_item_stack.pop();
				next_cur_money_num_item.over_num = money_num_queue.shift() + 1;
				next_cur_money_num_item.onEnterFrame = this.onEnterFrame;
				next_cur_money_num_item.gotoAndPlay(1);
			}
			this.onEnterFrame = undefined;
			this.stop();
		}
	}
	cur_money_num_item.gotoAndPlay(1);
}


function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.go_on._visible = false
	_root.fteanim.quit._visible = false
	
}
FTEHideAnim()