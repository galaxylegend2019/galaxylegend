/*								Layout
**
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
**
*/

import com.tap4fun.animation.Tweening;
import mx.transitions.easing.*;

[IconFile("icons/AlertMenu.png")]

class com.tap4fun.components.elements.Layout extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "Layout";
	static var symbolOwner:Object = Layout;
	var className:String = "Layout";
	
	//Constants
	private static var _enumCnt:Number = 0;
	public static var LEFT:Number = _enumCnt++;
	public static var RIGHT:Number = _enumCnt++;
	public static var TOP:Number = _enumCnt++;
	public static var BOTTOM:Number = _enumCnt++;
	public static var HORIZONTAL_CENTER:Number = _enumCnt++;
	public static var VERTICAL_CENTER:Number = _enumCnt++;
	public static var HORIZONTAL:Number = _enumCnt++;
	public static var VERTICAL:Number = _enumCnt++;
	//Anims
	public static var ANIM_FROM_LEFT:Number = _enumCnt++;
	public static var ANIM_FROM_RIGHT:Number = _enumCnt++;
	public static var ANIM_FROM_TOP:Number = _enumCnt++;
	public static var ANIM_FROM_BOTTOM:Number = _enumCnt++;
	public static var ANIM_TO_LEFT:Number = _enumCnt++;
	public static var ANIM_TO_RIGHT:Number = _enumCnt++;
	public static var ANIM_TO_TOP:Number = _enumCnt++;
	public static var ANIM_TO_BOTTOM:Number = _enumCnt++;
	public static var ANIM_ALPHA_IN:Number = _enumCnt++;
	public static var ANIM_ALPHA_OUT:Number = _enumCnt++;
	
	private var _tweening:Tweening;
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Properties											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	/*[Inspectable(defaultValue=0)]
	public var value:Number;*/
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function Layout()
	{
		this._tweening = new Tweening();
		this._visible = false;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function align($elements:Array, $pos:Number):Void
	{
		if (this.disabled) return;
		
		var $bounds:Object = this.getBounds(_root);
		var $curElement:MovieClip;
		var $curElementBounds:Object;

		switch($pos)
		{
			case Layout.BOTTOM:
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElementBounds = $curElement.getBounds(_root);
				$curElement.yPos = $bounds.yMax + ($curElement._y - $curElementBounds.yMax);
				$curElement._y = $curElement.yPos;
			}
			break;

			case Layout.TOP:
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElementBounds = $curElement.getBounds(_root);
				$curElement.yPos = $bounds.yMin + ($curElement._y - $curElementBounds.yMin);
				$curElement._y = $curElement.yPos;
			}
			break;

			case Layout.LEFT:
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElementBounds = $curElement.getBounds(_root);
				$curElement.xPos = $bounds.xMin + ($curElement._x - $curElementBounds.xMin);
				$curElement._x = $curElement.xPos;
			}
			break;

			case Layout.RIGHT:
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElementBounds = $curElement.getBounds(_root);
				$curElement.xPos = $bounds.xMax + ($curElement._x - $curElementBounds.xMax);
				$curElement._x = $curElement.xPos;
			}
			break;

			case Layout.VERTICAL_CENTER:
			var $center:Number = $bounds.yMin + (($bounds.yMax - $bounds.yMin) / 2);
			var $offset:Number;
			//_root.clear();
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElementBounds = $curElement.getBounds(_root);
				$offset = $curElementBounds.yMin - $curElement._y;

				//_root.lineStyle(1, 0, 100);
				//_root.moveTo(0, $center);
				//_root.lineTo($curElementBounds.xMin, $curElementBounds.yMin);
				
				$curElement.yPos = $center - $offset - (($curElementBounds.yMax - $curElementBounds.yMin)/2);
				$curElement._y = $curElement.yPos;
			}

			break;

			case Layout.HORIZONTAL_CENTER:
			var $center:Number = $bounds.xMin + (($bounds.xMax - $bounds.xMin) / 2);
			var $offset:Number;
			//_root.clear();
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElementBounds = $curElement.getBounds(_root);
				$offset = $curElementBounds.xMin - $curElement._x;

				//_root.lineStyle(1, 0, 100);
				//_root.moveTo(0, $center);
				//_root.lineTo($curElementBounds.xMin, $curElementBounds.yMin);
				
				$curElement.xPos = $center - $offset - (($curElementBounds.xMax - $curElementBounds.xMin)/2);
				$curElement._x = $curElement.xPos;
			}
			break;
		}
	}
	
	public function spaceEvenly($elements:Array, $pos:Number):Void
	{
		if (this.disabled) return;
		
		var $bounds:Object = this.getBounds(_root);
		var $curElement:MovieClip;
		var $curElementBounds:Object;
		var $space:Number;
		var $startPos:Number;
		var $previousPos:Number;

		switch($pos)
		{
			case Layout.HORIZONTAL:
			//Calculate space between elements
			$space = $bounds.xMax - $bounds.xMin;
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElementBounds = $elements[$i].getBounds(_root);
				$space -= $curElementBounds.xMax - $curElementBounds.xMin;
			}
			$space /= $elements.length-1;
			
			//Getting start position
			$curElement = $elements[0];
			$curElementBounds = $curElement.getBounds(_root);
			$startPos = $bounds.xMin + ($curElement._x - $curElementBounds.xMin);
			
			//Position elements
			$previousPos = $startPos;
			
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElement._x = $curElement.xPos = $previousPos;
				
				$previousPos = $curElement._x + $curElement._width + $space; 
			}
			break;
			
			
			case Layout.VERTICAL:
			//Calculate space between elements
			$space = $bounds.yMax - $bounds.yMin;
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElementBounds = $elements[$i].getBounds(_root);
				$space -= $curElementBounds.yMax - $curElementBounds.yMin;
			}
			$space /= $elements.length-1;
			
			//Getting start position
			$curElement = $elements[0];
			$curElementBounds = $curElement.getBounds(_root);
			$startPos = $bounds.yMin + ($curElement._y - $curElementBounds.yMin);
			
			//Position elements
			$previousPos = $startPos;
			
			for(var $i:Number = 0; $i<$elements.length; $i++)
			{
				$curElement = $elements[$i];
				$curElement.yPos = $curElement._y = $previousPos;
				
				$previousPos = $curElement._y + $curElement._height + $space; 
			}
			break;
		}
	}
	
	//Animate
	public function animate($elements:Array, $anim:Number, $animFunc:Function, $framesCnt:Number, $animate_in:Boolean):Void
	{
		var $curElement:MovieClip;
		var $beginVal:Number;
		var $targetProp:String;
		var $targetMember:String;
		
		switch($anim)
		{
			case Layout.ANIM_ALPHA_IN:
			case Layout.ANIM_ALPHA_OUT:
			$targetProp = "_alpha";
			$targetMember = "_alpha";
			break;
			
			case Layout.ANIM_FROM_TOP:
			case Layout.ANIM_TO_TOP:
			case Layout.ANIM_FROM_BOTTOM:
			case Layout.ANIM_TO_BOTTOM:
			$targetProp = "_y";
			$targetMember = "yPos";
			break;
			
			case Layout.ANIM_FROM_RIGHT:
			case Layout.ANIM_TO_RIGHT:
			case Layout.ANIM_FROM_LEFT:
			case Layout.ANIM_TO_LEFT:
			$targetProp = "_x";
			$targetMember = "xPos";
			break;
		}
		
		var $outObj:Object = new Object();
		var $inObj:Object = new Object();
		
		for (var $i:Number = 0; $i < $elements.length; $i++)
		{
			$curElement = $elements[$i];
			$outObj = new Object();
			$inObj = new Object();
			
			switch($anim)
			{
				case Layout.ANIM_ALPHA_IN:
				case Layout.ANIM_ALPHA_OUT:
				$outObj[$targetProp] = 0;
				break;
				
				case Layout.ANIM_FROM_TOP:
				case Layout.ANIM_TO_TOP:
				$outObj[$targetProp] = 0 - $curElement._height;
				break;
				
				case Layout.ANIM_FROM_RIGHT:
				case Layout.ANIM_TO_RIGHT:
				$outObj[$targetProp] = Stage.width;
				break;
				
				case Layout.ANIM_FROM_BOTTOM:
				case Layout.ANIM_TO_BOTTOM:
				$outObj[$targetProp] = Stage.height;
				break;
				
				case Layout.ANIM_FROM_LEFT:
				case Layout.ANIM_TO_LEFT:
				$outObj[$targetProp] = 0 - $curElement._width;
				break;
			}
			
			if ($targetProp == "_alpha")
			{
				$inObj._alpha = 100;
			}
			else
			{
				$inObj[$targetProp] = $curElement[$targetMember];
			}
			
			if ($animate_in) this._tweening.addTweened($curElement, $animFunc, $outObj, $inObj, $framesCnt);
			else this._tweening.addTweened($curElement, $animFunc, $inObj, $outObj, $framesCnt);
		}
		this._tweening.startAnimating();
	}
	
	public function animateIn($elements:Array, $anim:Number, $animFunc:Function, $framesCnt:Number):Void
	{
		this.animate($elements, $anim, $animFunc, $framesCnt, true);
	}
	public function animateOut($elements:Array, $anim:Number, $animFunc:Function, $framesCnt:Number):Void
	{
		this.animate($elements, $anim, $animFunc, $framesCnt, false);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
}