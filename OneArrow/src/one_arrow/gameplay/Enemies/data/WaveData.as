package one_arrow.gameplay.enemies.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WaveData 
	{
		
		private var _enemies:Vector.<EnemyData>;
		public function get enemies():Vector.<EnemyData> { return _enemies; }
		
		public function WaveData():void
		{
			_enemies = new Vector.<EnemyData>();
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