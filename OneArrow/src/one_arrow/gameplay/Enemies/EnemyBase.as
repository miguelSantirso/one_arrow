package one_arrow.gameplay.enemies 
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
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.Arrow;
	import utils.FrameScriptInjector;
	import one_arrow.Sounds;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class EnemyBase extends Character 
	{	
		public static const DEFEAT_ANIMATION_COMPLETE:String = "deadcomplete";
		public static const APPEARANCE_ANIMATION_COMPLETE:String = "appearanceComplete";
	
		protected static const STATUS_IDLE:int = 1;
		protected static const STATUS_FOLLOWING:int = 2;
		protected static const STATUS_ATTACKING:int = 3;
		protected static const STATUS_DEFEAT:int = 4;
		protected static const STATUS_APPEARING:int = 5;
		protected static const STATUS_LEAVING:int = 6;
		
		protected static const STATUS_IDLE_SHIELD:int = 7;
		
		protected var _enemyCbType:CbType;
		
		protected var _status:int;
		
		protected var _initial_position:Point;
			
		protected var _appearanceEffect:MovieClip;
		
		private var collisionBox:Polygon;
		
		public function EnemyBase(gameplayMain:GameplayMain) 
		{
			super(gameplayMain);
			
			_direction.x = -1;
			_main.physicalWorld.addBody(_physicalBody);
			
			_enemyCbType = new CbType();
			
			initAnimations();
			
			var defeat:MovieClip = _animations[Character.ANIM_DEFEAT];
			
			if (defeat) {
				defeat.gotoAndStop(1);
				FrameScriptInjector.injectStopAtEnd(defeat, DEFEAT_ANIMATION_COMPLETE);
				defeat.addEventListener(DEFEAT_ANIMATION_COMPLETE, onDefeatAnimationComplete);		
			}
			
			collisionBox = new Polygon(Polygon.rect( -35, -84, 70, 60));
			collisionBox.sensorEnabled = true;
			collisionBox.body = _physicalBody;
			//collisionBox.cbTypes.add(_enemyCbType);
			_main.physicalWorld.space.listeners.add(new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.SENSOR,
				_enemyCbType,
				Arrow.ARROW_THROW_CB_TYPE,
				onCollisionWithArrow
			));
			
			_status = STATUS_APPEARING;
		}
		
		protected function initAnimations():void
		{
			// to be overriden 
		}
		
		public function killNow():void
		{
			_status = STATUS_DEFEAT;
			setAnimation(Character.ANIM_DEFEAT);
			collisionBox.cbTypes.clear();
			
			Sounds.playSoundById(Sounds.ENEMY_DAMAGE);
			Sounds.playSoundById(Sounds.ENEMY_DEATH);
		}
		
		protected function onCollisionWithArrow(cb:InteractionCallback):void
		{
			killNow();
		}
		
		public function setPosition(position:Point):void
		{
			_initial_position = position;
			_physicalBody.position.set(new Vec2(position.x, position.y));
			
			_appearanceEffect = new FxEnemyAppear();
			_foreLayer.addChild(_appearanceEffect);
			FrameScriptInjector.injectFunctionToLabel(_appearanceEffect, "appear", onEnemyAppear);
			FrameScriptInjector.injectStopAtEnd(_appearanceEffect, APPEARANCE_ANIMATION_COMPLETE);
			_appearanceEffect.addEventListener(APPEARANCE_ANIMATION_COMPLETE, onAppearanceComplete);
		}
		
		protected function onEnemyAppear():void
		{
			setAnimation(Character.ANIM_IDLE);
			_status = STATUS_IDLE;
			collisionBox.cbTypes.add(_enemyCbType);
		}
		
		protected function onAppearanceComplete(evt:Event):void
		{
			_appearanceEffect.removeEventListener(APPEARANCE_ANIMATION_COMPLETE, onAppearanceComplete);
			_foreLayer.removeChild(_appearanceEffect);
		}
		
		protected function onDefeatAnimationComplete(evt:Event):void
		{
			_main.physicalWorld.removeBody(_physicalBody);
			_animations[Character.ANIM_DEFEAT].removeEventListener(DEFEAT_ANIMATION_COMPLETE, onDefeatAnimationComplete);
			while (_animLayer.numChildren > 0) {
				_animLayer.removeChildAt(0);
			}
			
			dispatchEvent(new Event(DEFEAT_ANIMATION_COMPLETE));
		}
		
		public override function update():void
		{
			// We don't call the super.update()
		}
		
		protected function someRandomFrames(maxFrames:int = 30):int
		{
			return Math.ceil(maxFrames*Math.random())
		}
	}

}