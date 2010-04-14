package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.GridBoxEvent;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.RatingBar;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	
	public class MainForm extends GameLayer
	{
		private static const _commentTextFormat:TextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xa7b3b4);
		private static const _nameTextFormat:TextFormat = new TextFormat(Util.opiumBold.fontName, 16, 0xffe6be);
		
		public var _userProfileBtn: GameObject;
		public var _mainPhoto: GameObject;
		
		protected var _bigPhoto:Photo;
		protected var _smallPhoto:Photo;
		protected var _ratingAverageField:TextField;
		protected var _votesCountField:TextField;
		protected var _nameField:TextField;
		protected var _commentField:TextField;
		protected var _rateBar:RatingBar;
		
		protected var _sexBox:ComboBox;
		protected var _minAgeBox:ComboBox;
		protected var _maxAgeBox:ComboBox;
		protected var _countryBox:ComboBox;
		protected var _cityBox:ComboBox;
		
		private var _filter:Object;
		private var _current:Object;
		private var _previous:Object;
		
		private var _previousLayer:Sprite;
		
		public function MainForm(value:GameScene)
		{
			super(value);
			
			visible = false;
			
			width = Constants.APP_WIDTH;
			height = Constants.APP_HEIGHT;
			
			var label:TextField = createLabel("Оцени это фото!", 0, 72, Constants.APP_WIDTH);
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
			_rateBar.buttonMode = true;
			_rateBar.useHandCursor = true;
			
			_rateBar.addEventListener(MouseEvent.CLICK, onRateClicked);
			
			addChild(_rateBar);
			
			var superIcon:Bitmap = Util.multiLoader.get(Images.SUPER_ICON);
			superIcon.x = 452;
			superIcon.y = 75;
			addChild(superIcon);
			
			var otherPhotos:LinkButton = new LinkButton(value, "Еще фото", 195, 150);
			otherPhotos.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 12, 0x8bbe79, null, null, true), LinkButton.STATE_NORMAL);
			otherPhotos.textField.embedFonts = true;
			otherPhotos.textField.antiAliasType = AntiAliasType.ADVANCED;
			addChild(otherPhotos);
			
			_bigPhoto = new Photo(_scene, null, (Constants.APP_WIDTH - 234) / 2, 176, 234, 317);
			addChild(_bigPhoto);
			
			_previousLayer = new Sprite();
			_previousLayer.visible = false;
			addChild(_previousLayer);
			
			_smallPhoto = new Photo(_scene, null, 38, 176, 132, 176);
			_previousLayer.addChild(_smallPhoto);
			
			
			var bigStar:Bitmap = BitmapUtil.clone(Util.multiLoader.get(Images.BIG_STAR));
			bigStar.y = _smallPhoto.y + _smallPhoto.height + 8;;
			bigStar.x = 44;
			_previousLayer.addChild(bigStar);
			
			var line:Bitmap = Util.multiLoader.get(Images.LINE);
			line.x = 38;
			line.y = _smallPhoto.y + _smallPhoto.height + 68;;
			_previousLayer.addChild(line);
			
			_ratingAverageField = createLabel("0", 38, _smallPhoto.y + _smallPhoto.height + 3, line.width);
			_ratingAverageField.setTextFormat(new TextFormat(Util.tahoma.fontName, 30, 0xffffff));
			_ratingAverageField.embedFonts = true;
			_ratingAverageField.antiAliasType = AntiAliasType.ADVANCED;
			_ratingAverageField.autoSize = TextFieldAutoSize.CENTER;
			_previousLayer.addChild(_ratingAverageField);
			
			
			var ratingLabel:TextField = createLabel("средний балл", 38, _smallPhoto.y + _smallPhoto.height + 43, line.width);
			ratingLabel.setTextFormat(new TextFormat(Util.opiumBold.fontName, 13, 0xd2dee0));
			ratingLabel.embedFonts = true;
			ratingLabel.antiAliasType = AntiAliasType.ADVANCED;
			ratingLabel.type = TextFieldType.DYNAMIC;
			ratingLabel.autoSize = TextFieldAutoSize.CENTER;
			_previousLayer.addChild(ratingLabel);
			
			var votesLabel:TextField = createLabel("голосовало:", 38, _smallPhoto.y + _smallPhoto.height + 72, line.width);
			votesLabel.setTextFormat(new TextFormat(Util.opiumBold.fontName, 12, 0x86a4a8));
			votesLabel.embedFonts = true;
			votesLabel.autoSize = TextFieldAutoSize.CENTER;
			votesLabel.antiAliasType = AntiAliasType.ADVANCED;
			_previousLayer.addChild(votesLabel);
			
			_votesCountField = createLabel("10345", 38, _smallPhoto.y + _smallPhoto.height + 90, line.width);
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
			
			var filterLabel:TextField = createLabel("Я ищу:", 470, 315);
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
			addChild(_sexBox);
			/*
			filterLabel = createLabel("От:", 470, 364);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_minAgeBox = createComboBox(502, 367, 84);
			for (var i:int = 8; i < 60; ++i) {
				_minAgeBox.addItem(""+i);
			}
			_minAgeBox.addItem("60+");
			_minAgeBox.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, onMinAgeChanged);
			addChild(_minAgeBox);
			
			filterLabel = createLabel("До:", 470, 382);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_maxAgeBox = createComboBox(502, 385, 84);
			for (i = 8; i < 60; ++i) {
				_maxAgeBox.addItem(""+i);
			}
			_maxAgeBox.addItem("60+");
			_minAgeBox.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, onMaxAgeChanged);
			addChild(_maxAgeBox);
			
			filterLabel = createLabel("Страна:", 470, 405);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_countryBox = createComboBox(472, 425, 113);
			_countryBox.setTextFormat(new TextFormat(Util.tahoma.fontName, 11), true, AntiAliasType.ADVANCED);
			_countryBox.horizontalAlign = View.ALIGN_HOR_RIGHT;
			_countryBox.addItem('Россия');
			_countryBox.addItem('Германия');
			_countryBox.addItem('США');
			_countryBox.selectedItem = 'Россия';
			addChild(_countryBox);
			
			filterLabel = createLabel("Город:", 470, 445);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.antiAliasType = AntiAliasType.ADVANCED;
			filterLabel.embedFonts = true;
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_cityBox = createComboBox(472, 465, 113);
			_cityBox.addItem('Пенза');
			_cityBox.addItem('Москва');
			_cityBox.addItem('Рязань');
			_cityBox.selectedItem = 'Пенза';
			addChild(_cityBox);
			*/
			_nameField = createLabel(
				null,
				_bigPhoto.x,
				_bigPhoto.y + ((_bigPhoto.bitmap) ? _bigPhoto.bitmap.height : _bigPhoto.height) + 4,
				_bigPhoto.width);
			_nameField.setTextFormat(_nameTextFormat);
			_nameField.embedFonts = true;
			_nameField.autoSize = TextFieldAutoSize.CENTER;
			addChild(_nameField);
			
			var commentY:int = _nameField.y + 28;
			_commentField = createLabel(
				null,
				commentY < 495 ? _bigPhoto.x : 180,
				commentY,
				commentY < 495 ? _bigPhoto.width : 300);
			
			_commentField.setTextFormat(_commentTextFormat);
			_commentField.multiline = true;
			_commentField.wordWrap = true;
			addChild(_commentField);
		}
		
		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (value) {
				Util.api.nextPhoto(Util.userId);
			}
		}
		
		public function nextPhoto(obj:Object):void {
			_rateBar.rating = 0;
			
			if (_current && _current.pid != obj.pid) {
				if (_previous) {
					Util.multiLoader.unload(_previous.pid);
				}
				_previous = _current;
			}
			
			if (!_current || _current.pid != obj.pid) {
				_current = obj;
				Util.multiLoader.load(_current.src_big, _current.pid, "Bitmap");
				Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
			}
		}
		
		public function vote(obj:Object):void {
			_current.rating_average = obj.rating_average;
			_current.votes_count = obj.votes_count;
			Util.api.nextPhoto(Util.userId);
		}
		
		private function multiLoaderProgressListener(event:MultiLoaderEvent):void {
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.hasLoaded(_current.pid)) {
				bigPhoto = Util.multiLoader.get(_current.pid);
				
				_nameField.text = _current.fname;
				_nameField.setTextFormat(_nameTextFormat);
				
				if (_current.comment) {
					_commentField.text = _current.comment;
					_commentField.setTextFormat(_commentTextFormat);
				}
				
				_previousLayer.visible = _previous && _previous.votes_count;
				if (_previousLayer.visible) {
					smallPhoto = Util.multiLoader.get(_previous.pid);
					
					var format:TextFormat = _ratingAverageField.getTextFormat();
					_ratingAverageField.text = _previous.rating_average;
					_ratingAverageField.setTextFormat(format);
					
					format = _votesCountField.getTextFormat();
					_votesCountField.text = _previous.votes_count;
					_votesCountField.setTextFormat(format);
				}
				
				updateFilter();
			}
			
			Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
		}
		
		public function updateFilter():void {
			switch (_filter.sex) {
				case 1:
					_sexBox.selectedItem = Constants.SEX_FEMALE;
				break;
				case 2:
					_sexBox.selectedItem = Constants.SEX_MALE;
				break;
				default:
					_sexBox.selectedItem = Constants.SEX_BOTH;
				break;
			}
			
//			_minAgeBox.selectedItem = "" + ((_filter.age_min == 60) ? "60+" : _filter.age_min);
//			_maxAgeBox.selectedItem = "" + ((_filter.age_max == 60) ? "60+" : _filter.age_max);
		}
		
		private function createLabel(text:String, x:int, y:int, width:int=0):TextField {
			var label:TextField = new TextField();
			label.text = (text) ? text : "";
			label.x = x;
			label.y = y;
			label.width = width;
			label.selectable = false;
			
			return label;
		}
		
		private function createComboBox(x:int, y:int, width:int):ComboBox {
			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(0, 0, width, 15, 12);
			spr.graphics.endFill();
			var bd: BitmapData = new BitmapData(width, 15, true, undefined);
			bd.draw(spr);
			var button:Bitmap = Util.multiLoader.get(Images.CHOOSE_BUTTON);
//			var matrix:Matrix = new Matrix();
//			matrix.tx = bd.width - button.width;
//			bd.draw(button, matrix);
			
			
			var box:ComboBox = new ComboBox(_scene);
			box.bitmap = new Bitmap(bd);
			box.dropIcon = button;
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
		
		public function set bigPhoto(image:Bitmap):void {
			if (image) {
				_bigPhoto.photo = image;
				
				if (_nameField) {
					_nameField.y = _bigPhoto.y + _bigPhoto.height + 4;
				}
				
				if (_commentField) {
					_commentField.y = _nameField.y + 28;
					_commentField.x = _commentField.y < 495 ? _bigPhoto.x : 180;
					_commentField.width = _commentField.y < 495 ? _bigPhoto.width : 300;
				}
			}
		}
		
		public function set smallPhoto(image:Bitmap):void {
			if (image) {
				_smallPhoto.photo = image;
			}
		}
		
		public function set filter(obj:Object):void {
			_filter = obj;
		}
		
		public function onRateClicked(event:MouseEvent):void {
			Util.api.vote(Util.userId, _current.pid, _rateBar.rating);
		}
		
		public function onMinAgeChanged(event:GridBoxEvent):void {
			if (_minAgeBox.selectedIndex > _maxAgeBox.selectedIndex) {
//				TODO:
//				_maxAgeBox.selectedItem = _minAgeBox.selectedIndex;
			}
		}
		
		public function onMaxAgeChanged(event:GridBoxEvent):void {
			if (_minAgeBox.selectedIndex > _maxAgeBox.selectedIndex) {
//				TODO:
//				_maxAgeBox.selectedItem = _minAgeBox.selectedIndex;
			}
		}
	}
}