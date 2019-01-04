/**
 * ...
 * @author ZYB
 */
class com.tap4fun.utils.CLinearChangeNum
{
	private var m_curNum:Number;
	private var m_targetNum:Number;
	private var m_stepPerSec:Number;
	private var m_isIncrease:Boolean;
	private var m_lastTimer:Number;
	
	public function CLinearChangeNum(curNum:Number, targetNum:Number, stepPerSec:Number) 
	{
		SetParameter(curNum, targetNum, stepPerSec);
	}
	
	public function SetParameter(curNum:Number, targetNum:Number, stepPerSec:Number):Void 
	{
		this.m_curNum = curNum;
		this.m_targetNum = targetNum;
		this.m_stepPerSec = stepPerSec;
		this.m_isIncrease = (targetNum > curNum);
		this.m_lastTimer = getTimer();
	}
	
	public function UpdateNumberChange():Boolean
	{
		var curTimer:Number = getTimer();
		var numberChange:Number = Math.ceil(m_stepPerSec * (curTimer - this.m_lastTimer) / 1000);
		this.m_lastTimer = curTimer;
		if (this.m_isIncrease)
		{
			this.m_curNum = Math.min(this.m_curNum + numberChange, this.m_targetNum);
		}
		else
		{
			this.m_curNum = Math.max(this.m_curNum - numberChange, this.m_targetNum);
		}
		
		return HasFinished();
	}
	
	public function HasFinished():Boolean
	{
		return (this.m_curNum == this.m_targetNum);
	}
	
	public function get CurNum():Number
	{
		return this.m_curNum;
	}
	
	public function get TargetNum():Number
	{
		return this.m_targetNum;
	}
	
	public function get StepPerSec():Number
	{
		return this.m_stepPerSec;
	}
}