package one_arrow.gameplay.fx 
{
	import flash.display.MovieClip;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.Main;
	import utils.FrameScriptInjector;
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class AutoFx 
	{
		public static var _gameplay:GameplayMain;
		
		public static function showFx(mc:MovieClip, worldX:int, worldY:int):void
		{
			mc.x = worldX;
			mc.y = worldY;
			mc.mouseChildren = false;
			mc.mouseEnabled = false;
			mc.gotoAndPlay(0);
			
			_gameplay.fore.addChild(mc);
			
			FrameScriptInjector.injectFunction(mc, mc.totalFrames, function():void {
				mc.stop();
				var nFrames:int = mc.totalFrames;
				for (var i:int = 0; i < nFrames; ++i) mc.addFrameScript(i, null);
				_gameplay.fore.removeChild(mc);
			});
		}
	}

}