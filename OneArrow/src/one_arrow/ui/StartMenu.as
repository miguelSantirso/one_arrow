package one_arrow.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import one_arrow.Config;
	import one_arrow.GameScreen;
	import one_arrow.Main;
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
			
			background.scaleX = background.scaleY = Config.SCREEN_SIZE_X / background.width;
			background.x = Main.instance.stage.stageWidth / 2 - background.width / 2;
			background.y = Main.instance.stage.stageHeight / 2 - background.height / 2;
			
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