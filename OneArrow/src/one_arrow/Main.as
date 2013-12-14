package one_arrow
{
	import flash.display.Sprite;
	import flash.events.Event;
	import one_arrow.gameplay.GameplayMain;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Main extends Sprite 
	{
		public static function get instance():Main { return _instance; }
		private static var _instance:Main;
		
		private var _gameplayMain:GameplayMain;
		
		
		public function Main():void 
		{
			_instance = this;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_gameplayMain = new GameplayMain();
			addChild(_gameplayMain);
		}
		
		
		private function onEnterFrame(e:Event):void
		{
			_gameplayMain.update();
		}
		
	}
	
}