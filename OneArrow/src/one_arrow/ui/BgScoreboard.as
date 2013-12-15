package one_arrow.ui 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class BgScoreboard extends MovieClip
	{
		private var _tf:TextField;
		
		private var _waveComplete:Boolean = false;
		private var _newWaveFramesLeft:int;
		public var countDownMillisLeft:int;
		
		public function BgScoreboard() 
		{
			var mc:Scoreboard = new Scoreboard();
			addChild(mc);
			x = 722;
			y = 465;
			_tf = mc.tf;
			
			_tf.text = "WELCOME";
		}
		
		
		public function newWave(waveNumber:int):void
		{
			_tf.text = "WAVE " + waveNumber;
			_newWaveFramesLeft = 150;
			_waveComplete = false;
		}
		public function success():void
		{
			_waveComplete = true;
			_tf.text = "SUCCESS";
		}
		
		
		public function update():void
		{
			if (_waveComplete) return;
			
			if (_newWaveFramesLeft > 0)
			{
				_newWaveFramesLeft--;
			}
			else
			{
				if (countDownMillisLeft > 0)
				{
					var aux:int = countDownMillisLeft;
					
					var minutes:int = Math.floor(aux / 1000 / 60);
					aux -= minutes * 60 * 1000;
					var seconds:int = Math.floor(aux / 1000);
					aux -= seconds * 1000;
					var decsSecond:int = Math.floor(aux / 100);
					
					_tf.text = minutes + ":" + (seconds < 10 ? "0" : "") + seconds + ":" + decsSecond;
				}
				else
				{
					_tf.text = "TIME OUT";
				}
			}
			
		}
		
		
	}

}