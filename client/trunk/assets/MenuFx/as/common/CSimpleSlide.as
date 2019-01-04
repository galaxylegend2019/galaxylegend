import com.tap4fun.utils.Utils;


class common.CSimpleSlide extends MovieClip
{
	var k_offsetQueueLength : Number	= 3.0;

	var INERTIA_ATTENUATION : Number    = 0.85;
	var OFFSET_MIN_THRESHOLD: Number    = 3;
	var INERTIA_MIN_OFFSET  : Number    = 8;

	var m_inertiaOffset		: Number	= 0;
	var m_offsetQueue       : Array     = [];
	var m_isInertiaBack		: Boolean	= false;
	var m_enableDrag		: Boolean	= true;
	var m_lastMouseY        : Number    = 0;
    var m_pressPosX         : Number    = 0;
    var m_pressPosY         : Number    = 0;
	var m_maxBackValue		: Number	= 0;
	var m_totolOffsetSlide  : Number    = 0;

	var m_isPressed         : Boolean   = false;
	var m_isVertical		: Boolean   = true;
	var m_slideBox			: MovieClip = null;
	var m_this				: MovieClip = null;
    var m_slideItem         : MovieClip = null;
	var m_slideItem2		: MovieClip = null;
	var m_hitZone_panel		: MovieClip = null;
    var m_percent           : Number    = 0;
    var m_isNeedScoll       : Boolean   = false;

	var __DEBUG__			: Boolean	= false;

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

    function _getMousePosX()
    {
        if (m_isVertical)
        {
            return _root._xmouse
        }
        else
        {
            return _root._ymouse
        }
    }

    function _getItemPosY()
    {
        if(m_isVertical)
        {
            return m_slideItem._y
        }
        else
        {
            return m_slideItem._x
        }
    }

    function _getItemHeight()
    {
        if(m_slideItem.itemHeight != undefined)
        {
            return m_slideItem.itemHeight;
        }

        if(m_isVertical)
        {
            if(m_slideItem._itemHitzone != undefined)
            {
                return m_slideItem._itemHitzone._height;
            }

            return m_slideItem._height
        }
        else
        {
            if(m_slideItem._itemHitzone != undefined)
            {
                return m_slideItem._itemHitzone._width;
            }
            return m_slideItem._width
        }
    }


    function _setItemOffPosY(pos)
    {
        if(__DEBUG__)
        {
            trace("_setItemOffPosY: " + pos);
        }


        if(m_isVertical)
        {
            m_slideItem._y += pos
            m_slideItem2._y += pos
        }
        else
        {
            m_slideItem._x += pos
            m_slideItem2._x += pos
        }

        if(m_isNeedScoll)
        {
            var itemY = _getItemPosY();
            var itemHeight = _getItemHeight();
            var panelTopY = _getPanelPosY();
            var panelBottomY = _getPanelBottomPosY();

            if(itemY + itemHeight <= panelBottomY)
            {
                m_percent = 100;
            }
            else if(itemY >= panelTopY)
            {
                m_percent = 0;
            }
            else
            {
                var dh = _getItemHeight() - _getPanelHeight();
                m_percent = 100 * (panelTopY - itemY) / dh;
            }
        }
    }

    function OnHeightChanged()
    {
        if(_getItemHeight() > _getPanelHeight())
        {
            m_isNeedScoll = true;
        }
        else
        {
            m_isNeedScoll = false;
        }
    }

    function IsNeedScoll()
    {
        return m_isNeedScoll;
    }

    function GetPercent()
    {
        return m_percent;
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
            return m_hitZone_panel._y + _getPanelHeight();
        } else {
            return m_hitZone_panel._x + _getPanelHeight();
        }
    }

    function _getPanelHeight()
    {
        // if(m_hitZone_panel.PanelHeight != undefined)
        // {
        //     m_hitZone_panel.PanelHeight;
        // }

        if(m_isVertical) {
            return m_hitZone_panel._height;
        } else {
            return m_hitZone_panel._width;
        }
    }

    function IsReleaseInPressedPos()
    {
        //trace("IsReleaseInPressedPos: " + m_pressPosX + " " + _getMousePosX() + " " + m_pressPosY + " " + _getMousePosY());
        return Math.abs(m_pressPosX - _getMousePosX()) < 15 && Math.abs(m_pressPosY - _getMousePosY()) < 15;
    }

    function onPressedInListbox()
    {
        if(!m_isPressed)
        {
            m_isPressed = true;
            m_pressPosX = _getMousePosX();
            m_pressPosY = _getMousePosY();

            if(__DEBUG__)
            {
                trace("onPressedInListbox: " + m_pressPosX + " " + m_pressPosY);
            }

            m_lastMouseY = _getMousePosY();

            m_offsetQueue.splice(0);
            for(var i = 0; i < k_offsetQueueLength; i++)
            {
            	m_offsetQueue.push(0);
            }

            forceCorrectPosition();
        }
    }

    function onReleasedInListbox()
    {
        if(m_isPressed)
        {
            m_isPressed = false;
            m_inertiaOffset = 0;
            for(var i = 0; i < k_offsetQueueLength; i++)
            {
            	m_inertiaOffset += m_offsetQueue[i];
            }
            m_offsetQueue.splice(0);

            if(__DEBUG__)
            {
            	trace((m_inertiaOffset / (k_offsetQueueLength * 1.0)));
            }

            m_inertiaOffset =  m_inertiaOffset / (k_offsetQueueLength * 1.0);
            
            if(m_inertiaOffset == 0)
            {
                m_isInertiaBack = true;
            }
        }
    }

    function forceCorrectPosition()
    {
        m_inertiaOffset = 0;
        var totelBackLen = _getInertialBackLen();
        if(totelBackLen != 0)
        {
            // _offsetMCPos(totelBackLen, -1, -1);
            // trace("totelBackLen: " + totelBackLen);
            _setItemOffPosY(totelBackLen);
            m_isInertiaBack     = false;
        }

        if(m_totolOffsetSlide)
        {
            _setItemOffPosY(m_totolOffsetSlide);
            m_totolOffsetSlide  = 0;
        }
    }

    function _getInertialBackLen()
    {
    	var itemY = _getItemPosY();
    	var itemHeight = _getItemHeight();

    	var panelTopY = _getPanelPosY();
    	var panelBottomY = _getPanelBottomPosY();

    	var inertiaBackLen = 0;


        if(itemHeight > panelBottomY - panelTopY)
        {
            if(itemY + itemHeight < panelBottomY)
            {
                inertiaBackLen = panelBottomY - (itemY + itemHeight);
            }

            if(itemY > panelTopY)
            {
                inertiaBackLen = panelTopY - itemY;
            }
        }
        else
        {
            inertiaBackLen = panelTopY - itemY;
        }


        return inertiaBackLen;
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
                    offsetScale = 1 - (absLen + Math.abs(offsetValue/k_offsetQueueLength))/(m_maxBackValue)
                    offsetScale = Math.max(0, offsetScale)
                }
                else
                {
                    offsetScale = 1 - (absLen - Math.abs(offsetValue/k_offsetQueueLength))/(m_maxBackValue)
                    offsetScale = Math.min(1.0, offsetScale)
                }
                offsetValue *= offsetScale
            }
    //        trace("fuck offsetScale" + offsetScale)
        }
    //    trace("fuck offsetValue " + offsetValue)
        return offsetValue
    }

	function OnUpdate()
	{
        if(__DEBUG__)
        {
            // trace("slider update " + m_isPressed);
            // trace("" + _getPanelPosY() + "  " + _getPanelBottomPosY());
            // trace(_getItemHeight());
            // trace(GetPercent());
        }

        if(m_isPressed && m_enableDrag)
        {
            var currentMouseY = _getMousePosY();
            var offset = currentMouseY - m_lastMouseY;

            if(__DEBUG__)
            {
                trace("offset: " + offset);
            }

            offset = _getRealoffsetValue(offset);

            if(__DEBUG__)
            {
                trace("2 offset: " + offset);
            }

            m_offsetQueue.push(offset);
            if(m_offsetQueue.length > 3)
            {
                m_offsetQueue.shift();
            }
            if(Math.abs(offset) >= 1)
            {
                _setItemOffPosY(offset);
                m_lastMouseY = currentMouseY;
            }
        }
        else if(m_inertiaOffset != 0)
        {
        	if(__DEBUG__)
        	{
        		trace("m_inertiaOffset: " + m_inertiaOffset);
        	}

            if(Math.abs(m_inertiaOffset) < INERTIA_MIN_OFFSET)
            {
                m_inertiaOffset = 0;
                m_isInertiaBack = true;
            }
            else
            {
                var offset = _getRealoffsetValue(m_inertiaOffset);
                var attenuation = INERTIA_ATTENUATION;
                if(offset < m_inertiaOffset)
                {
                    offset *= 0.5;
                    attenuation *= 0.6;
                }
                _setItemOffPosY(offset);
                m_inertiaOffset *= attenuation;
            }
        }
        else if(m_totolOffsetSlide != 0)
        {
    //        trace("fuck offsetSlide " + m_totolOffsetSlide)
            var offset = m_totolOffsetSlide;
            if(Math.abs(m_totolOffsetSlide) < OFFSET_MIN_THRESHOLD)
            {
                _setItemOffPosY(offset);
                m_totolOffsetSlide = 0;
            }
            else
            {
                offset = Math.ceil(m_totolOffsetSlide * 0.2);
                var absoffset = Math.abs(offset);
                if(absoffset < OFFSET_MIN_THRESHOLD)
                {
                    offset = (offset > 0) ? OFFSET_MIN_THRESHOLD : -OFFSET_MIN_THRESHOLD;
                }
                _setItemOffPosY(offset);
                m_totolOffsetSlide -= offset;
            }
        }
        else if(m_isInertiaBack)
        {
            var totalBackLen = _getInertialBackLen();
            var offset = 0;

            if(Math.abs(totalBackLen) < OFFSET_MIN_THRESHOLD)
            {
                offset = totalBackLen;
                m_isInertiaBack = false;
            }
            else
            {
                offset = totalBackLen * 0.2;
                if(totalBackLen > 0)
                {
                    offset = Math.max(offset, OFFSET_MIN_THRESHOLD);
                }
                else
                {
                    offset = Math.min(offset, -OFFSET_MIN_THRESHOLD);
                }
            }
            _setItemOffPosY(offset);
        }
	}

	function SimpleSlideOnLoad()
	{
		m_this = this;
		m_hitZone_panel = m_this.hitZone_panel;
        m_slideItem = m_this.slideItem;
		m_slideItem2 = m_this.slideItem2;
		m_maxBackValue = _getPanelHeight() / 1.5;


		m_hitZone_panel.onPress = function()
		{
			_parent.onPressedInListbox();
		}

		m_hitZone_panel.onRelease =
        m_hitZone_panel.onReleaseOutside = function()
		{
			_parent.onReleasedInListbox();
		}
	}



}




