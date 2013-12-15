package one_arrow.gameplay.projectiles 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import one_arrow.events.ProjectileEvent;
	
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
			mouseEnabled = false;
			mouseChildren = false;
			
			type = newType;
			
			_body = new Body(BodyType.KINEMATIC);
			_body.userData.graphic = this;
			
			init();
		}
		
		public function init():void
		{
			
		}
		
		public function dispose():void 
		{
			
		}
		
		public function update():void
		{
			
		}
		
		protected function destroy():void
		{
			dispatchEvent(new ProjectileEvent(this,ProjectileEvent.DESTROY));
			
			dispose();
		}
		
		public function setPosition(position:Point):void
		{
			_body.position.set(new Vec2(position.x, position.y));
			
		}
	}

}