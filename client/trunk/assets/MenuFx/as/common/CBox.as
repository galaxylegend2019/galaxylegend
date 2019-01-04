/**
 * ...
 * @author Long Conghai
 */
class common.CBox
{
	private var m_itemList:Array;
	private var m_height:Number;
	private var m_masterItem:Object;//MovieClip;
	private var m_posY:Number;
	private var m_curUsableY:Number;
	private var m_isHide:Boolean;
	private var m_parent:Object;
	private var m_idx:Number;
	private var m_startY:Number;
	private static var s_W:Number;
	private var m_dstItem:Number;
	
	public function ApplyMasterItemEvent(){}
	
	public function CBox(parent:Object, idx:Number, posY:Number, dstItem:Number) 
	{
		m_itemList = new Array();
		m_height = 0;
		m_curUsableY = m_posY = posY;
		m_parent = parent;
		m_idx = idx;
		m_isHide = false;
		s_W = m_parent._width;
		m_dstItem = (dstItem == null) ? 0: dstItem;
	}
	public function get height():Number
	{
		return m_height;
	}
	public function get usableY():Number
	{
		if (m_itemList.length > 0 && m_itemList[m_itemList.length - 1]._x + m_itemList[m_itemList.length -1]._width <= s_W / 2)
		{
			return m_curUsableY + m_itemList[m_itemList.length - 1]._height;
		}
		return m_curUsableY;
	}
	public function AddItem(item:Object, type:Number):Void
	{
		if (type == 0)
		{
			m_masterItem = item;
			m_masterItem._box = this;
			//item._x = 0;
			m_height += (item._height + m_dstItem);
			item._y = m_curUsableY;
			m_curUsableY += (item._height + m_dstItem);
			return;
		}
		var lastItem:MovieClip = m_itemList[m_itemList.length - 1];
		if (item._width > s_W / 2 || m_itemList.length <= 0 || lastItem._x + lastItem._width > s_W / 2)
		{//need whole line
			item._x = 0;
		}
		else
		{
			item._x = lastItem._x + lastItem._width;
		}
		item._y = m_curUsableY;
		if (item._x + item._width <= s_W / 2)
		{
			m_height += (item._height + m_dstItem);
		}
		else
		{
			m_curUsableY += (item._height + m_dstItem);
			if (item._width > s_W / 2)
			{
				m_height += (item._height + m_dstItem);
			}
		}
		m_itemList.push(item);
	}
	
	public function AppendPadding(h:Number):Void
	{
		m_curUsableY  = m_curUsableY - m_dstItem + h;
		m_height = m_height - m_dstItem + h;
	}
	
	public function SwitchItemShow():Void
	{
		if (m_itemList.length <= 0)
		{
			return;
		}
		//trace("m_height = " + m_height + ", mh = " + m_masterItem._height);
		m_isHide = !m_isHide;
		var dst:Number = 0;
		if (m_isHide)
		{
			dst = m_height - m_masterItem._height;
		}
		else
		{
			dst = m_masterItem._height - m_height;
		}
		for (var i in m_itemList)
		{
			m_itemList[i]._visible = !m_isHide;
		}
		m_curUsableY -= dst;
		this.m_parent.AdjustPos(dst, m_idx + 1);
	}
	
	public function AdjustPos(dst:Number):Void
	{
		m_masterItem._y -= dst;
		m_curUsableY -= dst;
		m_posY -= dst;
		for (var i in m_itemList)
		{
			m_itemList[i]._y -= dst;
		}
	}
	
	public function Clear():Void
	{
		for (var i in m_itemList)
		{
			var item = m_itemList[i];
			m_itemList.splice(i, 1);
			item.removeMovieClip();
		}
		m_masterItem.removeMovieClip();
	}
	public function Remove():Void
	{
		Clear();
		this.m_parent.AdjustPos(m_height , m_idx+1);
	}

	public function IsHide():Boolean
	{
		return m_isHide;
	}
}