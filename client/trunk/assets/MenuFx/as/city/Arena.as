import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;
import common.Lua.LuaSA_MenuType;

function getChildrenOf(movie)
{
	var ret = [];
	for(i in movie)
	{
		var ch = movie[i];
		if(ch instanceof MovieClip)
		{
			ret.push(ch);
		}
	}	
	return ret;
}

//Top Level
var g_HeroInfo = _root.HeroInfo;
var g_EnemyInfo = _root.EnemyInfo;
var g_BottomBar = _root.BottomBar;

//Enemy Info
var g_EnemyInfos = [g_EnemyInfo.Enemy_0, g_EnemyInfo.Enemy_1, g_EnemyInfo.Enemy_2, g_EnemyInfo.Enemy_3];
var g_RefreshBar = g_EnemyInfo.EnemyBG.refreshBar;

//Energy
var g_EnergyBtn = g_HeroInfo.Energy.btn_Energy;
var g_EnergyNum = g_HeroInfo.EnergyNum.txt_Num;

//Hero Info
var g_HeroCombatPower = g_HeroInfo.combat_num.num.txt_Num;

var g_HeroHeadIcon = undefined;
var g_HeroTitle = g_HeroInfo.titleBar.txt_Title;
var g_HeroRank = g_HeroInfo.RankBar.rank;

var g_Heros = [g_HeroInfo.item_0, g_HeroInfo.item_1, g_HeroInfo.item_2, g_HeroInfo.item_3, g_HeroInfo.item_4, g_HeroInfo.item_5];

var g_DefendBtn = g_HeroInfo.btn_Defend;
var g_BackBtn = g_HeroInfo.btn_close;
var g_ExchangeBtn = g_BottomBar.btn_Exchange;
var g_RankBtn = g_BottomBar.btn_Rank;
var g_HistoryBtn = g_BottomBar.btn_History;
var g_RuleBtn = g_BottomBar.btn_Rule;
var g_RefreshBtn = undefined;
var g_Refresh2Btn = undefined;
var g_ArrowBtn = g_HeroInfo.btn_TopArrow;

var move_out_target = "";
var g_swtichState = 1;
var g_isSwitchHeroState = false;

var g_enemyInfoPosX = [350, -350, 350, -350];
var g_enemyInfoPosY = [130, 100, 20, 20];

//get cache move clip functions
function GetHeroTeamInfo(i)
{
	var item = g_Heros[i];
	if(item.hero_icons != undefined && item.hero_icons.icons == undefined)
	{
		item.hero_icons.loadMovie("CommonHeros.swf");
	}	

	return item;
}

function GetEnemyTeamInfo(i)
{
	var item = g_EnemyInfos[i];
	item["iconBar"] = item.btn_iconBar;
	// item.iconBar.hero_icons.gotoAndStop(2);
	if(item.iconBar.hero_icons != undefined && item.iconBar.hero_icons.icons == undefined)
	{
		item.iconBar.hero_icons.loadMovie("CommonPlayerIcons.swf");
	}	
	return item;
}


//cs functions
this.onLoad = function(){
	init();

	// move_in();
}

function init()
{
	_root.move_out_target = "";

	SetTopInvisible();

	// g_HeroInfo.headIcon.hero_icons.gotoAndStop(2);
	g_HeroInfo.headIcon.hero_icons.loadMovie("CommonPlayerIcons.swf");
	g_HeroHeadIcon = g_HeroInfo.headIcon.hero_icons;

	InitEnemyInfos();

	// move_in();
	// SetEnergyNum("75/100");
	// SetRefreshCredit("11");
	// SetRefreshCountDown("01:02:03");
}

function SetTopInvisible()
{
	g_HeroInfo._visible = false;
	g_EnemyInfo._visible = false;
	g_BottomBar._visible = false;
}

function InitEnemyInfos()
{
	for(var i = 0 ; i < g_EnemyInfos.length ; ++i)
	{
		g_EnemyInfos[i].my_index = i;
		g_EnemyInfos[i].is_moved_in = false;
		g_EnemyInfos[i].is_moving_in = false;

		g_EnemyInfos[i].is_moved_out = false;
		g_EnemyInfos[i].is_moving_out = false;
		g_EnemyInfos[i].OnMoveOutOver = function()
		{
			if(not this.is_moved_out)
			{
				this.is_moved_out = true;
				this.is_moving_out = false;
				var all_moved_out = true;
				for(var j = 0; j < g_EnemyInfos.length; ++j)
				{
					if(not g_EnemyInfos[j].is_moved_out)
					{
						all_moved_out = false;
						break;
					}
				}
				if(all_moved_out)
				{
					// _root.move_out();
				}
			}			
		}

		// g_EnemyInfos[i].onRelease = function()
		// {
		// 	if(this.is_moved_in && !this.is_moving_out && _root.move_out_target == "")
		// 	{
		// 		fscommand("ArenaEnemyClicked", this.my_index);
		// 		_root.move_out_target = "ArenaBattle";
		// 		_root.move_out_enemy();
		// 		_root.move_out();
		// 	}
		// }

		
	}
}

function SetRefreshBtn(isRefresh, credit, countDown)
{
	if(isRefresh)
	{
		g_RefreshBar.gotoAndStop(1);
		g_RefreshBar.btn_Refresh2.onRelease = function()
		{
			fscommand("ArenaStartFreshEnemy");
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_refresh_arena");
		}
        // g_EnemyInfo.energyInfo_2.timeBarall.gotoAndStop(2);
	}
	else
	{
		g_RefreshBar.gotoAndStop(2);
		g_RefreshBar.btn_Refresh.onRelease = function()
		{
			fscommand("ArenaNoCDClicked", "CD");
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_confirm_purchase");
		}

        g_RefreshBar.btn_Refresh.txt_Credit.text = credit;
        g_RefreshBar.timeBar.txt_Time.text = countDown;
        // g_EnemyInfo.energyInfo_2.timeBarall.gotoAndStop(1);
        // g_EnemyInfo.energyInfo_2.timeBarall.timeBar.txt_Time.text = countDown;
	}
}

function SetEnergyNum(numTxt, isShowAdd)
{
	g_EnemyInfo.energyInfo_1.energyBar.txt_Num.text = numTxt;
	if(isShowAdd)
	{
		g_EnemyInfo.energyInfo_1.energyBar.btn_Add._visible = true;
	}
	else
	{
		g_EnemyInfo.energyInfo_1.energyBar.btn_Add._visible = false;
	}
	// g_EnemyInfo.energyInfo_2.energyBar.txt_Num.text = numTxt;
}

function move_in()
{
	g_HeroInfo._visible = true;

	g_HeroInfo.OnMoveInOver = function()
	{
		_root.InitButtonFunctions();
		// _root.switch_hero_state();
	}

	g_HeroInfo.gotoAndPlay("opening_ani");
	g_swtichState = 1;
	g_isSwitchHeroState = false;

	g_HeroInfo.headIcon.gotoAndPlay("opening_ani");

	g_BottomBar._visible = true;
	g_BottomBar.gotoAndPlay("opening_ani");

	fscommand("TutorialCommand","Activate" + "\2" + "OpenArena");
}

function move_out()
{
	if(g_swtichState == 1)
	{
		g_HeroInfo.gotoAndPlay("closing_ani");
	}
	else
	{
		g_HeroInfo.gotoAndPlay("closing_ani2");
		for(var i = 0; i < g_Heros.length; ++i)
		{
			g_Heros[i].gotoAndPlay("closing_ani");
		}
	}
	g_HeroInfo.headIcon.gotoAndPlay("closing_ani");


	_root.ClearButtonFunctions();
	if(_root.move_out_target != "")
	{
		g_HeroInfo.OnMoveOutOver = function()
		{
			if(_root.move_out_target == "Back")
			{
				fscommand("GotoNextMenu", "GS_MainMenu");
			}
			else
			{
				fscommand("GoToNext", _root.move_out_target);
			}
			_root.move_out_target = "";
			_root.SetTopInvisible();
		}
	}
	else
	{
		g_HeroInfo.OnMoveOutOver = undefined;
	}

	g_BottomBar.gotoAndPlay("closing_ani");
}

function move_in_enemy(canAttack)
{
	g_EnemyInfo._visible = true;
	g_EnemyInfo.EnemyBG.is_moved_in = false;
	g_EnemyInfo.EnemyBG.OnMoveInOver = function()
	{
		this.is_moved_in = true;
	}

	g_EnemyInfo.EnemyBG.gotoAndPlay("opening_ani");

	g_EnemyInfo.energyInfo_1.gotoAndPlay("opening_ani");
	g_EnemyInfo.energyInfo_1.OnMoveInOver = function()
	{
		g_EnemyInfo.energyInfo_1.energyBar.btn_Add.onRelease = function()
		{
			fscommand("ArenaNoCDClicked", "energy");
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_confirm_purchase");
		}
	}

    // g_EnemyInfo.energyInfo_2.gotoAndPlay("opening_ani");

	for(var i = 0 ; i < g_EnemyInfos.length ; ++i)
	{
		g_EnemyInfos[i].is_moved_in = false;
		g_EnemyInfos[i].is_moving_in = false;
		g_EnemyInfos[i].is_moved_out = true;
		g_EnemyInfos[i].is_moving_out = false;
		g_EnemyInfos[i].my_can_attack = canAttack;
		g_EnemyInfos[i].gotoAndPlay(canAttack ? "opening_ani" : "opening_ani_1");
		// trace(canAttack ? "opening_ani" : "opening_ani_1");

		g_EnemyInfos[i].btn_attack.my_index = i;
		g_EnemyInfos[i].btn_iconBar.my_index = i;
		g_EnemyInfos[i].btn_Info.my_index = i;
		g_EnemyInfos[i].btn_bg.my_index = i;

		g_EnemyInfos[i].OnMoveInOver = function()
		{
				/*******FTE*******/
				fscommand("TutorialCommand","Activate" + "\2" + "ArenaUILoad");
				/*******End*******/
			
			this.is_moved_in = true;
			this.is_moving_in = false;

			this.btn_attack.onRelease = function()
			{
				/*******FTE*******/
				fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickEditTroopBtn");
				/*******End*******/
				if(g_EnemyInfos[this.my_index].my_can_attack && g_EnemyInfos[this.my_index].is_moved_in && !g_EnemyInfos[this.my_index].is_moving_out && _root.move_out_target == "")
				{
					fscommand("ArenaEnemyClicked", this.my_index);
					fscommand("PlayMenuConfirm");
				}
			}

			this.btn_iconBar.onRelease = this.btn_Info.onRelease = this.btn_bg.onRelease = function()
            {
                var pos = new Object();
                pos.x = _root._xmouse;
                pos.y = _root._ymouse;
                // pos.x = g_EnemyInfos[this.my_index].btn_iconBar._x + g_enemyInfoPosX[this.my_index];
                // pos.y = g_enemyInfoPosY[this.my_index];
                // g_EnemyInfos[this.my_index].localToGlobal(pos);
				fscommand("SetEnemyTeamInfo", this.my_index + "\2" + pos.x + "\2" + pos.y);
				fscommand("PlayMenuConfirm");
			}
		}

		g_EnemyInfos[i].btn_iconBar.gotoAndPlay("opening_ani");
	}
}

function move_out_enemy()
{
	if(!g_EnemyInfo.EnemyBG.is_moved_in)
	{
		g_EnemyInfo._visible = false;
		return
	}
	g_EnemyInfo._visible = true;
	g_EnemyInfo.EnemyBG.is_moved_in = false;
	g_EnemyInfo.EnemyBG.gotoAndPlay("closing_ani");

	g_EnemyInfo.energyInfo_1.energyBar.btn_Add.onRelease = false;
	g_EnemyInfo.energyInfo_1.gotoAndPlay("closing_ani");
    // g_EnemyInfo.energyInfo_2.gotoAndPlay("closing_ani");

	for(var i = 0 ; i < g_EnemyInfos.length ; ++i)
	{
		g_EnemyInfos[i].is_moved_in = true;
		g_EnemyInfos[i].is_moving_in = false;
		g_EnemyInfos[i].is_moved_out = false;
		g_EnemyInfos[i].is_moving_out = true;
		g_EnemyInfos[i].gotoAndPlay(g_EnemyInfos[i].my_can_attack ? "close_ani" : "close_ani_1");
		g_EnemyInfos[i].btn_iconBar.gotoAndPlay("closing_ani");
		g_EnemyInfos[i].btn_iconBar.onRelease = undefined;
		g_EnemyInfos[i].btn_attack.onRelease = undefined;
		g_EnemyInfos[i].btn_Info.onRelease = undefined;
	}
}

function CheckCanAttackUI(canAttack)
{
	for(var i = 0 ; i < g_EnemyInfos.length ; ++i)
	{
		if(g_EnemyInfos[i].is_moved_in && (!g_EnemyInfos[i].is_moving_out))
		{
			if(canAttack && !g_EnemyInfos[i].my_can_attack)
			{
				g_EnemyInfos[i].my_can_attack = true;
				g_EnemyInfos[i].gotoAndPlay("button_open");
			}
			else if(!canAttack && g_EnemyInfos[i].my_can_attack)
			{
				g_EnemyInfos[i].my_can_attack = false;	
				g_EnemyInfos[i].gotoAndPlay("button_close");
			}
		}
	}
}

function switch_hero_state()
{
	if(g_swtichState == 1)
	{
		g_swtichState = 2;
		g_HeroInfo.gotoAndPlay("switch1");
		_root.ClearButtonFunctions();

		for(var i = 0; i < g_Heros.length; ++i)
		{
			g_Heros[i].gotoAndPlay("opening_ani");
		}
		g_isSwitchHeroState = true;
	}
	else
	{
		g_swtichState = 1;
		g_HeroInfo.gotoAndPlay("switch2");
		_root.ClearButtonFunctions();

		for(var i = 0; i < g_Heros.length; ++i)
		{
			g_Heros[i].gotoAndPlay("closing_ani");
		}
		g_isSwitchHeroState = true;
	}
}

function set_rank_num(rank, num, isLeft, maxDigit)
{
	var digits = [];
	num = Math.floor(num);
	while(num > 0)
	{
		var c = num % 10;
		digits.push(c);
		num /= 10;
		num = Math.floor(num);
	}
	for(var j = digits.length; j < maxDigit; ++j)
	{
		if(isLeft)
		{
			digits.unshift(-1);
		}
		else
		{
			digits.push(-1);
		}
	}
	// trace(digits);
	for(var i = 0; i < maxDigit; ++i)
	{
		var clipIndex = i + 1;
		var clip = rank["r_" + clipIndex];
		var d = digits[i];
		if(d != -1)
		{
			var frame = (d == 0) ? 1 : (d + 1);
			clip._visible = true;
			clip.gotoAndStop(frame);
		}
		else
		{
			clip._visible = false;
		}
	}
}

function set_rank_num_center(rank, num)
{
	if(num >= 10000)
	{
		rank.gotoAndStop(5);
	}
	else if(num >= 1000)
	{
		rank.gotoAndStop(4);

	}
	else if(num >= 100)
	{
		rank.gotoAndStop(3);
		
	}
	else if(num >= 10)
	{
		rank.gotoAndStop(2);
	}
	else 
	{
		rank.gotoAndStop(1);
	}

	var digits = [];
	num = Math.floor(num);
	while(num > 0)
	{
		var c = num % 10;
		digits.unshift(c);
		num /= 10;
		num = Math.floor(num);
	}
	var maxDigit = 5;
	for(var j = digits.length; j < maxDigit; ++j)
	{

		digits.push(-1);
	}
	// trace(digits);
	for(var i = 0; i < maxDigit; ++i)
	{
		var clipIndex = i;
		var clip = rank["r_" + clipIndex];
		var d = digits[i];
		if(d != -1)
		{
			var frame = (d == 0) ? 1 : (d + 1);
			clip._visible = true;
			clip.gotoAndStop(frame);
		}
		else
		{
			clip._visible = false;
		}
	}
}

//info: [ heroTitle(localized), heroName, combat(formated), rank ]
//team: [ [ heroName, lv, start ], ]
function SetHeroInfo(info, team) 
{
	g_HeroTitle.text = info[0];
    g_HeroHeadIcon.IconData = info[1];
    _root.HeroInfo.headIcon.levelText.level_num.htmlText = info[4];
    if (g_HeroHeadIcon.UpdateIcon) { g_HeroHeadIcon.UpdateIcon(); }

	// g_HeroHeadIcon.icons.gotoAndStop("hero_" + info[1]);
	g_HeroCombatPower.text = info[2];
	// set_rank_num(g_HeroRank, info[3], true, 5);
	set_rank_num_center(g_HeroRank, info[3]);
	// g_HeroRank.gotoAndStop(info[3]);

	for(var i = 0; i < g_Heros.length; ++i)
	{
		if(i < team.length)
		{
			// g_Heros[i].hero_icons.gotoAndStop(2);
			var t = team[i];
			var clip = _root.GetHeroTeamInfo(i);
			clip._visible = true;
			clip.hero_icons.IconData = t[0];
   			if (clip.hero_icons.UpdateIcon) { clip.hero_icons.UpdateIcon(); }
   			clip.level_info._visible = true;
   			clip.level_info.level_text.text = t[1];
   			clip.star_plane._visible = true;
   			for(var j = 1; j <= 5; ++j)
			{
				clip.star_plane["star_" + j]._visible = (j <= t[2]);
			}
		}
		else
		{
			// g_Heros[i].hero_icons.gotoAndStop(1);
			var clip = _root.GetHeroTeamInfo(i);
			clip._visible = false;
			clip.hero_icons.gotoAndStop(1);
   			clip.level_info._visible = false;
   			clip.star_plane._visible = false;
		}
	}
}

//infos: [ [ heroTitle(localized), heroName, combat(formated), rank, lv(formated) ], ]
function SetEnemyInfo(infos)
{
	for(var i = 0; i < g_EnemyInfos.length; ++i)
	{
		var clip = _root.GetEnemyTeamInfo(i);
		if(i >= infos.length)
		{
			g_EnemyInfos[i]._visible = false;
			continue;
		}
		g_EnemyInfos[i]._visible = true;
		
		var info = infos[i];

		clip.infoBar.txtTitle.text = info[0];
		// clip.headIcon.icons.gotoAndStop("hero_" + info[1]);
		clip.iconBar.hero_icons.IconData = info[1];
   		if (clip.iconBar.hero_icons.UpdateIcon) { clip.iconBar.hero_icons.UpdateIcon(); }
   		clip.combatBar.txt_CombatNum.html = true;
		clip.combatBar.txt_CombatNum.htmlText = info[2];
		// clip.rank.gotoAndStop(info[3]);
		clip.rank.gotoAndStop(1);
		// set_rank_num(clip.rank.rank, info[3], i % 2 == 0, 5);
		var rankNum = info[3];
		if(rankNum >= 100000)
		{
			clip.rankBar.gotoAndStop(2);
			clip.rankBar.txt_Rank.text = rankNum;
		}
		else
		{
			clip.rankBar.gotoAndStop(1);
			set_rank_num_center(clip.rankBar.rank, rankNum);
		}
        clip.iconBar.levelText.level_num.htmlText = info[4];
	}
}


g_HeroInfo.OnSwitchOver = function()
{
	_root.InitButtonFunctions();
	g_isSwitchHeroState = false;
}

g_EnemyInfo.OnMoveInOver = function()
{
}

g_EnemyInfo.OnMoveOutOver = function()
{
}

function InitButtonFunctions()
{
	g_EnergyBtn.onRelease = function()
	{
		trace("Energy Clicked");
	}

	g_DefendBtn.onRelease = function()
	{
		if(g_swtichState == 2 and (not g_isSwitchHeroState) and _root.move_out_target == "")
		{
			_root.move_out_target = "Defend";
			_root.move_out_enemy();
			_root.move_out();
			fscommand("PlayMenuConfirm");
		}
	}

	g_BackBtn.onRelease = function()
	{
		// trace("Back Clicked");
		// fscommand("GotoNextMenu", LuaSA_MenuType.GS_MainMenu);
		// fscommand("GotoNextMenu", "Back");
		if(_root.move_out_target == "")
		{
			_root.move_out_target = "Back";
			_root.move_out_enemy();
			_root.move_out();
			// fscommand("PlayMenuBack");
			fscommand("PlaySound", "sfx_ui_cancel");
		}
	}

	g_ExchangeBtn.onRelease = function()
	{
		// trace("Exchange Clicked");
		if(_root.move_out_target == "")
		{
			_root.move_out_target = "ArenaShop";
			_root.move_out_enemy();
			_root.move_out();
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_selection_1");
		}
	}

	g_RankBtn.onRelease = function()
	{
		// trace("Rank Clicked");
		if(_root.move_out_target == "")
		{
			_root.move_out_target = "ArenaRanking";
			_root.move_out_enemy();
			_root.move_out();
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_selection_1");
		}
	}

	g_HistoryBtn.onRelease = function()
	{
		// trace("History Clicked");
		if(_root.move_out_target == "")
		{
			_root.move_out_target = "ArenaHistory";
			_root.move_out_enemy();
			_root.move_out();
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_selection_1");
		}
	}

	g_RuleBtn.onRelease = function()
	{
		// trace("History Clicked");
		if(_root.move_out_target == "")
		{
			_root.move_out_target = "ArenaRule";
			_root.move_out_enemy();
			_root.move_out();
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_selection_1");
		}
	}

	g_ArrowBtn.onRelease = function()
	{
		_root.switch_hero_state();
		fscommand("PlayMenuConfirm");
	}
}

function ClearButtonFunctions()
{
	g_EnergyBtn.onRelease = undefined;
	g_DefendBtn.onRelease = undefined;
	g_BackBtn.onRelease = undefined;
	g_ExchangeBtn.onRelease = undefined;
	g_RankBtn.onRelease = undefined;
	g_HistoryBtn.onRelease = undefined;
	g_RuleBtn.onRelease = undefined;
	g_ArrowBtn.onRelease = undefined;
}

function MoveOutTo(where)
{
	if(_root.move_out_target == "")
	{
		_root.move_out_target = where;
		_root.move_out_enemy();
		_root.move_out();
	}
}


function FTEClickBattle()
{
	g_EnemyInfos[0].btn_attack.onRelease()
}


function FTEPlayAnim(sname)
{
	_root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
	_root.fteanim.btn_tl._visible = false
}

FTEHideAnim()
