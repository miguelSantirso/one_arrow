package one_arrow.gameplay.Enemies 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 * 
	 * This class loads the enemy Waves configuration.
	 * And returns any data related to the enemy waves.
	 * 
	 */
	public class EnemiesData extends EventDispatcher
	{
		public static const WAVES_LOADED:String = "WavesLoaded";
		
		private var _loader:URLLoader;
		
		private var _enemyWaves:XML;
		
		public function load():void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoaded);
			
			try {
				_loader.load(new URLRequest("enemyWaves.xml"));
			}catch (e:Error)
			{
				trace("error loading xml");
			}
		}
		
		private function onLoaded(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoaded);
			
			_enemyWaves = new XML(_loader.data as String);
			
			dispatchEvent(new Event(WAVES_LOADED));
		}
		
	}

}