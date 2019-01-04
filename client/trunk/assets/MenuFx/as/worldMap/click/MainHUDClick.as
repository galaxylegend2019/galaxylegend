var WORLD_MAP_WIDTH
var WORLD_MAP_HEIGHT

_root.onLoad=function()
{	
	WORLD_MAP_WIDTH=_root.smap._width
	WORLD_MAP_HEIGHT=_root.smap._height
}

_root.smap.onRelease=function()
{
	var xPos=(this._xmouse/WORLD_MAP_WIDTH)*100
	var yPos=(this._ymouse/WORLD_MAP_HEIGHT)*100
	fscommand("MapCommand","ClickSmallMap\2"+xPos+"\2"+yPos)
}