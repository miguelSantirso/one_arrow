package one_arrow.gameplay 
{
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class GameplayRules 
	{
		private const REST_TIME_FRAMES:int = 160;
		private static const WAVE_INITIAL_MILLIS_LONG:int = 70 * 1000;
		private static const MILLIS_PENALTY_PER_ROUND:int = 30 * 1000;
		private static const ROUND_WAVES_LONG:int = 20;
		private var _waveMillisLong:int = WAVE_INITIAL_MILLIS_LONG;
		
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
			_waveMillisLong = WAVE_INITIAL_MILLIS_LONG - Math.floor(_currentWave / ROUND_WAVES_LONG) * MILLIS_PENALTY_PER_ROUND;
			
			var gainedScore:int = Math.floor(_waveMillisRemaining / 1000.0);
			_totalScore += gainedScore;
			
			_restTimeFramesRemaining = _currentWave == 0 ? 10 : REST_TIME_FRAMES;
			_waveMillisRemaining = _waveMillisLong;
			
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