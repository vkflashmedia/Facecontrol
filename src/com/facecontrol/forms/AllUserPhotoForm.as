package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.LinkButton;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class AllUserPhotoForm extends Form
	{
		private const THUMB_X: int = 12;
		private const THUMB_WIDTH: int = 60;
		private const THUMB_HEIGHT: int = 60;
		private const THUMB_BETWEEN_INDENT: int = 14;
		private const THUMB_VISIBLE_COUNT: int = 5;
		
		private var label: TextField;
		private var _userName: LinkButton;
		private var curBigPhoto: Photo;
		private var api: Api;
		private var multiloader: MultiLoader;
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
		private var curPhotoIndex: int;
		private var lastPhotoX: int;
		
		public var user: Object;
		public var returnForm: Form;
		
		private static var _instance: AllUserPhotoForm;
		public static function get instance():AllUserPhotoForm {
			if (!_instance) _instance = new AllUserPhotoForm(Util.scene);
			return _instance;
		}
		
		
		public function AllUserPhotoForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			visible = false;
			multiloader = new MultiLoader();
						
			api = new Api();
			api.addEventListener(ApiEvent.COMPLETED, onRequestCompleted);
			api.addEventListener(ApiEvent.ERROR, onRequestError);
			
			allPhotos = new Array();
			
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
			_userName = new LinkButton(_scene, Util.fullName(user, 20), label.x + label.width, 88);
			_userName.setTextFormatForState(new TextFormat(Util.opiumBold.fontName, 18, 0xf7ebff, null, null, true),
				CONTROL_STATE_NORMAL);
			_userName.textField.embedFonts = true;
			_userName.textField.antiAliasType = AntiAliasType.ADVANCED;
			_userName.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,
				function(event:GameObjectEvent):void {
					Util.gotoUserProfile(user.uid);
				}
			);
			addChild(_userName);
			
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
			leftBtn.setBackgroundImageForState(Util.multiLoader.get(Images.ALL_USER_PHOTO_LEFT_ACT_BTN), CONTROL_STATE_HIGHLIGHTED);
			leftBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onLeftBtnClick);
			addChild(leftBtn);
			
			var rightBtn: Button = new Button(_scene, 568, 488);
			rightBtn.setBackgroundImageForState(Util.multiLoader.get(Images.ALL_USER_PHOTO_RIGHT_BTN), CONTROL_STATE_NORMAL);
			rightBtn.setBackgroundImageForState(Util.multiLoader.get(Images.ALL_USER_PHOTO_RIGHT_ACT_BTN), CONTROL_STATE_HIGHLIGHTED);
			rightBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRightBtnClick);
			addChild(rightBtn);
			
			var format:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var cancel:Button = new Button(_scene, 251, 572);
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
				if (contains(_userName)) {
					removeChild(_userName);
				}
				
				_userName = new LinkButton(_scene, Util.fullName(user, 20), label.x + label.width, 88);
				_userName.setTextFormatForState(new TextFormat(Util.opiumBold.fontName, 18, 0xf7ebff, null, null, true),
					CONTROL_STATE_NORMAL);
				_userName.textField.embedFonts = true;
				_userName.textField.antiAliasType = AntiAliasType.ADVANCED;
				_userName.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,
					function(event:GameObjectEvent):void {
						Util.gotoUserProfile(user.uid);
					}
				);
				addChild(_userName);
				
				if (thumbsLayer && contains(thumbsLayer)) {
					removeChild(thumbsLayer);
				}
				thumbsLayer = new GameLayer(scene);
				thumbsLayer.smoothScroll = 0.7;
				thumbsLayer.x = 99;
				thumbsLayer.y = 498;
				thumbsLayer.width = 432;
				thumbsLayer.height = THUMB_HEIGHT;
				thumbsLayer.scrollRect = new Rectangle(0, 0, thumbsLayer.width, THUMB_HEIGHT);
				addChild(thumbsLayer);
				
				addedPhotosCount = 0;
				curPhotoIndex = 0;
				lastPhotoX = 0;
				
				PreloaderSplash.instance.showModal();
				allPhotos = new Array();
				api.getPhotos(user['uid']);
			}
			else {
				if (multiloader) {
					multiloader.unloadAll();
				}
				
				if (curBigPhoto && contains(curBigPhoto)) {
					removeChild(curBigPhoto);
					curBigPhoto = null;
				}
			}
		}
		
		private function createBigPhoto(photo:Object):void {
			curBigPhoto = new Photo(scene, photo['src_big'], 85, 155, 470, 315, Photo.BORDER_TYPE_ROUND_RECT);
			curBigPhoto.align = Photo.ALIGN_CENTER;
			curBigPhoto.verticalAlign = Photo.VERTICAL_ALIGN_TOP;
			curBigPhoto.horizontalAlign = Photo.HORIZONTAL_ALIGN_CENTER;
			curBigPhoto.photoBorderColor = 0x3a2426;
			addChild(curBigPhoto);
		}
		
		private function toLeftPhoto(): void {
			if (curPhotoIndex > 0) {
				curPhotoIndex--;
				if (curBigPhoto && contains(curBigPhoto)) {
					removeChild(curBigPhoto);
				}
				var cp: Object = null;
				for each (var p: Object in allPhotos) {
					if (p['index'] == curPhotoIndex) {
						cp = p;
					}
				}
				createBigPhoto(cp);
				thumbsLayer.scroll(-THUMB_WIDTH - THUMB_BETWEEN_INDENT, 0);
			}
		}
		
		private function toRightPhoto(): void {
			if (curPhotoIndex < (addedPhotosCount - 1)) {
				curPhotoIndex++;
				if (curBigPhoto && contains(curBigPhoto)) {
					removeChild(curBigPhoto);
				}
				var cp: Object = null;
				for each (var p: Object in allPhotos) {
					if (p['index'] == curPhotoIndex) {
						cp = p;
					}
				}
				createBigPhoto(cp);
				thumbsLayer.scroll(THUMB_WIDTH + THUMB_BETWEEN_INDENT, 0);
			}
		}
		
		private function addPhoto(photo: Object): void {
			if (photo.hasOwnProperty('src_big')) {
				photo['index'] = addedPhotosCount;
				var thumb: Photo = new Photo(scene, photo['src_big'], 0, 0, THUMB_WIDTH, THUMB_HEIGHT, Photo.BORDER_TYPE_RECT);
				thumb.photoBorder = 1;
				thumb.photoBorderColor = 0x563645;
				thumb.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
				thumb.verticalScale = Photo.VERTICAL_SCALE_ALWAYS;
				if (addedPhotosCount == 0) {
					createBigPhoto(photo);
					thumb.x = 189;//(thumbsLayer.width - THUMB_WIDTH) / 2;
					lastPhotoX = thumb.x + THUMB_BETWEEN_INDENT + THUMB_WIDTH;
//					PreloaderSplash.instance.resetModal();
				}
				else {
					thumb.x = lastPhotoX;
					thumbsLayer.width += THUMB_BETWEEN_INDENT + THUMB_WIDTH;
					lastPhotoX += THUMB_BETWEEN_INDENT + THUMB_WIDTH;
				}
				thumb.buttonMode = true;
				thumb.useHandCursor = true;
				thumb.setSelect(true);
				thumb.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onThumbClick);
				thumb.index = addedPhotosCount;
				thumbsLayer.addChild(thumb);
				addedPhotosCount++;
			}
		}
		
		public function onThumbClick(event: GameObjectEvent): void {
			curPhotoIndex = event.target.index;
			if (curBigPhoto && contains(curBigPhoto)) {
				removeChild(curBigPhoto);
			}
			var cp: Object = null;
			for each (var p: Object in allPhotos) {
				if (p['index'] == curPhotoIndex) {
					cp = p;
				}
			}
			createBigPhoto(cp);
			thumbsLayer.scroll(event.target.x - 189 - thumbsLayer.scrollRect.x, 0);
		}
		
		private function onLeftBtnClick(event: GameObjectEvent): void {
			toLeftPhoto();
		}
		
		private function onRightBtnClick(event: GameObjectEvent): void {
			toRightPhoto();
		}
		
		private function onCancelClick(event: GameObjectEvent): void {
			if (returnForm) {
				returnForm.show();
			}
		}
		
		private function onRequestCompleted(event: ApiEvent): void {
			switch (event.response.method) {
				case 'get_photos':
					for each (var photo: Object in event.response.photos) {
						allPhotos.push({'src_big_path': photo['src_big']});
						multiloader.load(photo['src_big'], photo['src_big'], 'Bitmap');
					}
					multiloader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
				break;
			}
		}
		
		private function onRequestError(event: ApiEvent): void {
			trace('onRequestError: ' + event.errorCode + " (" + event.errorMessage+")");
		}
		
		public function multiLoaderCompliteListener(event: MultiLoaderEvent):void {
			if (multiloader.isLoaded) {
				multiloader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
				PreloaderSplash.instance.resetModal();
			}
			for (var i: int = 0; i < allPhotos.length; i++) {
				if (allPhotos[i]['src_big_path'] == event.entry) {
					allPhotos[i]['src_big'] = multiloader.get(allPhotos[i]['src_big_path']);
					addPhoto(allPhotos[i]);
					break;
				}
			}
		}
		
		public function multiLoaderFaultListener(event: MultiLoaderEvent):void {
			trace('multiLoaderFaultListener :: ' + event.entry);
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is AllUserPhotoForm);
					} 
				}
			}
		}
	}
}