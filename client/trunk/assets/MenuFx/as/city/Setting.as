var generalPanel = this.general_main
var pushPanel = this.push_main
var tabPanel = this.filter_contral
var topPanel = this.top_bar
var isOnPressMusic = false
var isOnPressSound = false
var curShowTabNumber = 1
var soundLenght = 164
var soundMax = 10
var soundNumber = 10
var lastXmouse = 0
var lastMusicNum = 0
var lastSoundNum = 0
var allData = new Object()

var languages_name = [
     "",
     "",
     "",
     "",
     "",
     "cn",
     ""
]

this.onLoad = function()
{
    this._visible = false;
    InitPerformancePanel();
    // InitLanguagePanel();
}

this.onEnterFrame = function()
{
    if (isOnPressMusic)
    {
        var disXmouse = _root._xmouse - lastXmouse + lastMusicNum / soundMax * soundLenght;
        if (disXmouse < 0)
        {

        }
        else if(disXmouse > soundLenght)
        {
            soundNumber = 10
        }
        else
        {
            soundNumber = Math.floor(disXmouse / soundLenght * soundMax + 0.5);
        }
        if (soundNumber != generalPanel.board_1.music_plane.num)
        {
            generalPanel.board_1.music_plane.num = soundNumber;
            generalPanel.board_1.music_plane.updateSoundNum()
        }

    }
    if (isOnPressSound)
    {
        var disXmouse = _root._xmouse - lastXmouse + lastSoundNum / soundMax * soundLenght;
        if (disXmouse < 0)
        {

        }
        else if(disXmouse > soundLenght)
        {
            soundNumber = 10
        }
        else
        {
            soundNumber = Math.floor(disXmouse / soundLenght * soundMax + 0.5);
        }
        if (soundNumber != generalPanel.board_1.sound_plane.num)
        {
            generalPanel.board_1.sound_plane.num = soundNumber;
            generalPanel.board_1.sound_plane.updateSoundNum()
        }
    }
}

function InitData(data)
{
    allData = data
    generalPanel.board_1.music_plane.num = data.musicNum;
    generalPanel.board_1.music_plane.num_txt.text = data.musicNum;
    var par = data.musicNum / soundMax * 100 + 1;
    generalPanel.board_1.music_plane.gotoAndStop(par);
    generalPanel.board_1.sound_plane.num = data.soundNum;
    generalPanel.board_1.sound_plane.num_txt.text = data.soundNum;
    var par2 = data.soundNum / soundMax * 100 + 1;
    generalPanel.board_1.sound_plane.gotoAndStop(par2)
    if (data.isBGMOn)
    {
        generalPanel.board_1.icon_1.gotoAndStop(1);
    }
    else
    {
        generalPanel.board_1.icon_1.gotoAndStop(2);
    }

    if (data.isSFXOn)
    {
        generalPanel.board_1.icon_2.gotoAndStop(1);
    }
    else
    {
        generalPanel.board_1.icon_2.gotoAndStop(2);
    }

    generalPanel.board_1.choose.select = data.autoTranslate;
    generalPanel.board_1.choose.onSelect();
    generalPanel.board_2.num = data.performance;
    generalPanel.board_2.onSelect();
    SetLanguagePanel();
}

function MoveIn()
{
    this._visible = true;
    topPanel.gotoAndPlay("opening_ani");
    tabPanel.gotoAndPlay("opening_ani");
    ContralTabel(curShowTabNumber)
}

function InitAllLayer()
{
    generalPanel._visible = false;
    pushPanel._visible = false;
    tabPanel.filter_button_3.gotoAndStop("Normal");
    tabPanel.filter_button_2.gotoAndStop("Normal");
}

function ContralTabel(id)
{
    InitAllLayer()
    if (id == 1)
    {
        generalPanel._visible = true;
        generalPanel.gotoAndPlay("opening_ani");
        tabPanel.filter_button_3.gotoAndStop("Selected");
    }
    else if (id == 2)
    {
        pushPanel._visible = true;
        pushPanel.gotoAndPlay("opening_ani");
        tabPanel.filter_button_2.gotoAndStop("Selected");
    }
    else
    {
        trace("---------------")
    }
}

function InitPerformancePanel()
{
    for(var i = 1; i < 4; i++)
    {
        var item = generalPanel.board_2["choose_" + i]
        item.id = i;
        item.onRelease = function()
        {
            // this._parent.num = this.id;
            // this._parent.onSelect();
            fscommand("OnSettingCmd","ShowMessage" + "\2" + 1)
            // fscommand("OnSettingCmd","updatePerformance" + "\2" + this.id)
        }
    }
}

function SetLanguagePanel()
{
    var listView = generalPanel.language.list.ViewList;
    var allLanguagesData = allData.allLanguages;
    listView.clearListBox();
    listView.initListBox("language_list_0",0,true,true)
    listView.enableDrag(true)
    listView.allLanguagesData = allLanguagesData
    listView.onEnterFrame = function()
    {
        this.OnUpdate();
    }
    listView.onItemEnter = function(mc,index)
    {
        var item1Index = index * 2
        var item2Index = index * 2 + 1
        mc.language_1.txt.text = this.allLanguagesData[item1Index].nameText;
        mc.language_1.gotoAndStop(1)
        mc.language_1.data = this.allLanguagesData[item1Index]
        mc.language_2._visible = false
        if (this.allLanguagesData[item2Index])
        {
            mc.language_2._visible = true;
            mc.language_2.gotoAndStop(1)
            mc.language_2.txt.text = this.allLanguagesData[item2Index].nameText;
            mc.language_2.data = this.allLanguagesData[item2Index]
        }

        if (allData.language == this.allLanguagesData[item1Index].name)
        {
            mc.language_1.gotoAndStop(2)
        }
        if (allData.language == this.allLanguagesData[item2Index].name)
        {
            mc.language_2.gotoAndStop(2)
        }
        mc.language_1.hitzone.onRelease = function()
        {
            this._parent._parent._parent.onReleasedInListbox();
            if(Math.abs(this.Prees_x - this._xmouse) < this._width / 2 && Math.abs(this.Prees_y - this._ymouse) < this._height / 2)
            {
                if(this._parent.data.name == "")
                {
                    fscommand("OnSettingCmd","ShowMessage" + "\2" + 1)
                }
                else
                {
                    fscommand("OnSettingCmd","Selectlanguage" + "\2" + this._parent.data.name)
                }
            }
        }
        mc.language_1.hitzone.onReleaseOutside = function()
        {
            this._parent._parent._parent.onReleasedInListbox();
        }
        mc.language_1.hitzone.onPress = function()
        {
            this._parent._parent._parent.onPressedInListbox();
            this.Prees_x = this._xmouse;
            this.Prees_y = this._ymouse;
        }

        mc.language_2.hitzone.onRelease = function()
        {
            this._parent._parent._parent.onReleasedInListbox();
            if(Math.abs(this.Prees_x - this._xmouse) < this._width / 2 && Math.abs(this.Prees_y - this._ymouse) < this._height / 2)
            {
                if (this._parent.data.name == "")
                {
                    fscommand("OnSettingCmd","ShowMessage" + "\2" + 1)
                }
                else
                {
                    fscommand("OnSettingCmd","Selectlanguage" + "\2" + this._parent.data.name)
                }
            }
        }
        mc.language_2.hitzone.onReleaseOutside = function()
        {
            this._parent._parent._parent.onReleasedInListbox();
        }

        mc.language_2.hitzone.onPress = function()
        {
            this._parent._parent._parent.onPressedInListbox();
            this.Prees_x = this._xmouse;
            this.Prees_y = this._ymouse;
        }
    }
    var num = Math.ceil(allLanguagesData.length / 2)
    for(var i = 0; i < num; i++)
    {
        listView.addListItem(i,false,false)
    }

}

tabPanel.filter_button_3.onRelease = function()
{
    curShowTabNumber = 1
    ContralTabel(curShowTabNumber)
}

tabPanel.filter_button_2.onRelease = function()
{
    curShowTabNumber = 2;
    ContralTabel(curShowTabNumber)
    SetPushLayer()
}

generalPanel.board_1.music_plane.move_bar.onPress = function()
{
    isOnPressMusic = true;
    lastMusicNum = this._parent.num
    lastXmouse = _root._xmouse
}

generalPanel.board_1.music_plane.move_bar.onRelease = generalPanel.board_1.music_plane.move_bar.onReleaseOutside = function()
{
    isOnPressMusic = false;
}

generalPanel.board_1.music_plane.updateSoundNum = function()
{
    this.num_txt.text = this.num;
    var par = this.num / soundMax * 100 + 1
    this.gotoAndStop(par)
    fscommand("OnSettingCmd", "upateMusicNum" + "\2" + this.num);
    if(this.num > 0)
    {
        allData.isBGMOn = true
        generalPanel.board_1.icon_1.gotoAndStop(1)
    }
    else
    {
        allData.isBGMOn = false
        generalPanel.board_1.icon_1.gotoAndStop(2)
    }
    fscommand("OnSettingCmd","updateMusicOn" + "\2" + allData.isBGMOn)
}

generalPanel.board_1.sound_plane.move_bar.onPress = function()
{
    isOnPressSound = true;
    lastSoundNum = this._parent.num
    lastXmouse = _root._xmouse;
}

generalPanel.board_1.sound_plane.move_bar.onRelease = generalPanel.board_1.sound_plane.move_bar.onReleaseOutside = function()
{
    isOnPressSound = false;
}

generalPanel.board_1.sound_plane.updateSoundNum = function()
{
    this.num_txt.text = this.num
    var par = this.num / soundMax * 100 + 1
    this.gotoAndStop(par)
    fscommand("OnSettingCmd", "upateSoundNum" + "\2" + this.num);

    if(this.num > 0)
    {
        allData.isSFXOn = true
        generalPanel.board_1.icon_2.gotoAndStop(1)
    }
    else
    {
        allData.isSFXOn = false
        generalPanel.board_1.icon_2.gotoAndStop(2)
    }
    fscommand("OnSettingCmd", "updateSoundOn" + "\2" + allData.isSFXOn)
}

generalPanel.board_1.icon_1.onRelease = function()
{
    if(allData.isBGMOn)
    {
        allData.isBGMOn = false;
        this.gotoAndStop(2);
    }
    else
    {
        allData.isBGMOn = true;
        this.gotoAndStop(1);
    }
    fscommand("OnSettingCmd","updateMusicOn" + "\2" + allData.isBGMOn);
}

generalPanel.board_1.icon_2.onRelease = function()
{
    if(allData.isSFXOn)
    {
        allData.isSFXOn = false;
        this.gotoAndStop(2);
    }
    else
    {
        allData.isSFXOn = true;
        this.gotoAndStop(1);
    }
    fscommand("OnSettingCmd","updateSoundOn" + "\2" + allData.isSFXOn);
}


generalPanel.board_1.choose.onRelease = function()
{
    // if(this.select == 0)
    // {
    //     this.select = 1
    // }
    // else
    // {
    //     this.select = 0;
    // }
    // this.onSelect();
    fscommand("OnSettingCmd","ShowMessage" + "\2" + 1)
    // fscommand("OnSettingCmd","autoTranslate" + "\2" + this.select)
}

generalPanel.board_1.choose.onSelect = function()
{
    if (this.select == 0)
    {
        this.gotoAndStop(2);
    }
    else
    {
        this.gotoAndStop(1);
    }

}

generalPanel.board_2.onSelect = function()
{
    for(var i = 1;i < 4; i++)
    {
        var item = this["choose_" + i]
        item.gotoAndStop(2);
    }
    var selectItem = this["choose_" + this.num];
    selectItem.gotoAndStop(1)
}

topPanel.btn_close.onRelease = function()
{
    _root._visible = false;
}

_root.troops_middle.onRelease = function()
{

}

topPanel.energy.btn_add.onRelease = function()
{
    fscommand("GoToNext", "Affair");
}

topPanel.money.btn_add.onRelease = function()
{
    fscommand("GoToNext", "Affair");
}

topPanel.credit.btn_add.onRelease = function()
{
    fscommand("GoToNext", "Purchase");
}

function SetMoneyInfo(moneyData)
{
    var titles = topPanel
    titles.money.money_text.text = moneyData.money
    titles.credit.credit_text.text = moneyData.credit
}

function SetEnergyInfo(point)
{
    var energyBtn = topPanel.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point
}

function SetPushLayer()
{
    var listView = pushPanel.list_push.ViewList;
    var pushData = allData.pushData
    listView.pushData = pushData
    listView.clearListBox();
    listView.initListBox("push_list_1",0,true,true);
    listView.enableDrag(true);
    listView.onEnterFrame = function()
    {
        this.OnUpdate();
    }

    listView.onItemEnter = function(mc,index)
    {
        var itemData = this.pushData[index];
        mc.itemData = itemData;
        mc.name_txt.text = itemData.name;
        if (itemData.isOpen == 0)
        {
            mc.choose.gotoAndStop(2)
        }
        else
        {
            mc.choose.gotoAndStop(1)
        }
        mc.choose.onRelease = function()
        {
            // if (this._parent.itemData.isOpen == 0)
            // {
            //     this._parent.itemData.isOpen = 1
            //     this.gotoAndStop(1)
            // }
            // else
            // {
            //     this._parent.itemData.isOpen = 0
            //     this.gotoAndStop(2)
            // }
            fscommand("OnSettingCmd","ShowMessage" + "\2" + 1)
            // fscommand("OnSettingCmd",this._parent.itemData.flag + "\2" + this._parent.itemData.isOpen)
        }
    }
    for (var i = 0; i < pushData.length; ++i )
    {
        listView.addListItem(i,false,false);
    }
}
