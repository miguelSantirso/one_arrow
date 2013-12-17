package one_arrow.gameplay 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import mochi.as3.MochiEvents;
	import nape.geom.Vec2;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.character.MainCharacter;
	import one_arrow.gameplay.enemies.Enemies;
	import one_arrow.gameplay.enemies.KillerDrone;
	import one_arrow.gameplay.fx.AutoFx;
	import one_arrow.gameplay.projectiles.Projectiles;
	import one_arrow.gameplay.world.PhysicalWorld;
	import one_arrow.Config;
	import one_arrow.GameScreen;
	import one_arrow.Main;
	import one_arrow.ui.ArrowIndicator;
	import one_arrow.ui.BgScoreboard;
	import one_arrow.ui.SuccessInformation;
	import one_arrow.ui.SurviveInformation;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayMain extends GameScreen
	{
		[Embed(source = "../../../assets/background_day.png")]
		private var BackgroundDay:Class;
		[Embed(source = "../../../assets/background_night.png")]
		private var BackgroundNight:Class;
		[Embed(source = "../../../assets/foreground.png")]
		private var ForegroundClass:Class;
		
		public function get physicalWorld():PhysicalWorld { return _physicalWorld; }
		private var _physicalWorld:PhysicalWorld;
		
		public function get bg():Sprite { return _bg; }
		private var _bg:Sprite = new Sprite();
		public function get fore():Sprite { return _fore; }
		private var _fore:Sprite = new Sprite();
		private var _successInformation:SuccessInformation;
		public function get successInformation():SuccessInformation { return _successInformation; }
		private var _surviveInformation:SurviveInformation;
		
		private var _bgDay:Bitmap = new BackgroundDay();
		
		private var _framesElapsed:Number = 0;
		
		public function get arrowIndicator():ArrowIndicator { return _arrowsIndicator; }
		private var _arrowsIndicator:ArrowIndicator;
		public function get scoreboard():BgScoreboard { return _scoreboard; }
		private var _scoreboard:BgScoreboard = new BgScoreboard();
		
		public function get character():MainCharacter { return _character; }
		private var _character:MainCharacter;
		public function get arrow():Arrow { return _arrow; }
		private var _arrow:Arrow;
		private var _enemies:Enemies;
		private var _projectiles:Projectiles;
		
		private var _rules:GameplayRules = new GameplayRules();

		public var cameraX:int = 0;
		public var cameraY:int = 0;
		
		private var _currentWave:int = -1;
		
		public function GameplayMain():void 
		{
			AutoFx._gameplay = this;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected override function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			super.init(e);
			
			MochiEvents.startPlay();
			
			addChild(_bg);

			_bg.mouseChildren = false;
			_bg.addChild(new BackgroundNight());
			_bg.addChild(_bgDay);
			_bg.addChild(_scoreboard);
			
			// entry point
			_physicalWorld = new PhysicalWorld(this);
			
			_arrow = new Arrow(this);
			addChild(_arrow);
			_physicalWorld.addBody(_arrow.body);
			_enemies = new Enemies(this);
			addChild(_enemies);
			_character = new MainCharacter(this);
			_character.physicalBody.position = new Vec2(800, 805);
			addChild(_character);
			_physicalWorld.addBody(_character.physicalBody);
			
			_projectiles = new Projectiles(this);
			_projectiles.mouseEnabled = false;
			addChild(_projectiles);
			
			_fore.mouseChildren = false;
			_fore.mouseEnabled = false;
 			addChild(_fore);
			_fore.addChild(new ForegroundClass());
			
			_arrowsIndicator = new ArrowIndicator();
			addChild(_arrowsIndicator);
			_arrowsIndicator.x = 20;
			_arrowsIndicator.y = 20;
			
			_rules.waveCompletedAndReturnPointsObtained();
			
			_successInformation = new SuccessInformation();
			addChild(_successInformation);
			
			_surviveInformation = new SurviveInformation();
			addChild(_surviveInformation);

			_surviveInformation.show();
		}
		
		protected override function dispose(e:Event = null):void
		{
			super.dispose(e);
			
			_character.dispose();
			_character = null;
			
		}
		
		public override function update():void
		{
			super.update();
		
			_framesElapsed++;
			
			if (_framesElapsed > Config.BG_TRANSITION_END_FRAME)
			{
				if (_bgDay != null)
				{
					_bg.removeChild(_bgDay);
					_bgDay = null;
				}
			}
			else if (_framesElapsed > Config.BG_TRANSITION_START_FRAME && _bgDay.alpha > 0)
			{
				_bgDay.alpha = (Config.BG_TRANSITION_END_FRAME - _framesElapsed) / Config.BG_TRANSITION_FRAMES_LONG;
			}
			
			if (!_rules.isResting() && !_gameOver && _rules.millisRemaining <= 0)
			{
				ranOutOfTime();
			}
			else if (_currentWave != _rules.currentWave && !_rules.isResting() && !_gameOver)
 			{
				_currentWave = _rules.currentWave;
 				if (_currentWave == 0)
 				{
 					_character.maxJumps = 2;
 				}
				
				_enemies.startWave(_currentWave % _enemies.nWaves);
				_scoreboard.newWave(_currentWave + 1);
			}
			else if (!_gameOver && _enemies.isWaveComplete() && !_rules.isResting())
			{
				var timeLeft:int = _rules.millisRemaining / 1000;
				var points:int = _rules.waveCompletedAndReturnPointsObtained();
				_successInformation.showWave(timeLeft, _rules.totalScore, _rules.currentWave + 1);
				_scoreboard.success();
 			}
			
			_character.update();
			_enemies.update();
			_projectiles.update();
			_successInformation.update();
			
			cameraX = _character.physicalBody.position.x;
			cameraY = _character.physicalBody.position.y;
			if (Math.abs(_character.vectorToMouse.x) >= 1)
			{
				cameraX += _character.vectorToMouse.x * 0.12;
			}
			if (Math.abs(_character.vectorToMouse.y) >= 1)
			{
				cameraY += _character.vectorToMouse.y * 0.1;
			}
			
			if (cameraX < 0.5 * Config.SCREEN_SIZE_X) cameraX = 0.5 * Config.SCREEN_SIZE_X;
			if (cameraY < 0.5 * Config.SCREEN_SIZE_Y) cameraY = 0.5 * Config.SCREEN_SIZE_Y;
			if (cameraX > Config.WORLD_SIZE_X - 0.5 * Config.SCREEN_SIZE_X) cameraX = Config.WORLD_SIZE_X - 0.5 * Config.SCREEN_SIZE_X;
			if (cameraY > Config.WORLD_SIZE_Y - 0.5 * Config.SCREEN_SIZE_Y) cameraY = Config.WORLD_SIZE_Y - 0.5 * Config.SCREEN_SIZE_Y;
 			
			_fore.x = _bg.x = 0.5 * Config.SCREEN_SIZE_X - cameraX;
			_fore.y = _bg.y = 0.5 * Config.SCREEN_SIZE_Y - cameraY;
 			
 			_physicalWorld.update();
			
			if (_killerDrone)
				_killerDrone.update();
			
			_rules.update();
			_scoreboard.countDownMillisLeft = _rules.millisRemaining;
			_scoreboard.update();
		}
		
		public function createProjectile(type:int,position:Point):void
		{
			_projectiles.createProjectile(type,position);
		}
		
		
		
		private var _gameOver:Boolean = false;
		private var _killerDrone:KillerDrone;
		private var _gameFinished:Boolean = false;
		public function ranOutOfTime():void
		{
			_gameOver = true;
			_killerDrone = new KillerDrone(this);
			_fore.addChild(_killerDrone);
			_enemies.killAllEnemies();
			_character.gameOver();
		}
		public function removeMainChar():void
		{
			if (contains(_character))
				removeChild(_character);
		}
		public function gameFinished():void
		{
			if (_gameFinished)
				return;
			
			_gameFinished = true;
			var overlay:Sprite = new Sprite();
			overlay.graphics.beginFill(0, 0.4);
			overlay.graphics.drawRect(0, 0, Config.SCREEN_SIZE_X, Config.SCREEN_SIZE_Y);
			addChild(overlay);
			
			Main.showLeaderboard(_rules.totalScore);
		}
	}

}