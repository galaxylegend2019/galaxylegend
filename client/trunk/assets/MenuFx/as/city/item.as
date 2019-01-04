var Obj = new Array();
Obj = [icon_league_0, icon_league_1, icon_league_2, icon_league_3, icon_league_4,icon_league_5];
var Pos = new Array();
Pos = [-100,0,100,200,300,400]
var ObjPos = new Array();
ObjPos = [-100,0,100,200,300,400];

var ObjLength = 6;

var stdWidth=icon_league_3._width;
var stdHeight=icon_league_3._height;
var stdx=icon_league_3._x;
var stdy=icon_league_3._y;

for(var i=0;i<ObjLength;i++)
{
	Obj[i]._width=stdWidth;
	Obj[i]._height=stdHeight;
	Obj[i]._x = stdx;
	Obj[i]._y = stdy;

	Pos[i]=Pos[i]+60
}

this._parent.resetAll(Obj,Pos,ObjPos,ObjLength);

var touchzone=this._parent.touchzone
touchzone.onPress = function() {
	this._parent.setAllVar(Obj,Pos,ObjPos,ObjLength,this);
	this._parent.OnPress(this._parent._ymouse,false);
	this.onEnterFrame = this._parent.Roll;
};

touchzone.onDragOut = touchzone.onRelease=touchzone.onReleaseOutside=touchzone.onRollOut=function () {
	//this.onEnterFrame = null;
	if(this.onEnterFrame == null){
		return;
	}
	this.onEnterFrame = this._parent.BackCenter;
	//this.onEnterFrame = null;
};