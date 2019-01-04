var PreformationList = new Array();
_root.uiid = undefined;

_root.onLoad=function()
{
	reset();
	//SetFormatListData([[],[],[]])
	//move_in();
}

_root.main_ui.pop_content.btn_close.onRelease = function(){
	move_out();		
}


function reset(){
	_root.main_ui.pop_content.gotoAndStop("opening_ani");
	_root.btn_bg._visible = false;
	_root.main_ui._visible = false;
}


function move_in(UIID){
	_root.uiid = UIID;
	_root.btn_bg._visible = true;
	_root.main_ui._visible = true;
	_root.main_ui.pop_content.gotoAndPlay("opening_ani");
}

function move_out(){
	_root.main_ui.pop_content.gotoAndPlay("closing_ani");
	_root.main_ui.pop_content.OnMoveOutOver = function(){
		fscommand("MapCommand","UIClose\2" + _root.uiid)
		reset();
	}
}

function RefreashFormations(){
	var FormationsView = _root.main_ui.pop_content.item_list.drag_list;
	FormationsView.clearListBox();
	FormationsView.initListBox("item_list",0,true,true);
	FormationsView.enableDrag( true );
	FormationsView.onEnterFrame = function(){
		this.OnUpdate();
	}

	FormationsView.onItemEnter = function(mc,index_item){
		var totle_combat_num = 0;
		var hero_data_list = PreformationList[index_item - 1];
		mc.formation_index = index_item;
		mc.index_plane.index_number.text = mc.formation_index;
		for ( var i = 1 ; i <= 6 ; i ++ ){
			var hero_view_item = mc["item" + i]
			var hero_data = hero_data_list[i - 1];
			if (hero_view_item.icon_info.icon_info.icons == undefined){
				hero_view_item.icon_info.icon_info.loadMovie("CommonHeros.swf");
			}
			if (hero_data == undefined){
				hero_view_item.blood.gotoAndStop(1);
				hero_view_item.icon_info.icon_info.IconData = undefined;
				hero_view_item.icon_info.star_plane._visible = false;
			}
			else{
				hero_view_item.blood.gotoAndStop(6);
				hero_view_item.icon_info.icon_info.IconData = hero_data.icon_data;
				hero_view_item.icon_info.star_plane._visible = true;
				hero_view_item.icon_info.star_plane.star.gotoAndStop(hero_data.star);
				totle_combat_num = hero_data.combat;
			}
			if(hero_view_item.icon_info.icon_info.UpdateIcon) { hero_view_item.icon_info.icon_info.UpdateIcon(); }
		}

		mc.btn_configure.onRelease = function(){
			fscommand("MapCommand","SetDefendFormation\2" + this._parent.formation_index);
		}

		mc.combat_plane.combat_text.text = totle_combat_num;
	}

	for( var i=1; i <= PreformationList.length ; i++ )
	{   
	    FormationsView.addListItem(i, false, false);
	}
}

function SetFormatListData( list_data:Array ){
	PreformationList = list_data;
	RefreashFormations();
}