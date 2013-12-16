package one_arrow.gameplay.enemies 
{
	import flash.display.MovieClip;
	import nape.geom.Vec2;
	import one_arrow.gameplay.GameplayMain;
	import one_arrow.Sounds;
	
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class KillerDrone extends MovieClip 
	{
		private const _MOVEMENT_SPEED:Number = 5;
		
		private var _inPosition:Boolean = false;
		private var _finalAnimation:MovieClip = null;
		private var _gameplay:GameplayMain;
		
		public function KillerDrone(gameplayMain:GameplayMain) 
		{
			_gameplay = gameplayMain;
			
			addChild(new DronFlyingLoop);
			
			x = _gameplay.character.physicalBody.position.x;
			y = 0;
		}
		
		
		public function update():void
		{
			var dir:Vec2 = new Vec2(_gameplay.character.physicalBody.position.x - x, _gameplay.character.physicalBody.position.y - y);
			if (dir.length < _MOVEMENT_SPEED * _MOVEMENT_SPEED)
			{
				x += dir.x;
				y += dir.y;
				_inPosition = true;
			}
			
			if (!_inPosition)
			{
				dir.length = 1;
				
				x += dir.x * _MOVEMENT_SPEED;
				y += dir.y * _MOVEMENT_SPEED;
			}
			else if (_finalAnimation == null)
			{
				while (numChildren > 0)
					removeChildAt(0);
				
				_finalAnimation = new DronKilling();
				addChild(_finalAnimation);
				_gameplay.removeMainChar();
			}
			else if (_finalAnimation.currentFrame ==  33)
			{
				Sounds.playSoundById(Sounds.ENEMY_DRON_KILLING);
			}
			else if (_finalAnimation.currentFrame == _finalAnimation.totalFrames)
			{
				_finalAnimation.stop();
				while (numChildren > 0)
					removeChildAt(0);
				
				
				addChild(new DronFlyingLoop());
				_gameplay.gameFinished();
			}
		}
		
	}

}