

var g_announceRoot = _root.pop_content;

this.onLoad = function(){
	init();
}

function init(){
	// _root._visible = false;
	g_announceRoot._visible = false;
	
	g_announceRoot.download._visible = false; //not use
	g_announceRoot.timeless._visible = false; //not use


	// ShowAnnounce("Amid a flurry of social media excitement, Niantic Labs, the software company behind the game, announced it was in Japan.First released in the US, Australia and New Zealand on 6 July and now available in more than 30 countries, the game has been a global phenomenon.The Japanese launch comes with a McDonalds sponsorship deal.The Japanese launch comes with a McDonalds sponsorship deal.Fast food restaurants were expected to be advertised as places where people were guaranteed to find Pokemon, or as  where players can train up their captured monsters for virtual fights.Amid a flurry of social media excitement, Niantic Labs, the software company behind the game, announced it was in Japan.First released in the US, Australia and New Zealand on 6 July and now available in more than 30 countries, the game has been a global phenomenon.The Japanese launch comes with a McDonalds sponsorship deal.The Japanese launch comes with a McDonalds sponsorship deal.Fast food restaurants were expected to be advertised as places where people were guaranteed to find Pokemon, or as  where players can train up their captured monsters for virtual fights");
}


function ShowAnnounce(contentTxt)
{
	// _root._visible = true;
	g_announceRoot._visible = true;

	g_announceRoot.download._visible = false; //not use
	g_announceRoot.timeless._visible = false; //not use

	g_announceRoot.content_bar.txt_content.text = contentTxt;
	
	g_announceRoot.btn_bg._visible = true;
	g_announceRoot.btn_bg.onRelease = function(){}
	

	g_announceRoot.btn_shield.onRelease = function(){}
	g_announceRoot.gotoAndPlay("opening_ani");
	g_announceRoot.OnMoveInOver = function()
	{
		this.is_moved_in = true;
		g_announceRoot.btn_bg.onRelease = function()
		{
			HideAnnounce();
		}
	}

	SetText(g_announceRoot.content_txt, contentTxt);


	g_announceRoot.btn_facebook.onRelease = function()
	{
		fscommand("OnContactCmd", "facebook");
	}
	g_announceRoot.btn_forum.onRelease = function()
	{
		fscommand("OnContactCmd", "forum");
	}
	g_announceRoot.btn_contact_us.onRelease = function()
	{
		fscommand("OnContactCmd", "contact");
	}
}

function HideAnnounce()
{
	g_announceRoot.is_moved_in = false;
	g_announceRoot.gotoAndPlay("closing_ani");
	g_announceRoot.OnMoveOutOver = function()
	{
		this.btn_bg.onRelease = undefined;
		this.btn_bg._visible = false;
		this._visible = false;
		// _root._visible = false;
	}
}

function SetText(mc, contentTxt)
{
	var ViewList = mc.desc.ViewList;
	var item = ViewList.slideItem;
	var item2 = ViewList.slideItem2;
	var totalHeight = 0;
	var kDist = 5;

	for(var mc in item2)
	{
		item2[mc].removeMovieClip();
	}

	var txtItem = item2.attachMovie("content_txt", "txt_" + 0, item2.getNextHighestDepth());
	// trace("txtItem: " + txtItem);
	txtItem.txt_content.htmlText = contentTxt;
	// trace("txtItem height: " + txtItem._height + "  textheight: " + txtItem.txt_content.textHeight);
	txtItem._y = totalHeight;
	totalHeight += (txtItem.txt_content.textHeight);
	// trace("txtItem height: " + txtItem._height + "  textheight: " + txtItem.txt_content.textHeight);

	item._height = totalHeight;

	ViewList.SimpleSlideOnLoad();
	ViewList.onEnterFrame = function()
	{
		this.OnUpdate();
	}
	ViewList.forceCorrectPosition();
}

