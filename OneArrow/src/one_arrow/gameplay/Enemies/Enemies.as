package one_arrow.gameplay.enemies 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import one_arrow.gameplay.enemies.data.EnemiesData;
	import one_arrow.gameplay.enemies.data.EnemyData;
	import one_arrow.gameplay.enemies.types.EnemyFly;
	import one_arrow.gameplay.enemies.types.EnemyFly1;
	import one_arrow.gameplay.enemies.types.EnemyFly2;
	import one_arrow.gameplay.enemies.types.EnemyTurret;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.gameplay.character.Character;
	import one_arrow.Sounds;
	/**
	 * Controls the enemies
	 */
	public class Enemies extends Sprite
	{
		private var _main:GameplayMain;
		private var _enemiesData:EnemiesData;
		
		private var _enemies:Vector.<EnemyBase>;
		
		private static const STATUS_FIGHTING:int = 0;
		private static const STATUS_WAITING:int = 1;
		private var _status:int;
		
		public function get nWaves():int { return _enemiesData.nWaves; }
		public function get currentWave():int { return _enemiesData.currentWave; }
		
		public function Enemies(gameplayMain:GameplayMain)
		{
			_main = gameplayMain;
			
			_enemies = new Vector.<EnemyBase>;
			
			_status = STATUS_FIGHTING;
			
			_enemiesData = new EnemiesData();
			_enemiesData.load();
		}
		
		public function loadEnemies():void
		{
			var newEnemy:Character;
			
			for (var i:int = 0; i < _enemiesData.enemiesInWave.length; i++)
			{
				newEnemy = null;
				
				switch(_enemiesData.enemiesInWave[i].type)
				{
					case 0:
						newEnemy = new EnemyFly1(_main);
						(newEnemy as EnemyFly).setPosition(new Point(_enemiesData.enemiesInWave[i].x, _enemiesData.enemiesInWave[i].y));
						break;
					
					case 2:
						newEnemy = new EnemyTurret(_main);
						(newEnemy as EnemyTurret).setPosition(new Point(_enemiesData.enemiesInWave[i].x, _enemiesData.enemiesInWave[i].y));
						break;
					
					case 3:
						newEnemy = new EnemyFly2(_main);
						(newEnemy as EnemyFly).setPosition(new Point(_enemiesData.enemiesInWave[i].x, _enemiesData.enemiesInWave[i].y));
						break;
						
					default:
						break;
				}
				
				if (newEnemy) {
					_enemies.push(newEnemy);
					newEnemy.addEventListener(EnemyBase.DEFEAT_ANIMATION_COMPLETE, onEnemyDefeat);
					addChild(newEnemy);
				}
			}
			
		}
		
		
		public function killAllEnemies():void
		{
			for each (var e:EnemyBase in _enemies)
			{
				e.killNow();
			}
		}
		
		
		public function isWaveComplete():Boolean
		{
			return _status == STATUS_WAITING;
		}
		
		private function onEnemyDefeat(evt:Event):void
		{
			evt.currentTarget.removeEventListener(EnemyBase.DEFEAT_ANIMATION_COMPLETE, onEnemyDefeat);
			
			for (var i:int = 0; i < _enemies.length; i++)
			{
				if (_enemies[i] == evt.currentTarget)
				{
					_enemies[i].dispose();
					_enemies.splice(i, 1);
					
					if (_enemies.length == 0)
						_status = STATUS_WAITING;
						
					return;
				}
			}
		}
		
		
		public function startWave(waveIndex:int):void
		{
			_enemiesData.currentWave = waveIndex;
			loadEnemies();
			
			_status = STATUS_FIGHTING;
			Sounds.playSoundById(Sounds.ENEMY_SPAWN);
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