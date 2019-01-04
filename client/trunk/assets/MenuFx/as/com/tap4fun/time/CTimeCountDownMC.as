/**
 * Class name: CTimeCountDownMC
 * ...
 * @author ZYB
 * ...
 * **********Class********************Description**********
 */

import com.tap4fun.time.CTimeCountDown;

class com.tap4fun.time.CTimeCountDownMC extends MovieClip
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private members 										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var m_cCountDown:CTimeCountDown;
	private var m_bIsActive:Boolean;
	private var m_callBackFun:Function;
	private var m_calBackParam:String;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function CTimeCountDownMC() 
	{
		this.m_cCountDown = new CTimeCountDown();
		this.m_bIsActive = false;
		this.m_callBackFun = null;
		//this.SetUp(1520 * 1000, CTimeCountDown.se_showMinute, false, " test");
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public Methods											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function SetUp($totalTime:Number, $showStyle:Number, $compress:Boolean, $callBackFun:Function, $callBackParam:String):Void 
	{
		this.m_cCountDown.SetUp($totalTime, $showStyle, $compress);
		this.onEnterFrame = doUpdate;
		this.m_bIsActive = true;
		this.m_callBackFun = $callBackFun;
		this.m_calBackParam = $callBackParam;
	}
	
	public function GetTimeLeft():Number 
	{
		return this.m_cCountDown.GetTimeLeft();
	}
	
	public function ClearTimeCountDown():Void 
	{
		this.m_bIsActive = false;
		this.onEnterFrame = null;
		this.m_callBackFun = null;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Methods											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function doUpdate():Void 
	{
		if (this.m_cCountDown.IsTimeOut())
		{
			this.m_bIsActive = false;
			this.onEnterFrame = null;
			if (this.m_callBackFun)
			{
				this.m_callBackFun(this.m_calBackParam);
			}
		}
		if (this["txtStr"])
		{
			this["txtStr"].text = this.m_cCountDown.GetCountDownStr();
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//									Getter and Setter											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function get IsActive():Boolean
	{
		return this.m_bIsActive;
	}
	
}