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
		private static const MAXIMUM_IDLE_DISTANCE:int = 100;
		private static const MOVEMENT_SPEED:int = 2;
		private static const FOLLOW_SPEED:int = 4;
		private static const DISTANCE_TO_FOLLOW:int = 200;
		private static const DISTANCE_TO_ATTACK:int = 50;
		private static const DISTANCE_TO_DIE:int = 90;
		private static const MC_WIDTH:int = 45;
		private static const FRAMERATE_SPEEDUP_FACTOR:int = 15;
		
		private var _framesLeftLeaving:int = 0;
		private var _storedStandardFramerate:int = -1;
		
		public function EnemyFly(gameplayMain:GameplayMain) 
		{
			super(gameplayMain);
		}
		
		protected override function initAnimations():void
		{
			_animations[Character.ANIM_IDLE] = new Enemy01Idle();
			_animations[Character.ANIM_ATTACK] = new Enemy01Attack();
			_animations[Character.ANIM_DEFEAT] = new Enemy01Defeat();
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
					else if (distanceToHero < DISTANCE_TO_ATTACK)
					{
						_main.character.takeDamage();
						_status = STATUS_IDLE;
						setAnimation(ANIM_IDLE);
						setAssetDirection();
						_framesLeftLeaving = Config.ENEMY_FRAMES_RELAXED_AFTER_ATTACK;
					}
					else 
					{
						_status = STATUS_IDLE;
						setAnimation(ANIM_IDLE);
					}
					break;
				case STATUS_FOLLOWING:
					_physicalBody.position.set(new Vec2(_physicalBody.position.x + (localDirection.x * FOLLOW_SPEED),
														_physicalBody.position.y + (localDirection.y * FOLLOW_SPEED)));
					
					/*if (_storedStandardFramerate < 0)
					{
						_storedStandardFramerate = _animLayer.stage.frameRate;
						_animLayer.stage.frameRate += FRAMERATE_SPEEDUP_FACTOR;
					}*/
					
					if (distanceToHero > DISTANCE_TO_FOLLOW)
					{
						_initial_position = new Point(_physicalBody.position.x, _physicalBody.position.y);
						_status = STATUS_IDLE;
						break;
					}
														
					if(distanceToHero < DISTANCE_TO_ATTACK)
					{
						setAnimation(Character.ANIM_ATTACK);
						_status = STATUS_ATTACKING;
						break;
					}
					
					_animations[_currentAnimation].scaleX = localDirection.x > 0 ? 1 : -1;
					
					break;
				case STATUS_IDLE:
					/*if (_storedStandardFramerate > 0)
					{
						_animations[_currentAnimation].frameRate = _storedStandardFramerate;
						_storedStandardFramerate = -1;
					}*/
					
					if ((_framesLeftLeaving == 0) && (distanceToHero < DISTANCE_TO_FOLLOW))
					{
						if (distanceToHero >= DISTANCE_TO_ATTACK)
						{
							setAnimation(Character.ANIM_IDLE);
							_status = STATUS_FOLLOWING;
						}
						else
						{
							setAnimation(Character.ANIM_ATTACK);
							_status = STATUS_ATTACKING;
						}
					}
					else
					{
						if (_framesLeftLeaving > 0) _framesLeftLeaving--;
						
						if (_direction.x < 0 
							&& _physicalBody.position.x < _initial_position.x - MAXIMUM_IDLE_DISTANCE)
							_direction.x = 1;
						else if(_direction.x > 0
							&& _physicalBody.position.x > _initial_position.x + MAXIMUM_IDLE_DISTANCE)
							_direction.x = -1;
						
						// Check collisions with the side walls:
						var nextPositionX:Number = _physicalBody.position.x + (MOVEMENT_SPEED * _direction.x);
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