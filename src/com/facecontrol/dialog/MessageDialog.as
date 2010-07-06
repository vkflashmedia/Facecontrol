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

	public class MessageDialog extends GameLayer
	{
		public function MessageDialog(value:GameScene, title:String, message:String, cancelButton:String, secondButton:String=null)
		{
			super(value);
			
			this.graphics.beginFill(0x00, 0.5);
			this.graphics.drawRect(0, 0, _scene.width, _scene.height);
			
			bitmap = Util.multiLoader.get(Images.MESSAGE_DIALOG_BACKGROUND);
			bitmap.x = (Constants.APP_WIDTH - bitmap.width) / 2;
			bitmap.y = 214;
			
			var label:TextField = Util.createLabel(title, 175, 232, 282, 20);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.CENTER;
			addChild(label);
			
			label = Util.createLabel(message, 193, 271, 250, 50);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xffffff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.multiline = true;
			label.wordWrap = true;
			switch (label.numLines) {
				case 4:
					label.height = 70;
				break;
			}
			addChild(label);
			
			var buttonTextFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var buttonY:int = (label.numLines < 3) ? 322 : 332;
			var buttonImage:Bitmap = BitmapUtil.cloneImageNamed(Images.MESSAGE_DIALOG_BUTTON);
			var cancelX:int = secondButton ? bitmap.x + 14 : bitmap.x + (bitmap.width - buttonImage.width) / 2;
			var cancel:Button = new Button(_scene, cancelX, buttonY);
			cancel.setBackgroundImageForState(buttonImage, CONTROL_STATE_NORMAL);
			cancel.setTitleForState(cancelButton, CONTROL_STATE_NORMAL);
			cancel.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
			cancel.textField.embedFonts = true;
			cancel.textField.antiAliasType = AntiAliasType.ADVANCED;
			cancel.setTextPosition(58, 11);
			cancel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelButtonClicked);
			addChild(cancel);
			
			if (secondButton) {
				var second:Button = new Button(_scene, cancel.x + cancel.width, buttonY);
				second.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
				second.setTitleForState(secondButton, CONTROL_STATE_NORMAL);
				second.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
				second.textField.embedFonts = true;
				second.textField.antiAliasType = AntiAliasType.ADVANCED;
				second.setTextPosition(58, 11);
				second.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onSecondButtonClicked);
				addChild(second);
			}
		}
		
		public function onCancelButtonClicked(event:GameObjectEvent):void {
			_scene.resetModal(this);
			dispatchEvent(new MessageDialogEvent(MessageDialogEvent.CANCEL_BUTTON_CLICKED));
		}
		
		public function onSecondButtonClicked(event:GameObjectEvent):void {
			_scene.resetModal(this);
			dispatchEvent(new MessageDialogEvent(MessageDialogEvent.SECOND_BUTTON_CLICKED));
		}
		
		public static function dialog(title:String, message:String):void {
			var dialog:MessageDialog = new MessageDialog(Util.scene, title, message, 'Oк');
			Util.scene.showModal(dialog);
		}
	}
}