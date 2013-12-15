package one_arrow.gameplay.projectiles 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import one_arrow.events.ProjectileEvent;
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
					newProjectile = new EnergyBall(_main);
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
			
			newProjectile.addEventListener(ProjectileEvent.DESTROY, onProjectileDestroy,false,0,true);
		}
		
		protected function onProjectileDestroy(evt:ProjectileEvent):void
		{
			if (evt.type == ProjectileEvent.DESTROY) {
				evt.protectile.removeEventListener(ProjectileEvent.DESTROY, onProjectileDestroy);
				
				var index:int = _projectiles.indexOf(evt.protectile);
				if (index > 0 && index < _projectiles.length)
					_projectiles.splice(index, 1);
				
				_main.physicalWorld.removeBody(evt.protectile.body);
				
				if (contains(evt.protectile))
					removeChild(evt.protectile);
					
				trace("projectiles left",_projectiles.length);
			}
		}
	}

}