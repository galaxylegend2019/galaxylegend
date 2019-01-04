import common.CTextEdit;
import com.tap4fun.utils.Utils;

var cur_channel_id = undefined;
var cur_channel_content = [];
var detail_is_move_in = false;

var chat_detail_view = _root.chat_main.content_all.talk_content;

_root.onLoad()
{
	_root.chat_summary_ui.chat_summary_ui.TxtInfo.TxtInfo.text = "";
	init();
	reset();
	MainUIOpen();
}
function MainUIOpen()
{
	_root.chat_summary_ui._visible = true;
	_root.chat_summary_ui.gotoAndPlay("opening_ani");
}

function MainUIClose()
{
	if ( _root.chat_summary_ui._visible )
	{
		_root.chat_summary_ui.gotoAndPlay("closing_ani");
	}
}

function init(){

	_root.chat_main.content_all.talk_content.inputbox.init("UIKeyboardTypeDefault", "FlashChatUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, false);
	_root.chat_main.content_all.talk_content.inputbox.setDefaultText('');
	_root.chat_main.content_all.talk_content.inputbox.setMaxLength(120);

	_root.chat_main.content_all.talk_content.list.initPosY = _root.chat_main.content_all.talk_content.list._y
	_root.chat_main.content_all.talk_content.btn_input.initPosY = _root.chat_main.content_all.talk_content.btn_input._y
	_root.chat_main.content_all.talk_content.content_mask.initPosY = _root.chat_main.content_all.talk_content.content_mask._y
	_root.chat_main.content_all.talk_content.inputbox.initPosY = _root.chat_main.content_all.talk_content.inputbox._y

	_root.chat_main.content_all.talk_content.inputbox.onChangeKeyBoardHeight = function ()
	{
		var heightChanded = Math.abs(_root.chat_main.content_all.talk_content.inputbox.GetHeightChange());
		trace("hellow heightChanded = " + heightChanded)
		trace("_root.chat_main.content_all.talk_content.content_mask.initPosY = " + _root.chat_main.content_all.talk_content.content_mask.initPosY)

		//_root.chat_main.content_all.talk_content.content_mask._y = _root.chat_main.content_all.talk_content.content_mask.initPosY - heightChanded
		_root.chat_main.content_all.talk_content.list._y = _root.chat_main.content_all.talk_content.list.initPosY - heightChanded
		_root.chat_main.content_all.talk_content.btn_input._y = _root.chat_main.content_all.talk_content.btn_input.initPosY - heightChanded
		//_root.chat_main.content_all.talk_content.inputbox._y = _root.chat_main.content_all.talk_content.inputbox.initPosY - heightChanded
		//trace("_root.chat_main.content_all.talk_content.content_mask._y = " + _root.chat_main.content_all.talk_content.content_mask._y)
	}

	_root.chat_main.content_all.talk_content.btn_input.onRelease = function(){
		var msg_text = _root.chat_main.content_all.talk_content.inputbox.getInputString();
		if (msg_text.length > 0)
		{
			fscommand("PlaySound", "sfx_ui_selection_3");
			fscommand("ChatMgrCmd","SendMessage\2" + msg_text)
			_root.chat_main.content_all.talk_content.inputbox.lua2fs_setText('');
		}
	}

	_root.chat_summary_ui.onRelease = function(){
		detail_move_in();
		hide_chat_summary();
	}

	_root.chat_main.hitzone.onRelease = function(){
		detail_move_out();
		show_chat_summary();
	}

	chat_detail_view.OnMovedIn = function(){
		fscommand("ChatMgrCmd","ChatDetailMoveIn");
	}

	chat_detail_view.OnMoveOutOver = function(){
		reset();
	}

	detail_is_move_in = false;

	refresh_channel_info([]);

	chat_detail_view.btn_close._visible = false;
}

function reset(){
	chat_detail_view.gotoAndStop("opening_ani");
	_root.chat_main._visible = false;
}

function detail_move_in()
{
	if ( detail_is_move_in ) { return; }
	chat_detail_view.gotoAndPlay("opening_ani");
	_root.chat_main._visible = true;
	fscommand("PlaySound", "sfx_ui_selection_2");
	detail_is_move_in = true;
}

function detail_move_out()
{
	if (detail_is_move_in == false ) { return ; }
	fscommand("ChatMgrCmd","ChatDetailMoveOut");
	chat_detail_view.gotoAndPlay("closing_ani");
	fscommand("PlaySound", "sfx_ui_cancel");
	detail_is_move_in = false;
}

function all_ui_move_out(){
	if (detail_is_move_in){
		fscommand("ChatMgrCmd","ChatDetailMoveOut");
		_root.chat_main.gotoAndPlay("closing_ani");
		_root.chat_main.content_all.talk_content.btn_close._visible = false;
		detail_is_move_in = false;
	}
	hide_chat_summary();
}

function show_chat_summary(){
	if ( _root.chat_summary_ui._visible == false){
		_root.chat_summary_ui._visible = true;
		_root.chat_summary_ui.gotoAndPlay("opening_ani");
	}
}

function hide_chat_summary(){
	if ( _root.chat_summary_ui._visible ){
		_root.chat_summary_ui.OnMoveOutOver = function(){ this._visible = false; }
		_root.chat_summary_ui.gotoAndPlay("closing_ani");
	}
}


function refresh_chat( channel_id:String , channel_content:Array ){
	cur_channel_content = channel_content;
	cur_channel_id = channel_id;

	var talk_plane = _root.chat_main.content_all.talk_content;
	for (var i = 0; i < 3 ; i++){
		if (talk_plane["chat_" + (i + 1)]._visible){
			talk_plane["chat_" + (i + 1)].gotoAndStop(talk_plane["chat_" + (i + 1)].channel_id == cur_channel_id ? "activited" : "normal" );
		}
	}

	var chat_list = _root.chat_main.content_all.talk_content.list;
	chat_list.clearListBox();
	chat_list.initListBox("item_list_chat",0,true,true);
	chat_list.enableDrag( true );
	chat_list.onEnterFrame = function(){
		this.OnUpdate();
	}


	chat_list.onItemEnter = function(mc,index_item){
		mc.content_data = cur_channel_content[index_item - 1];
		refresh_chat_item(mc,index_item);
	}

	for(var i = 1; i <= cur_channel_content.length ; i++){
		var force_show = (i == cur_channel_content.length);
		chat_list.addListItem(i, false, force_show);
	}
}

function refresh_chat_item(mc,index_item){
	mc.gotoAndStop(mc.content_data.chat_type);
	mc.chat_view.btn_translate.gotoAndStop("disabled");
	var item_view = mc.chat_view;
	var chat_data = mc.content_data;


	switch (chat_data.chat_type){
		case 'chat_self' :
		case 'chat_other' :
			item_view.uname_text.text = chat_data.uname;
			item_view.send_time.text = chat_data.sendtime_string;
			item_view.message_content.text = chat_data.text_content;
			item_view.message_bg_mid._height = item_view.message_content.textHeight - 20;
			item_view.message_bg_bottom._y = item_view.message_bg_mid._y + item_view.message_bg_mid._height;
			
			if (item_view.head_icon.hero_icons.icons == undefined){
				item_view.head_icon.hero_icons.loadMovie("CommonPlayerIcons.swf");
			}
			if (chat_data.head_data == undefined){
				item_view.head_icon.hero_icons.IconData = undefined;
			}
			else{
				item_view.head_icon.hero_icons.IconData = chat_data.head_data;
			}
			if(item_view.head_icon.hero_icons.UpdateIcon) { item_view.head_icon.hero_icons.UpdateIcon(); }

			break;
		case 'chat_server' :
			item_view.send_time.text = chat_data.sendtime_string;
			item_view.message_content.text = chat_data.text_content;
			item_view.message_bg_mid._height = item_view.message_content.textHeight - 20;
			item_view.message_bg_bottom._y = item_view.message_bg_mid._y + item_view.message_bg_mid._height;
			break;
		default:
	}
}

function add_chat(channel_content_item){
	cur_channel_content.push(channel_content_item);
	var chat_list = _root.chat_main.content_all.talk_content.list;
	var chat_index = chat_list.getItemListLength();
	var force_show = chat_list.isReachTailLimit();
	chat_list.addListItem(chat_index + 1, false, force_show);
}


function refresh_channel_info(channel_Info_liset){
	var talk_plane = _root.chat_main.content_all.talk_content;
	for (var i = 0; i < 3 ; i++){
		if ( channel_Info_liset[i] == undefined ){
			talk_plane["chat_" + (i + 1)]._visible = false;
			talk_plane["chat_" + (i + 1)].onRelease = undefined;
		}
		else{
			talk_plane["chat_" + (i + 1)]._visible = true;
			talk_plane["chat_" + (i + 1)].tips._visible = false;
			talk_plane["chat_" + (i + 1)].channel_id = channel_Info_liset[i].channel_id;
			talk_plane["chat_" + (i + 1)].tag_text.text_value.text = channel_Info_liset[i].channel_name;
			talk_plane["chat_" + (i + 1)].onRelease = function(){
				if ( cur_channel_id == this.channel_id ) { return ;}
				fscommand("PlaySound", "sfx_ui_selection_2");
				fscommand("ChatMgrCmd","SwitchChatGroupView\2" + this.channel_id);
			}
		}
	}
}

function set_chat_activited(is_activited : Boolean){
	chat_detail_view.Chat_disabled._visible = !is_activited;
}

function refresh_chat_summary(chat_str:String){
	_root.chat_summary_ui.chat_summary_ui.TxtInfo.TxtInfo.text = chat_str;
}