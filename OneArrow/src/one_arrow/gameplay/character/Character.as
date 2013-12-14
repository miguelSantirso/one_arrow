package one_arrow.gameplay.character 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.PreCallback;
	import nape.callbacks.PreListener;
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Edge;
	import nape.shape.Polygon;
	import nape.callbacks.CbEvent;
	import nape.callbacks.PreFlag;
	import nape.callbacks.InteractionType;
	import nape.geom.Geom;
	import nape.phys.GravMassMode;
	import nape.shape.ShapeList;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.Config;
	
	import one_arrow.Main;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Character extends Sprite 
	{
		private var _main:GameplayMain;
		
		public function get physicalBody():Body { return _physicalBody; }
		private var _physicalBody:Body;
		
		private var _nextPosition:Vec2 = new Vec2();
		
		public function Character(gameplayMain:GameplayMain) 
		{
			_main = gameplayMain;
			
			graphics.beginFill(0x225544);
			graphics.drawRect( -34, -108, 68, 108);
			graphics.endFill();
			
			_physicalBody = new Body(BodyType.KINEMATIC);
			_physicalBody.userData.graphic = this;
			_physicalBody.allowRotation = false;
		}
		
		
		public function update():void
		{
			_nextPosition.set(_physicalBody.position);
			_nextPosition.y -= Config.PLAYER_SPEED_DOWN;
			
			if (Main.input.rightPressed)
				move(true);
			else if (Main.input.leftPressed)
				move(false);
			
			var rayResult:RayResult = _main.physicalWorld.space.rayCast(Ray.fromSegment(_nextPosition, _nextPosition.add(new Vec2(0, 2*Config.PLAYER_SPEED_DOWN))));
			if (!rayResult)
				_nextPosition.y += 2*Config.PLAYER_SPEED_DOWN;
			else
			{
				_nextPosition.y += rayResult.distance;
			}
			
			_physicalBody.position.set(_nextPosition);
		}
		private function move(right:Boolean):void
		{
			var sign:Number = (right ? 1 : -1);
			
			var rayResult:RayResult = _main.physicalWorld.space.rayCast(Ray.fromSegment(_nextPosition, _nextPosition.add(new Vec2(sign * 15, 0))));
			_nextPosition.x = _physicalBody.position.x + sign * (rayResult ? rayResult.distance : 15);
		}
		
	}

}