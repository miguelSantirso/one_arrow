package one_arrow.gameplay.character 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import one_arrow.Config;
	import one_arrow.gameplay.Arrow;
	import one_arrow.gameplay.fx.AutoFx;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.Main;
	import one_arrow.Sounds;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class MainCharacter extends Character 
	{
		public static const CHARACTER_CB_TYPE:CbType = new CbType();
		
		private var _nArrowsLeft:int = 1;
		
		public function get damaged():Boolean { return _damaged; }
		private var _damaged:Boolean = false;
		private var _mouseDown:Boolean = false;
		private var _framesToStartPointing:int = Config.LOADING_ANIM_FRAMES_LONG;
		private var _shootAngle:Number;
		
		private var _pointingArmFore:MovieClip = new MainCharArmPointingRightFore();
		private var _pointingArmBack:MovieClip = new MainCharArmPointingRightBack();
		private var _lastMouseWorldPos:Vec2 = new Vec2();
		public function get vectorToMouse():Vec2 { return _vectorToMouse; }
		private var _vectorToMouse:Vec2 = new Vec2();
		private var _arrowDirection:Vec2 = new Vec2();
		
		private var _gameOver:Boolean = false;
		
		private var _mouseHoldingOnAirEvent:MouseEvent = null;
		
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
			_animations[Character.ANIM_HIT] = new MainCharHitRight();
			_animations[Character.ANIM_HIT_FALLING_LOOP] = new MainCharHitFallingLoop();
			_animations[Character.ANIM_HIT_RECOVER] = new MainCharRecover();
			
			setAnimation(Character.ANIM_IDLE_RIGHT);
			
			var collisionBox:Polygon = new Polygon(Polygon.rect( -35, -108, 70, 108));
			collisionBox.sensorEnabled = true;
			collisionBox.body = physicalBody;
			collisionBox.cbTypes.add(CHARACTER_CB_TYPE);
			_main.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.ONGOING,
				InteractionType.SENSOR,
				CHARACTER_CB_TYPE,
				Arrow.ARROW_CB_TYPE,
				onCollisionWithArrow
			));
			
			_foreLayer.addChild(_pointingArmFore);
			_backLayer.addChild(_pointingArmBack);
			_pointingArmBack.visible = _pointingArmFore.visible = false;
			_pointingArmBack.x = 0; 
			_pointingArmBack.y = -77;
			_pointingArmFore.x = -4;
			_pointingArmFore.y = -77;
			
			gameplayMain.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown, false, 0, true);
			gameplayMain.addEventListener(MouseEvent.MOUSE_UP, onStageUp, false, 0, true);
			gameplayMain.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			gameplayMain.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
		}
		
		public override function dispose():void
		{
			_main.removeEventListener(MouseEvent.MOUSE_DOWN, onStageDown);
			_main.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
			_main.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_main.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public override function update():void
		{
			_vectorToMouse = _lastMouseWorldPos.sub(physicalBody.position);
			
			// Check if the player wants to shoot the arrow when the character ends her jump and lands on the floor:
			if (_feetInFloor && _mouseHoldingOnAirEvent)
			{
				onStageDown(_mouseHoldingOnAirEvent);
				return;
			}
			
			if (_damaged)
			{
				if (_currentAnimation == ANIM_HIT && currentAnimMc.currentFrame == currentAnimMc.totalFrames)
				{
					if (_feetInFloor)
						setAnimation(ANIM_HIT_RECOVER);
					else
						setAnimation(ANIM_HIT_FALLING_LOOP);
				}
				else if (_currentAnimation == ANIM_HIT_FALLING_LOOP && _feetInFloor)
				{
					setAnimation(ANIM_HIT_RECOVER);
				}
				else if (_currentAnimation == ANIM_HIT_RECOVER && currentAnimMc.currentFrame == currentAnimMc.totalFrames)
				{
					_damaged = false;
					_preventDefaultAnimations = false;
				}
				
				super.update();
			}
			else if (_gameOver)
			{
				_direction.x = _direction.y = 0;
				_mouseDown = true;
				super.update();
				return;
			}
			else if (_mouseDown)
			{
				if (_framesToStartPointing > 0)
				{
					_framesToStartPointing-- 
					if (_framesToStartPointing == 0)
					{
						setAnimation(_lastScaleX == 1 ? Character.ANIM_POINTING_RIGHT : Character.ANIM_POINTING_LEFT);
						_pointingArmBack.visible = _pointingArmFore.visible = true;
						_framesToStartPointing = -1;
					}
				}
				else
				{
					var vectorToMouseTmp:Vec2 = _vectorToMouse.copy();
					
					if (_lastMouseWorldPos.x > physicalBody.position.x)
					{
						_lastScaleX = 1;
						_pointingArmBack.scaleX = _pointingArmFore.scaleX = 1;
						_pointingArmFore.x = -4;
						setAnimation(Character.ANIM_POINTING_RIGHT);
					}
					else
					{
						_lastScaleX = -1;
						_pointingArmBack.scaleX = _pointingArmFore.scaleX = -1;
						_pointingArmFore.x = 4;
						setAnimation(Character.ANIM_POINTING_LEFT);
						vectorToMouseTmp.x = -vectorToMouseTmp.x;
						vectorToMouseTmp.y = -vectorToMouseTmp.y;
					}
					
					
					var angle:Number = vectorToMouseTmp.angle * 57.2957795;
					if (angle < -45) angle = -45;
					if (angle > 40) angle = 40;
					_pointingArmBack.rotation = _pointingArmFore.rotation = angle;
				}
			}
			else
			{
				if (Main.input.rightPressed)
					_direction.x = 1;
				else if (Main.input.leftPressed)
					_direction.x = -1;
				else _direction.x = 0;
				
				if (Main.input.downPressed)
					_direction.y = 1;
				else
					_direction.y = 0;
				
				super.update();
				
				if (Main.input.canJump && _remainingJumps > 0)
				{
					// Jump
					jump();
				}
				
				if (!Main.input.upPressed && _verticalSpeed > 0) _verticalSpeed *= 0.85;
			}
			
		}
		
		protected override function jump():void
		{
			super.jump();
			
			Sounds.playSoundById(Sounds.JUMP);
		}

		public function takeDamage():void
		{
			_framesToStartPointing = Config.LOADING_ANIM_FRAMES_LONG;
			_mouseDown = false;
			_direction.x = 0;
			_direction.y = 0;
			_pointingArmBack.visible = _pointingArmFore.visible = false;
			
			_damaged = true;
			_feetInFloor = false;
			scaleX = _lastScaleX;
			_direction.y = 1;
			_preventDefaultAnimations = true;
			_verticalSpeed = 15;
			setAnimation(ANIM_HIT);
			
			Sounds.playSoundById(Sounds.DAMAGE);
		}
		
		
		public function gameOver():void
		{
			_lastScaleX = -1;
			_gameOver = true;
		}
		
		
		private function shootArrow():void
 		{
 			var angle:Number = clampAngle(_vectorToMouse.angle);
			var pos:Vec2 = physicalBody.position.sub(new Vec2(0, 70));
			_main.arrow.shoot(pos, angle);
			AutoFx.showFx(new FxShoot(), pos.x + Math.cos(angle) * 30, pos.y + Math.sin(angle) * 30);
 			_nArrowsLeft--;
			_main.arrowIndicator.setArrowsEmpty();
 			_pointingArmFore.visible = _pointingArmBack.visible = false;
 			
 			Sounds.playSoundById(Sounds.ARROW_THROW);
		}
		private function onCollisionWithArrow(cb:InteractionCallback):void
		{
			if (Main.input.moveKeyPressed)
			{
				AutoFx.showFx(new FxPickArrow(), _main.arrow.body.position.x, _main.arrow.body.position.y);
				_main.arrow.body.position = new Vec2( -200, -200);
				_nArrowsLeft++;
				_main.arrowIndicator.setArrowAvailable();
				Sounds.playSoundById(Sounds.PICK_UP_ARROW);
			}
		}
		
		private function clampAngle(angle:Number):Number
		{
			if (_lastScaleX > 0)
			{
				if (angle > 0.78) return 0.78;
				else if (angle < -0.78) return -0.78;
			}
			else
			{
				if (angle < 2.27 && angle > 0) return 2.27;
				else if (angle > -2.27 && angle < 0) return -2.27;
			}
			
			return angle;
		}
		
		private function onStageDown(e:MouseEvent):void
		{
			if (_nArrowsLeft <= 0)
				_main.arrowIndicator.doAnimation();
				
			if (!_feetInFloor)
			{
				_mouseHoldingOnAirEvent = e;
			}

			if (_nArrowsLeft <= 0 || !_feetInFloor) return;
			
			// This can happen if the user moves the mouse out of the screen while shooting, releases the mouse button and then comes back to keep playing
			// In this case, the best solution is to allow him to shoot simply by clicking on the screen
			if (_mouseDown) 
				onStageUp(e);
			
			_mouseDown = true;
			(_lastMouseWorldPos.x > physicalBody.position.x) ? _lastScaleX = 1 : _lastScaleX = -1;
			setAnimation(_lastScaleX == 1 ? Character.ANIM_LOADING_RIGHT : Character.ANIM_LOADING_LEFT);
			scaleX = 1;
			trace("DIRECTION: " + _lastScaleX);
			_framesToStartPointing = Config.LOADING_ANIM_FRAMES_LONG;
			_lastMouseWorldPos.x = e.stageX - 0.5 * Config.SCREEN_SIZE_X + _main.cameraX;
			_lastMouseWorldPos.y = e.stageY - 0.5 * Config.SCREEN_SIZE_Y + _main.cameraY + 50;
		}
		private function onStageUp(e:MouseEvent):void
		{
			_mouseDown = false;
			_mouseHoldingOnAirEvent = null;
			_lastMouseWorldPos.x = e.stageX - 0.5 * Config.SCREEN_SIZE_X + _main.cameraX;
			_lastMouseWorldPos.y = e.stageY - 0.5 * Config.SCREEN_SIZE_Y + _main.cameraY + 50;
			if (_framesToStartPointing == -1)
			{
				shootArrow();
				_framesToStartPointing = Config.LOADING_ANIM_FRAMES_LONG;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			_lastMouseWorldPos.x = e.stageX - 0.5 * Config.SCREEN_SIZE_X + _main.cameraX;
			_lastMouseWorldPos.y = e.stageY - 0.5 * Config.SCREEN_SIZE_Y + _main.cameraY + 50;
		}
		private function onMouseOut(e:MouseEvent):void
		{
			//_mouseDown = false;
			//_pointingArmFore.visible = _pointingArmBack.visible = false;
		}
		
	}

}