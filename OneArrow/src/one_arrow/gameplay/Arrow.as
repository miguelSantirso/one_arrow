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
		private var _gameplay:GameplayMain;
		private var _tipType:CbType = new CbType();
		private var _restType:CbType = new CbType();
		
		private var _canStick:Boolean = false;
		public function get canStick():Boolean { return _canStick;}
		
		public function get body():Body { return _body; }
		private var _body:Body;
		
		public function Arrow(gameplayMain:GameplayMain) 
		{
			_gameplay = gameplayMain;
			
			graphics.lineStyle(3, 0x225544);
			graphics.moveTo(-40, 0);
			graphics.lineTo(00, 0);
			
			_body = new Body(BodyType.DYNAMIC);
			_body.userData.graphic = this;
			
			_gameplay.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				_tipType,
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
			weight.translate(new Vec2(5, 0));
			weight.body = _body;
			weight.material.density = 6.5;
			weight.cbTypes.add(_tipType);
		}
		
		
		public function shoot(pos:Vec2, direction:Vec2):void
		{
			_canStick = true;
			_body.allowMovement = _body.allowRotation = true;
			
			_body.velocity = Vec2.get();
			_body.allowRotation = false;
			_body.position = pos;
			_body.rotation = direction.angle;
			_body.torque = 0;
			_body.angularVel = 0;
			_body.isBullet = true;
			_body.applyImpulse(direction.mul(600));
		}
		
		private function onValidTerrainCollision(cb:InteractionCallback):void
		{
			if (!_canStick) return;
			
			_body.velocity = Vec2.get();
			_body.angularVel = 0;
			_body.allowMovement = _body.allowRotation = false;
		}
		
		private function onInvalidTerrainCollision(cb:InteractionCallback):void
		{
			_body.allowRotation = true;
			_canStick = false;
		}
		
	}

}