package one_arrow.gameplay.projectiles.types 
{
	import nape.geom.Vec2;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.projectiles.Projectile;
	import one_arrow.Config;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class EnergyBall extends Projectile
	{
		protected static const SPEED:Number = Config.PROJECTILE_ENERGY_BALL_SPEED;
		private var _lifeFramesLeft:int;
		
		public function EnergyBall(gameplayMain:GameplayMain) 
		{
			super(gameplayMain,TYPE_ENERGY_BALL);
			
			addChild(new Enemy03Projectile());
			
			_lifeFramesLeft = Config.PROJECTILE_ENERGY_BALL_LIFE_SECONDS*_main.stage.frameRate;
		}
		
		public override function update():void
		{
			super.update();
			
			if (--_lifeFramesLeft < 0)
				destroy();
														
			var direction:Vec2 = _main.character.physicalBody.position.sub(_body.position);
			direction.y += _main.character.halfHeight;
			direction.normalise();
			
			_body.position = _body.position.add(direction.mul(SPEED));
		}
	}

}