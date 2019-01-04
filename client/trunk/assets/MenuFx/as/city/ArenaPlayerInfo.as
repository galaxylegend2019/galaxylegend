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

var g_InfoBar = _root.info_bar;
var move_out_target = "";

var g_InitPosX = g_InfoBar._x;
var g_InitPosY = g_InfoBar._y;
var g_InitWidth = g_InfoBar._width;
var g_InitHeight = g_InfoBar._height;

//cs functions
this.onLoad = function(){
	init();

	// move_in();
}

function init()
{
	set_top_invisible();
}

function set_top_invisible()
{
	g_InfoBar._visible = false;
	_root.btn_bg._visible = false;
}

function move_in()
{
	g_InfoBar._visible = true;
	g_InfoBar.gotoAndPlay("open_member");
	g_InfoBar.OnMoveInOver = function()
	{
		g_InfoBar.is_moved_in = true;
	}

	g_InfoBar.player_icon.gotoAndPlay("opening_ani");
	_root.btn_bg._visible = true;
}

function move_out()
{
	g_InfoBar.is_moved_in = false;
	g_InfoBar.gotoAndPlay("close_member");
	g_InfoBar.OnMoveOutOver = function()
	{
		set_top_invisible();
	}

	g_InfoBar.player_icon.gotoAndPlay("closing_ani");
}

_root.btn_bg.onRelease = function()
{
	if(g_InfoBar.is_moved_in)
	{
		move_out();
		fscommand("PlayMenuBack");
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

function SetInfoPos(posx, posy)
{
    if (posx - g_InitWidth < 0)
    {
        g_InfoBar._x = posx
    }
    else
    {
        g_InfoBar._x = posx - g_InitWidth
    }
    g_InfoBar._y = posy - g_InitHeight * 0.5
    // g_InfoBar._x = (posx != -1) ? (posx - g_InitWidth * 1) : g_InitPosX;
    // g_InfoBar._y = (posy != -1) ? (posy - g_InitHeight * 1 - 30) : g_InitPosY;
}

function SetPlayerInfo(info)
{
	var clip = g_InfoBar;
	if(clip.player_icon.hero_icons.icons == undefined)
	{
		clip.player_icon.hero_icons.loadMovie("CommonPlayerIcons.swf");
	}

	clip.player_icon.hero_icons.IconData = info.playerIconInfo;
    if (clip.player_icon.hero_icons.UpdateIcon) { clip.player_icon.hero_icons.UpdateIcon(); }

	clip.title_bar.txt_LevelTitle.text = info.levelTitleTxt;
	clip.title_bar.txt_Level.text = info.levelTxt;
	clip.title_bar.txt_Name.text = info.nameTxt;
	clip.title_bar.txt_LevelTitle._x = clip.title_bar.txt_Name._x + clip.title_bar.txt_Name.textWidth + 12;
	clip.title_bar.txt_Level._x = clip.title_bar.txt_LevelTitle._x + clip.title_bar.txt_LevelTitle.textWidth + 6;
	clip.title_bar.txt_Union.text = info.unionTxt;

	// set_rank_num(clip.rank_bar.rank, info.rank, true, 5);
	set_rank_num_center(clip.rank_bar.rank, info.rank);

	clip.win_bar.txt_WinNum.text = info.winNumTxt;
	clip.combat_bar.txt_Combat.text = info.combatTxt;

	for(var i = 0; i < 6; ++i)
	{
		var memberIcon = clip['iconBar_' + (6 - 1 - i)];
		if(i < info.enemy.length)
		{
			var enemyInfo = info.enemy[i];
			memberIcon.hero_icons._visible = true;
			if(emberIcon.hero_icons.icons == undefined)
			{
				memberIcon.hero_icons.loadMovie("CommonHeros.swf");
			}
			memberIcon.hero_icons.IconData = enemyInfo.heroIconInfo;
   			if (memberIcon.hero_icons.UpdateIcon) { memberIcon.hero_icons.UpdateIcon(); }
			
			memberIcon.level_info._visible = true;
			memberIcon.star_plane._visible = true;
			memberIcon.level_info.level_text.text = enemyInfo.levelTxt;
			memberIcon.level_info.level_text._x = memberIcon.level_info.LC_UI_Collection_Lv._x + memberIcon.level_info.LC_UI_Collection_Lv.textWidth + 5
			var starRank = enemyInfo.star;
			for(var k = 0; k < 5; ++k)
			{
				var starClip = memberIcon.star_plane['star_' + (k + 1)]
				if(k < starRank)
				{
					starClip._visible = true;
				}
				else
				{
					starClip._visible = false;
				}
			}
		}
		else
		{
			memberIcon.level_info._visible = false;
			memberIcon.star_plane._visible = false;
			// memberIcon.hero_icons._visible = false;
			memberIcon.hero_icons._visible = true;
			if(emberIcon.hero_icons.icons == undefined)
			{
				memberIcon.hero_icons.loadMovie("CommonHeros.swf");
			}
			memberIcon.hero_icons.IconData = undefined;
   			if (memberIcon.hero_icons.UpdateIcon) { memberIcon.hero_icons.UpdateIcon(); }
		}
	}

}

