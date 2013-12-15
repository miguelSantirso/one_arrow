package one_arrow.ui 
{
	
	import flash.display.Sprite;
	import utils.FrameScriptInjector;
	/**
	 * ...
	 * @author ...
	 */
	public class SuccessInformation extends Sprite 
	{
		
		private var _successAnimation:SuccessAnimation;
		
		private var _waveId:int;
		private var _seconds:int;
		private var _points:int;
		
		public function SuccessInformation() 
		{
			_successAnimation = new SuccessAnimation();
			FrameScriptInjector.injectFunctionToLabel(_successAnimation, "waveSet", onWaveSet);
			FrameScriptInjector.injectFunctionToLabel(_successAnimation, "complete", onCompleted);
		}
		
		public function showWave(seconds:int, points:int, waveId:int):void
		{
			_successAnimation.gotoAndStop(1);
			_successAnimation.secondsLeft.secondsText.text = String(seconds);
			_successAnimation.totalScore.scoreText.text = String(points);
			
			_waveId = waveId;
			addChild(_successAnimation);
			_successAnimation.play();
		}
		
		private function onWaveSet():void
		{
			var waveName:String = "WAVE " + _waveId;
			_successAnimation.waveFront.waveText.text = waveName;
			_successAnimation.waveBack.waveText.text = waveName;
		}
		
		private function onCompleted():void
		{
			removeChild(_successAnimation);
		}
		
	}

}