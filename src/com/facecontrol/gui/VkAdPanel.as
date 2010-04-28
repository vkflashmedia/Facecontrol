package com.facecontrol.gui
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.net.VKontakte;
	import com.net.VKontakteEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	public class VkAdPanel extends GameLayer
	{
		private var _vk: VKontakte;
		/**
		 * ['title']
		 * ['description']
		 * ['photo']
		 * ['link']
		 * ['showCount']
		 */
		private var _ads: Array;
		private var _currentAdIndex: int;
		private var _timer: Timer;
		private var _title: TextField;
		private var _photo: Bitmap;
		private var _description: TextField;
		private var _multiLoader: MultiLoader;
		
		public function VkAdPanel(value: GameScene, x: int = 0, y: int = 0, width: int = 100, height: int = 50)
		{
			super(value);
			setSelect(true);
			useHandCursor = true;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			_multiLoader = new MultiLoader();
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onLoad);
			_ads = new Array();
			_vk = new VKontakte();
			_vk.addEventListener(VKontakteEvent.COMPLETED, onVKRequestSuccess);
			_vk.addEventListener(VKontakteEvent.ERROR, onVKRequestError);
			_vk.getAds();
			_currentAdIndex = 0;
			_timer = new Timer(5000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onTimer(event: TimerEvent): void {
			_currentAdIndex++;
			if (_currentAdIndex >= _ads.length) {
				_currentAdIndex = 0;
			}
			if (!_title) {
				_title = new TextField();
				_title.autoSize = TextFieldAutoSize.LEFT;
				addChild(_title);
			}
			if (!_description) {
				_description = new TextField();
				_description.autoSize = TextFieldAutoSize.LEFT;
				addChild(_description);
			}
//			if (!_photo) {
//				_photo = new Bitmap();
//				addChild(_photo);
//			}
			if (_ads[_currentAdIndex] && _ads[_currentAdIndex].hasOwnProperty('title')) {
				if (_photo && contains(_photo)) {
					removeChild(_photo);
				}
				if (_ads[_currentAdIndex].hasOwnProperty('src_image')) {
					_photo = _ads[_currentAdIndex]['src_image'];
				}
				else{
					_photo = new Bitmap(new BitmapData(40, 40, false, 0xaaaaaa));
				}
				addChild(_photo);
				_photo.x = 10;
				_photo.y = 10;
				_title.text = _ads[_currentAdIndex]['title'];
				_title.x = _photo.x + _photo.width + 10;
				_title.y = 10;
				_description.text = _ads[_currentAdIndex]['description'];
				_description.x = _photo.x + _photo.width + 10;;
				_description.y = 40;
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			if (_ads[_currentAdIndex] && _ads[_currentAdIndex].hasOwnProperty('link')) {
				var req: URLRequest = new URLRequest(_ads[_currentAdIndex]['link']);
				flash.net.navigateToURL(req);
			}
		}
		
		private function adExist(title: String): Boolean {
			for each (var ad: Object in _ads) {
				if ((ad.title as String) == title) {
					return true;
				}
			}
			return false;
		}
		
		private function onVKRequestSuccess(event: VKontakteEvent): void {
			if (event.method == 'getAds') {
				trace(event.response);
				for each (var ad: Object in event.response) {
					if (!adExist(ad.title)) {
						_ads.push({'title': ad.title, 'description': ad.description, 'photo': ad.photo, 'link': ad.link, 'showCount': 0});
						_multiLoader.load(ad.photo, ad.photo, 'Bitmap');
					}
				}
//				_ads.push({'title': 'shop title', 'description': 'two desct', 'photo': 'dsgdfg', 'link': '45', 'showCount': 0});
			}
		}
		
		private function onVKRequestError(event: VKontakteEvent): void {
			trace('onVKRequestError: ' + event.errorMessage);
		}
		
		private function onLoad(event: MultiLoaderEvent): void {
			for (var i: int = 0; i < _ads.length; i++) {
				if (event.entry == _ads[i]['photo']) {
					_ads[i]['src_image'] = _multiLoader.get(_ads[i]['photo']);
					break;
				}
			}
		}
	}
}