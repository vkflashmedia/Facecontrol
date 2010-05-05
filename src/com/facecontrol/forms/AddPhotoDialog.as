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

	public class AddPhotoDialog extends GameLayer
	{
		public function AddPhotoDialog(value:GameScene)
		{
			super(value);
			
			this.graphics.beginFill(0x00, 0.5);
			this.graphics.drawRect(0, 0, _scene.width, _scene.height);
			
			bitmap = Util.multiLoader.get(Images.ADD_PHOTO_BCK);
			bitmap.x = 216;
			bitmap.y = 213;
			
			var label:TextField = Util.createLabel('Добавить фото', 248, 227);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var format:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var loadPhoto:Button = new Button(_scene, 253, 276);
			loadPhoto.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_RED), CONTROL_STATE_NORMAL);
			loadPhoto.setTitleForState('загрузить фото', CONTROL_STATE_NORMAL);
			loadPhoto.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			loadPhoto.textField.embedFonts = true;
			loadPhoto.textField.antiAliasType = AntiAliasType.ADVANCED;
			loadPhoto.setTextPosition(29, 11);
			addChild(loadPhoto);
			
			var selectFromAlbom:Button = new Button(_scene, loadPhoto.x, loadPhoto.y + 48);
			selectFromAlbom.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			selectFromAlbom.setTitleForState('выбрать из альбомов', CONTROL_STATE_NORMAL);
			selectFromAlbom.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			selectFromAlbom.textField.embedFonts = true;
			selectFromAlbom.textField.antiAliasType = AntiAliasType.ADVANCED;
			selectFromAlbom.setTextPosition(16, 11);
			selectFromAlbom.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onAlbumClick);
			addChild(selectFromAlbom);
			
			var cancel:Button = new Button(_scene, loadPhoto.x, selectFromAlbom.y + 48);
			cancel.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_GREY), CONTROL_STATE_NORMAL);
			cancel.setTitleForState('отмена', CONTROL_STATE_NORMAL);
			cancel.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			cancel.textField.embedFonts = true;
			cancel.textField.antiAliasType = AntiAliasType.ADVANCED;
			cancel.setTextPosition(49, 11);
			cancel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelClick);
			addChild(cancel);
		}
		
		public function onAlbumClick(event:GameObjectEvent):void {
			_scene.resetModal(this);
			PhotoAlbumForm.instance.setAddedPhotos(MyPhotoForm.instance.photos);
			_scene.showModal(PhotoAlbumForm.instance);
		}
		
		public function onCancelClick(event:GameObjectEvent):void {
			_scene.resetModal(this);
		}
	}
}