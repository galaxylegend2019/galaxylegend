//import


class com.tap4fun.data.DataLink
{
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Members											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private var _data:Array;
	private var _elements:Array;
	private var _dataProviderFunction:Function;
	private var _maxElementsCnt:Number;
	private var _curElementsCnt:Number;
	private var _links:Array;
	
	//if data settings
	public var onData_do_onData_callback:Boolean = false;
	
	//if no data settings
	public var noData_goInvisible:Boolean = true;
	public var noData_do_onNoData_callback:Boolean = false;
	public var noData_useDefaultValues:Boolean = true; //TODO: Allow settings of default noData values
	public var noData_gotoAndStop_noData:Boolean = false;
	public var noData_alpha50:Boolean = false;
	
	//Links Types
	private static var _i:Number = -1;
	
	public static var TYPE_MEMBER:Number = ++_i;
	public static var TYPE_FRAME:Number = ++_i;
	public static var TYPE_TEXT:Number = ++_i;
	public static var TYPE_HTML_TEXT:Number = ++_i;
	
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DataLink($elements:Array, $dataProviderFunction:Function)
	{
		this._elements = $elements;
		this._dataProviderFunction = $dataProviderFunction;
		
		this._maxElementsCnt = this._elements.length;
		this.prepareDataArray();
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function prepareDataArray():Void
	{
		this._data = new Array();
		
		for (var $i:Number = 0; $i < this._maxElementsCnt; ++$i)
		{
			this._data[$i] = new Object();
		}
	}
	private function getCurMcChild($mc:Object, $mcChildId:String):Object
	{
		if ($mcChildId.indexOf(".") < 0) return $mc[$mcChildId];
		
		var $elements:Array = $mcChildId.split(".");
		var $curMc:Object = $mc;
		var $el:String;
		
		for (var $i:Number = 0; $i < $elements.length; ++$i)
		{
			$el = $elements[$i];
			$curMc = $curMc[$el];
		}
		
		return $curMc;
	}
	private function applyDefaultValues($mc:Object):Void
	{
		var $curLink:Object;
		var $curMcChild:Object;
		
		for (var $i:Number = 0; $i < this._links.length; ++$i)
		{
			$curLink = this._links[$i];
			
			if($curLink.type != TYPE_MEMBER) $curMcChild = this.getCurMcChild($mc, $curLink.mc);
			
			switch($curLink.type)
			{
				case TYPE_MEMBER:
				$mc[$curLink.mc] = null;
				break;
				
				case TYPE_FRAME:
				$curMcChild.gotoAndStop("default");
				break;
				
				case TYPE_TEXT:
				$curMcChild.text = "";
				break;
				
				case TYPE_HTML_TEXT:
				$curMcChild.htmlText = "";
				break;
			}
		}
	}
	private function sync($index:Number):Void
	{
		var $curLink:Object;
		var $curMc:Object;
		var $curData:Object;
		var $curMcChild:Object;
		
		$curMc = this._elements[$index];
		$curData = this._data[$index];
		
		if ($index > this._curElementsCnt)
		{
			//No data
			if (noData_goInvisible) $curMc._visible = false;
			if (noData_do_onNoData_callback) this.onNoData($curMc);
			if (noData_useDefaultValues) this.applyDefaultValues($curMc);
			if (noData_gotoAndStop_noData) $curMc.gotoAndStop("noData");
			if (noData_alpha50) $curMc._alpha = 50;
			return;
		}
		
		if (noData_goInvisible) $curMc._visible = true;
		if (noData_alpha50) $curMc._alpha = 100;
		if (noData_gotoAndStop_noData) $curMc.gotoAndStop(1);
		
		for (var $j:Number = 0; $j < this._links.length; ++$j)
		{
			$curLink = this._links[$j];
			
			if($curLink.type != TYPE_MEMBER) $curMcChild = this.getCurMcChild($curMc, $curLink.mc);
			
			switch($curLink.type)
			{
				case TYPE_MEMBER:
				$curMc[$curLink.mc] = $curData[$curLink.data];
				break;
				
				case TYPE_FRAME:
				$curMcChild.gotoAndStop($curData[$curLink.data]);
				break;
				
				case TYPE_TEXT:
				$curMcChild.text = $curData[$curLink.data];
				break;
				
				case TYPE_HTML_TEXT:
				$curMcChild.htmlText = $curData[$curLink.data];
				break;
			}
		}
		
		if (onData_do_onData_callback) this.onData($curMc, $curData);
	}
	
	private function processLinks():Void
	{
		for (var $i:Number = 0; $i < this._maxElementsCnt; ++$i)
		{
			this.sync($i);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setLinks($links:Array):Void
	{
		this._links = $links;
	}
	
	public function refresh($index:Number):Void
	{
		if ($index === null) return;
		else if ($index!=undefined)
		{
			_dataProviderFunction.call(this, _data, $index);
			this.sync($index);
		}
		else
		{
			this._curElementsCnt = _dataProviderFunction.call(this, _data);
			this.processLinks();
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getData($index:Number):Object
	{
		if ($index != undefined)
		{
			return this._data[$index];
		}
		else
		{
			return this._data;
		}
	}
	public function getElement($index:Number):Object
	{
		if ($index != undefined)
		{
			return this._elements[$index];
		}
		else
		{
			return this._elements;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Callbacks											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function onNoData($mc:Object):Void { }
	public function onData($mc:Object, $data:Object):Void {}
}