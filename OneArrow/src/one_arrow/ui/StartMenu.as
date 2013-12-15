package one_arrow.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import one_arrow.GameScreen;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class StartMenu extends GameScreen
	{
		private var background:start_menu;
		
		public function StartMenu() 
		{
			
		}
		
		protected override function init(e:Event = null):void
		{
			super.init(e);
			
			background = new start_menu();
			addChild(background);
			
			addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
		}
		
		protected override function dispose(e:Event = null):void
		{
			super.dispose(e);
			
			removeEventListener(MouseEvent.CLICK,onMouseClick);
			
			removeChild(background);
		}
		
		public override function update():void
		{
			super.update();
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			requestScreenChange(GameScreen.GAMEPLAY);
		}
	}

}