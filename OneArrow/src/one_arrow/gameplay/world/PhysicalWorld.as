package one_arrow.gameplay.world 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import one_arrow.Main;
	import one_arrow.Config;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class PhysicalWorld 
	{
		private var _b2dWorld:b2World;
		
		public function PhysicalWorld() 
		{
			// Creat world AABB
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-0.5 * Config.WORLD_SIZE_METERS_X, 0);
			worldAABB.upperBound.Set(0.5 * Config.WORLD_SIZE_METERS_X, Config.WORLD_SIZE_METERS_Y);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, Config.GRAVITY);
			
			_b2dWorld = new b2World(worldAABB, gravity, true);
			
			if (Config.DEBUG)
			{
				var dbgDraw:b2DebugDraw = new b2DebugDraw();
				var dbgSprite:Sprite = new Sprite();
				Main.instance.addChild(dbgSprite);
				dbgDraw.m_sprite = dbgSprite;
				dbgDraw.m_drawScale = Config.PIXELS_PER_METER;
				dbgDraw.m_fillAlpha = 0.0;
				dbgDraw.m_lineThickness = 1.0;
				dbgDraw.m_drawFlags = 0xFFFFFFFF;
				_b2dWorld.SetDebugDraw(dbgDraw);
			}
		}
		
		
		public function update():void
		{
			_b2dWorld.Step(1/30.0, 5);
		}
		
	}

}