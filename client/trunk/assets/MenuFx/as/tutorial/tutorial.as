var noshadow_rect:Object = undefined;
var shadow_list:Array = undefined;
var m_dialogueList:Array = undefined;
var m_isShowShadow:Boolean = false;
var m_isAllResponce:Boolean = false;
var guide_anim:Object = undefined;
var is_shadowShow:Boolean = false;
var cur_dialogue:Number = 0;
var cur_dialogueUI:Object = undefined;

var cur_stroy_type:Number;
var STORY_TYPE_NONE  = 0;
var STORY_TYPE_STORY = 1;
var STORY_TYPE_GUIDE = 2;

var m_isSentComplate = false;

var isValidPress = false;

var isEmptyGuide = false;

_root.onLoad = function(){
	initShadow();
	reset();
	SetTutorialEnable(false);
}

function SetTutorialEnable( is_enable )
{
	if (is_enable)
	{
		_root._visible = true;
	}else
	{
		_root._visible = false;
	}
}

function reset(){
	_root.Dialogue_guide._visible = false;
	_root.Dialogue_bottom._visible = false;
	SetUIShow(false);
	isValidPress = false;

}

function initShadow(){
	shadow_list = new Array();
	var shadow_layer = _root.shadow_layer;
	for ( var i = 1 ; i <= 4 ; i++ ){
		var new_mov = shadow_layer.attachMovie("shadow_item", "btn_shadow_" + i ,shadow_layer.getNextHighestDepth());
		shadow_list.push(new_mov);
		new_mov._visible = false;
	}
}

function setshadow_rect(empty_rect:Object){
	noshadow_rect = empty_rect;
}


function doTutorial(dialogue_list:Array ,isForceGuide:Number, guide_anim_name : String , guide_rect:Object , y_reverse:Boolean){
	trace("[FTE] doTutorial "+isForceGuide+" list "+dialogue_list+" "+guide_rect.x+" "+guide_anim_name+" "+cur_dialogueUI)

	reset();

	if (y_reverse == true){
		guide_rect.y = _root._height - guide_rect.y;
	}
	m_dialogueList = dialogue_list;

	switch (isForceGuide)
	{
		case 0: 
		m_isShowShadow = false
		m_isAllResponce = false
		break;
		case 1:
		m_isShowShadow = true
		m_isAllResponce = false
		break;
		case 2:
		m_isShowShadow = false
		m_isAllResponce = true
		break;
		case 3:
		m_isShowShadow = true
		m_isAllResponce = true
		break;
	}

	m_isSentComplate = false;
	if( guide_anim != undefined ){
		guide_anim.removeMovieClip();
	}
	guide_anim = undefined;
	if( guide_rect){
		setshadow_rect(guide_rect);
		if (guide_anim_name){
			guide_anim = _root.anim_layer.attachMovie( guide_anim_name , "guide_arrow" ,anim_layer.getNextHighestDepth());
			_root.anim_layer.guide_arrow.mc.gotoAndPlay(1)
		}
		if(guide_anim){
			guide_anim._x = guide_rect.x + guide_rect.width / 2
			guide_anim._y = guide_rect.y + guide_rect.height / 2;
			guide_anim._visible = false;
		}

	}
	cur_dialogue = 0;
	playTutorial();
}

function playTutorial(){
	var cur_dialogue_info = m_dialogueList[cur_dialogue];
	
	if ( cur_dialogue_info == undefined ){
		cur_stroy_type = STORY_TYPE_GUIDE;
		isEmptyGuide = true;
		cur_dialogueUI = undefined;
		return;
	}
	switch(cur_dialogue_info.type){
		case 0:
			cur_stroy_type = STORY_TYPE_GUIDE;
			cur_dialogueUI = _root.Dialogue_guide;
			cur_dialogueUI._x = cur_dialogue_info.pos.x;
			cur_dialogueUI._y = cur_dialogue_info.pos.y;
			
			if (cur_dialogue_info.pos.x == undefined and cur_dialogue_info.pos.y == undefined)
			{
				cur_dialogueUI.content_view._visible = false;
				cur_dialogueUI.head._visible = false;
			}else
			{
				cur_dialogueUI.content_view._visible = true;
				cur_dialogueUI.head._visible = true;
				cur_dialogueUI.content_view.content_text.htmlText = cur_dialogue_info.content_text;
			}
			cur_dialogueUI._visible = true;
			cur_dialogueUI.gotoAndPlay("opening_ani");
			if ( m_isShowShadow ) { showshadow_rect(noshadow_rect); }
			if ( guide_anim ) { guide_anim._visible = true; guide_anim.play_anim(); }
		break;
		case 1:
			cur_stroy_type = STORY_TYPE_STORY;
			cur_dialogueUI = _root.Dialogue_bottom;
			SetDialogInfo(cur_dialogue_info.dir, cur_dialogue_info.npc, cur_dialogue_info.content_text, cur_dialogue_info.name_txt);
			cur_dialogueUI._visible = true
			cur_dialogueUI.gotoAndPlay("opening_ani");
		break;
		default:
	}

	trace("[FTE] playTutorial "+cur_dialogueUI._name+" "+cur_dialogueUI._visible)

	if (cur_dialogue_info.ID != 10000)
	{
		fscommand("TutorialCommand","StartDialog\2"+cur_dialogue_info.content_id);
	}

	SetUIShow(true);
}

function showshadow_rect(noshadow_rect){
	//is_shadowShow = true;
	var shadow_mov = shadow_list[0];
	shadow_mov._visible = true;
	shadow_mov._x = 0;
	shadow_mov._y = 0;
	shadow_mov._height = _root.Stage.height;
	shadow_mov._width = noshadow_rect.x;

	shadow_mov = shadow_list[1];
	shadow_mov._x = noshadow_rect.x;
	shadow_mov._y = 0;
	shadow_mov._height = noshadow_rect.y;
	shadow_mov._width = _root.Stage.width;
	shadow_mov._visible = true;

	shadow_mov = shadow_list[2];
	shadow_mov._x = noshadow_rect.x + noshadow_rect.width;
	shadow_mov._y = noshadow_rect.y;
	shadow_mov._height = _root.Stage.height - new_mov._y;
	shadow_mov._width = _root.Stage.width - new_mov._x;
	shadow_mov._visible = true;

	shadow_mov = shadow_list[3];
	shadow_mov._x = noshadow_rect.x;
	shadow_mov._y = noshadow_rect.y + noshadow_rect.height;
	shadow_mov._height = _root.Stage.height - new_mov._y;
	shadow_mov._width = noshadow_rect.width;
	shadow_mov._visible = true;

	trace("FTE showshadow_rect x "+noshadow_rect.x+" y "+noshadow_rect.y+" w "+noshadow_rect.width+" h "+noshadow_rect.height)
}

function hideshadow(){
	//is_shadowShow = false;
	m_isShowShadow = false;
	for ( var i = 0 ; i < 4 ; i ++ ){
		shadow_list[i]._visible = false;
	}
}

_root.btn_bg.onRelease = function(){
	trace("------[FTE]-------Click Tutorial bg------------"+cur_stroy_type+" is_shadowShow "+m_isShowShadow+" is_Noshadow "+is_Noshadow()+" isEmptyGuide "+isEmptyGuide)
	

	var cur_dialogue_info = m_dialogueList[cur_dialogue];
	if (cur_dialogue_info.ID != 10000)
	{
		fscommand("TutorialCommand","StopDialog\2"+cur_dialogue_info.content_id+"\2"+_root._visible);
	}

	if ( _root._visible == false ) { return false; }

	if ( cur_stroy_type == STORY_TYPE_STORY ){

		cur_dialogueUI.OnMoveOutOver = function(){
			cur_dialogue ++;
			//fscommand("UnlockInput");
			var cur_dialogue_info = m_dialogueList[cur_dialogue];
			if (cur_dialogue_info == undefined)
			{
				reset();
				doneTutorial();
				cur_stroy_type = STORY_TYPE_NONE;
				TutorialPlayOver();
			}else
			{
				playTutorial();
			}
		}
		//fscommand('LockInput');
		cur_dialogueUI.gotoAndPlay("closing_ani");
		return true;
	}else if(cur_stroy_type == STORY_TYPE_GUIDE){
		 
		if (m_isAllResponce) {
			fscommand("TutorialCommand","DoClickCall");
			m_isAllResponce = false;
			m_isShowShadow = false;
			return;
		}
		else {
			if( is_Noshadow() ){
				fscommand("TutorialCommand","DoClickCall");
				m_isShowShadow = false;
				return;
			}
		}
	}else if (cur_stroy_type == STORY_TYPE_NONE){
		trace("------[FTE]--------Cur None Story---------------")
	}
	else{
		trace("error type");
	}
}


function CompleteGuideTutorial()
{
	if ( m_isShowShadow ) { hideshadow(); }
	if ( guide_anim ) { guide_anim._visible = false; }
	doneTutorial();
	cur_stroy_type = STORY_TYPE_NONE;
	if (cur_dialogueUI != undefined)
	{
		
		cur_dialogueUI.OnMoveOutOver = function(){
			TutorialPlayOver();
			reset();
			cur_dialogueUI = undefined;
		}
		
		cur_dialogueUI.gotoAndPlay("closing_ani");

/*
		TutorialPlayOver();
		reset();
		cur_dialogueUI = undefined;
		*/
	}else
	{
		TutorialPlayOver();
		reset();
	}
}

function is_Noshadow(){
	var press_x = _root._xmouse;
	var press_y = _root._ymouse;
	if (press_x < noshadow_rect.x || press_x > noshadow_rect.x + noshadow_rect.width){
		return false;
	}
	else if( press_y < noshadow_rect.y || press_y > noshadow_rect.y + noshadow_rect.height)
	{
		return false;
	}
	return true;
}

function doneTutorial(){
	if (m_isSentComplate) { return ;}

	fscommand("TutorialCommand","DoneTutorial");

	m_isSentComplate = true;
	return;
}

function TutorialPlayOver(){
	fscommand("TutorialCommand","StoryOver");
}

/************************Plot*************************/


//show.dir show.content show.left_npc show.right_npc show.time
function SetDialogInfo( dir, npc ,content, name_txt)
{
	trace("dir=" + dir)
	trace("npc=" + npc)
	trace("content=" + content)
	var content_mc1 = undefined;
	var content_mc2 = undefined;
	var m_Dialog = _root.Dialogue_bottom;
	if (dir == "left")
	{
		m_Dialog.left_npc._visible = true;
		m_Dialog.right_npc._visible = false;
		content_mc2 = m_Dialog.left_npc.TxtLeft.content_txt;
		SetPlayerHead(m_Dialog.left_npc.head, npc);
		m_Dialog.left_npc.name.name_txt.text = name_txt;
		CurDialog = m_Dialog.left_npc;
	}else if (dir == "right")
	{
		m_Dialog.left_npc._visible = false;
		m_Dialog.right_npc._visible = true;
		content_mc1 = m_Dialog.right_npc.TxtRight.content_txt;
		SetPlayerHead(m_Dialog.right_npc.head, npc);
		m_Dialog.right_npc.name.name_txt.text = name_txt;
		CurDialog = m_Dialog.right_npc;
	}

	
	if (content_mc1 != undefined)
	{
		content_mc1.html = true;
		content_mc1.htmlText = content;	
	}
	if (content_mc2 != undefined)
	{
		content_mc2.html = true;
		content_mc2.htmlText = content;
	}
}



function SetPlayerHead( head_mc, name )
{
	if (name == undefined)
	{
		head_mc._visible = false;
	}else
	{
		head_mc._visible = true;	
		head_mc.gotoAndStop(name);
	}
}

function SetUIShow(is_show)
{
	trace("----------------[FTE]SetUIShow=" + is_show)
	_root.shadow_layer._visible = is_show;
	_root.anim_layer._visible = is_show;
}