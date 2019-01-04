import com.tap4fun.utils.Utils;
import common.Lua.LuaSA_MCPlayType;

var g_screenW = _root._width;
var g_screenH = _root._height;

var g_curPopName = "";
var g_allPopups = new Object();

var g_RankInfos = [];

trace("g_screenW: " + g_screenW + " g_screenH: " + g_screenH);

this.onLoad = function(){
	init();
}

function init()
{
	g_allPopups.pop_ranking = _root.pop_ranking;
	g_allPopups.pop_rule = _root.pop_rule;
	g_allPopups.pop_fleets = _root.pop_fleets;
	g_allPopups.pop_fleetlist = _root.pop_fleetlist;

	for(var popName in g_allPopups)
	{
		g_allPopups[popName].popName = popName;
		g_allPopups[popName]._visible = false;
	}

	// ShowPopDetail("pop_ranking");
}

function ShowPopDetail(popName, info)
{
	if(g_curPopName != "" && g_curPopName != popName)
	{
		ClosePopDetail();
	}

	g_curPopName = popName;
	var mc = g_allPopups[popName];
	trace(popName + "  " + mc)
	if(mc)
	{
		mc._visible = true;
		mc.gotoAndPlay("opening_ani");
		mc.btn_shield.onRelease = function(){}
		mc.btn_bg.onRelease = function()
		{
			ClosePopDetail();
			this.onRelease = undefined;
		}

		var initFunc = _root["InitFunc_" + popName];
		initFunc(mc, info);
	}
}

function ClosePopDetail()
{
	if(g_curPopName != "")
	{
		var popName = g_curPopName;
		g_curPopName = "";
		var mc = g_allPopups[popName];
		mc.OnMoveOutOver = function()
		{
			this._visible = false;
		}
		mc.gotoAndPlay("closing_ani");
		fscommand("WorldMapCmd", "OnPopupDetailClosed" + "\2" + popName);
	}
}

function DoSetRankInfo(mc, rankInfo)
{
	mc.txt_rank.text = rankInfo.rankTxt;
	mc.txt_name.text = rankInfo.nameTxt;
	mc.txt_value.text = rankInfo.valueTxt;

	// if(mc.icon_bar.item_icon.icons == undefined)
	// {
	// 	var w = mc.icon_bar.item_icon._width;
	// 	var h = mc.icon_bar.item_icon._height;
	// 	mc.icon_bar.item_icon.loadMovie("CommonIcons.swf");
	// 	mc.icon_bar.item_icon._width = w;
	// 	mc.icon_bar.item_icon._height = h;
	// }

	// mc.icon_bar.item_icon.IconData = rankInfo.iconData;
	// if (mc.icon_bar.item_icon.UpdateIcon) { mc.icon_bar.item_icon.UpdateIcon(); }
}

function SetRankInfos(infos)
{
	var viewList = g_allPopups.pop_ranking.list_area.viewList;
	var curRankInfos = viewList.rankInfos;
	var addFrontCount = 0;
	var addTailCount = 0;
	for(var idx = 0; idx < infos.length; ++idx)
	{
		var info = infos[idx];
		var added = false;
		for(var i = 0; i < curRankInfos.length; ++i)
		{
			var rank = curRankInfos[i].rank;
			if(rank == info.rank)
			{
				curRankInfos[i] = info;
				added = true;
				break;
			}
			else if(rank > info.rank)
			{
				curRankInfos.splice(i, 0, info);
				added = true;
				++addFrontCount;
				break;
			}
		}
		if(!added)
		{
			curRankInfos.push(info);
			++addTailCount;
		}
	}

	var minRank = curRankInfos[0].rank;
	var maxRank = curRankInfos[0].rank;
	for(var i = 1; i < curRankInfos.length; ++i)
	{
		var rank = curRankInfos[i].rank;
		if(rank < minRank)
		{
			minRank = rank;
		}
		else if(rank > maxRank)
		{
			maxRank = rank;
		}
	}

	var needCount = maxRank - minRank + 1;
	var curCount = viewList.getItemListLength();
	if(curCount == 0)
	{
		for(var i = 0; i < needCount; ++i)
		{
			viewList.addListItem(i + minRank, false, false);
		}
	}
	else if(needCount > curCount) //delete no supported
	{
		for(var i = addFrontCount; i > 0; --i)
		{
			viewList.addListItem(minRank + i - 1, true, false)
		}
		for(var i = addTailCount; i > 0; --i)
		{
			viewList.addListItem(maxRank - i + 1, false, false)
		}
	}
	viewList.minRank = minRank;
	viewList.maxRank = maxRank;
	viewList.minPage = Math.ceil(minRank / viewList.rankItemPerPage);
	viewList.maxPage = Math.ceil(maxRank / viewList.rankItemPerPage);

	viewList.hasPrevPage = viewList.minPage >= 2;
	viewList.hasNextPage = (maxRank % viewList.rankItemPerPage) == 0;

	viewList.needUpdateVisibleItem();
}

function InitFunc_pop_ranking(mc, info)
{
	// mc.head_bar.txt_value.text = info.headValueTxt;
	DoSetRankInfo(mc.my_rank_bar, info.myRankInfo);

	var viewList = mc.list_area.viewList;
	viewList.clearListBox();
	viewList.initListBox("RankListBar", 6, true, true);
	viewList.enableDrag(true);
	viewList.rankItemPerPage = info.itemPerPage;
	viewList.rankInfos = [];
	viewList.minRank = undefined;
	viewList.maxRank = undefined;
	viewList.minPage = undefined;
	viewList.maxPage = undefined;
	viewList.hasPrevPage = undefined;
	viewList.hasNextPage = undefined
	viewList.needUpdatePrevPage = undefined;
	viewList.needUpdateNextPage = undefined;

	viewList.onEnterFrame = function()
	{
		this.OnUpdate();

		if(this.needUpdatePrevPage)
		{
			this.needUpdatePrevPage = undefined;
			fscommand("WorldMapCmd", "OnRequestRankPage" + "\2" + (this.minPage - 1));
		}
		else if(this.needUpdateNextPage)
		{
			this.needUpdateNextPage = undefined;
			fscommand("WorldMapCmd", "OnRequestRankPage" + "\2" + (this.maxPage + 1));
		}
	}

	viewList.onItemEnter = function(mc, itemKey)
	{
		DoSetRankInfo(mc, this.rankInfos[itemKey - this.minRank]);
		if(this.hasPrevPage && itemKey - this.minRank < 5)
		{
			this.needUpdatePrevPage = true;
		}
		else if(this.hasNextPage && this.maxRank - itemKey < 5)
		{
			this.needUpdateNextPage = true;
		}
	}

	viewList.forceCorrectPosition();
}

function InitFunc_pop_rule(mc, info)
{
	var txts = info.descTxts;

	var ViewList = mc.desc.ViewList;
	var item = ViewList.slideItem;
	var item2 = ViewList.slideItem2;
	var totalHeight = 0;
	var kDist = 5;

	for(var mc in item2)
	{
		item2[mc].removeMovieClip();
	}

	// trace(item._height + "  " + item._yscale);
	for(var i = 0; i < txts.length; ++i)
	{
		var txt = txts[i];
		var txtItem = item2.attachMovie("Rule_info_txt", "txt_" + i, item2.getNextHighestDepth());
		txtItem.txt_Text.htmlText = txt;
		//trace(txtItem.txt_Text.text)
		txtItem._y = totalHeight;
		// totalHeight += (txtItem.txt_Text.textHeight + kDist);
		totalHeight += (txtItem.txt_Text.textHeight);
		// trace(i + " aa " + txtItem.textHeight + "   " + txtItem._yscale);
		// txtItem._yscale = 100;
		// trace(i + " bb " + txtItem.textHeight + "   " + txtItem._yscale);

		// var lineItem = item.attachMovie("arena_rule_board_1", "line_" + i, item.getNextHighestDepth());
		// lineItem._y = totalHeight;
		// totalHeight += lineItem._height;
		// txtItem._yscale = 100;

		// totalHeight += kDist;
		// txtItem._yscale = 100;
	}

	item._height = totalHeight;

	ViewList.SimpleSlideOnLoad();
	// ViewList.SetIsAutoInertiaBack(false);
	ViewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ViewList.forceCorrectPosition();
}

function InitFunc_pop_fleets(mc, info)
{
	mc.remaining_bar.txt_remain.text = info.remainTxt;
	for(var i = 0; i < 5; ++i)
	{
		var barMc = mc["Bar" + (i + 1)];
		if(i < info.fleets.length)
		{
			var fleet = info.fleets[i];
			barMc._visible = true;
			barMc.player_self._visible = false;
			barMc.player_other._visible = false;
			var player = fleet.isSelf ? barMc.player_self : barMc.player_other;
			player._visible = true;
			player.txt_name.text = fleet.nameTxt;
			player.txt_status.text = fleet.statusTxt;
		}
		else
		{
			barMc._visible = false;
		}
	}
}

function InitFunc_pop_fleetlist(mc, info)
{
	mc.tital_bar.txt_title.text = info.titleTxt;
	mc.remaining_bar.txt_remain.htmlText = info.remainTxt;

	var viewList = mc.list_area.ViewList;
	viewList.fleets = info.fleets;
	viewList.clearListBox();
	viewList.initListBox("SainInBar", 6, true, true);
	viewList.enableDrag(true);
	viewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	viewList.onItemEnter = function(barMc, itemKey)
	{
		var fleet = barMc._parent.fleets[itemKey];
		barMc._visible = true;
		barMc.player_self._visible = false;
		barMc.player_other._visible = false;
		var player = fleet.isSelf ? barMc.player_self : barMc.player_other;
		player._visible = true;
		player.txt_name.text = fleet.nameTxt;
		player.txt_status.text = fleet.statusTxt;
	}

	for(var i = 0; i < info.fleets.length; ++i)
	{
		viewList.addListItem(i, false, false);
	}
	viewList.forceCorrectPosition();
}