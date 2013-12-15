package one_arrow.gameplay.world 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import com.adobe.serialization.json.JSON;
	import nape.callbacks.CbType;
	import nape.dynamics.InteractionFilter;
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.phys.Body;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import one_arrow.gameplay.GameplayMain;
	
	import one_arrow.Main;
	import one_arrow.Config;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class PhysicalWorld 
	{
		public static const TERRAIN_TYPE:CbType = new CbType();
		public static const ARROW_COLLISION_GROUP:int = 1;
		public static const TERRAIN_COLLISION_GROUP:int = 2;
		public static const BOUNDS_COLLISION_GROUP:int = 4;
		
		private var _gameplay:GameplayMain;
		
		public function get space():Space { return _space; }
		private var _space:Space;
		private var debugBitmap:BitmapDebug;
		
		public function PhysicalWorld(mainGameplay:GameplayMain) 
		{
			_gameplay = mainGameplay;
			
			// Create a new simulation Space.
            //   Weak Vec2 will be automatically sent to object pool.
            //   when used as argument to Space constructor.
            var gravity:Vec2 = Vec2.weak(0, 600);
			_space = SpaceLoader.loadSpaceFromRUBE(JSON.decode(new Config.WORLD_JSON()), Config.PIXELS_PER_METER);
            
			_space.bodies.foreach(function(body:Body):void {
				var bodyName:String = body.userData.name;
				if (bodyName)
				{
					if (bodyName.indexOf("terrain") >= 0)
					{
						body.cbTypes.add(TERRAIN_TYPE);
						body.shapes.foreach(function(s:nape.shape.Shape):void {
							s.filter.collisionGroup = TERRAIN_COLLISION_GROUP;
						});
					}
					if (bodyName.indexOf("bound") >= 0)
					{
						body.shapes.foreach(function(s:nape.shape.Shape):void {
							s.filter.collisionGroup = BOUNDS_COLLISION_GROUP;
						});
					}
					if (bodyName.indexOf("arrow") >= 0)
					{
						body.shapes.foreach(function(s:nape.shape.Shape):void {
							s.filter.collisionGroup = ARROW_COLLISION_GROUP;
						});
					}
				}
			});
			
			if (Config.DEBUG)
			{
				// Create a new BitmapDebug screen matching stage dimensions and
				// background colour.
				//   The Debug object itself is not a DisplayObject, we add its
				//   display property to the display list.
				debugBitmap = new BitmapDebug(Config.WORLD_SIZE_X, Config.WORLD_SIZE_Y, 0, true);
				//debugBitmap.display.x = -0.5 * Config.WORLD_SIZE_X;
				//debugBitmap.display.y = Config.WORLD_SIZE_Y;
				Main.instance.addChild(debugBitmap.display);
			}
		}
		
		public function update():void
		{
			_space.step(1 / 30.0);
			
			if (debugBitmap)
			{
				debugBitmap.display.x = 0.5 * Config.SCREEN_SIZE_X - _gameplay.cameraX;
				debugBitmap.display.y = 0.5 * Config.SCREEN_SIZE_Y - _gameplay.cameraY;
				// Render Space to the debug draw.
				//   We first clear the debug screen,
				//   then draw the entire Space,
				//   and finally flush the draw calls to the screen.
				debugBitmap.clear();
				debugBitmap.draw(_space);
				debugBitmap.flush();
			}
			
			_space.bodies.foreach(updateGraphics);
		}
		
		
		public function addBody(b:Body):void
		{
			_space.bodies.add(b);
		}
		
		public function removeBody(b:Body):void
		{
			_space.bodies.remove(b);
		}
		
		
		private function updateGraphics(b:Body):void
		{
			var graphics:DisplayObject = b.userData.graphic;
			if (graphics)
			{
				graphics.x = b.position.x + 0.5 * Config.SCREEN_SIZE_X - _gameplay.cameraX;
				graphics.y = b.position.y + 0.5 * Config.SCREEN_SIZE_Y - _gameplay.cameraY;
				graphics.rotation = b.rotation * 57.2957795;
			}
		}
		
	}

}