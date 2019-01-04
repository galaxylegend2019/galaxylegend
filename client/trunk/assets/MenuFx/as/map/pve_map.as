var MainUI 		= _root;
var AWardUI 	= MainUI.reward_popup;
var AwardBoxUI 	= MainUI.pve_down;
var CloseBtn 	= MainUI.top_ui.btn_close;

var ChapterDatas = new Array(10);
var DragDir 	 = undefined;

var IsExit 		= false;

_root.onLoad = function()
{
	SetDefaultShow();
	InitUI();
}

function SetDefaultShow()
{
	AWardUI._visible = false;
	SetLeftArrowShow(false);
	SetRightArrowShow(false);
}

function InitUI()
{
	CloseBtn.onRelease = function()
	{
		CloseUI(true);
	}
	InitDragList();
	//SetAwardBox();
	OpenUI();
}

function OpenUI()
{
	MainUI.top_ui.gotoAndPlay("opening_ani");
	MainUI.chapter_arrow.gotoAndPlay("opening_ani");
	AwardBoxUI.gotoAndPlay("opening_ani");
	trace("----------OpenUI----------")

	fscommand("TutorialCommand","Activate" + "\2" + "OpenRegionUI");
}



function CloseUI( is_exit )
{
	IsExit = is_exit == true;
	MainUI.top_ui.gotoAndPlay("closing_ani");
	MainUI.chapter_arrow.gotoAndPlay("closing_ani");
	AwardBoxUI.gotoAndPlay("closing_ani");
	CloseDragList();
	if (is_exit)
	{
		MainUI.top_ui.OnMoveOutOver = function()
		{
			if (IsExit)
			{
				fscommand("ExitBack");
				fscommand("PveMgrCmd", "ExitPveMap");
			}
			
		}
		
	}else
	{
		var cur_list = GetCurItem();
		cur_list.content.OnMoveOutOver = function()
		{
			if (not IsExit)
			{
				fscommand("GoToNext");
			}
		}
		
	}
	

}

function SetArrowShow( state )
{
	SetLeftArrowShow(state.previous);
	SetRightArrowShow(state.next);
}

function SetLeftArrowShow(is_show)
{
	MainUI.chapter_arrow.last_arrow._visible = is_show;
}

function SetRightArrowShow(is_show)
{
	MainUI.chapter_arrow.next_arrow._visible = is_show;
}

MainUI.chapter_arrow.last_arrow.onRelease = function()
{
	if (not m_dragStart)
	{
		fscommand("PveMgrCmd","SwitchChapter\2previous");	
	}
}

MainUI.chapter_arrow.next_arrow.onRelease = function()
{
	if (not m_dragStart)
	{
		fscommand("PveMgrCmd","SwitchChapter\2next");	
	}
}

function SetMoneyData(datas)
{
	MainUI.top_ui.money.money_text.text = datas.money;
	MainUI.top_ui.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = MainUI.top_ui.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}
MainUI.top_ui.money.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

MainUI.top_ui.credit.onRelease=function()
{
	fscommand("GoToNext", "Purchase");
}

MainUI.top_ui.energy.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

/*

*/
function SetAwardBox( infos )
{
	for (var i = 0; i < 3; ++i)
	{
		AwardBoxUI["reward_" + (i + 1)].icon.gotoAndStop(infos.info[i].state);
		AwardBoxUI["reward_" + (i + 1)].star_text.text = infos.info[i].star;
		if (infos.info[i].state == "activate")
		{
			AwardBoxUI["reward_" + (i + 1)].icon.star = infos.info[i].star;
			AwardBoxUI["reward_" + (i + 1)].icon.onRelease = function()
			{
				fscommand("PveMgrCmd", "GetStarGift\2" + this.star);
			}
		}else
		{
			AwardBoxUI["reward_" + (i + 1)].icon.onRelease = undefined;
		}
	}
	AwardBoxUI.star_percent_bar.gotoAndStop(infos.rate + 1);
}

/*******************AwardProp**********************/

/*
datas.credit
datas.money
*/

function ShowAwardUI( datas )
{
	AWardUI._visible = true;
	AWardUI.gotoAndPlay("opening_ani");
	if (datas.credit != undefined and datas.money != undefined)
	{
		AWardUI.content.money.gotoAndStop(1);
		AWardUI.content.money.money1.gotoAndStop(1);
		AWardUI.content.money.money2.gotoAndStop(2);
		AWardUI.content.money.money1.num.num_txt.text = "x" + datas.money;
		AWardUI.content.money.money2.num.num_txt.text = "x" + datas.credit;
	}else
	{
		AWardUI.content.money.gotoAndStop(2);
		if (datas.credit != undefined)
		{
			AWardUI.content.money.money1.gotoAndStop(2);
			AWardUI.content.money.money1.num.num_txt.text = "x" + datas.credit;
		}else
		{
			AWardUI.content.money.money1.gotoAndStop(1);
			AWardUI.content.money.money1.num.num_txt.text = "x" + datas.money;
		}
	}
	AWardUI.bg.onRelease = function()
	{
		AWardUI.gotoAndPlay("closing_ani");
		AWardUI._visible = false;
	}
}


/*************************************************/

function InitDragList()
{
	DragListInit();
	for(var i = 0; i <= 7; ++i)
	{
		AddItem("pve_content_barrier_all", i);
	}
}

function RefreashGate(datas)
{
	ChapterDatas = datas;
	var cur_item = GetCurItem()
	if (cur_item == undefined)
	{
		SetFirstShow(ChapterDatas.ChapterIndex);	
	}else
	{
		onFirstMoveIn(cur_item)
	}
	
}

function SetGateInfos(mc)
{
	for (var i = 0; i < ChapterDatas.GateList.length; ++i)
	{
		var info = ChapterDatas.GateList[i];
		var item = mc.content["barrier_" + (i + 1)];
		item.info = info;
		item.onPress = function()
		{
			if (this.info.task_state != "lock")
			{
				this.star.gotoAndStop("onPress");
				m_hitZone_panel.onPress();
			}
		}
		item.onRelease = function()
		{
			if (this.info.task_state != "lock")
			{
				this.star.gotoAndStop("onNormal");
				fscommand("PveMgrCmd","SetCurEnemys\2" + this.info.task_id) ;
				CloseUI();
			}
			m_hitZone_panel.onRelease();
		}
		item.onReleaseOutside = function()
		{
			if (this.info.task_state != "lock")
			{
				this.star.gotoAndStop("onNormal");
				m_hitZone_panel.onReleaseOutside();
			}
		}
		
		item.gotoAndStop(info.task_state);

		if (info.task_state == "normal")
		{
            SetItemStar(item.star.head, info.finish_star);
			item.star.level_info.level_text.text    = info.task_order_num
            item.star.level_info.NameText.text       = info.task_name
		}else if (info.task_state == "activited")
		{
			item.star.level_info.level_text.text    = info.task_order_num
            item.star.level_info.NameText.text       = info.task_name
			item.star.combat_plane.combat_text.text = info.combat
		}else if (info.task_state == "lock")
		{
			item.star.level_info.level_text.text = info.task_order_num
        }

        if (item.star.head.player_icon.icons == undefined)
        {
            item.star.head.player_icon.loadMovie("CommonHeros.swf")
            item.star.head.player_icon.icons.hero_icons.gotoAndStop(info.hero_avatar)
        }
    }
	
}

function SetItemStar(mc, num)
{
	for(var i = 1; i <= 3; i++)
	{
		if (i > num)
		{
			mc["star_" + i]._visible = false;
		}else
		{
			mc["star_" + i]._visible = true;
		}
	}
}



function onItemEnter(mc, index)
{
	mc.gotoAndStop(index + 1);
}

function onMoveStart(mc)
{
	SetGateInfos(mc);
}

function onFirstMoveIn(mc)
{
	
	onMoveStart(mc);
	OpenDragList(mc);
}

function OpenDragList(mc)
{
	var cur_list = mc;
	for (var i = 1; i <= 20; ++i)
	{
		var item = cur_list.content["barrier_" + i];
		if (item != undefined)
		{
			item.star.gotoAndPlay("opening_ani");
			item.gotoAndPlay("opening_ani");
		}
	}
	cur_list.content.gotoAndPlay("opening_ani");
}

function CloseDragList()
{
	var cur_list = GetCurItem();
	for (var i = 1; i <= 20; ++i)
	{
		var item = cur_list.content["barrier_" + i];
		if (item != undefined)
		{
			item.star.gotoAndPlay("closing_ani");
			item.gotoAndPlay("closing_ani");
		}
	}
	cur_list.content.gotoAndPlay("closing_ani");
}

MainUI.onEnterFrame = function()
{
	DragListUpdate();
}

/********************************************/

var ChapterList 	= MainUI.list_view;
var m_listMc        = new Array();
var m_maxIndex      = 0;
var m_curIndex      = 0;
var m_lastMc        = 0;
var m_curMc         = undefined;
var m_dragDir       = 0 ;   //0--left, 1--right
var m_dragStart      = false; 
var m_hitZone_panel = undefined;
var m_slideItem     = undefined;
var m_itemWidth     = 0;
var m_moveSpeed     = 80;
var m_curMoveOffset = 0;
var m_isDrag        = false;
var m_pressPos      = 0;

var m_startTime       = 0; //ms



// var onItemEnter     = undefined;
// var onMoveIn        = undefined;
// var onMoveStart     = undefined;
// var onClick         = undefined;

function DragListInit()
{
    m_hitZone_panel = ChapterList.hitZone_panel;
    m_slideItem     = ChapterList.slideItem;
    m_itemWidth     = GetItemWidth();
    _DragInput();
}


function AddItem(mc_url, index)
{
    var newMC = m_slideItem.attachMovie(mc_url, "Item" + m_maxIndex, m_slideItem.getNextHighestDepth());
    newMC.m_index = index;
    m_listMc.push(newMC);

    if (onItemEnter != undefined)
    {
        onItemEnter(newMC, newMC.m_index);
    }

    // if (m_maxIndex == 5) //first
    // {
       
    // }else
    // {
        newMC._visible = false;
    //}
    m_maxIndex = m_maxIndex + 1;
    return newMC;
}

function SetFirstShow(index)
{
	trace("------------index=" + index)
	index = index - 1;
    m_curMc = m_listMc[index];
    if (m_curMc == undefined)
    {
    	return;
    }
    m_curMc._visible = true;
    m_curIndex = index;
    if (onFirstMoveIn)
    {
    	onFirstMoveIn(m_curMc);
    }
}

function GetLeftItem()
{
    if (m_curIndex > 0)
    {
        return m_listMc[m_curIndex - 1];
    }
    return undefined;
}

function GetRightItem()
{
    if (m_curIndex < m_maxIndex - 1)
    {
        return m_listMc[m_curIndex + 1];
    }
    return undefined;
}

function GetItemWidth()
{
    return m_hitZone_panel._width;
}

function DragListUpdate()
{
    if (m_dragStart)
    {
    	//fscommand("LockInput");
        var offset = m_moveSpeed;
        if (m_curMoveOffset + offset > m_itemWidth)
        {
            offset = m_itemWidth - m_curMoveOffset;
        }
        m_curMoveOffset = m_curMoveOffset + offset;
        if (m_dragDir == 0) //left
        {
            m_slideItem._x = m_slideItem._x - offset;
        }else //right
        {
            m_slideItem._x = m_slideItem._x + offset;
        }
        if (m_curMoveOffset >= m_itemWidth)
        {
            m_dragStart = false;
            DragDir = undefined;
            m_curMoveOffset = 0;
            m_lastMc._visible = false;
            if (onMoveIn != undefined)
            {
                onMoveIn(m_curMc);
            }
            m_startTime = 0;
            m_hitZone_panel.onRelease();
            //fscommand("UnlockInput");
        }
    }
}

function SetItemPosX(mc, offset)
{
    mc._x = m_lastMc._x + offset;
}

function DragLeft( datas )
{
	ChapterDatas = datas;
    var item = GetRightItem();
    if (item == undefined)
    {
    	return;
    }
    item._visible = true;
    m_curIndex = item.m_index;
    m_lastMc = m_curMc;
    m_curMc = item;
    SetItemPosX(item, m_itemWidth);
    m_dragStart = true;
    m_dragDir = 0;
    if (onMoveStart != undefined)
    {
        onMoveStart(m_curMc);
    }
}

function DragRight( datas )
{
	ChapterDatas = datas;
    var item = GetLeftItem();
    if (item == undefined)
    {
    	return;
    }
    item._visible = true;
    m_curIndex = item.m_index;
    m_lastMc = m_curMc;
    m_curMc = item;
    SetItemPosX(item, -m_itemWidth);
    m_dragStart = true;
    m_dragDir = 1;
    if (onMoveStart != undefined)
    {
        onMoveStart(m_curMc);
    }
}

function GetCurItem()
{
    return m_curMc
}


function _DragInput()
{
    m_hitZone_panel.onPress = function()
    {
        m_isDrag = true;
        m_pressPos = _root._xmouse;
    }

    m_hitZone_panel.onReleaseOutside = function()
    {
        m_isDrag = false;
    }

    m_hitZone_panel.onRelease = function()
    {
        m_isDrag = false;
    }
    m_hitZone_panel.onEnterFrame = function()
    {
        if (m_isDrag and not m_dragStart)
        {
            var offset = _root._xmouse - m_pressPos;
            if (offset < -80)
            {
                //DragLeft();
                DragDir = "left";
                fscommand("PveMgrCmd","SwitchChapter\2next");
                m_isDrag = false;
            }else if (offset > 80)
            {
                //DragRight();
                DragDir = "right";
                fscommand("PveMgrCmd","SwitchChapter\2previous");
                m_isDrag = false;
            }
        }
    }
    
}


function FTEClickFirstElite()
{
	var cur_list = GetCurItem();
	cur_list.content["barrier_1"].onRelease()
}

function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.firstelite._visible = false
}

FTEHideAnim()