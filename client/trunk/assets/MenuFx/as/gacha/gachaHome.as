var all_view_mov_object_list : Array = [ _root.main_ui , _root.advanced_gacha_plane , _root.normal_gacha_plane ];
var all_view_static_object_list : Array = [ ];
var Is_MovedIn : Boolean = false;

var move_out_target = "";

this.onLoad = function(){
	/*******FTE*******/
	fscommand("TutorialCommand","TutorialComplete" + "\2" + "GachaHomeUILoad");
	/*******End*******/
	init();
	//move_in();
}


function reset(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndStop("opening_ani");
		all_view_mov_object_list[i]._visible = false;
	}
}

function init(){
	init_function_area();
	reset();
}

function init_function_area(){
	_root.main_ui.btn_close.onRelease = function(){
		if(_root.main_ui.is_moved_in)
		{
			_root.main_ui.OnMoveOutOver = function(){
				fscommand("GotoNextMenu","GS_MainMenu");
			}
			move_out();
			// fscommand("PlayMenuBack");
			fscommand("PlaySound", "sfx_ui_cancel");
			/*******FTE*******/
			fscommand("TutorialCommand","TutorialComplete" + "\2" + "ClickGachaHomeCloseBtn");
			/*******End*******/
		}
	}

	_root.main_ui.OnMoveInOver = function()
	{
		this.is_moved_in = true;
	}

	// _root.advanced_gacha_plane.btn_gacha.onRelease = function(){
	// 	fscommand("GachaCommand","SetGachaMode\2"+"2\2" + "1");
	// 	fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
	// }

	_root.advanced_gacha_plane.btn_gacha_10.onRelease = function(){
		fscommand("GachaCommand","SetGachaMode\2"+"2\2" + "10");
		fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_confirm_purchase");
	}

	// _root.normal_gacha_plane.btn_gacha.onRelease = function(){
	// 	fscommand("GachaCommand","SetGachaMode\2"+"1\2" + "1");
	// 	fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
	// }

	_root.normal_gacha_plane.btn_gacha_10.onRelease = function(){
		fscommand("GachaCommand","SetGachaMode\2"+"1\2" + "10");
		fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_confirm_purchase");
	}

	_root.main_ui.money.btn_add.onRelease = function()
	{
		MoveOutToBuy("Affair");
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_selection_1");
	}
	_root.main_ui.credit.btn_add.onRelease = function()
	{
		MoveOutToBuy("Purchase");
		// fscommand("PlayMenuConfirm");
		fscommand("PlaySound", "sfx_ui_selection_1");
		
	}
	_root.main_ui.energy.btn_add.onRelease = function()
	{
		if(move_out_target == "")
		{
			fscommand("GoToNext", "Energy");
			// fscommand("PlayMenuConfirm");
			fscommand("PlaySound", "sfx_ui_selection_1");
		}
	}
}

function move_in(){
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i]._visible = true;
		all_view_mov_object_list[i].gotoAndPlay("opening_ani");
	}
}

function move_out(){
	_root.main_ui.is_moved_in = false;
	for(var i = 0 ; i < all_view_mov_object_list.length ; i++){
		all_view_mov_object_list[i].gotoAndPlay("closing_ani");
	}
}

function MoveOutToGacha()
{
	_root.main_ui.OnMoveOutOver = function(){
		reset();
		fscommand("GoToNext","gacha");
	}
	move_out();
}

function MoveOutToBuy(where)
{
	move_out_target = where;
	_root.main_ui.OnMoveOutOver = function(){
		reset();
		if(move_out_target != "")
		{
			if(move_out_target == "Back")
			{
				fscommand("ExitBack", "");
			}
			else
			{
				fscommand("GoToNext", move_out_target);
			}
			move_out_target = "";
		}
		fscommand("RejectTexture", "FlashGachaHomeUI");
	}
	move_out();
}

function SetGachaInfo(gachaType, isFree, numTxt, timeTxt, priceTxt, price10Txt, discountNum, infoTxt)
{
	var clip = (gachaType == "normal") ? _root.normal_gacha_plane : _root.advanced_gacha_plane;

	if(timeTxt != "")
	{
		if(gachaType == "normal")
		{
			clip.timeBar.gotoAndStop(2);
		}
		// clip.timeBar.txt_Num._visible = false;

		// clip.timeBar.txt_FreeAfter._visible = true;
		clip.timeBar.txt_Time._visible = true;
		clip.timeBar.txt_Time.htmlText = timeTxt;
	}
	else
	{
		if(gachaType == "normal")
		{
			clip.timeBar.gotoAndStop(1);
		}
		// clip.timeBar.txt_Num._visible = true;
		clip.timeBar.txt_Num.text = numTxt;

		// clip.timeBar.txt_FreeAfter._visible = false;
		clip.timeBar.txt_Time._visible = false;
	}

	if(isFree)
	{
		clip.gacha1.gotoAndStop(1);
		if(gachaType == "normal")
		{
			clip.gacha1.btn_gacha.onRelease = function(){
				fscommand("GachaCommand","SetGachaMode\2"+"1\2" + "1");
				fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
				// fscommand("PlayMenuConfirm");
				fscommand("PlaySound", "sfx_ui_selection_1");
			}
		}
		else
		{
			clip.gacha1.btn_gacha.onRelease = function(){
				fscommand("GachaCommand","SetGachaMode\2"+"2\2" + "1");
				fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
				// fscommand("PlayMenuConfirm");
				fscommand("PlaySound", "sfx_ui_selection_1");
			}
		}
	}
	else
	{
		clip.gacha1.gotoAndStop(2);
		clip.gacha1.btn_gacha.txt_Price.text = priceTxt;
		if(gachaType == "normal")
		{
			clip.gacha1.btn_gacha.onRelease = function(){
				fscommand("GachaCommand","SetGachaMode\2"+"1\2" + "1");
				fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
				// fscommand("PlayMenuConfirm");
				fscommand("PlaySound", "sfx_ui_confirm_purchase");
			}
		}
		else
		{
			clip.gacha1.btn_gacha.onRelease = function(){
				fscommand("GachaCommand","SetGachaMode\2"+"2\2" + "1");
				fscommand("GachaCommand","CheckGotoGacha" + "\2" + "home");
				// fscommand("PlayMenuConfirm");
				fscommand("PlaySound", "sfx_ui_confirm_purchase");
			}
		}
	}

	// clip.timeBar.txt_Time.text = timeTxt;
	// clip.timeBar.txt_FreeAfter._visible = timeTxt != "";
	// clip.btn_gacha.txt_Price.text = priceTxt;
	clip.btn_gacha_10.txt_Price.text = price10Txt;
	if(clip.btn_gacha_10.discount)
	{
		if(discountNum < 100)
		{
			clip.btn_gacha_10.discount._visible = true;
			clip.btn_gacha_10.discount.num.txt_Num.text = discountNum + "%";
		}
		else
		{
			clip.btn_gacha_10.discount._visible = false;
		}
	}
	clip.txt_Info.txt_Info.text = infoTxt;
}

function SetMoney(moneyTxt, creditTxt, energyTxt)
{
	_root.main_ui.money.money_text.text = moneyTxt;
	_root.main_ui.credit.credit_text.text = creditTxt;
	_root.main_ui.energy.energy_text.text = energyTxt;
}

