package com.facecontrol.dialog
{
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PaymentDialog extends GameLayer
	{
		public function PaymentDialog(value:GameScene)
		{
			super(value);
			
			graphics.beginFill(0x00, 0.5);
			graphics.drawRect(0, 0, _scene.width, _scene.height);
			
			bitmap = Util.multiLoader.get(Images.PAYMENT_FORM);
			bitmap.x = (Constants.APP_WIDTH - bitmap.width) / 2;
			bitmap.y = 213;
			
			var label:TextField = Util.createLabel('Пополнение счета', 175, 232, 280, 20);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.CENTER;
			addChild(label);
			
			var buttonTextFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var button:Button = new Button(_scene, bitmap.x + 30, bitmap.y + 65);
			button.setTitleForState('3 монеты', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			button.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				writeOff(1);
			});
			addChild(button);
			
			label = Util.createLabel('1 голос', button.x + button.width + 15, button.y + 10);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label); 
			
			button = new Button(_scene, bitmap.x + 30, button.y + button.height);
			button.setTitleForState('12 монет', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			button.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				writeOff(3);
			});
			addChild(button);
			
			label = Util.createLabel('3 голоса', button.x + button.width + 15, button.y + 10);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label); 
			
			button = new Button(_scene, bitmap.x + 30, button.y + button.height);
			button.setTitleForState('25 монет', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			button.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,  function(event:GameObjectEvent):void {
				writeOff(5);
			});
			addChild(button);
			
			label = Util.createLabel('5 голосов', button.x + button.width + 15, button.y + 10);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label); 
			
			var image:Bitmap = BitmapUtil.cloneImageNamed(Images.ADD_PHOTO_BUTTON_RED);
			button = new Button(_scene, bitmap.x + (bitmap.width - image.width) / 2, button.y + 55);
			button.setTitleForState('Отмена', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(image, CONTROL_STATE_NORMAL);
			button.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,  function(event:GameObjectEvent):void {
				reset();
			});
			addChild(button);
		}
		
		private function reset():void {
			_scene.resetModal(this);
		}
		
		private function writeOff(votes:int):void {
			Util.requestVotes = votes;
			Util.api.withdrawVotes(votes);
			_scene.resetModal(this);
		}
		
		public static function showPayment():void {
			Util.scene.showModal(new PaymentDialog(Util.scene));
		}
	}
}