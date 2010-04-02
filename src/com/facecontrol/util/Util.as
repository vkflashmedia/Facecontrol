package com.facecontrol.util
{
	import com.efnx.net.MultiLoader;
	import com.facecontrol.gui.MainMenu;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	
	import flash.text.Font;
	import flash.text.TextFormat;
	
	public class Util
	{
		public static var multiLoader: MultiLoader = new MultiLoader();
		public static var scene:GameScene;
		
		private static var _mainMenu:MainMenu;
		
		public static function get mainMenu():MainMenu {
			if (_mainMenu == null) {
				_mainMenu = new MainMenu(scene);
				
				_mainMenu.x = 1;
				_mainMenu.y = 1;
				
				var f:Font = new EmbeddedFonts_University();
				
				var format:TextFormat = new TextFormat();
				format.font = f.fontName;
				format.size = 21;
				
				var b1:Button = new Button(scene, 0, 0);
				b1.setBackgroundImageForState(multiLoader.get(Images.HEAD_BUTTON1), Button.STATE_NORMAL);
				b1.setTitleForState("главная", Button.STATE_NORMAL);
				b1.setTextFormatForState(format, Button.STATE_NORMAL);
				b1.textField.embedFonts = true;
				b1.textField.rotation = -2;
				b1.setTextPosition(66, 10);
				
				var b2:Button = new Button(scene, 149, 0);
				b2.setBackgroundImageForState(multiLoader.get(Images.HEAD_BUTTON2), Button.STATE_NORMAL);
				b2.setTitleForState("мои фото", Button.STATE_NORMAL);
				b2.setTextFormatForState(format, Button.STATE_NORMAL);
				b2.textField.embedFonts = true;
				b2.setTextPosition(23, 10);
				
				var b3:Button = new Button(scene, 257, 0);
				b3.setBackgroundImageForState(multiLoader.get(Images.HEAD_BUTTON3), Button.STATE_NORMAL);
				b3.setTitleForState("top100", Button.STATE_NORMAL);
				b3.setTextFormatForState(format, Button.STATE_NORMAL);
				b3.textField.embedFonts = true;
				b3.textField.rotation = 3
				b3.setTextPosition(30, 10);
				
				var b4:Button = new Button(scene, 364, 0);
				b4.setBackgroundImageForState(multiLoader.get(Images.HEAD_BUTTON4), Button.STATE_NORMAL);
				b4.setTitleForState("bottom100", Button.STATE_NORMAL);
				b4.setTextFormatForState(format, Button.STATE_NORMAL);
				b4.textField.embedFonts = true;
				b4.setTextPosition(23, 10);
				
				var b5:Button = new Button(scene, 483, 0);
				b5.setBackgroundImageForState(multiLoader.get(Images.HEAD_BUTTON5), Button.STATE_NORMAL);
				b5.setTitleForState("друзья", Button.STATE_NORMAL);
				b5.setTextFormatForState(format, Button.STATE_NORMAL);
				b5.textField.embedFonts = true;
				b5.setTextPosition(25, 10);
				
				var buttons:Array = new Array(b1, b2, b3, b4, b5);
				_mainMenu.buttons = buttons;
			}
			
			return _mainMenu;
		}
	}
}