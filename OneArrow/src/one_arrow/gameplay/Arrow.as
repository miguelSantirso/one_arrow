package one_arrow.gameplay 
{
	import flash.display.Sprite;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import one_arrow.gameplay.world.PhysicalWorld;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Arrow extends Sprite 
	{
		public static const ARROW_CB_TYPE:CbType = new CbType();
		public static const ARROW_THROW_CB_TYPE:CbType = new CbType();
		
		private var _gameplay:GameplayMain;
		
		private var _restType:CbType = new CbType();
		
		private var _canStick:Boolean = false;
		public function get canStick():Boolean { return _canStick;}
		
		public function get body():Body { return _body; }
		private var _body:Body;
		private var _sensor:Circle;
		
		private var _glow:GlowArrow = new GlowArrow();
		
		public function Arrow(gameplayMain:GameplayMain) 
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			_gameplay = gameplayMain;
			
			addChild(_glow);
			_glow.visible = false;
			addChild(new ArrowRight);
			
			_body = new Body(BodyType.DYNAMIC);
			_body.userData.graphic = this;
			
			_gameplay.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				ARROW_THROW_CB_TYPE,
				CbType.ANY_BODY,
				onValidTerrainCollision
			));
			_gameplay.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				_restType,
				CbType.ANY_BODY,
				onInvalidTerrainCollision
			));
			
			var shape:Polygon = new Polygon(Polygon.rect(-40, -1, 40, 2));
			shape.body = _body;
			shape.material.density = 0.55;
			shape.filter.collisionMask = PhysicalWorld.ARROW_COLLISION_GROUP;
			shape.cbTypes.add(_restType);
			var weight:Circle = new Circle(3);
			//weight.translate(new Vec2(5, 0));
			weight.body = _body;
			weight.material.density = 6.5;
			shape.filter.collisionMask = PhysicalWorld.ARROW_COLLISION_GROUP;
			weight.cbTypes.add(ARROW_THROW_CB_TYPE);
			
			_sensor = new Circle(50);
			_sensor.material.density = 0;
			_sensor.sensorEnabled = true;
			_sensor.cbTypes.add(ARROW_CB_TYPE);
			_sensor.body = _body;
		}
		
		
		public function shoot(pos:Vec2, angle:Number):void
		{
			_glow.visible = false;
			_canStick = true;
			_body.allowMovement = _body.allowRotation = true;
			
			_body.velocity = Vec2.get();
			_body.allowRotation = false;
			_body.position = pos;
			_body.rotation = angle;
			_body.torque = 0;
			_body.angularVel = 0;
			_body.isBullet = true;
			_body.applyImpulse((new Vec2(1, 0)).rotate(angle).mul(600));
			
			_sensor.cbTypes.remove(ARROW_CB_TYPE);
		}
		
		private function onValidTerrainCollision(cb:InteractionCallback):void
		{
			if (!_canStick) return;
			
			_body.velocity = Vec2.get();
			_body.angularVel = 0;
			_body.allowMovement = _body.allowRotation = false;
			_sensor.cbTypes.add(ARROW_CB_TYPE);
			_glow.visible = true;
		}
		
		private function onInvalidTerrainCollision(cb:InteractionCallback):void
		{
			_body.allowRotation = true;
			_canStick = false;
			_sensor.cbTypes.add(ARROW_CB_TYPE);
			_glow.visible = true;
		}
		
	}

}