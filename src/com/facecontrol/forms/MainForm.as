package com.facecontrol.forms
{
	import com.adobe.images.JPGEncoder;
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.ComboBoxEvent;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.RatingBar;
	import com.flashmedia.util.BitmapUtil;
	import com.net.VKontakte;
	import com.net.VKontakteEvent;
	import com.serialization.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import ru.inspirit.net.MultipartURLLoader;
	
	
	public class MainForm extends Form
	{
		private static const COUNTRY_DEFAULT:String = 'Весь мир';
		private static const CITY_DEFAULT:String = 'Вся страна';
		
		private static const CURRENT_PHOTO_COMMENT_HEIGHT:int = 100;
		private static const CURRENT_USER_NAME_HEIGHT:int = 25;

		private static const INDENT_BETWEEN_CURRENT_PHOTO_AND_NAME:int = 4;
		private static const INDENT_BETWEEN_CURRENT_PHOTO_AND_COMMENT:int = 32;
		
		private static const INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_STAR_ICON:int = 8;
		private static const INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_DELIMITER_ICON:int = 68;
		private static const INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_RATING_AVERAGE:int = 3;
		private static const INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_RATING_AVERAGE_LABEL:int = 43;
		private static const INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_VOTES_COUNT:int = 90;
		private static const INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_VOTES_COUNT_LABEL:int = 72;
		
		private static const INDENT_BETWEEN_INVITE_LABEL_AND_PHOTO:int = 5;
		private static const INDENT_BETWEEN_INVITE_PHOTO_AND_BUTTON:int = 0;
		
		private static var _instance:MainForm = null;
		public static function get instance():MainForm {
			if (!_instance) _instance = new MainForm(Util.scene);
			return _instance;
		}
		
		private var _currentUser:Object;
		private var _currentUserArea:Sprite;
		private var _currentUserPhoto:Photo;
		private var _currentUserName:LinkButton;
		private var _currentUserPhotoComment:TextField;
		private var _currentUserMorePhotosButton:LinkButton;
		private var _currentUserSetFavoriteButton:LinkButton;
		
		private var _previousUser:Object;
		private var _previousUserPhoto:Photo;
		private var _previousUserPhotoRatingAverage:TextField;
		private var _previousUserPhotoVotesCount:TextField;
		private var _previousUserPhotoRatingAverageLabel:TextField;
		private var _previousUserPhotoVotesCountLabel:TextField;
		private var _previousUserArea:Sprite;
		private var _previousUserStarIcon:Bitmap;
		private var _previousUserDelimiterIcon:Bitmap;
		
		private var _inviteArea:Sprite;
		private var _inviteLabel:TextField;
		private var _invitePhoto:Photo;
		private var _inviteButton:Button;
		
		private var _rateBar:RatingBar;
		
		private var _sexBox:ComboBox;
		private var _minAgeBox:TextField;
		private var _maxAgeBox:TextField;
		private var _countryBox:ComboBox;
		private var _cityBox:ComboBox;
		
		private var _filter:Object;
		private var _multiloader:MultiLoader;
		private var _vkontakte:VKontakte;
		private var _friends:Array;
		private var _friend:Object;
		private var _toUnload:String = undefined;
		
		private var _friendPhotoLoader:MultiLoader;
		private var _mpLoader:MultipartURLLoader;
		private var _server:String;
		private var _photo:String;
		private var _hash:String;
		
		public function MainForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			_multiloader = new MultiLoader();
			
			_mpLoader = new MultipartURLLoader();
			_mpLoader.addEventListener(Event.COMPLETE, function(event:Event):void {
				var response:Object = JSON.deserialize(_mpLoader.loader.data);
				_server = response.server;
				_photo = response.photo;
				_hash = response.hash;
				_vkontakte.wallSavePost(_friend.uid, response.server, response.photo, response.hash);
			});
			
			_friendPhotoLoader = new MultiLoader();
			_friendPhotoLoader.addEventListener(MultiLoaderEvent.COMPLETE, function(event:MultiLoaderEvent):void {
				var url:String = _friend.photo_big;
				if (_friendPhotoLoader.hasLoaded(url)) {
					showInviteArea();
				}
			});
			
			_vkontakte = new VKontakte();
			_vkontakte.addEventListener(VKontakteEvent.COMPLETED, function(event:VKontakteEvent):void {
				var response:Object = event.response;
				try {
					switch (event.method) {
						case 'getFriends':
							_friends = response as Array;
							_vkontakte.getAppFriends();
						break;
						
						case 'getAppFriends':
							var appFriends:Array = response as Array;
							_friends.filter(function(element:*, index:int, arr:Array):* {
								for each (var uid:int in appFriends) {
									if (element.uid == uid) {
										return false;
									}
								}
								return true;
							});
							randomizeFriend();
						break;
						
						case 'getPhotoUploadServer':
							var vars:URLVariables = new URLVariables();
							var bitmap:Bitmap = Util.multiLoader.get(Images.INVITE_ICON);
						    var myEncoder:JPGEncoder = new JPGEncoder(70);
						    var myCapStream:ByteArray = myEncoder.encode(bitmap.bitmapData);
							_mpLoader.addFile(myCapStream, 'file.jpg', 'photo', 'image/jpeg');
							_mpLoader.load(response.upload_url);
						break;
						
						case 'wallSavePost':
							if (Util.wrapper.external) {
								Util.wrapper.external.saveWallPost(response.post_hash);
							}
						break;
					}
				}
				catch (e:Error) {
					if (Util.DEBUG) trace(e.message);
				}
			});
			_vkontakte.getFriends('first_name,sex,photo_big');
			
			visible = false;
			
			width = Constants.APP_WIDTH;
			height = Constants.APP_HEIGHT;
			
			var label:TextField = Util.createLabel('Оцени это фото!', 0, 72, Constants.APP_WIDTH);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 12, 0xffffff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.CENTER;
			addChild(label);
			
			var junkIcon:Bitmap = Util.multiLoader.get(Images.JUNK_ICON);
			junkIcon.x = 58;
			junkIcon.y = 73;
			addChild(junkIcon);
			
			_rateBar = new RatingBar(_scene, 10);
			_rateBar.x = 180;
			_rateBar.y = 98;
			_rateBar.setLayout(5, 13, 26, 21);
			_rateBar.bitmap = Util.multiLoader.get(Images.RATING_BACKGROUND);
			_rateBar.rateIconOff = Util.multiLoader.get(Images.RATING_OFF);
			_rateBar.rateIconOn = Util.multiLoader.get(Images.RATING_ON);
			_rateBar.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onRateClicked);
			
			addChild(_rateBar);
			
			var superIcon:Bitmap = Util.multiLoader.get(Images.SUPER_ICON);
			superIcon.x = 452;
			superIcon.y = 75;
			addChild(superIcon);
			
			initCurrentUserArea();
			initPreviousUserArea();
			initInviteArea();
			
			var filterBackgruond:Bitmap = BitmapUtil.cloneImageNamed(Images.FILTER_BACKGROUND);
			filterBackgruond.x = 452;
			filterBackgruond.y = 176;
			addChild(filterBackgruond);
			
			var filterLabelFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xf2c3ff);
			var filterLabel:TextField = Util.createLabel('Я ищу:', filterBackgruond.x + 18, filterBackgruond.y + 2);
			filterLabel.embedFonts = true;
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_sexBox = createComboBox(filterBackgruond.x + 20, filterBackgruond.y + 22, 113);
			_sexBox.addItem(Constants.SEX_FEMALE);
			_sexBox.addItem(Constants.SEX_MALE);
			_sexBox.addItem(Constants.SEX_BOTH);
			_sexBox.selectedItem = Constants.SEX_FEMALE;
			_sexBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			addChild(_sexBox);
			
			filterLabel = Util.createLabel('От:', filterBackgruond.x + 18, filterBackgruond.y + 51);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(filterBackgruond.x + 50, filterBackgruond.y + 54, 83, 15, 12);
			spr.graphics.endFill();
			addChild(spr);
			
			_minAgeBox = new TextField();
			_minAgeBox.selectable = true;
			_minAgeBox.x = filterBackgruond.x + 28;
			_minAgeBox.y = filterBackgruond.y + 54;
			_minAgeBox.maxChars = 3;
			_minAgeBox.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 11);
			_minAgeBox.type = TextFieldType.INPUT;
			_minAgeBox.autoSize = TextFieldAutoSize.RIGHT;
			_minAgeBox.embedFonts = true;
			_minAgeBox.antiAliasType = AntiAliasType.ADVANCED;
			_minAgeBox.restrict = '0-9';
			_minAgeBox.addEventListener(FocusEvent.FOCUS_OUT, onMinAgeFocusOut);
			_minAgeBox.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			addChild(_minAgeBox);
			
			filterLabel = Util.createLabel('До:', filterBackgruond.x + 18, filterBackgruond.y + 69);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			spr = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(filterBackgruond.x + 50, filterBackgruond.y + 72, 83, 15, 12);
			spr.graphics.endFill();
			addChild(spr);
			
			_maxAgeBox = new TextField();
			_maxAgeBox.selectable = true;
			_maxAgeBox.x = filterBackgruond.x + 28;
			_maxAgeBox.y = filterBackgruond.y + 72;
			_maxAgeBox.maxChars = 3;
			_maxAgeBox.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 11);
			_maxAgeBox.autoSize = TextFieldAutoSize.RIGHT;
			_maxAgeBox.type = TextFieldType.INPUT;
			_maxAgeBox.embedFonts = true;
			_maxAgeBox.antiAliasType = AntiAliasType.ADVANCED;
			_maxAgeBox.restrict = '0-9';
			_maxAgeBox.addEventListener(FocusEvent.FOCUS_OUT, onMaxAgeFocusOut);
			_maxAgeBox.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			addChild(_maxAgeBox);
			
			filterLabel = Util.createLabel('Страна:', filterBackgruond.x + 18, filterBackgruond.y + 92);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_countryBox = createComboBox(filterBackgruond.x + 20, filterBackgruond.y + 112, 113);
			_countryBox.setTextFormat(new TextFormat(Util.tahoma.fontName, 11), true, AntiAliasType.ADVANCED);
			_countryBox.horizontalAlign = View.ALIGN_HOR_RIGHT;
			_countryBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			addChild(_countryBox);
			
			filterLabel = Util.createLabel('Город:', filterBackgruond.x + 18, filterBackgruond.y + 132);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_cityBox = createComboBox(filterBackgruond.x + 20, filterBackgruond.y + 152, 113);
			_cityBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			addChild(_cityBox);
		}
		
		private function initCurrentUserArea():void {
			_currentUserArea = new Sprite();
			_currentUserArea.visible = false;
			addChild(_currentUserArea);
			
			_currentUserPhoto = new Photo(_scene, null, (Constants.APP_WIDTH - 234) / 2, 176, 234, 317);
			_currentUserPhoto.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			_currentUserArea.addChild(_currentUserPhoto);
			
			_currentUserMorePhotosButton = new LinkButton(_scene, '', 195, 150);
			_currentUserMorePhotosButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 12, 0x8bbe79, null, null, true), CONTROL_STATE_NORMAL);
			_currentUserMorePhotosButton.textField.embedFonts = true;
			_currentUserMorePhotosButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			_currentUserMorePhotosButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onOtherPhotosClick);
			_currentUserArea.addChild(_currentUserMorePhotosButton);
			
			_currentUserSetFavoriteButton = new LinkButton(_scene, '', 305, 150);
			_currentUserSetFavoriteButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 12, 0x63cdff, null, null, true), CONTROL_STATE_NORMAL);
			_currentUserSetFavoriteButton.textField.embedFonts = true;
			_currentUserSetFavoriteButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			_currentUserSetFavoriteButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFavoriteClick);
			_currentUserArea.addChild(_currentUserSetFavoriteButton);
			
			_currentUserName = new LinkButton(_scene, null, _currentUserPhoto.x, _currentUserPhoto.y + _currentUserPhoto.photoHeight + INDENT_BETWEEN_CURRENT_PHOTO_AND_NAME,
				TextFieldAutoSize.CENTER);
			_currentUserName.width = _currentUserPhoto.width;
			_currentUserName.height = CURRENT_USER_NAME_HEIGHT;
			_currentUserName.setTextFormatForState(new TextFormat(Util.opiumBold.fontName, 16, 0xffe6be, null, null, true), CONTROL_STATE_NORMAL);
			_currentUserName.textField.embedFonts = true;
			_currentUserName.textField.antiAliasType = AntiAliasType.ADVANCED;
			_currentUserName.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,
				function(event:GameObjectEvent):void {
					Util.gotoUserProfile(_currentUser.uid);
				}
			);
			_currentUserArea.addChild(_currentUserName);
			
			_currentUserPhotoComment = Util.createLabel(null, 180, _currentUserPhoto.y + _currentUserPhoto.photoHeight + INDENT_BETWEEN_CURRENT_PHOTO_AND_COMMENT,
				_currentUserPhoto.width, CURRENT_PHOTO_COMMENT_HEIGHT);
			_currentUserPhotoComment.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xa7b3b4));
			_currentUserPhotoComment.embedFonts = true;
			_currentUserPhotoComment.multiline = true;
			_currentUserPhotoComment.wordWrap = true;
			_currentUserArea.addChild(_currentUserPhotoComment);
		}
		
		private function initPreviousUserArea():void {
			_previousUserArea = new Sprite();
			_previousUserArea.visible = false;
			addChild(_previousUserArea);
			
			_previousUserPhoto = new Photo(_scene, null, 38, 176, 132, 176);
			_previousUserPhoto.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			_previousUserArea.addChild(_previousUserPhoto);
			
			_previousUserStarIcon = BitmapUtil.cloneImageNamed(Images.BIG_STAR);
			_previousUserStarIcon.y = _previousUserPhoto.y + _previousUserPhoto.height + 8;
			_previousUserStarIcon.x = 44;
			_previousUserArea.addChild(_previousUserStarIcon);
			
			_previousUserDelimiterIcon = BitmapUtil.cloneImageNamed(Images.LINE);
			_previousUserDelimiterIcon.x = 38;
			_previousUserDelimiterIcon.y = _previousUserPhoto.y + _previousUserPhoto.height + 68;;
			_previousUserArea.addChild(_previousUserDelimiterIcon);
			
			_previousUserPhotoRatingAverage = Util.createLabel('0', 38, _previousUserPhoto.y + _previousUserPhoto.height + 3, _previousUserDelimiterIcon.width);
			_previousUserPhotoRatingAverage.setTextFormat(new TextFormat(Util.tahoma.fontName, 30, 0xffffff));
			_previousUserPhotoRatingAverage.embedFonts = true;
			_previousUserPhotoRatingAverage.antiAliasType = AntiAliasType.ADVANCED;
			_previousUserPhotoRatingAverage.autoSize = TextFieldAutoSize.CENTER;
			_previousUserArea.addChild(_previousUserPhotoRatingAverage);
			
			
			_previousUserPhotoRatingAverageLabel = Util.createLabel('средний балл', 38, _previousUserPhoto.y + _previousUserPhoto.height + 43, _previousUserDelimiterIcon.width);
			_previousUserPhotoRatingAverageLabel.setTextFormat(new TextFormat(Util.opiumBold.fontName, 13, 0xd2dee0));
			_previousUserPhotoRatingAverageLabel.embedFonts = true;
			_previousUserPhotoRatingAverageLabel.antiAliasType = AntiAliasType.ADVANCED;
			_previousUserPhotoRatingAverageLabel.type = TextFieldType.DYNAMIC;
			_previousUserPhotoRatingAverageLabel.autoSize = TextFieldAutoSize.CENTER;
			_previousUserArea.addChild(_previousUserPhotoRatingAverageLabel);
			
			_previousUserPhotoVotesCountLabel = Util.createLabel('голосовало:', 38, _previousUserPhoto.y + _previousUserPhoto.height + 72, _previousUserDelimiterIcon.width);
			_previousUserPhotoVotesCountLabel.setTextFormat(new TextFormat(Util.opiumBold.fontName, 12, 0x86a4a8));
			_previousUserPhotoVotesCountLabel.embedFonts = true;
			_previousUserPhotoVotesCountLabel.autoSize = TextFieldAutoSize.CENTER;
			_previousUserPhotoVotesCountLabel.antiAliasType = AntiAliasType.ADVANCED;
			_previousUserArea.addChild(_previousUserPhotoVotesCountLabel);
			
			_previousUserPhotoVotesCount = Util.createLabel('0', 38, _previousUserPhoto.y + _previousUserPhoto.height + 90, _previousUserDelimiterIcon.width);
			_previousUserPhotoVotesCount.setTextFormat(new TextFormat(Util.tahoma.fontName, 20, 0xb0dee6));
			_previousUserPhotoVotesCount.embedFonts = true;
			_previousUserPhotoVotesCount.antiAliasType = AntiAliasType.ADVANCED;
			_previousUserPhotoVotesCount.autoSize = TextFieldAutoSize.CENTER;
			_previousUserArea.addChild(_previousUserPhotoVotesCount);
		}
		
		private function initInviteArea():void {
			_inviteArea = new Sprite();
			_inviteArea.visible = false;
			addChild(_inviteArea);
			
			var backgruond:Bitmap = BitmapUtil.cloneImageNamed(Images.INVITE_BACKGROUND);
			backgruond.x = 452;
			backgruond.y = 376;
			_inviteArea.addChild(backgruond);
			
			_inviteLabel = Util.createLabel('Федя еще не прошел Фейсконтроль?', 465, 380, 140, 60);
			_inviteLabel.setTextFormat(new TextFormat(Util.tahoma.fontName, 11, 0xd3d96c));
			_inviteLabel.embedFonts = true;
			_inviteLabel.antiAliasType = AntiAliasType.ADVANCED;
			_inviteLabel.wordWrap = true;
			_inviteArea.addChild(_inviteLabel);
			
			_invitePhoto = new Photo(_scene, null, 481, _inviteLabel.y + _inviteLabel.height + INDENT_BETWEEN_INVITE_LABEL_AND_PHOTO, 100, 100);
			_invitePhoto.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			_invitePhoto.verticalScale = Photo.VERTICAL_SCALE_ALWAYS;
			_inviteArea.addChild(_invitePhoto);
			
			_inviteButton = new Button(_scene, 469, _invitePhoto.y + _invitePhoto.photoHeight + INDENT_BETWEEN_INVITE_PHOTO_AND_BUTTON);
			_inviteButton.setTitleForState('пригласить', CONTROL_STATE_NORMAL);
			_inviteButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.MY_PHOTO_BUTTON_RED), CONTROL_STATE_NORMAL);
			_inviteButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			_inviteButton.textField.embedFonts = true;
			_inviteButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			_inviteButton.setTextPosition(30, 17);
			_inviteButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				if (_server && _photo && _hash) {
					_vkontakte.wallSavePost(_friend.uid, _server, _photo, _hash);
				}
				else {
					_vkontakte.getPhotoUploadServer();
				}
			});
			_inviteArea.addChild(_inviteButton);
		}
		
		public function randomizeFriend():void {
			if (_friends && _friends.length > 0) {
				_friend = _friends[Util.random(0, _friends.length)];
				showInviteArea();
			}
		}
		
		private function showInviteArea():void {
			if (_friend) {
				if (_friendPhotoLoader.hasLoaded(_friend.photo_big)) {
					_inviteLabel.defaultTextFormat = _inviteLabel.getTextFormat();
						switch (_friend.sex) {
							case '1':
								_inviteLabel.text = _friend.first_name + ' еще не прошла Фейсконтроль?\nПригласи ее и получи 5 монет.';
							break;
							
							case '2':
								_inviteLabel.text = _friend.first_name + ' еще не прошел Фейсконтроль?\nПригласи его и получи 5 монет.';
							break;
						}
						
					_invitePhoto.photo = _friendPhotoLoader.get(_friend.photo_big);
					_inviteButton.y = _invitePhoto.y + _invitePhoto.photoHeight + INDENT_BETWEEN_INVITE_PHOTO_AND_BUTTON;
					
					_inviteArea.visible = true;
				}
				else {
					_friendPhotoLoader.load(_friend.photo_big, _friend.photo_big, 'Bitmap');
				}
			}
			else {
				randomizeFriend();
			}
		}
		
		public function nextPhoto(obj:Object):void {
			_rateBar.rating = 0;
			
			if (!obj.hasOwnProperty('pid')) {
				if (_currentUser) {
					bigPhoto = null;
					
					if (_currentUser.votes_count) {
						if (_previousUser) {
							try {
								_multiloader.unload(_previousUser.pid);
							}
							catch (e:Error) {}
						}
						_previousUser = _currentUser;
						previousPhoto();
					}
				}
				
				_rateBar.enabled = false;
				_currentUser = null;
				_currentUserName.title = '';
				_currentUserPhotoComment.text = '';
				
				MessageDialog.dialog('Сообщение:', 'Ты проголосовал за всех пользователей. ' + 
						'Попробуй изменить фильтр "Я ищу" или пригласи больше друзей.');
			}
			else {
				if (_currentUser && _currentUser.pid != obj.pid) {
					if (_previousUser) _toUnload = _previousUser.pid;
					_previousUser = _currentUser;
				}
				
				if (!_currentUser || _currentUser.pid != obj.pid) {
					_multiloader.addEventListener(ErrorEvent.ERROR, multiloaderError);
					_multiloader.load(obj.src_big, obj.pid, 'Bitmap');
					_multiloader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderComplete);
					_currentUser = obj;
					return;
				}
				
				_currentUser = obj;
				_currentUserName.title = Util.fullName(_currentUser);
				
				_currentUserPhotoComment.defaultTextFormat = _currentUserPhotoComment.getTextFormat();
				_currentUserPhotoComment.text = _currentUser.comment ? _currentUser.comment : '';
				_currentUserPhotoComment.visible = true;
				
				_rateBar.enabled = true;
				_currentUserSetFavoriteButton.title = (_currentUser.favorite) ? 'Удалить из избранных' : 'Добавить в избранные';
			}
			PreloaderSplash.instance.resetModal();
		}
		
		public function get currentUser(): Object {
			return _currentUser;
		}
		
		public function vote(obj:Object):void {
			PreloaderSplash.instance.showModal();
			_currentUser.rating_average = obj.rating_average;
			_currentUser.votes_count = obj.votes_count;
			Util.api.nextPhoto(Util.viewer_id);
		}
		
		private function multiloaderError(event:ErrorEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.nextPhoto(Util.viewer_id);
		}
		
		private function multiLoaderComplete(event:MultiLoaderEvent):void {
			if (_multiloader.hasLoaded(_currentUser.pid)) {
				bigPhoto = _multiloader.get(_currentUser.pid);
				nextPhoto(_currentUser);
				previousPhoto();
				
				try {
					if (_toUnload) _multiloader.unload(_toUnload);
					_toUnload = null;
				}
				catch (e:Error) {}
				
				_multiloader.removeEventListener(ErrorEvent.ERROR, multiloaderError);
				_multiloader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderComplete);
			}
		}
		
		private function previousPhoto():void {
			_previousUserArea.visible = _previousUser && _previousUser.votes_count;
			if (_previousUserArea.visible) {
				smallPhoto = _multiloader.get(_previousUser.pid);
				
				_previousUserPhotoRatingAverage.defaultTextFormat = _previousUserPhotoRatingAverage.getTextFormat();
				_previousUserPhotoRatingAverage.text = _previousUser.rating_average ? _previousUser.rating_average : '';
				
				_previousUserPhotoVotesCount.defaultTextFormat = _previousUserPhotoVotesCount.getTextFormat();
				_previousUserPhotoVotesCount.text = _previousUser.votes_count ? _previousUser.votes_count : '';
			}
		}
		
		public override function refresh():void {
			Util.api.mainPhoto(_currentUser.uid);
		}
		
		public function updateFilter():void {
			_sexBox.removeEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			_countryBox.removeEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			_cityBox.removeEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			
			switch (_filter.sex) {
				case '1':
					_sexBox.selectedItem = Constants.SEX_FEMALE;
				break;
				case '2':
					_sexBox.selectedItem = Constants.SEX_MALE;
				break;
				default:
					_sexBox.selectedItem = Constants.SEX_BOTH;
				break;
			}
			
			if (_filter.age_min) {
				var format:TextFormat = _minAgeBox.getTextFormat();
				_minAgeBox.text = (_filter.age_min == 60) ? '60+' : _filter.age_min;
				_minAgeBox.setTextFormat(format);
			}
			
			if (_filter.age_max) {
				format = _maxAgeBox.getTextFormat();
				_maxAgeBox.text = (_filter.age_max == 60) ? '60+' : _filter.age_max;
				_maxAgeBox.setTextFormat(format);
			}
			
			_countryBox.clear();
			if (Util.user.country_name) {
				_countryBox.addItem(Util.user.country_name);
			}
			_countryBox.addItem(COUNTRY_DEFAULT);
			_countryBox.selectedItem = (_filter.country) ? _filter.country : COUNTRY_DEFAULT;
			
			_cityBox.clear();
			if (Util.user.city_name) {
				_cityBox.addItem(Util.user.city_name);
			}
			_cityBox.addItem(CITY_DEFAULT);
			_cityBox.selectedItem = (_filter.city) ? _filter.city : CITY_DEFAULT;
			
			_sexBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			_countryBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			_cityBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
		}
		
		private function createComboBox(x:int, y:int, width:int):ComboBox {
			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(0, 0, width, 15, 12);
			spr.graphics.endFill();
			
			var sprD: Sprite = new Sprite();
			sprD.graphics.beginFill(0xffffff);
			sprD.graphics.drawRect(0, 0, width, 15);
			sprD.graphics.endFill();
			var sprDmask: Sprite = new Sprite();
			sprDmask.graphics.beginFill(0xffffff);
			sprDmask.graphics.drawRoundRect(0, 0, width, 30, 12);
			sprDmask.graphics.endFill();
			sprD.mask = sprDmask;
			
			var bd: BitmapData = new BitmapData(width, 15, true, undefined);
			bd.draw(spr);
			
			var bdDropped: BitmapData = new BitmapData(width, 15, true, undefined);
			bdDropped.draw(sprD);
			
			var box:ComboBox = new ComboBox(_scene);
			box.setDropListHoverColor(0xd0d0d0, 1, 0xababab, 1);
			box.bitmap = new Bitmap(bd);
			box.bitmapDropped = new Bitmap(bdDropped);
			box.dropIcon = new Bitmap(BitmapUtil.cloneImageNamed(Images.CHOOSE_BUTTON).bitmapData);
			box.setTextFormat(new TextFormat(Util.tahoma.fontName, 11), true, AntiAliasType.ADVANCED);
			box.horizontalAlign = View.ALIGN_HOR_RIGHT;
			box.x = x;
			box.y = y;
			box.width = width;
			box.height = 15;
			return box;
		}
		
		public override function destroy():void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
			super.destroy();
		}
		
		public function get bigPhoto():Bitmap {
			return _currentUserPhoto.photo;
		}
		
		public function set bigPhoto(image:Bitmap):void {
			if (image) {
				_currentUserPhoto.frameIndex = _currentUser.frame;
				_currentUserPhoto.photo = image;
				_currentUserMorePhotosButton.title = Util.getMorePhotoString(_currentUser.sex);
				_currentUserSetFavoriteButton.title = (_currentUser.favorite) ? 'Удалить из избранных' :
					 'Добавить в избранные';
				_currentUserName.y = _currentUserPhoto.y + _currentUserPhoto.photoHeight + INDENT_BETWEEN_CURRENT_PHOTO_AND_NAME;
				_currentUserPhotoComment.y = _currentUserPhoto.y + _currentUserPhoto.photoHeight + INDENT_BETWEEN_CURRENT_PHOTO_AND_COMMENT;
				
				_currentUserArea.visible = true;
				
				randomizeFriend();
			} else {
				_currentUserArea.visible = false;
				_currentUserPhoto.photo = null;
			}
		}
		
		public function set smallPhoto(image:Bitmap):void {
			if (image) {
				_previousUserPhoto.photo = image;
				_previousUserPhoto.frameIndex = _previousUser.frame;
				var photoBottomY:int = _previousUserPhoto.y + _previousUserPhoto.photoHeight;
				_previousUserStarIcon.y = photoBottomY + INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_STAR_ICON;
				_previousUserDelimiterIcon.y = photoBottomY + INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_DELIMITER_ICON;
				_previousUserPhotoRatingAverage.y = photoBottomY + INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_RATING_AVERAGE;
				_previousUserPhotoRatingAverageLabel.y = photoBottomY + INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_RATING_AVERAGE_LABEL;
				_previousUserPhotoVotesCountLabel.y = photoBottomY + INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_VOTES_COUNT_LABEL;
				_previousUserPhotoVotesCount.y = photoBottomY + INDENT_BETWEEN_PREVIOUS_USER_PHOTO_AND_VOTES_COUNT;
			}
		}
		
		public function set filter(obj:Object):void {
			_filter = obj;
			updateFilter();
		}
		
		public function onRateClicked(event:GameObjectEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.vote(_currentUser.pid, _rateBar.rating);
		}
		
		public function onFilterChanged(event:ComboBoxEvent):void {
			saveFilters();
		}
		
		public function onTextInput(event:TextEvent):void {
			if (event.target.length + event.text.length > 2) {
				event.preventDefault();
			}
		}
		
		public function onMinAgeFocusOut(event:FocusEvent):void {
			var format:TextFormat = _minAgeBox.getTextFormat();
			if (_minAgeBox.length > 0) {
				if (_minAgeBox.text != '60+') {
					var age:int = int(_minAgeBox.text);
					if (age < 8) _minAgeBox.text = '8';
					else if (age >= 60) _minAgeBox.text = '60+';
				}
			}
			else _minAgeBox.text = '8';
			_minAgeBox.setTextFormat(format);
			
			var ageMin:int = _minAgeBox.text == '60+' ? 60 : int(_minAgeBox.text);
			var ageMax:int = _maxAgeBox.text == '60+' ? 60 : int(_maxAgeBox.text);
			
			if (ageMax < ageMin) {
				format  = _maxAgeBox.getTextFormat();
				_maxAgeBox.text = _minAgeBox.text;
				_maxAgeBox.setTextFormat(format);
			}
			
			saveFilters();
		}
		
		public function onMaxAgeFocusOut(event:FocusEvent):void {
			var format:TextFormat = _maxAgeBox.getTextFormat();
			if (_maxAgeBox.length > 0) {
				if (_maxAgeBox.text != '60+') {
					var age:int = int(_maxAgeBox.text);
					if (age < 8) _maxAgeBox.text = '8';
					else if (age >= 60) _maxAgeBox.text = '60+';
				}
			}
			else _maxAgeBox.text = '8';
			_maxAgeBox.setTextFormat(format);
			
			var ageMin:int = _minAgeBox.text == '60+' ? 60 : int(_minAgeBox.text);
			var ageMax:int = _maxAgeBox.text == '60+' ? 60 : int(_maxAgeBox.text);
			
			if (ageMin > ageMax) {
				format  = _minAgeBox.getTextFormat();
				_minAgeBox.text = _maxAgeBox.text;
				_minAgeBox.setTextFormat(format);
			}
			saveFilters();
		}
		
		private function saveFilters():void {
			var sex:int = _sexBox.selectedIndex + 1;
			var ageMin:int = _minAgeBox.text == '60+' ? 60 : int(_minAgeBox.text);
			var ageMax:int = _maxAgeBox.text == '60+' ? 60 : int(_maxAgeBox.text);
			var city:String = null;
			var country:String = null;
			
			if (_cityBox.selectedItem != CITY_DEFAULT) {
				city = Util.user.city;
			}
			
			if (_countryBox.selectedItem != COUNTRY_DEFAULT) {
				country = Util.user.country;
			}
			
			PreloaderSplash.instance.showModal();
			Util.api.saveSettings(Util.viewer_id, sex, ageMin, ageMax, city, country);
		}
		
		public function onOtherPhotosClick(event: GameObjectEvent): void {
			PreloaderSplash.instance.showModal();
			AllUserPhotoForm.instance.returnForm = this;
			AllUserPhotoForm.instance.user = _currentUser;
			AllUserPhotoForm.instance.show();
		}
		
		public function onFavoriteClick(event: GameObjectEvent):void {
			PreloaderSplash.instance.showModal();
			if (_currentUser.favorite) {
				Util.api.deleteFavorite(Util.viewer_id, _currentUser.uid);
			}
			else {
				Util.api.addFavorite(Util.viewer_id, _currentUser.uid);
			}
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is MainForm);
					}
				}
			}
		}
	}
}