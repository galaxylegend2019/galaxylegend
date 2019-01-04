import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

var g_screenW = _root._width;
var g_screenH = _root._height;

var g_MainUi = _root.main_ui;

trace("g_screenW: " + g_screenW + " g_screenH: " + g_screenH);

_root.btn_bg._visible = false;

this.onLoad = function(){
	init();
}

function init()
{
	g_MainUi._visible = false;

	// var info = new Object();
	// info.entityType = "boss";
	// info.entityId = 100;
	// info.levelTxt = 10;
	// info.oldDamageTxt = "6%";
	// info.newDamageTxt = "9%";
	// ShowResult(info);
}

function ShowResult(info)
{
	g_MainUi.entityType = info.entityType;
	g_MainUi.entityId = info.entityId;

	g_MainUi.rank_bar.txt_rank.text = info.rankTxt;
	g_MainUi.damage_bar.txt_old.text = info.oldDamageTxt;
	g_MainUi.damage_bar.txt_new.text = info.newDamageTxt;

	for(var i = 0; i < 5; ++i)
	{
		var mc = g_MainUi["hero" + (i + 1)];
		var heroInfo = info.heroInfos[i];
		if(heroInfo)
		{
			mc.hero_lv_up_plane._visible = heroInfo.isUpgraded;
			if(heroInfo.isUpgraded)
			{
				mc.hero_lv_up_plane.gotoAndPlay(1);
			}

			mc.star.gotoAndStop(heroInfo.star);
			mc.blood._visible = heroInfo.progressNum > 1;
			mc.blood.gotoAndStop(Math.floor(heroInfo.progressNum) + 2);
		}
		else
		{
			mc.hero_lv_up_plane._visible = false;
			mc.star._visible = false;
			mc.blood._visible = false;
		}
		
		if (mc.hero_icon.icons == undefined)
		{
			mc.hero_icon.loadMovie("CommonHeros.swf");
		}

		mc.hero_icon.IconData = heroInfo.iconData;
		if(mc.hero_icon.UpdateIcon)
		{ 
			mc.hero_icon.UpdateIcon(); 
		}
	}

	_root.btn_bg._visible = true;
	_root.btn_bg.onRelease = function()
	{
		// no click through
	}

	g_MainUi._visible = true;
	g_MainUi.OnMoveInOver = function()
	{
		fscommand('UnlockInput');
		this.btn_close.onRelease = function()
		{
			this._parent.OnMoveOutOver = function()
			{
				this._parent.btn_bg._visible = false;
				this._visible = false;
				fscommand("ExitBack", "");
			}
			this._parent.gotoAndPlay("closing_ani");
		}
		this.btn_again.onRelease = function()
		{
			this._parent.OnMoveOutOver = function()
			{
				this._parent.btn_bg._visible = false;
				this._visible = false;
				fscommand("WorldMapCmd", "OnBossPopClick" + "\2" + this.entityType + "\2" + this.entityId + "\2" + "again");
				fscommand("ExitBack", "");
			}
			this._parent.gotoAndPlay("closing_ani");
		}
	}
	g_MainUi.gotoAndPlay("opening_ani");
}