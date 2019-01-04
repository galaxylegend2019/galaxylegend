/**
 * Class name: CTimeCountDown
 * ...
 * @author ZYB
 * ...
 * **********Class********************Description**********
 * this class will record and format the timer count down.
 */

import com.tap4fun.time.CTimer;

class com.tap4fun.time.CTimeCountDown
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Public enumeration										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public static var se_showSecond:Number = 0;
	public static var se_showMinute:Number = se_showSecond + 1;
	public static var se_showHour:Number = se_showMinute + 1;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private members 										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var m_cTimer:CTimer;
	private var m_nTotalTime:Number;		//total time in milliseconds.
	private var m_eShowStyle:Number;
	private var m_bCompressFormat:Boolean;
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function CTimeCountDown() 
	{
		//trace("CTimeCountDown Constructor");
		m_cTimer = new CTimer();
		m_nTotalTime = 0;
		m_eShowStyle = se_showHour;
		m_bCompressFormat = false;
	}
	
	public function SetUp($totalTime:Number, $showStyle:Number, $compress:Boolean):Void 
	{
		m_nTotalTime = $totalTime;
		m_eShowStyle = $showStyle;
		m_bCompressFormat = $compress;
		m_cTimer.Restart();
	}
	
	public function IsTimeOut():Boolean 
	{
		var elapsed:Number = m_cTimer.GetElapsedTime();
		return elapsed >= m_nTotalTime;
	}
	
	public function GetTimeLeft():Number 
	{
		var elapsed:Number = m_cTimer.GetElapsedTime();
		var timeLeft:Number = Math.max(0, m_nTotalTime - elapsed);
		return timeLeft;
	}
	
	public function GetCountDownStr():String 
	{
		var timeLeft:Number = this.GetTimeLeft();
		var timeSeconds:Number = Math.floor(timeLeft / 1000);

		var timeStr:String = "";
		
		//days
		var timeNum:Number = Math.floor(timeSeconds / 86400);
		if (timeNum > 0)
		{
			timeStr += (timeNum.toString() + "d ");
		}
		
		//hours
		timeSeconds = Math.floor(timeSeconds % 86400);
		timeNum = Math.floor(timeSeconds / 3600);
		if ((m_eShowStyle >= se_showHour && !m_bCompressFormat) || timeStr.length > 1 || timeNum > 0)
		{
			timeStr += ((timeNum <= 0 ? "00" : ((timeNum < 10 ? "0" : "") + timeNum.toString())) + ":");
		}
		
		//minutes
		timeSeconds = Math.floor(timeSeconds % 3600);
		timeNum = Math.floor(timeSeconds / 60);
		if ((m_eShowStyle >= se_showMinute && !m_bCompressFormat) || timeStr.length > 1 || timeNum > 0)
		{
			timeStr += ((timeNum <= 0 ? "00" : ((timeNum < 10 ? "0" : "") + timeNum.toString())) + ":");
		}

		//seconds
		timeNum = Math.floor(timeSeconds % 60);
		timeStr += (timeNum <= 0 ? "00" : ((timeNum < 10 ? "0" : "") + timeNum.toString()));
		
		return timeStr;
	}
	
}