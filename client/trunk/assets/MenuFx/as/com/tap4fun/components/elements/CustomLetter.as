class com.tap4fun.components.elements.CustomLetter extends MovieClip
{
	var speed:Number;
	function CustomLetter()
	{
		
	}
	
	public function onEnterFrame():Void
	{
		//this._y -= random(10)/100;
		this._rotation = random(8)-4;
		this._alpha = 100 - (random(30));
	}
}