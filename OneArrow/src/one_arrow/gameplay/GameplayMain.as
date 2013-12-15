package one_arrow.gameplay 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import nape.geom.Vec2;
	import one_arrow.gameplay.character.Character;
	import one_arrow.gameplay.character.MainCharacter;
	import one_arrow.gameplay.enemies.Enemies;
	import one_arrow.gameplay.fx.AutoFx;
	import one_arrow.gameplay.world.PhysicalWorld;
	import one_arrow.Config;
	import one_arrow.GameScreen;
	import one_arrow.ui.ArrowIndicator;
	import one_arrow.ui.BgScoreboard;
	
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
		private var _currentWave:int = -1;
		
		public var cameraX:int = 0;
		public var cameraY:int = 0;
		
		public function GameplayMain():void 
		{
			AutoFx._gameplay = this;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected override function init(e:Event = null):void 
		{
			super.init(e);
			
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
			
			_fore.mouseChildren = false;
			_fore.mouseEnabled = false;
			addChild(_fore);
			_fore.addChild(new ForegroundClass());
			
			_arrowsIndicator = new ArrowIndicator();
			addChild(_arrowsIndicator);
			_arrowsIndicator.x = 20;
			_arrowsIndicator.y = 20;
		}
		
		protected override function dispose(e:Event = null):void
		{
			super.dispose(e);
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
			
			if (_currentWave != _enemies.currentWave)
			{
				_currentWave = _enemies.currentWave;
				if (_currentWave == 2)
				{
					_character.maxJumps = 2;
				}
				_scoreboard.newWave(_currentWave + 1, 30);
			}
			
			_character.update();
			_enemies.update();
			
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
			
			if (cameraX < 400) cameraX = 400;
			if (cameraY < 300) cameraY = 300;
			if (cameraX > Config.WORLD_SIZE_X - 400) cameraX = Config.WORLD_SIZE_X - 400;
			if (cameraY > Config.WORLD_SIZE_Y - 300) cameraY = Config.WORLD_SIZE_Y - 300;
			
			_fore.x = _bg.x = 400 - cameraX;
			_fore.y = _bg.y = 300 - cameraY;
			
			_physicalWorld.update();
			
			_scoreboard.update();
		}
		
	}

}