package com.facecontrol.gui
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.GridBox;
	import com.net.VKontakte;
	import com.net.VKontakteEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class VKPhotoAlbum extends GridBox
	{
		public static const STATE_LOADING: int = 1;
		public static const STATE_IN_ALBUMS: int = 2;
		public static const STATE_IN_PHOTOS: int = 3;
		
		private var _vk: VKontakte;
		private var _albums: Array;
		private var _photos: Array;
		private var _currentAlbum: Object;
		private var _state: int;
		private var _multiLoader: MultiLoader;
		
		public function VKPhotoAlbum(value: GameScene, maxColumnsCount: uint = COLUMNS_DEF_COUNT, maxRowsCount: uint = ROWS_DEF_COUNT)
		{
			super(value, maxColumnsCount, maxRowsCount);
			padding = 10;
			indentBetweenCols = 0;
			indentBetweenRows = 0;
			_state = STATE_LOADING;
			_currentAlbum = null;
			_multiLoader = new MultiLoader();
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onLoad);
			_vk = new VKontakte();
			_vk.addEventListener(VKontakteEvent.COMPLETED, onVKRequestSuccess);
			_vk.addEventListener(VKontakteEvent.ERROR, onVKRequestError);
			getUserPhotos();
		}
		
		public function get state(): int {
			return _state;
		}
		
		public function get selectedAlbumId(): String {
			if (_currentAlbum) {
				return _currentAlbum['aid'];
			}
			return null;
		}
		
		public function get albumsPages(): int {
			if (_albums) {
				return _albums.length / (_maxColumnsCount * _maxRowsCount) + 1;
			}
			return 0;
		}
		
		public function get selectedAlbumPhotosPages(): int {
			if (_currentAlbum) {
				var fp: int = _currentAlbum['size'] / (_maxColumnsCount * _maxRowsCount);
				return (_currentAlbum['size'] > (fp * _maxColumnsCount * _maxRowsCount)) ? fp + 1: fp;
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
					var b: Bitmap = getPhoto(a['thumb_id']);
					if (b && (curAlbum >= (pageIndex * maxAlbumsOnPage)) && (curAlbum < ((pageIndex + 1) * maxAlbumsOnPage))) {
						addItem(b);
						//changeItem(a['aid'], b);
					}
					curAlbum++;
				}
			}
		}
		
		public function showPhotos(aid: String, pageIndex: int = 0): void {
			if (aid && pageIndex < selectedAlbumPhotosPages) {
				var maxPhotosOnPage: int = _maxColumnsCount * _maxRowsCount;
				var curPhoto: int = 0;
				_state = STATE_IN_PHOTOS;
				removeAllItems();
				for (var ai: int = 0; ai < _photos.length; ai++) {
					for (var pi: int = 0; pi < (_photos[ai] as Array).length; pi++) {
						if (
							(_photos[ai] as Array)[pi].hasOwnProperty('src_image') &&
							(_photos[ai] as Array)[pi]['aid'] == aid
						) {
							if ((curPhoto >= (pageIndex * maxPhotosOnPage)) && (curPhoto < ((pageIndex + 1) * maxPhotosOnPage))) {
								addItem((_photos[ai] as Array)[pi]['src_image']);
							}
							curPhoto++;
						}
					}
				}
			}
		}
		
		private function getUserPhotos(): void {
			_vk.getAlbums();
		}
		
		private function getPhoto(pid: String, size: String = 'src'): Bitmap {
			for (var ai: int = 0; ai < _photos.length; ai++) {
				for (var pi: int = 0; pi < (_photos[ai] as Array).length; pi++) {
					var p: Object = (_photos[ai] as Array)[pi];
					if (p['pid'] == pid) {
						switch (size) {
							case 'src_small':
								//todo load
							break;
							case 'src_big':
								//todo load
							break;
							case 'src':
							default:
								if (p.hasOwnProperty('src_image')) {
									return p['src_image'];
								}
							break;
						}
					}
				}
			}
			return null;
		}
		
		private function isAllPhotosLoaded(): Boolean {
			if (_albums.length != _photos.length) {
				return false;
			}
			for (var ai: int = 0; ai < _photos.length; ai++) {
				for (var pi: int = 0; pi < (_photos[ai] as Array).length; pi++) {
					if (!(_photos[ai] as Array)[pi].hasOwnProperty('src_image')) {
						return false;
					}
				}
			}
			return true;
		}
		
		protected override function selectItem(value: GameObject): void {
			super.selectItem(value);
			var caid: String = '';
			for (var ai: int = 0; ai < _photos.length; ai++) {
				for (var pi: int = 0; pi < (_photos[ai] as Array).length; pi++) {
					if ((_photos[ai] as Array)[pi]['src_image'] == selectedItem) {
						caid = (_photos[ai] as Array)[pi]['aid']
						//_currentAlbum = (_photos[ai] as Array)[pi];
						//return;
					}
				}
			}
			for each(var a: Object in _albums) {
				if (a['aid'] == caid) {
					_currentAlbum = a;
					return;
				}
			}
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
		
		protected override function itemMouseDoubleClickListener(event: GameObjectEvent): void {
			super.itemMouseDoubleClickListener(event);
			if (_currentAlbum) {
				showPhotos(_currentAlbum['aid'], 0)
			}
		}
		
		private function onVKRequestSuccess(event: VKontakteEvent): void {
			if (event.method == 'photos.getAlbums') {
				trace(event.response);
				_albums = new Array();
				_photos = new Array();
				for each (var a: Object in event.response) {
					_albums.push(a);
					_vk.getPhotos(a.aid);
					//addItem(a.aid, thumbImage);
				}
			}
			if (event.method == 'photos.get') {
				trace(event.response);
				var album: Array = new Array();
				for each (var p: Object in event.response) {
					album.push(p);
					var path: String = p['src'] as String;
					var entryName: String = p['pid'] as String;
					_multiLoader.load(path, entryName, 'Bitmap');
				}
				_photos.push(album);
			}
		}
		
		private function onVKRequestError(event: VKontakteEvent): void {
			trace('onVKRequestError: ' + event.errorMessage);
		}
		
		private function onLoad(event: MultiLoaderEvent): void {
			for (var ai: int = 0; ai < _photos.length; ai++) {
				for (var pi: int = 0; pi < (_photos[ai] as Array).length; pi++) {
					var pid: String = (_photos[ai] as Array)[pi]['pid'];
					if (event.entry == pid) {
						(_photos[ai] as Array)[pi]['src_image'] = _multiLoader.get(pid);
						break;
					}
				}
			}
			if (isAllPhotosLoaded()) {
				showAlbums();
				var pEvent: VKPhotoAlbumEvent = new VKPhotoAlbumEvent(VKPhotoAlbumEvent.LOADED);
				dispatchEvent(pEvent);
			}
		}
	}
}