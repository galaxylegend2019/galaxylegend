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

//rank pop
var g_rankPop = _root.rank_pop;
var g_isShowRankPop = false;
var g_needShowRank = false;
var g_oldRank = 0;
var g_newRank = 0;
var g_rankAdded = 0;
var g_earned = 0;

//win pop
var g_winPop = _root.win_ui;
var g_quitBtn = g_winPop.btn_exit;

//BG
var g_BG = _root.bg2;

//cs functions
this.onLoad = function(){
	init();

	// SetTeamInfo(true, 180, 25, "Hugggg", [[80, 3, "Crius"], [[75, 1, "Zero"]]]);
	// SetTeamInfo(false, 90, 24, "guhhh", [[60, 4, "Crius"], [[73, 5, "Zero"]]]);
	// move_in(true, 600, 780, 1683, 12345);
}

function init()
{
	g_rankPop._visible = false;
	g_winPop._visible = false;
	g_BG._visible = false;
}

function move_in(needShowRank : Boolean, oldRank, newRank, rankAdded, earned)
{
	g_winPop._visible = true;
	g_BG._visible = true;

	g_needShowRank = needShowRank;
	if(g_needShowRank)
	{
		g_oldRank = oldRank;
		g_newRank = newRank;
		g_rankAdded = rankAdded;
		g_earned = earned;
	}

	g_winPop.gotoAndPlay("opening_ani");
	g_winPop.OnMoveInOver = function()
	{
		if(g_needShowRank)
		{
			g_needShowRank = false;
			ShowRankPop(g_oldRank, g_newRank, g_rankAdded, g_earned);
		}
		if(not g_isShowRankPop)
		{
			SetQuitBtnFunction(true);
		}
	}

	g_BG.gotoAndPlay("opening_ani")
}

function move_out()
{
	g_winPop.gotoAndPlay("closing_ani");
	SetQuitBtnFunction(false);
	g_winPop.OnMoveOutOver = function()
	{
		g_winPop._visible = false;
		g_BG._visible = false;
		// trace("ExitBack");
		fscommand("ExitBack", "");
	}

	g_BG.gotoAndPlay("closing_ani");
}

function SetQuitBtnFunction(enable : Boolean)
{
	if(enable)
	{
		g_quitBtn.onRelease = function()
		{
			move_out();
			fscommand("PlayMenuBack");
		}
	}
	else
	{
		g_quitBtn.onRelease = undefined;
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


function ShowRankPop(oldRank, newRank, rankAdded, earned)
{
	g_isShowRankPop = true;
	g_rankPop._visible = true;

	g_rankPop.gotoAndPlay("opening_ani");
	g_rankPop.OnMoveInOver = function()
	{
		g_rankPop.onRelease = function()
		{
			HideRankPop();
			fscommand("PlayMenuBack");
		}		
	}

	// set_rank_num(g_rankPop.earned, earned, true, 5);
	g_rankPop.earned.txt_number.text = earned;
	set_rank_num(g_rankPop.highRank, newRank, true, 4);
	set_rank_num(g_rankPop.oldRank, oldRank, true, 4);
	g_rankPop.oldRank.txt_Added.text = '[    ' + rankAdded + ' ]';

	// g_rankPop.oldRank.txt_MarkL._visible = false;
	// g_rankPop.oldRank.txt_MarkR._visible = false;
	
	// g_rankPop.oldRank.txt_MarkL.text = '['
	// g_rankPop.oldRank.txt_MarkR.text = ']'
	// trace(g_rankPop.oldRank.txt_MarkL + "  " + g_rankPop.oldRank.txt_MarkL._x);
	// trace(g_rankPop.oldRank.txt_MarkR + "  " + g_rankPop.oldRank.txt_MarkR._x);
	// g_rankPop.oldRank.txt_MarkL._x = g_rankPop.oldRank.mark_arrow._x - 12;
	// g_rankPop.oldRank.txt_MarkR._x = g_rankPop.oldRank.txt_Added._x + g_rankPop.oldRank.txt_Added.textWidth + 12;
	// trace(g_rankPop.oldRank.txt_MarkL + "  " + g_rankPop.oldRank.txt_MarkL._x);
	// trace(g_rankPop.oldRank.txt_MarkR + "  " + g_rankPop.oldRank.txt_MarkR._x);
}

function HideRankPop()
{
	g_rankPop.gotoAndPlay("closing_ani");
	g_rankPop.bg.onRelease = undefined;
	g_rankPop.OnMoveOutOver = function()
	{
		g_isShowRankPop = false;
		SetQuitBtnFunction(true);
		g_rankPop._visible = false;
	}
}

function SetTeamInfo(isWinner, rankTxt, levelTxt, nameTxt, iconInfo, team)
{
	var postfix = isWinner ? "win" : "lose";
	g_winPop["rank_" + postfix].txt_Rank.text = rankTxt;
	var infoBar = g_winPop["info_" + postfix];
	infoBar.txt_Level.text = levelTxt;
	infoBar.txt_Name.text = nameTxt;
	var teamBar = g_winPop["team_" + postfix];
	for(var i = 0; i < 6; ++i)
	{
		var iconBar = teamBar["icon_" + i];
		if(i < team.length)
		{
			var memberInfo = team[i];
			var levelTxt = memberInfo[0];
			var star = memberInfo[1];
			var headIcon = memberInfo[2];
			iconBar.level_info._visible = true;
			iconBar.level_info.level_text.text = levelTxt;
			iconBar.star_plane._visible = true;
			for(var j = 1; j <= 5; ++j)
			{
				iconBar.star_plane["star_" + j]._visible = (j <= star);
			}
			if(iconBar.hero_icon.icons == undefined)
			{
				iconBar.hero_icon.loadMovie("CommonHeros.swf");
			}
			iconBar.hero_icon.IconData = headIcon;
   			if (iconBar.hero_icon.UpdateIcon) { iconBar.hero_icon.UpdateIcon(); }
		}
		else
		{
			iconBar.level_info._visible = false;
			iconBar.star_plane._visible = false;
			if(iconBar.hero_icon.icons == undefined)
			{
				iconBar.hero_icon.loadMovie("CommonHeros.swf");
			}
			iconBar.hero_icon.IconData = undefined;
   			if (iconBar.hero_icon.UpdateIcon) { iconBar.hero_icon.UpdateIcon(); }
		}
	}

    if(g_winPop["herobody_" + postfix].item.icons == undefined)
    {
        g_winPop["herobody_" + postfix].item.loadMovie("CommonHeros_body_up.swf");
    }
    g_winPop["herobody_" + postfix].item.icons.gotoAndStop(1);
    g_winPop["herobody_" + postfix].item.icons.gotoAndStop(iconInfo.icon_index);
}
