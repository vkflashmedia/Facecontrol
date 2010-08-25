package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.gui.UserGridItem;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.Pagination;
	import com.flashmedia.util.BitmapUtil;
	import com.net.VKontakte;
	import com.net.VKontakteEvent;
	
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FriendsForm extends Form
	{
		private static const MAX_PHOTO_COUNT_IN_GRID:uint = 5;
		
		private static var _instance:FriendsForm = null;
		public static function get instance():FriendsForm {
			if (!_instance) _instance = new FriendsForm(Util.scene);
			return _instance;
		}
		
		private var _friendsCount:TextField;
		private var _pagination:Pagination;
		private var _grid:GridBox;
		private var _users:Array;
		
		private var cities:Array;
		private var countries:Array;
		private var _friends:Array;
		private var _appFriends:Array;
		private var _friendsIds:Array;
		private var _vkontakte:VKontakte = new VKontakte();
		private var _api:Api = new Api();
		
		private var _startIndex:int = 0;
		private var _endIndex:int = 5;
		
		private var _multiloader:MultiLoader;
		
		public function FriendsForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			_multiloader = new MultiLoader();
			visible = false;
			
			_vkontakte.addEventListener(VKontakteEvent.COMPLETED, onVkontakteRequestCompleted);
			_vkontakte.addEventListener(VKontakteEvent.ERROR, onVkontakteRequestError);
			
			_api.addEventListener(ApiEvent.COMPLETED, onApiRequestCompleted);
			_api.addEventListener(ApiEvent.ERROR, onApiRequestError);
			
			var label:TextField = Util.createLabel('Мои друзья', 150, 75);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var background:Bitmap = BitmapUtil.cloneImageNamed(Images.FRIENDS_BACKGROUND);
			background.x = 152;
			background.y = 104;
			addChild(background);
			
			_friendsCount = Util.createLabel('', 400, 84, 80, 10);
			_friendsCount.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 11, 0xff352b);
			_friendsCount.embedFonts = true;
			_friendsCount.antiAliasType = AntiAliasType.ADVANCED;
			_friendsCount.autoSize = TextFieldAutoSize.RIGHT;
			addChild(_friendsCount);
			
			_pagination = new Pagination(_scene, 383, 600);
			_pagination.width = 83;
			_pagination.textFormatForDefaultButton = new TextFormat(Util.tahoma.fontName, 9, 0xbcbcbc);
			_pagination.textFormatForSelectedButton = new TextFormat(Util.tahomaBold.fontName, 9, 0x00ccff);
			_pagination.addEventListener(Event.CHANGE, onPaginationChange);
			addChild(_pagination);
			_pagination.pagesCount = 10;
			
			_grid = new GridBox(_scene, 1, 5);
			_grid.x = 153;
			_grid.y = 102;
			_grid.width = 326;
			_grid.height = 492;
			_grid.widthPolicy = GridBox.WIDTH_POLICY_AUTO_SIZE;
			_grid.heightPolicy = GridBox.HEIGHT_POLICY_AUTO_SIZE;
			_grid.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_grid.verticalItemsAlign = View.ALIGN_VER_TOP;
			_grid.indentBetweenRows = 0;
			_grid.indentBetweenCols= 0;
			_grid.setPaddings(0,0,0,0);
//			_grid.debug = true;
			addChild(_grid);
		}
		
		public function onPaginationChange(event:Event):void {
			updateGrid();
		}
		
		public function set users(value:Array):void {
			if (!PreloaderSplash.instance.isModal) {
				Util.scene.showModal(PreloaderSplash.instance);
			}
			_users = value;
			updateGrid();
		}
		
		public function loadError(event:ErrorEvent):void {
			
		}
		
		public function loadComplete(event:MultiLoaderEvent):void {
			if (_multiloader.isLoaded) {
				_multiloader.removeEventListener(ErrorEvent.ERROR, loadError);
				_multiloader.removeEventListener(MultiLoaderEvent.COMPLETE, loadComplete);
				
				updateGrid();
				if (PreloaderSplash.instance.isModal) {
					Util.scene.resetModal(PreloaderSplash.instance);
				}
			}
		}
		
		public function updateGrid():void {
			var i:int = 0;
			var j:int = 0;
			var count:int = _users.length;
			var format:TextFormat = _friendsCount.getTextFormat();
			_friendsCount.text = 'всего: ' + count;
			_friendsCount.setTextFormat(format);
			_pagination.pagesCount = Math.ceil(_users.length / MAX_PHOTO_COUNT_IN_GRID);
			_pagination.visible = _pagination.pagesCount > 1;
			
			_grid.removeAllItems();
			
			if (_users.length > 0) {
				var start:int = _pagination.currentPage * MAX_PHOTO_COUNT_IN_GRID;
				var end:int = start + MAX_PHOTO_COUNT_IN_GRID < _friendsIds.length ? start + MAX_PHOTO_COUNT_IN_GRID : _friendsIds.length;
				
				_startIndex = start - 5;
				_endIndex = end + 5;
				if (_startIndex < 0) _startIndex = 0;
				if (_endIndex >= count) _endIndex = count - 1;
				
				_multiloader.addEventListener(ErrorEvent.ERROR, loadError);
				
				var item:UserGridItem;
				for (i = start, j = 1; i < end; ++i, ++j) {
					var user:Object = _users[i];
					if (user.pid) {
						if (!_multiloader.hasLoaded(user.pid)) {
							if (user.src_big) _multiloader.load(user.src_big, user.pid, 'Bitmap');
						}
					}
					else if (user.photo_big) {
						if (!_multiloader.hasLoaded(user.photo_big)) {
							if (user.photo_big) _multiloader.load(user.photo_big, user.photo_big, 'Bitmap');
						}
					}
					var photoBitmap:Bitmap = null;
					if (_multiloader.hasLoaded(_users[i].pid)) {
						photoBitmap = new Bitmap(_multiloader.get(_users[i].pid).bitmapData);
					}
					else if (_multiloader.hasLoaded(_users[i].photo_big)) {
						photoBitmap = new Bitmap(_multiloader.get(_users[i].photo_big).bitmapData);
					}
					item = new UserGridItem(_scene, _users[i], photoBitmap, j < MAX_PHOTO_COUNT_IN_GRID, true, this);
					_grid.addItem(item);
				}
				
				if (_multiloader.isLoaded) {
					if (PreloaderSplash.instance.isModal) {
						Util.scene.resetModal(PreloaderSplash.instance);
					}
				}
				else {
					if (!PreloaderSplash.instance.isModal) {
						Util.scene.showModal(PreloaderSplash.instance);
					}
					_multiloader.addEventListener(MultiLoaderEvent.COMPLETE, loadComplete);
				}
			}
		}
		
		public override function refresh():void {
			requestFriends();
		}
		
		public function requestFriends():void {
			PreloaderSplash.instance.showModal();
			_vkontakte.getAppFriends();
		}
		
		public function onVkontakteRequestCompleted(event:VKontakteEvent):void {
			var response:Object = event.response;
			switch (event.method) {
				case 'getProfiles':
					cities = new Array();
					countries = new Array();
					_friends = _appFriends;
					var notAppFriends:Array = response as Array;
					
					for each (var notAppFriend:Object in notAppFriends) {
						if (!notAppFriend.city || notAppFriend.city == 0) notAppFriend.city = null;
						else cities.push(notAppFriend.city);
						
						if (!notAppFriend.country || notAppFriend.country == 0) notAppFriend.country = null;
						else countries.push(notAppFriend.country);
						
						_friends = _friends.concat(notAppFriend);
					}
					
					_vkontakte.getCities(cities);
				break;
				
				case 'getCities':
					cities = response as Array;
					for each (var friend:Object in _friends) {
						for each (var city:Object in cities) {
							if (friend.city == city.cid) {
								friend.city = city.name;
							}
						}
					}
					_vkontakte.getCountries(countries);
				break;
				
				case 'getCountries':
					countries = response as Array;
					for each (friend in _friends) {
						for each (var country:Object in countries) {
							if (friend.country == country.cid) {
								friend.country = country.name;
							}
						}
					}
					
					users = _friends;
					show();
				break;
				
				case 'getAppFriends':
					_api.friends(response as Array);
				break;
				
				case 'getFriends':
					_friendsIds = response as Array;
					var notAppFriendsIds:Array = new Array();
					for each (var id:String in _friendsIds) {
						var isAppFriendId:Boolean = false;
						for each (var appFriend:Object in _appFriends) {
							if (appFriend.uid == id) {
								isAppFriendId = true;
								break;
							}
						}
						if (!isAppFriendId) {
							notAppFriendsIds.push(id);
						}
					}
					_vkontakte.getProfiles(notAppFriendsIds);
				break;
			}
		}
		
		public function onVkontakteRequestError(event:VKontakteEvent):void {
			Util.showError(event.errorCode, event.errorMessage);
		}
		
		public function onApiRequestCompleted(event:ApiEvent):void {
			var response:Object = event.response;
			switch (response.method) {
				case 'friends':
					_appFriends = response.users;
					_vkontakte.getFriends();
				break;
			}
		}
		
		public function onApiRequestError(event:ApiEvent):void {
			Util.showError(event.errorCode, event.errorMessage);
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is FriendsForm);
					}
				}
			}
		}
	}
}