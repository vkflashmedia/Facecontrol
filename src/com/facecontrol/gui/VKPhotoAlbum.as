package com.facecontrol.gui
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.util.BitmapUtil;
	import com.net.VKontakte;
	import com.net.VKontakteEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class VKPhotoAlbum extends GridBox
	{
		public static const STATE_LOADING: int = 1;
		public static const STATE_IN_ALBUMS: int = 2;
		public static const STATE_IN_PHOTOS: int = 3;
		
		private var _vk: VKontakte;
		/**
		 * 	[aid]
		 *  [title]
		 *  [size]
		 * 		['photos']
		 * 			['pid']
		 * 			['src']
		 * 			['src_image'] Bitmap
		 * 			['marked'] Boolean - фото отмечено галочкой
		 */
		private var _albums: Array;
		private var _currentAlbumId: String;
		private var _curPhotoPageIndex: int;
		private var _state: int;
		private var _multiLoader: MultiLoader;
		private var _markIcon: Bitmap;
		private var _markedPathes: Array;
		
		public function VKPhotoAlbum(value: GameScene, maxColumnsCount: uint = COLUMNS_DEF_COUNT, maxRowsCount: uint = ROWS_DEF_COUNT)
		{
			super(value, maxColumnsCount, maxRowsCount);
			padding = 10;
			indentBetweenCols = 0;
			indentBetweenRows = 0;
			_state = STATE_LOADING;
			_curPhotoPageIndex = 0;
			_multiLoader = new MultiLoader();
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onLoad);
			_vk = new VKontakte();
			_vk.addEventListener(VKontakteEvent.COMPLETED, onVKRequestSuccess);
			_vk.addEventListener(VKontakteEvent.ERROR, onVKRequestError);
			_vk.getAlbums();
		}
		
		public function clearMarks(): void {
			for each (var a: Object in _albums) {
				for each (var p: Object in _albums['photos']) {
					if (p.hasOwnProperty('marked')) {
						p['marked'] = false;
					}
				}
			}
		}
		
		public function set markedPathes(value: Array): void {
			_markedPathes = value;
		}
		
		private function inMarkedPathes(value: String): Boolean {
			for each (var path: String in _markedPathes) {
				if (value == path) {
					return true;
				}
			}
			return false;
		}
		
		public function getPhotosToAdd(): Array {
			var result: Array = new Array();
			for each (var a: Object in _albums) {
				for each (var p: Object in a['photos']) {
					if (p.hasOwnProperty('marked') && p['marked'] == true) {
						if (!inMarkedPathes(p['src_big'])) {		
							result.push(p);
						}
					}
				}
			}
			return result;
		}
		
		public function getPhotosToDelete(): Array {
			var result: Array = new Array();
			for each (var a: Object in _albums) {
				for each (var p: Object in a['photos']) {
					if (inMarkedPathes(p['src_big'])) {
						if (!p.hasOwnProperty('marked') || p['marked'] == false) {
							result.push(p);
						}
					}
				}
			}
			return result;
		}
		
		public function set markIcon(value: Bitmap): void {
			_markIcon = value;
		}
		
		public function get state(): int {
			return _state;
		}
		
		public function get currentAlbum(): Object {
			for each (var a: Object in _albums) {
				if (a['aid'] == _currentAlbumId) {
					return a;
				}
			}
			return null;
		}
		
		public function getPhoto(pid: String): Object {
			for each (var p: Object in currentAlbum['photos']) {
				if (p['pid'] == pid) {
					return p;
				}
			}
			return null;
		}
		
		public function get albumsPages(): int {
			if (_albums) {
				var fp: int = _albums.length / (_maxColumnsCount * _maxRowsCount);
				return (_albums.length > (fp * _maxColumnsCount * _maxRowsCount)) ? fp + 1: fp;
			}
			return 0;
		}
		
		public function get selectedAlbumPhotosPages(): int {
			if (currentAlbum) {
				var fp: int = currentAlbum['size'] / (_maxColumnsCount * _maxRowsCount);
				return (currentAlbum['size'] > (fp * _maxColumnsCount * _maxRowsCount)) ? fp + 1: fp;
			}
			return 0;
		}
		
		public function showAlbums(pageIndex: int = 0): void {
			if (pageIndex < albumsPages) {
				var maxAlbumsOnPage: int = _maxColumnsCount * _maxRowsCount;
				var curAlbum: int = 0;
				_state = STATE_IN_ALBUMS;
				removeAllItems();
				for each (var a: Object in _albums) {
					//var b: Bitmap = getPhoto(a['thumb_id']);
					if (/*b && */(curAlbum >= (pageIndex * maxAlbumsOnPage)) && (curAlbum < ((pageIndex + 1) * maxAlbumsOnPage))) {
						//addItem(b);
//						var p: Photo = new Photo(scene, b, 0, 0, 60, 60, Photo.BORDER_TYPE_RECT);
//						p.photoBorderColor = 0x453841;
//						p.setFocus(true, true, BitmapUtil.cloneBitmap(Util.multiLoader.get(Images.PHOTO_ALBUM_SELECT)), View.ALIGN_HOR_CENTER | View.ALIGN_VER_CENTER);
//						addItem(p);
						var albGo: GameObject = new GameObject(scene);
						albGo.setSelect(true);
						albGo.useHandCursor = true;
						albGo.bitmap = BitmapUtil.cloneBitmap(Util.multiLoader.get(Images.PHOTO_ALBUM_FOLDER));
						albGo.height = Util.multiLoader.get(Images.PHOTO_ALBUM_FOLDER).height + 14;
						albGo.setFocus(true, true, BitmapUtil.cloneBitmap(Util.multiLoader.get(Images.PHOTO_ALBUM_SELECT)), View.ALIGN_HOR_CENTER | View.ALIGN_VER_CENTER);
						var tf: TextField = new TextField();
						var format: TextFormat = new TextFormat(Util.tahoma.fontName, 10, 0xffffff);
						tf.embedFonts = true;
						tf.text = (a['title'] as String).substr(0, 10) + '...';
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.setTextFormat(format);
						albGo.setTextField(tf, View.ALIGN_HOR_CENTER | View.ALIGN_VER_BOTTOM);
						addItem(a['aid'], albGo);
						//changeItem(a['aid'], b);
					}
					curAlbum++;
				}
				var event: VKPhotoAlbumEvent = new VKPhotoAlbumEvent(VKPhotoAlbumEvent.ALBUMS_LOADED);
				dispatchEvent(event);
			}
		}
		
		public function showPhotos(aid: String, pageIndex: int = 0): void {
			if (aid && pageIndex < selectedAlbumPhotosPages) {
				_curPhotoPageIndex = pageIndex;
				var maxPhotosOnPage: int = _maxColumnsCount * _maxRowsCount;
				_state = STATE_IN_PHOTOS;
				removeAllItems();
				if (!currentAlbum.hasOwnProperty('photos')) {
					_vk.getPhotos(aid);
				}
				else {
					var curPhoto: int = 0;
					if (isAllPhotoOnPageLoaded(_curPhotoPageIndex)) {
						for each (var p: Object in currentAlbum['photos']) {
							if ((curPhoto >= (pageIndex * maxPhotosOnPage)) && (curPhoto < ((pageIndex + 1) * maxPhotosOnPage))) {
								var pGo: Photo = new Photo(scene, p['src_image'], 0, 0, 60, 60, Photo.BORDER_TYPE_RECT);
								pGo.photoBorderColor = 0x453841;
								if (inMarkedPathes(p['src_big'])) {
									p['marked'] = true;
								}
								if (p.hasOwnProperty('marked') && p['marked'] == true) {
									var icon: Bitmap = BitmapUtil.cloneBitmap(_markIcon);
									icon.x = -6;
									icon.y = 43;
									pGo.view.addDisplayObject(icon, 'mark', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER);
								}
								addItem(p['pid'], pGo);
							}
							curPhoto++;
						}
						var event: VKPhotoAlbumEvent = new VKPhotoAlbumEvent(VKPhotoAlbumEvent.PHOTOS_LOADED);
						dispatchEvent(event);
					}
					else {
						for each (p in currentAlbum['photos']) {
							if ((curPhoto >= (pageIndex * maxPhotosOnPage)) && (curPhoto < ((pageIndex + 1) * maxPhotosOnPage))) {
								if (!p.hasOwnProperty('src_image')) {
									_multiLoader.load(p['src'],  p['pid'], 'Bitmap');
								}
							}
							curPhoto++;
						}
					}
				}
			}
		}
		
		private function isAllPhotoOnPageLoaded(pageIndex: int = 0): Boolean {
			var curPhoto: int = 0;
			var maxPhotosOnPage: int = _maxColumnsCount * _maxRowsCount;
			var alb: Object = currentAlbum;
			for each (var p: Object in alb['photos']) {
				if ((curPhoto >= (pageIndex * maxPhotosOnPage)) && (curPhoto < ((pageIndex + 1) * maxPhotosOnPage))) {
					if (!p.hasOwnProperty('src_image')) {
						return false;
					}
				}
				curPhoto++;
			}
			return true;
		}
		
		private function get thumbImage(): GameObject {
			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRect(0,0,50,50);
			spr.graphics.endFill();
			spr.graphics.lineStyle(2, 0x00aa00);
			spr.graphics.drawRect(5,5,40,40);
			var bd: BitmapData = new BitmapData(50, 50);
			bd.draw(spr);
			var b: Bitmap = new Bitmap(bd);
			var go: GameObject = new GameObject(_scene);
			go.autoSize = true;
			go.bitmap = b;
			return go;
		}
		
		protected override function selectItem(value: GameObject): void {
			super.selectItem(value);
			if (_state == STATE_IN_ALBUMS) {
				_currentAlbumId = selectedItem;
			}
			else if (_state == STATE_IN_PHOTOS) {
				var p: Object = getPhoto(selectedItem);
				if (p.hasOwnProperty('marked')) {
					p['marked'] = !(p['marked'] as Boolean);
				}
				else {
					p['marked'] = true;
				}
				if (p['marked'] == true) {
					var pGo: Photo = new Photo(scene, p['src_image'], 0, 0, 60, 60, Photo.BORDER_TYPE_RECT);
					var icon: Bitmap = BitmapUtil.cloneBitmap(_markIcon);
					icon.x = -6;
					icon.y = 43;
					pGo.view.addDisplayObject(icon, 'mark', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER);
					changeItem(selectedItem, selectedItem, pGo);
				}
				else {
					pGo = new Photo(scene, p['src_image'], 0, 0, 60, 60, Photo.BORDER_TYPE_RECT);
					changeItem(selectedItem, selectedItem, pGo);
				}
			}
		}
		
		protected override function itemMouseDoubleClickListener(event: GameObjectEvent): void {
			super.itemMouseDoubleClickListener(event);
			showPhotos(_currentAlbumId);
		}
		
		private function onVKRequestSuccess(event: VKontakteEvent): void {
			if (event.method == 'photos.getAlbums') {
				_albums = new Array();
				for each (var a: Object in event.response) {
					_albums.push(a);
				}
				showAlbums();
			}
			if (event.method == 'photos.get') {
				currentAlbum['photos'] = event.response;
				showPhotos(_currentAlbumId, _curPhotoPageIndex);
			}
		}
		
		private function onVKRequestError(event: VKontakteEvent): void {
			trace('onVKRequestError: ' + event.errorMessage);
		}
		
		private function onLoad(event: MultiLoaderEvent): void {
			var alb: Object = currentAlbum;
			for (var i: int = 0; i < (alb['photos'] as Array).length; i++) {
				if (alb['photos'][i]['pid'] == event.entry) {
					alb['photos'][i]['src_image'] = _multiLoader.get(event.entry);
					break;
				}
			}
			var curPhoto: int = 0;
			var maxPhotosOnPage: int = _maxColumnsCount * _maxRowsCount;
			if (isAllPhotoOnPageLoaded(_curPhotoPageIndex)) {
				for each (var p: Object in alb['photos']) {
					if ((curPhoto >= (_curPhotoPageIndex * maxPhotosOnPage)) && (curPhoto < ((_curPhotoPageIndex + 1) * maxPhotosOnPage))) {
						var pGo: Photo = new Photo(scene, p['src_image'], 0, 0, 60, 60, Photo.BORDER_TYPE_RECT);
						pGo.photoBorderColor = 0x453841;
						if (inMarkedPathes(p['src_big'])) {
							p['marked'] = true;
						}
						if (p.hasOwnProperty('marked') && p['marked'] == true) {
							var icon: Bitmap = BitmapUtil.cloneBitmap(_markIcon);
							icon.x = -6;
							icon.y = 43;
							pGo.view.addDisplayObject(icon, 'mark', GameObject.VISUAL_DISPLAY_OBJECT_Z_ORDER);
						}
						addItem(p['pid'], pGo);
					}
					curPhoto++;
				}
				var pevent: VKPhotoAlbumEvent = new VKPhotoAlbumEvent(VKPhotoAlbumEvent.PHOTOS_LOADED);
				dispatchEvent(pevent);
			}
		}
	}
}