package one_arrow.events 
{
	import flash.events.Event;
	import one_arrow.gameplay.projectiles.Projectile;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class ProjectileEvent extends Event 
	{
		public static const DESTROY:String = "destroyProjectileEvent"
		protected var _protectile:Projectile;
		
		public function ProjectileEvent(projectile:Projectile, type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			_protectile = projectile;
			
			super(type, bubbles, cancelable);
		}
		
		public function get protectile():Projectile 
		{
			return _protectile;
		}
		
	}

}