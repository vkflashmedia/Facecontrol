package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class AllUserPhotoForm extends GameLayer
	{
		private const THUMB_X: int = 12;
		private const THUMB_WIDTH: int = 60;
		private const THUMB_HEIGHT: int = 60;
		private const THUMB_BETWEEN_INDENT: int = 23;
		private const THUMB_VISIBLE_COUNT: int = 5;
		
		private var label: TextField;
		private var labelName: TextField;
		private var api: Api;
		
		/**
		 * ['src_big']
		 * ['src_small']
		 * ['src']
		 * ['src_big_path']
		 * ['src_small_path']
		 * ['src_path']
		 */
		private var allPhotos: Array;
		private var thumbsLayer: GameLayer;
		private var addedPhotosCount: int;
		private var lastPhotoX: int;
		
		
		public function AllUserPhotoForm(value:GameScene)
		{
			super(value);
			api = new Api();
			api.addEventListener(ApiEvent.COMPLETED, onRequestCompleted);
			api.addEventListener(ApiEvent.ERROR, onRequestError);
			
			allPhotos = new Array();
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
			
			var smileIco: Bitmap = new Bitmap(Util.multiLoader.get(Images.MY_PHOTO_SMILE_ICO).bitmapData);
			smileIco.x = 114;
			smileIco.y = 93;
			addChild(smileIco);
			
			var labelFormat:TextFormat = new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff);
			label = Util.createLabel("Все фото пользователя ", 136, 88);
			label.setTextFormat(labelFormat);
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var labelNameFormat:TextFormat = new TextFormat(Util.opiumBold.fontName, 18, 0xf7ebff);
			labelName = Util.createLabel(MainForm.instance.fullNameCurrentUser(), label.x + label.width, 88);
			labelName.setTextFormat(labelNameFormat);
			labelName.embedFonts = true;
			labelName.antiAliasType = AntiAliasType.ADVANCED;
			labelName.autoSize = TextFieldAutoSize.LEFT;
			addChild(labelName);
			
			var labelDesc: TextField = Util.createLabel("Здесь ты можешь просмотреть все фото этого пользователя", 145, 119);
			labelDesc.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			labelDesc.embedFonts = true;
			labelDesc.antiAliasType = AntiAliasType.ADVANCED;
			labelDesc.autoSize = TextFieldAutoSize.LEFT;
			addChild(labelDesc);
			
			var background:Bitmap = Util.multiLoader.get(Images.ALL_USER_PHOTO_BACK);
			background.x = 73;
			background.y = 144;
			addChild(background);
			
			var background2:Bitmap = Util.multiLoader.get(Images.ALL_USER_PHOTO_BACK2);
			background2.x = 73;
			background2.y = 486;
			addChild(background2);
			
			var leftBtn: Button = new Button(_scene, 32, 488);
			leftBtn.setBackgroundImageForState(Util.multiLoader.get(Images.ALL_USER_PHOTO_LEFT_BTN), CONTROL_STATE_NORMAL);
			leftBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLeftBtnClick);
			addChild(leftBtn);
			
			var rightBtn: Button = new Button(_scene, 568, 488);
			rightBtn.setBackgroundImageForState(Util.multiLoader.get(Images.ALL_USER_PHOTO_RIGHT_BTN), CONTROL_STATE_NORMAL);
			rightBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRightBtnClick);
			addChild(rightBtn);
			
			var format:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var cancel:Button = new Button(_scene, 259, 572);
			cancel.setBackgroundImageForState(Util.multiLoader.get(Images.ADD_PHOTO_BUTTON_RED), CONTROL_STATE_NORMAL);
			cancel.setTitleForState('Назад', CONTROL_STATE_NORMAL);
			cancel.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			cancel.textField.embedFonts = true;
			cancel.textField.antiAliasType = AntiAliasType.ADVANCED;
			cancel.setTextPosition(49, 11);
			cancel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelClick);
			addChild(cancel);
		}
		
		public override function set visible(value: Boolean): void {
			super.visible = value;
			if (visible) {
				if (contains(labelName)) {
					removeChild(labelName);
				}
				var labelNameFormat:TextFormat = new TextFormat(Util.opiumBold.fontName, 18, 0xf7ebff);
				labelName = Util.createLabel(MainForm.instance.fullNameCurrentUser(), label.x + label.width, 88);
				labelName.setTextFormat(labelNameFormat);
				labelName.embedFonts = true;
				labelName.antiAliasType = AntiAliasType.ADVANCED;
				labelName.autoSize = TextFieldAutoSize.LEFT;
				addChild(labelName);
				
				if (thumbsLayer && contains(thumbsLayer)) {
					removeChild(thumbsLayer);
				}
				thumbsLayer = new GameLayer(scene);
				thumbsLayer.x = 96;
				thumbsLayer.y = 496;
				thumbsLayer.width = 435;
				thumbsLayer.height = THUMB_HEIGHT;
				thumbsLayer.scrollRect = new Rectangle(0, 0, thumbsLayer.width, THUMB_HEIGHT);
				addChild(thumbsLayer);
				
				//todo fix
				allPhotos = new Array();
				allPhotos.push({
						'src_path': 'http://cs9231.vkontakte.ru/u06492/100001227/m_7875d2fb.jpg',
					 	'src_small_path': 'http://cs9231.vkontakte.ru/u06492/100001227/s_c3bba2a8.jpg',
					 	'src_big_path': 'http://cs9231.vkontakte.ru/u06492/100001227/x_cd563004.jpg'});
				allPhotos.push({
						'src_path': 'http://cs9231.vkontakte.ru/u06492/100001227/m_fd092958.jpg',
						'src_small_path': 'http://cs9231.vkontakte.ru/u06492/100001227/s_603d27ab.jpg',
						'src_big_path': 'http://cs9231.vkontakte.ru/u06492/100001227/x_1f8ec9b8.jpg'});
				for each (var photo: Object in allPhotos) {
					Util.multiLoader.load(photo['src_small_path'], photo['src_small_path'], 'Bitmap');
				}
//				var currentUser: Object = (scene as Facecontrol)._mainForm.currentUser; 
//				if (currentUser && currentUser.hasOwnProperty('uid')) {
//					api.getPhotos(currentUser['uid']);
//				}
			}
		}
		
		private function addPhoto(photo: Object): void {
			if (photo.hasOwnProperty('src') && photo.hasOwnProperty('src_big') && photo.hasOwnProperty('src_small')) {
				var thumb: GameObject = new GameObject(scene);
				thumb.bitmap = photo['src_small'];
				thumb.autoSize = true;
				if (addedPhotosCount == 0) {
					thumb.x = (thumbsLayer.width - THUMB_WIDTH) / 2;
				}
				else {
					thumb.x = lastPhotoX;
				}
				lastPhotoX += thumb.x + THUMB_BETWEEN_INDENT + THUMB_WIDTH;
				thumbsLayer.addChild(thumb);
				addedPhotosCount++;
			}
		}
		
		private function onLeftBtnClick(event: GameObjectEvent): void {
			
		}
		
		private function onRightBtnClick(event: GameObjectEvent): void {
			
		}
		
		private function onCancelClick(event: GameObjectEvent): void {
			(scene as Facecontrol).onFirstMenuButtonClick(null);
		}
		
		private function onRequestCompleted(event: ApiEvent): void {
			switch (event.response.method) {
				case 'get_photos':
					event.response;
				break;
			}
		}
		
		private function onRequestError(event: ApiEvent): void {
			trace('onRequestError: ' + event.errorCode + " (" + event.errorMessage+")");
		}
		
		public function multiLoaderCompliteListener(event: MultiLoaderEvent):void {
			if (Util.multiLoader.isLoaded) {
				Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
			}
			for (var i: int = 0; i < allPhotos.length; i++) {
				if (allPhotos[i]['src_small_path'] == event.entry) {
					allPhotos[i]['src_small'] = Util.multiLoader.get(allPhotos[i]['src_small_path']);
					addPhoto(allPhotos[i]);
					break;
				}
				if (allPhotos[i]['src_big_path'] == event.entry) {
					allPhotos[i]['src_big'] = Util.multiLoader.get(allPhotos[i]['src_big_path']);
					addPhoto(allPhotos[i]);
					break;
				}
				if (allPhotos[i]['src_path'] == event.entry) {
					allPhotos[i]['src'] = Util.multiLoader.get(allPhotos[i]['src_path']);
					addPhoto(allPhotos[i]);
					break;
				}
			}
		}
	}
}