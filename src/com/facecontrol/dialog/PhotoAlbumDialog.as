package com.facecontrol.dialog
{
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.forms.MyPhotoForm;
	import com.facecontrol.forms.PreloaderSplash;
	import com.facecontrol.gui.VKPhotoAlbum;
	import com.facecontrol.gui.VKPhotoAlbumEvent;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.Pagination;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PhotoAlbumDialog extends GameLayer
	{
		private static var _instance: PhotoAlbumDialog = null;
		public static function get instance(): PhotoAlbumDialog {
			if (!_instance) _instance = new PhotoAlbumDialog(Util.scene);
			return _instance;
		}
		
		private var _api: Api;
		private var waitText: TextField;
		private var _vkPhotoAlbum: VKPhotoAlbum;
		private var _currentAlbumPage: int = 0;
		private var _currentPhotoPage: int = 0;
		private var _pagination: Pagination;
		private var newPhotos: Array;
		private var delPhotos: Array;
		
		public function PhotoAlbumDialog(value:GameScene)
		{
			super(value);
			_api = new Api();
			_api.addEventListener(ApiEvent.COMPLETED, onApiCompleted);
			
			this.graphics.beginFill(0x00, 0.5);
			this.graphics.drawRect(0, 0, _scene.width, _scene.height);
			
			bitmap = Util.multiLoader.get(Images.PHOTO_ALBUM_BACK);
			bitmap.x = 87;
			bitmap.y = 87;
			
			var label:TextField = Util.createLabel('Твои фотографии', 226, 101); // -5px
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			label = Util.createLabel('Выбери фотографии, которые смогут просматривать другие участники', 111, 129);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0x9cb190));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var albumBack: Sprite = new Sprite();
			albumBack.graphics.beginFill(0x00);
			albumBack.graphics.drawRoundRect(113, 159, 404, 362, 8, 8);
			albumBack.graphics.endFill();
			albumBack.graphics.lineStyle(1, 0x2c2c2e);
			albumBack.graphics.drawRoundRect(112, 158, 406, 364, 9, 9);
			addChild(albumBack);
			
			var format:TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
			var toAlbums:Button = new Button(_scene, 106, 544); // +2 px
			toAlbums.setBackgroundImageForState(Util.multiLoader.get(Images.PHOTO_ALBUM_ORANGE_BTN), CONTROL_STATE_NORMAL);
			toAlbums.setTitleForState('к альбомам', CONTROL_STATE_NORMAL);
			toAlbums.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			toAlbums.textField.embedFonts = true;
			toAlbums.textField.antiAliasType = AntiAliasType.ADVANCED;
			toAlbums.setTextPosition(38, 11);
			toAlbums.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onToAlbumsClick);
			addChild(toAlbums);
			
			var save:Button = new Button(_scene, 262, 544);
			save.setBackgroundImageForState(Util.multiLoader.get(Images.PHOTO_ALBUM_RED_BTN), CONTROL_STATE_NORMAL);
			save.setTitleForState('сохранить', CONTROL_STATE_NORMAL);
			save.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			save.textField.embedFonts = true;
			save.textField.antiAliasType = AntiAliasType.ADVANCED;
			save.setTextPosition(42, 11);
			save.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onSaveClick);
			addChild(save);
			
			var cancel:Button = new Button(_scene, 389, 539);
			cancel.setBackgroundImageForState(Util.multiLoader.get(Images.PHOTO_ALBUM_GRAY_BTN), CONTROL_STATE_NORMAL);
			cancel.setTitleForState('отмена', CONTROL_STATE_NORMAL);
			cancel.setTextFormatForState(format, CONTROL_STATE_NORMAL);
			cancel.textField.embedFonts = true;
			cancel.textField.antiAliasType = AntiAliasType.ADVANCED;
			cancel.setTextPosition(47, 16);
			cancel.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onCancelClick);
			addChild(cancel);
			
			_pagination = new Pagination(_scene, 430, 522, 0, 3);
//			_pagination.debug = true;
			_pagination.width = 83;
			_pagination.textFormatForDefaultButton = new TextFormat(Util.tahoma.fontName, 9, 0xbcbcbc);
			_pagination.textFormatForSelectedButton = new TextFormat(Util.tahomaBold.fontName, 9, 0x00ccff);
			_pagination.init();
			_pagination.addEventListener(Event.CHANGE, onPaginationChange);
			addChild(_pagination);
			
			_vkPhotoAlbum = new VKPhotoAlbum(scene, 4, 4);
			_vkPhotoAlbum.x = 144;
			_vkPhotoAlbum.y = 170;
			_vkPhotoAlbum.markIcon = Util.multiLoader.get(Images.V);
			_vkPhotoAlbum.indentBetweenCols = 7;
			_vkPhotoAlbum.indentBetweenRows = 7;
			_vkPhotoAlbum.addEventListener(VKPhotoAlbumEvent.ALBUMS_LOADED, function onAlbumsLoad(event: VKPhotoAlbumEvent): void {
				//removeChild(waitText);
				_pagination.pagesCount = _vkPhotoAlbum.albumsPages;
				_pagination.x = 518 - _pagination.width;
				_pagination.visible = _pagination.pagesCount > 1;
			});
			_vkPhotoAlbum.addEventListener(VKPhotoAlbumEvent.PHOTOS_LOADED, function onPhotosLoad(event: VKPhotoAlbumEvent): void {
				//removeChild(waitText);
				_pagination.pagesCount = _vkPhotoAlbum.selectedAlbumPhotosPages;
				_pagination.x = 518 - _pagination.width;
				_pagination.visible = _pagination.pagesCount > 1;
				if (PreloaderSplash.instance.isModal) {
					Util.scene.resetModal(PreloaderSplash.instance);
				}
			});
			addChild(_vkPhotoAlbum);
		}
		
		public function setAddedPhotos(photos: Array): void {
			var pathes: Array = new Array();
			for each (var p: Object in photos) {
				pathes.push(p['src_big']);
			}
			_vkPhotoAlbum.markedPathes = pathes;
		}
		
		private function onToAlbumsClick(event: GameObjectEvent): void {
			_vkPhotoAlbum.showAlbums(0);
			_pagination.currentPage = 0;
		}
		
		private function onSaveClick(event: GameObjectEvent): void {
			var wasChanges: Boolean = false;
			scene.showModal(PreloaderSplash.instance); 
			_vkPhotoAlbum.showAlbums(0);
			_pagination.currentPage = 0;
			newPhotosComplCount = 0;
			newPhotos = _vkPhotoAlbum.getPhotosToAdd();
			for each (var p: Object in newPhotos) {
				var src: String = (p.hasOwnProperty('src')) ? p['src'] : null;
				var src_small: String = (p.hasOwnProperty('src_small')) ? p['src_small'] : null;
				var src_big: String = (p.hasOwnProperty('src_big')) ? p['src_big'] : null;
				_api.addPhoto(Util.viewer_id, src, src_small, src_big, null);
				wasChanges = true
			}
			delPhotosComplCount = 0;
			delPhotos = _vkPhotoAlbum.getPhotosToDelete();
			var photos: Array = MyPhotoForm.instance.photos;
			for each (p in delPhotos) {
				src = (p.hasOwnProperty('src')) ? p['src'] : null;
				src_small = (p.hasOwnProperty('src_small')) ? p['src_small'] : null;
				src_big = (p.hasOwnProperty('src_big')) ? p['src_big'] : null;
				for each (var photo: Object in photos) {
					if (photo['src_big'] == src_big) {
						_api.deletePhoto(photo['pid']);
						wasChanges = true;
						break;
					}
				}
			}
			_vkPhotoAlbum.clearMarks();
			//Util.api.getPhotos(Util.userId);
			if (this.isModal) {
				Util.scene.resetModal(this);
			}
			if (!wasChanges && PreloaderSplash.instance.isModal) {
				scene.resetModal(PreloaderSplash.instance);
			}
		}
		
		private function onCancelClick(event: GameObjectEvent): void {
			_vkPhotoAlbum.showAlbums(0);
			_pagination.currentPage = 0;
			_vkPhotoAlbum.clearMarks();
			if (this.isModal) {
				scene.resetModal(this);
			}
		}
		
		private function onPaginationChange(event: Event): void {
			if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_ALBUMS) {
				_vkPhotoAlbum.showAlbums(_pagination.currentPage);
			}
			else {
				_vkPhotoAlbum.showPhotos(_vkPhotoAlbum.currentAlbum['aid'] as String, _pagination.currentPage);	
			}
		}
		
		private var newPhotosComplCount: int = 0;
		private var delPhotosComplCount: int = 0;
		private function onApiCompleted(event:ApiEvent):void {
			var response:Object = event.response;
			try {
				switch (response.method) {
					case 'add_photo':
						newPhotosComplCount++;
					break;
					case 'del_photo':
						delPhotosComplCount++
					break;
				}
				if (newPhotosComplCount == newPhotos.length && delPhotosComplCount == delPhotos.length) {
					Util.api.getPhotos(Util.viewer_id);
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
	}
}