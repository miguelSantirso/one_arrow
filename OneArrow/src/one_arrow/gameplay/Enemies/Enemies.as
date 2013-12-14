package one_arrow.gameplay.enemies 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import one_arrow.gameplay.enemies.data.EnemiesData;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.character.Character;
	/**
	 * Controls the enemies
	 */
	public class Enemies extends Sprite 
	{
		private var _main:GameplayMain;
		private var _enemiesData:EnemiesData;
		
		private var _enemies:Vector.<Character>;
		
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