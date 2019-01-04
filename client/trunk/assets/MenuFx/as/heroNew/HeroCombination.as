var ui_all
var contentText
function InitMC(mc)
{
	ui_all=mc
}



function InitData(inputData:Array)
{
	trace(inputData)
	contentText=inputData.comDesc
	SetCombinationText()

	ui_all.comTitle.com_title.text=inputData.comTitle

	ui_all.btn_close.onRelease=function()
	{
		_root.closeUI()
	}
}

function SetCombinationText()
{
	var listView=ui_all.com_desc.view_list

	listView.clearListBox();
	listView.initListBox("content_text",0,true,true);
	listView.enableDrag(true);
	listView.onEnterFrame = function(){
		this.OnUpdate();
	}

	listView.onItemEnter = function(mc,index_item){
		mc.tt.htmlText=contentText
		mc.bg._height=mc.tt.textHeight
		mc.ItemHeight=mc.bg._height

		mc.onRelease=function(){
			this._parent.onReleasedInListbox();
		}

		mc.onReleaseOutside = function(){
			this._parent.onReleasedInListbox();
		}
		mc.onPress =function(){
			this._parent.onPressedInListbox();
			this.Press_x = _root._xmouse;
			this.Press_y = _root._ymouse;
		}
	}
	listView.addListItem(1, false, false);
}