package com.facecontrol.forms
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

	public class MessageDialog extends GameLayer
	{
		public function MessageDialog(value:GameScene, title:String, message:String)
		{
			super(value);
			
			this.graphics.beginFill(0x00, 0.5);
			this.graphics.drawRect(0, 0, _scene.width, _scene.height);
			
			bitmap = Util.multiLoader.get(Images.MESSAGE_DIALOG_BACKGROUND);
			bitmap.x = 166;
			bitmap.y = 214;
			
			var label:TextField = Util.createLabel(title, 175, 232, 282, 20);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.CENTER;
			addChild(label);
			
			label = Util.createLabel(message, 193, 271, 250, 45);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xffffff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.multiline = true;
			label.wordWrap = true;
//			switch (label.numLines) {
//				case 3:
//					label.height = 50;
//				break;
//				case 4:
					label.height = 70;
//				break;
//			}
			addChild(label);
			
			var ok:Button = new Button(_scene, 249, (label.numLines < 3) ? 322 : 332);
			ok.setBackgroundImageForState(Util.multiLoader.get(Images.MESSAGE_DIALOG_BUTTON), CONTROL_STATE_NORMAL);
			ok.setTitleForState('Oк', CONTROL_STATE_NORMAL);
			ok.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			ok.textField.embedFonts = true;
			ok.textField.antiAliasType = AntiAliasType.ADVANCED;
			ok.setTextPosition(58, 11);
			ok.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onOkClick);
			addChild(ok);
		}
		
		public function onOkClick(event:GameObjectEvent):void {
			_scene.resetModal(this);
		}
		
		public static function dialog(title:String, message:String):void {
			var dialog:MessageDialog = new MessageDialog(Util.scene, title, message);
			Util.scene.showModal(dialog);
		}
	}
}