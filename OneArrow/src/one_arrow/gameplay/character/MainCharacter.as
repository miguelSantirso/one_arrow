package one_arrow.gameplay.character 
{
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.Main;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class MainCharacter extends Character 
	{
		
		public function MainCharacter(gameplayMain:GameplayMain)
		{
			super(gameplayMain);
			
			_animations[Character.ANIM_IDLE_LEFT] = new MainCharIdleLeft();
			_animations[Character.ANIM_IDLE_RIGHT] = new MainCharIdleRight();
			_animations[Character.ANIM_RUN_RIGHT] = new MainCharRunRight();
			_animations[Character.ANIM_FALLING] = new MainCharFalling();
			_animations[Character.ANIM_JUMPING] = new MainCharJumpUp();
			
			setAnimation(Character.ANIM_IDLE_RIGHT);
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (Main.input.rightPressed)
				_direction.x = 1;
			else if (Main.input.leftPressed)
				_direction.x = -1;
			else _direction.x = 0;
			
			if (Main.input.canJump && _remainingJumps > 0)
			{
				// Jump
				_remainingJumps--;
				_jumpFramesLeft = 10;
			}
		}
		
	}

}