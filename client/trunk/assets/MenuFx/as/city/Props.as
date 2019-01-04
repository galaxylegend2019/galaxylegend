import com.tap4fun.utils.Utils;
var troops_middle = _root.troops_middle;
var ui_item_sell = _root.item_sell_page.item_sell
ui_item_sell.num = 0

var lastSwicthButton:Object = undefined;

var AllItemMap:Array = new Array();
var AllItemNewCueNumber = new Array();
var Item_type_Whole = 0;
var Item_type_Cost = 1;
var Item_type_Equip = 2;
var Item_type_Hero = 3;
AllItemMap[Item_type_Whole] = new Array();
AllItemMap[Item_type_Cost] = new Array();
AllItemMap[Item_type_Equip] = new Array();
AllItemMap[Item_type_Hero] = new Array();
AllItemNewCueNumber[Item_type_Whole] = 0;
AllItemNewCueNumber[Item_type_Cost] = 0;
AllItemNewCueNumber[Item_type_Equip] = 0;
AllItemNewCueNumber[Item_type_Hero] = 0;
var curItemType:Number = 0;
var item_list_mc_length=5;

var curFocusButton = undefined

var all_view_mov_object_list : Array = [ _root.item_sell_page , _root.item_origin_page , _root.hero_use , _root.troops_middle , _root.Title_plane , _root.filter_contral ];

var LocalTexts = undefined;
var isOnRelessed = false

this.onLoad = function()
{
	InitFlash();
}

function move_in(){
	 _root.troops_middle._visible = true;
	 _root.troops_middle.gotoAndPlay("opening_ani");
	 _root.troops_middle.common_bg.gotoAndPlay("anim1");
	 _root.Title_plane._visible = true;
	 _root.Title_plane.gotoAndPlay("opening_ani");
	 _root.filter_contral._visible = true;
	 _root.filter_contral.gotoAndPlay("opening_ani");
	 fscommand("ItemCommand","RegItemUIListener");
	 _root.btn_bg._visible = true;
}

function move_out(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		if ( all_view_mov_object_list[i]._visible ){
			all_view_mov_object_list[i].gotoAndPlay("closing_ani");
		}
	}
	 _root.troops_middle.common_bg.gotoAndPlay("anim2");
     fscommand("ItemCommand","UnRegItemUIListener");
     fscommand("ItemCommand","CloseItemLayer");
	_root.troops_middle.OnMoveOutOver = function(){
		reset();
		fscommand("GotoNextMenu","GS_MainMenu")
		_root.btn_bg._visible = false;
	}
}

function InitFlash()
{
	initCommFuncArea();
	InitFilterButtons();
	reset();
}

function SetLocalText(data)
{
	LocalTexts = data;
}	

function initCommFuncArea(){
	_root.Title_plane.energy_plane.onRelease = 
	_root.Title_plane.money_plane.onRelease =
	_root.Title_plane.fuel_plane.onRelease =
	function(){
		fscommand("PlaySound", "sfx_ui_selection_1");
		fscommand("GoToNext","Affair");
	}

	//fscommand("GoToNext", "BackToAllianceMain")
}

function reset(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i]._visible = false;
	}
	_root.btn_bg._visible = false;

	_root.add_number_technique._visible = 
	_root.add_number_money._visible = 
	_root.add_number_energy._visible = 
	_root.add_number_fuel._visible = false;
}

function InitFilterButtons()
{
	for(var i = Item_type_Whole; i <= Item_type_Hero ; i++)
	{
		var curButton = _root.filter_contral[ "filter_button_" + (i + 1) ];
		curButton.btnIndex = i;
		curButton.onRelease = function()
		{
			if( curItemType != this.btnIndex ){
				fscommand("PlaySound", "sfx_ui_selection_2");
				ShowOneTypeItems ( this.btnIndex , true);
			}
		}
	}
}


function ShowResourceChange(Change_list:Array){
	if ( !_root.Title_plane._visible ){
		return;
	}
	for(var i = 0; i < Change_list.length ; i++){
		if (Change_list[i].ResName == "money"){
			_root.add_number_money.num_bar.txt_value.text = Change_list[i].ResChange_description;
			_root.add_number_money._visible = true;
			_root.add_number_money.gotoAndPlay("move_up");
		}
		else if (Change_list[i].ResName == "energy"){
			_root.add_number_energy.num_bar.txt_value.text = Change_list[i].ResChange_description;
			_root.add_number_energy._visible = true;
			_root.add_number_energy.gotoAndPlay("move_up");
		}
		else if (Change_list[i].ResName == "fuel"){
			_root.add_number_fuel.num_bar.txt_value.text = Change_list[i].ResChange_description;
			_root.add_number_fuel._visible = true;
			_root.add_number_fuel.gotoAndPlay("move_up");
		}
	}
}

//-----------------------------------------------------------Item Sell---------------------------------------------
function PopItemSell(itemData)
{
	_root.item_sell_page._visible=true

	_root.item_sell_page.btn_bg.onRelease = function() {}
	_root.item_sell_page.OnMoveInOver = function()
	{
		_root.item_sell_page.btn_bg.onRelease=function()
		{
			fscommand("PlaySound", "sfx_ui_cancel");
			_root.item_sell_page.OnMoveOutOver=function()
			{
				this.OnMoveOutOver=undefined
				_root.item_sell_page._visible=false
			}
			_root.item_sell_page.gotoAndPlay("closing_ani")
		}
	}

	_root.item_sell_page.gotoAndPlay("opening_ani")

	//set info for the sell page

	_root.item_sell_page.item_info.item_name_text.text = itemData.name_text;
	_root.item_sell_page.item_info.discription_text.text = itemData.discription_text == undefined ? "-" : itemData.discription_text;

	_root.item_sell_page.item_info.price_plane.price_text.text = itemData.price
	_root.item_sell_page.item_info.price_plane.item_num.text = Math.min(itemData.count, itemData.max_num);
	_root.item_sell_page.item_info.item_icon_frame.item_num.text = Math.min(itemData.count, itemData.max_num);

	var ui_item_icon = _root.item_sell_page.item_info.item_icon_frame
	if(ui_item_icon.item_icon.icons==undefined)
	{
		ui_item_icon.item_icon.loadMovie("CommonIcons.swf")
	}
	ui_item_icon.item_icon.IconData = itemData.icon_data;
	// ui_item_icon.item_icon.m_OnlyIcon = true;
	if( ui_item_icon.item_icon.UpdateIcon ){ ui_item_icon.item_icon.UpdateIcon() }

	ui_item_sell.itemData = itemData
	ui_item_sell.num = 1

	ui_item_sell.updatePriceAndNum()

	ui_item_sell.btn_sell.onRelease=function()
	{
		var id=ui_item_sell.itemData.id
		var count=ui_item_sell.num
		fscommand("PlaySound", "sfx_ui_sell");
		fscommand("ItemCommand","sellItem\2"+id+"\2"+count)

		_root.item_sell_page.gotoAndPlay("closing_ani")
		_root.item_sell_page.OnMoveOutOver=function()
		{
			this.OnMoveOutOver=undefined
			_root.item_sell_page._visible=false
		}
	}

}

ui_item_sell.num_tube.hit.onPress = function(){
	this._parent.onEnterFrame = function(){
		var new_sell_num = 1;
		if( this._xmouse < 0 ){
			//default 1
		}else if( this._xmouse > this._width ){
			new_sell_num = Math.min(ui_item_sell.itemData.count, ui_item_sell.itemData.max_num);
		}else{
			new_sell_num = Math.floor(this._xmouse / this._width * Math.min(ui_item_sell.itemData.count, ui_item_sell.itemData.max_num) + 0.5);
		}
		if( new_sell_num < 1) { new_sell_num = 1; }
		if( new_sell_num != ui_item_sell.num ){
			ui_item_sell.num = new_sell_num;
			ui_item_sell.updatePriceAndNum();
		}
	}
}

ui_item_sell.num_tube.hit.onRelease = ui_item_sell.num_tube.hit.onReleaseOutside = function(){
	this._parent.onEnterFrame = undefined;
}

ui_item_sell.updatePriceAndNum=function()
{
	var allPrice = ui_item_sell.num * ui_item_sell.itemData.price;

	// ui_item_sell.num_text.text = ui_item_sell.num + '/' + ui_item_sell.itemData.count ;
	ui_item_sell.num_tube.sell_number.num_text.text = ui_item_sell.num + '/' + Math.min(ui_item_sell.itemData.count, ui_item_sell.itemData.max_num) ;
	// ui_item_sell.item_all_price.text = allPrice;
    ui_item_sell.btn_sell.txt_Price.text = allPrice;
    Utils.ButtonIconAndNumberMidSide(ui_item_sell.btn_sell)

	var sell_num_percent = Math.ceil(ui_item_sell.num / Math.min(ui_item_sell.itemData.count, ui_item_sell.itemData.max_num) * 100);
	ui_item_sell.num_tube.gotoAndStop(sell_num_percent + 1);
}


ui_item_sell.btn_add.onRelease=function()
{
	fscommand("PlaySound", "sfx_ui_selection_3");
	if(ui_item_sell.num >= Math.min(ui_item_sell.itemData.count, ui_item_sell.itemData.max_num))
	{
		return;
	}
	ui_item_sell.num = ui_item_sell.num + 1;
	ui_item_sell.updatePriceAndNum()
}
ui_item_sell.btn_reduce.onRelease=function()
{
	fscommand("PlaySound", "sfx_ui_selection_3");
	if(ui_item_sell.num <= 1)
	{
		return;
	}
	ui_item_sell.num = ui_item_sell.num-1;
	ui_item_sell.updatePriceAndNum();
}

ui_item_sell.btn_max.onRelease = function(){
	fscommand("PlaySound", "sfx_ui_selection_3");
	ui_item_sell.num = Math.min(ui_item_sell.itemData.count, ui_item_sell.itemData.max_num);
	ui_item_sell.updatePriceAndNum();
}

// _root.item_sell_page.btn_close.onRelease=function()
_root.item_sell_page.btn_shield.onRelease=function()
{

}
_root.item_sell_page.btn_bg.onRelease=function()
{
	
}


//-----------------------------------------------------------Item Origin---------------------------------------------

function PopItemOrigin(itemData)
{
	fscommand("ShowItemOrigin",itemData.id)
}


_root.item_origin_page.pop_content.btn_close.onRelease=function()
{
	fscommand("PlaySound", "sfx_ui_cancel");
	_root.item_origin_page.pop_content.OnMoveOutOver=function()
	{
		this.OnMoveOutOver=undefined
		_root.item_origin_page._visible=false
		//_root.item_origin_page.page_cover._visible=false

	}
	_root.item_origin_page.pop_content.gotoAndPlay("closing_ani")
}


//-----------------------------------------------------------Item Detail---------------------------------------------

function UpdateResourceInfo(ResourceData:Object)
{
    _root.Title_plane.money_plane.value_view.text = ResourceData.money;
	_root.Title_plane.credit_plane.value_view.text = ResourceData.credit;
    //_root.Title_plane.technique_plane.value_view.text = ResourceData.technique;
    var point = ResourceData.energy
    var energyBtn =  _root.Title_plane.energy_plane
    var arrayNum = point.split("/");
    var ratio = Math.floor(Number(arrayNum[0]) / Number(arrayNum[1]) * 100)
    ratio = Math.min(100, Math.max(1, ratio))
    energyBtn.mc.gotoAndStop(ratio)
    energyBtn.mc.TxtNum.text = point

}


var cur_item_data;
var cur_item_MC;
//set item info (eg. icon,quality,price,name)
function UpdateItemDetail()
{
	if (cur_item_data.cue_new == true)
	{
		cur_item_data.cue_new = false;
		-- AllItemNewCueNumber[Item_type_Whole];
		-- AllItemNewCueNumber[cur_item_data.titleType];
		RefreashFileterCueRedPoint();
		curFocusButton.cue_effect._visible = false;
		fscommand("ItemCommand","check_newitem\2" + cur_item_data.id);
	}
	var ui_item_detail=troops_middle.item_detail.item_detail
	//ui_item_detail._visible=true
	ui_item_detail.item_price.price_text.text = cur_item_data.price == undefined ? 0 : cur_item_data.price;
	ui_item_detail.item_name_text.text = cur_item_data.name_text == undefined ? "-" : cur_item_data.name_text;
	ui_item_detail.discription_text.text = cur_item_data.discription_text == undefined ? "-" : cur_item_data.discription_text;
	var count = cur_item_data.count == undefined ? "-" : Math.min(cur_item_data.count, cur_item_data.count.max_num);
	ui_item_detail.item_num.html = true;
	ui_item_detail.item_num.htmlText = "<font color='#73C5EF'>" + LocalTexts.NumberText + "</font>" + " " + "<font color='#ffffff'>" + count + "</font>";

	if(ui_item_detail.item_frame.icons==undefined)
	{
		ui_item_detail.item_frame.loadMovie("CommonIcons.swf")
	}
	ui_item_detail.item_frame.IconData = cur_item_data.icon_data;
	ui_item_detail.item_frame.m_OnlyIcon = true;
	if( ui_item_detail.item_frame.UpdateIcon ) { ui_item_detail.item_frame.UpdateIcon(); }

	ui_item_detail.btn_sell.discription_text.text = cur_item_data.use_btn_description == undefined ? "" : cur_item_data.use_btn_description;
	ui_item_detail.btn_use.discription_text.text = cur_item_data.use_btn_description == undefined ? "" : cur_item_data.use_btn_description;
    ui_item_detail.btn_sell.txt_Price.text = cur_item_data.price == undefined ? 0 : cur_item_data.price;
    Utils.ButtonIconAndNumberMidSide(ui_item_detail.btn_sell)
	
	//unused button
	ui_item_detail.btn_detail_mid._visible = false;
	//end
	if( cur_item_data ){
		if (cur_item_data.useType < 0){
			ui_item_detail.btn_detail._visible = false;
			ui_item_detail.btn_sell._visible = false;
			ui_item_detail.btn_use._visible = false;
		}
		else{
			ui_item_detail.btn_detail._visible = true;
			ui_item_detail.btn_detail.onRelease=function()
			{
				fscommand("PlaySound", "sfx_ui_selection_1");
				PopItemOrigin(cur_item_data);
			}

			if(cur_item_data.useType == 0)
			{
				ui_item_detail.btn_use._visible = false;
				ui_item_detail.btn_sell._visible = true;
			}
			else
			{
				ui_item_detail.btn_use._visible = true;
				ui_item_detail.btn_sell._visible = false;
			}
			// ui_item_detail.btn_sell._visible = true;
			// ui_item_detail.btn_sell.onRelease=function()
			ui_item_detail.btn_sell.onRelease = ui_item_detail.btn_use.onRelease = function()
			{
				fscommand("PlaySound", "sfx_ui_menu_appears");
				if(cur_item_data.useType == 0)
				{
					PopItemSell( cur_item_data );
				}else if(cur_item_data.useType==3)
				{
					PopItemUseForHero( cur_item_data );
				}
				else
				{
					var id = cur_item_data.id;
					fscommand("ItemCommand","useItem\2"+id)
				}
				
			}
		}
	}
	else{
		ui_item_detail.btn_detail._visible = false;
		ui_item_detail.btn_sell._visible = false;
		ui_item_detail.btn_use._visible = false;
	}

}


var m_item_offer_exp:Number = 0;
var cur_Hero_exp_item:Object = undefined;
function PopItemUseForHero(itemData)
{
	cur_Hero_exp_item = itemData;
	for (var i = 0; i < cur_Hero_exp_item.use_param.length ; i++){
		if(cur_Hero_exp_item.use_param[i][0] == "hero_exp"){
			m_item_offer_exp = cur_Hero_exp_item.use_param[i][1];
			break;
		}
	}

	// var heroitme_use_plane = _root.hero_use.pop_content;
	var heroitme_use_plane = _root.hero_use;
	heroitme_use_plane._parent._visible=true

	_root.hero_use._visible = true;
	_root.hero_use.btn_bg.onRelease = function() {}
	_root.hero_use.OnMoveInOver = function()
	{
		this.btn_bg.onRelease=function()
		{
			fscommand("PlaySound", "sfx_ui_cancel");
			_root.hero_use.OnMoveOutOver=function()
			{
				this.OnMoveOutOver=undefined
				_root.hero_use._visible=false
			}
			_root.hero_use.gotoAndPlay("closing_ani")
		}
	}

	_root.hero_use.gotoAndPlay("opening_ani")


	var item_info_plane = heroitme_use_plane.item_info_plane;

	trace(item_info_plane._name);

	item_info_plane.item_name_text.text = cur_Hero_exp_item.name_text;
	item_info_plane.description_text.text = cur_Hero_exp_item.discription_text == undefined ? "-" : cur_Hero_exp_item.discription_text;
	// item_info_plane.item_icon_frame.item_num.text = LocalTexts.NumberText + " " + cur_Hero_exp_item.count;
	item_info_plane.item_icon_frame.item_num.text = Math.min(cur_Hero_exp_item.count, cur_Hero_exp_item.max_num);

	var item_icon_frame = item_info_plane.item_icon_frame;	

	if(item_icon_frame.item_icon.icons == undefined){
		item_icon_frame.item_icon.loadMovie("CommonIcons.swf");
	}
	item_icon_frame.item_icon.IconData = cur_Hero_exp_item.icon_data;
	// item_icon_frame.item_icon.m_OnlyIcon = true;
	if( item_icon_frame.item_icon.UpdateIcon ) { item_icon_frame.item_icon.UpdateIcon(); }

	RefreashHeroDatasUI();
	

	// heroitme_use_plane.btn_close.onRelease=function()
	// {
	// 	fscommand("PlaySound", "sfx_ui_cancel");
	// 	this._parent.OnMoveOutOver = function(){
	// 		this._parent._visible = false;
	// 	}
	// 	this._parent.gotoAndPlay("closing_ani");
	// }
	// heroitme_use_plane.gotoAndPlay("opening_ani");
}


var m_Hero_List:Array = undefined;
var const_row_hero_num = 2;
function UpdateHeroUseDatas(inputHeroListData:Array){
	m_Hero_List = inputHeroListData;
}

function RefreashHeroDatasUI(){
	var HeroList = _root.hero_use.hero_list.hero_list;

	var change_row_num = Math.ceil(m_Hero_List.length / const_row_hero_num) - HeroList.getItemListLength();

	while(change_row_num < 0){
		HeroList.eraseItem(HeroList.getItemListLength())
		change_row_num ++ 
	}

	for(var i = 0 ; i < HeroList.getItemListLength() ; i ++){
		var hero_plane_MC = HeroList.getMcByItemKey(i + 1)
		for(var j = 0 ; j < const_row_hero_num ; j++){
			var hero_view_MC = hero_plane_MC["item_" + (j + 1)];
			hero_view_MC.HeroData = m_Hero_List[i * const_row_hero_num + j];
			UpdateHeroViewItem(hero_view_MC);
		}
	}

	for( i = HeroList.getItemListLength() ; change_row_num > 0 ; i ++)
	{   
	    HeroList.addListItem(i + 1, false, false);
	    change_row_num --;
	}
}

var m_Hero_exp_database:Array = undefined;
var m_Hero_Limit_Level:Number = 0;
function SetHeroUseDatas(inputHeroListData:Array,exp_list:Array,lv_limit:Number,lvLimitStr)
{
	m_Hero_exp_database = exp_list;
	m_Hero_Limit_Level = lv_limit;
	// _root.hero_use.level_title.level_text.text = lv_limit;
	_root.hero_use.level_title.level_text.text = lvLimitStr;
	var HeroList = _root.hero_use.hero_list.hero_list;

	HeroList.clearListBox();
	HeroList.initListBox("list_item_use_item",0,true,true);
	HeroList.enableDrag( true );
	HeroList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	HeroList.onItemEnter = function(mc,index_item)
	{
		for(var i = 0 ; i < 2 ; i++)
		{
			var curIndex=(index_item-1) * const_row_hero_num + i

			var HeroData = m_Hero_List[curIndex]
			var subItem = mc["item_" + (i + 1)];

			subItem._visible = true;
			subItem.HeroData = HeroData;
			UpdateHeroViewItem(subItem);

			subItem.add_num_ani._visible = false;
			subItem.item_icon_view.onPress = function(){
				trace("onPressonPressonPressonPressonPress = ")
				isOnRelessed = false
				if(cur_Hero_exp_item.count <= 0 || !check_hero_limit(this._parent)){
					this._parent.use_item_number = 0;
					return;
				}
				fscommand("PlaySound","sfx_ui_item_use_bar_raise");
				this._parent.item_icon_view._width = 74;
				this._parent.item_icon_view._height = 74;
				cur_Hero_exp_item.count --;
				_root.hero_use.pop_content.item_origin.item_info_plane.item_num.text = Math.min(cur_Hero_exp_item.count, cur_Hero_exp_item.max_num);
				_root.hero_use.item_info_plane.item_icon_frame.item_num.text = Math.min(cur_Hero_exp_item.count, cur_Hero_exp_item.max_num);
				this._parent.use_item_number = 1;
				this._parent.mPressFrame = 0;
				this._parent.mNextUseFrame = 40;
				virtual_use_exp_item(this._parent,m_item_offer_exp,40);
				this._parent.onEnterFrame = function(){
					if(isOnRelessed)
					{
						this.onEnterFrame = undefined;
					}
					this.mPressFrame ++;
					// trace("this.mPressFrame: " + this.mPressFrame + "  this.mNextUseFrame: " + this.mNextUseFrame);
					if(this.mPressFrame >= this.mNextUseFrame){
						// trace("111 add_num_ani: " + this.add_num_ani + "  " + this.add_num_ani.add_num + "  " + this.add_num_ani.add_num.num_text);
						// trace("cur_Hero_exp_item.count: " + cur_Hero_exp_item.count + " HeroData.level: " + this.HeroData.level + "  m_Hero_Limit_Level: " + m_Hero_Limit_Level);

						if(cur_Hero_exp_item.count <= 0 || !check_hero_limit(this)){
							return;
						}
						cur_Hero_exp_item.count --;
						_root.hero_use.pop_content.item_origin.item_info_plane.item_num.text = Math.min(cur_Hero_exp_item.count, cur_Hero_exp_item.max_num);
						_root.hero_use.item_info_plane.item_icon_frame.item_num.text = Math.min(cur_Hero_exp_item.count, cur_Hero_exp_item.max_num);
						this.use_item_number ++;
						this.mPressFrame = 0;
						this.mNextUseFrame = 10;
						this.add_num_ani.add_num.num_text.text = 'X' + this.use_item_number;
						// trace("111 add_num_ani: " + this.add_num_ani + "  " + this.add_num_ani.add_num + "  " + this.add_num_ani.add_num.num_text);
						if (not this.add_num_ani._visible){
							this.add_num_ani._visible = true;
							this.add_num_ani.gotoAndPlay("showing");
							// trace("add_num_ani: " + this.add_num_ani + "  " + this.add_num_ani.add_num + "  " + this.add_num_ani.add_num.num_text);
						}
						trace(isOnRelessed)
						virtual_use_exp_item(this,m_item_offer_exp,10);
					}
				}
			}

			subItem.item_icon_view.onRelease = subItem.item_icon_view.onReleaseOutside = function()
			{
				isOnRelessed = true
				// this._parent._parent.onReleasedInListbox();
				// if(Math.abs(this.Press_x - _root._xmouse) + Math.abs(this.Press_y - _root._ymouse) < 10)
				{
					// fscommand("AllianceMainCmd", "RefuseApply" + "\2" + this._parent.data.player_id);
					this._parent.item_icon_view._width = 70;
					this._parent.item_icon_view._height = 70;
					this._parent.onEnterFrame = undefined;
					trace("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy = ")
					trace(this._parent.exp_process_bar.onEnterFrame)
					if (this._parent.add_num_ani._visible){
						this._parent.add_num_ani.gotoAndPlay("hideing");
					}
					if ( this._parent.use_item_number > 0){
						trace("use : " + this._parent.use_item_number);
						var heroID = this._parent.HeroData.id;
						var itemID = cur_item_data.id;
						var count = this._parent.use_item_number;
						fscommand("ItemCommand","useExpItem\2" + heroID + "\2" + itemID + "\2" + count);
					}
				}
			}

			// subItem.onRelease = subItem.onReleaseOutside = function(){
			// 	this.item_icon_view._width = 70;
			// 	this.item_icon_view._height = 70;
			// 	this.onEnterFrame = undefined;
			// 	if (this.add_num_ani._visible){
			// 		this.add_num_ani.gotoAndPlay("hideing");
			// 	}
			// 	if ( this.use_item_number > 0){
			// 		//trace("use : " + this.use_item_number);
			// 		var heroID = this.HeroData.id;
			// 		var itemID = cur_item_data.id;
			// 		var count = this.use_item_number;
			// 		fscommand("ItemCommand","useExpItem\2" + heroID + "\2" + itemID + "\2" + count);
			// 	}
			// }
		}
	}
	HeroList.onListboxMove = undefined;
	UpdateHeroUseDatas(inputHeroListData);
}

function UpdateHeroViewItem(subItem:Object){
	if(subItem.HeroData == undefined){
		subItem._visible = false;
		return;
	}
	else{
		subItem._visible = true;
	}
	if(check_hero_limit(subItem)){
		subItem.gotoAndStop("normal");
	}
	else{
		subItem.gotoAndStop("limit");
	}
	subItem.hero_name.text = subItem.HeroData.heroName;
	subItem.level_text.text="LV." + subItem.HeroData.level
	//icon and star
	if(subItem.item_icon_view.item_icon.icons==undefined)
	{
		subItem.item_icon_view.item_icon.loadMovie("CommonHeros.swf");
	}
	subItem.item_icon_view.item_icon.IconData = subItem.HeroData.icon_data;
	if ( subItem.item_icon_view.item_icon.UpdateIcon ) { subItem.item_icon_view.item_icon.UpdateIcon(); }

	subItem.item_icon_view.star_view.star.gotoAndStop(subItem.HeroData.star);

	var process_num = subItem.HeroData.nextExp > 0 ? Math.floor(subItem.HeroData.curExp / subItem.HeroData.nextExp * 100) : 100;
	subItem.exp_process_bar.gotoAndStop( process_num )	
}

function check_hero_limit(Hero_item_view:Object){
	if ( Hero_item_view.HeroData.level > m_Hero_Limit_Level  ) { return false; }
	if ( Hero_item_view.HeroData.level == m_Hero_Limit_Level && Hero_item_view.HeroData.curExp >= Hero_item_view.HeroData.nextExp - 1){
		return false;
	}
	return true;
}

function RefreashFileterCueRedPoint(){
	// for (var i = Item_type_Whole ; i <= Item_type_Hero ; ++i){
	// 	if( AllItemNewCueNumber[i] == 0){
	// 		_root.filter_contral["filter_button_" + (i + 1)].tips._visible = false;
	// 	}
	// 	else{
	// 		_root.filter_contral["filter_button_" + (i + 1)].tips._visible = true;
	// 		_root.filter_contral["filter_button_" + (i + 1)].tips.tt.text = AllItemNewCueNumber[i];
	// 	}
	// }
	for (var i = Item_type_Whole ; i <= Item_type_Hero ; ++i){
		if( AllItemNewCueNumber[i] == 0){
			_root.filter_contral["filter_button_" + (i + 1)].red_point._visible = false;
		}
		else{
			_root.filter_contral["filter_button_" + (i + 1)].red_point._visible = true;
		}
	}
}

function UpdateItemData(allItemData){
	AllItemMap[Item_type_Whole] = allItemData;
	for(var i = Item_type_Whole ; i <= Item_type_Hero ; ++i){
		AllItemNewCueNumber[i] = 0;
	}
	for(var i = Item_type_Cost ; i <= Item_type_Hero ; ++i){
		AllItemMap[i].splice(0);
	}
	for(var i = 0; i < allItemData.length; i++){
		AllItemMap[allItemData[i].titleType].push(allItemData[i]);
		if (allItemData[i].cue_new){
			++ AllItemNewCueNumber[Item_type_Whole];
			++ AllItemNewCueNumber[allItemData[i].titleType];
		}
	}
	RefreashFileterCueRedPoint();
	ShowOneTypeItems(curItemType , false);
}

function SetItemData(inputItemData)
{
	var ItemsList = _root.troops_middle.item_view.view_list;

	ItemsList.clearListBox();
	ItemsList.initListBox("list_items",0,true,true);
	ItemsList.enableDrag( true );
	ItemsList.onEnterFrame = function()
	{
		this.OnUpdate();
	}

	ItemsList.onItemEnter = function(mc,index_item)
	{
		for(var i = 0 ; i < item_list_mc_length ; i++)
		{
			var item_MC_index = i + 1;
			var item_data_index = ( index_item - 1 ) * item_list_mc_length + i

			var itemData = AllItemMap[curItemType][item_data_index]
			var subItem = mc["item_" + item_MC_index];
			subItem.itemData = itemData;

			subItem.onPress = function()
			{
				this.touch_x = _root._xmouse;
				this.touch_y = _root._ymouse;
				this._parent._parent.onPressedInListbox();
			}
			subItem.onReleaseOutside = function(){
				this._parent._parent.onReleasedInListbox();
			}
			subItem.onRelease=function()
			{
				this._parent._parent.onReleasedInListbox();
				if ( (this.itemData == undefined) || (Math.abs(this.touch_x - _root._xmouse) > this._width / 2) ||  (Math.abs(this.touch_y - _root._ymouse) > this._height / 2) ){
					return;
				}
				if( this == curFocusButton){
					return;
				}

				var pt:Object = {x:this.touch_x, y:this.touch_y};
				// trace("pt: " + pt.x + " " + pt.y);
				this._parent._parent.globalToLocal(pt);
				// trace("ptlocal: " + pt.x + " " + pt.y + " py: " + this._parent._parent._getPanelPosY() + " pbottom: " + this._parent._parent._getPanelBottomPosY());
				if(pt.y < this._parent._parent._getPanelPosY() || pt.y > this._parent._parent._getPanelBottomPosY())
				{
					return;
				}

				if ( curFocusButton != undefined )
				{
					curFocusButton.item_icon.SelectIcon(false);
				}
				fscommand("PlaySound", "sfx_ui_selection_3");
				curFocusButton = this
				curFocusButton.item_icon.SelectIcon(true);
				cur_item_data = this.itemData;
				UpdateItemDetail();
			}
			UpdateItemViewMC(subItem);
		}
	}
	ItemsList.onListboxMove = undefined;
	UpdateItemData(inputItemData);
}


function ShowOneTypeItems(itemType , gotoHead)
{
	curItemType = itemType;

	for(var filter_index = Item_type_Whole ; filter_index <= Item_type_Hero ; filter_index++){
		_root.filter_contral[ "filter_button_" + (filter_index + 1) ].gotoAndStop( filter_index == curItemType ? "Selected" : "Normal" );
	}

	var m_cur_ItemList = AllItemMap[curItemType];

	//set default selected item
	if( cur_item_data ){
		var default_item_id = cur_item_data.id;
		cur_item_data = undefined;
		for (var i = 0; i < m_cur_ItemList.length ; i++){
			if( m_cur_ItemList[i].id == default_item_id ){
				cur_item_data = m_cur_ItemList[i];
				break;
			}
		}
	}
	if ( cur_item_data == undefined ){
		cur_item_data = m_cur_ItemList[0];
	}


	var ItemsList = _root.troops_middle.item_view.view_list;

	var change_row_num = Math.ceil(m_cur_ItemList.length / item_list_mc_length) - ItemsList.getItemListLength();

	while(change_row_num < 0){
		ItemsList.eraseItem(ItemsList.getItemListLength())
		change_row_num ++ 
	}

	for(var i = 0 ; i < ItemsList.getItemListLength() ; i ++){
		var item_plane_MC = ItemsList.getMcByItemKey(i + 1)
		for(var j = 0 ; j < item_list_mc_length ; j++){
			var item_view_MC = item_plane_MC["item_" + (j + 1)];
			item_view_MC.itemData = m_cur_ItemList[i * item_list_mc_length + j];
			UpdateItemViewMC(item_view_MC);
		}
	}

	for( i = ItemsList.getItemListLength() ; change_row_num > 0 ; i ++)
	{   
	    ItemsList.addListItem(i + 1, false, false);
	    change_row_num --;
	}

	if(gotoHead == true){
		ItemsList.setItemPos(1, "head", 0)
	}
	UpdateItemDetail();
}

function UpdateItemViewMC(item_MC:Object){
	if(item_MC.itemData == undefined)
	{
		item_MC._visible=false
	}
	else{
		item_MC._visible=true
		item_MC.item_bg._visible = false;
		item_MC.cue_effect._visible = item_MC.itemData.cue_new == true ? true : false;
		item_MC.item_level._visible=false

		if(item_MC.item_icon.icons==undefined)
		{
			item_MC.item_icon.loadMovie("CommonIcons.swf");
		}

		item_MC.item_icon.IconData = item_MC.itemData.icon_data;
		if ( item_MC.item_icon.UpdateIcon ) { item_MC.item_icon.UpdateIcon(); }
		item_MC.item_num.text = Math.min(item_MC.itemData.count, item_MC.itemData.max_num);

		if( item_MC.itemData.id == cur_item_data.id ){
			item_MC.item_icon.m_selected = true;
			curFocusButton = item_MC;
		}
		else{
			item_MC.item_icon.m_selected = false;
		}
		if ( item_MC.item_icon.SelectIcon ) { item_MC.item_icon.SelectIcon(); }
	}	
}


_root.Title_plane.btn_close.onRelease=function()
{
	fscommand("PlaySound", "sfx_ui_cancel");
	move_out();
}


function virtual_use_exp_item(Hero_item_view:Object,hero_exp:Number,exp_frame_time:Number){
	var m_hero_data = Hero_item_view.HeroData;
	var ori_process = Math.floor(m_hero_data.curExp / m_hero_data.nextExp * 100);
	Hero_item_view.exp_process_bar.onEnterFrame = undefined;
	Hero_item_view.exp_process_bar.gotoAndStop( ori_process )
	var first_round_frame_num = 100 - ori_process;
	var exp_process_totle_frame_num = 0;
	m_hero_data.curExp += hero_exp;
	while(m_hero_data.curExp >= m_hero_data.nextExp && m_hero_data.nextExp > 0 ){
		m_hero_data.curExp -= m_hero_data.nextExp;
		m_hero_data.level ++;
		if ( m_hero_data.level > m_Hero_Limit_Level){
			m_hero_data.level = m_Hero_Limit_Level;
			m_hero_data.curExp = m_hero_data.nextExp - 1;
			//exp_process_totle_frame_num = exp_process_totle_frame_num == 0 ? 0 : exp_process_totle_frame_num;
		}
		else{
			exp_process_totle_frame_num = exp_process_totle_frame_num == 0 ? first_round_frame_num : exp_process_totle_frame_num + 100;
			m_hero_data.nextExp = m_Hero_exp_database[m_hero_data.level - 1];
		}
	}
	var exp_end_process_num = m_hero_data.nextExp > 0 ? Math.floor(m_hero_data.curExp / m_hero_data.nextExp * 100) : 100;
	exp_process_totle_frame_num = exp_process_totle_frame_num == 0 ? exp_end_process_num - ori_process : exp_process_totle_frame_num + exp_end_process_num;
	Hero_item_view.exp_process_bar.totle_frame_num = exp_process_totle_frame_num;
	Hero_item_view.exp_process_bar.end_frame = exp_end_process_num;
	Hero_item_view.exp_process_bar.totle_frame_time = exp_frame_time;
	Hero_item_view.exp_process_bar.frame_time = 0;
	Hero_item_view.exp_process_bar.cur_exactframe = Hero_item_view.exp_process_bar._currentframe;
	Hero_item_view.exp_process_bar.onEnterFrame = function(){
		trace("xxxxxxxxxxxxxxxxxxxxxxxxxx")
		this.frame_time ++;
		trace(this.frame_time)
		trace(this.totle_frame_time)
		if( this.frame_time >= this.totle_frame_time){
			this.onEnterFrame = undefined;
			trace("hhhhhhhhhhhhhhhhhhhhhhhhhh")
			UpdateHeroViewItem(this._parent);
			
			return;
			
		}
		var round_exactframe = this.totle_frame_num / this.totle_frame_time;
		this.cur_exactframe += round_exactframe;
		if ( this.cur_exactframe > 100 ){
			trace("mmmmmmmmmmmmmmmmmmmm")
			this._parent.level_text.text = "LV." + this._parent.HeroData.level;
			this._parent.hero_lv_up_plane._visible = true;
			this._parent.hero_lv_up_plane.gotoAndPlay("play_level_up");
			while( (this.cur_exactframe -= 100) > 100);
		}
		this.gotoAndStop(Math.ceil(this.cur_exactframe));
	}
}