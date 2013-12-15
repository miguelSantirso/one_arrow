package one_arrow.gameplay.projectiles.types 
{
	import flash.events.Event;
	import nape.geom.Vec2;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.projectiles.Projectile;
	import one_arrow.Config;
	import utils.FrameScriptInjector;
	import one_arrow.gameplay.fx.AutoFx;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class EnergyBall extends Projectile
	{
		protected static const SPEED:Number = Config.PROJECTILE_ENERGY_BALL_SPEED;
		protected static const HIT_ANIMATION_COMPLETE:String = "hitAnimationCompleteEvent";
		
		private var _lifeFramesLeft:int;
		
		public function EnergyBall(gameplayMain:GameplayMain) 
		{
			super(gameplayMain,TYPE_ENERGY_BALL);
			
			_animation = new Enemy03Projectile();
			addChild(_animation);
			
			_lifeFramesLeft = Config.PROJECTILE_ENERGY_BALL_LIFE_SECONDS*_main.stage.frameRate;
		}
		
		public override function dispose():void
		{
			super.dispose();
		}
		
		public override function update():void
		{
			super.update();
			
			if (destroyed) {
				// TODO The projectile looks like is not being removed right
				//trace("FUCK");
				return;
			}
			
			if (--_lifeFramesLeft < 0)
				destroy();
														
			var direction:Vec2 = _main.character.physicalBody.position.sub(_body.position);
			direction.y -= _main.character.halfHeight;
			direction.normalise();
			
			_body.position = _body.position.add(direction.mul(SPEED));
		}
		
		protected override function destroy():void
		{
			super.destroy();
			
			AutoFx.showFx(new Enemy03ProjectileHit(), _body.position.x, _body.position.y);
			
			dispose();		
		}
	}

}