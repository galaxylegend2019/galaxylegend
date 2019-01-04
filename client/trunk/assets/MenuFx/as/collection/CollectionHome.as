var all_view_mov_object_list : Array = [ _root.home_info ,  _root.home_function , _root.home_npc ];
var all_view_static_object_list : Array = [ ];
var Is_MovedIn : Boolean = false;


this.onLoad = function(){
	init();
	//move_in();
}
//_root.home_info.onMoveOutOver = re_move_in;

//_root.onAllMoveOut = re_move_in;

function re_move_in(){
	move_in();
}



function init(){
	init_function_area();
	switch_collect_mode();
	reset();
}

function reset(){
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
	Is_MovedIn = true;
}

function move_out(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndPlay("closing_ani");
	}
	Is_MovedIn = false;
}

function init_function_area(){
	_root.home_info.exit_btn.onRelease = function(){
		_root.home_info.onMoveOutOver = function(){
			reset();
			fscommand("GotoNextMenu","GS_MainMenu");
			this.onMoveOutOver = undefined;
		}
		move_out();
	}

	//plunder_plane
	_root.home_function.plunder_plane.onPress = function(){
		this.gotoAndStop("button_on_press");
	}

	_root.home_function.plunder_plane.onReleaseOutside = function(){
		this.gotoAndStop("button_normal");
	}

	_root.home_function.plunder_plane.onRelease = function(){
		this.gotoAndStop("button_normal");
		_root.home_info.onMoveOutOver = function(){
			reset();
			fscommand("GoToNext","CollectionPlunder");
			this.onMoveOutOver = undefined;
		}
		move_out();
	}
	//end plunder_plane

	//crystal_plane
	_root.home_function.crystal_plane.onPress = function(){
		this.gotoAndStop("button_on_press");
	}

	_root.home_function.crystal_plane.onReleaseOutside = function(){
		this.gotoAndStop("button_normal");
	}

	_root.home_function.crystal_plane.onRelease = function(){
		this.gotoAndStop("button_normal");
		_root.home_info.onMoveOutOver = function(){
			reset();
			fscommand("GoToNext","CollectionSearch");
			this.onMoveOutOver = undefined;
		}
		move_out();
	}
	//end crystal_plane

	//gas_plane
	_root.home_function.gas_plane.onPress = function(){
		this.gotoAndStop("button_on_press");
	}

	_root.home_function.gas_plane.onReleaseOutside = function(){
		this.gotoAndStop("button_normal");
	}

	_root.home_function.gas_plane.onRelease = function(){
		this.gotoAndStop("button_normal");
		_root.home_info.onMoveOutOver = function(){
			reset();
			fscommand("GoToNext","CollectionSearch");
			this.onMoveOutOver = undefined;
		}
		move_out();
	}
	//end gas_plane


	//history_btn
	_root.home_info.history_btn.onPress = function(){
		this.gotoAndStop("button_on_press");
	}
	_root.home_info.history_btn.onReleaseOutside = function(){
		this.gotoAndStop("button_normal");
	}

	_root.home_info.history_btn.onRelease = function(){
		this.gotoAndStop("button_normal");
		_root.home_info.onMoveOutOver = function(){
			reset();
			fscommand("GoToNext","History");
			this.onMoveOutOver = undefined;
		}
		move_out();
	}

	//end history_btn
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
		_root.home_info.onMoveOutOver = function(){
			reset();
			fscommand("GoToNext","Collection_State")
			this.onMoveOutOver = undefined;
		}
		move_out();
	}
	return false;
}