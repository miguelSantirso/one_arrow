package one_arrow.gameplay 
{
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayRules 
	{
		private const REST_TIME_FRAMES:int = 160;
		private var _waveMillisLong:int = 90 * 30 * 1000;
		
		public function get totalScore():Number { return _totalScore; }
		private var _totalScore:int;
		
		public function get currentWave():int { return _currentWave; }
		private var _currentWave:int = -1;
		private var _restTimeFramesRemaining:Number;
		public function get millisRemaining():Number { return _waveMillisRemaining; }
		private var _waveMillisRemaining:Number;
		
		public function isResting():Boolean
		{
			return _restTimeFramesRemaining > 0;
		}
		
		
		public function waveCompletedAndReturnPointsObtained():int
		{
			_currentWave++;
			_restTimeFramesRemaining = REST_TIME_FRAMES;
			_waveMillisRemaining = _waveMillisLong;
			
			var gainedScore:int = Math.floor(_restTimeFramesRemaining / 1000.0);
			_totalScore += gainedScore;
			return gainedScore;
		}
		
		public function update():void
		{
			if (_restTimeFramesRemaining > 0)
			{
				_restTimeFramesRemaining--;
			}
			else
			{
				_waveMillisRemaining -= 1000 / 30;
			}
		}
	}

}