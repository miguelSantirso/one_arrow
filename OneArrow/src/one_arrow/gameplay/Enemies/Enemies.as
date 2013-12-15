package one_arrow.gameplay.enemies 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import one_arrow.gameplay.enemies.data.EnemiesData;
	import one_arrow.gameplay.enemies.data.EnemyData;
	import one_arrow.gameplay.enemies.types.EnemyFly;
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
			
			_enemies = new Vector.<Character>;
			
			_enemiesData = new EnemiesData();
			_enemiesData.load();
			loadEnemies();
		}
		
		public function loadEnemies():void
		{
			var newEnemy:Character;
			
			for (var i:int = 0; i < _enemiesData.enemiesInWave.length; i++)
			{
				switch(_enemiesData.enemiesInWave[i].type)
				{
					case 0:
						newEnemy = new EnemyFly(_main);
						_enemies.push(newEnemy);
						(newEnemy as EnemyFly).setPosition(new Point(_enemiesData.enemiesInWave[i].x, _enemiesData.enemiesInWave[i].y));
						newEnemy.addEventListener(EnemyFly.DEFEAT_ANIMATION_COMPLETE, onEnemyDefeat);
						addChild(newEnemy);
						
					break;
				}
			}
			
		}
		
		private function onEnemyDefeat(evt:Event):void
		{
			evt.currentTarget.removeEventListener(EnemyFly.DEFEAT_ANIMATION_COMPLETE, onEnemyDefeat);
			
			for (var i:int = 0; i < _enemies.length; i++)
			{
				if (_enemies[i] == evt.currentTarget)
				{
					_enemies.splice(i, 1);
					return;
				}
			}
		}
		
		public function update():void
		{
			
			for (var i:int = 0; i < _enemies.length; i++)
			{
				_enemies[i].update();
			}
		}
	}

}