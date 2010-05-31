package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
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
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	
	public class MainForm extends Form
	{
		private static const _commentTextFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xa7b3b4);
		private static const _nameTextFormat:TextFormat = new TextFormat(Util.opiumBold.fontName, 16, 0xffe6be);
		
		private static const COUNTRY_DEFAULT:String = 'Весь мир';
		private static const CITY_DEFAULT:String = 'Вся страна';
		
		private static var _instance:MainForm = null;
		public static function get instance():MainForm {
			if (!_instance) _instance = new MainForm(Util.scene);
			return _instance;
		}
		
		protected var _bigPhoto:Photo;
		protected var _smallPhoto:Photo;
		protected var _ratingAverageField:TextField;
		protected var _votesCountField:TextField;
		protected var _nameField:TextField;
		protected var _commentField:TextField;
		protected var _rateBar:RatingBar;
		private var _goto:Button;
		
		protected var _sexBox:ComboBox;
		protected var _minAgeBox:TextField;
		protected var _maxAgeBox:TextField;
		protected var _countryBox:ComboBox;
		protected var _cityBox:ComboBox;
		
		private var _filter:Object;
		private var _current:Object;
		private var _previous:Object;
		
		private var _previousLayer:Sprite;
		
		private var bigStar:Bitmap;
		private var line:Bitmap;
		private var ratingLabel:TextField;
		private var votesLabel:TextField;
		
		private var _morePhotos:LinkButton;
		private var _favorite:LinkButton;
		
		private var _multiloader:MultiLoader;
		
		public function MainForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			_multiloader = new MultiLoader();
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
			
			_morePhotos = new LinkButton(value, '', 195, 150);
			_morePhotos.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 12, 0x8bbe79, null, null, true), CONTROL_STATE_NORMAL);
			_morePhotos.textField.embedFonts = true;
			_morePhotos.textField.antiAliasType = AntiAliasType.ADVANCED;
			_morePhotos.visible = false;
			_morePhotos.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onOtherPhotosClick);
			addChild(_morePhotos);
			
			_favorite = new LinkButton(value, '', 305, 150);
			_favorite.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 12, 0x63cdff, null, null, true), CONTROL_STATE_NORMAL);
			_favorite.textField.embedFonts = true;
			_favorite.textField.antiAliasType = AntiAliasType.ADVANCED;
			_favorite.visible = false;
			_favorite.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onFavoriteClick);
			addChild(_favorite);
			
			_bigPhoto = new Photo(_scene, null, (Constants.APP_WIDTH - 234) / 2, 176, 234, 317);
			_bigPhoto.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			addChild(_bigPhoto);
			
			_previousLayer = new Sprite();
			_previousLayer.visible = false;
			addChild(_previousLayer);
			
			_smallPhoto = new Photo(_scene, null, 38, 176, 132, 176);
			_smallPhoto.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			_previousLayer.addChild(_smallPhoto);
			
			bigStar = BitmapUtil.cloneImageNamed(Images.BIG_STAR);
			bigStar.y = _smallPhoto.y + _smallPhoto.height + 8;
			bigStar.x = 44;
			_previousLayer.addChild(bigStar);
			
			line = Util.multiLoader.get(Images.LINE);
			line.x = 38;
			line.y = _smallPhoto.y + _smallPhoto.height + 68;;
			_previousLayer.addChild(line);
			
			_ratingAverageField = Util.createLabel('0', 38, _smallPhoto.y + _smallPhoto.height + 3, line.width);
			_ratingAverageField.setTextFormat(new TextFormat(Util.tahoma.fontName, 30, 0xffffff));
			_ratingAverageField.embedFonts = true;
			_ratingAverageField.antiAliasType = AntiAliasType.ADVANCED;
			_ratingAverageField.autoSize = TextFieldAutoSize.CENTER;
			_previousLayer.addChild(_ratingAverageField);
			
			
			ratingLabel = Util.createLabel('средний балл', 38, _smallPhoto.y + _smallPhoto.height + 43, line.width);
			ratingLabel.setTextFormat(new TextFormat(Util.opiumBold.fontName, 13, 0xd2dee0));
			ratingLabel.embedFonts = true;
			ratingLabel.antiAliasType = AntiAliasType.ADVANCED;
			ratingLabel.type = TextFieldType.DYNAMIC;
			ratingLabel.autoSize = TextFieldAutoSize.CENTER;
			_previousLayer.addChild(ratingLabel);
			
			votesLabel = Util.createLabel('голосовало:', 38, _smallPhoto.y + _smallPhoto.height + 72, line.width);
			votesLabel.setTextFormat(new TextFormat(Util.opiumBold.fontName, 12, 0x86a4a8));
			votesLabel.embedFonts = true;
			votesLabel.autoSize = TextFieldAutoSize.CENTER;
			votesLabel.antiAliasType = AntiAliasType.ADVANCED;
			_previousLayer.addChild(votesLabel);
			
			_votesCountField = Util.createLabel('0', 38, _smallPhoto.y + _smallPhoto.height + 90, line.width);
			_votesCountField.setTextFormat(new TextFormat(Util.tahoma.fontName, 20, 0xb0dee6));
			_votesCountField.embedFonts = true;
			_votesCountField.antiAliasType = AntiAliasType.ADVANCED;
			_votesCountField.autoSize = TextFieldAutoSize.CENTER;
			_previousLayer.addChild(_votesCountField);
			
			var filterBackgruond:Bitmap = Util.multiLoader.get(Images.FILTER_BACKGROUND);
			filterBackgruond.x = 452;
			filterBackgruond.y = 313;
			addChild(filterBackgruond);
			
			var filterLabelFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xf2c3ff);
			
			var filterLabel:TextField = Util.createLabel('Я ищу:', 470, 315);
			filterLabel.embedFonts = true;
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_sexBox = createComboBox(472, 335, 113);
			_sexBox.addItem(Constants.SEX_FEMALE);
			_sexBox.addItem(Constants.SEX_MALE);
			_sexBox.addItem(Constants.SEX_BOTH);
			_sexBox.selectedItem = Constants.SEX_FEMALE;
			_sexBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			addChild(_sexBox);
			
			filterLabel = Util.createLabel('От:', 470, 364);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(502, 367, 83, 15, 12);
			spr.graphics.endFill();
			addChild(spr);
			
			_minAgeBox = new TextField();
			_minAgeBox.selectable = true;
			_minAgeBox.x = 480;
			_minAgeBox.y = 367;
			_minAgeBox.maxChars = 3;
			_minAgeBox.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 11);
			_minAgeBox.autoSize = TextFieldAutoSize.RIGHT;
			_minAgeBox.type = TextFieldType.INPUT;
			_minAgeBox.embedFonts = true;
			_minAgeBox.antiAliasType = AntiAliasType.ADVANCED;
			_minAgeBox.restrict = '0-9';
			_minAgeBox.addEventListener(FocusEvent.FOCUS_OUT, onMinAgeFocusOut);
			_minAgeBox.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			addChild(_minAgeBox);
			
			filterLabel = Util.createLabel('До:', 470, 382);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			spr = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(502, 385, 83, 15, 12);
			spr.graphics.endFill();
			addChild(spr);
			
			_maxAgeBox = new TextField();
			_maxAgeBox.selectable = true;
			_maxAgeBox.x = 479;
			_maxAgeBox.y = 385;
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
			
			filterLabel = Util.createLabel('Страна:', 470, 405);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_countryBox = createComboBox(472, 425, 113);
			_countryBox.setTextFormat(new TextFormat(Util.tahoma.fontName, 11), true, AntiAliasType.ADVANCED);
			_countryBox.horizontalAlign = View.ALIGN_HOR_RIGHT;
			_countryBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			addChild(_countryBox);
			
			filterLabel = Util.createLabel('Город:', 470, 445);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_cityBox = createComboBox(472, 465, 113);
			_cityBox.addEventListener(ComboBoxEvent.ITEM_SELECT, onFilterChanged);
			addChild(_cityBox);
			
			_nameField = Util.createLabel(
				null,
				_bigPhoto.x,
				_bigPhoto.y + _bigPhoto.photoHeight + 4,
				_bigPhoto.width);
			_nameField.setTextFormat(_nameTextFormat);
			_nameField.embedFonts = true;
			_nameField.autoSize = TextFieldAutoSize.CENTER;
			addChild(_nameField);
			
			var commentY:int = _nameField.y + 28;
			_commentField = Util.createLabel(
				null,
				commentY < 495 ? _bigPhoto.x : 180,
				commentY,
				commentY < 495 ? _bigPhoto.width : 300,
				100);
			_commentField.setTextFormat(_commentTextFormat);
			_commentField.embedFonts = true;
			_commentField.multiline = true;
			_commentField.wordWrap = true;
			addChild(_commentField);
			
			var gotoProfileBitmap:Bitmap = BitmapUtil.cloneImageNamed(Images.VK_ICON);
			_goto = new Button(
				_scene,
				_bigPhoto.x + _bigPhoto.photoWidth - gotoProfileBitmap.width - 10,
				_bigPhoto.y + 10
			);
			_goto.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.VK_ICON), CONTROL_STATE_NORMAL);
			_goto.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK,
				function(event:GameObjectEvent):void {
					Util.gotoUserProfile(currentUser.uid);
				}
			);
			addChild(_goto);
		}
		
		public function nextPhoto(obj:Object):void {
			_rateBar.rating = 0;
			
			if (!obj.hasOwnProperty('pid')) {
				if (_current) {
					bigPhoto = null;
					
					if (_current.votes_count) {
						if (_previous) {
							try {
								_multiloader.unload(_previous.pid);
							}
							catch (e:Error) {}
						}
						_previous = _current;
						previousPhoto();
					}
				}
				
				_current = null;
				_rateBar.enabled = false;
				
				_nameField.text = '';
				_nameField.setTextFormat(_nameTextFormat);
				
				_commentField.text = '';
				_commentField.setTextFormat(_commentTextFormat);
				
				_scene.showModal(new MessageDialog(_scene, 'Сообщение:', 'Ты проголосовал за всех пользователей. Попробуй изменить фильтр "Я ищу" или пригласи больше друзей.'));
			}
			else {
				if (_current && _current.pid != obj.pid) {
					if (_previous) {
						try {
//							Util.multiLoader.unload(_previous.pid);
							_multiloader.unload(_previous.pid);
						}
						catch (e:Error) {}
					}
					_previous = _current;
				}
				
				if (!_current || _current.pid != obj.pid) {
					_multiloader.addEventListener(ErrorEvent.ERROR, multiloaderError);
					_multiloader.load(obj.src_big, obj.pid, 'Bitmap');
					_multiloader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderComplete);
				}
				
				_current = obj;
				_nameField.text = Util.fullName(_current);
				_nameField.setTextFormat(_nameTextFormat);
				
				if (_commentField) {
					if (_current.comment) {
						_commentField.text = _current.comment ? _current.comment : '';
						_commentField.setTextFormat(_commentTextFormat);
						_commentField.visible = true;
					}
					else {
						_commentField.visible = false;
					}
				}
				
				_rateBar.enabled = true;
				if (_current) _favorite.label = (_current.favorite) ? 'Удалить из избранных' : 'Добавить в избранные';
			}
		}
		
		public function get currentUser(): Object {
			return _current;
		}
		
		public function vote(obj:Object):void {
			_current.rating_average = obj.rating_average;
			_current.votes_count = obj.votes_count;
			Util.api.nextPhoto(Util.viewer_id);
		}
		
		private function multiloaderError(event:ErrorEvent):void {
			PreloaderSplash.instance.showModal();
			Util.api.nextPhoto(Util.viewer_id);
		}
		
		private function multiLoaderComplete(event:MultiLoaderEvent):void {
			if (_multiloader.hasLoaded(_current.pid)) {
				bigPhoto = _multiloader.get(_current.pid);
				previousPhoto();
			}
			
			_multiloader.removeEventListener(ErrorEvent.ERROR, multiloaderError);
			_multiloader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderComplete);
		}
		
		private function previousPhoto():void {
			_previousLayer.visible = _previous && _previous.votes_count;
			if (_previousLayer.visible) {
				smallPhoto = _multiloader.get(_previous.pid);
				
				_ratingAverageField.defaultTextFormat = _ratingAverageField.getTextFormat();
				_ratingAverageField.text = _previous.rating_average ? _previous.rating_average : '';
				
				_votesCountField.defaultTextFormat = _votesCountField.getTextFormat();
				_votesCountField.text = _previous.votes_count ? _previous.votes_count : '';
			}
		}
		
		public override function refresh():void {
			Util.api.mainPhoto(_current.uid);
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
			return _bigPhoto.photo;
		}
		
		public function set bigPhoto(image:Bitmap):void {
			if (image) {
				_bigPhoto.photo = image;
				
				var gotoProfileBitmap:Bitmap = _goto.backgroundImageForState(CONTROL_STATE_NORMAL);
				_goto.visible = true;
				_goto.x = _bigPhoto.x + _bigPhoto.photoWidth - gotoProfileBitmap.width - 10;
				_goto.y = _bigPhoto.y + 6;
				
				_morePhotos.visible = true;
				_morePhotos.label = Util.getMorePhotoString(_current.sex);
				
				_favorite.visible = true;
				_favorite.label = (_current.favorite) ? 'Удалить из избранных' : 'Добавить в избранные';
				
				if (_nameField) {
					_nameField.y = _bigPhoto.y + _bigPhoto.photoHeight + 4;
				}
				
				if (_commentField) {
					_commentField.y = _nameField.y + 28;
					_commentField.x = _commentField.y < 495 ? _bigPhoto.x : 180;
					_commentField.width = _commentField.y < 495 ? _bigPhoto.width : 300;
				}
			} else {
				_bigPhoto.photo = null;
				_morePhotos.visible = false;
				_favorite.visible = false;
				_goto.visible = false;
			}
		}
		
		public function set smallPhoto(image:Bitmap):void {
			if (image) {
				_smallPhoto.photo = image;
				
				bigStar.y = _smallPhoto.y + _smallPhoto.photoHeight + 8;
				line.y = _smallPhoto.y + _smallPhoto.photoHeight + 68;;
				_ratingAverageField.y = _smallPhoto.y + _smallPhoto.photoHeight + 3;
				ratingLabel.y = _smallPhoto.y + _smallPhoto.photoHeight + 43;
				votesLabel.y = _smallPhoto.y + _smallPhoto.photoHeight + 72;
				_votesCountField.y = _smallPhoto.y + _smallPhoto.photoHeight + 90;
			}
		}
		
		public function set filter(obj:Object):void {
			_filter = obj;
			updateFilter();
		}
		
		public function onRateClicked(event:GameObjectEvent):void {
			Util.api.vote(Util.viewer_id, _current.pid, _rateBar.rating);
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
			if (!PreloaderSplash.instance.isModal) {
				scene.showModal(PreloaderSplash.instance);
			}
			Util.api.saveSettings(Util.viewer_id, sex, ageMin, ageMax, city, country);
		}
		
		public function onOtherPhotosClick(event: GameObjectEvent): void {
			AllUserPhotoForm.instance.returnForm = this;
			AllUserPhotoForm.instance.user = _current;
			AllUserPhotoForm.instance.show();
			if (!PreloaderSplash.instance.isModal) {
				scene.showModal(PreloaderSplash.instance);
			}
		}
		
		public function onFavoriteClick(event: GameObjectEvent):void {
			if (!PreloaderSplash.instance.isModal) {
				scene.showModal(PreloaderSplash.instance);
			}
			if (_current.favorite) {
				Util.api.deleteFavorite(Util.viewer_id, _current.uid);
			}
			else {
				Util.api.addFavorite(Util.viewer_id, _current.uid);
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