import com.tap4fun.utils.MovieClipsUtils;
import com.tap4fun.utils.Utils;



    var m_itemKeyList       : Array     = []
    var m_itemMCList        : Array     = []
    var m_freeMCList        : Array     = []
    var m_isVertical        : Boolean   = true
    var m_isAlignHead       : Boolean   = true
    var m_enableDrag        : Boolean   = true
    var m_panelHeight       : Number    = 0
    var m_basePosX          : Number    = 0
    var m_itemPosInterval   : Number    = 0
    var m_lastMouseY        : Number    = 0
    var m_isPressed         : Boolean   = false
    var m_inertiaOffset     : Number    = 0
    var m_isInertiaBack     : Boolean   = false
    var m_offsetQueue       : Array     = []
    var m_maxBackValue      : Number    = 0
    var m_firstVisibleItemMC: MovieClip = null
    var m_lastVisibleItemMC : MovieClip = null
    var m_hitZone_panel     : MovieClip = null
    var m_this              : MovieClip = null
    var m_firstItemIndexSlide:Number    = -1
    var m_lastItemIndexSlide: Number    = -1
    var m_totolOffsetSlide  : Number    = 0
    var m_totalScrollLength : Number    = 0
    var m_itemHeight        : Number    = 0
    var m_needUpdateItemData: Boolean   = false
    var m_showAllOneFrame   : Boolean   = false
    var m_needFreeItemCount: Number    = 0

    var THRESHOLD_ERASE     : Number    = 0
    var THRESHOLD_ADD       : Number    = 0
    var MAX_ITEM_COUNT      : Number    = 1000
    var INERTIA_ATTENUATION : Number    = 0.85
    var INERTIA_MIN_OFFSET  : Number    = 8
    var OFFSET_MIN_THRESHOLD: Number    = 3

    var m_specialItemHeight : Number    = 0
    var THRESHOLD_S_ERASE   : Number    = 0
    var THRESHOLD_S_ADD     : Number    = 0
    var MIN_ITEM_HEIGHT     : Number    = -1

    var ADD_FACOTR          : Number    = 1
    var ERASE_FACTOR        : Number    = 2

    var __SUB_DEBUG__ = true;
    function debug(data)
    {
        if(__SUB_DEBUG__)
        {
            trace(data)
        }
    }

    function enableDrag(enable:Boolean)
    {
        m_enableDrag = enable
    }

    function _getItemWidth(mc:MovieClip)
    {
        if(m_isVertical)
        {
            if( mc._itemHitzone != undefined )
            {
                return mc._itemHitzone._width;
            }
            return mc._width
        }
        else
        {
            if( mc._itemHitzone != undefined )
            {
                return mc._itemHitzone._height;
            }
            return mc._height
        }
    }

    function _getItemHeight(mc:MovieClip)
    {
        if(mc.ItemHeight) return mc.ItemHeight
        if(m_isVertical)
        {
            if( mc._itemHitzone != undefined )
            {
                return mc._itemHitzone._height;
            }
            return mc._height
        }
        else
        {
            if( mc._itemHitzone != undefined )
            {
                return mc._itemHitzone._width;
            }
            return mc._width
        }
    }

    function _setItemMCPosY(mc:MovieClip, pos:Number)
    {
        if(m_isVertical)
        {
            mc._y = pos
            mc._x = m_basePosX
        }
        else
        {
            mc._x = pos
            mc._y = m_basePosX
        }
    }

    function _getItemPosY(mc:MovieClip)
    {
        if(m_isVertical)
        {
            return mc._y
        }
        else
        {
            return mc._x
        }
    }

    function _getItemBottomPosY(mc:MovieClip)
    {
        if(m_isVertical)
        {
            return mc._y + _getItemHeight(mc)
        }
        else
        {
            return mc._x + _getItemHeight(mc)
        }
    }

    function _getPanelPosY()
    {
        if(m_isVertical) {
            return m_hitZone_panel._y;
        } else {
            return m_hitZone_panel._x;
        }
    }

    function _getPanelBottomPosY()
    {
        if(m_isVertical) {
            return m_hitZone_panel._y + m_hitZone_panel._height;
        } else {
            return m_hitZone_panel._x + m_hitZone_panel._width;
        }
    }

    function forceCorrectPosition()
    {
    //    trace("forceCorrectPosition ")
        m_inertiaOffset     =   0
        var totelBackLen    = _getInertialBackLen()
        if(totelBackLen != 0)
        {
    //       trace("inertialBack " + totelBackLen)
            _offsetMCPos(totelBackLen, -1, -1)
            m_isInertiaBack     = false
        }

        if(m_totolOffsetSlide)
        {
            _offsetMCPos(m_totolOffsetSlide, m_firstItemIndexSlide, m_lastItemIndexSlide)
            m_totolOffsetSlide  = 0
            m_firstItemIndexSlide   = -1
            m_lastItemIndexSlide    = -1
        }
        removeInvisibleMC()
        addPotentialVisibleMC()
    }

    function _getMousePosY()
    {
        if (m_isVertical)
        {
            return _root._ymouse
        }
        else
        {
            return _root._xmouse
        }
    }

    function setSpecialItemHeight(movieClipURL:String, itemInterval:Number)
    {
        var sampleMC = this.attachMovie(movieClipURL, "listBoxItem" + 0, this.getNextHighestDepth())
        sampleMC._visible = false
        m_specialItemHeight = _getItemHeight(sampleMC) + itemInterval
        debug("m_specialItemHeight "+m_specialItemHeight)
        THRESHOLD_S_ADD = m_specialItemHeight
        THRESHOLD_S_ERASE = m_specialItemHeight * 1.5

    }

    function setItemMinHeight(movieClipURL:String, itemInterval:Number)
    {
        var sampleMC = this.attachMovie(movieClipURL, "listBoxItem" + 0, this.getNextHighestDepth())
        sampleMC._visible = false
        MIN_ITEM_HEIGHT = _getItemHeight(sampleMC) + itemInterval
    }

    function getItemMinHeight()
    {
        return MIN_ITEM_HEIGHT;
    }

    function setShowItemOneFrame(isShowOneFrame)
    {
        m_showAllOneFrame = isShowOneFrame;
    }

    /*
    function setSpecialItemHeight(specialHeight:Number, itemInterval:Number)
    {
        m_specialItemHeight = specialHeight + itemInterval
        THRESHOLD_S_ADD = m_specialItemHeight
        THRESHOLD_S_ERASE = m_specialItemHeight * 2
    }
    */

    function setAddEraseFactor(addFacotr:Number, eraseFactor:Number)
    {
        debug("setAddEraseFactor "+addFacotr+" "+eraseFactor)
        ADD_FACOTR = addFacotr
        ERASE_FACTOR = eraseFactor
    }

    function initListBox(movieClipURL:String, itemInterval:Number, isVertical : Boolean, isAlignHead : Boolean )
    {
        m_this = this
        m_hitZone_panel = m_this.hitZone_panel

    //    trace("init free list size " + m_freeMCList.length)
        m_itemPosInterval = itemInterval
        m_isVertical    = isVertical
        m_isAlignHead   = isAlignHead
        var sampleMC = this.attachMovie(movieClipURL, "listBoxItem" + 0, this.getNextHighestDepth())
        sampleMC._visible = false
        if(m_this.onItemMCCreate != undefined)
        {
            m_this.onItemMCCreate(sampleMC)
        }
        m_freeMCList.push(sampleMC)
        m_itemMCList.push(sampleMC)
        var itemHeight  = _getItemHeight(sampleMC) + m_itemPosInterval
        var itemWidth   = _getItemWidth(sampleMC)
        if(isVertical)
        {
            m_panelHeight   = m_hitZone_panel._height
            m_basePosX      = Math.ceil((m_hitZone_panel._width - itemWidth)/2.0)
        }
        else
        {
            m_panelHeight = m_hitZone_panel._width
            m_basePosX      = Math.ceil((m_hitZone_panel._height - itemWidth)/2.0)
        }
        m_itemHeight = itemHeight;
        debug("init itemHeight: "+m_itemHeight)

        var count   = Math.ceil(m_panelHeight/itemHeight) + 3

        if(MIN_ITEM_HEIGHT > 0)
        {
            count   = Math.ceil(m_panelHeight/MIN_ITEM_HEIGHT) + 3
        }
        else
        {
            MIN_ITEM_HEIGHT = itemHeight
        }

        for (var i = 1; i < count; ++i)
        {
            var newMC = this.attachMovie(movieClipURL, "listBoxItem" + i, this.getNextHighestDepth())
            newMC._visible = false
            if(m_this.onItemMCCreate != undefined)
            {
                m_this.onItemMCCreate(newMC)
            }
            m_freeMCList.push(newMC)
            m_itemMCList.push(newMC)
        }

        m_maxBackValue  =   m_panelHeight/1.5
        THRESHOLD_ADD   =   itemHeight * ADD_FACOTR
        THRESHOLD_ERASE =   (itemHeight) * ERASE_FACTOR

        debug("m_hitZone_panel: " + Utils.getFullName(m_hitZone_panel))
        debug("ERASE:" + THRESHOLD_ERASE)
        debug("Add:" + THRESHOLD_ADD)
        debug("this height " + this._height)
        debug("panelHeight : " + m_panelHeight)
        debug("free list size " + m_freeMCList.length)
        debug("alllist size " + m_itemMCList.length)
        if(m_this._initScaleListbox != undefined)
        {
            m_this._initScaleListbox()
        }
    }

    function getItemData(itemIndex)
    {
        if(itemIndex < 0 or itemIndex >= m_itemKeyList.length)
        {
            debug("Warning : getItemData invalid index " + itemIndex)
            return -1
        }
        return m_itemKeyList[itemIndex]
    }

    function getItemListLength()
    {
        return m_itemKeyList.length
    }

    function getFirstVisibleItemMC()
    {
        _regetFirstAndLastVisibleItemMC()
        return m_firstVisibleItemMC
    }

    function getLastVisibleItemMC()
    {
        _regetFirstAndLastVisibleItemMC()
        return m_lastVisibleItemMC
    }

    function getMcByItemKey(itemKey)
    {
        for(var i=0; i < m_itemMCList.length; ++i)
        {
            var itemMC = m_itemMCList[i]
            if(m_itemKeyList[itemMC.ItemIndex] == itemKey)
            {
                return itemMC
            }
        }
        return null
    }

    function eraseItem(itemKey:Number)
    {
        var itemIndex  = -1
        var allItemLen = m_itemKeyList.length
        for(var i=0; i<allItemLen; ++i)
        {
            if(itemKey == m_itemKeyList[i])
            {
                itemIndex = i
                break
            }
        }
        debug("erase item " + itemKey + " index " + itemIndex)
        if(itemIndex == -1)
        {
            debug("warning: itemKey: " + itemKey + " is not in the list")
            return
        }

        var allItemMCListLen = m_itemMCList.length
        var itemMC:MovieClip = null
    //    trace("allVisibleLen " + allItemMCListLen)
        for(var i=0; i<allItemMCListLen; ++i)
        {
            var mc = m_itemMCList[i]
            if(mc._visible and mc.ItemIndex == itemIndex)
            {
                itemMC = mc
                break
            }
        }

    //    trace("itemMC been erase " + itemMC)
        if(itemMC != null)
        {
            var itemPosY    = _getItemPosY(itemMC)
            var itemButtomY = _getItemBottomPosY(itemMC)
    //        trace("itemPosY " + itemPosY)
    //        trace("itemButtomPosY " + itemButtomY)
    //        trace("itemHeight" + _getItemHeight(itemMC))
            if(itemButtomY<= 0)
            {
                m_firstItemIndexSlide   = -1
                m_lastItemIndexSlide    = itemIndex - 1
            }
            else if(itemPosY >= m_panelHeight)
            {
                m_firstItemIndexSlide   = itemIndex
                m_lastItemIndexSlide    = MAX_ITEM_COUNT
            }
            else
            {
                if(m_isAlignHead)
                {
                    m_firstItemIndexSlide   = itemIndex
                    m_lastItemIndexSlide    = MAX_ITEM_COUNT
                }
                else
                {
                    m_firstItemIndexSlide   = -1
                    m_lastItemIndexSlide    = itemIndex - 1
                }
            }
    //        trace("first itemIndex " + m_firstItemIndexSlide)
    //        trace("last  itemIndex " + m_lastItemIndexSlide)
            m_totolOffsetSlide  = -_getItemHeight(itemMC)
            hideItem(itemMC)
        }
        m_itemKeyList.splice(itemIndex, 1);
        _offsetMCItemIndex(-1, itemIndex, MAX_ITEM_COUNT)
        m_needUpdateItemData = true;
    //    trace("item size " + m_itemKeyList.length)
    }

    function hideItem(mc)
    {
        debug("hide mc")
        if(mc._visible)
        {
            m_freeMCList.push(mc)
        }
        mc._visible = false
        mc.ItemIndex = -1
        mc.ItemHeight = null
    }

    function setItemPos(itemKey, posDesc, offset)
    {
        debug("setItemPos: " + posDesc + " " + offset);
        var itemIndex = -1
        var itemKeyListLen = m_itemKeyList.length
        for(var i = 0; i<itemKeyListLen; ++i)
        {
            if(m_itemKeyList[i] == itemKey)
            {
                itemIndex = i
                break
            }
        }

        var itemMCLen = m_itemMCList.length
        for(var i=0; i<itemMCLen; ++i)
        {
            hideItem(m_itemMCList[i])
        }

        var mc = m_this.addToVisibleList(itemIndex, null, true)
        var newItemPosY = 0
        if(posDesc == "head")
        {
            newItemPosY = offset
        }
        else if(posDesc == "center")
        {
            newItemPosY = m_panelHeight/2.0 + offset
        }
        else if(posDesc == "tail")
        {
            newItemPosY = m_panelHeight - _getItemHeight(mc) + offset
        }
        else
        {

        }
        _setItemMCPosY(mc, newItemPosY)

        var count = 0
        while(addPotentialVisibleMC())
        {
            count++
            if(count > 30)
            {
                debug("Error: infinite loop in setItemPos")
                break
            }
        }
        if(posDesc == "tail")
        {
            var totelBackLen = _getInertialBackLen()
            _offsetMCPos(totelBackLen, -1, -1)
        }

        return mc
    }

    function insertItem(itemKey, pos, forceShow)
    {
        debug("insertItem " + itemKey + pos + forceShow)
        var itemKeyListLen = m_itemKeyList.length
        var newMC = null
        if(pos >= itemKeyListLen)
        {
            newMC = addListItem(itemKey, false, forceShow)
        }
        else if(pos <= 0)
        {
            newMC = addListItem(itemKey, true, forceShow)
        }
        else
        {
            m_itemKeyList.splice(pos, 0, itemKey)
            var allItemLen = m_itemMCList.length
            var nextItemMC = null //newInsertItem
            for(var i=0; i<allItemLen; ++i)
            {
                var mc = m_itemMCList[i]
                if(mc._visible and mc.ItemIndex == pos)
                {
                    nextItemMC = mc
                    mc.ItemIndex += 1
                }
                else if(mc._visible and mc.ItemIndex > pos)
                {
                    mc.ItemIndex += 1
                }
            }

            if(nextItemMC != null)
            {
                var itemPosY        = _getItemPosY(nextItemMC)
                var itemButtomPosY  = _getItemBottomPosY(nextItemMC)
    //            if(itemPosY > 0 and itemButtomPosY < m_panelHeight)
                {
                    newMC = addToVisibleList(pos, nextItemMC, true)
                    _setItemMCPosY(newMC,   itemPosY)
                    m_firstItemIndexSlide   = pos + 1
                    m_lastItemIndexSlide    = MAX_ITEM_COUNT
                    m_totolOffsetSlide      = _getItemHeight(newMC)
                }
            }
        }
        return newMC
    }

    function addListItem(itemKey, addToHead, forceShow)
    {
        debug("addListItem " + itemKey + addToHead + forceShow)
        var newMC = null
        if(not addToHead)
        {
            m_itemKeyList.push(itemKey)
            if(m_itemKeyList.length <= m_itemMCList.length)
            {
                _regetFirstAndLastVisibleItemMC()
                var itemIndex = 0
                if(m_lastVisibleItemMC != null)
                {
                    itemIndex = m_lastVisibleItemMC.ItemIndex + 1
                }
                newMC = addToVisibleList(itemIndex, m_lastVisibleItemMC, false)
            }
            if(forceShow)
            {
                newMC = setItemPos(itemKey, "tail", 0)
            }
        }
        else
        {
            m_itemKeyList.unshift(itemKey)
            _offsetMCItemIndex(1, 0, MAX_ITEM_COUNT)
            if(m_itemKeyList.length <= m_itemMCList.length)
            {
                _regetFirstAndLastVisibleItemMC()
                var itemIndex = 0
                if(m_firstVisibleItemMC!= null)
                {
                    itemIndex = m_firstVisibleItemMC.ItemIndex - 1
                    newMC = addToVisibleList(itemIndex, null, true)
                    _setItemMCPosY(newMC, _getItemPosY(m_firstVisibleItemMC))
                }
                else
                {
                    newMC = addToVisibleList(itemIndex, null, true)
                }
            }

            debug(newMC)
            debug(m_itemKeyList.length)
            if(forceShow)
            {
                newMC = setItemPos(itemKey, "head", 0)
            }
            else if(newMC and m_itemKeyList.length >= 2)
            {
                m_firstItemIndexSlide   = 1
                m_lastItemIndexSlide    = MAX_ITEM_COUNT
                m_totolOffsetSlide      = _getItemWidth(newMC)
            }
        }
        return newMC
    }

    function addToVisibleList(itemIndex, MCAddTo, addToHead)
    {
        debug("free MC len" + m_freeMCList.length)
        debug("addToVisibleList " + itemIndex + addToHead)
        if(m_freeMCList.length <= 0)
        {
            return
        }

        var mc = m_freeMCList.pop()
        mc._visible     = true
        mc.ItemIndex    = itemIndex
        var itemKey     = m_itemKeyList[itemIndex]

        if(m_this.onItemEnter)
        {
            m_this.onItemEnter(mc, itemKey)
        }
        
        var itemPosY = m_itemPosInterval
        if(addToHead)
        {
            if(MCAddTo != null)
            {
                var headItemPosY = _getItemPosY(MCAddTo)
                itemPosY = headItemPosY - _getItemHeight(mc) - m_itemPosInterval
            }
        }
        else
        {
            if(MCAddTo != null)
            {
                itemPosY = _getItemBottomPosY(MCAddTo) + m_itemPosInterval
            }
        }
        debug("mc._x: "+mc._x)
        debug("addToVisibleList: "+itemPosY)
        _setItemMCPosY(mc, itemPosY)
        if(m_this._scaleItemCallback)
        {
            m_this._scaleItemCallback(mc)
        }
        return mc
    }

    function removeInvisibleMC()
    {
        if(!m_showAllOneFrame)
        {
            if(m_freeMCList.length > 0)
            {
                debug("m_freeMCList.length "+m_freeMCList.length)
                return
            }
        }
        else
        {
            debug("m_freeMCList.length: " + m_needFreeItemCount)
            if(m_freeMCList.length >= m_needFreeItemCount)
            {
                debug("m_freeMCList.length "+m_freeMCList.length)
                return
            }
        }

        var allItemMCListLen = m_itemMCList.length
        for(var i=0; i<allItemMCListLen; ++i)
        {
            var mc = m_itemMCList[i]

            if(mc.isSpecial && THRESHOLD_S_ERASE > 0)
            {
                debug("try removeInvisibleMC isSpecial")
                debug(_getItemPosY(mc)+" "+ (-THRESHOLD_S_ERASE))
                debug(_getItemBottomPosY(mc)+" "+m_panelHeight+ THRESHOLD_S_ERASE)
                if(_getItemPosY(mc) < -THRESHOLD_S_ERASE)
                {
                    m_this.onItemLeave(mc, mc.ItemIndex)
                    debug("AAA")
                    hideItem(mc)
                }
                else if(_getItemBottomPosY(mc) > m_panelHeight+ THRESHOLD_S_ERASE )
                {
                     debug("BBB")
                    m_this.onItemLeave(mc, mc.ItemIndex)
                    hideItem(mc)
                }            
            }
            else
            {
                debug("try removeInvisibleMC normal")
                debug(_getItemPosY(mc)+" "+ (-THRESHOLD_ERASE))
                debug(_getItemBottomPosY(mc)+" "+(m_panelHeight+ THRESHOLD_ERASE))            
                if(_getItemPosY(mc) < -THRESHOLD_ERASE)
                {
                     debug("CCC")
                    m_this.onItemLeave(mc, mc.ItemIndex)
                    hideItem(mc)
                }                
                else if(_getItemBottomPosY(mc) > m_panelHeight+ THRESHOLD_ERASE )
                {
                     debug("DDD")
                    m_this.onItemLeave(mc, mc.ItemIndex)
                    hideItem(mc)
                }            
            }
        }
    }

    function addPotentialVisibleMC()
    {
        debug("addPotentialVisibleMC")
        if(m_freeMCList.length <= 0 or m_itemKeyList.length <= 0)
        {
            debug("m_freeMCList length: "+m_freeMCList.length+"m_itemKeyList len:"+m_itemKeyList.length)
            return
        }

        var newItemAdded = false
        _regetFirstAndLastVisibleItemMC()
        if(m_firstVisibleItemMC == null or m_lastVisibleItemMC == null)
        {
            debug("m_firstVisibleItemMC == null")
            addToVisibleList(0, null, true)
            newItemAdded = true
            return newItemAdded
        }

        if(m_firstVisibleItemMC.isSpecial && THRESHOLD_S_ADD > 0)
        {
            debug("addPotentialVisibleMC isSpecial")
            if(m_firstVisibleItemMC.ItemIndex >0 and _getItemPosY(m_firstVisibleItemMC) > - THRESHOLD_S_ADD)
            {
                debug("AAA")
                addToVisibleList(m_firstVisibleItemMC.ItemIndex - 1, m_firstVisibleItemMC, true)
                newItemAdded = true
                return newItemAdded
            }

            if(m_lastVisibleItemMC.ItemIndex + 1 < m_itemKeyList.length and _getItemBottomPosY(m_lastVisibleItemMC) < m_panelHeight + THRESHOLD_S_ADD )
            {
                debug("BBB")
                addToVisibleList(m_lastVisibleItemMC.ItemIndex + 1, m_lastVisibleItemMC, false)
                newItemAdded = true
                return newItemAdded
            }        
        }
        else
        {
            debug("addPotentialVisibleMC normal")
            if(m_firstVisibleItemMC.ItemIndex >0 and _getItemPosY(m_firstVisibleItemMC) > - THRESHOLD_ADD)
            {
                debug("CCC")
                addToVisibleList(m_firstVisibleItemMC.ItemIndex - 1, m_firstVisibleItemMC, true)
                newItemAdded = true
                return newItemAdded
            }

            if(m_lastVisibleItemMC.ItemIndex + 1 < m_itemKeyList.length and _getItemBottomPosY(m_lastVisibleItemMC) < m_panelHeight + THRESHOLD_ADD )
            {
                debug("DDD")
                addToVisibleList(m_lastVisibleItemMC.ItemIndex + 1, m_lastVisibleItemMC, false)
                newItemAdded = true
                return newItemAdded
            }
        }

        return false
    }

    function clearListBox()
    {
        for (var i = 0; i < m_itemMCList.length; ++i)
        {
            var mc = m_itemMCList[i]
            mc._visible = false
            mc.ItemIndex = -1
            mc.ItemHeight = null
            mc.removeMovieClip()
        }

        m_itemKeyList.splice(0)
        m_itemMCList.splice(0)
        m_freeMCList.splice(0)
        m_isInertiaBack = false
        m_inertiaOffset = 0
    }

    function onPressedInListbox()
    {   
        trace('=======-=========onPressedInListbox')
        if(not m_isPressed)
        {   
            m_isPressed = true
            m_lastMouseY = _getMousePosY()
            m_offsetQueue.splice(0)
            m_offsetQueue.push(0)
            m_offsetQueue.push(0)
            m_offsetQueue.push(0)
            forceCorrectPosition()
        }
    }

    function onReleasedInListbox()
    {
        trace('=======-=========onReleasedInListbox')
        if(m_isPressed)
        {
            m_isPressed = false
            m_inertiaOffset =  (m_offsetQueue[0] + m_offsetQueue[1] + m_offsetQueue[2])/3.0
    //        trace("fuck inertialOffset " + m_inertiaOffset)
            m_offsetQueue.splice(0)
            if(m_inertiaOffset == 0)
            {
                m_isInertiaBack = true
            }
        }
    }

    function needUpdateVisibleItem()
    {
        for (var i = 0; i < m_itemMCList.length; ++i)
        {
            var mc = m_itemMCList[i]
            var itemKey     = m_itemKeyList[mc.ItemIndex]
            if( itemKey )
            {
                if(m_this.onItemEnter)
                {
                    m_this.onItemEnter(mc, itemKey)
                }
            }
        }
    }

    //this function do the same things as the function 'computeVisiblePos'
    //but when the return value result_pos.spos is large than 1,
    //this function will return 1,
    //the function named 'computeVisiblePos' will returan a 0 when there are some disvisable in the itme_lisg
    //it's a bug but there are many file include this , so i add a new function for safe!
    function fix_computeVisiblePos()
    {
        var result_pos = {}
        var list_length = m_itemKeyList.length * m_itemHeight;

        if(m_specialItemHeight > 0)
        {
            list_length = list_length + (m_specialItemHeight - m_itemHeight)
        }

        if( list_length == 0 )
        {
            result_pos.spos = 0;
            result_pos.epos = 99999;
            result_pos.item_height = 99999;
            return result_pos;
        }

        result_pos.item_height = m_itemHeight / list_length;
        var panel_length_rate = m_panelHeight / list_length;

        var visible_item_top = {};
        visible_item_top.list_item = undefined;
        visible_item_top.index_item = undefined;
        visible_item_top.min_ypos = 99999;

        var panel_pos_top = _getPanelPosY();
        var panel_pos_bottom = _getPanelBottomPosY();

        for( var i=0; i<m_itemMCList.length; ++i )
        {
            var mc_item = m_itemMCList[i];
            var pos_top = _getItemPosY(mc_item);
            var pos_bottom = _getItemBottomPosY(mc_item);
            if( mc_item._visible && pos_bottom > panel_pos_top && pos_top < visible_item_top.min_ypos )
            {
                visible_item_top.index_item = i;
                visible_item_top.list_item = mc_item;
                visible_item_top.min_ypos = pos_top;
            }
        }

        if( visible_item_top.list_item == undefined )
        {
            result_pos.spos = 1;
            result_pos.epos = result_pos.spos + panel_length_rate;
        }
        else
        {
            var item_index= visible_item_top.list_item.ItemIndex;
            if(item_index == undefined) item_index = 0;
            var ypos_offset = panel_pos_top - _getItemPosY(visible_item_top.list_item) + (item_index * m_itemHeight) ;
            result_pos.spos = ypos_offset / list_length;
            result_pos.epos = result_pos.spos + panel_length_rate;
        }

        return result_pos;
    }


    //if you find some abnormal when use this funtion , try function 'fix_computeVisiblePos', ^ ^
    function computeVisiblePos()
    {
        var result_pos = {}
        var list_length = m_itemKeyList.length * m_itemHeight;

        if(m_specialItemHeight > 0)
        {
            list_length = list_length + (m_specialItemHeight - m_itemHeight)
        }

        if( list_length == 0 )
        {
            result_pos.spos = 0;
            result_pos.epos = 99999;
            result_pos.item_height = 99999;
            return result_pos;
        }

        result_pos.item_height = m_itemHeight / list_length;
        var panel_length_rate = m_panelHeight / list_length;

        var visible_item_top = {};
        visible_item_top.list_item = undefined;
        visible_item_top.index_item = undefined;
        visible_item_top.min_ypos = 99999;

        var panel_pos_top = _getPanelPosY();
        var panel_pos_bottom = _getPanelBottomPosY();

        for( var i=0; i<m_itemMCList.length; ++i )
        {
            var mc_item = m_itemMCList[i];
            var pos_top = _getItemPosY(mc_item);
            var pos_bottom = _getItemBottomPosY(mc_item);
            if( pos_bottom > panel_pos_top && pos_top < visible_item_top.min_ypos )
            {
                visible_item_top.index_item = i;
                visible_item_top.list_item = mc_item;
                visible_item_top.min_ypos = pos_top;
            }
        }

        if( visible_item_top.list_item == undefined )
        {
            result_pos.spos = 1;
            result_pos.epos = result_pos.spos + panel_length_rate;
        }
        else
        {
            var item_index= visible_item_top.list_item.ItemIndex;
            if(item_index == undefined) item_index = 0;
            var ypos_offset = panel_pos_top - _getItemPosY(visible_item_top.list_item) + (item_index * m_itemHeight) ;
            result_pos.spos = ypos_offset / list_length;
            result_pos.epos = result_pos.spos + panel_length_rate;
        }

        //registHitZoneDrag();

        return result_pos;
    }

    function registHitZoneDrag()
    {
        debug("m_hitZone_panel2: " + Utils.getFullName(m_hitZone_panel))
        m_hitZone_panel.onPress = function()
        {
            debug("m_hitZone_panel.onPress")
            onPressedInListbox()
        }

        m_hitZone_panel.onRelease = m_hitZone_panel.onReleaseOutside = function()
        {
            debug("m_hitZone_panel.onRelease")
            onReleasedInListbox()
        }
    }

    function getItemKey(mc)
    {
        return m_itemKeyList[mc.ItemIndex]
    }


    function onItemPressed(mc)
    {
        onPressedInListbox()
        return m_itemKeyList[mc.ItemIndex]
    }

    function onItemReleased(mc)
    {
        onReleasedInListbox()
        return m_itemKeyList[mc.ItemIndex]
    }

    function _regetFirstAndLastVisibleItemMC()
    {
        m_firstVisibleItemMC = null
        m_lastVisibleItemMC = null
        var allItemLen = m_itemMCList.length
        for(var i=0; i<allItemLen; ++i)
        {
            var itemMC = m_itemMCList[i]
            if(itemMC._visible == true)
            {
                if(m_firstVisibleItemMC == null or (itemMC.ItemIndex < m_firstVisibleItemMC.ItemIndex))
                {
                    m_firstVisibleItemMC = itemMC
                }
                if(m_lastVisibleItemMC == null or (itemMC.ItemIndex > m_lastVisibleItemMC.ItemIndex))
                {
                    m_lastVisibleItemMC = itemMC
                }
            }
        }
    }

    //warning: should call _regetFirstAndLastVisibleItemMC() before use
    function isReachHeadLimit()
    {
        return m_firstVisibleItemMC.ItemIndex == 0 and _getItemPosY(m_firstVisibleItemMC) >= 0
    }

    //warning: should call _regetFirstAndLastVisibleItemMC() before use
    function isReachTailLimit()
    {
        return m_lastVisibleItemMC.ItemIndex == m_itemKeyList.length - 1 and _getItemBottomPosY(m_lastVisibleItemMC) <= m_panelHeight
    }

    function _getInertialBackLen()
    {
        _regetFirstAndLastVisibleItemMC()
        if(m_firstVisibleItemMC == null or m_lastVisibleItemMC == null)
        {
            return 0
        }

        var isReachHead     = m_firstVisibleItemMC.ItemIndex == 0
        var isReachTail     = m_lastVisibleItemMC.ItemIndex == m_itemKeyList.length - 1
        var headItemYPos    = _getItemPosY(m_firstVisibleItemMC)
        var tailItemButtomYPos    = _getItemBottomPosY(m_lastVisibleItemMC)
        var inertiaBackLen = 0
        if(isReachHead and headItemYPos > 0)
        {
            inertiaBackLen = -headItemYPos
        }
        else if(isReachTail and tailItemButtomYPos < m_panelHeight )
        {
            inertiaBackLen = Math.min(m_panelHeight - tailItemButtomYPos, -headItemYPos)
        }

    //    trace(isReachHead)
    //    trace(isReachTail)
    //    trace(headItemYPos)
    //    trace(tailItemButtomYPos)
    //    trace(inertiaBackLen)
        return inertiaBackLen
    }

    function _getRealoffsetValue(offsetAttempt:Number)
    {
        var offsetValue = offsetAttempt
        var offsetScale = 0
        if(not m_isInertiaBack)
        {
            var inertiaBackLen = _getInertialBackLen()
            if(inertiaBackLen != 0)
            {
                var absLen = Math.abs(inertiaBackLen)
                if(inertiaBackLen * offsetValue < 0 )
                {
                    offsetScale = 1 - (absLen + Math.abs(offsetValue/3.0))/(m_maxBackValue)
                    offsetScale = Math.max(0, offsetScale)
                }
                else
                {
                    offsetScale = 1 - (absLen - Math.abs(offsetValue/3.0))/(m_maxBackValue)
                    offsetScale = Math.min(1.0, offsetScale)
                }
                offsetValue *= offsetScale
            }
    //        trace("fuck offsetScale" + offsetScale)
        }
    //    trace("fuck offsetValue " + offsetValue)
        return offsetValue
    }

    function _offsetMCItemIndex(offsetValue:Number, firstItemIndex:Number, lastItemIndex:Number)
    {
        for (var i = 0; i < m_itemMCList.length; ++i)
        {
            var mc = m_itemMCList[i]
            if(mc._visible)
            {
                if(firstItemIndex != -1 and lastItemIndex != -1)
                {
                    var itemIndex = mc.ItemIndex
                    if(itemIndex > lastItemIndex or itemIndex < firstItemIndex)
                    {
                        continue
                    }
                    mc.ItemIndex += offsetValue
                }
            }
        }
    }
    // those whose itemIndex "isLargerThenRef" than "itemIndexRef" will recaculate position
    function _offsetMCPos(offsetValue:Number, firstItemIndex:Number, lastItemIndex:Number)
    {
        for (var i = 0; i < m_itemMCList.length; ++i)
        {
            var mc = m_itemMCList[i]
            if(mc._visible)
            {
                if(firstItemIndex != -1 or lastItemIndex != -1)
                {
                    var itemIndex = mc.ItemIndex
                    if(itemIndex > lastItemIndex or itemIndex < firstItemIndex)
                    {
                        continue
                    }
                }
                var YPos = _getItemPosY(mc)
                YPos += offsetValue
                _setItemMCPosY(mc,YPos)

                if(m_this._scaleItemCallback)
                {
                    m_this._scaleItemCallback(mc)
                }
            }
        }
        if(m_this.onListboxMove != undefined)
        {
            m_this.onListboxMove()
        }
        setListBoxArrowVisible()
    }

    function enableAutoArrowSet(isEnable, upArrowMC, downArrowMC)
    {
        m_this.upArrow = upArrowMC;
        m_this.downArrow = downArrowMC;
        m_this.enable = isEnable
    }   

    function setListBoxArrowVisible()
    {
        if(m_this.upArrow)
        {
            m_this.upArrow._visible = false
        }
        if(m_this.downArrow)
        {
            m_this.downArrow._visible = false
        }
        var visible_pos = fix_computeVisiblePos();
        if(1 - visible_pos.epos > ( visible_pos.item_height * 0.5 ) and m_this.downArrow)
        {
            m_this.downArrow._visible = true;
        }
        if(visible_pos.spos > ( visible_pos.item_height * 0.5 ) and m_this.upArrow)
        {
            // trace('main._prev')
            m_this.upArrow._visible = true;
        }
    }

    function CheckShowAndHideItem()
    {
        removeInvisibleMC()

        if(!m_showAllOneFrame)
        {
            addPotentialVisibleMC()
        }
        else
        {
            var count = 0
            while(addPotentialVisibleMC())
            {
                count++
                if(count > 30)
                {
                    debug("Error: infinite loop in setItemPos")
                    break
                }
            }
        }
    }

    function setNeedFrameItemCount(offset)
    {
        offset = Math.abs(offset)
        m_needFreeItemCount = Math.ceil(offset / getItemMinHeight())
    }

    function OnUpdate()
    {
        //debug("listbox OnUpdate")
        if(m_isPressed and m_enableDrag)
        {
            var currentMouseY = _getMousePosY()
            var offset = currentMouseY - m_lastMouseY
            offset = _getRealoffsetValue(offset)
            m_offsetQueue.push(offset)
            if(m_offsetQueue.length > 3)
            {
                m_offsetQueue.shift()
            }
            if(Math.abs(offset) >= 1)
            {
    //            trace("fuck padMove offset " + offset)
                _offsetMCPos(offset, -1, -1)

                setNeedFrameItemCount(offset)

                m_lastMouseY = currentMouseY
                CheckShowAndHideItem()
            }
        }
        else if(m_inertiaOffset != 0)
        {
            if(Math.abs(m_inertiaOffset) < INERTIA_MIN_OFFSET)
            {
                m_inertiaOffset = 0
                m_isInertiaBack = true
            }
            else
            {
                var offset = _getRealoffsetValue(m_inertiaOffset)
    //            trace("fuck inertia offset " + offset)
                var attenuation = INERTIA_ATTENUATION
                // if inertial direction is opposite with the InertilBack direction, it should move with more resistance
                if(offset < m_inertiaOffset)
                {
                    offset *= 0.5
                    attenuation *= 0.6
                }
                _offsetMCPos(offset, -1, -1)
                setNeedFrameItemCount(offset)
                CheckShowAndHideItem()
                m_inertiaOffset *= attenuation
            }
        }
        else if(m_totolOffsetSlide != 0)
        {
    //        trace("fuck offsetSlide " + m_totolOffsetSlide)
            var offset = m_totolOffsetSlide
            if(Math.abs(m_totolOffsetSlide) < OFFSET_MIN_THRESHOLD)
            {
                _offsetMCPos(offset, m_firstItemIndexSlide, m_lastItemIndexSlide)
                m_firstItemIndexSlide   = -1
                m_lastItemIndexSlide    = -1
                m_totolOffsetSlide = 0
            }
            else
            {
                offset = Math.ceil(m_totolOffsetSlide * 0.2)
                var absoffset = Math.abs(offset)
                if(absoffset < OFFSET_MIN_THRESHOLD)
                {
                    offset = (offset > 0) ? OFFSET_MIN_THRESHOLD : -OFFSET_MIN_THRESHOLD
                }
                _offsetMCPos(offset, m_firstItemIndexSlide, m_lastItemIndexSlide)
                m_totolOffsetSlide -= offset
            }
            setNeedFrameItemCount(offset)

            CheckShowAndHideItem()
        }
        else if(m_isInertiaBack)
        {
            var totalBackLen = _getInertialBackLen()
    //        trace("fuck inertialBack " + totalBackLen)

            var offset = 0
            if(Math.abs(totalBackLen) < OFFSET_MIN_THRESHOLD)
            {
                offset = totalBackLen
                m_isInertiaBack = false
            }
            else
            {
                offset = totalBackLen * 0.2
                if(totalBackLen > 0)
                {
                    offset = Math.max(offset, OFFSET_MIN_THRESHOLD)
                }
                else
                {
                    offset = Math.min(offset, -OFFSET_MIN_THRESHOLD)
                }
            }
    //        trace("fuck " + offset)
            _offsetMCPos(offset, -1, -1)
            setNeedFrameItemCount(offset)
            CheckShowAndHideItem()
        }

        if(m_needUpdateItemData)
        {
            needUpdateVisibleItem();
            m_needUpdateItemData = undefined;
        }
    }

    function FixListItemPos(mc:MovieClip, isFixUp:Boolean, isFixDown)
    {
        if(isFixUp)
        {
            var posY = _getItemPosY(mc);
            if(posY < _getPanelPosY())
            {
                if(true)
                {
                    trace("FixListItemPos: up " + posY + " " + _getPanelPosY() + " " + itemKey);
                    trace("" + Utils.getFullName(mc));
                }

                _offsetMCPos(_getPanelPosY() - posY, -1, -1);
                CheckShowAndHideItem();
                return;
            }
        }
        
        if(isFixDown)
        {
            var posY = _getItemBottomPosY(mc);
            if(posY > _getPanelBottomPosY())
            {
                var itemKey = getItemKey(mc);

                if(true)
                {
                    trace("FixListItemPos: down " + posY + " " + _getPanelBottomPosY() + " " + itemKey);
                    trace("" + Utils.getFullName(mc));
                }

                _offsetMCPos(_getPanelBottomPosY() - posY, -1, -1);
                setNeedFrameItemCount(_getPanelBottomPosY() - posY);
                CheckShowAndHideItem();
                return;
            }
        }
    }

	// reset the each item height and position.
    function RefreshListItemHeight()
    {
        trace("RefreshListItemHeight");

        if(m_itemKeyList.length >= 2)
        {
            var preMC:MovieClip = getMcByItemKey(m_itemKeyList[0]);
            for(var idx:Number = 1; idx < m_itemKeyList.length; idx++)
            {
                var mc:MovieClip = getMcByItemKey(m_itemKeyList[idx]);

                if(mc)
                {
                    if(preMC)
                    {
                        var itemPosY:Number = _getItemBottomPosY(preMC) + m_itemPosInterval;                
                        _setItemMCPosY(mc, itemPosY);                    
                    }

                    preMC = mc;                
                }
            }
        }
    }



