package one_arrow.gameplay.enemies.types 
{
	import nape.dynamics.InteractionFilter;
	import nape.geom.Ray;
	import nape.geom.RayResult;
	import one_arrow.gameplay.enemies.EnemyBase;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Polygon;
	import one_arrow.Config;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.GameplayMain;
	import utils.FrameScriptInjector;
	import one_arrow.gameplay.Arrow;
	import one_arrow.Sounds;
	import one_arrow.gameplay.world.PhysicalWorld;
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyFly extends EnemyBase 
	{
		private static const MC_WIDTH:int = 45;
		
		private var _followSpeed:int=4;
		public function set followSpeed(value:int):void { _followSpeed = value; }
		private var _movementSpeed:int=2;
		public function set movementSpeed(value:int):void { _movementSpeed = value; }
		private var _maximumIdleDistance:int=100;
		public function set maximumIdleDistance(value:int):void { _maximumIdleDistance = value; }
		private var _distanceToFollow:int=200;
		public function set distanceToFollow(value:int):void { _distanceToFollow = value; }
		private var _distanceToAttack:int=50;
		public function set distanceToAttack(value:int):void { _distanceToAttack = value; }
		
		
		private var _framesLeftLeaving:int = 0;
		private var _storedStandardFramerate:int = -1;
		
		public function EnemyFly(gameplayMain:GameplayMain) 
		{
			super(gameplayMain);
		}
		
		private function setAssetDirection():void
		{
			if (_direction.x > 0)
				_animations[_currentAnimation].scaleX = 1;
			else
				_animations[_currentAnimation].scaleX = -1;
		}
		
		public function isAttacking():Boolean
		{
			return _currentAnimation == Character.ANIM_ATTACK
				&& currentAnimMc.currentFrame < currentAnimMc.totalFrames;
		}
		
		public override function update():void
		{
			super.update();
			
			var hero:Character = _main.character;
			var distanceToHero:Number = Point.distance(new Point(_physicalBody.position.x, _physicalBody.position.y),
													   new Point(hero.physicalBody.position.x, hero.physicalBody.position.y));
			var localDirection:Vec2 = new Vec2(hero.physicalBody.position.x - _physicalBody.position.x,
											   hero.physicalBody.position.y - _physicalBody.position.y);
										  
			localDirection = localDirection.normalise();
			
			switch(_status)
			{
				case STATUS_APPEARING:
				case STATUS_DEFEAT:
				default:
					return;
				case STATUS_ATTACKING:
					if (isAttacking())
					{
						_status = STATUS_ATTACKING;
					}
					else if (distanceToHero < _distanceToAttack)
					{
						_main.character.takeDamage();
						_status = STATUS_IDLE;
						_direction = localDirection;
						setAnimation(ANIM_IDLE);
						_framesLeftLeaving = Config.ENEMY_FRAMES_RELAXED_AFTER_ATTACK;
					}
					else 
					{
						_status = STATUS_IDLE;
						setAnimation(ANIM_IDLE);
					}
					break;
				case STATUS_FOLLOWING:
					_physicalBody.position.set(new Vec2(_physicalBody.position.x + (localDirection.x * _followSpeed),
														_physicalBody.position.y + (localDirection.y * _followSpeed)));
					
					if (distanceToHero > _distanceToFollow)
					{
						_initial_position = new Point(_physicalBody.position.x, _physicalBody.position.y);
						_status = STATUS_IDLE;
						break;
					}
														
					if(distanceToHero < _distanceToAttack)
					{
						setAnimation(Character.ANIM_ATTACK);
						_status = STATUS_ATTACKING;
						_direction = localDirection;
						setAssetDirection();
						break;
					}
					
					_animations[_currentAnimation].scaleX = localDirection.x > 0 ? 1 : -1;
					
					break;
				case STATUS_IDLE:
					if ((_framesLeftLeaving == 0) && (distanceToHero < _distanceToFollow))
					{
						if (distanceToHero >= _distanceToAttack)
						{
							setAnimation(Character.ANIM_IDLE);
							_status = STATUS_FOLLOWING;
						}
						else
						{
							setAnimation(Character.ANIM_ATTACK);
							_status = STATUS_ATTACKING;
							setAssetDirection();
						}
					}
					else
					{
						if (_framesLeftLeaving > 0) _framesLeftLeaving--;
						
						if (_direction.x < 0 
							&& _physicalBody.position.x < _initial_position.x - _maximumIdleDistance)
							_direction.x = 1;
						else if(_direction.x > 0
							&& _physicalBody.position.x > _initial_position.x + _maximumIdleDistance)
							_direction.x = -1;
						
						// Check collisions with the side walls:
						var nextPositionX:Number = _physicalBody.position.x + (_movementSpeed * _direction.x);
						var nextPositionXWW:Number = nextPositionX + (MC_WIDTH * _direction.x);
						var rayToWall:Ray = new Ray(new Vec2(nextPositionXWW, _physicalBody.position.y), new Vec2(_direction.x, 0));
						var rayCast:RayResult = _main.physicalWorld.space.rayCast(rayToWall, true, new InteractionFilter(4, PhysicalWorld.BOUNDS_COLLISION_GROUP));
						
						rayCast ? _physicalBody.position.set(new Vec2(nextPositionX, _physicalBody.position.y)) : _direction.x *= -1;
						
						setAssetDirection();
					}
					break;
			}
			
			return;
		}
		
	}

}