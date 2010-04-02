package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;

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
				button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClick);
			}
		}
		
		public function buttonAtIndex(index:uint):Button {
			var button:Button = null;
			if (_buttons != null && (index >= 0 && index < _buttons.length)) {
				button = _buttons[index];
			}
			return button;
		}
		
		private function onButtonClick(event:GameObjectEvent):void {
			var menuEvent:MainMenuEvent = null;
			switch (event.gameObject) {
				case _buttons[0]:
					menuEvent = new MainMenuEvent(MainMenuEvent.FIRST_BUTTON_CLICK);
				break;
				case _buttons[1]:
					menuEvent = new MainMenuEvent(MainMenuEvent.SECOND_BUTTON_CLICK);
				break;
				case _buttons[2]:
					menuEvent = new MainMenuEvent(MainMenuEvent.THIRD_BUTTON_CLICK);
				break;
				case _buttons[3]:
					menuEvent = new MainMenuEvent(MainMenuEvent.FOURTH_BUTTON_CLICK);
				break;
				case _buttons[4]:
					menuEvent = new MainMenuEvent(MainMenuEvent.FIFTH_BUTTON_CLICK);
				break;
			}
			
			if (menuEvent != null) dispatchEvent(menuEvent);
		}
	}
}