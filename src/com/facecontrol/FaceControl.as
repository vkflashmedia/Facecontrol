package com.facecontrol
{
	/**
	 * ===================================
	 * Это был мой класс, где я начинал делать приложение. 
	 * 
	 * ===================================
	 */
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.facecontrol.forms.MainForm;
	import com.facecontrol.forms.StartPreloadForm;
	import com.facecontrol.forms.UserProfileForm;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.managers.GameLayerManager;
	
	public class FaceControl
	{
		public static const APP_WIDTH: uint = 627;
		public static const APP_HEIGHT: uint = 600;
		public static const MIN_LOAD_TIME: uint = 2000;	
		
		// константы - имена форм
		public static const FORM_PRELOADER: String = 'formStartPreload';
		public static const FORM_MAIN: String = 'formMain';
		public static const FORM_USER_PROFILE: String = 'formUserProfile';
		
		private var _minLoadTimeCompleted: Boolean;
		private var _resourcesLoaded: Boolean;
		private var _scene: GameScene;
		private static var _gameLayerManager: GameLayerManager;
		private static var _multiLoader: MultiLoader;
		
		public function FaceControl(value: GameScene)
		{
			_scene = value;
			_minLoadTimeCompleted = false;
			_resourcesLoaded = false;
			_gameLayerManager = new GameLayerManager(_scene);
			_multiLoader = new MultiLoader();
			load();
		}
		
		public static function get gameLayerManager(): GameLayerManager {
			return FaceControl._gameLayerManager;
		}
		
		public static function get multiLoader(): MultiLoader {
			return FaceControl._multiLoader;
		}
		
		public function loadForms(): void {
			var mainForm: MainForm = new MainForm(_scene);
			mainForm.name = FORM_MAIN;
			_gameLayerManager.addGameLayer(mainForm);
			var userProfileForm: UserProfileForm = new UserProfileForm(_scene);
			userProfileForm.name = FORM_USER_PROFILE;
			_gameLayerManager.addGameLayer(userProfileForm);
			if (_minLoadTimeCompleted) {
				_gameLayerManager.showLayer(FORM_MAIN);
			}
		}
		
		public function loadResources(): void {
			multiLoader.load("http://cs1256.vkontakte.ru/u7776141/17008570/x_b07e69c3.jpg", "Photo1", "Bitmap");
			multiLoader.load("http://cs4229.vkontakte.ru/u7776141/16220641/x_a962a7d3.jpg", "Photo2", "Bitmap");
			multiLoader.load("http://cs221.vkontakte.ru/u7776141/105280453/x_ecfb2a23.jpg", "Photo3", "Bitmap");
			multiLoader.load("http://cs152.vkontakte.ru/u12069732/23428030/x_c0b642f9.jpg", "Photo4", "Bitmap");
			multiLoader.load("http://cs4115.vkontakte.ru/u4817417/96668635/x_143da210.jpg", "Photo5", "Bitmap");
			multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
			multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
		}

		public function load(): void {
			var preloadForm: StartPreloadForm = new StartPreloadForm(_scene);
			preloadForm.name = FORM_PRELOADER;
			_gameLayerManager.addGameLayer(preloadForm);
			_gameLayerManager.showLayer(FORM_PRELOADER);
			
			var minLoadTimer: Timer = new Timer(MIN_LOAD_TIME, 1);
			minLoadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function onMinLoadTimerComplete(event: TimerEvent): void {
				event.target.removeEventListener(TimerEvent.TIMER_COMPLETE, onMinLoadTimerComplete);
				_minLoadTimeCompleted = true;
				if (_resourcesLoaded) {
					_gameLayerManager.showLayer(FORM_MAIN);
				}
			});
			minLoadTimer.start();
			
			var loadTimer: Timer = new Timer(0, 1);
			loadTimer.addEventListener(TimerEvent.TIMER, function onLoadTimer(event: TimerEvent): void {
				event.target.removeEventListener(TimerEvent.TIMER, onLoadTimer);
				loadResources();
			});
			loadTimer.start();
		}
		
		private function multiLoaderProgressListener(event:MultiLoaderEvent):void
		{
			trace("UpdatedTools::progress()", event.entry, ": ", (event.bytesLoaded/event.bytesTotal*100));
			(_gameLayerManager.getGameLayer(FORM_PRELOADER) as StartPreloadForm).progressPercent = event.bytesLoaded/event.bytesTotal*100;
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void
		{
			_resourcesLoaded = true;
			if (_multiLoader.isLoaded) {
				loadForms();
			}
//			trace("UpdatedTools::complete()");
//			switch(event.entry)
//			{
//				case "efnx":
//					var efnxBitmap:Bitmap = _multiLoader.get("efnx");
//					_scene.addChild(efnxBitmap);
//					break;
//				case "808":
//					var sprite808:Sprite = _multiLoader.get("808");
//					_scene.addChild(sprite808);
//					break;
//				default:
//			}
		}
	}
}