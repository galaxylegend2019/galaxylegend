var all_view_mov_object_list : Array = [ _root.main_ui , _root.npc_ui , _root.content_ui ];
var all_view_static_object_list : Array = [ ];
var Is_MovedIn : Boolean = false;




this.onLoad = function(){
	init();
	//move_in();
}

function init(){
	reset();
	init_function_area();
	_root.content_ui.OnMoveInOver = function(){
		fscommand("CollectionCommand","UpdateHistoryList");
	}
	//_root.content_ui.OnMoveOutOver = function(){
	//	clearList();
	//}
}

function init_function_area(){
	_root.main_ui.exit_btn.onRelease = function(){
		if(m_FightList != undefined){
			fscommand("CollectionCommand","SetCurCollectionHistory");
			m_FightList = undefined;
			_root.content_ui.OnMoveOutOver = function(){
				this.OnMoveOutOver = undefined;
				var item_list = _root.content_ui.content_list.itemlist;
				item_list.clearListBox();
				this.gotoAndPlay("opening_ani");
			}
			_root.content_ui.gotoAndPlay("closing_ani");
		}
		else{
			move_out();
			main_ui.OnMoveOutOver = function(){
				fscommand("CollectionCommand","SetCurCollectionHistory");
					fscommand("ExitBack");
					this.OnMoveOutOver = undefined;
					reset();
			}
		}
	}
}

function reset(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndStop("opening_ani");
		all_view_mov_object_list[i]._visible = false;
	}
	clearList();
}

function move_in(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndPlay("opening_ani");
		all_view_mov_object_list[i]._visible = true;
	}
}

function move_out(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndPlay("closing_ani");
	}
}


var m_HistoryList = undefined;
function refeashHistoryList(HistoryList:Array){
	var item_list = _root.content_ui.content_list.itemlist;
	item_list.clearListBox();
	item_list.setAddEraseFactor( -0.3 , 1);
	item_list.initListBox("defence_record_list",0,true,true);
	item_list.enableDrag( true );
	item_list.onEnterFrame = function(){
		this.OnUpdate();
	}
	m_HistoryList = HistoryList;
	item_list.onItemEnter = function(mc,index_item){
		var history_item_info = m_HistoryList[index_item - 1];
		mc.collection_id = history_item_info.Collection_id;
		mc.result_sign.gotoAndStop(history_item_info.Is_Win ? "win" : "lose");
		mc.hero_icon.icon_frame.gotoAndStop(history_item_info.Is_Win ? "win" : "lose");
		mc.btn_get_award._visible = history_item_info.Have_award;
		mc.btn_detail.onRelease = function(){
			_root.content_ui.gotoAndPlay("closing_ani");
			fscommand("CollectionCommand","SetCurCollectionHistory\2" + this._parent.collection_id);
			_root.content_ui.OnMoveOutOver = function(){
				this.OnMoveOutOver = undefined;
				var item_list = _root.content_ui.content_list.itemlist;
				item_list.clearListBox();
				this.gotoAndPlay("opening_ani");
			}
		}
		mc.gotoAndPlay("opening_ani");
	}

	for( var i=1; i <= HistoryList.length; i++ )
	{   
	    item_list.addListItem(i, false, false);
	}
}

var m_FightList = undefined;
function refeashFightList(FightList:Array){
	var item_list = _root.content_ui.content_list.itemlist;
	item_list.clearListBox();
	item_list.setAddEraseFactor( -0.3 , 1);
	item_list.initListBox("defence_record_list_play",0,true,true);
	item_list.enableDrag( true );
	item_list.onEnterFrame = function(){
		this.OnUpdate();
	}
	m_FightList = FightList;
	item_list.onItemEnter = function(mc,index_item){
		var item_fight_info = m_FightList[index_item - 1];
		mc.fight_id = item_fight_info.Fight_id;
		mc.player_1_info.combat_text.text = item_fight_info.Player_1_Combat;
		mc.player_2_info.combat_text.text = item_fight_info.Player_2_Combat;
		mc.btn_replay.onRelease = function(){
			fscommand("Debug",this._parent.fight_id);
		}
		mc.gotoAndPlay("opening_ani");
	}

	for( var i=1; i <= FightList.length; i++ )
	{   
	    item_list.addListItem(i, false, false);
	}
}

function clearList(){
	var item_list = _root.content_ui.content_list.itemlist;
	item_list.clearListBox();
}