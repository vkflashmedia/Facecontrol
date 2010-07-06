package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.dialog.PhotoAlbumDialog;
	import com.facecontrol.forms.AllUserPhotoForm;
	import com.facecontrol.forms.Background;
	import com.facecontrol.forms.FavoritesForm;
	import com.facecontrol.forms.FramesForm;
	import com.facecontrol.forms.FriendsForm;
	import com.facecontrol.forms.MainForm;
	import com.facecontrol.forms.MyPhotoForm;
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
					Background.instance.visible = false;
					Background.instance.menu.addEventListener(MainMenuEvent.FIRST_BUTTON_CLICK, onFirstMenuButtonClick);
					Background.instance.menu.addEventListener(MainMenuEvent.THIRD_BUTTON_CLICK, onThirdMenuButtonClick);
					Background.instance.menu.addEventListener(MainMenuEvent.FOURTH_BUTTON_CLICK, onFourthMenuButtonClick);
					Background.instance.menu.addEventListener(MainMenuEvent.FIFTH_BUTTON_CLICK, onFifthMenuButtonClick);
					Background.instance.menu.visible = false;
					addChild(Background.instance);
					
					addChild(MainForm.instance);
					addChild(MyPhotoForm.instance);
					addChild(Top100.instance);
					addChild(FavoritesForm.instance);
					addChild(FriendsForm.instance);
					addChild(FramesForm.instance);
					addChild(AllUserPhotoForm.instance);
					
					addChild(Background.instance.menu);
					
					if (Util.wrapper.application) Util.vkontakte.isAppUser();
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
			FramesForm.instance.getMainPhoto();
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
						Util.api.login(Util.user);
//						Util.api.registerUser(Util.user);
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
					
					case 'getUserSettings':
						var settings:int = response as int;
						
						if ((settings & SETTINGS_NOTICE_ACCEPT) == 0 ||
							(settings & SETTINGS_FRIENDS_ACCESS) == 0 ||
							(settings & SETTINGS_PHOTO_ACCESS) == 0)
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
								Util.api.login(Util.user);
//								Util.api.registerUser(Util.user);
							}
							else {
								Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
							}
						}
					break;
				}
			}
			catch (e:Error) {
				if (Util.DEBUG) trace(e.message);
			}
		}
		
		private function resetPaymentListeners():void {
			Util.wrapper.removeEventListener('onMerchantPaymentCancel');
			Util.wrapper.removeEventListener('onMerchantPaymentSuccess');
			Util.wrapper.removeEventListener('onMerchantPaymentFail');
		}
		
		public function onFacecontrolRequestError(event:ApiEvent):void {
			switch (event.errorCode) {
				case 502:
					if (Util.wrapper.external) {
						Util.wrapper.addEventListener('onMerchantPaymentCancel', function():void {
							resetPaymentListeners();
							Util.requestVotes = 0;
						});
	    				Util.wrapper.addEventListener('onMerchantPaymentSuccess', function(merchantOrderId: String):void {
	    					resetPaymentListeners();
	    					Util.api.withdrawVotes('', Util.requestVotes);
	    				});
	    				Util.wrapper.addEventListener('onMerchantPaymentFail', function():void {
	    					resetPaymentListeners();
	    					Util.requestVotes = 0;
	    				});
						Util.wrapper.external.showPaymentBox(Util.requestVotes);
					}
				break;
				default:
					Util.showError(event.errorCode, event.errorMessage);
			}
		}
		
		private function onFacecontrolRequestComplited(event:ApiEvent):void {
			var response:Object = event.response;
			try {
				switch (response.method) {
					case 'reg_user':
						Util.user.account = response.account;
						Background.instance.updateAccount();
						Util.user.city_name = response.city_name;
						Util.user.country_name = response.country_name;
						Util.inviteCount = response.invite_count;
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
						Background.instance.visible = true;
						Background.instance.menu.visible = true;
						MainForm.instance.show();
						MainForm.instance.nextPhoto(response);
//						PreloaderSplash.instance.resetModal();
						
						if (Util.inviteCount > 0) {
							var result:String = '';
							switch (Util.inviteCount) {
								case 11:
								case 12:
								case 13:
								case 14:
									result = 'Вами было приглашено ' + Util.inviteCount + ' новых пользователей';
								break;
								default:
									var remainder:int = Util.inviteCount % 10;
									switch (remainder) {
										case 1:
											result = 'Вами был приглашен ' + Util.inviteCount + ' новый пользователь';
										break;
										case 2:
										case 3:
										case 4:
											result = 'Вами было приглашено ' + Util.inviteCount + ' новых пользователя';
										break;
										default:
											result = 'Вами было приглашено ' + Util.inviteCount + ' новых пользователей';
									}
							}
							MessageDialog.dialog('Поздравляем:', result +'.\n'+
								'За это тебе начислено '+Util.inviteCount*5 + ' монет.');
							Util.inviteCount = 0;
						}
					break;
					
					case 'main_photo':
						Background.instance.visible = true;
						MainForm.instance.show();
						MainForm.instance.nextPhoto(response);
						PreloaderSplash.instance.resetModal();
					break;
					
					case 'vote':
						MainForm.instance.vote(response);
					break;
					
					case 'get_photos':
						MyPhotoForm.instance.photos = response.photos;
						PhotoAlbumDialog.instance.setAddedPhotos(MyPhotoForm.instance.photos);
						MyPhotoForm.instance.show();
						PreloaderSplash.instance.resetModal();
					break;
					
					case 'del_photo':
						try {
							Util.multiLoader.unload(response.pid);
						}
						catch (e:Error) {}
						PhotoAlbumDialog.instance.setAddedPhotos(MyPhotoForm.instance.photos);
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
					
					case 'write_in':
					case 'write_off':
						Util.user.account = response.account;
						Background.instance.updateAccount();
					break;
					
					case 'withdraw_votes':
						Util.requestVotes = 0;
						Util.user.account = response.account;
						Background.instance.updateAccount();
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
					Util.api.login(Util.user);
				}
				else {
					Util.vkontakte.getProfiles(new Array(''+Util.viewer_id));
				}
			}
		}
	}
}

