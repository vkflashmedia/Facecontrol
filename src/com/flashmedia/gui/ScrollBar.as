package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;

	public class ScrollBar extends GameObject
	{
		public function ScrollBar(value:GameScene, x:int, y:int, width:int, height:int)
		{
			super(value);
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
	}
}