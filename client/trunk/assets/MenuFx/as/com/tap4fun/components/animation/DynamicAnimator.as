/*								ComponentName
**
** instanciation howto
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
** 
*/
import mx.transitions.easing.*;
import com.tap4fun.animation.Tweening;

//The image must measure 18 pixels square, and you must save it in PNG format. It must be bit with alpha transparency, and the upper left pixel must be transparent to support masking.
//[IconFile("icons/Menu.png")]
//Write the next two lines of code: [Event("onLoadComplete")] and [Event("onProgress")]. The [Event("YourEventName")] represents the events that the component will trigger during the loading process (onProgress) and when the loading process is completed (onLoadComplete).
[Event("onLoadComplete")]
[Event("onProgress")]

class com.tap4fun.components.animation.DynamicAnimator extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "DynamicAnimator";
	static var symbolOwner:Object = DynamicAnimator;
	var className:String = "DynamicAnimator";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	[Inspectable(defaultValue="")]
	public var animationTarget:String;
	[Inspectable(defaultValue="None", enumeration="Back,Bounce,Elastic,Regular,Strong,None")]
	public var animationType:String;
	[Inspectable(defaultValue="easeOut", enumeration="easeIn,easeOut,easeInOut")]
	public var easingType:String;
	[Inspectable(defaultValue=10)]
	public var frames:Number;
	[Inspectable]
	public var positionReferences:Array;
	
	private var _animationTarget:MovieClip;
	private var _positionReferences:Array;
	private var _animationFunc:Function;
    
	private var tweening:Tweening;
    private var myTween:Object;
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DynamicAnimator()
	{
		if(this.animationTarget!="") this._animationTarget = this._parent[animationTarget];
		
		this._positionReferences = new Array();
		for(var $i:Number = 0; $i<this.positionReferences.length; $i++)
		{
			var $ref_name:String = this.positionReferences[$i];
			this._positionReferences.push(this._parent[$ref_name]);
		}
		this.tweening = new Tweening();
		
		this.setAnimationFunc();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setAnimationFunc():Void
	{	
		switch(this.animationType)
		{
			case "Back":
				switch(this.easingType)
				{
					case "easeIn":
					this._animationFunc = Back.easeIn;
					break;
					case "easeOut":
					this._animationFunc = Back.easeOut;
					break;
					case "easeInOut":
					this._animationFunc = Back.easeInOut;
					default:
					this._animationFunc = Back.easeOut;
					break;
				}
			break;
			
			case "Bounce":
				switch(this.easingType)
				{
					case "easeIn":
					this._animationFunc = Bounce.easeIn;
					break;
					case "easeOut":
					this._animationFunc = Bounce.easeOut;
					break;
					case "easeInOut":
					this._animationFunc = Bounce.easeInOut;
					default:
					this._animationFunc = Bounce.easeOut;
					break;
				}
			break;
			
			case "Elastic":
				switch(this.easingType)
				{
					case "easeIn":
					this._animationFunc = Elastic.easeIn;
					break;
					case "easeOut":
					this._animationFunc = Elastic.easeOut;
					break;
					case "easeInOut":
					this._animationFunc = Elastic.easeInOut;
					default:
					this._animationFunc = Elastic.easeOut;
					break;
				}
			break;
			
			case "Regular":
				switch(this.easingType)
				{
					case "easeIn":
					this._animationFunc = Regular.easeIn;
					break;
					case "easeOut":
					this._animationFunc = Regular.easeOut;
					break;
					case "easeInOut":
					this._animationFunc = Regular.easeInOut;
					default:
					this._animationFunc = Regular.easeOut;
					break;
				}
			break;
			
			case "Strong":
				switch(this.easingType)
				{
					case "easeIn":
					this._animationFunc = Strong.easeIn;
					break;
					case "easeOut":
					this._animationFunc = Strong.easeOut;
					break;
					case "easeInOut":
					this._animationFunc = Strong.easeInOut;
					default:
					this._animationFunc = Strong.easeOut;
					break;
				}
			break;
			
			case "None":
			default:
				switch(this.easingType)
				{
					case "easeIn":
					this._animationFunc = None.easeIn;
					break;
					case "easeOut":
					this._animationFunc = None.easeOut;
					break;
					case "easeInOut":
					this._animationFunc = None.easeInOut;
					default:
					this._animationFunc = None.easeNone;
					break;
				}
			break;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function playAnimation($ref1:Object, $ref2:Object, $target:MovieClip, $frames:Number, $animationFunc:Function):Void
	{
		if($target == undefined) $target = this._animationTarget;
		if($frames == undefined) $frames = this.frames;
		if($animationFunc == undefined) $animationFunc = this._animationFunc;
		
		this.tweening.addTweened($target, $animationFunc, {_x:$ref1._x, _y:$ref1._y, _xscale:$ref1._xscale, _yscale:$ref1._yscale, _rotation:$ref1._rotation, _alpha:$ref1._alpha},$ref2, $frames)
		$target.dAnim = this;
		$target.onDestination = function():Void
		{
			if(this.dAnim.onAnimationEnd) this.dAnim.onAnimationEnd();
		};
		this.tweening.startAnimating();
	}
	public function animateToReference($ref_num:Number, $target:MovieClip, $frames:Number, $animationFunc:Function):Void
	{
		if($target == undefined) $target = this._animationTarget;
		if($frames == undefined) $frames = this.frames;
		if($animationFunc == undefined) $animationFunc = this._animationFunc;
		var $ref2 = this._positionReferences[$ref_num];
		
		this.playAnimation($target, $ref2, $target, $frames, $animationFunc);
	}
	public function animateTo($ref2:Object, $target:MovieClip, $frames:Number, $animationFunc:Function):Void
	{
		if($target == undefined) $target = this._animationTarget;
		if($frames == undefined) $frames = this.frames;
		if($animationFunc == undefined) $animationFunc = this._animationFunc;
		
		this.playAnimation($target, $ref2, $target, $frames, $animationFunc);
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setAnimationType($type:String):Void
	{
		
	}
	public function setEasingType($type:String):Void
	{
		
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
}