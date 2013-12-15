package one_arrow.gameplay.enemies.types 
{
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
		
		private var _framesLeftLeaving:int = Config.ENEMY_FRAMES_RELAXED_AFTER_ATTACK;
		
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
		
		protected override function onCollisionWithArrow(cb:InteractionCallback):void
		{
			super.onCollisionWithArrow(cb);
			
			Sounds.playSoundById(Sounds.ENEMY_DAMAGE);
			Sounds.playSoundById(Sounds.ENEMY_DEATH);
		}
		
		private function setAssetDirection():void
		{
			if (_direction.x > 0)
				_animations[_currentAnimation].scaleX = 1;
			else
				_animations[_currentAnimation].scaleX = -1;
		}
		
		public override function update():void
		{
			
			if (_status == STATUS_DEFEAT || _status == STATUS_APPEARING)
				return;
			
			if (_status != STATUS_LEAVING 
				&& _currentAnimation == Character.ANIM_ATTACK 
				&& currentAnimMc.currentFrame == currentAnimMc.totalFrames)
			{
				_main.character.takeDamage();
				_status = STATUS_LEAVING;
				setAnimation(ANIM_IDLE);
				_framesLeftLeaving = Config.ENEMY_FRAMES_RELAXED_AFTER_ATTACK
			}
			
			var hero:Character = _main.character;
			var distanceToHero:Number = Point.distance(new Point(_physicalBody.position.x, _physicalBody.position.y),
														new Point(hero.physicalBody.position.x, hero.physicalBody.position.y));
														
			var direction:Vec2 = new Vec2(hero.physicalBody.position.x - _physicalBody.position.x,
										hero.physicalBody.position.y - _physicalBody.position.y);
			direction.normalise();
				
			//FOLLOWING COS DISTANCE
			if (_status == STATUS_LEAVING)
			{
				if (--_framesLeftLeaving == 0)
					_status = STATUS_IDLE;
			}
			else if (distanceToHero < DISTANCE_TO_FOLLOW && distanceToHero>DISTANCE_TO_ATTACK)
			{
				if(_status != STATUS_FOLLOWING)
					setAnimation(Character.ANIM_IDLE);
					
				_status = STATUS_FOLLOWING;
				_physicalBody.position.set(new Vec2(_physicalBody.position.x + direction.x * FOLLOW_SPEED, 
													_physicalBody.position.y + direction.y * FOLLOW_SPEED));
				_direction = direction;
				setAssetDirection();
				return;
			
			//ATTACKING COS DISTANCE
			}else if (distanceToHero < DISTANCE_TO_ATTACK)
			{
				if(_status != STATUS_ATTACKING)
					setAnimation(Character.ANIM_ATTACK);
					
				_status = STATUS_ATTACKING;
				
				_direction = direction;
				setAssetDirection();
				return;
			}
			
			//IF NOT FOLLOWING OR NOT ATTACKING 
			if (_status != STATUS_IDLE && _status != STATUS_LEAVING)
			{
				_initial_position = new Point(_physicalBody.position.x, _physicalBody.position.y);
				_status = STATUS_IDLE;
				setAnimation(Character.ANIM_IDLE);
				_direction.x = -1;
			}
			
			if (_direction.x < 0 
			&& _physicalBody.position.x < _initial_position.x - MAXIMUM_IDLE_DISTANCE)
				_direction.x = 1;
			else if(_direction.x > 0
			&& _physicalBody.position.x > _initial_position.x + MAXIMUM_IDLE_DISTANCE)
				_direction.x = -1;
				
				
			if (_direction.x == -1)
				_physicalBody.position.set(new Vec2(_physicalBody.position.x - MOVEMENT_SPEED, _physicalBody.position.y));
			else
				_physicalBody.position.set(new Vec2(_physicalBody.position.x + MOVEMENT_SPEED, _physicalBody.position.y));
			
			setAssetDirection();
			
		}
		
		
	}

}