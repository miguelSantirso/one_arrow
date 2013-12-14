package one_arrow.gameplay.character 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
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
		
		public static const ANIM_IDLE_LEFT:int = 0;
		public static const ANIM_IDLE_RIGHT:int = 1;
		public static const ANIM_RUN_RIGHT:int = 2;
		public static const ANIM_FALLING:int = 3;
		
		private var _animations:Dictionary = new Dictionary();
		private var _currentAnimation:int = -1;
		
		private var _lastScaleX:int = 1;
		
		public function Character(gameplayMain:GameplayMain) 
		{
			_main = gameplayMain;
			
			_physicalBody = new Body(BodyType.KINEMATIC);
			_physicalBody.userData.graphic = this;
			_physicalBody.allowRotation = false;
			
			_animations[ANIM_IDLE_LEFT] = new MainCharIdleLeft();
			_animations[ANIM_IDLE_RIGHT] = new MainCharIdleRight();
			_animations[ANIM_RUN_RIGHT] = new MainCharRunRight();
			_animations[ANIM_FALLING] = new MainCharFalling();
			
			setAnimation(ANIM_IDLE_RIGHT);
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
			
			var movementThisFrameX:Number = _nextPosition.x - _physicalBody.position.x;
			var movementThisFrameY:Number = _nextPosition.y - _physicalBody.position.y;
			
			
			if (movementThisFrameY > 0.5 * Config.PLAYER_SPEED_DOWN)
			{
				setAnimation(ANIM_FALLING);
				scaleX = _lastScaleX;
			}
			else
			{
				if (movementThisFrameX == 0)
				{
					setAnimation(_lastScaleX == 1 ? ANIM_IDLE_RIGHT : ANIM_IDLE_LEFT);
					scaleX = 1;
				}
				else if (movementThisFrameX > 0)
				{
					_lastScaleX = scaleX = 1;
					setAnimation(ANIM_RUN_RIGHT);
				}
				else 
				{
					_lastScaleX = scaleX = -1;
					setAnimation(ANIM_RUN_RIGHT);
				}
			}
			
			
			_physicalBody.position.set(_nextPosition);
		}
		private function move(right:Boolean):void
		{
			var sign:Number = (right ? 1 : -1);
			
			var rayResult:RayResult = _main.physicalWorld.space.rayCast(Ray.fromSegment(_nextPosition, _nextPosition.add(new Vec2(sign * 15, 0))));
			_nextPosition.x = _physicalBody.position.x + sign * (rayResult ? rayResult.distance : 15);
		}
		
		
		private function setAnimation(newAnimation:int):void
		{
			if (newAnimation == _currentAnimation)
				return;
			
			if (_currentAnimation >= 0)
			{
				_animations[_currentAnimation].stop();
				removeChild(_animations[_currentAnimation]);
			}
			
			_currentAnimation = newAnimation;
			
			addChild(_animations[_currentAnimation]);
			_animations[_currentAnimation].gotoAndPlay(1);
		}
		
	}

}