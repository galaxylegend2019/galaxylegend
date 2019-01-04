import com.tap4fun.utils.MovieClipsUtils;
import com.tap4fun.utils.Utils;


class common.CDragBar extends MovieClip
{
	var m_isHorizontal			: Boolean			= false;
	var m_percent				: Number			= 0;
	var m_startCoord			: Number			= 0;
	//var m_startAbsCoord			: Number			= 0;
	var m_length				: Number			= 0;
	var m_dragDerta				: Number			= 0;
	var m_isDragging			: Boolean			= false;
	var m_barInstance			: MovieClip			= null;
	var m_this					: MovieClip			= null;

	var __DEBUG__				: Boolean			= true;

	function initDragBar(isHorizontal, percent)
	{
		m_this = this;
		m_barInstance = this["Bar"];

		m_isHorizontal = isHorizontal;



		if(m_isHorizontal)
		{
			//m_startAbsCoord = Utils.getGlobalPosition(this["CoordinateBar"]).x;
			m_startCoord = this["CoordinateBar"]._x;
			m_length = this["CoordinateBar"]._width;
		}
		else
		{
			//m_startAbsCoord = Utils.getGlobalPosition(this["CoordinateBar"]).y;
			m_startCoord = this["CoordinateBar"]._y;
			m_length = this["CoordinateBar"]._height;
		}
		
		SetPercent(percent);

		if(__DEBUG__)
		{
			trace(m_startCoord);
		}

		// child function
		m_barInstance.onPress = function()
		{
			if(__DEBUG__)
			{
				trace("m_barInstance.onPress")
			}
			
			this._parent.m_isDragging = true;
			if(this._parent.m_isHorizontal)
			{
				this._parent.m_dragDerta = this._x - _root._xmouse;
			}
			else
			{
				this._parent.m_dragDerta = this._y - _root._ymouse;
			}
		}

		m_barInstance.onRelease = function()
		{
			if(__DEBUG__)
			{
				trace("m_barInstance.onRelease")
			}
			
			this._parent.m_isDragging = false;
			if(this._parent.outOnRelease)
			{
				this._parent.outOnRelease();
			}
		}

		m_barInstance.onReleaseOutside = function()
		{
			if(__DEBUG__)
			{
				trace("m_barInstance.onReleaseOutside")
			}
			
			this._parent.m_isDragging = false;
			if(this._parent.outOnRelease)
			{
				this._parent.outOnRelease();
			}
		}
	}

	function onEnterFrame()
	{
		if(m_isDragging)
		{
			var newPercent = 0;

			if(m_isHorizontal)
			{
				m_barInstance._x = _root._xmouse + m_dragDerta;

				if(m_barInstance._x < m_startCoord)
				{
					m_barInstance._x = m_startCoord;
				}
				else if(m_barInstance._x > m_startCoord + m_length)
				{
					m_barInstance._x = m_startCoord + m_length;
				}

				newPercent = 100 * (m_barInstance._x - m_startCoord) / m_length;
			}
			else
			{
				m_barInstance._y = _root._ymouse + m_dragDerta;

				if(m_barInstance._y < m_startCoord)
				{
					m_barInstance._y = m_startCoord;
				}
				else if(m_barInstance._y > m_startCoord + m_length)
				{
					m_barInstance._y = m_startCoord + m_length;
				}

				newPercent = 100 * (m_barInstance._y - m_startCoord) / m_length;
			}
			newPercent = Math.round(newPercent);
			
			if(newPercent != m_percent)
			{
				m_percent = newPercent;
				if(m_this.onPrecentChange)
				{
					m_this.onPrecentChange();
				}
			}
		}
	}

	function SetPercent(percent)
	{
		m_percent = percent;
		if(m_isHorizontal)
		{
			m_barInstance._x = m_startCoord + m_length * m_percent / 100;
		}
		else
		{
			m_barInstance._y = m_startCoord + m_length * m_percent / 100;
		}
	}

	function GetPercent()
	{
		return m_percent;
	}





}