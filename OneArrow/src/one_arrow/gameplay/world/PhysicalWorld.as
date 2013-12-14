package one_arrow.gameplay.world 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.adobe.serialization.json.JSON;
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
            
			if (Config.DEBUG)
			{
				// Create a new BitmapDebug screen matching stage dimensions and
				// background colour.
				//   The Debug object itself is not a DisplayObject, we add its
				//   display property to the display list.
				debugBitmap = new BitmapDebug(Config.WORLD_SIZE_X, Config.WORLD_SIZE_Y, 0, true);
				//debugBitmap.display.x = -0.5 * Config.WORLD_SIZE_X;
				//debugBitmap.display.y = Config.WORLD_SIZE_Y;
				Main.instance.addChildAt(debugBitmap.display, 0);
			}
		}
		
		public function update():void
		{
			_space.step(1 / 30.0);
			
			if (debugBitmap)
			{
				debugBitmap.display.x = 400 - _gameplay.cameraX;
				debugBitmap.display.y = 300 - _gameplay.cameraY;
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
		
		
		private function updateGraphics(b:Body):void
		{
			var graphics:DisplayObject = b.userData.graphic;
			if (graphics)
			{
				graphics.x = b.position.x + 400 - _gameplay.cameraX;
				graphics.y = b.position.y + 300 - _gameplay.cameraY;
				graphics.rotation = b.rotation;
			}
		}
		
	}

}