package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	
	public class PhotoPreview extends GameObject
	{
		private const PHOTO_RIGHT_INDENT: uint = 5;
		private const TEXT_TOP_INDENT: uint = 5;
		
		private var _photo: Bitmap;
		private var _rating: String;
		private var _rateIcon: Bitmap;
		private var _votesCount: uint;
		private var _text: String;
		/**
		 * Стикеры для размещения на фото
		 * - icon: Bitmap - иконка стикера
		 * - name: имя стикера, для обращения к нему и проверок
		 * - dX смещение отностельно фото
		 * - dY смещение отностельно фото
		 */
		private var _stickers: Array;
		
		public function PhotoPreview(scene: GameScene)
		{
			super(scene);
			_stickers = new Array();
		}

		public function set photo(value: Bitmap): void {
			_photo = value;
			update();
		}
		
		public function set rating(value: String): void {
			_rating = value;
			update();
		}
		
		public function set rateIcon(value: Bitmap): void {
			_rateIcon = value;
			update();
		}
		
		public function set votesCount(value: uint): void {
			_votesCount = value;
			update();
		}
		
		public function setSticker(name: String, icon: Bitmap, dX: int = 0, dY: int = 0): void {
			var sticker: Object = new Object();
			sticker['name'] = name;
			sticker['icon'] = icon;
			sticker['dX'] = dX;
			sticker['dY'] = dY;
			_stickers.push(sticker);
			update();
		}
		
		public function hasSticker(name: String): Boolean {
			for each (var sticker: Object in _stickers) {
				if (sticker.hasOwnProperty('name') && (sticker['name'] as String) == name) {
					return true;
				}
			}
		}
		
		public function removeSticker(name: String): void {
			for (var i: uint = 0; i < _stickers.length; i++) {
				if (sticker.hasOwnProperty('name') && (sticker['name'] as String) == name) {
					_stickers.splice(i, 1);
					i--;
				}
			}
		}
		
		private function update(): void {
			var xx: int = 0;
			var yy: int = 0;
			if (_photo) {
				_photo.x = xx;
				_photo.y = yy;
				if (!contains(_photo)) {
					addChild(_photo);
				}
				xx += _photo.width + PHOTO_RIGHT_INDENT;
			}
			else {
				if (contains(_photo)) {
					removeChild(_photo);
				}
			}
			yy += TEXT_TOP_INDENT;
			if (_rateIcon) {
				_rateIcon.x = xx;
				_rateIcon.y = yy;
				if (!contains(_rateIcon)) {
					addChild(_rateIcon);
				}
				xx += _rateIcon.width;
			}
			else {
				if (contains(_rateIcon)) {
					removeChild(_rateIcon);
				}
			}
			
		}
	}
}