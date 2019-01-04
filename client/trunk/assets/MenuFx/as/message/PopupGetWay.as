
var ui_all=_root.item_origin_page
var origin_content=ui_all.pop_content

this.onLoad=function()
{
/*	var item_icon=origin_content.item_origin.item_info.reward_icon.item_icon
	item_icon.loadMovie("CommonIcons.swf")*/
	
	_root._visible=false
}

function SetUIPlay()
{
	_root._visible=true
	origin_content.gotoAndPlay("opening_ani")
}


function SetOriginData(mc,datas,picIndex)
{
	mc._visible=true

	if(datas.openState==true)
	{
		mc.origin_info.gotoAndStop(1)
	}else
	{
		mc.origin_info.gotoAndStop(2)
	}
	//-----------for name info
	var info=mc.origin_info
	info.chapter_text.htmlText=datas.chapterName
	info.name_text.htmlText=datas.originName

	//-----------for origin info
	//var info=mc.origin_info
	//info.lock_pic._visible=!datas.openState
	//info.count.count_text.text=datas.count
	info.count.count_text.htmlText=datas.countText

	info.pic.gotoAndStop(picIndex)
}


function SetItemData(inputData)
{
	SetUIPlay()

	var mc_item_origin=origin_content.item_origin

	//----------for item info
	var  item_info=mc_item_origin.item_info

	//var item_icon=item_info.reward_icon
	if(item_info.reward_icon.icons==undefined)
	{
		item_info.reward_icon.loadMovie("CommonIcons.swf")
	}
	//item_icon.icons.icons.gotoAndStop("item_"+inputData.id)
	item_info.reward_icon.IconData=inputData.iconData
	if(item_info.reward_icon.UpdateIcon) 
	{
		item_info.reward_icon.UpdateIcon()
	}

	item_info.name_text.htmlText=inputData.itemName
	//item_info.count_text.text=inputData.count
	item_info.count_text.htmlText=inputData.numText

	//----------for origin data
	var MAX_ORIGIN=3
	for(var i=0;i<MAX_ORIGIN;i++)
	{
		var mc_origin=mc_item_origin["origin_"+(i+1)]
		var originData=inputData.originDatas[i]

		mc_origin.originData=originData
		
		if(originData!=undefined)
		{
			SetOriginData(mc_origin,originData,(i+1))
		}else
		{
			mc_origin._visible=false
		}

		mc_origin.onRelease=function()
		{
			fscommand("PlayMenuConfirm")
			var id=this.originData.originID
			var originType=this.originData.originType
			if(this.originData.openState==true)
			{
				ui_all.page_cover.onRelease()
				fscommand("LoadAnimationCmd","Goto"+'\2'+originType+'\2'+id)
			}else
			{
				fscommand("LoadAnimationCmd","Lock"+'\2'+originType)
			}
		}
	}

	ui_all.page_cover.onRelease=hideWindonw

}


//------------------------for page close 
origin_content.btn_close.onRelease=function()
{
	fscommand("PlayMenuBack")
	ui_all.page_cover.onRelease()
}


function hideWindonw()
{
	ui_all.page_cover.onRelease=undefined
	origin_content.gotoAndPlay("closing_ani")
	origin_content.OnMoveOutOver=function()
	{
		_root._visible=false
		this.OnMoveOutOver=undefined
	}
	fscommand("LoadAnimationCmd", "CloseItemGetWay");
}

