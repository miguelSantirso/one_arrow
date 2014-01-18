package one_arrow.gameplay.character 
{
	import flash.display.MovieClip;
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
	import one_arrow.gameplay.fx.AutoFx;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.Config;
	
	import one_arrow.gameplay.world.PhysicalWorld;
	import one_arrow.Main;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Character extends Sprite 
	{
		protected var _main:GameplayMain;
		
		protected var _backLayer:Sprite = new Sprite();
		protected var _animLayer:Sprite = new Sprite();
		protected var _foreLayer:Sprite = new Sprite();
		
		public function get physicalBody():Body { return _physicalBody; }
		protected var _physicalBody:Body;
		
		private var _prevDirectionX:int = 0;
		protected var _direction:Vec2 = new Vec2();
		protected var _nextPosition:Vec2 = new Vec2();
		
		public static const ANIM_IDLE_LEFT:int = 0;
		public static const ANIM_IDLE_RIGHT:int = 1;
		public static const ANIM_RUN_RIGHT:int = 2;
		public static const ANIM_FALLING:int = 3;
		public static const ANIM_JUMPING:int = 4;
		public static const ANIM_LOADING_RIGHT:int = 5;
		public static const ANIM_LOADING_LEFT:int = 6;
		public static const ANIM_POINTING_LEFT:int = 7;
		public static const ANIM_POINTING_RIGHT:int = 8;
		public static const ANIM_IDLE:int = 9;
		public static const ANIM_ATTACK:int = 10;
		public static const ANIM_DEFEAT:int = 11;
		public static const ANIM_HIT:int = 12;
		public static const ANIM_HIT_FALLING_LOOP:int = 13;
		public static const ANIM_HIT_RECOVER:int = 14;
		
		public static const ANIM_IDLE_SHIELD:int = 15;
		
		public function get currentAnimMc():MovieClip { return _animations[_currentAnimation]; }
		protected var _animations:Dictionary = new Dictionary();
		protected var _currentAnimation:int = -1;
		
		private var _feetSensor:Circle;
		private var _feetType:CbType = new CbType();
		
		protected var _feetInFloor:Boolean = false;
		protected var _remainingJumps:int = 2;
		public var maxJumps:int = 1;
		private var _verticalAcceleration:Number = 4.5;
		protected var _verticalSpeed:Number = 0;
		
		protected var _lastScaleX:int = 1;
		
		protected var _preventDefaultAnimations:Boolean = false;
		
		public function Character(gameplayMain:GameplayMain) 
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			_main = gameplayMain;
			
			addChild(_backLayer);
			addChild(_animLayer);
			addChild(_foreLayer);
			
			_physicalBody = new Body(BodyType.KINEMATIC);
			_physicalBody.userData.graphic = this;
			_physicalBody.allowRotation = false;
			
			/*_feetSensor = new Circle(5);
			_feetSensor.filter = new InteractionFilter(1, -1, 1, 5);
			_feetSensor.sensorEnabled = true;
			_feetSensor.body = _physicalBody;
			_feetSensor.cbTypes.add(_feetType);*/
		}
		
		
		public function dispose():void
		{
		}
		
		public function update():void
		{
			_nextPosition.set(_physicalBody.position);
			_nextPosition.y -= Config.PLAYER_SPEED_DOWN;
			
			move();
			
			_verticalSpeed -= _verticalAcceleration;
			if (_verticalSpeed < -60) _verticalSpeed = -60;
			
			if (_verticalSpeed >= 0)
			{
				_nextPosition.y -= _verticalSpeed - Config.PLAYER_SPEED_DOWN;
			}
			else
			{
				var rayResult:RayResult = _main.physicalWorld.space.rayCast(
					Ray.fromSegment(_nextPosition, _nextPosition.add(new Vec2(0, _feetInFloor ? 2 * Config.PLAYER_SPEED_DOWN : -_verticalSpeed))),
					true,
					new InteractionFilter(16, _direction.y > 0 ? PhysicalWorld.BOUNDS_COLLISION_GROUP : PhysicalWorld.BOUNDS_COLLISION_GROUP | PhysicalWorld.TERRAIN_COLLISION_GROUP));
				if (rayResult)
				{
					if (!_feetInFloor)
						AutoFx.showFx(new FxLand(), physicalBody.position.x, physicalBody.position.y);
					_feetInFloor = true;
					_remainingJumps = maxJumps;
					_verticalSpeed = 0;
					_nextPosition.y += rayResult.distance;
				}
				else
				{
					_nextPosition.y -= _verticalSpeed - Config.PLAYER_SPEED_DOWN;
				}
			}
			
			var movementThisFrameX:Number = _nextPosition.x - _physicalBody.position.x;
			var movementThisFrameY:Number = _nextPosition.y - _physicalBody.position.y;
			_physicalBody.position.set(_nextPosition);
			
			// ANIMATION
			
			if (_preventDefaultAnimations)
				return;
			
			if (movementThisFrameY > 0.5 * Config.PLAYER_SPEED_DOWN)
			{
				setAnimation(ANIM_FALLING);
				scaleX = _lastScaleX;
			}
			else if (movementThisFrameY < 0 && !_feetInFloor)
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
		}
		protected function move():void
		{
			if (_direction.x == 0)
			{
				_prevDirectionX = 0;
				return;
			}
			
			const characterCollisionDistance:int = 25;
			
			var sign:Number = (_direction.x > 0 ? 1 : -1);
			var ray:Ray = new Ray(_nextPosition, new Vec2(_direction.x, 0));
			var rayResult:RayResult = _main.physicalWorld.space.rayCast(ray, 
				true,
				new InteractionFilter(4, PhysicalWorld.BOUNDS_COLLISION_GROUP | PhysicalWorld.TERRAIN_COLLISION_GROUP));
			if (rayResult)
			{
				_nextPosition.x += sign * Math.min(rayResult.distance - characterCollisionDistance, Config.PLAYER_SPEED_HORIZONTAL);
			}
			else
			{
				_nextPosition.x += sign * Config.PLAYER_SPEED_HORIZONTAL;
			}
			
			if (rayResult && (Math.floor(Math.abs(rayResult.distance)) > characterCollisionDistance)
			&& (_prevDirectionX != _direction.x) && _feetInFloor)
			{
				var fx:MovieClip = new FxRunRight();
				fx.scaleX = sign;
				AutoFx.showFx(fx, _physicalBody.position.x, _physicalBody.position.y);
			}
			
			_prevDirectionX = _direction.x;
		}
		protected function jump():void
		{
			_feetInFloor = false;
			_remainingJumps--;
			_verticalSpeed = 38;
			AutoFx.showFx(new FxJump(), physicalBody.position.x, physicalBody.position.y);
		}
		
		
		protected function setAnimation(newAnimation:int):void
		{
			if (newAnimation == _currentAnimation)
				return;
			
			if (_currentAnimation >= 0)
			{
				_animations[_currentAnimation].stop();
				_animLayer.removeChild(_animations[_currentAnimation]);
			}
			
			_currentAnimation = newAnimation;
			
			_animLayer.addChild(_animations[_currentAnimation]);
			_animations[_currentAnimation].gotoAndPlay(1);
		}
		
		public function get halfHeight():Number
		{
			return currentAnimMc.height * 0.5;
		}
		
		public function isDamaged():Boolean
		{
			return _currentAnimation == ANIM_HIT
				|| _currentAnimation == ANIM_HIT_FALLING_LOOP
				|| _currentAnimation == ANIM_HIT_RECOVER;
		}
	}

}