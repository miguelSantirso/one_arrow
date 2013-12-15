package one_arrow.gameplay.enemies.data 
{
	import one_arrow.Config;
	/**
	 * ...
	 * @author ...
	 * 
	 * This class loads the enemy Waves configuration.
	 * And returns any data related to the enemy waves.
	 * 
	 */
	public class EnemiesData 
	{
		
		private var _enemyWaves:XML;
		
		private var _waves:Vector.<WaveData>;
		
		private var _actualWaveId:int;
		
				
		public function EnemiesData():void
		{
			_waves = new Vector.<WaveData>();
			_actualWaveId = 0;
		}
		
		
		public function load():void
		{
			_enemyWaves = new XML(new Config.ENEMY_WAVES());
			
			var wave:XML;
			var waveData:WaveData;
			for each(wave in _enemyWaves..wave)
			{
				waveData = new WaveData();
				waveData.parseWave(wave);
				_waves.push(waveData);
				
			}
			
		}
		
		public function get enemiesInWave():Vector.<EnemyData>
		{
			return _waves[_actualWaveId].enemies;
		}
		
		public function nextWave():void
		{
			_actualWaveId++;
		}
		
	}

}