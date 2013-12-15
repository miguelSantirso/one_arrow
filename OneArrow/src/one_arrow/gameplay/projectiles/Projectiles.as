package one_arrow.gameplay.projectiles 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.projectiles.types.EnergyBall;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Projectiles extends Sprite 
	{
		private var _main:GameplayMain;
		private var _projectiles:Vector.<Projectile>;
		
		public function Projectiles(gameplayMain:GameplayMain)
		{
			_main = gameplayMain;
			_projectiles = new Vector.<Projectile>;
		}
		
		public function update():void
		{
			for (var i:int = 0; i < _projectiles.length; i++){
				_projectiles[i].update();
			}
		}
		
		public function createProjectile(type:int,position:Point):void
		{
			var newProjectile:Projectile = null;
			
			switch(type) {
				case Projectile.TYPE_ENERGY_BALL:
					newProjectile = new EnergyBall();
					break;
				default :
					break;
			}
			
			if (newProjectile) {
				addProjectile(newProjectile,position);
			}
		}
		
		protected function addProjectile(newProjectile:Projectile,position:Point):void
		{
			if (!newProjectile)
				return;
				
			addChild(newProjectile);
			newProjectile.setPosition(position);
			_projectiles.push(newProjectile);
			_main.physicalWorld.addBody(newProjectile.body);
		}
	}

}