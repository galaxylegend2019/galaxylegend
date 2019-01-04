var getHeroPanel = _root.gacha_hero
var hasSkillPanel = _root.upgrade.evolve_result
var noSkillPanel = _root.upgrade.upgrade_result
var heroEvolvePanel = _root.evolve
var dataInfo = undefined;
var isHasNewSkill = false
_root.onLoad = function()
{
    _root._visible = false;
    if(hasSkillPanel.skill_icon.skill_icon.icons == undefined)
    {
        hasSkillPanel.skill_icon.skill_icon.loadMovie("CommonSkills.swf")
    }
    if(hasSkillPanel.left_item.icon.item_icon.icons == undefined)
    {
        hasSkillPanel.left_item.icon.item_icon.loadMovie("CommonHeros.swf")
    }
    if(hasSkillPanel.right_item.icon.item_icon.icons == undefined)
    {
        hasSkillPanel.right_item.icon.item_icon.loadMovie("CommonHeros.swf")
    }
    if(noSkillPanel.left_item.icon.item_icon.icons == undefined)
    {
        noSkillPanel.left_item.icon.item_icon.loadMovie("CommonHeros.swf")
    }
    if(noSkillPanel.right_item.icon.item_icon.icons == undefined)
    {
        noSkillPanel.right_item.icon.item_icon.loadMovie("CommonHeros.swf")
    }
}

hasSkillPanel.bg.onRelease = noSkillPanel.bg.onRelease = getHeroPanel.hitzone.onRelease = function()
{

}
hasSkillPanel.btn_close.onRelease = noSkillPanel.btn_close.onRelease = function()
{
    MoveOut();
}

heroEvolvePanel.btn_close.onRelease = function()
{
    fscommand("HeroCommand","HideHeroEvole")
    heroEvolvePanel.gotoAndPlay("closing_ani")
}

getHeroPanel.hitzone.onRelease = function()
{
    if(getHeroPanel._visible)
    {
        getHeroPanel.gotoAndPlay("closing_ani")
    }
}

getHeroPanel.OnMoveOutOver = function()
{
    _root._visible = false;
    fscommand("HeroCommand","HideHeroCallUI")
}
hasSkillPanel.OnMoveOutOver = function()
{
    _root._visible = false
}

noSkillPanel.OnMoveOutOver = function()
{
    _root._visible = false
}

hasSkillPanel.ShowQulityNumberAni = noSkillPanel.ShowQulityNumberAni =  function()
{
    this.right_item.quality.gotoAndPlay("show")
}


function MoveIn()
{
    _root._visible = true;
    hasSkillPanel._visible = false;
    noSkillPanel._visible = false;
    getHeroPanel._visible = false;
    heroEvolvePanel._visible = false;
    if (dataInfo.upgradeType == "hero_star")
    {
        heroEvolvePanel._visible = true
        HeroEvolveLayer()
        heroEvolvePanel.gotoAndPlay("opening_ani")
    }
    else
    {
        if(isHasNewSkill)
        {
            hasSkillPanel._visible = true
            hasSkillPanel.gotoAndPlay("opening_ani");
        }else
        {
            noSkillPanel._visible = true
            noSkillPanel.gotoAndPlay("opening_ani");
        }
    }
}

function ShowHero3dLayer(info)
{
    if (_root._visible)
    {
        return;
    }
    _root._visible = true;
    hasSkillPanel._visible = false;
    noSkillPanel._visible = false;
    getHeroPanel._visible = true;
    heroEvolvePanel._visible = false;
    getHeroPanel.skill_info._visible = false;
    getHeroPanel.desc._visible = false;

    getHeroPanel.hero_flag_icon.gotoAndStop(info.heroType)
    getHeroPanel.hero_flag_icon.hero_desc.text = info.Describe_Desc
    getHeroPanel.info.hero_star.gotoAndStop(info.star)
    getHeroPanel.info.name_txt.htmlText = info.heroName
    if (info.isHasNewSkill)
    {
        getHeroPanel.skill_info._visible = true;
    }
    if(getHeroPanel.skill_info.skill_icon.skill_icon.icons == undefined)
    {
        getHeroPanel.skill_info.skill_icon.skill_icon.loadMovie("CommonSkills.swf")
    }
    getHeroPanel.skill_info.skill_icon.skill_icon.icons.icons.gotoAndStop("skill_" + info.skillDataInfo.id)
    getHeroPanel.skill_info.name_text.text = info.skillDataInfo.skillName
    getHeroPanel.skill_info.tt.text = info.skillDataInfo.skillDesc

    getHeroPanel.gotoAndPlay("opening_ani")
}

function MoveOut()
{
    if(isHasNewSkill)
    {
        hasSkillPanel.gotoAndPlay("closing_ani")
    }
    else
    {
        noSkillPanel.gotoAndPlay("closing_ani")
    }
}

function SetIcon(mc,data,name)
{
    if(mc.icons == undefined)
    {
        mc.loadMovie(name)
    }
    mc.IconData = data
    if(mc.UpdateIcon)
    {
        mc.UpdateIcon()
    }
}

function SetPowerNumber(mc,number)
{
    var numStr = number.toString();
    var aryNumStr = numStr.split("");
    var nLenght = aryNumStr.length;
    mc.gotoAndStop(nLenght)
    for(var i = 0;i < 6; ++i)
    {
        var item = mc["r_" + (i + 1)];
        item._visible = false
        if(aryNumStr[i] != undefined)
        {
            item._visible = true
            item.gotoAndStop(Number(aryNumStr[i]) + 1)
        }
    }
}

function SetData(datas)
{
    dataInfo = datas
    isHasNewSkill = (dataInfo.isUnlockSkill && dataInfo.upgradeType == "hero_quality")

    InitPanel()
    MoveIn()
}

function InitPanel()
{
    hasSkillPanel.left_item.name_txt.htmlText = dataInfo.lastHeroDataInfo.name;
    hasSkillPanel.left_item.icon.star_plane.star.gotoAndStop(dataInfo.lastHeroDataInfo.star)
    hasSkillPanel.left_item.quality.quality.quality_txt.htmlText = dataInfo.lastHeroDataInfo.qualityText
    hasSkillPanel.left_item.bg._visible = false

    SetIcon(hasSkillPanel.left_item.icon.item_icon,dataInfo.lastHeroDataInfo.heroIcon,"CommonHeros.swf")
    hasSkillPanel.num_left.number_txt.text = dataInfo.lastHeroDataInfo.powerNumber

    hasSkillPanel.right_item.name_txt.htmlText = dataInfo.curHeroDataInfo.name;
    hasSkillPanel.right_item.icon.star_plane.star.gotoAndStop(dataInfo.curHeroDataInfo.star)
    hasSkillPanel.right_item.quality.quality.quality_txt.htmlText = dataInfo.curHeroDataInfo.qualityText
    hasSkillPanel.right_item.bg.gotoAndStop("quality_" + dataInfo.curHeroDataInfo.quality)
    SetIcon(hasSkillPanel.right_item.icon.item_icon,dataInfo.curHeroDataInfo.heroIcon,"CommonHeros.swf")
    SetPowerNumber(hasSkillPanel.number_2,dataInfo.curHeroDataInfo.powerNumber);

    if (hasSkillPanel.skill_icon.skill_icon.icons == undefined)
    {
        hasSkillPanel.skill_icon.skill_icon.loadMovie("CommonSkills.swf")
    }
    hasSkillPanel.skill_icon.skill_icon.icons.icons.gotoAndStop("skill_" + dataInfo.skillDataInfo.id)
    // hasSkillPanel.skill_icon.skill_icon.icons.gotoAndStop("skill_13002")
    hasSkillPanel.skill_name.name_text.text = dataInfo.skillDataInfo.skillName
    hasSkillPanel.skill_info.info_text.text = dataInfo.skillDataInfo.skillDesc

    noSkillPanel.left_item.name_txt.htmlText = dataInfo.lastHeroDataInfo.name;
    noSkillPanel.left_item.quality.quality.quality_txt.htmlText = dataInfo.lastHeroDataInfo.qualityText
    noSkillPanel.left_item.icon.star_plane.star.gotoAndStop(dataInfo.lastHeroDataInfo.star)
    SetIcon(noSkillPanel.left_item.icon.item_icon,dataInfo.lastHeroDataInfo.heroIcon,"CommonHeros.swf")
    noSkillPanel.num_left.number_txt.text = dataInfo.lastHeroDataInfo.powerNumber
    noSkillPanel.left_item.bg._visible = false

    noSkillPanel.right_item.name_txt.htmlText = dataInfo.curHeroDataInfo.name;
    noSkillPanel.right_item.quality.quality.quality_txt.htmlText = dataInfo.curHeroDataInfo.qualityText
    noSkillPanel.right_item.icon.star_plane.star.gotoAndStop(dataInfo.curHeroDataInfo.star)
    noSkillPanel.right_item.bg.gotoAndStop("quality_" + dataInfo.curHeroDataInfo.quality)
    SetIcon(noSkillPanel.right_item.icon.item_icon,dataInfo.curHeroDataInfo.heroIcon,"CommonHeros.swf")
    SetPowerNumber(noSkillPanel.number_2,dataInfo.curHeroDataInfo.powerNumber);
}

heroEvolvePanel.ShowStarAnimation = function()
{
    heroEvolvePanel.star.star_item.gotoAndPlay("star_show");
}

heroEvolvePanel.ShowPowerAnimation = function()
{
    trace("ShowPowerAnimation =============")
    trace(heroEvolvePanel.powerNum.power_number)
    heroEvolvePanel.powerNum.power_number.gotoAndPlay("power_show");
}


heroEvolvePanel.ShowHero3DMode = function()
{
    fscommand("HeroCommand","AddHero" + "\2" + "1" + "\2" + dataInfo.curHeroDataInfo.heroModel)
}

function HeroEvolveLayer()
{
    heroEvolvePanel._visible = true
    var powerAdd = dataInfo.curHeroDataInfo.powerNumber - dataInfo.lastHeroDataInfo.powerNumber
    PlayCombat(heroEvolvePanel.powerNum.power_number.extra_num,powerAdd)
    SetPowerNumber(heroEvolvePanel.power_number,dataInfo.curHeroDataInfo.powerNumber)
    heroEvolvePanel.name.name_txt.htmlText = dataInfo.curHeroDataInfo.name;
    heroEvolvePanel.star.gotoAndStop(dataInfo.curHeroDataInfo.star - 1);
}
function PlayCombat(mc,num)
{
    var strNum = num.toString();
    var arrayNum = strNum.split("");
    var nLength = arrayNum.length;

    if(nLength<=3)
    {
        mc.gotoAndStop("three")
    }else if(nLength<=4)
    {
        mc.gotoAndStop("four")
    }else if(nLength<=5)
    {
        mc.gotoAndStop("five")
    }

    for(var i = 0; i < 5; ++i)
    {
        var item = mc["num"+(i+1)]
        item._visible=true
        if(arrayNum[i]!=undefined)
        {
            var temp = Number(arrayNum[i]);
            item.gotoAndStop(temp + 1)
        }else
        {
            item._visible=false
        }
    }
}

function FTEOnclickConfirm()
{
    fscommand("HeroCommand","Close_CallHeroUI")
    MoveOut();
    if(getHeroPanel._visible)
    {
        _root._visible = false;
        fscommand("HeroCommand","HideHeroCallUI")
        // getHeroPanel.gotoAndPlay("closing_ani")
    }
    if (heroEvolvePanel._visible)
    {
        heroEvolvePanel.btn_close.onRelease()
    }
}


function FTEPlayAnim(sname)
{
    _root.fteanim[sname]._visible = true
}

function FTEHideAnim()
{
    _root.fteanim.confirm._visible = false
}

FTEHideAnim()