package one_arrow.gameplay.enemies.data 
{
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyData 
	{
		
		public var x:int;
		public var y:int;
		public var type:int;
		
		public function parseEnemy(enemy:XML):void
		{
			x = enemy.@x;
			y = enemy.@y;
			type = enemy.@type;
		}
		
	}

}