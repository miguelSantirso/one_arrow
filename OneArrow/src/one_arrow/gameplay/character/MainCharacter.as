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
		private var _mouseDown:Boolean = false;
		private var _framesToStartPointing:int = -1;
		
		public function MainCharacter(gameplayMain:GameplayMain)
		{
			super(gameplayMain);
			
			_animations[Character.ANIM_IDLE_LEFT] = new MainCharIdleLeft();
			_animations[Character.ANIM_IDLE_RIGHT] = new MainCharIdleRight();
			_animations[Character.ANIM_RUN_RIGHT] = new MainCharRunRight();
			_animations[Character.ANIM_FALLING] = new MainCharFalling();
			_animations[Character.ANIM_JUMPING] = new MainCharJumpUp();
			_animations[Character.ANIM_LOADING_RIGHT] = new MainCharacterLoadingRight();
			_animations[Character.ANIM_LOADING_LEFT] = new MainCharacterLoadingLeft();
			_animations[Character.ANIM_POINTING_RIGHT] = new MainCharPointingRight();
			_animations[Character.ANIM_POINTING_LEFT] = new MainCharPointingLeft();
			
			setAnimation(Character.ANIM_IDLE_RIGHT);
			
			gameplayMain.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown, false, 0, true);
			gameplayMain.addEventListener(MouseEvent.MOUSE_UP, onStageUp, false, 0, true);
			gameplayMain.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		}
		
		
		public override function update():void
		{
			
			
			if (_mouseDown)
			{
				if (_framesToStartPointing > 0)
				{
					_framesToStartPointing-- 
					if (_framesToStartPointing == 0)
					{
						setAnimation(_lastScaleX == 1 ? Character.ANIM_POINTING_RIGHT : Character.ANIM_POINTING_LEFT);
						_framesToStartPointing = -1;
					}
				}
				else
				{
					
				}
			}
			else
			{
				if (Main.input.rightPressed)
					_direction.x = 1;
				else if (Main.input.leftPressed)
					_direction.x = -1;
				else _direction.x = 0;
				
				super.update();
				
				if (Main.input.canJump && _remainingJumps > 0)
				{
					//shootArrow();
					// Jump
					_remainingJumps--;
					_jumpFramesLeft = 10;
				}
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
		
		private function onStageDown(e:MouseEvent):void
		{
			_mouseDown = true;
			setAnimation(_lastScaleX == 1 ? Character.ANIM_LOADING_RIGHT : Character.ANIM_LOADING_LEFT);
			scaleX = 1;
			_framesToStartPointing = 19;
			//shootArrow(new Vec2(e.localX - 400 + _main.cameraX, e.localY - 300 + _main.cameraY));
		}
		private function onStageUp(e:MouseEvent):void
		{
			_mouseDown = false;
			if (_framesToStartPointing == -1)
				shootArrow(new Vec2(e.localX - 400 + _main.cameraX, e.localY - 300 + _main.cameraY));
		}
		private function onMouseMove(e:MouseEvent):void
		{
			if (!_mouseDown || _framesToStartPointing != -1)
				return;
			
			if (e.localX - 400 + _main.cameraX > physicalBody.position.x)
			{
				_lastScaleX = 1;
				setAnimation(Character.ANIM_POINTING_RIGHT);
			}
			else
			{
				_lastScaleX = -1;
				setAnimation(Character.ANIM_POINTING_LEFT);
			}
		}
		
	}

}