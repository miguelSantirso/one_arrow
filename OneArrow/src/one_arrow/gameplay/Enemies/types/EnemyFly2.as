package one_arrow.gameplay.enemies.types 
{
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.character.Character;
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyFly1  extends EnemyFly
	{
		
		private static const MAXIMUM_IDLE_DISTANCE:int = 100;
		private static const MOVEMENT_SPEED:int = 2;
		private static const FOLLOW_SPEED:int = 6;
		private static const DISTANCE_TO_FOLLOW:int = 500;
		private static const DISTANCE_TO_ATTACK:int = 50;
		
		public function EnemyFly1(gameplayMain:GameplayMain) 
		{
			maximumIdleDistance = MAXIMUM_IDLE_DISTANCE;
			movementSpeed = MOVEMENT_SPEED;
			followSpeed = FOLLOW_SPEED;
			distanceToAttack = DISTANCE_TO_ATTACK;
			distanceToFollow = DISTANCE_TO_FOLLOW;
			
			
			super(gameplayMain);
		}
		
		protected override function initAnimations():void
		{
			_animations[Character.ANIM_IDLE] = new Enemy01Idle();
			_animations[Character.ANIM_ATTACK] = new Enemy01Attack();
			_animations[Character.ANIM_DEFEAT] = new Enemy01Defeat();
		}
		
	}

}