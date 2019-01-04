import com.tap4fun.utils.Utils;


class common.CDragList extends MovieClip
{
    var m_this          = undefined;
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
    var m_moveSpeed     = 10;
    var m_curMoveOffset = 0;
    var m_isDrag        = false;
    var m_pressPos      = 0;

    var m_startTime       = 0; //ms
    var m_intervalTime  = 5000; //ms
    var m_isAutoMove    = false;



    var onItemEnter     = undefined;
    var onMoveIn        = undefined;
    var onMoveStart     = undefined;
    var onClick         = undefined;

    function Init()
    {
        m_this = this;
        m_hitZone_panel = m_this.hitZone_panel;
        m_slideItem     = m_this.slideItem;
        m_itemWidth     = GetItemWidth();
        _DragInput();
    }


    function AddItem(mc_url, index)
    {
        var newMC = m_slideItem.attachMovie(mc_url, "Item" + m_maxIndex, m_slideItem.getNextHighestDepth());
        newMC.m_index = index;
        trace("------------dragList=" + index)
        m_listMc.push(newMC);

        if (onItemEnter != undefined)
        {
            onItemEnter(newMC, newMC.m_index);
        }

        if (m_maxIndex == 0) //first
        {
            newMC._visible = true;
            m_curIndex = 0;
            m_curMc = newMC;
            onMoveIn(m_curMc);
        }else
        {
            newMC._visible = false;
        }
        m_maxIndex = m_maxIndex + 1;
        return newMC;
    }

    function GetLeftItem()
    {
        if (m_curIndex == 0)
        {
            return m_listMc[m_maxIndex - 1];
        }else
        {
            return m_listMc[m_curIndex - 1];
        }
    }

    function GetRightItem()
    {
        if (m_curIndex == m_maxIndex - 1)
        {
            return m_listMc[0];
        }else
        {
            return m_listMc[m_curIndex + 1];
        }
    }

    function GetItemWidth()
    {
        return m_hitZone_panel._width;
    }

    function OnUpdate()
    {
        if (m_dragStart)
        {
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
                m_curMoveOffset = 0;
                m_lastMc._visible = false;
                if (onMoveIn != undefined)
                {
                    onMoveIn(m_curMc);
                }
                m_startTime = 0;
            }
        }
        if (m_isAutoMove)
        {
            var curDate = new Date();
            var curMilliseconds = curDate.getTime();
            if (m_startTime == 0)
            {
                m_startTime = curMilliseconds;
            }
            var offset = curMilliseconds - m_startTime;
            if (offset >= m_intervalTime)
            {
                DragLeft();
            }
        }
    }

    function SetItemPosX(mc, offset)
    {
        mc._x = m_lastMc._x + offset;
    }

    function DragLeft()
    {
        if (m_dragStart)
        {
            return;
        }
        var item = GetRightItem();
        item._visible = true;
        m_curIndex = item.m_index;
        m_lastMc = m_curMc;
        m_curMc = item;
        SetItemPosX(item, m_itemWidth);
        m_dragStart = true;
        m_dragDir = 0;
        if (onMoveStart != undefined)
        {
            onMoveStart(m_lastMc);
        }
    }

    function DragRight()
    {
        if (m_dragStart)
        {
            return;
        }
        var item = GetLeftItem();
        item._visible = true;
        m_curIndex = item.m_index;
        m_lastMc = m_curMc;
        m_curMc = item;
        SetItemPosX(item, -m_itemWidth);
        m_dragStart = true;
        m_dragDir = 1;
        if (onMoveStart != undefined)
        {
            onMoveStart(m_lastMc);
        }
    }

    function GetCurItem()
    {
        return m_curMc
    }
    
    function GetItemByIndex(index)
    {
        return m_listMc[index];
    }

    function SetAutoMove(is_auto)
    {
        m_isAutoMove = is_auto;
    }

    function _DragInput()
    {
        m_hitZone_panel.onPress = function()
        {
            this._parent.m_isDrag = true;
            m_pressPos = _root._xmouse;
        }

        m_hitZone_panel.onReleaseOutside = function()
        {
            this._parent.m_isDrag = false;
        }

        m_hitZone_panel.onRelease = function()
        {
            this._parent.m_isDrag = false;
            if (this._parent.onClick and !this._parent.m_dragStart)
            {
                this._parent.onClick(this._parent.m_curMc);    
            }
        }
        m_hitZone_panel.onEnterFrame = function()
        {
            if (this._parent.m_isDrag && (this._parent.m_maxIndex > 1))
            {
                var offset = _root._xmouse - m_pressPos;
                if (offset < -40)
                {
                    this._parent.DragLeft();
                    this._parent.m_isDrag = false;
                }else if (offset > 40)
                {
                    this._parent.DragRight();
                    this._parent.m_isDrag = false;
                }
            }
        }
        
    }

}




