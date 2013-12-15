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
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class EnemyTurret extends EnemyBase 
	{
		public function EnemyTurret(gameplayMain:GameplayMain) 
		{
			super(gameplayMain);
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
			super.onCollisionWithArrow(cb);
			
			Sounds.playSoundById(Sounds.ENEMY_DAMAGE);
			Sounds.playSoundById(Sounds.ENEMY_DEATH);
		}

		override public function update():void
		{
			super.update();
			
			switch(_status)
			{
				case STATUS_DEFEAT:
				case STATUS_APPEARING:
					return;
				
			}
		}
	}

}