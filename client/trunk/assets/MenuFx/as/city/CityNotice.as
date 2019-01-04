
var MainUI = _root.Notice;
var StartTime = 0;
var NoticeData = new Array();
var CurIndex = 0;
this.onLoad = function()
{
	//Test();
	OpenUI();
	MainUI.NoticeBar.notice.content_txt._visible = false;
}

function Test()
{
	var data1 = "Welcome to GL2!";
	NoticeData.push(data1);
	var data2 = "Have a clearance sale!";
	NoticeData.push(data2);
	var data3 = "Brog invasion began!";
	NoticeData.push(data3);
}

function SetNoticeDatas( datas )
{
	NoticeData = datas;
	SetNotcieTxt();
	MainUI.NoticeBar.notice.content_txt._visible = true;
}

function OpenUI()
{
	MainUI.gotoAndPlay("opening_ani");
}

function CloseUI()
{
	MainUI.gotoAndPlay("closing_ani");
}

function SetNotcieTxt( )
{
	if (CurIndex >= NoticeData.length)
	{
		CurIndex = 0;
	}
	var content = NoticeData[CurIndex];
	CurIndex = CurIndex + 1;
	MainUI.NoticeBar.notice.content_txt.text = content;
	trace(MainUI.NoticeBar.notice.content_txt.text);
	MainUI.NoticeBar.gotoAndPlay("opening_ani");
}

function SetNoticeShow()
{

}

var IntervalTime = 6000;
_root.onEnterFrame = function()
{
	var curDate = new Date();
    var curMilliseconds = curDate.getTime();
    if (StartTime == 0)
    {
        StartTime = curMilliseconds;
    }
    var offset = curMilliseconds - StartTime;
    if (offset >= IntervalTime)
    {
    	
       SetNotcieTxt();
       StartTime = 0;

    }
}