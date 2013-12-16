package one_arrow.ui 
{
	/**
	 * ...
	 * @author Miguel Santirso
	 */
	public class ArrowIndicator extends HudArrowsLeft
	{
		
		public function ArrowIndicator() 
		{
			setArrowAvailable();
		}
		
		
		public function setArrowAvailable():void
		{
			gotoAndStop(1);
		}
		public function setArrowsEmpty():void
		{
			gotoAndStop(2);
		}
		public function doAnimation():void
		{
			gotoAndPlay(3);
		}
		
	}

}