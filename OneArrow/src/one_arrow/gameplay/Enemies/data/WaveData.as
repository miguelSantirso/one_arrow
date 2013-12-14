package one_arrow.gameplay.enemies.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WaveData 
	{
		
		public var _enemies:Array;
		
		public function WaveData():void
		{
			_enemies = new Array();
		}
		
		public function parseWave(wave:XML):void
		{
			
			var enemy:XML;
			var enemyData:EnemyData;
			
			for each(enemy in wave.enemy)
			{
				enemyData = new EnemyData();
				enemyData.parseEnemy(enemy);
				_enemies.push(enemyData);
			}
			
		}
		
	}

}