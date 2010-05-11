package com.facecontrol.forms
{
	import com.facecontrol.gui.MainMenu;
	import com.facecontrol.gui.VkAdPanel;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFormat;

	public class Background extends GameLayer
	{
		public var menu:MainMenu;
		public function Background(value:GameScene)
		{
			super(value);
			bitmap = Util.multiLoader.get(Images.BACKGROUND);
			menu = new MainMenu(scene);
				
			menu.x = 1;
			menu.y = 1;
			
			var f:Font = new EmbeddedFonts_University();
			
			var format:TextFormat = new TextFormat();
			format.font = f.fontName;
			format.size = 21;
			
			var b1:Button = new Button(scene, 0, 0);
			b1.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON1), CONTROL_STATE_NORMAL);
			b1.setTitleForState('главная', CONTROL_STATE_NORMAL);
			b1.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b1.textField.embedFonts = true;
			b1.textField.antiAliasType = AntiAliasType.ADVANCED;
			b1.textField.rotation = -2;
			b1.setTextPosition(66, 16);
			
			var b2:Button = new Button(scene, 149, 0);
			b2.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON2), CONTROL_STATE_NORMAL);
			b2.setTitleForState('мои фото', CONTROL_STATE_NORMAL);
			b2.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b2.textField.embedFonts = true;
			b2.textField.antiAliasType = AntiAliasType.ADVANCED;
			b2.setTextPosition(23, 7);
			
			var b3:Button = new Button(scene, 257, 0);
			b3.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON3), CONTROL_STATE_NORMAL);
			b3.setTitleForState('top100', CONTROL_STATE_NORMAL);
			b3.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b3.textField.embedFonts = true;
			b3.textField.antiAliasType = AntiAliasType.ADVANCED;
			b3.textField.rotation = 3
			b3.setTextPosition(30, 11);
			
			var b4:Button = new Button(scene, 364, 0);
			b4.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON4), CONTROL_STATE_NORMAL);
			b4.setTitleForState('избранные', CONTROL_STATE_NORMAL);
			b4.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b4.textField.embedFonts = true;
			b4.textField.antiAliasType = AntiAliasType.ADVANCED;
			b4.textField.rotation = -3;
			b4.setTextPosition(23, 19);
			
			var b5:Button = new Button(scene, 483, 0);
			b5.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON5), CONTROL_STATE_NORMAL);
			b5.setTitleForState('друзья', CONTROL_STATE_NORMAL);
			b5.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b5.textField.embedFonts = true;
			b5.textField.antiAliasType = AntiAliasType.ADVANCED;
			b5.setTextPosition(25, 7);
			
			menu.buttons = new Array(b1, b2, b3, b4, b5);
			addChild(menu);
			
			var ad:Bitmap = Util.multiLoader.get(Images.ADVERTISING_FORM);
			ad.x = (Constants.APP_WIDTH - ad.width) / 2;
			ad.y = Constants.APP_HEIGHT - ad.height;
			//ad.y = Constants.APP_HEIGHT - 2 * ad.height;
			addChild(ad);
			
			var advPanel: VkAdPanel = new VkAdPanel(Util.scene, ad.x + 10, ad.y + 10, ad.width - 20, ad.height - 20);
			addChild(advPanel);
		}
		
	}
}