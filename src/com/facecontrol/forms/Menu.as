package com.facecontrol.forms
{
	import com.facecontrol.gui.MainMenu;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	
	import flash.text.Font;
	import flash.text.TextFormat;

	public class Menu extends GameLayer
	{
		public function Menu(value:GameScene)
		{
			super(value);
			bitmap = Util.multiLoader.get(Images.BACKGROUND);
			var menu:MainMenu = new MainMenu(scene);
				
			menu.x = 1;
			menu.y = 1;
			
			var f:Font = new EmbeddedFonts_University();
			
			var format:TextFormat = new TextFormat();
			format.font = f.fontName;
			format.size = 21;
			
			var b1:Button = new Button(scene, 0, 0);
			b1.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON1), Button.STATE_NORMAL);
			b1.setTitleForState("главная", Button.STATE_NORMAL);
			b1.setTextFormatForState(format, Button.STATE_NORMAL);
			b1.textField.embedFonts = true;
			b1.textField.rotation = -2;
			b1.setTextPosition(66, 16);
			
			var b2:Button = new Button(scene, 149, 0);
			b2.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON2), Button.STATE_NORMAL);
			b2.setTitleForState("мои фото", Button.STATE_NORMAL);
			b2.setTextFormatForState(format, Button.STATE_NORMAL);
			b2.textField.embedFonts = true;
			b2.setTextPosition(23, 7);
			
			var b3:Button = new Button(scene, 257, 0);
			b3.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON3), Button.STATE_NORMAL);
			b3.setTitleForState("top100", Button.STATE_NORMAL);
			b3.setTextFormatForState(format, Button.STATE_NORMAL);
			b3.textField.embedFonts = true;
			b3.textField.rotation = 3
			b3.setTextPosition(30, 11);
			
			var b4:Button = new Button(scene, 364, 0);
			b4.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON4), Button.STATE_NORMAL);
			b4.setTitleForState("bottom100", Button.STATE_NORMAL);
			b4.setTextFormatForState(format, Button.STATE_NORMAL);
			b4.textField.embedFonts = true;
			b4.textField.rotation = -3;
			b4.setTextPosition(23, 19);
			
			var b5:Button = new Button(scene, 483, 0);
			b5.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON5), Button.STATE_NORMAL);
			b5.setTitleForState("друзья", Button.STATE_NORMAL);
			b5.setTextFormatForState(format, Button.STATE_NORMAL);
			b5.textField.embedFonts = true;
			b5.setTextPosition(25, 7);
			
			menu.buttons = new Array(b1, b2, b3, b4, b5);
			addChild(menu);
		}
		
	}
}