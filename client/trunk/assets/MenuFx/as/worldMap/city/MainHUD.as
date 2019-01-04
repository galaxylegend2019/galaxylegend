var ui_all=_root.ui_main
var ui_map=ui_all.map.map.map
var ui_map_coord=ui_all.map_coord
var ui_tab_bottom=ui_all.tab_bottom
var mcPools:Array
var usePools:Array
var radius=500-50
var isShow=false
var uniqueID=1
var UIID
var MenuDatas
var isShowMenu=false
var WORLD_MAP_WIDTH
var WORLD_MAP_HEIGHT
var ARROW_OFFSET=80
this.onLoad = function()
{
	_root.ui_main.tab_bottom._visible=false
	_root.ui_main.tab_bottom.talk_content._visible=false
	WORLD_MAP_WIDTH=ui_map._width
	WORLD_MAP_HEIGHT=ui_map._height

	InitEventBtn();
}


function InitEventBtn()
{
	//ui_all.new_event.event.time_txt._visible = false;
	UpdateEventRedPoint(false);
}

function UpdateEventRedPoint( is_show )
{
	if (is_show)
	{
		ui_all.new_event.gotoAndStop(2);
		//ui_all.new_event.event.time_txt._visible = false;
	}else
	{
		ui_all.new_event.gotoAndStop(1);
		//ui_all.new_event.event.time_txt._visible = false;
	}
}

function SetData(ID)
{
	//ui_all.event_list
	UIID=ID
}

//---------------------for coord desc-------------------------
function SetMapCoordData(obj)
{
	ui_map_coord.coord_text.text=obj.coordinate
	ui_map_coord.txt_desc.text=obj.coordDesc

/*	if(obj.distanceDesc!=undefined)
	{
		_root.dir.dis_desc.text=obj.distanceDesc
		_root.dir.dis_num.text=obj.distanceNum		
	}

	if(obj.radius!=undefined)
	{
		radius=obj.radius
	}
	SetDirAngleCok(obj.angle%360,obj.isVisible)*/
	//SetDirAngle(obj.angle%360,obj.isVisible)
}
_root.dir.onRelease=function()
{
	fscommand("MapCommand","BackToBase")
}

//------------for my think
function SetDirAngle(angle,isVisible)
{
	//trace()

	var MC=_root.dir
	MC._visible=isVisible
	var centerX=_root._width/2
	var centerY=_root._height/2

	var dx = _xmouse - centerX; 
	var dy = centerY-_ymouse

/*	if(angle==undefined)
	{
		angle =30//GetSinAngle(Math.abs(dy)/Math.abs(dx)); 
	}*/
	//var angle =GetSinAngle(Math.abs(dy)/Math.abs(dx)); 
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

ui_map_coord.btn_search.onRelease=function()
{
	fscommand("MapCommand","SearchCoord")
}
ui_map_coord.bg.onRelease=function()
{
	fscommand("MapCommand","SearchCoord")
}

//--------------------for news event
ui_all.new_event.onRelease=function()
{
	fscommand("MapCommand","Event")
}



//---------------------for small map-------------------------------
ui_map.onRelease=function()
{
	var xPos=math.floor((this._xmouse/WORLD_MAP_WIDTH)*100)
	var yPos=math.floor((this._ymouse/WORLD_MAP_HEIGHT)*100)
	fscommand("MapCommand","ClickSmallMap\2"+xPos+"\2"+yPos)
}

function GetSinAngle(sinValue)
{
	return Math.floor(Math.atan(sinValue)*180/Math.PI)
}



function getUniqueName(str)
{
	uniqueID++;
	return str+uniqueID
}

function GetVisibleMC(mcType)
{
	var colorType=new Array("icon_map_self_ani","icon_map_boss3_ani","icon_map_boss2","icon_map_boss1","icon_map_location")
	for(var i=0;i<mcPools.length;i++)
	{
		var mc=mcPools[i]

		if(mcType==mc.Type && mc._visible==false)
		{
			return mc
		}
	}

	var mclink=colorType[mcType-1]
	var tempName=getUniqueName("boss")

	ui_map.attachMovie(mclink,tempName,ui_map.getNextHighestDepth(),{_x:0,_y:0})
	ui_map[tempName].Type=mcType

	return ui_map[tempName]
}

function SetSmallMapData(smallMapData)
{
	if(smallMapData==undefined)
	{
		trace("smallMapData is undefined in MainHUD.as")
		return
	}
	for(i=0;i<usePools.length;i++)
	{
		usePools[i]._visible=false
	}
	usePools=new Array()

	for(var i=0;i<smallMapData.length;i++)
	{
		var itemData=smallMapData[i]
		var mc=GetVisibleMC(itemData.Type)
		usePools.push(mc)
		mc._visible=true

		var xPos=math.floor((itemData.xPos/100)*WORLD_MAP_WIDTH)
		if(xPos<mc._width/2)
		{
			xPos=mc._width/2
		}else if(xPos>(WORLD_MAP_WIDTH-(mc._width/2)))
		{
			xPos=WORLD_MAP_WIDTH-(mc._width/2)
		}

		var yPos=math.floor((itemData.yPos/100)*WORLD_MAP_HEIGHT)
		if(yPos<mc._height/2)
		{
			yPos=mc._height/2
		}else if(yPos>(WORLD_MAP_HEIGHT-(mc._height/2)))
		{
			yPos=WORLD_MAP_HEIGHT-(mc._height/2)
		}

		mc._x=xPos
		mc._y=yPos
		//mc._x=math.floor((itemData.xPos/100)*WORLD_MAP_WIDTH)
		//mc._y=math.floor((itemData.yPos/100)*WORLD_MAP_HEIGHT)
	}
}

ui_all.mark_btn.onRelease=function()
{
	fscommand("MapCommand","ShowMark")
}
ui_all.mapon_btn.onRelease=function()
{
	fscommand("MapCommand","SwitchColor")
}

_root.ui_main.map_coord.btn_back_base.onRelease=function()
{
	fscommand("MapCommand","BackToBase")
}

/*ui_all.event_list.mc_list.onRelease=function()
{
	fscommand("MapCommand","ShowTripDetail")
}*/

ui_all.map.btn_hide_show.onRelease=function()
{
	if(isShow==true)
	{
		ui_all.map.gotoAndPlay("closing_ani")
	}else
	{
		ui_all.map.gotoAndPlay("opening_ani")
	}
	isShow=!isShow
}

//--------------------------------------------for right news---------------------------



//--------------------------------------------for update money info------------------------
function SetMoneyData(obj)
{
	ui_all.money_info.fuel.txt_num.text=obj.fuel
	ui_all.money_info.money.txt_num.text=obj.money
}

ui_all.money_info.fuel.onRelease=function()
{
	fscommand("GoToNext", "Affair");
}

ui_all.money_info.money.onRelease=function()
{
	fscommand("GoToNext", "Purchase");
}


//------------------------------------------for init bottom button---------------------------.
function keepIcon(mc)
{
	mc.gotoAndStop(mc._parent.iconIndex)
}

function InitUIData(datas)
{
	MenuDatas=datas
	ui_tab_bottom.button_list._visible=false
}

function InitButtons()
{

	var tab_bottom=ui_all.tab_bottom
	tab_bottom.gotoAndPlay("move_in")

	tab_bottom.button_list._visible=true
	tab_bottom.button_list.gotoAndPlay("move_in")
	tab_bottom.line_bg.gotoAndPlay("move_in")

	tab_bottom.line_bg._width=1000

	var mc_bottons=tab_bottom.button_list.ViewList
	for(var i=1;i<=8;i++)
	{
		var menuData=MenuDatas[i-1]	
		var btn=mc_bottons["btn_"+i]

/*		if(menuData.isUnread==true)
		{
			showUnread(btn,true)
		}else
		{
			showUnread(btn,false)
		}*/

		if(MenuDatas.length<i)
		{
			btn._visible=false
			continue
		}

		btn.menuData=menuData
		btn.btn_name.btn_name_text.text=menuData.btnNameText
		btn.iconIndex=menuData.icon
		btn.item_icons.gotoAndStop(menuData.icon)

		btn.onRelease=function()
		{
			if(this.menuData.type=="page")
			{
				var strPage=this.menuData.pageName
				fscommand("GotoNextMenu",strPage)
			}else
			{
				var message=this.menuData.message
				fscommand("MapCommand",message)
			}
		}

	}
}
ui_all.tab_bottom.btn_arrow.onRelease=hideAndShow

function hideAndShow()
{
	isShowMenu=!isShowMenu

	if(isShowMenu)
	{
		ui_tab_bottom.button_list._visible=true
		ui_tab_bottom.gotoAndStop("move_in")
		ui_tab_bottom.btn_arrow.gotoAndStop("opening_ani")
		InitButtons()
	}else
	{
		ui_tab_bottom.gotoAndPlay("move_out")
		ui_tab_bottom.OnMoveOutOver=function()
		{
			this.button_list._visible=false
		}
		ui_tab_bottom.btn_arrow.gotoAndStop("closing_ani")
	}

	ui_tab_bottom.btn_arrow.onRelease=hideAndShow
}

ui_all.btn_close.onRelease=function()
{
	fscommand("MapCommand","btnClose")
}


//--------------------------------------for play ui animation----------------------
function SetUIPlay(flag)
{
	if(flag==true)
	{
		_root._visible=true
		ui_all.gotoAndPlay("opening_ani")
	}else
	{
		ui_all.gotoAndPlay("closing_ani")
		ui_all.OnMoveOutOver=function()
		{
			_root._visible=false
			fscommand("MapCommand","UIClose\2"+"WMHUD")
		}
	}
}


/////////////////Test///////////////////////

ui_all.pvp.onRelease = function()
{
	fscommand("MapCommand","Arena");
}

ui_all.pve.onRelease = function()
{
	fscommand("MapCommand","Pve");
}

ui_all.expedition.onRelease = function()
{
	fscommand("MapCommand","Expedition");
}