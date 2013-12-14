package one_arrow.gameplay 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import one_arrow.gameplay.world.PhysicalWorld;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayMain extends Sprite 
	{
		public function get physicalWorld():PhysicalWorld { return _physicalWorld; }
		private var _physicalWorld:PhysicalWorld;
		
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
		}
		
		
		public function update():void
		{
			_physicalWorld.update();
		}
		
	}

}