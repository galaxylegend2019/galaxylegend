var all_view_mov_object_list : Array = [ _root.RegionTop, _root.mian_ui ,  _root.btn_bg ];
var all_view_static_object_list : Array = [ ];

var rush_data:Object = undefined
var show_round_index = 0;
var TopUI = _root.RegionTop

function initTastData(){
	rush_data = new Object();
	rush_data.plyer_exp = 2;
	rush_data.rush_round = new Array();
    for(var i = 0;i < 2 ; i++){
		var round_item = new Object();
		round_item.round_description = i + 1;//"round : " + (i + 1);
		round_item.money = 5;
		round_item.rewards = new Array();
		for(var j = 1; j < i + 2 ; j++){
			var reward_item = new Object();
			reward_item.icon_data = new Object();
			reward_item.icon_data.icon_index = "item_102"
			reward_item.icon_data.icon_quality = 2;
			reward_item.count = 2;
			round_item.rewards.push(reward_item);
		}
		rush_data.rush_round.push(round_item);
	}
	rush_data.ex_rewards = new Array();
	var ex_reward_item = new Object;
	ex_reward_item.count = 5;
	ex_reward_item.icon_data = new Object();
	ex_reward_item.icon_data.icon_index = "item_102"
	ex_reward_item.icon_data.icon_quality = 2;
	rush_data.ex_rewards.push(ex_reward_item);
}

function initRaidsData(m_data){
	rush_data = m_data;
}


this.onLoad = function(){
    init();
    // initTastData();
    // move_in();
}


function init(){
	init_function_area();
	reset();

	_root.mian_ui.round_list.OnUpDone = function(){
		if(show_round_index >= rush_data.rush_round.length){
			if(show_round_index == 2){
				_root.mian_ui.round_list.stop();
			}
			else if( show_round_index == 3 ){
				//_root.mian_ui.round_list.stop();
				_root.mian_ui.round_list.gotoAndPlay("final_up");
                _root.RegionTop.btn_close.enabled = true;
			}
			else{
				refeash_end_data(4);
				_root.mian_ui.round_list.round_4._visible = true;
				_root.mian_ui.round_list.round_4.round_content.gotoAndPlay("opening_ani");
				fscommand("PlaySound","sfx_ui_mopup");
				_root.mian_ui.round_list.gotoAndPlay("final_up");
                _root.RegionTop.btn_close.enabled = true;
			}
		}
		else{
			show_round_index ++;
			refeash_all_round_data(show_round_index - 2,4);
			_root.mian_ui.round_list.round_4.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");
			this.gotoAndPlay(1);
		}
		
	}
}

function reset(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object.gotoAndStop(1);
		view_object._visible = false;
	}
	_root.mian_ui.round_list.gotoAndStop(1);
	for(var i = 1 ; i <= 4 ; i++){
		_root.mian_ui.round_list["round_" + i].round_content.gotoAndStop(1);
		_root.mian_ui.round_list["round_" + i]._visible = false;
	}
}

function init_function_area(){
	_root.RegionTop.btn_close.onRelease = function(){
		//refeash_all_round_data(1,1);
		move_out();
	}
}


function move_in(){
    _root.RegionTop.btn_close.enabled = false;
	_root.btn_bg._visible = true;
	_root.btn_bg.onRelease=function()
	{

	}

	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = true;
		view_object.gotoAndPlay("opening_ani");
	}

	if(rush_data.rush_round.length == 1){
		refeash_all_round_data(1,1);
		_root.mian_ui.round_list.round_1.round_content.OnMovedIn = function(){
			refeash_end_data(2);
			_root.mian_ui.round_list.round_2._visible = true;
			_root.mian_ui.round_list.round_2.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");			
			show_round_index = 1;
            _root.RegionTop.btn_close.enabled = true;
		}
	}
	else if(rush_data.rush_round.length == 2){
		refeash_all_round_data(1,2);
		_root.mian_ui.round_list.round_1.round_content.OnMovedIn = function(){
			_root.mian_ui.round_list.round_2._visible = true;
			_root.mian_ui.round_list.round_2.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");			
			show_round_index = 2;
		}
		_root.mian_ui.round_list.round_2.round_content.OnMovedIn = function(){
			refeash_end_data(3);
			_root.mian_ui.round_list.round_3._visible = true;
			_root.mian_ui.round_list.round_3.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");			
			_root.mian_ui.round_list.play();
            _root.RegionTop.btn_close.enabled = true;
		}
	}
	else if(rush_data.rush_round.length == 3){

		refeash_all_round_data(1,3);
		_root.mian_ui.round_list.round_1.round_content.OnMovedIn = function(){
			_root.mian_ui.round_list.round_2._visible = true;
			_root.mian_ui.round_list.round_2.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");			
			show_round_index = 2;
		}
		_root.mian_ui.round_list.round_2.round_content.OnMovedIn = function(){
			_root.mian_ui.round_list.round_3._visible = true;
			_root.mian_ui.round_list.round_3.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");			
			show_round_index = 3;
		}
		_root.mian_ui.round_list.round_3.round_content.OnMovedIn = function(){
			refeash_end_data(4);
			_root.mian_ui.round_list.round_4._visible = true;
			_root.mian_ui.round_list.round_4.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");
			_root.mian_ui.round_list.play();
		}
	}
	else{
		refeash_all_round_data(1,4);
		_root.mian_ui.round_list.round_1.round_content.OnMovedIn = function(){
			_root.mian_ui.round_list.round_2._visible = true;
			_root.mian_ui.round_list.round_2.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");			
			show_round_index = 2;
		}
		_root.mian_ui.round_list.round_2.round_content.OnMovedIn = function(){
			_root.mian_ui.round_list.round_3._visible = true;
			_root.mian_ui.round_list.round_3.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");
			show_round_index = 3;
		}
		_root.mian_ui.round_list.round_3.round_content.OnMovedIn = function(){
			_root.mian_ui.round_list.round_4._visible = true;
			_root.mian_ui.round_list.round_4.round_content.gotoAndPlay("opening_ani");
			fscommand("PlaySound","sfx_ui_mopup");
			_root.mian_ui.round_list.play();
		}
	}
	_root.mian_ui.OnMovedIn = function(){
		this.round_list.round_1._visible = true;
		this.round_list.round_1.gotoAndStop("round_normal");
		this.round_list.round_1.round_content.gotoAndPlay("first_round_openging_ani");
		fscommand("PlaySound","sfx_ui_mopup");
	}
}

function move_out(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = true;
		view_object.gotoAndPlay("closing_ani");
	}
	for(var i = 1; i <= 3 ; i ++ ){
		if ( _root.mian_ui.round_list["round_" + i]._visible ) _root.mian_ui.round_list["round_" + i].round_content.gotoAndPlay("closing_ani");
	}

	_root.btn_bg._visible=false
}


_root.mian_ui.OnMoveOutOver = function(){
	_root.btn_bg._visible = false;
	reset();
	fscommand("PveMgrCmd","CloseUI")
}

function refeash_round_data(round_plane_index:Number,round_index:Number){
	var round_plane = _root.mian_ui.round_list["round_" + round_plane_index];
	round_plane.gotoAndStop("round_normal");
	round_plane.round_content.round_title_plane.round_text.text =  rush_data.rush_round[round_index - 1].round_description
	round_plane.round_content.exp_plane.exp_value_text.text = rush_data.plyer_exp;
	round_plane.round_content.money_plane.money_value_text.text = rush_data.rush_round[round_index - 1].money;

	var rewards_data_list = rush_data.rush_round[round_index - 1].rewards;
	for(var i = 0; i < 7; i ++){
		var item_icon_view = round_plane.round_content["item_" + i].reward_icon;
		if(item_icon_view.item_icon.icons == undefined){
			item_icon_view.item_icon.loadMovie("CommonIcons.swf");
		}
		if(rewards_data_list[i] == undefined){
			item_icon_view.item_icon.IconData = undefined;
            item_icon_view.item_num._visible = false;
            item_icon_view._visible = false;
		}
		else{
			item_icon_view.item_icon.IconData = rewards_data_list[i].icon_data;
			item_icon_view.item_num._visible = true;
			item_icon_view.item_num.text = 'x ' +  rewards_data_list[i].count
		}
		if (item_icon_view.item_icon.UpdateIcon) { item_icon_view.item_icon.UpdateIcon(); }
	}
}

function refeash_end_data(round_plane_index){
	var round_plane = _root.mian_ui.round_list["round_" + round_plane_index];
	round_plane.gotoAndStop("round_end");
	var rewards_data_list = rush_data.ex_rewards;
	for(var i = 0; i < 7; i ++){
		var item_icon_view = round_plane.round_content["item_" + i].reward_icon;
		if(item_icon_view.item_icon.icons == undefined){
			item_icon_view.item_icon.loadMovie("CommonIcons.swf");
		}
		if(rewards_data_list[i] == undefined){
			item_icon_view.item_icon.IconData = undefined;
            item_icon_view.item_num._visible = false;
            item_icon_view._visible = false
		}
		else{
			item_icon_view.item_icon.IconData = rewards_data_list[i].icon_data;
			item_icon_view.item_num._visible = true;
			item_icon_view.item_num.text = 'x ' +  rewards_data_list[i].count
		}
		if (item_icon_view.item_icon.UpdateIcon) { item_icon_view.item_icon.UpdateIcon(); }
	}

}

function refeash_all_round_data(start_round_index:Number,len:Number){
	for(var i = 0 ; i < len ; i ++){
		refeash_round_data(i + 1 , start_round_index + i);
	}
}

function SetMoneyData(datas)
{
    TopUI.money.money_text.text = datas.money;
    TopUI.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    trace("777777777777777777")
    var energyBtn = TopUI.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}
