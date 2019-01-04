var all_view_mov_object_list : Array = [ _root.collection_mian_ui ,  _root.refresh_area];
var all_view_static_object_list : Array = [ ];
var Is_MovedIn : Boolean = false;

var m_collection_sign_list:Array = new Array();

this.onLoad = function(){
	init();
	//move_in();
}

function init(){
	init_function_area();
	reset();
}

function init_function_area(){
	_root.collection_mian_ui.btn_exit.onRelease = function(){
		_root.collection_mian_ui.onMoveOutOver = function(){
			this.onMoveOutOver = undefined;
			fscommand("ExitBack");
		}
		move_out();
	}

	_root.refresh_area.btn_refresh.onRelease = function(){
		_root.AllMiningSignMoveOutOver = function(){
			fscommand("SendEmptyMsgToUnity","MiningRaderSearch");
			//add_mining_sign(450,300,true);
			//add_mining_sign(500,500,false);
		}
		clear_mining_sign();
	}
}

function reset(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndStop("opening_ani");
		all_view_mov_object_list[i]._visible = false;
	}
	_root.collection_area_sign._visible = false;
}

function move_in(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i]._visible = true;
		all_view_mov_object_list[i].gotoAndPlay("opening_ani");
	}
	_root.collection_area_sign._visible = true;
	fscommand("SendEmptyMsgToUnity","MiningRaderSearch");

	Is_MovedIn = true;
	//test
	//add_mining_sign(450,350,true);
	//add_mining_sign(700,200,false);
}

function move_out(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndPlay("closing_ani");
	}
	_root.AllMiningSignMoveOutOver = undefined;
	clear_mining_sign();
	Is_MovedIn = false;
}
function add_mining_sign(x:Number , y:Number , isInfoLeft:Boolean){
	var sign_str = isInfoLeft ? "collection_sign_left" : "collection_sign_right";
	var new_mov =  _root.collection_area_sign.attachMovie(sign_str,"collection_sign_" + m_collection_sign_list.length,collection_area_sign.getNextHighestDepth());
	new_mov._x = x;
	new_mov._y = y;
	new_mov.gotoAndPlay("opening_ani");
	new_mov.onRelease = function(){
		 _root.collection_mian_ui.onMoveOutOver = function(){
			this.onMoveOutOver = undefined;
			fscommand("GoToNext","DoMining");
		}
		move_out();
	}
	m_collection_sign_list.push(new_mov);
}

function clear_mining_sign(){
	if(m_collection_sign_list.length == 0){
		if ( _root.AllMiningSignMoveOutOver ) _root.AllMiningSignMoveOutOver();
		return;
	}
	while(m_collection_sign_list.length > 0){
		var mov = m_collection_sign_list.pop();
		if(m_collection_sign_list.length == 0){
			mov.onMoveOutOver = function(){
				this.removeMovieClip();
				if ( _root.AllMiningSignMoveOutOver ) _root.AllMiningSignMoveOutOver();
			}
		}
		else{
			mov.onMoveOutOver = function(){
				this.removeMovieClip();
			}
		}
		mov.gotoAndPlay("closing_ani");
	}
}

var press_x = 0;
_root.onStagePress = function(){
	if(!Is_MovedIn) return false;
	press_x =  _root._xmouse;
	return false;
}

_root.onStageRelease = function(){
	if(!Is_MovedIn) return false;
	if(_root._xmouse - press_x > Stage.width * 0.4){
		_root.collection_mian_ui.onMoveOutOver = function(){
			this.onMoveOutOver = undefined;
			fscommand("GoToNext","Collection_State")
		}
		move_out();
	}
	return false;
}