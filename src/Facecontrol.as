package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.forms.AllUserPhotoForm;
	import com.facecontrol.forms.Background;
	import com.facecontrol.forms.FavoritesForm;
	import com.facecontrol.forms.FriendsForm;
	import com.facecontrol.forms.MainForm;
	import com.facecontrol.forms.MessageDialog;
	import com.facecontrol.forms.MyPhotoForm;
	import com.facecontrol.forms.PreloaderForm;
	import com.facecontrol.forms.Top100;
	import com.facecontrol.gui.MainMenuEvent;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.Pagination;
	import com.flashmedia.gui.RatingBar;
	import com.flashmedia.gui.ScrollBar;
	import com.net.ServerEvent;
	import com.net.VKontakteEvent;
	
	import flash.text.TextField;
	
	public class Facecontrol extends GameScene {
		
		private static var _images:Images;
		private static var _multiLoader: MultiLoader;
		
		private var textField: TextField = new TextField();
		private var p:Pagination;
		private var linkButton:LinkButton;
		private var gb: GridBox;
		private var cb: ComboBox;
		private var scroll: ScrollBar;
		private var rateBar: RatingBar;
		private var form: Form;
		
		private var _background:Background;
		private var _preloaderShown: Boolean;
		
		public function Facecontrol() {
			
			Util.scene = this;
			_images = new Images();
			
			Util.multiLoader = new MultiLoader();
			Util.multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
			loadPreloader();
		}
		
		private function loadPreloader():void {
			for each (var image: String in Images.PRE_IMAGES) {
				Util.multiLoader.load(image, image, 'Bitmap');
			}
		}
		
		private function load():void {
			for each (var image:String in Images.IMAGES) {
				Util.multiLoader.load(image, image, 'Bitmap');
			}
		}
		
		private function multiLoaderProgressListener(event:MultiLoaderEvent):void {
			
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.isLoaded) {
				if (_preloaderShown) {
					Util.multiLoader.removeEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
					Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
					
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
					
					Util.vkontakte.getProfiles(new Array('' + Util.userId));
				}
				else {
					_preloaderShown = true;
					addChild(PreloaderForm.instance);
					
					load();
					
					Util.api.addEventListener(ApiEvent.COMPLETED, onFacecontrolRequestComplited);
					Util.api.addEventListener(ApiEvent.ERROR, onFacecontrolRequestError);
					
					Util.vkontakte.addEventListener(VKontakteEvent.COMPLETED, onVkontakteRequestComplited);
					Util.vkontakte.addEventListener(VKontakteEvent.ERROR, onVkontakteRequestError);
					
					Util.vkontakte.addEventListener(VKontakteEvent.FRIEDNS_PROFILES_LOADED, onFriendsProfilesResponse);
					
					Util.server.addEventListener(ServerEvent.ERROR, onServerRequestError);
					Util.server.addEventListener(ServerEvent.TOP_LOAD_COMPLETED, onTopLoaded);
					Util.server.addEventListener(ServerEvent.REG_USER_COMPLETED, onUserRegistred);
				}
			}
		}
		
		public function onFirstMenuButtonClick(event:MainMenuEvent):void {
			Util.api.nextPhoto(Util.userId);
			MainForm.instance.show();
		}
		
		public function onSecondMenuButtonClick(event:MainMenuEvent):void {
			Util.api.getPhotos(Util.userId);
		}
		
		public function onThirdMenuButtonClick(event:MainMenuEvent):void {
			Util.server.getTop(Util.userId);
		}
		
		public function onFourthMenuButtonClick(event:MainMenuEvent):void {
			Util.api.favorites(Util.userId);
		}
		
		public function onFifthMenuButtonClick(event:MainMenuEvent):void {
			Util.vkontakte.getFriends();
		}
		
		public function onServerRequestError(event:ServerEvent):void {
			try {
				switch (event.errorCode) {
					default:
						showModal(new MessageDialog(this, 'Ошибка:', event.errorMessage));
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
		
		private function onUserRegistred(event:ServerEvent):void {
			var response:Object = event.response;
			Util.user.city_name = response.city_name;
			Util.user.country_name = response.country_name;
			if (response.photo_count == 0) {
				Util.api.addPhoto(Util.userId, Util.user.photo, Util.user.photo_medium, Util.user.photo_big);
			}
			else Util.api.loadSettings(Util.userId);
		}
		
		private function onTopLoaded(event:ServerEvent):void {
			Top100.instance.users = event.response.users;
			Top100.instance.show();
		}
		
		private function onVkontakteRequestError(event:VKontakteEvent):void {
			try {
				switch (event.errorCode) {
					default:
						trace('onVkontakteRequestError: ' + event.errorCode + ' ' + event.errorMessage);
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
		
		private function onVkontakteRequestComplited(event:VKontakteEvent):void {
			var response:Object = event.response;
			try {
				switch (event.method) {
					case 'getProfiles':
						Util.user = response[0];
						Util.server.registerUser(Util.userId, Util.user.first_name, Util.user.last_name, Util.user.nickname, Util.user.sex, Util.user.bdate, Util.user.city, Util.user.country);
					break;
					
					case 'getFriends':
						Util.api.friends(response as Array);
					break;
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
		
		public function onFriendsProfilesResponse(event:VKontakteEvent):void {
			var users:Array = event.response as Array;
			FriendsForm.instance.users = users;
			FriendsForm.instance.show();
		}
		
		public function onFacecontrolRequestError(event:ApiEvent):void {
			try {
				switch (event.errorCode) {
					default:
						showModal(new MessageDialog(this, 'Ошибка:', event.errorMessage));
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
		
		private function onFacecontrolRequestComplited(event:ApiEvent):void {
			var response:Object = event.response;
			try {
				switch (response.method) {
//					case 'reg_user':
//						Util.user.city_name = response.city_name;
//						Util.user.country_name = response.country_name;
//						if (response.photo_count == 0) {
//							Util.api.addPhoto(Util.userId, Util.user.photo, Util.user.photo_medium, Util.user.photo_big);
//						}
//						else Util.api.loadSettings(Util.userId);
//					break;
					
					case 'add_photo':
						Util.api.loadSettings(Util.userId);
					break;
					
					case 'load_settings':
						MainForm.instance.filter = response;
						Util.api.nextPhoto(Util.userId);
					break;
					
					case 'next_photo':
						_background.visible = true;
						MainForm.instance.show();
						MainForm.instance.nextPhoto(response);
					break;
					
					case 'vote':
						MainForm.instance.vote(response);
					break;
					
					case 'get_photos':
						this.resetModal(PreloaderForm.instance);
						MyPhotoForm.instance.photos = response.photos;
						MyPhotoForm.instance.show();
					break;
					
					case 'del_photo':
						Util.multiLoader.unload(response.pid);
						
					case 'set_main':
						Util.api.getPhotos(Util.userId);
					break;
					
					case 'friends':
						FriendsForm.instance.users = response.users;
						FriendsForm.instance.show();
					break;
					
					case 'edit_photo':
						Util.api.getPhotos(Util.userId);
					break;
					
					case 'save_settings':
						Util.api.nextPhoto(Util.userId);
					break;
					
					case 'favorites':
						FavoritesForm.instance.users = response.users;
						FavoritesForm.instance.show();
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
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
	}
}

