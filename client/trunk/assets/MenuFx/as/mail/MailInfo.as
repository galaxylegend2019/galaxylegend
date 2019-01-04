_root._visible = false;
var MailContent = undefined;
_root.top.btn_close.onRelease = function()
{
     SetPlay(_root.mail_content,false)
}

_root.mail_content.bg_shield.onRelease = function()
{

}

function ShowMailContent(datas,CurMailType)
{
    trace("show -------------------MailContent")
    _root._visible = true;
    _root.mail_content.gotoAndPlay("opening_ani")
    _root.top.gotoAndPlay("opening_ani")
    _root.bg1.gotoAndPlay("opening_ani")
    SetPlay(_root.mail_content,true)
    _root.mail_content.content_title.receive_name.text=datas.fromName
    _root.mail_content.content_title.mail_theme.text=datas.mailName
    _root.mail_content.content_title.mail_time_txt.text = datas.mailDate + " " + datas.mailTime;

    MailContent = datas

    //
    _root.mail_content.btn_reply._visible=!MailContent.isAttach

    //_root.mail_content.btn_keep._visible=CurMailType=="UserMail"

    _root.mail_content.btn_delete.onRelease=function()
    {
        fscommand("MailCommand","Delete")
        SetPlay(_root.mail_content,false)
    }

    _root.mail_content.btn_keep._visible=CurMailType!="archive"
    _root.mail_content.btn_keep.onRelease=function()
    {
        fscommand("MailCommand","Favorite")
        SetPlay(_root.mail_content,false)
    }

    if (MailContent.isAttach and MailContent.isGet == 0)
    {
        _root.mail_content.btn_get._visible = true;
        _root.mail_content.btn_reply._visible = false;
        _root.mail_content.btn_get.onRelease=function()
        {
            fscommand("MailCommand","GetAction")
            SetPlay(_root.mail_content,false)
        }
    }else
    {
        _root.mail_content.btn_get._visible = false;
        _root.mail_content.btn_reply._visible=MailContent.type=="user" or MailContent.type=="userarchive"
        _root.mail_content.btn_reply.onRelease=function()
        {
            fscommand("MailCommand","Reply")
            SetPlay(_root.mail_content,false)
        }
    }
    InitMailText()
}

function InitMailText()
{
    var MaxLine=820

    var listView=_root.mail_content.content_main.content_list

    listView.setSpecialItemHeight("mail_attach_board",0)
    listView.clearListBox();
    listView.initListBox("mail_content_all",0,true,true);
    listView.enableDrag( true );
    listView.onEnterFrame = function(){
        this.OnUpdate();
    }

    listView.onItemEnter = function(mc,index_item){

        if(index_item==1)
        {
            mc.ui_text.tt.html = true
            mc.ui_text.tt.htmlText=MailContent.body
            mc.ui_text.bg._height=mc.ui_text.tt.textHeight

            mc.ui_text._visible=true
            mc.ui_item._visible=false
            mc.ItemHeight=mc.ui_text.bg._height//listView._getItemHeight(mc.ui_text)

            //var myformat = mc.tt.getTextFormat()
            //trace(myformat.size)
            mc.onRelease=function(){
                this._parent.onReleasedInListbox();
                if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10){
                    //MailTitleSelect(this._parent);
                }
            }

            mc.onReleaseOutside = function(){
                this._parent.onReleasedInListbox();
            }
            mc.onPress =function(){
                this._parent.onPressedInListbox();
                this.Press_x = _root._xmouse;
                this.Press_y = _root._ymouse;
            }
        }else
        {
            mc.ui_text._visible=false
            mc.ui_item._visible=true

            mc.ItemHeight=listView._getItemHeight(mc.ui_item)
            for(var i=0;i<6;i++)
            {
                var item=mc.ui_item["item"+(i+1)]
                var datas=MailContent["item"][i]
                SetActionIcons(item,datas)
            }
        }

    }
    var count=1
    if(MailContent.isAttach==true)
    {
        count=2
    }
    for( var i=1; i <=count; i++ )
    {
        listView.addListItem(i, false, false);
    }
}

function SetActionIcons(mc,datas)
{
    var item=mc
    if(datas==undefined)
    {
        item._visible=false
        return
    }
    item._visible=true
    if(item.item.icons==undefined)
    {
        item.item.loadMovie("CommonIcons.swf")
    }
    item.item._width=65
    item.item._height=65
    item.item.IconData=datas.IconData
    item.num_text.text=datas.count
    if(item.item.UpdateIcon)
    {
        item.item.UpdateIcon()
    }
}



function SetPlay(mc,flag)
{
    if(flag==true)
    {
        _root._visible = true
        mc._visible=true
        mc.gotoAndPlay("opening_ani")
         _root.top.gotoAndPlay("opening_ani")
         _root.bg1.gotoAndPlay("opening_ani")
    }else
    {
        if(mc._visible==false)
        {
            return
        }
        mc.gotoAndPlay("closing_ani")
         _root.top.gotoAndPlay("closing_ani")
         _root.bg1.gotoAndPlay("closing_ani")
        mc.OnMoveOutOver=function()
        {
            this._visible=false
            _root._visible = false
        }
    }
}

function SetMoneyData(datas)
{
    _root.top.money.money_text.text = datas.money;
    _root.top.credit.credit_text.text = datas.credit;
}

function SetPointData(point)
{
    var energyBtn = _root.top.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}