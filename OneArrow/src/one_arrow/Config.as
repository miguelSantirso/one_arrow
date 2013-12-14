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
		
		public static const WORLD_SIZE_METERS_X:int = 28;
		public static const WORLD_SIZE_METERS_Y:int = 18;
		public static const WORLD_SIZE_METERS:Point = new Point(WORLD_SIZE_METERS_X, WORLD_SIZE_METERS_Y);
		
		public static const PIXELS_PER_METER:Number = 50;
		public static const GRAVITY:Number = 10.0;
		
	}

}