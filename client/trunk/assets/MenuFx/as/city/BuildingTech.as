import com.tap4fun.utils.Utils;

var ui_all=undefined
var MAX_SKILL_NUM=4
var focusButtons:Array;

this.onLoad=function()
{
/*	ui_all=this

	InitButtons()
	trace("--this.onLoadthis.onLoadthis.onLoadthis.onLoad---")

	InitEvent()*/
	InitMC(_root)
}

function InitMC(mc)
{
	ui_all=mc
	//InitButtons()
	InitEvent()

	ui_all._parent.bg_UI._visible=true
	ui_all.black_bg.onRelease=function()
	{
		this.onRelease=undefined
		ui_all.ui_title.btn_close.onRelease()
	}
	InitSkillIcon()
}

function InitSkillIcon()
{
	for(var i=1;i<=4;i++)
	{
		var skill=ui_all.tech_info["skill_"+i]
		for(var j=1;j<=2;j++)
		{
			var mc_skill_btn=skill["skill_"+j]
			loadSkillIcon(mc_skill_btn.skill_icon,1)
		}
		
		var skillIcon=ui_all.tech_info.choose_info["skill_"+i].skill_icon
		loadSkillIcon(skillIcon,this.skillData.icons)
	}

}

function InitEvent()
{
	ui_all.ui_title.btn_close.onRelease=function()
	{
		ui_all.ui_title.gotoAndPlay("closing_ani")
		ui_all.tech_info.gotoAndPlay("closing_ani")
		ui_all.tech_info.OnMoveOutOver=function()
		{
			ui_all._visible=false
		}
	}
}

function UpdateData(inputData)
{
	//this.tech_info.hoose_info

	//buiding level,techPoint,speed
	ui_all.tech_info.build_level.level_text.text=inputData.level
	ui_all.tech_info.tech_point.tech_point_text.text=inputData.techPoint
	ui_all.tech_info.tech_point_output.point_output_text.text=inputData.pointOutput

	InitButtons(inputData.skillDatas)
}

function InitButtons(skillDatas)
{
	//var 
	focusButtons=new Array()
	for(var i=0;i<MAX_SKILL_NUM;i++)
	{
		var skill=ui_all.tech_info["skill_"+(i+1)]

		for(var j=1;j<=2;j++)
		{
			var mc_skill_btn=skill["skill_"+j]
			var dataIndex=i*2+j-1
			var skillData=skillDatas[dataIndex]

			mc_skill_btn.skillData=skillData


			mc_skill_btn.gotoAndStop(skillData.icons)
			mc_skill_btn.btn_index=i+1

			mc_skill_btn.skill_state._visible=false
			loadSkillIcon(mc_skill_btn.skill_icon,skillData.icons)

			mc_skill_btn.onRelease=function()
			{
				focusButtons[this.btn_index].skill_state._visible=false
				this.skill_state._visible=true

				focusButtons[this.btn_index]=this

				var skillIcon=ui_all.tech_info.choose_info["skill_"+this.btn_index].skill_icon
				loadSkillIcon(skillIcon,this.skillData.icons)
			}
		}
	}

	for(var i=0;i<MAX_SKILL_NUM;i++)
	{
		var skill=ui_all.tech_info.choose_info["skill_"+(i+1)]
		skill.gotoAndStop(i+1)
	}

	for(var i=0;i<MAX_SKILL_NUM;i++)
	{
		var skill=ui_all.tech_info["skill_"+(i+1)]

		for(var j=1;j<=2;j++)
		{
			var mc_skill_btn=skill["skill_"+j]

			if(mc_skill_btn.skillData.isFocus==true)
			{
				mc_skill_btn.onRelease()
			}
		}
	}
}

function loadSkillIcon(mc,icons)
{
	if(mc.icons==undefined)
	{
		mc.loadMovie("CommonHeros.swf")
	}
	mc.icons.gotoAndStop(icons)
}


function InitData(inputData)
{
	ui_all.ui_title.gotoAndPlay("opening_ani")
	ui_all.tech_info.gotoAndPlay("opening_ani")



	UpdateData(inputData)
}

