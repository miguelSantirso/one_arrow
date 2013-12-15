package one_arrow.gameplay.projectiles.types 
{
	import one_arrow.gameplay.projectiles.Projectile;
	import one_arrow.Config;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class EnergyBall extends Projectile
	{
		private var _lifeFramesLeft:int;
		
		public function EnergyBall() 
		{
			super(TYPE_ENERGY_BALL);
			
			addChild(new Enemy03Projectile());
			
			_lifeFramesLeft = Config.PROJECTILE_ENERGY_BALL_LIFE_SECONDS;
		}
		
		public override function update():void
		{
			super.update();
			
			if (--_lifeFramesLeft < 0)
				destroy();
		}
	}

}