import common.CTextEdit;
import com.tap4fun.utils.Utils;

var cur_channel_id = undefined;
var cur_channel_content = [];
var detail_is_move_in = false;

var chat_detail_view = _root.chat_main;
var chat_top = _root.top;
var chat_bg = _root.btn_bg
var chatTabName = undefined;

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

    _root.chat_main.inputbox.init("UIKeyboardTypeDefault", "FlashChatUI", "hitzone", "", "content_text", false, false, '', null, null, null, null, false);
    _root.chat_main.inputbox.setDefaultText('');
    _root.chat_main.inputbox.setMaxLength(256);

    _root.chat_main.list.initPosY = _root.chat_main.list._y
    _root.chat_main.btn_input.initPosY = _root.chat_main.btn_input._y
    _root.chat_main.content_mask.initPosY = _root.chat_main.content_mask._y
    _root.chat_main.inputbox.initPosY = _root.chat_main.inputbox._y

    _root.chat_main.inputbox.onChangeKeyBoardHeight = function ()
    {
        var heightChanded = Math.abs(_root.chat_main.inputbox.GetHeightChange());
        trace("hellow heightChanded = " + heightChanded)
        trace("_root.chat_main.content_all.talk_content.content_mask.initPosY = " + _root.chat_main.content_mask.initPosY)

        _root.chat_main.list._y = _root.chat_main.list.initPosY - heightChanded
        _root.chat_main.btn_input._y = _root.chat_main.btn_input.initPosY - heightChanded

        var chatList = _root.chat_main.list
        chatList.GetSuggestionPos(chatList.getItemListLength())
    }

    _root.chat_main.btn_input.onPress = function(){
        fscommand("ChatMgrCmd","SendMessagePress")
    }

    _root.chat_main.btn_input.onRelease = function(){
        var msg_text = _root.chat_main.inputbox.getInputString();
        trace("msg_text ===== " + msg_text)
        if (msg_text.length > 0)
        {
            fscommand("PlaySound", "sfx_ui_selection_3");
            fscommand("ChatMgrCmd","SendMessage\2" + msg_text)
            _root.chat_main.inputbox.lua2fs_setText('');
        }
    }

    _root.chat_summary_ui.onRelease = function(){
        detail_move_in();
        hide_chat_summary();
    }

    _root.chat_main.btn_bg.onRelease = _root.top.btn_close.onRelease = function(){
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

    // chat_detail_view.btn_close._visible = false;
}

_root.chat_main.inputbox.onTextChange = function(_text)
{
    var btnInput = _root.chat_main.btn_input;
    var tmpstr = Utils.ltrim(_text)
    if(tmpstr == "")
    {
        btnInput.gotoAndStop("disabled")
        btnInput.enabled = false
    }
    else
    {
        btnInput.gotoAndStop("Idle")
        btnInput.enabled = true
    }
}

function onReturnPressed()
{
    var sender = _root.chat_main.btn_input;
    if(sender.btn_send.enabled == false)
    {
        return
    }
    var msg_text = _root.chat_main.inputbox.getInputString();
    if (msg_text.length > 0)
    {
        fscommand("PlaySound", "sfx_ui_selection_3");
        fscommand("ChatMgrCmd","SendMessage\2" + msg_text)
        _root.chat_main.inputbox.lua2fs_setText('');
    }
}

function reset(){
    // chat_detail_view.gotoAndStop("opening_ani");
    chat_detail_view._visible = false;
    chat_top._visible = false;
    chat_bg._visible = false;
}

function detail_move_in()
{
    if ( detail_is_move_in ) { return; }
    chat_detail_view.gotoAndPlay("opening_ani");
    _root.top.gotoAndPlay("opening_ani");
    chat_detail_view._visible = true;
    chat_top._visible = true;
    chat_bg._visible = true;
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
        _root.top.gotoAndPlay("closing_ani");
        // _root.chat_main.content_all.talk_content.btn_close._visible = false;
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

var chat_list = _root.chat_main.list;
chat_list.onEnterFrame = function()
{
    this.OnUpdate();
}
chat_list.onItemEnter = function(mc,index_item)
{
    mc.content_data = cur_channel_content[index_item - 1];
    refresh_chat_item(mc,index_item);
}

function refresh_chat( channel_id:String , channel_content:Array ){
    cur_channel_content = channel_content;
    cur_channel_id = channel_id;

    var talk_plane = _root.chat_main;
    for (var i = 0; i < 3 ; i++){
        if (talk_plane["chat_" + (i + 1)]._visible){
            talk_plane["chat_" + (i + 1)].gotoAndStop(talk_plane["chat_" + (i + 1)].channel_id == cur_channel_id ? "activited" : "normal" );
            if(chatTabName[i] != undefined)
            {
                talk_plane["chat_" + (i + 1)].text_value.text = chatTabName[i].channel_name;
            }
        }
    }

    chat_list.clearListBox();
    chat_list.initListBox("item_list_chat",4,true,true);
    chat_list.enableDrag( true );

    for(var i = 1; i <= cur_channel_content.length ; i++){
        var force_show = (i == cur_channel_content.length);
        chat_list.addListItem(i, false, force_show);
    }
}

function refresh_chat_item(mc,index_item){
    var item_view = undefined;
    var chat_data = mc.content_data;
    mc.chat_time._visible = false
    mc.chat_item._visible = false
    if (chat_data.isShowTime)
    {
        item_view = mc.chat_time.chat_view;
        mc.chat_time._visible = true
        mc.chat_time.time.time_text.text = chat_data.sendtime_string
        mc.chat_time.gotoAndStop(chat_data.chat_type)
    }
    else
    {
        item_view = mc.chat_item.chat_view;
        mc.chat_item._visible = true
        mc.chat_item.gotoAndStop(chat_data.chat_type)
    }

    updateItemInfo(mc.chat_time.chat_view,chat_data)
    updateItemInfo(mc.chat_item.chat_view,chat_data)
    if(chat_data.isShowTime)
    {
        mc.ItemHeight = mc.chat_time._height
    }
    else
    {
        mc.ItemHeight = mc.chat_item._height;
    }
}
function updateItemInfo(item_view,chat_data)
{

    switch (chat_data.chat_type){
        case 'chat_self' :
            item_view.icon._visible = false;
            item_view.btn_translate._visible = false;
            item_view.uname_text._visible = false;
            item_view.uname_txt1._visible = false;
            item_view.uname_text.text = chat_data.uname;
            item_view.uname_txt1.text = chat_data.uname;
            item_view.message_content.text = chat_data.text_content;
            //9 宫格
            var _w = item_view.message_content.textWidth + 40 - item_view.bg1._width - item_view.bg7._width + 5;

            var _h = item_view.message_content.textHeight + 10;
            item_view.bg4._width = _w
            item_view.bg5._width = _w
            item_view.bg6._width = _w

            item_view.bg2._height = _h - item_view.bg4._height
            item_view.bg8._height = _h - item_view.bg4._height
            item_view.bg5._height = _h - item_view.bg4._height
            item_view.bg1._x = item_view.bg2._x = item_view.bg3._x = item_view.head_icon._x - 24;
            item_view.bg3._y = item_view.bg2._y + item_view.bg2._height;
            item_view.bg4._x = item_view.bg1._x - item_view.bg4._width;
            item_view.bg5._x = item_view.bg4._x
            item_view.bg6._x = item_view.bg5._x
            item_view.bg6._y = item_view.bg3._y;
            item_view.bg7._x = item_view.bg4._x - item_view.bg7._width;
            item_view.bg8._x = item_view.bg7._x
            item_view.bg9._x = item_view.bg7._x
            item_view.bg9._y = item_view.bg3._y
            item_view.message_content._x = item_view.bg7._x + 20
            item_view.message_content._y = item_view.bg1._y + (item_view.bg1._height + item_view.bg2._height + item_view.bg3._height - item_view.message_content.textHeight) / 2 - 2;

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

            if (chat_data.alliance_icon == undefined || chat_data.alliance_icon == "")
            {
                item_view.icon._visible = false
                item_view.uname_txt1._visible = true;
            }
            else
            {
                item_view.icon._visible = true
                item_view.uname_text._visible = true
                if (item_view.icon.hero_icons.icons == undefined)
                {
                    var w = item_view.icon.hero_icons._width
                    var h = item_view.icon.hero_icons._height
                    item_view.icon.hero_icons.loadMovie("AllianceIconSmall.swf");
                    item_view.icon.hero_icons._width = w;
                    item_view.icon.hero_icons._height = h;
                }
                item_view.icon.hero_icons.icons.gotoAndStop(chat_data.alliance_icon);
                // item_view.icon.hero_icons.icons.gotoAndStop(chat_data.alliance_icon);
                item_view.icon._x = item_view.uname_text._x + item_view.uname_text._width - item_view.uname_text.textWidth - item_view.icon._width - 10
             }
            break;
            case 'chat_other' :
            item_view.icon._visible = false;
            item_view.btn_translate._visible = true;
            item_view.uname_text._visible = false;
            item_view.uname_txt1._visible = false;
            item_view.uname_text.text = chat_data.uname;
            item_view.uname_txt1.text = chat_data.uname;
            item_view.message_content.text = chat_data.text_content;
            //9 宫格
            var _w = item_view.message_content.textWidth + 40 + item_view.btn_translate._width;
            var _h = item_view.message_content.textHeight + 10;
            item_view.bg4._width = _w
            item_view.bg5._width = _w
            item_view.bg6._width = _w

            item_view.bg2._height = _h - item_view.bg4._height
            item_view.bg8._height = _h - item_view.bg4._height
            item_view.bg5._height = _h - item_view.bg4._height
            item_view.bg1._x = item_view.bg2._x = item_view.bg3._x = 83
            item_view.bg4._x = item_view.bg5._x = item_view.bg6._x = 94
            item_view.bg3._y = item_view.bg2._y + item_view.bg2._height;
            item_view.bg6._y = item_view.bg3._y
            item_view.bg7._x = item_view.bg4._x + item_view.bg4._width;
            item_view.bg8._x = item_view.bg7._x
            item_view.bg9._x = item_view.bg7._x
            item_view.bg9._y = item_view.bg3._y
            item_view.message_content._x = 110
            item_view.message_content._y = item_view.bg1._y + (item_view.bg1._height + item_view.bg2._height + item_view.bg3._height - item_view.message_content.textHeight) / 2 - 2;
            item_view.btn_translate._x = item_view.bg1._x + item_view.bg1._width + item_view.bg4._width + item_view.bg7._width - 10 - item_view.btn_translate._width;
            // item_view.btn_translate._y = item_view.bg1._y + (bg1._height + bg2._height + bg3._height - item_view.btn_translate._height) / 2;

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

            if (chat_data.alliance_icon == undefined || chat_data.alliance_icon == "")
            {
                item_view.icon._visible = false
                item_view.uname_txt1._visible = true;
            }
            else
            {
                item_view.icon._visible = true
                item_view.uname_text._visible = true
                if (item_view.icon.hero_icons.icons == undefined)
                {
                    var w = item_view.icon.hero_icons._width
                    var h = item_view.icon.hero_icons._height
                    item_view.icon.hero_icons.loadMovie("AllianceIconSmall.swf");
                    item_view.icon.hero_icons._width = w;
                    item_view.icon.hero_icons._height = h;
                }
                // item_view.icon.hero_icons.icons.gotoAndStop(2);
                item_view.icon.hero_icons.icons.gotoAndStop(chat_data.alliance_icon);
            }

            item_view.icon._x = 110;

            break;
        case 'chat_server' :
            item_view.btn_translate._visible = true;
            item_view.send_time.text = chat_data.sendtime_string;
            item_view.message_content.text = chat_data.text_content;
            item_view.message_bg_mid._height = item_view.message_content.textHeight - 20;
            //item_view.message_bg_bottom._y = item_view.message_bg_mid._y + item_view.message_bg_mid._height;
            break;
        default:
    }
}


function add_chat(channel_content_item){
    cur_channel_content.push(channel_content_item);
    var chat_list = _root.chat_main.list;
    var chat_index = chat_list.getItemListLength();
    // var force_show = chat_list.isReachTailLimit();
    var force_show = true;
    chat_list.addListItem(chat_index + 1, false, force_show);
}

function initTabText(nameList)
{
    var talk_plane = _root.chat_main
    for(var i = 0;i < 3; i++)
    {
        talk_plane["chat_" + (i + 1)].text_value.text = nameList[i].name;
    }
}

function refresh_channel_info(channel_Info_liset){
    chatTabName = channel_Info_liset
    var talk_plane = _root.chat_main;
    for (var i = 0; i < 3 ; i++){
        if ( channel_Info_liset[i] == undefined ){
            talk_plane["chat_" + (i + 1)]._visible = true;
            talk_plane["chat_" + (i + 1)].locked._visible = true
            talk_plane["chat_" + (i + 1)].tips._visible = false;
            talk_plane["chat_" + (i + 1)].onRelease = function()
            {
                fscommand("ChatMgrCmd","ShowTipMessage")
            }
        }
        else{
            talk_plane["chat_" + (i + 1)]._visible = true;
            talk_plane["chat_" + (i + 1)].locked._visible = false
            talk_plane["chat_" + (i + 1)].tips._visible = false;
            talk_plane["chat_" + (i + 1)].channel_id = channel_Info_liset[i].channel_id;
            talk_plane["chat_" + (i + 1)].text_value.text = channel_Info_liset[i].channel_name;
            talk_plane["chat_" + (i + 1)].onRelease = function(){
                if ( cur_channel_id == this.channel_id ) { return ;}
                fscommand("PlaySound", "sfx_ui_selection_2");
                fscommand("ChatMgrCmd","SwitchChatGroupView\2" + this.channel_id);
                for(var i = 0;i < 3 ; i++)
                {
                    if(chatTabName[i] != undefined)
                    {
                        _root.chat_main["chat_" + (i + 1)].text_value.text = chatTabName[i].channel_name;
                    }
                }
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

function UpdateMoneyAndCredit(datas)
{
    chat_top.money.money_text.text = datas.money;
    chat_top.credit.credit_text.text = datas.credit;
}

function UpdateEnergy(point)
{
    var energyBtn = chat_top.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}
