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
	import one_arrow.gameplay.projectiles.Projectiles;
	import one_arrow.gameplay.world.PhysicalWorld;
	import one_arrow.Config;
	import one_arrow.GameScreen;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayMain extends GameScreen
	{
		[Embed(source = "../../../assets/background.png")]
		private var BackgroundClass:Class;
		
		public function get physicalWorld():PhysicalWorld { return _physicalWorld; }
		private var _physicalWorld:PhysicalWorld;
		
		public function get bg():Bitmap { return _bg; }
		private var _bg:Bitmap = new BackgroundClass();
		public function get fore():Sprite { return _fore; }
		private var _fore:Sprite = new Sprite();
		
		public function get character():MainCharacter { return _character; }
		private var _character:MainCharacter;
		public function get arrow():Arrow { return _arrow; }
		private var _arrow:Arrow;
		private var _enemies:Enemies;
		private var _projectiles:Projectiles;
		
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
			mouseEnabled = true;
			
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
			addChild(_projectiles);
			
			addChild(_fore);
		}
		
		protected override function dispose(e:Event = null):void
		{
			super.dispose(e);
		}
		
		public override function update():void
		{
			super.update();
			
			_character.update();
			_enemies.update();
			_projectiles.update();
			
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
		}
		
		public function createProjectile(type:int):void
		{
			_projectiles.createProjectile(type:int);
		}
	}

}