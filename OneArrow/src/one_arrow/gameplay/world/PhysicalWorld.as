package one_arrow.gameplay.world 
{
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
	
	import one_arrow.Main;
	import one_arrow.Config;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class PhysicalWorld 
	{
		private var space:Space;
		private var debugBitmap:BitmapDebug;
		
		public function PhysicalWorld() 
		{
			// Create a new simulation Space.
            //   Weak Vec2 will be automatically sent to object pool.
            //   when used as argument to Space constructor.
            var gravity:Vec2 = Vec2.weak(0, 600);
			space = SpaceLoader.loadSpaceFromRUBE(JSON.decode(new Config.WORLD_JSON()), 50);
            
			if (Config.DEBUG)
			{
				// Create a new BitmapDebug screen matching stage dimensions and
				// background colour.
				//   The Debug object itself is not a DisplayObject, we add its
				//   display property to the display list.
				debugBitmap = new BitmapDebug(Config.WORLD_SIZE_X, Config.WORLD_SIZE_Y);
				//debugBitmap.display.x = -0.5 * Config.WORLD_SIZE_X;
				//debugBitmap.display.y = Config.WORLD_SIZE_Y;
				Main.instance.addChild(debugBitmap.display);
			}
			
			//loadSpaceFromRUBE(new Config.WORLD_JSON());
            //setUp();
		}
		
		
		private function setUp():void {
            var w:int = Config.WORLD_SIZE_X;
            var h:int = Config.WORLD_SIZE_Y;
 
            // Create the floor for the simulation.
            //   We use a STATIC type object, and give it a single
            //   Polygon with vertices defined by Polygon.rect utility
            //   whose arguments are (x, y) of top-left corner and the
            //   width and height.
            //
            //   A static object does not rotate, so we don't need to
            //   care that the origin of the Body (0, 0) is not in the
            //   centre of the Body's shapes.
			
            var floor:Body = new Body(BodyType.STATIC);
            floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
            floor.space = space;
 
            // Create a tower of boxes.
            //   We use a DYNAMIC type object, and give it a single
            //   Polygon with vertices defined by Polygon.box utility
            //   whose arguments are the width and height of box.
            //
            //   Polygon.box(w, h) === Polygon.rect((-w / 2), (-h / 2), w, h)
            //   which means we get a box whose centre is the body origin (0, 0)
            //   and that when this object rotates about its centre it will
            //   act as expected.
            for (var i:int = 0; i < 16; i++) {
                var box:Body = new Body(BodyType.DYNAMIC);
                box.shapes.add(new Polygon(Polygon.box(16, 32)));
                box.position.setxy((w / 2), ((h - 50) - 32 * (i + 0.5)));
                box.space = space;
            }
 
            // Create the rolling ball.
            //   We use a DYNAMIC type object, and give it a single
            //   Circle with radius 50px. Unless specified otherwise
            //   in the second optional argument, the circle is always
            //   centered at the origin.
            //
            //   we give it an angular velocity so when it touched
            //   the floor it will begin rolling towards the tower.
            var ball:Body = new Body(BodyType.DYNAMIC);
            ball.shapes.add(new Circle(50));
            ball.position.setxy(50, h / 2);
            ball.angularVel = 10;
            ball.space = space;
 
            // In each case we have used for adding a Shape to a Body
            //    body.shapes.add(shape);
            // We can also use:
            //    shape.body = body;
            //
            // And for adding the Body to a Space:
            //    body.space = space;
            // We can also use:
            //    space.bodies.add(body);
        }
		
		public function update():void
		{
			space.step(1 / 30.0);
			
			if (debugBitmap)
			{
				// Render Space to the debug draw.
				//   We first clear the debug screen,
				//   then draw the entire Space,
				//   and finally flush the draw calls to the screen.
				debugBitmap.clear();
				debugBitmap.draw(space);
				debugBitmap.flush();
			}
		}
		
	}

}