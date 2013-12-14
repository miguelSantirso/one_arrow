package one_arrow.gameplay.Enemies 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import one_arrow.gameplay.GameplayMain;
	
	/**
	 * Controls the enemies
	 */
	public class Enemies extends Sprite 
	{
		private var _main:GameplayMain;
		private var _enemiesData:EnemiesData;
		
		public function Enemies(gameplayMain:GameplayMain)
		{
			_main = gameplayMain;
			
			_enemiesData = new EnemiesData();
			_enemiesData.addEventListener(EnemiesData.WAVES_LOADED, onEnemiesDataLoaded);
			_enemiesData.load();
			
			
		}
		
		private function onEnemiesDataLoaded(evt:Event):void
		{
			_enemiesData.removeEventListener(EnemiesData.WAVES_LOADED, onEnemiesDataLoaded);
			
		}
		
	}

}