package one_arrow.gameplay.projectiles 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import one_arrow.events.ProjectileEvent;
	import one_arrow.gameplay.GameplayMain;
	import nape.callbacks.CbEvent;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import one_arrow.gameplay.character.MainCharacter;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Projectile extends Sprite 
	{
		public static const TYPE_ENERGY_BALL:int = 0;
		public static const PROJECTILE_CB_TYPE:CbType = new CbType();
		
		protected var _main:GameplayMain;
		
		protected var _animation:MovieClip;
		
		public function get body():Body { return _body; }
		protected var _body:Body;
		
		public var type:int;
		
		public var destroyed:Boolean = false;
		
		public function Projectile(gameplayMain:GameplayMain, newType:int = 0) 
		{
			mouseEnabled = false;
			mouseChildren = false;
		
			_main = gameplayMain;
			
			_body = new Body(BodyType.KINEMATIC);
			_body.userData.graphic = this;
			
			var cbType:CbType = new CbType();
			
			var sensor = new Circle(5);
			sensor.material.density = 0;
			sensor.sensorEnabled = true;
			sensor.cbTypes.add(cbType);
			sensor.body = _body;
			
			_main.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.SENSOR,
				cbType,
				MainCharacter.CHARACTER_CB_TYPE,
				onPlayerHit
			));
			
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
			destroyed = true;
			dispatchEvent(new ProjectileEvent(this,ProjectileEvent.DESTROY));
		}
		
		public function setPosition(position:Point):void
		{
			_body.position.set(new Vec2(position.x, position.y));	
		}
		
		protected function onPlayerHit(cb:InteractionCallback):void
		{
			if(!_main.character.isDamaged()) (_main.character as MainCharacter).takeDamage();
			
			destroy();
		}
	}

}