/**
 * ...
 * @author zhuyubin
 */
class com.tap4fun.utils.FingerPoint
{
	
	public var touchID:Number;
	public var x:Number;
	public var y:Number;
	public var state:Number;
	
	public function FingerPoint() 
	{
		this.touchID = -1;
		this.x = 0;
		this.y = 0;
		this.state = 0;
	}
	
	public function toString():String
	{
		return "(x =" + x + ",y=" + y + ",state = " + state + ",touchID=" + touchID + ")";
	}
	
}