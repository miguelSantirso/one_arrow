package one_arrow 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	
	public class Sounds 
	{
		public static const ARROW_THROW:int = registerSound(SoundThrow, "ArrowThrow");
		public static const JUMP:int = registerSound(SoundJump, "Jump");
		public static const DAMAGE:int = registerSound(SoundDmg, "Damage");
		public static const ENEMY_DEATH:int = registerSound(SoundEnemyDeath, "EnemyDeath");
		public static const ENEMY_SPAWN:int = registerSound(SoundEnemySpawn, "EnemySpawn");
		public static const ENEMY_DAMAGE:int = registerSound(SoundEnemyDmg, "EnemyDamage");
		
		private static var _soundsById:Vector.<Sound>;
		private static var _soundsByName:Dictionary;
		
		private static var _soundChannel:SoundChannel = new SoundChannel();
		
		private static const LOW_VOLUME:Number = 0.5;
		private static const NORMAL_VOLUME:Number = 0.5;
		
		
		public static function playSoundById(id:int, loops:int = 1):void
		{
				_soundChannel = _soundsById[id].play(0, loops);
		}
		public static function playSoundByName(name:String):void
		{
				if (_soundsByName[name] == null)
						throw new Error("Sounds: Can't find sound with name " + name);
				
				_soundChannel = new SoundChannel();
				_soundChannel = _soundsByName[name].play();
		}
		public static function stopSoundById(id:int):void
		{
				_soundChannel.stop();
		}
		
		private static function registerSound(soundClass:Class, name:String):int
		{
				if (!_soundsByName) _soundsByName = new Dictionary();
				if (!_soundsById) _soundsById = new Vector.<Sound>();
				
				if (_soundsByName[name])
						throw new Error("Sounds: More than one sound with the same name: " + name);
				
				var sound:Sound = new soundClass() as Sound;
				
				_soundsById[_soundsById.length] = sound;
				_soundsByName[name] = sound;
				
				return _soundsById.length - 1;
		}
			
	}

}