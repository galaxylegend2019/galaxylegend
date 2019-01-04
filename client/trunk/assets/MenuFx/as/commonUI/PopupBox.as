var all_view_mov_object_list : Array = [ _root.ItemBoxUI ];

//iconType = 0 undefined
//iconType = 1 item or resource
//iconType = 2 hero
var m_iconType = 0;

var m_box_width = _root.ItemBoxUI._width;
var m_box_height = _root.ItemBoxUI._height;

this.onLoad = function(){
	init();
}

function init(){
	for(var i = 0;i < all_view_mov_object_list.length;++i){
		all_view_mov_object_list[i].gotoAndStop(1);
		all_view_mov_object_list[i]._visible = false;
	}

	_root.btn_bg.onRelease = function(){
		close_all_box();
	}

	m_iconType = 0;
}


function close_all_box(){
	for(var i = 0;i < all_view_mov_object_list.length;++i){
		var box_view = all_view_mov_object_list[i];
		if(box_view._visible){
			box_view.gotoAndPlay("closing_ani");
			box_view.onMoveOutOver = function(){
				this._visible = false;
				_root.btn_bg._visible = false;
			}
		}
	}
}

function show_icon_info(item_info_object:Object,show_x:Number,show_y:Number){
	var box_view = _root.ItemBoxUI;
	if ( m_iconType == 1 ){
		if (item_info_object.icon_data.res_type == "hero"){
			//box_view.PopboxView.reward_icon.item_icon.unloadMovie();
			box_view.PopboxView.reward_icon.item_icon.loadMovie("CommonHeros.swf");
			m_iconType = 2;
		}
	}
	else if (m_iconType == 2){
		if (item_info_object.icon_data.res_type != "hero"){
			//box_view.PopboxView.reward_icon.item_icon.unloadMovie();
			box_view.PopboxView.reward_icon.item_icon.loadMovie("CommonIcons.swf");
			m_iconType = 1;
		}
	}
	else{
		if (item_info_object.icon_data.res_type == "hero"){
			box_view.PopboxView.reward_icon.item_icon.loadMovie("CommonHeros.swf");
			m_iconType = 2;
		}
		else{
			box_view.PopboxView.reward_icon.item_icon.loadMovie("CommonIcons.swf");
			m_iconType = 1;
		}
	}

	box_view.PopboxView.reward_icon.item_icon.IconData = item_info_object.icon_data
	if(box_view.PopboxView.reward_icon.item_icon.UpdateIcon) box_view.PopboxView.reward_icon.item_icon.UpdateIcon();
	box_view.PopboxView.name_plane.text = item_info_object.item_name;
	if (item_info_object.req_level == 0)
	{
		box_view.PopboxView.lv_lable._visible = false;
	}else
	{
		box_view.PopboxView.lv_lable._visible = true;
		box_view.PopboxView.lv_lable.html = true
		box_view.PopboxView.lv_lable.htmlText = item_info_object.req_levelTxt;
	}
	
	box_view.PopboxView.desc_plane.text = item_info_object.item_desc;
	if(m_box_width + show_x >= _root._width){
		show_x = _root._width - m_box_width - 10;
	}
	if(m_box_height + show_y >= _root._height){
		show_y = _root._height - m_box_height - 10 ;
	}
	box_view._x = show_x;
	box_view._y = show_y;
	box_view._visible = true;
	box_view.gotoAndPlay("opening_ani");
	_root.btn_bg._visible = true;
}

