package one_arrow.ui 
{
	import one_arrow.Config;
	import utils.FrameScriptInjector;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class SurviveInformation extends Sprite
	{
		
		private var _surviveAnimation:SurviveAnimation;
		
		public function SurviveInformation() 
		{
			mouseEnabled = mouseChildren = false;
			_surviveAnimation = new SurviveAnimation();
			_surviveAnimation.gotoAndStop(1);
			FrameScriptInjector.injectFunctionToLabel(_surviveAnimation, "completed", onCompleted);
			
			_surviveAnimation.scaleX = _surviveAnimation.scaleY = 1.25;
			//_surviveAnimation.x = 0.5 * Config.SCREEN_SIZE_X;// -_surviveAnimation.width / 2;
			_surviveAnimation.y = 10;
		}
		
		public function show():void
		{
			addChild(_surviveAnimation);
			_surviveAnimation.play();
		}
		
		
		private function onCompleted():void
		{
			removeChild(_surviveAnimation);
			_surviveAnimation.gotoAndStop(1);
		}
	}

}