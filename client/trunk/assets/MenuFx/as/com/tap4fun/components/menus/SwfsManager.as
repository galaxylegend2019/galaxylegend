/*								ComponentName
**
** drag this component on the container fla's stage
* 
*********Properties****************************Description******
* swfs:Array					//Array containing objects with reference and loadPaths of all loaded swfs
* 
*********Methods****************************Description*******
* loadSwf($path:String, $container:MovieClip, $id:String):MovieClip
* unloadSwf($ref:MovieClip):Void
* getSwfById($id:String):MovieClip
* getSwfByLoadPath($path:String):MovieClip
* 
*********Events*****************************Description*******
* $ref.onUnloadSwf(swfsManagerRef)						//Callback on swf's container before being removed

*********TODO*************************************************
** 
*/
//The image must measure 18 pixels square, and you must save it in PNG format. It must be bit with alpha transparency, and the upper left pixel must be transparent to support masking.
[IconFile("icons/MenusStack.png")]

//Write the next two lines of code: [Event("onLoadComplete")] and [Event("onProgress")]. The [Event("YourEventName")] represents the events that the component will trigger during the loading process (onProgress) and when the loading process is completed (onLoadComplete).
[Event("onLoadComplete")]
[Event("onProgress")]

import com.tap4fun.StaticFunctions;

dynamic class com.tap4fun.components.menus.SwfsManager extends com.tap4fun.components.ComponentBase
{
	// Components must declare these to be proper
	// components in the components framework
	static var symbolName:String = "SwfsManager";
	static var symbolOwner:Object = SwfsManager;
	var className:String = "SwfsManager";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//Inspectable
	/*[Inspectable(defaultValue="")]
	public var variable:String;*/
	
	public var swfs:Array;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function SwfsManager()
	{
		this.swfs = new Array();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function loadSwf($path:String, $container:MovieClip, $id:String):MovieClip
	{
		if (_global.MenusStack.debug) trace("Loading Swf " + $path + " in " + $container._name);
		
		if (this.getSwfById($id) != null)
		{
			if (_global.MenusStack.debug) trace("Swf with id " + $id + " already loaded, exiting loadSwf ");
			return;
		}
		
		var $cur_container:MovieClip = $container.createEmptyMovieClip($id, $container.getNextHighestDepth());
		$cur_container.loadMovie($path);
		
		this.swfs.push( { ref:$cur_container, swfPath:$path } );
		
		return $cur_container;
	}
	
	public function unloadSwf($container:MovieClip):Void
	{
		if (_global.MenusStack.debug) trace("Unloading swf " + $container);
		
		for (var $i:Number = 0; $i < this.swfs.length; $i++)
		{
			if (this.swfs[$i].ref._name == $container._name)
			{
				this.swfs = StaticFunctions.removeElementAtIndex(this.swfs, $i);
				break;
			}
		}
		if ($container.onUnloadSwf) $container.onUnloadSwf(this);
		$container.removeMovieClip();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getSwfById($id:String):MovieClip
	{
		for (var $i:Number = 0; $i < this.swfs.length; $i++)
		{
			if (this.swfs[$i].ref._name == $id) return this.swfs[$i].ref;
		}
		return null;
	}
	public function getSwfByLoadPath($path:String):MovieClip
	{
		for (var $i:Number = 0; $i < this.swfs.length; $i++)
		{
			if (this.swfs[$i].swfPath == $path) return this.swfs[$i].ref;
		}
		return null;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
}