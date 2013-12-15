package one_arrow
{
	import flash.display.Sprite;
	import flash.events.Event;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.ui.StartMenu;
	import one_arrow.events.GameScreenEvent;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Main extends Sprite 
	{
		public static function get instance():Main { return _instance; }
		private static var _instance:Main;
		
		private var _gameplayMain:GameplayMain;
		public static function get input():KeyboardInput { return _input; }
		private static var _input:KeyboardInput;
		
		private var _gameScreen:GameScreen;
		
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
			
			_input = new KeyboardInput();
			_input.init(stage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//_gameplayMain = new GameplayMain();
			//addChild(_gameplayMain);
			
			//addChild(new StartMenu());
			
			changeGameScreen(GameScreen.START_MENU);
		}
		
		
		private function onEnterFrame(e:Event):void
		{
			//_gameplayMain.update();
			
			_gameScreen.update();
		}
		
		private function changeGameScreen(screenType:int):void 
		{
			if (_gameScreen && contains(_gameScreen)) {
				_gameScreen.removeEventListener(GameScreenEvent.CHANGE_SCREEN, onGameScreenChangeEvent);
				removeChild(_gameScreen);
			}
				
			switch(screenType) {
				case GameScreen.START_MENU:
					_gameScreen = new StartMenu();
					break;
					
				case GameScreen.GAMEPLAY:
					_gameScreen = new GameplayMain();
					break;
					
				default:
					break;
			}
			
			if (_gameScreen) {
				_gameScreen.addEventListener(GameScreenEvent.CHANGE_SCREEN, onGameScreenChangeEvent,false,0,true);
				addChild(_gameScreen);	
			}
		}
		
		private function onGameScreenChangeEvent(e:GameScreenEvent):void
		{
			changeGameScreen(e.screenType);
		}
	}
	
}