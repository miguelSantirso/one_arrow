package one_arrow.gameplay.projectiles 
{
	import flash.display.Sprite;
	import nape.callbacks.CbType;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Projectile extends Sprite 
	{
		public static const TYPE_ENERGY_BALL:int = 0;
		public static const PROJECTILE_CB_TYPE:CbType = new CbType();
		
		public function get body():Body { return _body; }
		protected var _body:Body;
		
		public var type:int;
		
		public function Projectile(newType:int = 0) 
		{
			type = newType;
		}
		
		public function update():void
		{
			
		}
	}

}