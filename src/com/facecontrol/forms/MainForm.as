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
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.RatingBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class MainForm extends GameLayer
	{
		private static const opiumBold:Font = new EmbeddedFonts_OpiumBold();
		private static const _commentTextFormat:TextFormat = new TextFormat("Tahoma", 12, 0xa7b3b4);
		private static const _nameTextFormat:TextFormat = new TextFormat(opiumBold.fontName, 16, 0xffe6be);
		
		public var _userProfileBtn: GameObject;
		public var _mainPhoto: GameObject;
		
		protected var _bigPhoto:Photo;
		protected var _smallPhoto:Photo;
		protected var _ratingAverage:TextField;
		protected var _votesCount:TextField;
		protected var _name:TextField;
		protected var _comment:TextField;
		protected var _rateBar:RatingBar;
		protected var _sexBox:ComboBox;
		protected var _minAgeBox:ComboBox;
		protected var _maxAgeBox:ComboBox;
		protected var _countryBox:ComboBox;
		protected var _cityBox:ComboBox;
		
		private var _pid:int;
		
		public function MainForm(value:GameScene)
		{
			super(value);
			
			visible = false;
			
			width = Constants.APP_WIDTH;
			height = Constants.APP_HEIGHT;
			
			
//			var f:Font = new EmbeddedFonts_Opium();
//			var f:Font = new EmbeddedFonts_OpiumItalic();
//			var f:Font = new EmbeddedFonts_OpiumBoldItalic();
			
			var labelFormat:TextFormat = new TextFormat();
			labelFormat.font = opiumBold.fontName;
			labelFormat.size = 12;
			labelFormat.color = 0xffffff;
			
			var label:TextField = createLabel("Оцени это фото!", 0, 72, Constants.APP_WIDTH);
			label.setTextFormat(labelFormat);
			label.embedFonts = true;
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
			otherPhotos.setTextFormatForState(new TextFormat("Tahoma", 12, 0x8bbe79, null, null, true), LinkButton.STATE_NORMAL);
			addChild(otherPhotos);
			
			_bigPhoto = new Photo(_scene, null, (Constants.APP_WIDTH - 234) / 2, 176, 234, 317);
			addChild(_bigPhoto);
			
			_smallPhoto = new Photo(_scene, null, 38, 176, 132, 176);
			addChild(_smallPhoto);
			
			var bigStar:Bitmap = Util.multiLoader.get(Images.BIG_STAR);
			bigStar.y = 360;
			bigStar.x = 44;
			addChild(bigStar);
			
			_ratingAverage = createLabel("0", 83, 355);
			_ratingAverage.setTextFormat(new TextFormat("Tahoma", 30, 0xffffff));
			_ratingAverage.autoSize = TextFieldAutoSize.LEFT;
			addChild(_ratingAverage);
			
			var line:Bitmap = Util.multiLoader.get(Images.LINE);
			line.x = 38;
			line.y = 420;
			addChild(line);
			
			var ratingLabel:TextField = createLabel("средний бал", 38, 395, line.width);
			ratingLabel.setTextFormat(new TextFormat(opiumBold.fontName, 13, 0xd2dee0));
			ratingLabel.embedFonts = true;
			ratingLabel.autoSize = TextFieldAutoSize.CENTER;
			addChild(ratingLabel);
			
			var votesLabel:TextField = createLabel("голосовало:", 38, 424, line.width);
			votesLabel.setTextFormat(new TextFormat(opiumBold.fontName, 12, 0x86a4a8));
			votesLabel.embedFonts = true;
			votesLabel.autoSize = TextFieldAutoSize.CENTER;
			addChild(votesLabel);
			
			_votesCount = createLabel("10345", 38, 442, line.width);
			_votesCount.setTextFormat(new TextFormat("Tahoma", 20, 0xb0dee6));
			_votesCount.autoSize = TextFieldAutoSize.CENTER;
			addChild(_votesCount);
			
			var filterBackgruond:Bitmap = Util.multiLoader.get(Images.FILTER_BACKGROUND);
			filterBackgruond.x = 452;
			filterBackgruond.y = 313;
			addChild(filterBackgruond);
			
			var filterLabelFormat:TextFormat = new TextFormat("Tahoma", 12, 0xf2c3ff);
			
			var filterLabel:TextField = createLabel("Я ищу:", 470, 315);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_sexBox = createComboBox(113);
			_sexBox.x = 472;
			_sexBox.y = 335;
			_sexBox.addItem(Constants.SEX_FEMALE);
			_sexBox.addItem(Constants.SEX_MALE);
			_sexBox.addItem(Constants.SEX_BOTH);
			_sexBox.selectedItem = Constants.SEX_FEMALE;
			addChild(_sexBox);
			
			filterLabel = createLabel("От:", 470, 364);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_minAgeBox = createComboBox(84);
			_minAgeBox.x = 502;
			_minAgeBox.y = 367;
			for (var i:int = 10; i < 60; ++i) {
				_minAgeBox.addItem(""+i);
			}
//			_minAgeBox.selectedItem = '18';
			addChild(_minAgeBox);
			
			filterLabel = createLabel("До:", 470, 382);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_maxAgeBox = createComboBox(84);
			_maxAgeBox.x = 502;
			_maxAgeBox.y = 385;
			for (i = 10; i < 60; ++i) {
				_maxAgeBox.addItem(""+i);
			}
//			_maxAgeBox.selectedItem = '30';
			addChild(_maxAgeBox);
			
			filterLabel = createLabel("Страна:", 470, 405);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_countryBox = createComboBox(113);
			_countryBox.x = 472;
			_countryBox.y = 425;
			_countryBox.addItem('Россия');
			_countryBox.addItem('Германия');
			_countryBox.addItem('США');
			_countryBox.selectedItem = 'Россия';
			addChild(_countryBox);
			
			filterLabel = createLabel("Город:", 470, 445);
			filterLabel.setTextFormat(filterLabelFormat);
			filterLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(filterLabel);
			
			_cityBox = createComboBox(113);
			_cityBox.x = 472;
			_cityBox.y = 465;
			_cityBox.addItem('Пенза');
			_cityBox.addItem('Москва');
			_cityBox.addItem('Рязань');
			_cityBox.selectedItem = 'Пенза';
			addChild(_cityBox);
			
			_name = createLabel(
				null,
				_bigPhoto.x,
				_bigPhoto.y + ((_bigPhoto.bitmap) ? _bigPhoto.bitmap.height : _bigPhoto.height) + 4,
				_bigPhoto.width);
			_name.setTextFormat(_nameTextFormat);
			_name.embedFonts = true;
			_name.autoSize = TextFieldAutoSize.CENTER;
			addChild(_name);
			
			var commentY:int = _name.y + 28;
			_comment = createLabel(
				null,
				commentY < 495 ? _bigPhoto.x : 180,
				commentY,
				commentY < 495 ? _bigPhoto.width : 300);
			
			_comment.setTextFormat(_commentTextFormat);
			_comment.multiline = true;
			_comment.wordWrap = true;
			addChild(_comment);
		}
		
		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (value) {
				Util.api.nextPhoto(Util.userId);
			}
		}
		
		private var photoNames:Array = new Array("photo1", "photo2", "photo3");
		private var photoIndex:uint = 0;
		
		public function nextPhoto(obj:Object):void {
			_rateBar.rating = 0;
			
			if (Util.multiLoader.hasLoaded(photoNames[photoIndex])) {
				smallPhoto = Util.multiLoader.get(photoNames[photoIndex]);
				
				if (Util.multiLoader.hasLoaded(photoNames[photoIndex - 1])) {
					Util.multiLoader.unload(photoNames[photoIndex - 1]);
				}
				
				photoIndex = (photoIndex + 1) % 3;
			}
			
			_pid = obj["pid"];
			Util.multiLoader.load(obj['src_big'], photoNames[photoIndex], "Bitmap");
			userName = obj["fname"];
			userComment = obj["comment"];
			Util.multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
		}
		
		public function vote(obj:Object):void {
			ratingAverage = obj["rating_average"];
			votesCount = obj["votes_count"];
			Util.api.nextPhoto(Util.userId);
		}
		
		private function multiLoaderProgressListener(event:MultiLoaderEvent):void {
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.hasLoaded(photoNames[photoIndex])) {
				bigPhoto = Util.multiLoader.get(photoNames[photoIndex]);
			}
		}
		
		public function set userName(value:String):void {
			if (_name) {
				_name.text = value;
				_name.setTextFormat(_nameTextFormat);
			}
		}
		
		public function set userComment(value:String):void {
			if (_comment) {
				_comment.text = (value) ? value : "";
				_comment.setTextFormat(_commentTextFormat);
			}
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
		
		private function createComboBox(width:int):ComboBox {
			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(0, 0, width, 15, 12);
			spr.graphics.endFill();
			var bd: BitmapData = new BitmapData(width, 15, true, undefined);
			bd.draw(spr);
			var button:Bitmap = Util.multiLoader.get(Images.CHOOSE_BUTTON);
			var matrix:Matrix = new Matrix();
			matrix.tx = bd.width - button.width;
			bd.draw(button, matrix);
			
			var format:TextFormat = new TextFormat();
			format.font = "Tahoma";
			format.size = 11;
			
			var box:ComboBox = new ComboBox(_scene);
			box.bitmap = new Bitmap(bd);
//			box.textField.defaultTextFormat = format;
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
				if (_name) {
					_name.y = _bigPhoto.y + _bigPhoto.bitmap.height + 4;
				}
				if (_comment) {
					_comment.y = _name.y + 28;
					_comment.x = _comment.y < 495 ? _bigPhoto.x : 180;
					_comment.width = _comment.y < 495 ? _bigPhoto.width : 300;
				}
			}
		}
		
		public function set smallPhoto(image:Bitmap):void {
			if (image) {
				_smallPhoto.photo = image;
			}
		}
		
		public function set ratingAverage(value:String):void {
			var format:TextFormat = _ratingAverage.getTextFormat();
			_ratingAverage.text = value;
			_ratingAverage.setTextFormat(format);
		}
		
		public function set votesCount(value:String):void {
			var format:TextFormat = _ratingAverage.getTextFormat();
			_votesCount.text = value;
			_votesCount.setTextFormat(format);
		}
		
		public function set filterSex(sex:uint):void {
			switch (sex) {
				case 1:
					_sexBox.selectedItem = Constants.SEX_FEMALE;
				break;
				case 2:
					_sexBox.selectedItem = Constants.SEX_MALE;
				break;
				default:
					_sexBox.selectedItem = Constants.SEX_BOTH;
			}
		}
		
		public function set filterMinAge(age:uint):void {
			_minAgeBox.selectedItem = ""+age;
		}
		
		public function set filterMaxAge(age:uint):void {
			_maxAgeBox.selectedItem = ""+age;
		}
		
//		public function set filterCity(value:String):void {
//			
//		}
		
		public function onRateClicked(event:MouseEvent):void {
			Util.api.vote(Util.userId, _pid, _rateBar.rating);
		}
	}
}