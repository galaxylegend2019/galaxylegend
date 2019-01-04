import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

var all_view_mov_object_list : Array = [ _root.enemyinfo_content ,  _root.RegionTop ];
var all_view_static_object_list : Array = [ ];
var Is_MovedIn : Boolean = false;

var PlayerInfoObject : Object = undefined;

var m_MaxRushTimes = 0;

this.onLoad = function(){
	init();
	//initTestData();
	//refreshUIData();
	//move_in();
	_root.enemyinfo_content.Enemy_Func_Plane.props._visible = false;
}

function init(){
	_root.enemyinfo_content.EneyInfo_Title.btn_chat._visible = false;
	init_function_area();
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = false;
		view_object.OnMoveOutOver = function(){
			this._visible = false;
		}
	}
	_root.enemyinfo_content.OnMoveOutOver = function(){
		this._visible = false;
		_root.OnAllMovedOut();
	}

	_root.bg._visible=false
}

function reset(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = false;
		view_object.gotoAndStop(1);
		init_function_area();
	}
}

//function initTestData(){
//	PlayerInfoObject = new Object();
//	PlayerInfoObject.totle_power = 50;
//	PlayerInfoObject.props = 3;
//}

function refreshUIData(m_EnemyInfoObject){
	_root.RegionTop.title.Gate_name_text.text = m_EnemyInfoObject.task_name;
	_root.enemyinfo_content.EneyInfo_Title.monster_name_view.monster_name_text.text = m_EnemyInfoObject.monster_name;
	_root.enemyinfo_content.EneyInfo_Title.Enemy_Level.LevelDescription_text.htmltext = m_EnemyInfoObject.level_description;
	_root.enemyinfo_content.EneyInfo_Title.Discription.DiscriptionText.text = m_EnemyInfoObject.discription;
	var star_info = _root.enemyinfo_content.EneyInfo_Title.Enemy_Star;
	for(var i = 1 ; i <= 3 ; i++){
		star_info["Star_" + i].gotoAndStop( i <= m_EnemyInfoObject.star ? "activited" : "idle" );
	}

	/*var boss_icon_view = _root.enemyinfo_content.EneyInfo_Title.Monster_Boss_Icon.item_icon;
	if(boss_icon_view.icons == undefined){
		boss_icon_view.loadMovie("CommonHeros.swf");
	}
	boss_icon_view.IconData = m_EnemyInfoObject.Boss_Icon_Data;
	if(boss_icon_view.UpdateIcon) { boss_icon_view.UpdateIcon(); }*/

	refreshAttachLimit(m_EnemyInfoObject.attack_limit_description,m_EnemyInfoObject.can_buy_attack_times);
	refreshMultiple_rush(m_EnemyInfoObject.multiple_rush_description,m_EnemyInfoObject.max_rush_times);

	var rewardsView = _root.enemyinfo_content.Enemy_Func_Plane.RewardView;
	for(var i = 0 ; i <= 6 ; i ++){
		var reward_info = m_EnemyInfoObject.rewards[i];
		if (rewardsView["item_" + i].item_icon.icons == undefined){
			rewardsView["item_" + i].item_icon.loadMovie("CommonIcons.swf");
		}
		if(reward_info == undefined){
			rewardsView["item_" + i]._visible = false;
			rewardsView["item_" + i].item_icon.IconData = undefined;
			//if (rewardsView["item_" + i].item_icon.UpdateIcon) { rewardsView["item_" + i].item_icon.UpdateIcon(); }
			//rewardsView["item_" + i].item_description.text = "";
			rewardsView["item_" + i].onPress = rewardsView["item_" + i].onRelease = rewardsView["item_" + i].onReleaseOutside = undefined;
		}
		else{
			rewardsView["item_" + i]._visible = true;
			rewardsView["item_" + i].item_icon.IconData = reward_info;
			if (rewardsView["item_" + i].item_icon.UpdateIcon) { rewardsView["item_" + i].item_icon.UpdateIcon(); }
			//rewardsView["item_" + i].reward_icon.item_icon.icons.gotoAndStop(reward_info.res_id == 0 ? reward_info.res_type : reward_info.res_type + '_' + reward_info.res_id);
			//rewardsView["item_" + i].item_description.text = reward_info.description;
			rewardsView["item_" + i].res_id = reward_info.res_id;
			rewardsView["item_" + i].res_type = reward_info.res_type;
			//rewardsView["item_" + i].onPress = function(){
			//	this.item_icon.SelectIcon(true);
				
			//}
			//rewardsView["item_" + i].onRelease = rewardsView["item_" + i].onReleaseOutside = function(){
			//	this.item_icon.SelectIcon(false);
			//	fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
			//}
			rewardsView["item_" + i].onRelease = function(){
				fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
			}
		}
	}

	refreshRushNote(m_EnemyInfoObject.rush_note_num);
	
}

function refreshRushNote(note_num:Number){
	_root.enemyinfo_content.Enemy_Func_Plane.props.rush_note_num_text.text = note_num;
}


function refreshAttachLimit(attack_limit_description:String,can_buy_times:Boolean){
	_root.enemyinfo_content.Attack_limit_info.LimitDiscriptionText.htmltext = attack_limit_description;
	if( can_buy_times ){
		_root.enemyinfo_content.Attack_limit_info.add_btn._visible = true;
	}
	else{
		_root.enemyinfo_content.Attack_limit_info.add_btn._visible = false;
	}
}

function refreshMultiple_rush(multiple_rush_description:String,max_rushtimes:Number){
	m_MaxRushTimes = max_rushtimes;
	_root.enemyinfo_content.Enemy_Func_Plane.raids_10times_btn.Rush_multiple_btn_text.text = multiple_rush_description;
}

function SetMoneyData(idata)
{
	_root.RegionTop.money_plane.money_text.text = idata.money
	_root.RegionTop.credit_plane.credit_text.text = idata.credit

}

function SetPointData(point)
{
    var energyBtn = _root.RegionTop.energy_plane
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

function move_in(){
	if( Is_MovedIn ) { return; }
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "EnemyInfoUILoad");
	/*******End*******/	
	fscommand("PveMgrCmd","RegTaskInfoCallback");
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object._visible = true;
		view_object.gotoAndPlay("opening_ani");
	}

	for(var i = 0 ; i < all_view_static_object_list.length ; i++){
		all_view_static_object_list[i]._visible = true;
	}

	Is_MovedIn = true;

	_root.bg._visible=true
	_root.bg.onRelease=function()
	{
	}


	fscommand("TutorialCommand","Activate" + "\2" + "OpenEnemyInfo");
}

function move_out(){
	if( !Is_MovedIn ) { return; }
	
	fscommand("PveMgrCmd","UnRegTaskInfoCallback");

	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		var view_object = all_view_mov_object_list[i];
		view_object.gotoAndPlay("closing_ani");
	}

	for(var i = 0 ; i < all_view_static_object_list.length ; i++){
		all_view_static_object_list[i]._visible = false;
	}
	Is_MovedIn = false;
	_root.bg._visible=false
}

function RealGoAttachPopup(){
	move_out();
	_root.OnAllMovedOut = function(){
		fscommand("GoToNext","AttackPopup");
	}
}


function init_function_area(){
	_root.RegionTop.btn_close.onRelease = function(){
		fscommand("PlaySound", "sfx_ui_cancel");
		move_out();
		_root.OnAllMovedOut = function(){
			reset();
			fscommand("ExitBack");
		}
	}

	_root.enemyinfo_content.Enemy_Func_Plane.fight_btn.onRelease = function(){
		fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickEnemyInfoFightBtn");
		fscommand("PlaySound", "sfx_ui_selection_1");
		fscommand("PveMgrCmd","SafeGoAttachPopup");
	}

	_root.enemyinfo_content.Enemy_Func_Plane.raids_btn.onRelease = function(){
		fscommand("PlaySound", "sfx_ui_selection_1");
		fscommand("PveMgrCmd","RaidsTask\2" + "1");
	}

	_root.enemyinfo_content.Enemy_Func_Plane.raids_10times_btn.onRelease = function(){
		fscommand("PlaySound", "sfx_ui_selection_1");
		fscommand("PveMgrCmd","RaidsTask\2" + m_MaxRushTimes);
	}

	_root.enemyinfo_content.Attack_limit_info.add_btn.onRelease = function(){
		fscommand("PlaySound", "sfx_ui_menu_appears");
		fscommand("PveMgrCmd","ResetAttackLimit");
	}


	/*_root.enemyinfo_content.raids_btn.LC_UI_PVE_Enemy_Information_Raids10_BTN._visible = false;
	_root.enemyinfo_content.raids_btn.LC_UI_PVE_Enemy_Information_Raids1_BTN._visible = true;
	_root.enemyinfo_content.raids_select_plane_1.check_box.gotoAndStop("Selected");
	_root.enemyinfo_content.raids_select_plane_1.onRelease = function(){
		_root.enemyinfo_content.raids_select_plane_10.check_box.gotoAndStop("Idle");
		_root.enemyinfo_content.raids_btn.LC_UI_PVE_Enemy_Information_Raids10_BTN._visible = false;
	_root.enemyinfo_content.raids_btn.LC_UI_PVE_Enemy_Information_Raids1_BTN._visible = true;
		this.check_box.gotoAndStop("Selected");
		raids_num = 1;
	}

	_root.enemyinfo_content.raids_select_plane_10.check_box.gotoAndStop("Idle");
	_root.enemyinfo_content.raids_select_plane_10.onRelease = function(){
		_root.enemyinfo_content.raids_select_plane_1.check_box.gotoAndStop("Idle");
		_root.enemyinfo_content.raids_btn.LC_UI_PVE_Enemy_Information_Raids10_BTN._visible = true;
	_root.enemyinfo_content.raids_btn.LC_UI_PVE_Enemy_Information_Raids1_BTN._visible = false;
		this.check_box.gotoAndStop("Selected");
		raids_num = 10;
	}*/
}

function FTEClickFightBtn()
{
	_root.enemyinfo_content.Enemy_Func_Plane.fight_btn.onRelease()
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.fight._visible = false
}

FTEHideAnim()