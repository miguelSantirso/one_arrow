package one_arrow 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Config 
	{
		public static const DEBUG:Boolean = true;
		
		public static const WORLD_SIZE_X:int = 1800;
		public static const WORLD_SIZE_Y:int = 900;
		public static const WORLD_SIZE:Point = new Point(WORLD_SIZE_X, WORLD_SIZE_Y);
		
		public static const PIXELS_PER_METER:Number = 50;
		
		public static const PLAYER_SPEED_DOWN:Number = 25;
		
		[Embed(source="../../assets/world.json", mimeType="application/octet-stream")]
		public static const WORLD_JSON:Class;
	}

}