var WORLD_MAP_WIDTH
var WORLD_MAP_HEIGHT
var ARROW_OFFSET=120
var radius=400

this.onLoad = function()
{
	WORLD_MAP_WIDTH=ui_map._width
	WORLD_MAP_HEIGHT=ui_map._height
}

//---------------------for coord desc-------------------------
function SetMapCoordData(obj)
{
	if(obj.distanceDesc!=undefined)
	{
		_root.dir.dis_desc.text=obj.distanceDesc
		_root.dir.dis_num.text=obj.distanceNum		
	}

	if(obj.radius!=undefined)
	{
		radius=obj.radius
	}
	SetDirAngleCok(obj.angle%360,obj.isVisible)
}
_root.dir.onRelease=function()
{
	fscommand("MapCommand","BackToBase")
}

//Set angle for like cok----------------------------
function SetDirAngleCok(angle,isVisible)
{
	var MC=_root.dir
	MC._visible=isVisible
	var centerX=Stage.width/2
	var centerY=Stage.height/2

	var yLen=Math.sin(angle*Math.PI/180)*radius
	var xLen=Math.cos(angle*Math.PI/180)*radius
	var tansY=centerY-yLen
	var tansX=centerX+xLen

	if(tansY<ARROW_OFFSET)
	{
		tansY=ARROW_OFFSET
	}else if(tansY>Stage.height-ARROW_OFFSET)
	{
		tansY=Stage.height-ARROW_OFFSET
	}

	MC._rotation = 90-angle+180
	MC._y=Math.floor(tansY)
	MC._x=Math.floor(tansX)
}


/*//------------for my think
function SetDirAngle(angle,isVisible)
{
	//trace()

	var MC=_root.dir
	MC._visible=isVisible
	var centerX=_root._width/2
	var centerY=_root._height/2

	var dx = _xmouse - centerX; 
	var dy = centerY-_ymouse


	var tansAngle=135//==0

	var tansX=0
	var tansY=0

	var yLen=Math.sin(angle*Math.PI/180)*radius
	var xLen=Math.cos(angle*Math.PI/180)*radius

	if(angle>=0 && angle<90)//(dx>0 && dy>0)
	{
		//1st quadrant
		tansAngle=tansAngle-angle
		tansY=centerY-yLen
		tansX=centerX+xLen

	}else if(angle>=90 && angle<180)//(dx<0 && dy>0)
	{
		//2nd quadrant
		tansAngle=tansAngle-(90-angle)-90

		tansY=centerY-yLen
		tansX=centerX+xLen
	}
	else if(angle>=180 && angle<270)//(dx<0 && dy<0)
	{
		//3th quadrant
		tansAngle=tansAngle-angle-180

		tansY=centerY-yLen
		tansX=centerX+xLen
	}
	else
	{
		//4th quadrant
		tansAngle=tansAngle-(90-angle)-180-90
		tansY=centerY-yLen
		tansX=centerX+xLen
	}

	MC._rotation = 90-angle//tansAngle

}
*/

