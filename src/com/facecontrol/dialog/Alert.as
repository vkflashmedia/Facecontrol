package com.facecontrol.dialog
{
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Alert extends GameObject
	{
		private static const TOP_INDENT:int								= 20;
		private static const LEFT_INDENT:int							= 40;
		private static const RIGHT_INDENT:int							= 40;
		private static const BOTTOM_INDENT:int							= 0;
		
		private static const INDENT_BETWEEN_TITLE_AND_MESSAGE:int		= 40;
		private static const INDENT_BETWEEN_MESSAGE_AND_BUTTON:int		= 10;
		
		public function Alert(value:GameScene, title:String, message:String, cancel:String)
		{
			super(value);
			
			graphics.beginFill(0x00, 0.5);
			graphics.drawRect(0, 0, _scene.width, _scene.height);
			graphics.endFill();
			
			var layer:Sprite = new Sprite();
			addChild(layer);
			
			var background:Bitmap = BitmapUtil.cloneImageNamed(Images.MSG_DIALOG_BCK);
			layer.addChild(background);
			
			var dialogX:int = (Constants.APP_WIDTH - background.width) / 2;
			var dialogWidth:int = background.width;
			
			var titleField:TextField = Util.createLabel(title, 0, TOP_INDENT,
				background.width - (LEFT_INDENT + RIGHT_INDENT), 20);
			titleField.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			titleField.embedFonts = true;
			titleField.antiAliasType = AntiAliasType.ADVANCED;
			titleField.autoSize = TextFieldAutoSize.CENTER;
			titleField.x = dialogX + (background.width - titleField.width) / 2;
			layer.addChild(titleField);
			
			var messageField:TextField = Util.createLabel('', dialogX + LEFT_INDENT,
				titleField.y + INDENT_BETWEEN_TITLE_AND_MESSAGE, background.width - (LEFT_INDENT + RIGHT_INDENT), 60);
			messageField.embedFonts = true;
			messageField.antiAliasType = AntiAliasType.ADVANCED;
			messageField.multiline = true;
			messageField.wordWrap = true;
			messageField.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xffffff);
			messageField.text = message;
			messageField.height = 20 * messageField.numLines;
			layer.addChild(messageField);
			
			var buttonTextFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var buttonImage:Bitmap = BitmapUtil.cloneImageNamed(Images.MESSAGE_DIALOG_BUTTON);
			
			var cancelButton:Button = new Button(_scene, dialogX + (background.width - buttonImage.width) / 2,
				messageField.y + messageField.height + INDENT_BETWEEN_MESSAGE_AND_BUTTON);
			cancelButton.setBackgroundImageForState(buttonImage, CONTROL_STATE_NORMAL);
			cancelButton.setTitleForState(cancel ? cancel : '', CONTROL_STATE_NORMAL);
			cancelButton.setTextFormatForState(buttonTextFormat, CONTROL_STATE_NORMAL);
			cancelButton.textField.embedFonts = true;
			cancelButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			cancelButton.setTextPosition((buttonImage.width - cancelButton.textField.width) / 2, 11);
			cancelButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelButtonClicked);
			layer.addChild(cancelButton);
			
			background.x = dialogX;

			var dialogHeight:int = TOP_INDENT + titleField.height + INDENT_BETWEEN_TITLE_AND_MESSAGE +
				messageField.height + INDENT_BETWEEN_MESSAGE_AND_BUTTON + cancelButton.height + BOTTOM_INDENT;

			var top:Bitmap = BitmapUtil.cloneImageNamed(Images.MSG_DIALOG_TOP);
			top.x = dialogX;
			layer.addChild(top);
			
			var bottom:Bitmap = BitmapUtil.cloneImageNamed(Images.MSG_DIALOG_BOTTOM);
			bottom.x = dialogX;
			bottom.y = dialogHeight - bottom.height;
			layer.addChild(bottom);
			
			var topMask:Sprite = new Sprite();
			topMask.graphics.beginFill(0x00000);
			topMask.graphics.drawRect(dialogX, 0, dialogWidth, dialogHeight / 2);
			layer.addChild(topMask);
			top.mask = topMask;
			
			var bottomMask:Sprite = new Sprite();
			bottomMask.graphics.beginFill(0x00000);
			bottomMask.graphics.drawRect(dialogX, topMask.y + topMask.height, dialogWidth, dialogHeight / 2);
			layer.addChild(bottomMask);
			bottom.mask = bottomMask;
			
			var backgroundMask:Sprite = new Sprite();
			backgroundMask.graphics.beginFill(0x00000);
			backgroundMask.graphics.drawRect(dialogX, 0, dialogWidth, dialogHeight);
			layer.addChild(backgroundMask);
			background.mask = backgroundMask;
			
			layer.y = 78 + (545 - dialogHeight) / 2;
		}
		
		public static function show(title:String, message:String, cancel:String):void {
			var alert:Alert = new Alert(Util.scene, title, message, cancel);
			Util.scene.showModal(alert);
		}
		
		public function onCancelButtonClicked(event:GameObjectEvent):void {
			_scene.resetModal(this);
			dispatchEvent(new MessageDialogEvent(MessageDialogEvent.CANCEL_BUTTON_CLICKED));
		}
	}
}