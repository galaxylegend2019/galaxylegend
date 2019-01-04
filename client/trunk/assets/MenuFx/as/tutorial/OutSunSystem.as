
var StartPanel 	= _root.start_panel;
var DialogPanel = _root.left_npc;
var TipsPanel 	= _root.tips;
var PvePanel 	= _root.pve;

var CurPlanetId 	= 1;

_root.onLoad = function()
{
	StartPanel._visible 	= true;
	DialogPanel._visible 	= false;
	TipsPanel._visible 		= false;
	PvePanel._visible 		= false;
}


StartPanel.content.goto_btn.onRelease = function()
{
	PvePanel._visible = true;
	StartPanel._visible = false;
	PvePanel.OnMoveInOver = function()
	{
		DialogPanel._visible = true;
		DialogPanel.gotoAndPlay("opening_ani");
	}
	for(var i = 1; i <= 5; i++)
	{
		PvePanel["planet" + i].gotoAndPlay("opening_ani");
		PvePanel["planet" + i].planet_id = i;
		SetPlanetState(i, "lock");
		
	}
	PvePanel.gotoAndPlay("opening_ani");
	fscommand("WorldMapCmd", "Tutorial\2" + "tracking_go")
}

function CloseDialogPanel()
{
	DialogPanel.bg_btn.onRelease = function()
	{
		DialogPanel._visible = false;
		TipsPanel._visible = true;
		TipsPanel.gotoAndPlay("opening_ani");
		SetPlanetState(1, "open");
	}
}

DialogPanel.OnMoveInOver = function()
{
	CloseDialogPanel();
}

//datas.planet_id
//datas.state
function InitPanel(datas)
{
	var planet_datas = datas.planet_datas
	CurPlanetId 	= datas.cur_planet_id
	StartPanel._visible 	= false;
	DialogPanel._visible 	= false;
	TipsPanel._visible 		= true;
	PvePanel._visible 		= true;
	for(var i = 0; i < 5; ++i)
	{
		SetPlanetState(planet_datas[i].planet_id, planet_datas[i].state);
	}
}

//lock open over
function SetPlanetState(planet_id ,state)
{
	var mc = PvePanel["planet" + planet_id];
	mc.planet_id = planet_id
	if (state == "lock")
	{
		mc.planet.gotoAndStop(1);
		mc.onRelease = undefined;
	}else if (state == "open")
	{
		mc.planet.gotoAndStop(2);

		mc.onRelease = function()
		{
			// SetPlanetState(PvePanel.planet1, "over");
			// PlayShipMove("4_5");

			if (this.planet_id == 1)
			{
				fscommand("WorldMapCmd", "Tutorial\2" + "PlanetCombat\2" + this.planet_id);
			}else
			{
				PlayShipMove(this.planet_id);
			}
			this.onRelease = undefined;
			
		}
	}else if (state == "over")
	{
		mc.planet.gotoAndStop(3);

		if (CurPlanetId == planet_id)
		{
			mc.planet.star.gotoAndPlay(1);	
		}else
		{
			mc.planet.star.gotoAndStop("end");	
		}
		mc.onRelease = undefined;
	}
}

//1-2 2-3 3-4 4-5
function PlayShipMove(planet_id)
{
	var move_path = (planet_id - 1) + "_" + planet_id;
	var ship_mc = PvePanel["move" + move_path];
	if (ship_mc == undefined)
	{
		return;
	}
	ship_mc.planet_id = planet_id;
	ship_mc.OnMoveInOver = function()
	{
		fscommand("WorldMapCmd", "Tutorial\2" + "PlanetCombat\2" + this.planet_id);
	}
	ship_mc.gotoAndPlay(1);

}