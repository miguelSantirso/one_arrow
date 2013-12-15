package one_arrow.gameplay.character 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
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
		
		private var _mouseDown:Boolean = false;
		private var _framesToStartPointing:int = Config.LOADING_ANIM_FRAMES_LONG;
		private var _shootAngle:Number;
		
		private var _pointingArmFore:MovieClip = new MainCharArmPointingRightFore();
		private var _pointingArmBack:MovieClip = new MainCharArmPointingRightBack();
		private var _lastMouseWorldPos:Vec2 = new Vec2();
		public function get vectorToMouse():Vec2 { return _vectorToMouse; }
		private var _vectorToMouse:Vec2 = new Vec2();
		private var _arrowDirection:Vec2 = new Vec2();
		
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
			
			var collisionBox:Polygon = new Polygon(Polygon.rect( -35, -108, 70, 108));
			collisionBox.sensorEnabled = true;
			collisionBox.body = physicalBody;
			collisionBox.cbTypes.add(CHARACTER_CB_TYPE);
			_main.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.BEGIN,
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
		}
		
		
		public override function update():void
		{
			_vectorToMouse = _lastMouseWorldPos.sub(physicalBody.position);
			
			if (_mouseDown)
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
				
				super.update();
				
				if (Main.input.canJump && _remainingJumps > 0)
				{
					// Jump
					jump();
				}
				
				if (!Main.input.upPressed && _verticalSpeed > 0) _verticalSpeed *= 0.5;
			}
			
		}
		
		protected override function jump():void
		{
			super.jump();
			
			Sounds.playSoundById(Sounds.JUMP);
		}
		
		private function shootArrow():void
		{
			var angle:Number = clampAngle(_vectorToMouse.angle);
			_main.arrow.shoot(
				physicalBody.position.sub(new Vec2(0, 70)),
				angle
			);
			_nArrowsLeft--;
			_pointingArmFore.visible = _pointingArmBack.visible = false;
			
			Sounds.playSoundById(Sounds.ARROW_THROW);
		}
		private function onCollisionWithArrow(cb:InteractionCallback):void
		{
			_main.arrow.body.position = new Vec2( -200, -200);
			_nArrowsLeft++;
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
			if (_nArrowsLeft <= 0 || !_feetInFloor) return;
			
			_mouseDown = true;
			setAnimation(_lastScaleX == 1 ? Character.ANIM_LOADING_RIGHT : Character.ANIM_LOADING_LEFT);
			scaleX = 1;
			_framesToStartPointing = Config.LOADING_ANIM_FRAMES_LONG;
			_lastMouseWorldPos.x = e.localX - 400 + _main.cameraX;
			_lastMouseWorldPos.y = e.localY - 300 + _main.cameraY + 50;
		}
		private function onStageUp(e:MouseEvent):void
		{
			_mouseDown = false;
			_lastMouseWorldPos.x = e.localX - 400 + _main.cameraX;
			_lastMouseWorldPos.y = e.localY - 300 + _main.cameraY + 50;
			if (_framesToStartPointing == -1)
			{
				shootArrow();
				_framesToStartPointing = Config.LOADING_ANIM_FRAMES_LONG;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			var p:Point = _main.globalToLocal(new Point(e.stageX, e.stageY));
			_lastMouseWorldPos.x = e.localX - 400 + _main.cameraX;
			_lastMouseWorldPos.y = e.localY - 300 + _main.cameraY + 50;
		}
		
	}

}