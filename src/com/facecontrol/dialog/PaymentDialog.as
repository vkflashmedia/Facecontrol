package com.facecontrol.dialog
{
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	
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
			bitmap.x = 165;
			bitmap.y = 213;
			
			var label:TextField = Util.createLabel('Пополнение счета', 175, 232, 280, 20);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.CENTER;
			addChild(label);
			
			var button:Button = new Button(_scene, 185, 270);
			button.setTitleForState('5 монет', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_RED), CONTROL_STATE_NORMAL);
			button.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				writeOff(1);
			});
			addChild(button);
			
			button = new Button(_scene, 185, button.y + button.height);
			button.setTitleForState('20 монет', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			button.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				writeOff(3);
			});
			addChild(button);
			
			button = new Button(_scene, 185, button.y + button.height);
			button.setTitleForState('50 монет', CONTROL_STATE_NORMAL);
			button.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_GREY), CONTROL_STATE_NORMAL);
			button.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			button.textField.embedFonts = true;
			button.textField.antiAliasType = AntiAliasType.ADVANCED;
			button.setTextPosition(45, 11);
			button.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,  function(event:GameObjectEvent):void {
				writeOff(5);
			});
			addChild(button);
		}
		
		private function writeOff(votes:int):void {
			Util.requestVotes = votes;
			Util.api.withdrawVotes('', votes);
			_scene.resetModal(this);
		}
	}
}