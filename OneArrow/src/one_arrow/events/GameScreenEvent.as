package one_arrow.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class GameScreenEvent extends Event 
	{
		public static const CHANGE_SCREEN:String = "changeScreenEvent";

		protected var _screenType:int;
		
		public function GameScreenEvent(screenType:int, type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			_screenType = screenType;
			
			super(type, bubbles, cancelable);
		}
		
		public function get screenType():int 
		{
			return _screenType;
		}
		
	}

}