package com.facecontrol.forms
{
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
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

	public class PhotoAlbumForm extends GameLayer
	{
		private static var _instance: PhotoAlbumForm = null;
		public static function get instance(): PhotoAlbumForm {
			if (!_instance) _instance = new PhotoAlbumForm(Util.scene);
			return _instance;
		}
		
		private var _api: Api;
		private var waitText: TextField;
		private var _vkPhotoAlbum: VKPhotoAlbum;
		private var _currentAlbumPage: int = 0;
		private var _currentPhotoPage: int = 0;
		private var _pagination: Pagination;
		
		public function PhotoAlbumForm(value:GameScene)
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
			_pagination.debug = true;
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
			});
			_vkPhotoAlbum.addEventListener(VKPhotoAlbumEvent.PHOTOS_LOADED, function onPhotosLoad(event: VKPhotoAlbumEvent): void {
				//removeChild(waitText);
				_pagination.pagesCount = _vkPhotoAlbum.selectedAlbumPhotosPages;
				_pagination.x = 518 - _pagination.width;
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
			_vkPhotoAlbum.showAlbums(0);
			_pagination.currentPage = 0;
			var newPhotos: Array = _vkPhotoAlbum.getPhotosToAdd();
			for each (var p: Object in newPhotos) {
				var src: String = (p.hasOwnProperty('src')) ? p['src'] : null;
				var src_small: String = (p.hasOwnProperty('src_small')) ? p['src_small'] : null;
				var src_big: String = (p.hasOwnProperty('src_big')) ? p['src_big'] : null;
				_api.addPhoto(Util.userId, src, src_small, src_big, null);
			}
			var delPhotos: Array = _vkPhotoAlbum.getPhotosToDelete();
			var photos: Array = MyPhotoForm.instance.photos;
			for each (p in delPhotos) {
				src = (p.hasOwnProperty('src')) ? p['src'] : null;
				src_small = (p.hasOwnProperty('src_small')) ? p['src_small'] : null;
				src_big = (p.hasOwnProperty('src_big')) ? p['src_big'] : null;
				for each (var photo: Object in photos) {
					if (photo['src_big'] == src_big) {
						_api.deletePhoto(photo['pid']);
						break;
					}
				}
			}
			_vkPhotoAlbum.clearMarks();
			Util.api.getPhotos(Util.userId);
			_scene.resetModal(this);
		}
		
		private function onCancelClick(event: GameObjectEvent): void {
			_vkPhotoAlbum.showAlbums(0);
			_pagination.currentPage = 0;
			_vkPhotoAlbum.clearMarks();
			_scene.resetModal(this);
		}
		
		private function onPaginationChange(event: Event): void {
			if (_vkPhotoAlbum.state == VKPhotoAlbum.STATE_IN_ALBUMS) {
				_vkPhotoAlbum.showAlbums(_pagination.currentPage);
			}
			else {
				_vkPhotoAlbum.showPhotos(_vkPhotoAlbum.currentAlbum['aid'] as String, _pagination.currentPage);	
			}
		}
		
		private function onApiCompleted(event:ApiEvent):void {
			var response:Object = event.response;
			try {
				switch (response.method) {
					case 'add_photo':
						Util.api.getPhotos(Util.userId);
					break;
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
	}
}