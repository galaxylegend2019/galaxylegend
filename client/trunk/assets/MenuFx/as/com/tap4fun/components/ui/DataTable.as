/*								DataTable
**
** my_cb = com.tap4fun.components.ui.DataTable.construct();
** Le MovieClip doit comporter:
**	-Un MovieClip nommé row qui servira de template pour chaque item ayant comme frame labels: "normal", "selected"
**
*********Properties****************************Description******
*********Methods****************************Description*******
**check():Void			//Coche le checkbox
**uncheck():Void		//Décoche le checkbox
**toggle():Void			//Coche si décoché et vice versa
*********Events*****************************Description*******

*********TODO*************************************************
**
*/
[IconFile("icons/AlertMenu.png")]
class com.tap4fun.components.ui.DataTable extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "DataTable";
	static var symbolOwner:Object = DataTable;
	var className:String = "DataTable";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	[Inspectable (defaultValue=0)]
	public var itemDistance:Number;
	
	private var _items:Array;
	private var _selection:Number;
	private var row:MovieClip;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function DataTable()
	{
		if(row == undefined) trace("Error: MovieClip with id \"row\" not found in " + this);
		row._visible = false;
		if(itemDistance == undefined || itemDistance == 0) this.itemDistance = this.row._height;
		clear();
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function clear():Void
	{
		if(_items != undefined && _items != null)
		{
			for(var $i = 0; $i < _items.length; $i++)
			{
				getItem($i).removeMovieClip();
			}
		}
		
		_selection = -1;
		_items = new Array();
	}
	public function setItems($values:Array):Void
	{
		clear();
		
		for(var $i = 0; $i < $values.length; $i++)
		{
			 addItem($values[$i]);
		}
	}
	public function addItem($values:Object):Void
	{
		var $next_depth:Number = this.getNextHighestDepth();
		var $item:MovieClip = this.row.duplicateMovieClip("item" + _items.length, $next_depth);
		$item.onAnimationEnd = function():Void
		{
			this.stop();
		};
		$item._y = this.row._y + (_items.length * itemDistance);
		$item._visible = true;
		setItem(_items.length, $values);
		_items.push($item);
	}
	public function setItem($index:Number, $values:Object):Void
	{
		var $item:MovieClip = getItem($index);
		for(var $i in $values)
		{
			$item[$i].text = $values[$i];
			$item[$i].textToFill = $values[$i];
			if($item[$i] == undefined) trace("Error: Column " + $i + " not found in DataTable " + this + ", insert a Text component with the id \"" + $i + "\" in your row MovieClip.");
			$item[$i].onLoad = function() {this.setText(this.textToFill);};
		}
	}
	public function getItem($index:Number):MovieClip
	{
		return this["item" + $index];
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function getItemCount():Number
	{
		return this._items.length;
	}
	public function setSelectedItem($index:Number):Void
	{
		if($index == _selection)
			return;
		
		if(getItem(_selection).gotoAndPlay)getItem(_selection).gotoAndPlay("normal");
		_selection = $index;
		if(getItem(_selection).gotoAndPlay)getItem(_selection).gotoAndPlay("selected");
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}