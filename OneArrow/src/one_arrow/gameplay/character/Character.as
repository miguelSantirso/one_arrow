package one_arrow.gameplay.character 
{
	import flash.display.Sprite;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreListener;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.callbacks.CbEvent;
	import nape.callbacks.PreFlag;
	import nape.callbacks.InteractionType;
	
	import one_arrow.Main;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Character extends Sprite 
	{
		public function get physicalBody():Body { return _physicalBody; }
		private var _physicalBody:Body;
		public function get feetListener():PreListener { return _feetListener; }
		private var _feetListener:PreListener;
		
		public function Character() 
		{
			graphics.beginFill(0x225544);
			graphics.drawRect( -34, -108, 68, 108);
			graphics.endFill();
			
			_physicalBody = new Body(BodyType.DYNAMIC);
			_physicalBody.userData.graphic = this;
			_physicalBody.allowRotation = false;
			
			var shapeUpper:Polygon = new Polygon(Polygon.rect( -34, -108, 68, 108 - 34));
			shapeUpper.body = _physicalBody;
			var shapeFeet:Circle = new Circle(34);
			shapeFeet.body = _physicalBody;
			shapeFeet.material.dynamicFriction = 0;
			shapeFeet.material.density = 1000;
			shapeFeet.sensorEnabled = true;
			shapeFeet.cbTypes.add(new CbType());
			
			_feetListener = new PreListener(InteractionType.ANY, null, null, onFeetCollision);
		}
		
		
		public function update():void
		{
			var impulse:Vec2 = new Vec2();
			if (Main.input.leftPressed)
				impulse.x -= 300;
			if (Main.input.rightPressed)
				impulse.x += 300;
			if (Main.input.upPressed)
				impulse.y -= 600;
			
			_physicalBody.applyImpulse(impulse);
		}
		
		
		private function onFeetCollision(cb:PreCallback):PreFlag 
		{
			trace("pies");
			return PreFlag.ACCEPT;
		}
		
	}

}