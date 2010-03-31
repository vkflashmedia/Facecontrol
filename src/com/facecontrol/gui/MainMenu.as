package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;

	public class MainMenu extends GameObject
	{
		private var _buttons:Array;
		
		public function MainMenu(value:GameScene)
		{
			super(value);
		}
		
		public function set buttons(array:Array):void {
			var i:uint = 0;
			var count:uint = 0;
			if (_buttons) {
				count = _buttons.length;
				for (i = 0; i < count; ++i) {
					removeChild(_buttons[i]);
				}
			}
			
			_buttons = array;
			count = _buttons.length;
			for (i = 0; i < count; ++i) {
				var button:Button = _buttons[i];
				addChild(_buttons[i]);
//				button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, on
			}
		}
	}
}