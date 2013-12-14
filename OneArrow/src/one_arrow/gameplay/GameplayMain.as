package one_arrow.gameplay 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import nape.geom.Vec2;
	import one_arrow.gameplay.character.Character;
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
		
		public function GameplayMain():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_physicalWorld = new PhysicalWorld();
			
			_character = new Character();
			addChild(_character);
			_character.physicalBody.position = new Vec2(200, 100);
			_physicalWorld.addBody(_character.physicalBody);
			_physicalWorld.space.listeners.add(_character.feetListener);
		}
		
		
		public function update():void
		{
			_character.update();
			_physicalWorld.update();
		}
		
	}

}