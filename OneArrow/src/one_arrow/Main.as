package one_arrow
{
	import flash.display.Sprite;
	import flash.events.Event;
	import mochi.as3.MochiScores;
	import mochi.as3.MochiServices;
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
			
			MochiServices.connect("07494139c648b09b", root);
			
			_input = new KeyboardInput();
			_input.init(stage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			changeGameScreen(GameScreen.START_MENU);
		}
		
		
		public static function showLeaderboard(withNewScore:int = -1):void
		{
			var o:Object = { n: [4, 7, 4, 10, 11, 12, 0, 15, 4, 5, 9, 11, 12, 1, 8, 2], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0, "");
			
			if (withNewScore >= 0)
				MochiScores.showLeaderboard({boardID: boardID, score: withNewScore});
			else
				MochiScores.showLeaderboard({boardID: boardID});
		}
		
		private function onEnterFrame(e:Event):void
		{
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