var MainUI 		= _root.main.pop_content;

var CloseBtn 	= MainUI.btn_close;

var RankAwardList 	= MainUI.board.viewlist;
var AwardSlideItem 		= RankAwardList.slideItem;

var TotalHeight 	= 0;

_root.onLoad = function()
{
	//InitRankAwardList();
}

MainUI.bg_btn.onRelease = CloseBtn.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
	MainUI.bg_btn.gotoAndPlay("closing_ani");
}


MainUI.OnMoveOutOver = function()
{
	fscommand("GoToNext","CloseRankAward");
}


function AddRankAwardTitleItem(title)
{
	var rank_small_title = AwardSlideItem.attachMovie("rankrewards_list_1", "rank_small_title", AwardSlideItem.getNextHighestDepth());
	/*********TODO:SetValue********/
	rank_small_title.title_txt.html = true;
	rank_small_title.title_txt.htmlText = title;

	rank_small_title._y = TotalHeight;
	TotalHeight = TotalHeight + rank_small_title._height;
	//AllAwardMc.push(rank_small_title);
}

function SetAwardIcon(mc, icon_data)
{
	if (mc.item_icon.icons == undefined)
	{
		var w = mc.item_icon._width;
		var h = mc.item_icon._height;
		mc.item_icon.loadMovie("CommonIcons.swf");
		mc.item_icon._width = w;
		mc.item_icon._height = h;
	}
	mc.item_icon.IconData = icon_data;
	if(mc.item_icon.UpdateIcon)
	{ 
		mc.item_icon.UpdateIcon(); 
	}
}

function AddRankAwardItem(award)
{
	var award_item = AwardSlideItem.attachMovie("rankrewards_list_2", "award_item", AwardSlideItem.getNextHighestDepth());
	/*********TODO:SetValue********/
/*	var IconDatas = new Object();
	IconDatas.icon_index = 106;
	IconDatas.res_type = "item";
	IconDatas.icon_quality = 1;*/
	
	SetAwardIcon(award_item.award, award.icon_data)
	award_item.name_txt.text = award.name;
	award_item.count_txt.text = "X" + award.num;

	award_item._y = TotalHeight;
	TotalHeight = TotalHeight + award_item._height;
	//AllAwardMc.push(award_item);
}

function AddAwardLineItem()
{
	var line = AwardSlideItem.attachMovie("drag_list_line", "line", AwardSlideItem.getNextHighestDepth());

	line._y = TotalHeight;
	TotalHeight = TotalHeight + line._height;
}

function InitRankAwardList(datas)
{
	TotalHeight = 0;
	for (var i = 0; i < datas.length; ++i)
	{
		var award = datas[i];
		AddRankAwardTitleItem(award.title);
		for (var j = 0; j < award.data.length; ++j)
		{
			AddRankAwardItem(award.data[j]);
			if (j == award.data.length - 1)
			{
				break;
			}
			AddAwardLineItem();
		}
		
	}
	


	RankAwardList.SimpleSlideOnLoad();

	RankAwardList.onEnterFrame = function()
	{
		RankAwardList.OnUpdate();
	}
}


