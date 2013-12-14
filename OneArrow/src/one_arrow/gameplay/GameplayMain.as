package one_arrow.gameplay 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.character.MainCharacter;
	import one_arrow.gameplay.Enemies.Enemies;
	import one_arrow.gameplay.Enemies.EnemiesData;
	import one_arrow.gameplay.world.PhysicalWorld;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayMain extends Sprite 
	{
		[Embed(source = "../../../assets/background.png")]
		private var BackgroundClass:Class;
		
		public function get physicalWorld():PhysicalWorld { return _physicalWorld; }
		private var _physicalWorld:PhysicalWorld;
		
		private var _bg:Bitmap = new BackgroundClass();
		
		public function get character():Character { return _character; }
		private var _character:Character;
		public function get arrow():Arrow { return _arrow; }
		private var _arrow:Arrow;
		private var _enemies:Enemies;
		
		public var cameraX:int = 0;
		public var cameraY:int = 0;
		
		public function GameplayMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			addChild(_bg);
			mouseEnabled = true;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_physicalWorld = new PhysicalWorld(this);
			
			_arrow = new Arrow(this);
			addChild(_arrow);
			_physicalWorld.addBody(_arrow.body);
			_enemies = new Enemies(this);
			_character = new MainCharacter(this);
			_character.physicalBody.position = new Vec2(800, 805);
			addChild(_character);
			_physicalWorld.addBody(_character.physicalBody);
		}
		
		public function update():void
		{
			_character.update();
			
			cameraX = _character.physicalBody.position.x;
			cameraY = _character.physicalBody.position.y;
			
			_bg.x = 400 - cameraX;
			_bg.y = 300 - cameraY;
			
			_physicalWorld.update();
		}
		
	}

}