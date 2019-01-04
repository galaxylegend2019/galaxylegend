import common.CBox
/**
 * ...
 * @author zhuyubin
 */
import com.tap4fun.StaticFunctions;
class common.CObjList extends MovieClip
{
	private var m_stopInBorder:Boolean = false;
	private var m_mcMask:MovieClip = null;
	private var m_mcList:MovieClip = null;
	private var m_touchZone:MovieClip = null;
	private var m_maskName:String = "";
	private var m_listName:String = "";
	private var m_touchZoneName:String = "";
	//private var m_boxTmp:MovieClip = null;
	
	private var m_nMaxLength:Number = 0;
	private var m_nLastMouseY:Number = 0;
	
	private var m_nStepMoveLen:Number = 0;
	private var m_isAutoMove:Boolean = false;
	private var m_nSpeedOffPercent:Number = 85;
	private var m_nRollInertiaStopSpeed:Number = 5;
	
	private var m_bMovedAfterPress:Boolean = false;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function CObjList() 
	{
		// _global.IsWin32 = (getVersion().slice(0, 3) == "WIN");
		_global.IsWin32 = getVersion() == "GameSwfWIN";
		this._initMcList();
		this._applyEventHandler();
		
		this.m_nMaxLength = Math.floor(this.m_mcList._height - this.m_mcMask._height);
		 m_totalItemNum = 0;
		m_colNum = 0;
		m_curUsablePosY = 0;
		m_itemList = new Array();
		m_boxList = new Array();
		m_curBoxUsablePosY = 0;
		m_dstBox = 0;
		m_dstItem = 0;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public functions										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function UpdateMcList(mask:String,obl:String,tzone:String):Void
	{
		this.m_maskName = mask;
		this.m_listName = obl;
		this.m_touchZoneName = tzone;
		
		this.m_mcMask = this[mask];
		this.m_mcList = this[obl];
		this.m_touchZone = this[tzone];	
		this._applyEventHandler();
		this.m_nMaxLength = Math.floor(this.m_mcList._height - this.m_mcMask._height);
	}
	
	public function UpdateMove():Void 
	{
		var moveMC:MovieClip = this.m_mcList;
		if (!this.m_isAutoMove)
		{		
			m_nStepMoveLen = this._ymouse - this.m_nLastMouseY;
			this.m_nLastMouseY = this._ymouse;
			this.m_nStepMoveLen *= this._getMoveFactor();
		}
		else
		{			
			this.m_nStepMoveLen *= this._getMoveFactor();
			m_nStepMoveLen = m_nStepMoveLen * m_nSpeedOffPercent / 100;
			
			if (Math.abs(m_nStepMoveLen) < m_nRollInertiaStopSpeed)
			{
				this.m_isAutoMove = false;
				this.onEnterFrame = null;
				this.onEnterFrame = RollBack;
				return;
			}
		}
		if (Math.abs(this.m_nStepMoveLen) > 3)
		{
			this.m_bMovedAfterPress = true;
		}

		//trace(this.m_mcMask._y + " " + this.m_mcMask._height);


		moveMC._y += m_nStepMoveLen;


		if(m_stopInBorder)
		{
			if(moveMC._y > 0)
			{
				moveMC._y = 0;
			}
			if(moveMC._y + moveMC._height < this.m_mcMask._y + this.m_mcMask._height)
			{
				moveMC._y = this.m_mcMask._y + this.m_mcMask._height - moveMC._height;
			}
		}
	}

	public function SetStopInBorder(isStopInBorder)
	{
		m_stopInBorder = isStopInBorder;
	}

	public function RollBack():Void 
	{	
		var moveMC:MovieClip = this.m_mcList;
		var nMaxLength = this.m_nMaxLength;
		if (nMaxLength  < 0)
			nMaxLength = 0; 
		if (moveMC._y <= 0 && moveMC._y >= -nMaxLength)
		{
			this.onEnterFrame = null;
			return;
		}
		
		var dis:Number = moveMC._y;
		var flag:Number = -1;
		if (moveMC._y <= -nMaxLength)
		{
			flag = 1;
			dis = Math.abs(moveMC._y) - nMaxLength;
		}
		m_nStepMoveLen = 5;
	
		if(dis <= 3)
		{
			m_nStepMoveLen = dis;
		}
		else if(dis <= 6)
		{
			m_nStepMoveLen = 3;
		}
		else
		{
			m_nStepMoveLen = dis / 8;
		}
		moveMC._y += (m_nStepMoveLen * flag);
	}
	
	public function get IsMovedAfterPress():Boolean 
	{
		return this.m_bMovedAfterPress;
	}
	
	private var m_totalItemNum:Number;
	private var m_colNum:Number;
	//private var m_lineNum:Number;
	private var m_curUsablePosY:Number;
	private var m_itemList:Array;
	private var m_curBox:CBox;
	private var m_boxList:Array;
	private var m_curBoxUsablePosY:Number;
	private var m_dstBox:Number;
	private var m_dstItem:Number;
	
	public function AdjustScale():Void
	{
		for (var i in m_itemList)
		{
			m_itemList[i]._xscale = 1;
			m_itemList[i]._yscale = 1;
		}
	}
	public function AddItemMc(mcId:String, mcName:String, type:Number):Object
	{
		if (type == 0)
		{
			CreateNewBox();
		}

		// trace("AddItemMc: [" + mcId + "] [" + mcName + "]")
		m_mcList.attachMovie(mcId, mcName, m_mcList.getNextHighestDepth());
	
		var item = m_mcList[mcName];
		// trace(m_mcList)
		if (item != undefined)
		{
			m_curBox.AddItem(item, type);
		}
		return item;
	}

	public function GetItem(mcName)
	{
		return m_mcList[mcName]
	}

	public function CreateNewBox():Void
	{
		if (m_boxList.length > 0)
		{
			m_curBox.AppendPadding(m_dstBox);
			m_curUsablePosY = m_curBox.usableY;
			
		}
		var box:CBox = new CBox(this, m_boxList.length, m_curUsablePosY, m_dstItem);
		m_boxList.push(box);
		m_curBox = box;
		//return box;
	}
	public function AdjustPos(dst:Number, startIdx:Number):Void
	{
		var idx:Number = 0;
		if (startIdx >= 0)
		{
			idx = startIdx;
		}
		for (; idx < m_boxList.length; ++idx )
		{
			m_boxList[idx].AdjustPos(dst);
		}
		this.m_nMaxLength = Math.floor(this.m_mcList._height - this.m_mcMask._height);
		AdjustBorder();
	}
	
	public function AdjustBorder():Void
	{
		if (m_mcList._height <= m_mcMask._height)
		{
			m_mcList._y = 0;
		}
		else if (m_mcList._y + m_mcList._height < m_mcMask._y + m_mcMask._height)
		{
			m_mcList._y = m_mcMask._y + m_mcMask._height - m_mcMask._height;
		}
	}
	
	public function SetConfig(dstBox:Number, dstItem:Number):Void
	{
		m_dstBox = (dstBox == null) ? 0: dstBox ;
		m_dstItem = (dstItem == null) ? 0 :dstItem;
	}
	public function Clear():Void
	{
		m_curUsablePosY = 0;
		for (var i in m_boxList)
		{
			m_boxList[i].Clear();
			m_boxList.splice(i, 1);
		}
		AdjustBorder();
	}
	public function ResetYPos():Void
	{
		var moveMC:MovieClip = this.m_mcList;
		moveMC._y = 0;
	}
	public function CloseAllBox():Void
	{
		for (var i = 0; i < m_boxList.length; ++i )
		{
			m_boxList[i].SwitchItemShow();
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private functions										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function _initMcList():Void 
	{
		this.m_mcMask = this["MaskCover"];
		this.m_mcList = this["ObjectList"];
		this.m_touchZone = this["TouchZone"];
		//this.m_boxTmp = this["boxTmp"];
	}
	
	private function _applyEventHandler():Void
	{
		this.m_touchZone.onPress = function ():Void 
		{
			this._parent.m_isAutoMove = false;
			this._parent.m_bMovedAfterPress = false;
			this._parent.m_nLastMouseY = this._parent._ymouse;
			this._parent.onEnterFrame = this._parent.UpdateMove;
		}
		
		this.m_touchZone.onRelease = this.m_touchZone.onReleaseOutside/* = this.m_touchZone.onDragOut*/ = function ():Void 
		{
			this._parent.m_isAutoMove = true;
			//this._parent.onEnterFrame = this._parent.RollBack;
		}
	}
	
	private function _getMoveFactor():Number 
	{
		var moveMC:MovieClip = this.m_mcList;
		var factor:Number = 1;
		if (moveMC._y > 0 && m_nStepMoveLen > 0)
		{
			factor = (this.m_mcMask._height - moveMC._y) / this.m_mcMask._height; 
		}
		else if (moveMC._y < -this.m_nMaxLength && m_nStepMoveLen < 0)
		{
			factor = (this.m_mcMask._height - (Math.abs(moveMC._y) - this.m_nMaxLength)) / this.m_mcMask._height;
		}
		return factor;
	}
}