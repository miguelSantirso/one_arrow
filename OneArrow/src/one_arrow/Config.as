package one_arrow 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class Config 
	{
		public static const DEBUG:Boolean = false;
		
		public static const WORLD_SIZE_X:int = 1923;
		public static const WORLD_SIZE_Y:int = 1095;
		public static const WORLD_SIZE:Point = new Point(WORLD_SIZE_X, WORLD_SIZE_Y);
		
		public static const PIXELS_PER_METER:Number = 60.833333;
		
		public static const PLAYER_SPEED_DOWN:Number = 25;
		public static const PLAYER_SPEED_HORIZONTAL:Number = 17;
		
		[Embed(source="../../assets/world.json", mimeType="application/octet-stream")]
		public static const WORLD_JSON:Class;
		
		[Embed(source="../../assets/enemyWaves.xml", mimeType="application/octet-stream")]
		public static const ENEMY_WAVES:Class;
		
		public static const LOADING_ANIM_FRAMES_LONG:int = 19;
		
	}

}