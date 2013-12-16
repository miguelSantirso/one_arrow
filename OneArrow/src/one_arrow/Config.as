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
		
		public static const SCREEN_SIZE_X:int = 1000;
		public static const SCREEN_SIZE_Y:int = 700;
		
		public static const BG_TRANSITION_START_FRAME:Number = 55 * 30;
		public static const BG_TRANSITION_FRAMES_LONG:Number = 60 * 30;
		public static const BG_TRANSITION_END_FRAME:Number = BG_TRANSITION_START_FRAME + BG_TRANSITION_FRAMES_LONG;
		
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
		public static const ENEMY_FRAMES_RELAXED_AFTER_ATTACK:int = 140;
		
		// Enemy 2
		public static const ENEMY_2_IDLE_SECONDS_AFTER_ATTACK:Number = 5.0;
		public static const ENEMY_2_SHIELD_SECONDS:Number = 1.5;
		
		// Projectiles
		public static const PROJECTILE_ENERGY_BALL_LIFE_SECONDS:Number = 4;
		public static const PROJECTILE_ENERGY_BALL_SPEED:Number = 5.0;
		
		public static const LOADING_ANIM_FRAMES_LONG:int = 19;
		
	}

}