var g_minimapRoot = _root.main.map.container.map_cells;
var isMove = false;
var MouseX = undefined;
var _MouseX = undefined;
var SCESE_WIDTH = 0;
var WIDTH = _root.main.map.container._width;
var g_minimapLibNames = ["Star", "Ui_resources_my", "Ui_resources_friends", "Ui_resources_boss"];

this.onLoad = function()
{
    _root._visible = false;
}
this.onEnterFrame = function()
{
    if(isMove)
    {
        MoveContainer();
    }
}

_root.main.top_ui.btn_close.onRelease = function()
{
    _root._visible = false;
}

_root.main.map.container.btn_bg.onPress = function()
{
    trace("-container ------------------")
    isMove = true
    MouseX = _root._xmouse;
}

_root.main.map.container.btn_bg.onReleaseOutside = function()
{

}

_root.main.map.container.btn_bg.onRelease = function()
{
    isMove = false
}

function MoveContainer()
{
    if(MouseX != undefined)
    {
        disx = _root._xmouse - MouseX
    }
    g_minimapRoot._x = g_minimapRoot._x + disx;
    if(g_minimapRoot._x < WIDTH - SCESE_WIDTH)
    {
        g_minimapRoot._x = WIDTH - SCESE_WIDTH;
    }
    if(g_minimapRoot._x > 0)
    {
        g_minimapRoot._x = 0
    }
    MouseX = _root._xmouse;
}

function MoveIn()
{
    _root._visible = true;
    _root.main.top_ui._visible = true;
    _root.main.top_ui.gotoAndPlay("opening_ani");
}

function UpdateMinimapInfos(updatedInfos,width,deleteInfos)
{
    for(var i = 0; i < updatedInfos.length; ++i)
    {
        var info = updatedInfos[i];
        var UID = info.UID;

        var mc = g_minimapRoot[UID];
        mc.isUnlock = info.isUnlock
        if(mc == undefined)
        {
            var libName = g_minimapLibNames[info.libIndex];
            g_minimapRoot.attachMovie(libName, UID, g_minimapRoot.getNextHighestDepth());
            mc = g_minimapRoot[UID];
            mc.UID = UID;
            mc.id = info.id;
            mc.isHud = true;
            mc.isUnlock = info.isUnlock
            if(info.libIndex == 0)
            {
                mc.gotoAndStop(info.model)
                mc._xscale = 40
                mc._yscale = 40
                mc.attachMovie("Star_circles","circle",mc.getNextHighestDepth())
                mc.attachMovie("PlayerNameBar","info",mc.getNextHighestDepth())
                if (info.isUnlock)
                {
                    mc["info"].lock._visible = false;
                    mc["info"].NameBarCenter.gotoAndStop(1);
                }
                else
                {
                    mc["info"].lock._visible = true;
                    mc["info"].NameBarCenter.gotoAndStop(2);
                }
                mc["info"].NameBarCenter.txt_name.text = info.galaxyName
                mc["info"]._xscale = 160
                mc["info"]._yscale = 160;

                mc["circle"]._xscale = info.radius + 160;
                mc["circle"]._yscale = info.radius + 160;
                mc.onPress = function()
                {
                    isMove = true
                    MouseX = _root._xmouse;
                    _MouseX = _root._xmouse;
                }
                mc.onRelease = function()
                {
                    if (_root._xmouse - _MouseX < 10 && _root._xmouse - _MouseX > -10)
                    {
                        fscommand("WorldMapCmd","MoveToOherGalaxy" + "\2" + this.id)
                        if (this.isUnlock)
                        {
                            _root._visible = false;
                        }

                    }
                    isMove = false;
                }
            }
        }
        else
        {
            if (info.isUnlock)
            {
                mc["info"].lock._visible = false;
                mc["info"].NameBarCenter.gotoAndStop(1);
            }
            else
            {
                mc["info"].lock._visible = true;
                mc["info"].NameBarCenter.gotoAndStop(2);
            }
        }

        mc._x = info.posx;
        mc._y = info.posy;
        if(info.rotation != undefined)
        {
            mc._rotation = info.rotation;
        }
    }
    SCESE_WIDTH = width;
    for(var j = 0; j < deleteInfos.length; ++j)
    {
        var UID = deleteInfos[j];
        g_minimapRoot[UID].removeMovieClip();
    }

}

function UpdateLineInfos(allLineInfos)
{
    for (var i = 0; i < allLineInfos.length; i++)
    {
        var info = allLineInfos[i]
        var mc = g_minimapRoot[info.lineName]
        if(mc == undefined)
        {
            g_minimapRoot.attachMovie("Line",info.lineName,g_minimapRoot.getNextHighestDepth())
            mc = g_minimapRoot[info.lineName]
            mc._x = info.posx
            mc._y = info.posy
            mc._xscale = (info.distance / mc._width) * 100;
            mc._rotation = -info.rotation
        }
    }
}

function GetScreenSize()
{
    return Viewport.xMax + "\1" + Viewport.yMax + "\1";
}