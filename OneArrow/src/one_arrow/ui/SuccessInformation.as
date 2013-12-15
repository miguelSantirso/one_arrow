package one_arrow.ui 
{
	
	import flash.display.Sprite;
	import one_arrow.Config;
	import utils.FrameScriptInjector;
	/**
	 * ...
	 * @author ...
	 */
	public class SuccessInformation extends Sprite 
	{
		
		private var _successAnimation:SuccessAnimation;
		
		private var _waveId:int;
		private var _points:int;
		private var _seconds:int;
		private var _secondsInterval:int;
		private var _pointsInterval:int;
		private var _actualPoints:int;
		private var _actualSeconds:int;
		
		private var _activeCountDown:Boolean;
		private var _frameCounter:int;
		
		public function SuccessInformation() 
		{
			
			_activeCountDown = false;
			
			_successAnimation = new SuccessAnimation();
			_successAnimation.gotoAndStop(1);
			FrameScriptInjector.injectFunctionToLabel(_successAnimation, "waveSet", onWaveSet);
			FrameScriptInjector.injectFunctionToLabel(_successAnimation, "countdown", onCountDown);
			FrameScriptInjector.injectFunctionToLabel(_successAnimation, "complete", onCompleted);
			
			_successAnimation.scaleX = _successAnimation.scaleY = Config.SCREEN_SIZE_X / _successAnimation.width;
			_successAnimation.y = 0.5 * (Config.SCREEN_SIZE_Y - _successAnimation.height);
		}
		
		public function showWave(seconds:int, points:int, waveId:int):void
		{
			
			_actualPoints = 0;
			_actualSeconds = seconds;
			
			_secondsInterval = seconds / 30;
			_pointsInterval = points / 30;
			
			_seconds = seconds;
			_points = points;
			_waveId = waveId;
			
			setActualScoreSeconds();
			
			addChild(_successAnimation);
			_successAnimation.play();
		}
		
		private function setActualScoreSeconds():void
		{
			_successAnimation.secondsLeft.secondsText.text = String(_actualSeconds);
			_successAnimation.totalScore.scoreText.text = String(_actualPoints);
		}
		
		public function update():void
		{
			if (_activeCountDown)
			{
				_frameCounter++;
				if (_frameCounter > 30)
				{
					_successAnimation.secondsLeft.secondsText.text = String(0);
					_successAnimation.totalScore.scoreText.text = String(_points);
					_activeCountDown = false;
					return;
				}
				
				_actualPoints += _pointsInterval;
				_actualSeconds -= _secondsInterval;
				setActualScoreSeconds();
			}
		}
		
		private function onCountDown():void
		{
			_frameCounter = 0;
			_activeCountDown = true;
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
			_successAnimation.gotoAndStop(1);
		}
		
	}

}