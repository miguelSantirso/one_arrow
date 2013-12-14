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
	import nape.dynamics.InteractionFilter;
	import nape.dynamics.InteractionGroup;
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
		protected var _main:GameplayMain;
		
		public function get physicalBody():Body { return _physicalBody; }
		private var _physicalBody:Body;
		
		protected var _direction:Vec2 = new Vec2();
		private var _nextPosition:Vec2 = new Vec2();
		
		public static const ANIM_IDLE_LEFT:int = 0;
		public static const ANIM_IDLE_RIGHT:int = 1;
		public static const ANIM_RUN_RIGHT:int = 2;
		public static const ANIM_FALLING:int = 3;
		public static const ANIM_JUMPING:int = 4;
		
		protected var _animations:Dictionary = new Dictionary();
		private var _currentAnimation:int = -1;
		
		private var _feetSensor:Circle;
		private var _feetType:CbType = new CbType();
		
		
		private var _jumpAcceleration:Number = 0.3;
		protected var _remainingJumps:int = 2;
		protected var _jumpFramesLeft:int = 0;
		
		private var _lastScaleX:int = 1;
		
		public function Character(gameplayMain:GameplayMain) 
		{
			_main = gameplayMain;
			
			_physicalBody = new Body(BodyType.KINEMATIC);
			_physicalBody.userData.graphic = this;
			_physicalBody.allowRotation = false;
			
			/*_feetSensor = new Circle(5);
			_feetSensor.filter = new InteractionFilter(1, -1, 1, 5);
			_feetSensor.sensorEnabled = true;
			_feetSensor.body = _physicalBody;
			_feetSensor.cbTypes.add(_feetType);*/
		}
		
		
		public function update():void
		{
			_nextPosition.set(_physicalBody.position);
			_nextPosition.y -= Config.PLAYER_SPEED_DOWN;
			
			move();
			
			if (_jumpFramesLeft > 0)
			{
				_nextPosition.y -= _jumpAcceleration * _jumpFramesLeft;
				_jumpFramesLeft--;
			}
			else
			{
				var rayResult:RayResult = _main.physicalWorld.space.rayCast(
					Ray.fromSegment(_nextPosition, _nextPosition.add(new Vec2(0, 2 * Config.PLAYER_SPEED_DOWN))),
					true);
				if (!rayResult)
					_nextPosition.y += 2*Config.PLAYER_SPEED_DOWN;
				else
				{
					_remainingJumps = 2;
					_nextPosition.y += rayResult.distance;
				}
			}
			
			
			// ANIMATION
			
			var movementThisFrameX:Number = _nextPosition.x - _physicalBody.position.x;
			var movementThisFrameY:Number = _nextPosition.y - _physicalBody.position.y;
			
			if (movementThisFrameY > 0.5 * Config.PLAYER_SPEED_DOWN)
			{
				setAnimation(ANIM_FALLING);
				scaleX = _lastScaleX;
			}
			else if (movementThisFrameY < -3)
			{
				setAnimation(ANIM_JUMPING);
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
		protected function move():void
		{
			if (_direction.x == 0)
				return;
			
			var sign:Number = (_direction.x > 0 ? 1 : -1);
			
			var ray:Ray = new Ray(_nextPosition, _direction);
			var rayResult:RayResult = _main.physicalWorld.space.rayCast(ray, true);
			if (rayResult)
			{
				_nextPosition.x += sign * Math.min(rayResult.distance - 1, Config.PLAYER_SPEED_HORIZONTAL);
			}
			else
			{
				_nextPosition.x += sign * Config.PLAYER_SPEED_HORIZONTAL;
			}
		}
		
		
		protected function setAnimation(newAnimation:int):void
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