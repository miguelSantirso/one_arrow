package one_arrow.gameplay.enemies.types 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.GameplayMain;
	import utils.FrameScriptInjector;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyFly extends Character 
	{
		private static const DEFEAT_ANIMATION_COMPLETE:String = "deadcomplete";
		
		private static const MAXIMUM_IDLE_DISTANCE:int = 100;
		private static const MOVEMENT_SPEED:int = 4;
		private static const FOLLOW_SPEED:int = 6;
		private static const DISTANCE_TO_FOLLOW:int = 200;
		private static const DISTANCE_TO_ATTACK:int = 50;
		private static const DISTANCE_TO_DIE:int = 90;
		
		private static const STATUS_IDLE:int = 1;
		private static const STATUS_FOLLOWING:int = 2;
		private static const STATUS_ATTACKING:int = 3;
		private static const STATUS_DEFEAT:int = 4;
		private var _status:int;
		
		private var _initial_position:Point;
			
		
		public function EnemyFly(gameplayMain:GameplayMain) 
		{
			super(gameplayMain);
			
			_animations[Character.ANIM_IDLE] = new Enemy01Idle();
			_animations[Character.ANIM_ATTACK] = new Enemy01Attack();
			_animations[Character.ANIM_DEFEAT] = new Enemy01Defeat();
			
			var defeat:MovieClip = _animations[Character.ANIM_DEFEAT];
			defeat.gotoAndStop(1);
			FrameScriptInjector.injectStopAtEnd(defeat, DEFEAT_ANIMATION_COMPLETE);
			defeat.addEventListener(DEFEAT_ANIMATION_COMPLETE, onDefeatAnimationComplete);
			
			setAnimation(Character.ANIM_IDLE);
			
			_status = STATUS_IDLE;
			
			_direction.x = -1;
			_main.physicalWorld.addBody(_physicalBody);
			
		}
		
		public function setPosition(position:Point):void
		{
			_initial_position = position;
			_physicalBody.position.set(new Vec2(position.x,position.y));
		}
		
		private function setAssetDirection():void
		{
			if (_direction.x > 0)
				_animations[_currentAnimation].scaleX = 1;
			else
				_animations[_currentAnimation].scaleX = -1;
		}
		
		private function onDefeatAnimationComplete(evt:Event):void
		{
			_animations[Character.ANIM_DEFEAT].removeEventListener(DEFEAT_ANIMATION_COMPLETE, onDefeatAnimationComplete);
			while (_animLayer.numChildren > 0) {
				_animLayer.removeChildAt(0);
			}
		}
		
		override public function update():void
		{
			
			if (_status == STATUS_DEFEAT)
				return;
			
			
			if (_main.arrow.canStick)
			{
				var arrow:Body = _main.arrow.body;
				var distanceToArrow = Point.distance(new Point(_physicalBody.position.x, _physicalBody.position.y+25),
															new Point(arrow.position.x, arrow.position.y));
				
				if (distanceToArrow < DISTANCE_TO_DIE)
				{
					_status = STATUS_DEFEAT;
					setAnimation(Character.ANIM_DEFEAT);
					_main.physicalWorld.removeBody(_physicalBody);
					return;
				}
			}											
			
			
			var hero:Character = _main.character;
			var distanceToHero:Number = Point.distance(new Point(_physicalBody.position.x, _physicalBody.position.y),
														new Point(hero.physicalBody.position.x, hero.physicalBody.position.y));
														
			var direction:Vec2 = new Vec2(hero.physicalBody.position.x - _physicalBody.position.x,
										hero.physicalBody.position.y - _physicalBody.position.y);
			direction.normalise();
				
			//FOLLOWING COS DISTANCE
			if (distanceToHero < DISTANCE_TO_FOLLOW && distanceToHero>DISTANCE_TO_ATTACK)
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
			if (_status != STATUS_IDLE)
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