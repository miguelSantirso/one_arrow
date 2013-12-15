package one_arrow 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import one_arrow.events.GameScreenEvent;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class GameScreen extends Sprite
	{
		public static const START_MENU:int = 0;
		public static const GAMEPLAY:int = 1;
		
		public function GameScreen() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
	
		protected function init(e:Event = null):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);	
		}

		protected function dispose(e:Event = null):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function update():void
		{
			
		}
		
		protected function requestScreenChange(screenType:int):void
		{
			dispatchEvent(new GameScreenEvent(screenType, GameScreenEvent.CHANGE_SCREEN));
		}
	}

}