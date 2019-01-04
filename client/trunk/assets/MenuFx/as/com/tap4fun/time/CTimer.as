/**
 * Class name: CTimer
 * ...
 * @author ZYB
 * ...
 * **********Class********************Description**********
 * this class will record the number of milliseconds
 * that have elapsed since start the timer.
*/
class com.tap4fun.time.CTimer
{
	private var m_startTime:Number;
	
	public function CTimer() 
	{
		Restart();
	}
	
	public function Restart():Void 
	{
		m_startTime = getTimer();
	}
	
	//Get the elapsed time in milliseconds.
	public function GetElapsedTime():Number 
	{
		var curTime:Number = getTimer();
		return curTime - m_startTime;
	}
	
}