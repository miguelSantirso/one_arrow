package one_arrow.gameplay 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.character.MainCharacter;
	import one_arrow.gameplay.enemies.Enemies;
	import one_arrow.gameplay.world.PhysicalWorld;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayMain extends Sprite 
	{
		public function get physicalWorld():PhysicalWorld { return _physicalWorld; }
		private var _physicalWorld:PhysicalWorld;
		
		public function get character():Character { return _character; }
		private var _character:Character;
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
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_physicalWorld = new PhysicalWorld(this);
			
			_enemies = new Enemies(this);
			
			_character = new MainCharacter(this);
			addChild(_character);
			_character.physicalBody.position = new Vec2(200, 100);
			_physicalWorld.addBody(_character.physicalBody);
		}
		
		public function update():void
		{
			_character.update();
			
			cameraX = _character.physicalBody.position.x;
			cameraY = _character.physicalBody.position.y;
			
			_physicalWorld.update();
		}
		
	}

}