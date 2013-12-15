package one_arrow.gameplay.projectiles 
{
	import flash.display.Sprite;
	import one_arrow.gameplay.GameplayMain;
	
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
			_projectiles = new Vector.<Character>;
		}
		
		public function update():void
		{
			for (var i:int = 0; i < _projectiles.length; i++){
				_projectiles[i].update();
			}
		}
		
		public function createProjectile():void
		{
			
		}
	}

}