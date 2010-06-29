package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;

	public class MainMenu extends GameObject
	{
		private var _buttons:Array;
		private var _context:ProfileContextMenu;
		public function MainMenu(value:GameScene)
		{
			super(value);
			_context = new ProfileContextMenu(value);
			addChild(_context);
			_context.visible = false;
		}
		
		public function set buttons(array:Array):void {
			if (_buttons) {
				for each (var button:Button in _buttons) {
					removeChild(button);
				}
			}
			
			_buttons = array;
			if (_buttons) {
				for each (button in _buttons) {
					addChild(button);
					button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClick);
				}
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
					_context.visible = false;
					menuEvent = new MainMenuEvent(MainMenuEvent.FIRST_BUTTON_CLICK);
				break;
				case _buttons[1]:
					_context.visible = !_context.visible;
				break;
				case _buttons[2]:
					_context.visible = false;
					menuEvent = new MainMenuEvent(MainMenuEvent.THIRD_BUTTON_CLICK);
				break;
				case _buttons[3]:
					_context.visible = false;
					menuEvent = new MainMenuEvent(MainMenuEvent.FOURTH_BUTTON_CLICK);
				break;
				case _buttons[4]:
					_context.visible = false;
					menuEvent = new MainMenuEvent(MainMenuEvent.FIFTH_BUTTON_CLICK);
				break;
			}
			
			if (menuEvent != null) dispatchEvent(menuEvent);
		}
	}
}