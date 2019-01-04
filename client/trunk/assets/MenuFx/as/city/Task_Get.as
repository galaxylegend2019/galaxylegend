import com.tap4fun.utils.Utils;



_root.onLoad=function()
{
	_root.task_result._visible=false;
}

_root.task_result.btn_bg.onRelease = function()
{
	//no click through
}

_root.task_result.btn_frame_bg.onRelease = function()
{
	//no click through
}

function ShowAwardResult(datas)
{
	var mc_result=_root.task_result
	mc_result._visible=true
	var mc=mc_result

	mc_result.gotoAndPlay("opening_ani");
	mc_result.OnMoveInOver = function()
	{
		_root.task_result.btn_bg.onRelease = function()
		{
			HideAward();
			fscommand("PlayMenuBack");
			_root.task_result.btn_bg.onRelease = function()
			{
				//no click through
			}
		}
	}

	var MAX_LENGTH=7
	var awardLength=datas.length
	mc.icons.gotoAndStop(Math.min(datas.length, MAX_LENGTH));
	for(var i=0;i<MAX_LENGTH;i++)
	{	
		trace("------i=" + i);
		var award=mc.icons["item"+(i+1)]

		if(i<awardLength)
		{
			award._visible=true
			award.bg._visible = false
			var awardData=datas[i]

			//for the item color(quality)
			//award.gotoAndStop(1)

			award.num_text.text=awardData.count
			if(award.item_icon.icons==undefined)
			{
				var w = award.item_icon._width;
				var h = award.item_icon._height;
				award.item_icon.loadMovie("CommonIcons.swf")
				award.item_icon._width = w;
				award.item_icon._height = h;
			}
			// award.item_icon.icons.gotoAndStop("item_"+awardData.id)
			award.item_icon.IconData = awardData.iconInfo
			if (award.item_icon.UpdateIcon) { award.item_icon.UpdateIcon(); }
/*			award.item_icon._width=25
			award.item_icon._height=25*/

			award.res_type = awardData.res_type
			award.res_id = awardData.id

			award.onRelease = function()
			{
				this.item_icon.SelectIcon(true);
				fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
			}

			// if(awardData.res_type == "item")
			// {
			// 	award.onPress = function()
			// 	{
			// 		this.item_icon.SelectIcon(true);
			// 		fscommand("PopupBoxMgrCmd","PopupItemInfo\2" + this.res_type + "\2" + this.res_id + "\2" + _root._xmouse + "\2" + _root._ymouse);
			// 	}
			// 	award.onRelease = award.onReleaseOutside = function()
			// 	{
			// 		this.item_icon.SelectIcon(false);
			// 		fscommand("PopupBoxMgrCmd","CloseAllPopupBox");
			// 	}
			// }
			// else
			// {
			// 	award.onPress = undefined;
			// 	award.onRelease = undefined;
			// }
		}else
		{
			award._visible=false
		}
	}

}

function HideAward()
{
	var mc_result = _root.task_result
	mc_result.gotoAndPlay("closing_ani");
	mc_result.OnMoveOutOver = function()
	{
		this._visible = false;
	}

	fscommand("TutorialCommand","Activate" + "\2" + "CloseTaskAward");
}