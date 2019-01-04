import common.CTextAutoSizeTool;
CloseBtn 	= _root.top.btn_close;

StoreList 	= _root.list.view_list;
StoreSlideItem = StoreList.slideItem;
ItemArray 	= new Array();
StoreDatas 	= undefined;
TotalWidth 	= 0;
CountPage 	= 0;
var MAX_VIP_LEVEL = 15
var VipInfo = _root.vip_info;
_root.onLoad = function()
{
    // Test();
}

CloseBtn.onRelease = function()
{
	_root.top.gotoAndPlay("closing_ani");
	for (var i = 0; i < ItemArray.length; i++)
	{
		var mc = ItemArray[i];
		mc.gotoAndPlay("closing_ani");
		if (mc.item1 != undefined)
		{
			mc.item1.gotoAndPlay("closing_ani");
		}
		if (mc.item2 != undefined)
		{
			mc.item2.gotoAndPlay("closing_ani");
		}
	}
}

_root.top.OnMoveInOver = function()
{

}

_root.top.OnMoveOutOver = function()
{
	fscommand("ExitBack");
}

function Test()
{
	var datas = new Array();

	var data1 = new Object();
	data1.type = 2;
	data1.index = 1;
	datas.push(data1);

	var data2 = new Object();
    data2.type = 1;
	data2.index = 2;
	datas.push(data2);
	//datas.push(data1);
	var data3 = new Object();
    data3.type = 1;
	data3.index = 3;
	datas.push(data3);
	
	var data4 = new Object();
    data4.type = 1;
	data4.index = 4;
	datas.push(data4);

	var data5 = new Object();
    data5.type = 1;
	data5.index = 5;
	datas.push(data5);

    var data6 = new Object();
    data6.type = 1;
	data6.index = 6;
	datas.push(data6);

	InitStoreList(datas);
}

function ClearItemMc()
{
	for(var i in ItemArray)
	{
		ItemArray[i].removeMovieClip()
	}
	StoreList.forceCorrectPosition();
}

//datas.key
//datas.type 
//datas.credit
//datas.extra_award = {}
//datas.price
//datas.index
function InitStoreList( datas )
{
	StoreDatas = datas;
	if (StoreDatas == undefined)
	{
		return;
	}
	ClearItemMc();
	TotalWidth = 0;
    StoreList.m_isVertical = false;
    var dataTypeCount = 0;
	for (var i = 0 ; i < StoreDatas.length; i++)
	{
		var data = StoreDatas[i];
		var mc = undefined;
		if (data.type == 2)
		{
            mc = StoreSlideItem.attachMovie("Month_card", "month_card", StoreSlideItem.getNextHighestDepth());
            ItemArray[data.index] = mc;
		}else if (data.type == 1)
        {
            dataTypeCount += 1;
            if ((dataTypeCount - 1) % 2 == 0)
			{
				mc = StoreSlideItem.attachMovie("tab_item1", "store_item", StoreSlideItem.getNextHighestDepth());
                ItemArray[StoreDatas[i].index] = mc.item1;
                mc.gotoAndStop(1);
                if (StoreDatas[i + 1] == undefined || StoreDatas[i + 1].type != 1)
				{
					mc.item2._visible = false;
				}else
				{
					mc.item2._visible = true;
					ItemArray[StoreDatas[i + 1].index] = mc.item2;
				}
            }
		}
		if (mc != undefined)
		{
			mc._x = TotalWidth;
			TotalWidth = TotalWidth + mc._width;
			data.mc = mc;
        }
	}
	InitPageNum(Math.ceil(TotalWidth / 1300));
	StoreList.SimpleSlideOnLoad();

	StoreList.onEnterFrame = function()
	{
		StoreList.OnUpdate();
	}
}

function UpdateMonthCrad(datas)
{
	StoreDatas = datas;
	for (var i = 0 ; i < StoreDatas.length; i++)
	{
		var data = StoreDatas[i];
		if (data.type == 2)
		{
			SetMonthCardInfo(data);
		}
	}
}

function SetMonthCardInfo(data)
{
	var mc = ItemArray[data.index];
	mc.data = data;
    if (data.left <= 0)
    {
        mc.has._visible = false;
        mc.buy._visible = true;
        SetCreditNum(mc.buy.content.gain_num, data.credit);
        SetCreditNum(mc.buy.content.extra_num, data.all);
        SetAddSymbolVisble(mc.buy.content.add_symbol,data.all);
        mc.buy.content.product_desc.desc_txt.htmlText = data.show_text;
        mc.buy.content.title_text.text = data.awardName;
        CTextAutoSizeTool.SetSingleLineText(mc.buy.content.discount.name, data.discount, 16, 12);
        // mc.buy.content.discount.name.text = data.discount;
    }else
    {
        mc.has._visible = true;
        mc.buy._visible = false;
        SetCreditNum(mc.has.content.gain_num, data.credit);
        SetCreditNum(mc.has.content.extra_num, data.all);
        SetAddSymbolVisble(mc.has.content.add_symbol,data.all);
        mc.has.content.has_time_text.text = data.show_text;
        CTextAutoSizeTool.SetSingleLineText(mc.has.content.title_text, data.month_text, 40, 32);
        // mc.has.content.title_text.text = data.month_text;
    }

    mc.buy.buy_btn.onRelease = mc.has.buy_btn.onRelease =  function()
	{
        this._parent._parent._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
            trace("index====" + this._parent.data.index);
            if (this._parent._parent.data.enable)
            {
                trace("xxxsd = " +  this._parent._parent.data.key + "xx " +  this._parent._parent.data.id)
                fscommand("PayStoreCommand", "BuyProduct" + "\2" + this._parent._parent.data.key + "\2" + this._parent._parent.data.id);
            }
			
		}
	}
    mc.buy.buy_btn.onPress = mc.has.buy_btn.onPress = function()
	{
        this._parent._parent._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}
    mc.buy.buy_btn.onReleaseOutside = mc.has.buy_btn.onReleaseOutside = function()
	{
        this._parent._parent._parent._parent.onReleasedInListbox();
	}
}

function UpdateNormalProduct(datas)
{
	StoreDatas = datas;
	for (var i = 0 ; i < StoreDatas.length; i++)
	{
		var data = StoreDatas[i];
		if (data.type == 1)
		{
			SetNormalProductInfo(data);
		}
	}
}

function SetNormalProductInfo(data)
{
	var mc = ItemArray[data.index];
	mc.data = data;
    SetCreditNum(mc.content.num, data.credit);
    SetCreditNum(mc.content.extra_num.extra_num,data.extra_award[0].num);
    SetAddSymbolVisble(mc.content.extra_num.add_symbol,data.extra_award[0].num);
    mc.content.extra_num._x = mc.content.num._x + mc.content.num._width + 5;
    mc.content.title_name.text = data.awardName;
    mc.content.icon.gotoAndStop(data.key);
	mc.buy_btn.onRelease = function()
	{
		this._parent._parent._parent._parent.onReleasedInListbox();
		if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
		{
			trace("index=" + this._parent.data.index);
            if (this._parent.data.enable)
            {

                fscommand("PayStoreCommand", "BuyProduct" + "\2" + this._parent.data.key  + "\2" + this._parent.data.id);
			}
			
		}
	}
	mc.buy_btn.onPress = function()
	{
		this._parent._parent._parent._parent.onPressedInListbox();
		this.Press_x = _root._xmouse;
		this.Press_y = _root._ymouse;
	}
	mc.buy_btn.onReleaseOutside = function()
	{
		this._parent._parent._parent._parent.onReleasedInListbox();
	}
}

function UpdateProductPrice(datas)
{
	StoreDatas = datas;
	for (var i = 0 ; i < StoreDatas.length; i++)
	{
		var data = StoreDatas[i];
		var mc = ItemArray[data.index];
		mc.data = data;
        mc.buy_btn.txt_Price.text = data.price;
        mc.has.buy_btn.txt_Price.text = data.price;
        mc.buy.buy_btn.txt_Price.text = data.price;
	}
}

function InitPageNum( count )
{
	if (count <= 1)
	{
		_root.btn_bg.flips.flip_0._visible = true;
		_root.btn_bg.flips.flip_1._visible = false;
		_root.btn_bg.flips.flip_2._visible = false;
	}else if (count == 2)
	{
		_root.btn_bg.flips.flip_0._visible = true;
		_root.btn_bg.flips.flip_1._visible = true;
		_root.btn_bg.flips.flip_2._visible = false;
	}else if (count == 3)
	{
		_root.btn_bg.flips.flip_0._visible = true;
		_root.btn_bg.flips.flip_1._visible = true;
		_root.btn_bg.flips.flip_2._visible = true;
	}
	CountPage = count;
}

function SetPageNum()
{
	var page = 1
	var len = StoreSlideItem._x
	if (len < -300)
	{
		page = 2;
	}
	if (len < -800)
	{
		page = 3;
	}
	
	if (page > CountPage)
	{
		page = CountPage;
	}

	if (page <= 1)
	{
		_root.btn_bg.flips.flip_0.gotoAndStop(1);
		_root.btn_bg.flips.flip_1.gotoAndStop(2);
		_root.btn_bg.flips.flip_2.gotoAndStop(2);
	}else if (page == 2)
	{
		_root.btn_bg.flips.flip_0.gotoAndStop(2);
		_root.btn_bg.flips.flip_1.gotoAndStop(1);
		_root.btn_bg.flips.flip_2.gotoAndStop(2);
	}else if (page == 3)
	{
		_root.btn_bg.flips.flip_0.gotoAndStop(2);
		_root.btn_bg.flips.flip_1.gotoAndStop(2);
		_root.btn_bg.flips.flip_2.gotoAndStop(1);
	}
}

function SetAddSymbolVisble(mc,num)
{
    if(num > 0)
    {
        mc._visible = true
    }
    else
    {
        mc._visible = false;
    }
}

function SetCreditNum(mc, num)
{
    if (num > 0)
    {
        var strNum = num.toString();
        var arrayNum = strNum.split("");

        var nLength = arrayNum.length;
        mc.gotoAndStop(nLength);
        for(var i = 0; i < nLength; ++i)
        {
            var temp = Number(arrayNum[i]);
            mc["num" + (i + 1)].gotoAndStop(temp + 1);
        }
        mc._visible = true
    }
    else
    {
        mc._visible = false
    }
}

function SetMoneyInfo(moneyData)
{
    var titles = _root.top
    titles.money.money_text.text = moneyData.money
    titles.credit.credit_text.text = moneyData.credit
}

function SetEnergyInfo(point)
{
    var energyBtn = _root.top.energy
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point

}

function UpdateVipInfo(data)
{
    var VipDatas = data
    if (VipDatas.cur_vip_level >= MAX_VIP_LEVEL)
    {
        VipInfo.info._visible = false;
        VipInfo.full_level._visible = true;
        SetProgressBar(VipInfo.progress, VipDatas.cur_vip_point, VipDatas.cur_vip_point);
    }else
    {
        VipInfo.info._visible = true;
        VipInfo.full_level._visible = false;

        VipInfo.info.next_credit.credit_text.text = VipDatas.next_vip_need_credit;
        SetVipNum(VipInfo.info.next_level, VipDatas.next_vip_level);
        SetProgressBar(VipInfo.progress, VipDatas.cur_vip_point, VipDatas.upgrade_vip_point);
    }
    SetVipNum(VipInfo.cur_level, VipDatas.cur_vip_level);
}

function SetVipNum(mc, num)
{
    var num0 = Math.floor(num / 10);
    var num1 = num % 10;
    if (num >= 10)
    {
        mc.num.gotoAndStop(2);
        mc.num.num0.gotoAndStop(num0 + 1);
        mc.num.num1.gotoAndStop(num1 + 1);
    }else
    {
        mc.num.gotoAndStop(1);
        mc.num.num0.gotoAndStop(num1 + 1);
    }
}

function SetProgressBar(mc, cur, max)
{
    mc.txt_progress.text = cur + "/" + max;
    var progress = Math.floor((cur / max) * 100) + 1;
    mc.gotoAndStop(progress);
}


_root.onEnterFrame = function()
{
	SetPageNum();
}