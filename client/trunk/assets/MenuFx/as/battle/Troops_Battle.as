import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;
import common.CTextAutoSizeTool;


var all_view_mov_object_list : Array = [ _root.main.all_filter_button ,  _root.main.my_hero_list , _root.main.vs_info , _root.main.dispatch_title];
var Is_MovedIn : Boolean = false;
var Is_HasEnemy : Boolean = false;
var Is_Tutoria : Boolean  = false;
var Is_supportOutsideHero : Boolean = false;
var m_Custom_Enemy_Combat : Number = undefined
var m_new_selected_rid : Number = -1;
var hero_show_list = undefined;
var m_heroIntoBattle_list : Array;
var m_enemy_list = undefined;
var m_has_employ = false;
var isPlayerAnimation = false;
var cur_type : String 
var wsboss : Number = undefined

trace(_root.main.my_hero_list.button_filter)
this.onLoad = function(){
    /*******FTE*******/
    fscommand("TutorialCommand","Activate" + "\2" + "TroopsBattleUILoad");
    /*******End*******/
    //init();
    //move_in(false);
}

function init()
{
    for(var i = 0 ; i < all_view_mov_object_list.length ; i++)
    {
        var view_object = all_view_mov_object_list[i];
        view_object._visible = false;
    }

    _root.main.dispatch_title.btn_close.onRelease = function()
    {
        trace("btn_close")
        fscommand("PlaySound", "sfx_ui_cancel");
        move_out(false);
    }
    _root.main.btn_bg.onRelease = function()
    {
        close_filter_panel()
    }
    _root.main.btn_bg._visible = false
}

function init_filter_contral(btnText:Array)
{
    for(var j = 0; j <= 3 ; j++)
    {
        var filter_button = _root.main.all_filter_button["btn_filter_" + j];
        filter_button.filter_sign = j;
        filter_button.btn_text = btnText[j];
        filter_button.buttonText.text = btnText[j];
        filter_button.onRelease = function()
        {
            fscommand("PlaySound", "sfx_ui_selection_1");
            var button_filter = _root.main.my_hero_list.button_filter
            button_filter.filter_sign = this.filter_sign
            showAllHero(this.filter_sign);
        }
    }

    _root.main.my_hero_list.button_filter.LC_UI_NEW_MAP_TROOPS_FILTER_BUTTON.text = btnText[0];

    _root.main.vs_info.OnMoveInOver = function()
    {
        
    }
}

function initTitle(_title)
{
    //_root.main.dispatch_title.title.Title_txt.text = _title;
    CTextAutoSizeTool.SetSingleLineText(_root.main.dispatch_title.title.Title_txt, _title, 30, 20);
}

function isInAlliance(id)
{
    if(id == 0)
    {
        Is_supportOutsideHero = false
    }
    else
    {
        Is_supportOutsideHero = true
    }
}

function move_in(has_enemy:Boolean)
{
    if( Is_MovedIn ) { return; }
    init();
    m_has_employ = false;
    Is_HasEnemy = has_enemy;
    _root.main.dispatch_title._visible = true;
    _root.main.dispatch_title.gotoAndPlay("opening_ani");
    _root.main.my_hero_list._visible = true;
    _root.main.my_hero_list.gotoAndPlay("opening_ani");

    _root.main.vs_info._visible = true;
    _root.main.vs_info.gotoAndPlay("opening_ani");
    
    refer_PlayerTroops(_root.main.vs_info.my_power_info.power_num_txt)
    if(cur_type == "wmboss" && wsboss > 0)
    {
        _root.main.vs_info.btn_battle_0.enabled = true
        _root.main.vs_info.btn_battle_0._visible = true
        _root.main.vs_info.btn_battle.enabled = false
        _root.main.vs_info.btn_battle._visible = false
        _root.main.vs_info.btn_battle_0.onRelease = select_hero_done;
        _root.main.vs_info.btn_battle_0.txt_cost.text = wsboss
    }
    else
    {
        _root.main.vs_info.btn_battle_0.enabled = false
        _root.main.vs_info.btn_battle_0._visible = false
        _root.main.vs_info.btn_battle.enabled = true
        _root.main.vs_info.btn_battle._visible = true
        _root.main.vs_info.btn_battle.onRelease = select_hero_done;
    }
    
    if(Is_HasEnemy)
    {
        refer_Enemys(_root.main.vs_info.enemys_power_info.power_num_txt)
    }
    else
    {
        _root.main.vs_info.enemys_power_info.power_num_txt.text = 0;
    }

    showAllHero(0)
    if(Is_supportOutsideHero)
    {
        _root.main.my_hero_list.btn_mer.enabled = true;
        _root.main.my_hero_list.btn_mer.gotoAndStop("Idle")
    }
    else
    {
        if (cur_type == "expedition")
        {
            _root.main.my_hero_list.btn_mer.enabled = true;
            _root.main.my_hero_list.btn_mer.gotoAndStop("disabled")
        }
        else
        {
            _root.main.my_hero_list.btn_mer.enabled = false;
            _root.main.my_hero_list.btn_mer.gotoAndStop("disabled")
        }
    }


    filter_button_setting()
    m_new_selected_rid = -1;

    fscommand("ChatMgrCmd","Hide");
    Is_MovedIn = true;
    _root.main.btn_bg._visible = true
}

function SetMoneyData(data : Object)
{
    _root.main.dispatch_title.money.money_text.text = data.money;
    _root.main.dispatch_title.credit.credit_text.text = data.credit;
}

function SetPointData(point)
{
    var energyBtn = _root.main.dispatch_title.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

function filter_button_setting()
{
    //英雄filter
    var option_button = _root.main.my_hero_list.button_filter
    option_button.enabled = true
    option_button.filter_sign = 0
    option_button.onRelease = function()
    {
        this.enabled = false
        var isShowFilter = _root.main.all_filter_button._visible
        if(isShowFilter)
        {
            this.gotoAndStop("activated")
            _root.main.all_filter_button.gotoAndPlay("closing_ani")
        }
        else
        {
            _root.main.all_filter_button._visible = true
            this.gotoAndStop("released")
            if(Is_supportOutsideHero)
            {
                _root.main.my_hero_list.btn_mer.gotoAndStop("activated")
            }
            showAllHero(this.filter_sign)
            _root.main.all_filter_button.gotoAndPlay("opening_ani")
        }
    }

    var mercenary_button = _root.main.my_hero_list.btn_mer
    mercenary_button.filter_sign = 4
    mercenary_button.onRelease = function()
    {
        if(Is_supportOutsideHero)
        {
            fscommand("PlaySound", "sfx_ui_selection_1");
            var isShowFilter = _root.main.all_filter_button._visible
            if(isShowFilter)
            {
                this.enabled = false
                isPlayerAnimation = true
                _root.main.all_filter_button.gotoAndPlay("closing_ani")
            }
            _root.main.my_hero_list.btn_mer.gotoAndStop("released")
            _root.main.my_hero_list.button_filter.gotoAndStop("activated")
            showAllHero(this.filter_sign);
        }
        else
        {
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "11");
        }
    }

    _root.main.all_filter_button.OnMoveInOver = function()
    {
        if(Is_supportOutsideHero)
        {
            _root.main.my_hero_list.btn_mer.enabled = true
        }
        _root.main.my_hero_list.button_filter.enabled = true
    }

    _root.main.all_filter_button.OnMoveOutOver = function()
    {
        isPlayerAnimation = false
        _root.main.my_hero_list.button_filter.enabled = true
        if(Is_supportOutsideHero)
        {
            _root.main.my_hero_list.btn_mer.enabled = true
        }
        _root.main.all_filter_button._visible = false
    }
}

function close_filter_panel()
{
    var isShowFilter = _root.main.all_filter_button._visible
    if(isShowFilter && !isPlayerAnimation)
    {
        isPlayerAnimation = true
        var filterButton = _root.main.my_hero_list.button_filter
        filterButton.enabled = false
        filterButton.gotoAndStop("activated")
        _root.main.all_filter_button.gotoAndPlay("closing_ani")
    }
}

function select_hero_done()
{
    //trace(this);
    if(m_heroIntoBattle_list.length == 0)
    {
        fscommand("PlaySound", "sfx_ui_menu_appears");
        fscommand("ShowMessageBoxTimer","3000" + "\2" + "LC_ERROR_TROOPS_HERO_IS_EMPTY");
    }
    else if(m_heroIntoBattle_list.length < m_hero_list[s_list_all].length && m_heroIntoBattle_list.length < 5 && (isHasNoDeathHero() || cur_type != "expedition" ))
    {
        fscommand("PlaySound", "sfx_ui_menu_appears");
        fscommand("TroopsMgrCmd","CheckNotFullFormation");
    }
    else
    {
        fscommand("PlaySound", "sfx_ui_selection_1");
        RealgoBattle();
    }
}

function move_out(goBattle:Boolean)
{
    if( !Is_MovedIn ) { return; }

    for(var i = 0 ; i < all_view_mov_object_list.length ; i++)
    {
        var view_object = all_view_mov_object_list[i];
        if(view_object._visible)
        {
            view_object.gotoAndPlay("closing_ani");
            view_object.OnMoveOutOver = function()
            {
                this._visible = false;
            }
        }
    }

    _root.main.dispatch_title.OnMoveOutOver = function()
    {
        this._visible = false;
        _root.OnAllMovedOut();
    }

    if (goBattle)
    {
        _root.OnAllMovedOut = function()
        {
            var battle_member_parms = undefined;
            for(var i = 0 ; i < m_heroIntoBattle_list.length ; i++)
            {
                fscommand("ChatMgrCmd","Show");
                battle_member_parms =  battle_member_parms == undefined ? m_heroIntoBattle_list[i].rid : battle_member_parms + '\2' + m_heroIntoBattle_list[i].rid;
            }
            fscommand("TroopsMgrCmd","SetCurFormation\2" + battle_member_parms);
            // fscommand("GotoNextMenu", "GS_Battle");
            _root.main.btn_bg._visible = false;
            fscommand("GoToNext");
            fscommand("TroopsMgrCmd","BacklastScreen")
            /*******FTE*******/
            fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickGoFightBtn");
            /*******End*******/
        }
    }
    else
    {
        _root.OnAllMovedOut = function()
        {
            _root.main.btn_bg._visible = false;
            fscommand("ChatMgrCmd","Show");
            fscommand("ExitBack");
            fscommand("TroopsMgrCmd","BacklastScreen")
            fscommand("TutorialCommand","Activate" + "\2" + "CloseDispatchTroops");
        }
    }

    Is_MovedIn = false;
}




function RealgoBattle(){
    move_out(true);
}


var m_hero_list : Array;
var s_list_all : Number = 0;
var s_list_front : Number = 1;
var s_list_middle : Number = 2;
var s_list_back : Number = 3;
var s_list_outside : Number = 4;

function initHeroList(input_hero_data:Array,_type:String,_wsboss)
{
    if ( m_hero_list == undefined )
    {
        m_hero_list = new Array();
        for (var i = s_list_all ; i <= s_list_outside ; i++ )
        {
            m_hero_list[i] = new Array();
        }
    }
    for (var i = s_list_all ; i <= s_list_outside ; i++ )
    {
        m_hero_list[i].splice(0);
    }
    for (var i = 0; i < input_hero_data.length ; i++)
    {
        var m = input_hero_data[i];
        if (m.is_outside)
        {
            m_hero_list[s_list_outside].push(m);
        }
        else
        {
            m_hero_list[s_list_all].push(m);
            m_hero_list[m.local_mode].push(m);
        }
    }
    cur_type = _type;
    wsboss = _wsboss;
}


function initEnemyList(input_enemyList:Array , Custom_Enemy_Combat:Number)
{
    m_enemy_list = input_enemyList;
    m_Custom_Enemy_Combat = Custom_Enemy_Combat;
}

function refer_Enemys(CombatInfoPlane:Object)
{
    if(CombatInfoPlane != undefined)
    {
        if (m_Custom_Enemy_Combat != undefined)
        {
            CombatInfoPlane.text = m_Custom_Enemy_Combat;
        }
        else
        {
            var enemy_totle_combatnumb = 0;
            for (var i = 0 ;i < m_enemy_list.length ; i++)
            {
                enemy_totle_combatnumb += m_enemy_list[i].combat;
            }
            CombatInfoPlane.text = enemy_totle_combatnumb;
        }
    }
}

var AllheroList = _root.main.my_hero_list.HeroView.ViewList
AllheroList.onEnterFrame = function()
{
    this.OnUpdate();
}
AllheroList.onItemEnter = function(mc,index_item)
{
    trace("index_item == ")
    var hero_item_mc = mc;
    var hero_data = hero_show_list[(index_item - 1)];
    hero_item_mc.hero_data = hero_data;
    if (this.lsitSign == 4)
    {
        hideOutsideheroState(mc)
        onEnterOutSide(mc,index_item)
    }
    else
    {
        hideHeroItemAllState(mc)
        if(hero_item_mc.icon.icons == undefined)
        {
            hero_item_mc.icon.loadMovie("CommonHeros.swf")
        }
        hero_item_mc.icon.IconData = hero_data.icon_data
        if(hero_item_mc.icon.UpdateIcon) { hero_item_mc.icon.UpdateIcon(); }

        if(hero_data.hp_percent != undefined)
        {
            var hp_frame = Math.floor(hero_data.hp_percent / 20) + 1;
            hero_item_mc.heroHp._visible = true
            hero_item_mc.heroMp._visible = true
            hero_item_mc.heroHp.gotoAndStop(hp_frame)
            hero_item_mc.heroMp.gotoAndStop(hero_data.mp_percent + 1)
        }
        hero_item_mc.heroLv.level_text.text = hero_data.levelTxt
        hero_item_mc.star.gotoAndStop(hero_data.star)

        if(hero_data.is_enable)
        {
            if (hero_data.is_actived)
            {
                hero_item_mc.selectState._visible = true;
            }
        }
        else
        {
            if ( hero_data.hp_percent != undefined && hero_data.hp_percent == 0 )
            {
                hero_item_mc.deathState._visible = true;
            }
            if ( hero_data.unlockLevel != undefined)
            {
                hero_item_mc.star._visible = false;
                hero_item_mc.lockState._visible = true;
                hero_item_mc.lockState.unlock_text.text = hero_data.unlockLevel
            }
            if (hero_data.is_inFormation != undefined && hero_data.is_inFormation)
            {
                hero_item_mc.taskState._visible = true;
            }
        }

        //修理-- todo
    }

    hero_item_mc.onRelease = function()
    {
        this._parent.onReleasedInListbox();
        if(Math.abs(this.Press_x - _root._xmouse) < this._width / 2 &&  Math.abs(this.Press_y - _root._ymouse) < this._height / 2)
        {
            if (Is_Tutoria)
            {
                if (this.is_select == undefined)
                {
                    heroMC_select(this);
                    this.is_select = true;
                    /*******FTE*******/
                    fscommand("TutorialCommand","TutorialComplete" + "\2" + "SelectHero");
                    /*******End*******/
                }
            }else
            {
                heroMC_select(this);
            }
        }
    }
    hero_item_mc.onReleaseOutside = function()
    {
        this._parent.onReleasedInListbox();
    }
    hero_item_mc.onPress = function()
    {
        this._parent.onPressedInListbox();
        this.Press_x = _root._xmouse;
        this.Press_y = _root._ymouse;
    }
}

function hideOutsideheroState(mc)
{
    mc.deathState._visible = false
    mc.selectState._visible = false
    mc.heroHp._visible = false
    mc.heroMp._visible = false
}

function onEnterOutSide(mc, index_item)
{
    var hero_item_mc = mc;
    var hero_data = hero_show_list[(index_item - 1)];
    hero_item_mc.hero_data = hero_data;
    if(hero_item_mc.icon.icons == undefined)
    {
        hero_item_mc.icon.loadMovie("CommonHeros.swf")
    }
    hero_item_mc.icon.IconData = hero_data.icon_data
    if(hero_item_mc.icon.UpdateIcon) { hero_item_mc.icon.UpdateIcon(); }
    if(hero_data.hp_percent != undefined)
    {
        hero_item_mc.heroHp._visible = true
        hero_item_mc.heroMp._visible = true
        var hp_frame = Math.floor(hero_data.hp_percent / 20) + 1;
        hero_item_mc.heroHp.gotoAndStop(hp_frame)
        hero_item_mc.heroMp.gotoAndStop(hero_data.mp_percent + 1)
    }
    hero_item_mc.heroLv.level_text.text = hero_data.levelTxt
    hero_item_mc.name_text.text = hero_data.name
    hero_item_mc.money._visible = true
    if (hero_data.cost == undefined)
    {
        hero_item_mc.money._visible = false
    }
    if(hero_data.hasNoMoreMoney != undefined && hero_data.hasNoMoreMoney)
    {
        hero_item_mc.money.TxtNum.htmlText = "<font color='#DA0000'>" + hero_data.cost + "</font>"
    }
    else
    {
        hero_item_mc.money.TxtNum.htmlText = hero_data.cost
    }
    hero_item_mc.star.gotoAndStop(hero_data.star)
    if ( hero_data.hp_percent != undefined && hero_data.hp_percent == 0 )
    {
        hero_item_mc.deathState._visible = true;
    }
    if (hero_data.is_actived)
    {
        hero_item_mc.selectState._visible = true;
    }
}

function showAllHero(hero_list_sign:Number)
{
    if(hero_list_sign != 4)
    {
        var filter_button_view = _root.main.all_filter_button
        for(var i = 0;i <= 3; i++ )
        {
            var fbtn = filter_button_view["btn_filter_" + i]
            if(fbtn)
            {
                fbtn.gotoAndStop("Idle")
                fbtn.enabled = true
            }
        }
        var cur_filter_button = filter_button_view["btn_filter_" + hero_list_sign]
        cur_filter_button.gotoAndStop("released")
        cur_filter_button.enabled = true
        _root.main.my_hero_list.button_filter.LC_UI_NEW_MAP_TROOPS_FILTER_BUTTON.text = cur_filter_button.btn_text;
    }

    AllheroList.clearListBox();
    AllheroList.lsitSign = hero_list_sign
    if(hero_list_sign == 4)
    {
        AllheroList.initListBox("Mercenary_unions",0,false,true);
    }
    else
    {
        AllheroList.initListBox("hero",0,false,true);
    }
    AllheroList.enableDrag( true );

    hero_show_list = m_hero_list[hero_list_sign];
    if(hero_show_list == undefined)
    {
        hero_show_list = new Array();
    }

    for( var i=1; i <= hero_show_list.length ; i++ )
    {
        AllheroList.addListItem(i, false, false);
    }

}
function hideHeroItemAllState(mc)
{
    mc.repairState._visible = false
    mc.lockState._visible = false
    mc.deathState._visible = false
    mc.taskState._visible = false
    mc.heroHp._visible = false
    mc.heroMp._visible = false
    mc.selectState._visible = false
}

function SetTutoriaState( enable )
{
    Is_Tutoria = enable;
}

function heroMC_select(this_mc:Object)
{
    close_filter_panel();
    if (this_mc.hero_data.is_enable == false)
    {
        if(this_mc.hero_data.hp_percent == 0)
        {
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "5");
        }
        else if(this_mc.hero_data.is_outside)
        {
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "2");
        }
        else if(this_mc.hero_data.disable_reason != undefined)
        {
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + this_mc.hero_data.disable_reason);
        }
        else{
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "1");
        }
        return;
    }
    if (this_mc.hero_data.is_actived)
    {
        this_mc.hero_data.is_actived = false;
        this_mc.selectState._visible = false;
        //this_mc.hero_icon.hero_icon.SelectIcon(false);
        m_new_selected_rid = 0;
        refer_intoBattle_info(true);

        if(this_mc.hero_data.is_outside)
        {
            m_has_employ = false;
        }
    }
    else if(m_heroIntoBattle_list.length < 5)
    {
        if ( this_mc.hero_data.is_outside && m_has_employ)
        {
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "4");
            return;
        }

        if ( check_heroid_inBattle(this_mc.hero_data.id) )
        {
            fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "3");
            return;
        }

        this_mc.hero_data.is_actived = true;
        this_mc.selectState._visible = true;
        //this_mc.hero_icon.hero_icon.SelectIcon(true);
        m_heroIntoBattle_list.push(this_mc.hero_data);
        m_new_selected_rid = this_mc.hero_data.rid;
        refer_intoBattle_info(false);

        if(this_mc.hero_data.is_outside)
        {
            m_has_employ = true;
        }
    }
    else{
        fscommand("TroopsMgrCmd","TipCanNotTroop\2" + "12");
    }
}

function init_intoBattle_info()
{
    m_heroIntoBattle_list = new Array();
    for (var i = 0; i < m_hero_list[s_list_all].length ; i++)
    {
        if (m_hero_list[s_list_all][i].is_actived && m_hero_list[s_list_all][i].is_enable)
        {
            m_heroIntoBattle_list.push(m_hero_list[s_list_all][i]);
        }
    }
    for (var i = 0; i < m_hero_list[s_list_outside].length ; i++)
    {
        if (m_hero_list[s_list_outside][i].is_actived)
        {
            m_heroIntoBattle_list.push(m_hero_list[s_list_outside][i]);
        }
    }
}


function isHasNoDeathHero()
{
    for (var i = 0; i < m_hero_list[s_list_all].length ; i++)
    {
        var isInBatteList = false
        for (var j = 0; j < m_heroIntoBattle_list.length; j ++)
        {
            if (m_hero_list[s_list_all][i].id == m_heroIntoBattle_list[j].id)
            {
                isInBatteList = true
                break
            }
        }
        if (m_hero_list[s_list_all][i].hp_percent != undefined && m_hero_list[s_list_all][i].hp_percent  > 0 && not isInBatteList )
        {
            return true
            break
        }
    }
    for (var i = 0; i < m_hero_list[s_list_outside].length ; i++)
    {
        var isInBatteList = false
        for (var j = 0; j < m_heroIntoBattle_list.length; j ++)
        {
            if (m_hero_list[s_list_outside][i].id == m_heroIntoBattle_list[j].id)
            {
                isInBatteList = true
                break
            }
        }
        if (m_hero_list[s_list_outside][i].hp_percent != undefined && m_hero_list[s_list_outside][i].hp_percent  > 0 && not isInBatteList )
        {
            return true
            break
        }
    }
    return false
}

function refer_PlayerTroops(CombatInfoPlane:Object)
{
    if(CombatInfoPlane != undefined)
    {
        var enemy_totle_combatnumb = 0;
        for (var i = 0 ;i < m_heroIntoBattle_list.length ; i++)
        {
            enemy_totle_combatnumb += m_heroIntoBattle_list[i].combat;
        }
        CombatInfoPlane.text = enemy_totle_combatnumb;
    }
}


function check_heroid_inBattle(hero_id){
    var m_ret = false;
    for (var i = 0; i < m_heroIntoBattle_list.length ; i++){
        if ( m_heroIntoBattle_list[i].id == hero_id ){
            m_ret = true;
            break;
        }
    }
    return m_ret;
}

/*上阵英雄摆放位置
9 6 3  | 3 6 9
7 4 1  | 1 4 7
8 5 2  | 2 5 8
*/
var inBattleHero : Array = ["empty","empty","empty","empty","empty","empty","empty","empty","empty"]

function getHeroLocation(firstModeData,midModeData,backModeData,isMySelf)
{
    one_list_location(0,inBattleHero,firstModeData)
    one_list_location(3,inBattleHero,midModeData)
    one_list_location(6,inBattleHero,backModeData)
    var strHeroIds = ""
    for(var i = 0; i < inBattleHero.length; i++)
    {
        if(i == inBattleHero.length - 1)
        {
            strHeroIds += inBattleHero[i];
        }
        else
        {
            strHeroIds += inBattleHero[i] + "\1";
        }
    }
    if(isMySelf)
    {
        fscommand("TroopsMgrCmd","MySelfHerosLocation\2" + strHeroIds)
    }
    else
    {
        fscommand("TroopsMgrCmd","EnemyHerosLocation\2" + strHeroIds)
    }

}

function one_list_location(fromId,outData,inData)
{
    if(inData.length >= 3)
    {
        for(var i = 0; i < inData.length; i ++)
        {
            outData[fromId + i] = inData[i]
        }
    }
    else if(inData.length == 2)
    {
        outData[fromId] = "empty"
        for(var i = 0; i < inData.length; i++)
        {
            outData[fromId + i + 1] = inData[i]
        }
    }
    else if(inData.length == 1)
    {
        outData[fromId] = inData[0]
        outData[fromId + 1] = "empty"
        outData[fromId + 2] = "empty"
    }
    else
    {
        for(var i = 0; i < 3; i++)
        {
            outData[fromId + i] = "empty"
        }
    }
}

function get_hero_location(hero_list,isMySelf)
{
    var first_mode : Array = new Array()
    var new_first_mode : Array = new Array()
    var mid_mode : Array = new Array()
    var new_mid_mode : Array = new Array()
    var back_mode : Array = new Array()
    var new_back_mode : Array = new Array()

    for(var i = 0; i < hero_list.length; i++)
    {
        trace("hero_list = ")
        trace(hero_list[i].id)
        trace(",")
        if(hero_list[i].local_mode == 1 )
        {
            first_mode.push(hero_list[i])
        }
        else if(hero_list[i].local_mode == 2)
        {
            mid_mode.push(hero_list[i])
        }
        else if (hero_list[i].local_mode == 3)
        {
            back_mode.push(hero_list[i])
        }
    }

    if((first_mode.length >= 3) || (mid_mode.length >= 3) || (back_mode.length >= 3))
    {
        if(first_mode.length >= 3)
        {
            for(var i = 0; i < first_mode.length; i++)
            {
                if( i >= 3)
                {
                    new_mid_mode.push(first_mode[i].modeName)
                }
                else
                {
                    new_first_mode.push(first_mode[i].modeName)
                }
            }
            for(var j = 0; j < mid_mode.length; j++)
            {
                new_mid_mode.push(mid_mode[j].modeName)
            }

            for(var k = 0; k < back_mode.length; k++)
            {
                new_back_mode.push(back_mode[k].modeName)
            }
        }
        if(mid_mode.length >= 3)
        {
            for(var i = 0; i < first_mode.length; i++)
            {
                new_first_mode.push(first_mode[i].modeName)
            }
            for(var j = 0; j < mid_mode.length; j++)
            {
                if(j >= 3)
                {
                    new_back_mode.push(mid_mode[j].modeName)
                }
                else
                {
                    new_mid_mode.push(mid_mode[j].modeName)
                }
            }
            for(var k = 0; k < back_mode.length; k++)
            {
                new_back_mode.push(back_mode[k].modeName)
            }
        }
        if(back_mode.length >= 3)
        {
            for(var i = 0; i < first_mode.length; i++)
            {
                new_first_mode.push(first_mode[i].modeName)
            }
            for(var j = 0; j < mid_mode.length; j++)
            {
                new_mid_mode.push(mid_mode[j].modeName)
            }
            for(var k = 0; k < back_mode.length; k++ )
            {
                if(k < (back_mode.length - 3))
                {
                    new_mid_mode.push(back_mode[k].modeName)
                }
                else
                {
                    new_back_mode.push(back_mode[k].modeName)
                }
            }
        }
    }
    else
    {
        for(var i = 0; i < first_mode.length; i++)
        {
            new_first_mode.push(first_mode[i].modeName)
        }
        for(var j = 0; j < mid_mode.length; j++)
        {
            new_mid_mode.push(mid_mode[j].modeName)
        }
        for(var k = 0; k < back_mode.length; k++ )
        {
            new_back_mode.push(back_mode[k].modeName)
        }

    }
    for(var i = 0; i < 3; i++)
    {
        trace("mode = ")
        trace(new_first_mode[i])
        trace(new_mid_mode[i])
        trace(new_back_mode[i])
    }
    getHeroLocation(new_first_mode,new_mid_mode,new_back_mode,isMySelf)
}

function refer_intoBattle_info(need_remove : Boolean){
    //remove unintoBattle list
    if(need_remove){
        for (var i = 0; i < m_heroIntoBattle_list.length ; i++){
            if (!m_heroIntoBattle_list[i].is_actived){
                m_heroIntoBattle_list.splice(i,1);
            }
        }
    }
    //sort intoBattle list by local mode
    m_heroIntoBattle_list.sort(
        function(a,b) { return a.rank_value > b.rank_value ? 1 : -1;}
    );

    //修改英雄摆放位置 todo
    get_hero_location(m_heroIntoBattle_list,true)

    refer_PlayerTroops(_root.main.vs_info.my_power_info.power_num_txt);
}


function TutorialGetValidHeroItem(){
    var AllheroList = _root.troops_selectHero.HeroView.ViewList;
    for(var i = 1; i <= AllheroList.getItemListLength() ; ++ i){
        var mc = AllheroList.getMcByItemKey(i);
        if ( mc.hero_item.hero_data.is_enable && !mc.hero_item.hero_data.is_actived )
        {
            return mc.hero_item;
        }
    }
    return undefined;
}

function RemoveHeroFormTroops(heroName)
{
    var curItem = undefined
    for(var i = 1; i <= AllheroList.getItemListLength() ; ++ i){
        var mc = AllheroList.getMcByItemKey(i);
        if (mc.hero_data.name == heroName && mc.hero_data.is_actived)
        {
            curItem = mc;
        }
    }
    if(curItem != undefined )
    {
        curItem.onRelease()
    }
}

function AddHeroInTroops(heroName)
{
    var curItem = undefined
    for(var i = 1; i <= AllheroList.getItemListLength() ; ++ i){
        var mc = AllheroList.getMcByItemKey(i);
        if (mc.hero_data.name == heroName && !mc.hero_data.is_actived)
        {
            curItem = mc;
        }
    }
    if(curItem != undefined )
    {
        curItem.onRelease()
    }
}

_root.main.dispatch_title.energy.onRelease=function()
{
    fscommand("PlayMenuConfirm")
    fscommand("GoToNext", "Energy");
}
_root.main.dispatch_title.money.onRelease=function()
{
    fscommand("PlayMenuConfirm")
    fscommand("GoToNext", "Affair");
}
_root.main.dispatch_title.credit.onRelease = function()
{
    trace("xxxxxxxxxxxxxxxxxxxxxxxxx")
    fscommand("PlayMenuConfirm")
    fscommand("GoToNext", "Purchase");
}

//FTE
function FTEClickedListItem_One()
{
    var mc = AllheroList.getMcByItemKey(1)
    heroMC_select(mc)
}

function FTEClickedListItem_TWE()
{
    var mc = AllheroList.getMcByItemKey(2)
    heroMC_select(mc)
}

function FTEClickedListItem_3()
{
    var mc = AllheroList.getMcByItemKey(3)
    heroMC_select(mc)
}

function FTEClickedConfirm()
{
    select_hero_done()
}

function FTESelect3()
{
    for (var i=1; i<=3; i++)
    {
        var mc = AllheroList.getMcByItemKey(i)
        if (mc != undefined && !mc.hero_data.is_actived)
            heroMC_select(mc)
    }
}

function FTEPlayAnim(sname)
{
    _root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
    _root.fteanim.confirm._visible = false
    _root.fteanim.hero_1._visible = false
    _root.fteanim.hero_2._visible = false
    _root.fteanim.hero_3._visible = false
}
FTEHideAnim()