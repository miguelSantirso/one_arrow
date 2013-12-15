package one_arrow.gameplay.enemies.types 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.shape.Polygon;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.enemies.EnemyBase;
	import one_arrow.gameplay.GameplayMain;
	import utils.FrameScriptInjector;
	import one_arrow.gameplay.Arrow;
	import one_arrow.Sounds;
	import one_arrow.Config;
	import one_arrow.gameplay.projectiles.Projectile;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class EnemyTurret extends EnemyBase 
	{
		private static var ATTACK_ANIMATION_COMPLETE:String = "attackComplete";
		private var _framesLeftIdle:int;
		private var _framesLeftShield:int;
		
		public function EnemyTurret(gameplayMain:GameplayMain) 
		{
			super(gameplayMain);
			
			var attackAnimation:MovieClip = _animations[Character.ANIM_ATTACK];
			attackAnimation.gotoAndStop(1);
			FrameScriptInjector.injectStopAtEnd(attackAnimation, ATTACK_ANIMATION_COMPLETE);
			attackAnimation.addEventListener(ATTACK_ANIMATION_COMPLETE, onAttackAnimationComplete);		
		}
		
		protected override function initAnimations():void
		{
			_animations[Character.ANIM_IDLE] = new Enemy03Idle();
			_animations[Character.ANIM_IDLE_SHIELD] = new Enemy03IdleShield();
			_animations[Character.ANIM_ATTACK] = new Enemy03Attack();
			_animations[Character.ANIM_DEFEAT] = new Enemy03Defeat();
		}
		
		protected override function onCollisionWithArrow(cb:InteractionCallback):void
		{
			if (_status != STATUS_IDLE) // only vulnerable state
				return;
				
			super.onCollisionWithArrow(cb);
			
			Sounds.playSoundById(Sounds.ENEMY_DAMAGE);
			Sounds.playSoundById(Sounds.ENEMY_DEATH);
		}
		
		protected function onAttackAnimationComplete(e:Event):void
		{
			// TODO Shoot the projectile
			// it should use a direction Vec2
			var attackAnimation:MovieClip = _animations[Character.ANIM_ATTACK];
			var positionOffset:Point = new Point();
			
			if (attackAnimation && attackAnimation.energy_slot){
				var slot:MovieClip = attackAnimation.energy_slot as MovieClip;
				positionOffset.x = slot.x;
				positionOffset.y = slot.y;
			}
			
			_main.createProjectile(Projectile.TYPE_ENERGY_BALL,_physicalBody.position.toPoint().add(positionOffset));
			
			setIdle();
		}
		
		protected override function onAppearanceComplete(evt:Event):void
		{
			super.onAppearanceComplete(evt);
			
			setShieldIdle();
		}
		
		protected function setAttacking():void
		{
			_status = STATUS_ATTACKING;
			setAnimation(Character.ANIM_ATTACK);
		}
		
		protected function setIdle():void
		{
			_framesLeftIdle = Math.ceil(Config.ENEMY_2_IDLE_SECONDS_AFTER_ATTACK * _main.stage.frameRate) + someRandomFrames();
			_status = STATUS_IDLE;
			setAnimation(Character.ANIM_IDLE);
		}

		protected function setShieldIdle():void
		{
			_framesLeftShield = Math.ceil(Config.ENEMY_2_SHIELD_SECONDS * _main.stage.frameRate) + someRandomFrames();
			_status = STATUS_IDLE_SHIELD;
			setAnimation(Character.ANIM_IDLE_SHIELD);
		}
		
		override public function update():void
		{
			super.update();
			
			switch(_status)
			{
				case STATUS_DEFEAT:
				case STATUS_APPEARING:
				case STATUS_ATTACKING:
					return;
					break;
					
				case STATUS_IDLE_SHIELD:
					if (--_framesLeftShield <= 0) {
						setAttacking();
					}
					break;
				
				case STATUS_IDLE:
					if (--_framesLeftIdle <= 0) {
						setShieldIdle();
					}
					break;
			}
		}
	}

}