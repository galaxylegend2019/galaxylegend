/*								ComponentName
**
** instanciation howto
*********Properties****************************Description******
**prop:Type						//Desc
*********Methods****************************Description*******
**function():Void				//Desc
*********Events*****************************Description*******
**onEvent()						//Desc

*********TODO*************************************************
**
*/
[IconFile("icons/ParticleEmitterLine.png")]
class com.tap4fun.components.animation.ParticleEmitterLine extends com.tap4fun.components.ComponentBase
{
	static var symbolName:String = "ParticleEmitterLine";
	static var symbolOwner:Object = ParticleEmitterLine;
	var className:String = "ParticleEmitterLine";
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Private Properties										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	[Inspectable(defaultValue=0.5)]
	public var sizeMin:Number;
	[Inspectable(defaultValue=1)]
	public var sizeMax:Number;
	[Inspectable(defaultValue=25)]
	public var density:Number;
	[Inspectable(defaultValue=10)]
	public var speed:Number;
	[Inspectable(defaultValue=30)]
	public var particleLife:Number;
	[Inspectable(defaultValue=3)]
	public var wind:Number;
	[Inspectable(defaultValue=0.01)]
	public var friction:Number;
	[Inspectable(defaultValue=0.5)]
	public var weightJitter:Number;
	
	public var particle:MovieClip;
	public var emitter:MovieClip;
	private var particles:Array;
	private var _sizeRange:Number;
	private var _needPropsUpdate:Boolean;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Constructor											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	function ParticleEmitterLine()
	{
		this.setSizeMin(this.sizeMin);
		this.setSizeMax(this.sizeMax);
		this.setDensity(this.density);
		this.setSpeed(this.speed);
		this.setParticleLife(this.particleLife);
		this.setWind(this.wind);
		this.setFriction(this.friction);
		this.setWeightJitter(this.weightJitter);
		
		this.emitter._visible = false;
		this.particle._visible = false;
		this.particles = new Array();
		//this.start();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Private Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	private function update():Void
	{
		var $particle:MovieClip;
		
		if(this.particles.length < this.density)
		{
			var $newParticle:MovieClip = this.particle.duplicateMovieClip("part" + this.particles.length, this.getNextHighestDepth());
			
			this.initializeParticle($newParticle);
			this.resetParticle($newParticle);
			
			this.particles.push($newParticle);
		}
		
		for(var $i:Number = 0; $i < this.particles.length; ++$i)
		{
			$particle = this.particles[$i];
			if (this._needPropsUpdate) this.initializeParticle($particle);
			this.updateParticle($particle);
		}
		this._needPropsUpdate = false;
	}
	private function initializeParticle($particle:MovieClip):Void
	{
		$particle.gotoAndStop(random($particle._totalframes) + 1);
		$particle.weight = 1 + (Math.random() * this.weightJitter);
		$particle.windImpact = this.wind * $particle.weight;
		
		$particle._xscale = $particle._yscale = ((Math.random() * _sizeRange) + this.sizeMin) * 100;
		$particle.speedDec = this.friction * $particle.weight;
	}
	private function resetParticle($particle:MovieClip):Void
	{
		$particle.i = this.particles.length;
		$particle.life = this.particleLife;
		
		$particle.speed = this.speed;
		
		$particle._x = random(this.emitter._width) + this.emitter._x;
		$particle._y = this.emitter._y + Math.random()*this.speed;
	}
	private function updateParticle($particle:MovieClip):Void
	{
		if($particle.life <= 0)
		{
			this.resetParticle($particle);
		}
		
		$particle._y 	+= ($particle.speed * $particle.weight);
		$particle._x	+= $particle.windImpact;
		$particle.speed	-= $particle.speedDec;
		
		$particle.life--;
	}
	private function updateSizeRange():Void
	{
		this._sizeRange = this.sizeMax - this.sizeMin;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//											Public Methods										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function start():Void
	{
		this._needPropsUpdate = true;
		this.onEnterFrame = this.update;
	}
	public function pause():Void
	{
		delete this.onEnterFrame;
	}
	public function stop():Void
	{
		delete this.onEnterFrame;
		for(var $i:Number = 0; $i < this.particles.length; $i++)
		{
			var $cur:MovieClip = this.particles[$i];
			$cur.removeMovieClip();
		}
		this.particles = Array();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//										Getters and Setters										//
	//////////////////////////////////////////////////////////////////////////////////////////////////
	public function setSizeMin($size:Number):Void
	{
		this.sizeMin = $size;
		this.updateSizeRange();
		
		this._needPropsUpdate = true;
	}
	public function getSizeMin():Number
	{
		return this.sizeMin;
	}
	public function setSizeMax($size:Number):Void
	{
		this.sizeMax = $size;
		this.updateSizeRange();
		
		this._needPropsUpdate = true;
	}
	public function getSizeMax():Number
	{
		return this.sizeMax;
	}
	public function setDensity($density:Number):Void
	{
		this.density = $density;
		
		this._needPropsUpdate = true;
	}
	public function getDensity():Number
	{
		return this.density;
	}
	public function setSpeed($speed:Number):Void
	{
		this.speed = $speed;
		
		this._needPropsUpdate = true;
	}
	public function getSpeed():Number
	{
		return this.speed;
	}
	public function setParticleLife($life:Number):Void
	{
		this.particleLife = $life;
		
		this._needPropsUpdate = true;
	}
	public function getParticleLife():Number
	{
		return this.particleLife;
	}
	public function setWind($wind:Number):Void
	{
		this.wind = $wind;
		
		this._needPropsUpdate = true;
	}
	public function getWind():Number
	{
		return this.wind;
	}
	public function setFriction($friction:Number):Void
	{
		this.friction = $friction;
		
		this._needPropsUpdate = true;
	}
	public function getFriction():Number
	{
		return this.friction;
	}
	public function setWeightJitter($jitter:Number):Void
	{
		this.weightJitter = $jitter;
		
		this._needPropsUpdate = true;
	}
	public function getWeightJitter():Number
	{
		return this.weightJitter;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	//												Events											//
	//////////////////////////////////////////////////////////////////////////////////////////////////
}