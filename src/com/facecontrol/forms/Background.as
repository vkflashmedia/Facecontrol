package com.facecontrol.forms
{
	import com.facecontrol.dialog.PaymentDialog;
	import com.facecontrol.gui.MainMenu;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Background extends GameLayer
	{
		private static var _instance:Background = null;
		public static function get instance():Background {
			if (!_instance) _instance = new Background(Util.scene);
			return _instance;
		}
		
		public var menu:MainMenu;
		private var _goldLinkButton:LinkButton;
		public function Background(value:GameScene)
		{
			super(value);
			bitmap = Util.multiLoader.get(Images.BACKGROUND);
			menu = new MainMenu(scene);
				
			menu.x = 1;
			menu.y = 1;
			
			var format:TextFormat = new TextFormat(Util.university.fontName, 21);
			
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
			b2.setTitleForState('профиль', CONTROL_STATE_NORMAL);
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
			
			var bitmapBack:Bitmap = BitmapUtil.cloneImageNamed(Images.HEAD_BUTTON4);
			var bitmapData:BitmapData = new BitmapData(bitmapBack.width, bitmapBack.height, true, 0);
			bitmapData.draw(bitmapBack);
			var matrix:Matrix = new Matrix();
			matrix.translate(12, 23);
			bitmapData.draw(BitmapUtil.cloneImageNamed(Images.GOLD), matrix);
			
			var b4:Button = new Button(scene, 364, 0);
			b4.setBackgroundImageForState(new Bitmap(bitmapData), CONTROL_STATE_NORMAL);
			b4.setTitleForState('пополнить', CONTROL_STATE_NORMAL);
			b4.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b4.textField.embedFonts = true;
			b4.textField.antiAliasType = AntiAliasType.ADVANCED;
			b4.textField.rotation = -2;
//			b4.setTextPosition(23, 19);
			b4.setTextPosition(35, 19);
			
			var b5:Button = new Button(scene, 483, 0);
			b5.setBackgroundImageForState(Util.multiLoader.get(Images.HEAD_BUTTON5), CONTROL_STATE_NORMAL);
			b5.setTitleForState('рамки', CONTROL_STATE_NORMAL);
			b5.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			b5.textField.embedFonts = true;
			b5.textField.antiAliasType = AntiAliasType.ADVANCED;
			b5.setTextPosition(25, 7);
			
			menu.buttons = new Array(b1, b2, b3, b4, b5);
			
//			var addLinkButton:LinkButton = new LinkButton(value, 'Пополнить', 490, 81);
//			addLinkButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 12, 0xffffff, null, null, true),
//				CONTROL_STATE_NORMAL);
//			addLinkButton.textField.embedFonts = true;
//			addLinkButton.textField.antiAliasType = AntiAliasType.ADVANCED;
//			addLinkButton.textField.autoSize = TextFieldAutoSize.LEFT;
//			addLinkButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
//				_scene.showModal(new PaymentDialog(_scene));
//			});
//			addChild(addLinkButton);
			
			var goldButton:Button = new Button(scene, 560, 82);
			goldButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.GOLD), CONTROL_STATE_NORMAL);
			goldButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				_scene.showModal(new PaymentDialog(_scene));
			});
			addChild(goldButton);
			
			var account:String = '0';
			if (Util.user && Util.user.hasOwnProperty('account')) {
				account = Util.user.account;
			}
			_goldLinkButton = new LinkButton(value, account, 580, 79);
			_goldLinkButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 15, 0xb0dee6), CONTROL_STATE_NORMAL);
			_goldLinkButton.textField.embedFonts = true;
			_goldLinkButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			_goldLinkButton.textField.autoSize = TextFieldAutoSize.LEFT;
			_goldLinkButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				_scene.showModal(new PaymentDialog(_scene));
			});
			addChild(_goldLinkButton);
			
			var ad:Bitmap = BitmapUtil.cloneImageNamed(Images.ADVERTISING_FORM);
			ad.x = (Constants.APP_WIDTH - ad.width) / 2;
			ad.y = Constants.APP_HEIGHT - ad.height;
			//ad.y = Constants.APP_HEIGHT - 2 * ad.height;
			addChild(ad);
			
//			var advPanel: VkAdPanel = new VkAdPanel(Util.scene, ad.x + 10, ad.y + 10, ad.width - 20, ad.height - 20);
////			advPanel.debug = true;
//			addChild(advPanel);

			var errorsBoard:LinkButton = new LinkButton(_scene, 'Есть идеи? Не молчи! Самые интересные предложения ' + 
					'будут реализованы, а автор - вознагражден!', ad.x + 20, ad.y + 20, TextFieldAutoSize.NONE);
			errorsBoard.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 20, 0x45688e, null, null, true), CONTROL_STATE_NORMAL);
			errorsBoard.width = ad.width - 40;
			errorsBoard.textField.wordWrap = true;
			errorsBoard.textField.embedFonts = true;
			errorsBoard.textField.antiAliasType = AntiAliasType.ADVANCED;
			errorsBoard.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function():void {
				navigateToURL((new URLRequest('http://vkontakte.ru/topic-17556795_22792726')));
			});
			addChild(errorsBoard);
		}
		
		public function updateAccount():void {
			var account:String = '0';
			if (Util.user && Util.user.hasOwnProperty('account')) {
				account = Util.user.account;
			}
			_goldLinkButton.textField.defaultTextFormat = _goldLinkButton.textField.getTextFormat();
			_goldLinkButton.textField.text = account;
		}
	}
}