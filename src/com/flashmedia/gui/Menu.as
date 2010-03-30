package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;

	public class Menu extends GameObject
	{
		private var _firstButton:Button;
		private var _secondButton:Button;
		private var _thirdButton:Button;
		private var _fourthButton:Button;
		private var _fifthButton:Button;
		
		public function Menu(value:GameScene)
		{
			super(value);
		}
		
		public function set firstButton(button:Button):void {
			if (button != null) {
				if (_firstButton != null) removeChild(_firstButton);
				_firstButton = button;
				addChild(_firstButton);
			}
			
			update();
		}
		
		private function update():void {
		}
	}
}