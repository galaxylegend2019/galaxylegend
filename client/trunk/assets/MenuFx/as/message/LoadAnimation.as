 this.onLoad=function()
 {
 	_root._visible=false
 }

 function SetUIPlay(flag)
 {
 	_root._visible=true
 	trace(this._visible)
 	if(flag==true)
 	{
 		_root.ani.gotoAndPlay("opening_ani")
 		trace(_root.ani)
 	}else
 	{
 		_root.ani.gotoAndPlay("closing_ani")
 	}
 }

 _root.ani.OnMoveInOver=function()
 {
 	fscommand("LoadAnimationCmd","MoveInOver")
 }
 
 _root.ani.OnMoveOutOver=function()
 {
 	_root._visible=false
 	fscommand("LoadAnimationCmd","MoveOutOver")	
 } 