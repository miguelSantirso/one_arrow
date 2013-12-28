package one_arrow 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class KeyboardInput
	{
		private var _stage:Stage;
		private var _keysState:Dictionary = new Dictionary();
		
		private var _jumpAvailable:Boolean = true;
		
		public function get canJump():Boolean
		{
			var ret:Boolean = _jumpAvailable && upPressed;
			if (ret) _jumpAvailable = false;
			return ret;
		}
		public function get upPressed():Boolean 
		{
			return _keysState[38] || _keysState[87] || _keysState[32];
		}
		public function get downPressed():Boolean 
		{
			return _keysState[40] || _keysState[83];
		}
		public function get leftPressed():Boolean
		{
			return _keysState[37] || _keysState[65];
		}
		public function get rightPressed():Boolean 
		{
			return _keysState[39] || _keysState[68];
		}
		
		public function get moveKeyPressed():Boolean
		{
			return upPressed || downPressed || leftPressed || rightPressed;
		}
		
		
		
		public function init(stage:Stage):void
		{
			_stage = stage;
	
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			enabled = true;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			//trace("key down: " + e.keyCode);
			_keysState[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			//trace("key up: " + e.keyCode);
			_keysState[e.keyCode] = false;
			
			if (e.keyCode == 38 || e.keyCode == 87 || e.keyCode == 32)
				_jumpAvailable = true;
		}
		

		
		public function set enabled(value:Boolean):void
		{
			if (value)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			else
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
	}

}