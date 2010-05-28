package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.forms.AllUserPhotoForm;
	import com.facecontrol.forms.Background;
	import com.facecontrol.forms.FavoritesForm;
	import com.facecontrol.forms.FriendsForm;
	import com.facecontrol.forms.MainForm;
	import com.facecontrol.forms.MyPhotoForm;
	import com.facecontrol.forms.PhotoAlbumForm;
	import com.facecontrol.forms.PreloaderForm;
	import com.facecontrol.forms.PreloaderSplash;
	import com.facecontrol.forms.Top100;
	import com.facecontrol.gui.MainMenuEvent;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Form;
	import com.net.VKontakte;
	import com.net.VKontakteEvent;
	import com.serialization.json.JSON;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.Security;
	
	public class Facecontrol extends GameScene {
		private static const SETTINGS_NOTICE_ACCEPT:int = 0x01;
		private static const SETTINGS_FRIENDS_ACCESS:int = 0x02;
		private static const SETTINGS_PHOTO_ACCESS:int = 0x04;
		
		private var _background:Background;
		private var _preloaderShown:Boolean;
		private var api_result:String;
		
		public function Facecontrol() {
			Security.allowDomain('*');
			MultiLoader.usingContext = true;
			Util.scene = this;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e: Event): void {
	    	Util.wrapper = Object(this.parent.parent);
	    	if (Util.wrapper.application) {
	    		appObject = Util.wrapper.application;
	    		Util.wrapper.external.resizeWindow(Constants.APP_WIDTH, Constants.APP_HEIGHT);
	    		
	    		api_result = appObject.parameters.api_result;
	    		VKontakte.apiUrl = appObject.parameters.api_url;
	    		Util.viewer_id = appObject.parameters.viewer_id;
	    		Util.user_id = appObject.parameters.user_id;
	    		
	    		if (Util.viewer_id != Util.user_id) {
	    			Util.api.invite();
	    		}
	    		
	    		Util.wrapper.addEventListener('onApplicationAdded', onApplicationAdded);
	    		Util.wrapper.addEventListener('onSettingsChanged', onSettingsChanged);
	    	}
	    	loadPreloader();
	  	}
		
		private function loadPreloader():void {
			Util.multiLoader.addEventListener(ErrorEvent.ERROR, multiloaderError);
			for each (var image: String in Images.PRE_IMAGES) {
				Util.multiLoader.load(image, image, 'Bitmap');
			}
			
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
		}
		
		private function load():void {
			for each (var image:String in Images.IMAGES) {
				Util.multiLoader.load(image, image, 'Bitmap');
			}
			
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
		}
		
		private function multiloaderError(event:ErrorEvent):void {
//			TODO: show alert
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.isLoaded) {
				Util.multiLoader.removeEventListener(ErrorEvent.ERROR, multiloaderError);
				Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
				
				if (_preloaderShown) {
					_background = new Background(this);
					_background.visible = false;
					_background.menu.addEventListener(MainMenuEvent.FIRST_BUTTON_CLICK, onFirstMenuButtonClick);
					_background.menu.addEventListener(MainMenuEvent.SECOND_BUTTON_CLICK, onSecondMenuButtonClick);
					_background.menu.addEventListener(MainMenuEvent.THIRD_BUTTON_CLICK, onThirdMenuButtonClick);
					_background.menu.addEventListener(MainMenuEvent.FOURTH_BUTTON_CLICK, onFourthMenuButtonClick);
					_background.menu.addEventListener(MainMenuEvent.FIFTH_BUTTON_CLICK, onFifthMenuButtonClick);
					addChild(_background);
					
					addChild(MainForm.instance);
					addChild(MyPhotoForm.instance);
					addChild(Top100.instance);
					addChild(FavoritesForm.instance);
					addChild(FriendsForm.instance);
					addChild(AllUserPhotoForm.instance);
					
					if (Util.wrapper.application) {
						if (appObject.parameters.is_app_user) {
							checkAppSettings();
						}
						else {
							Util.wrapper.external.showInstallBox();
						}
					}
//					if (Util.wrapper.application) Util.vkontakte.isAppUser();
					else Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
				}
				else {
					_preloaderShown = true;
					addChild(PreloaderForm.instance);
					
					load();
					
					Util.api.addEventListener(ApiEvent.COMPLETED, onFacecontrolRequestComplited);
					Util.api.addEventListener(ApiEvent.ERROR, onFacecontrolRequestError);
					
					Util.vkontakte.addEventListener(VKontakteEvent.COMPLETED, onVkontakteRequestComplited);
					Util.vkontakte.addEventListener(VKontakteEvent.ERROR, onVkontakteRequestError);
				}
			}
		}
		
		public function onFirstMenuButtonClick(event:MainMenuEvent):void {
			if (!MainForm.instance.bigPhoto) {
				PreloaderSplash.instance.showModal();
				Util.api.nextPhoto(Util.viewer_id);
			}
			MainForm.instance.show();
		}
		
		public function onSecondMenuButtonClick(event:MainMenuEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.getPhotos(Util.viewer_id);
		}
		
		public function onThirdMenuButtonClick(event:MainMenuEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.getTop(Util.viewer_id);
		}
		
		public function onFourthMenuButtonClick(event:MainMenuEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.favorites(Util.viewer_id);
		}
		
		public function onFifthMenuButtonClick(event:MainMenuEvent):void {
			PreloaderSplash.instance.showModal();
			FriendsForm.instance.requestFriends();
		}
		
		private function onVkontakteRequestError(event:VKontakteEvent):void {
			Util.showError(event.errorCode, event.errorMessage);
		}
		
		private function onVkontakteRequestComplited(event:VKontakteEvent):void {
			var response:Object = event.response;
			try {
				switch (event.method) {
					case 'getProfiles':
						Util.user = response[0];
						Util.api.registerUser(Util.user);
					break;
					
					case 'getAppFriends':
						Util.api.friends(response as Array);
					break;
					
//					case 'isAppUser':
//						switch (response) {
//							case '0':
//								if (Util.wrapper.external) {
//									Util.wrapper.external.showInstallBox();
//								}
//							break;
//							case '1':
//								Util.vkontakte.getUserSettings();
//							break;
//						}
//					break;
					
//					case 'getUserSettings':
//						var settings:int = response as int;
//						
//						if ((settings & SETTINGS_NOTICE_ACCEPT) == 0 ||
//							(settings & SETTINGS_FRIENDS_ACCESS) == 0 ||
//							(settings & SETTINGS_PHOTO_ACCESS) == 0)
//						{
//							var installSettings:int = 0;
//							installSettings |= SETTINGS_NOTICE_ACCEPT;
//							installSettings |= SETTINGS_FRIENDS_ACCESS;
//							installSettings |= SETTINGS_PHOTO_ACCESS;
//							Util.wrapper.external.showSettingsBox(installSettings);
//						}
//						else {
//							if (api_result) {
//								var json:Object = JSON.deserialize(api_result);
//								Util.user = json.response[0];
//								Util.api.registerUser(Util.user);
//							}
//							else {
//								Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
//							}
//						}
//					break;
				}
			}
			catch (e:Error) {
				if (Util.DEBUG) trace(e.message);
			}
		}
		
		public function onFacecontrolRequestError(event:ApiEvent):void {
			Util.showError(event.errorCode, event.errorMessage);
		}
		
		private function onFacecontrolRequestComplited(event:ApiEvent):void {
			var response:Object = event.response;
			try {
				switch (response.method) {
					case 'reg_user':
						Util.user.city_name = response.city_name;
						Util.user.country_name = response.country_name;
						if (response.photo_count == 0) {
							Util.api.addPhoto(Util.viewer_id,
												Util.user.photo,
												Util.user.photo_medium,
												Util.user.photo_big);
						}
						else Util.api.loadSettings(Util.viewer_id);
					break;
					
					case 'top100':
						PreloaderSplash.instance.resetModal();
						Top100.instance.users = event.response.users;
						Top100.instance.show();
					break;
					
					case 'add_photo':
						Util.api.loadSettings(Util.viewer_id);
					break;
					
					case 'load_settings':
						MainForm.instance.filter = response;
						Util.api.nextPhoto(Util.viewer_id);
					break;
					
					case 'next_photo':
						_background.visible = true;
						MainForm.instance.show();
						MainForm.instance.nextPhoto(response);
						PreloaderSplash.instance.resetModal();
					break;
					
					case 'vote':
						MainForm.instance.vote(response);
					break;
					
					case 'get_photos':
						MyPhotoForm.instance.photos = response.photos;
						PhotoAlbumForm.instance.setAddedPhotos(MyPhotoForm.instance.photos);
						MyPhotoForm.instance.show();
						if (PreloaderSplash.instance.isModal) {
							this.resetModal(PreloaderSplash.instance);
						}
					break;
					
					case 'del_photo':
						try {
							Util.multiLoader.unload(response.pid);
						}
						catch (e:Error) {}
						PhotoAlbumForm.instance.setAddedPhotos(MyPhotoForm.instance.photos);
						PreloaderSplash.instance.resetModal();
					case 'set_main':
					case 'edit_photo':
						Util.api.getPhotos(Util.viewer_id);
					break;
					
					case 'save_settings':
						Util.api.nextPhoto(Util.viewer_id);
					break;
					
					case 'favorites':
						FavoritesForm.instance.users = response.users;
						FavoritesForm.instance.show();
						PreloaderSplash.instance.resetModal();
					break;
					
					case 'add_favorite':
					case 'del_favorite':
						for (var i:int = 0; i < numChildren; ++i) {
							if (getChildAt(i) is Form) {
								var form:Form = getChildAt(i) as Form;
								if (form.visible) {
									form.refresh();
									break;
								}
							} 
						}
					break;
					
					case 'main_photo':
						_background.visible = true;
						MainForm.instance.show();
						MainForm.instance.nextPhoto(response);
						if (PreloaderSplash.instance.isModal) {
							this.resetModal(PreloaderSplash.instance);
						}
					break;
				}
			}
			catch (e:Error) {
				if (Util.DEBUG) trace(e.message);
			}
		}
		
		public function onApplicationAdded(e:Object):void {
//			Util.vkontakte.getUserSettings();
			checkAppSettings();
		}
		
		public function onSettingsChanged(e:Object):void {
			if (appObject.parameters) {
				appObject.parameters.api_settings = e.settings;
			}
//			var settings:Number = e.settings;
//			if ((settings & SETTINGS_NOTICE_ACCEPT) == 0 ||
//				(settings & SETTINGS_FRIENDS_ACCESS) == 0 ||
//				(settings & SETTINGS_PHOTO_ACCESS) == 0) {
//				if (Util.wrapper.external) {
//					var installSettings:int = 0;
//					installSettings |= SETTINGS_NOTICE_ACCEPT;
//					installSettings |= SETTINGS_FRIENDS_ACCESS;
//					installSettings |= SETTINGS_PHOTO_ACCESS;
//					Util.wrapper.external.showSettingsBox(installSettings);
//				}
//			}
//			else {
				Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
//			}
		}
		
		public function checkAppSettings():void {
			if ((appObject.parameters.api_settings & SETTINGS_NOTICE_ACCEPT) == 0 ||
			(appObject.parameters.api_settings & SETTINGS_FRIENDS_ACCESS) == 0 ||
			(appObject.parameters.api_settings & SETTINGS_PHOTO_ACCESS) == 0)
			{
				var installSettings:int = 0;
				installSettings |= SETTINGS_NOTICE_ACCEPT;
				installSettings |= SETTINGS_FRIENDS_ACCESS;
				installSettings |= SETTINGS_PHOTO_ACCESS;
				Util.wrapper.external.showSettingsBox(installSettings);
			}
			else {
				if (api_result) {
					var json:Object = JSON.deserialize(api_result);
					Util.user = json.response[0];
					Util.api.registerUser(Util.user);
				}
				else {
					Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
				}
			}
		}
	}
}

