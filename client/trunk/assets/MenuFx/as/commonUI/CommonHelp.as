
var MainUI 		= _root.main.pop_content;
var CloseBtn 	= MainUI.btn_close;
var TitleText 	= MainUI.panel_title.title_txt;
var ContentList = MainUI.content;
var ContentItem = ContentList.slideItem;
_root.onLoad = function()
{
	MainUI.gotoAndPlay("opening_ani");
	MainUI.panel_bg.gotoAndPlay("opening_ani");
}

MainUI.OnMoveOutOver = function()
{
	fscommand("AllianceMainCmd", "CloseHelpInfo");
}

CloseBtn.onRelease = function()
{
	MainUI.gotoAndPlay("closing_ani");
	MainUI.panel_bg.gotoAndPlay("closing_ani");
}
//datas.title
//datas.content
function SetContent(datas)
{
	TitleText.text = datas.title;

	var CurContent = ContentItem.attachMovie("help_text_board", "content", ContentItem.getNextHighestDepth());
	CurContent.content_txt.html =true;
	CurContent.content_txt.htmlText = datas.content;
	CurContent._y = 0;
	var endLine = ContentItem.attachMovie("help_text_board", "content", ContentItem.getNextHighestDepth());
	endLine.content_txt.text = "";
	endLine._y = CurContent.content_txt.textHeight;

	ContentList.SimpleSlideOnLoad();

	ContentList.onEnterFrame = function()
	{
		ContentList.OnUpdate();
	}
}