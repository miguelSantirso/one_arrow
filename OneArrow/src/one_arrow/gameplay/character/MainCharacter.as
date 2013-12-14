package one_arrow.gameplay.character 
{
	import flash.events.MouseEvent;
	import nape.geom.Vec2;
	import one_arrow.gameplay.Arrow;
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
			
			gameplayMain.addEventListener(MouseEvent.CLICK, onStageClick, false, 0, true);
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
				//shootArrow();
				// Jump
				_remainingJumps--;
				_jumpFramesLeft = 10;
			}
		}
		
		
		private function shootArrow(worldPos:Vec2):void
		{
			var dir:Vec2 = worldPos.sub(physicalBody.position);
			dir.length = 1;
			_main.arrow.shoot(
				physicalBody.position.sub(new Vec2(0, 70)),
				dir
			);
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			shootArrow(new Vec2(e.localX - 400 + _main.cameraX, e.localY - 300 + _main.cameraY));
		}
		
	}

}