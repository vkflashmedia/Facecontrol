package com.facecontrol.forms
{
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.LinkButton;
	
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class MainForm extends GameLayer
	{
		public var _userProfileBtn: GameObject;
		public var _mainPhoto: GameObject;
		
		protected var _bigPhoto:Photo;
		protected var _smallPhoto:Photo;
		protected var _rating:TextField;
		protected var _votes:TextField;
		protected var _name:TextField;
		protected var _comment:TextField;
		
		public function MainForm(value:GameScene)
		{
			super(value);
			
			width = Constants.APP_WIDTH;
			height = Constants.APP_HEIGHT;
			
			bitmap = Util.multiLoader.get(Images.BACKGROUND);
			
			addChild(Util.mainMenu);
			
			var opiumBold:Font = new EmbeddedFonts_OpiumBold();
//			var f:Font = new EmbeddedFonts_Opium();
//			var f:Font = new EmbeddedFonts_OpiumItalic();
//			var f:Font = new EmbeddedFonts_OpiumBoldItalic();
			
			var labelFormat:TextFormat = new TextFormat();
			labelFormat.font = opiumBold.fontName;
			labelFormat.size = 12;
			labelFormat.color = 0xffffff;
			
			var label:TextField = new TextField();
			label.defaultTextFormat = labelFormat;
			label.embedFonts = true;
			label.text = "Оцени это фото!";
			label.x = 0;
			label.y = 72;
			label.width = Constants.APP_WIDTH;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.selectable = false;
			addChild(label);
			
			var junkIcon:Bitmap = Util.multiLoader.get(Images.JUNK_ICON);
			junkIcon.x = 58;
			junkIcon.y = 73;
			addChild(junkIcon);
			
			var superIcon:Bitmap = Util.multiLoader.get(Images.SUPER_ICON);
			superIcon.x = 452;
			superIcon.y = 75;
			addChild(superIcon);
			
			var otherPhotoNormalStateFormat:TextFormat = new TextFormat();
			otherPhotoNormalStateFormat.font = "Tahoma";
			otherPhotoNormalStateFormat.size = 12;
			otherPhotoNormalStateFormat.color = 0x8bbe79;
			otherPhotoNormalStateFormat.underline = true;
			
			var otherPhotos:LinkButton = new LinkButton(value, "Еще фото", 195, 150);
			otherPhotos.setTextFormatForState(otherPhotoNormalStateFormat, LinkButton.STATE_NORMAL);
			addChild(otherPhotos);
			
			var source:Bitmap = Util.multiLoader.get(Images.IM);
			_bigPhoto = new Photo(_scene, source, (Constants.APP_WIDTH - 234) / 2, 176, 234, 317);
			addChild(_bigPhoto);
			
			var smallSource:Bitmap = Util.multiLoader.get(Images.SMALL_MASK);
			_smallPhoto = new Photo(_scene, smallSource, 38, 176, 132, 176);
			addChild(_smallPhoto);
			
			var bigStar:Bitmap = Util.multiLoader.get(Images.BIG_STAR);
			bigStar.y = 360;
			bigStar.x = 44;
			addChild(bigStar);
			
			var ratingFormat:TextFormat = new TextFormat();
			ratingFormat.font = "Tahoma";
			ratingFormat.size = 30;
			ratingFormat.color = 0xffffff;
			
			_rating = new TextField();
			_rating.defaultTextFormat = ratingFormat;
			_rating.text = "9,5";
			_rating.x = 83;
			_rating.y = 355;
			_rating.autoSize = TextFieldAutoSize.LEFT;
			_rating.selectable = false;
			addChild(_rating);
			
			var line:Bitmap = Util.multiLoader.get(Images.LINE);
			line.x = 38;
			line.y = 420;
			addChild(line);
			
			var ratingLabelFormat:TextFormat = new TextFormat();
			ratingLabelFormat.font = opiumBold.fontName;
			ratingLabelFormat.size = 13;
			ratingLabelFormat.color = 0xd2dee0;
			
			var ratingLabel:TextField = new TextField();
			ratingLabel.defaultTextFormat = ratingLabelFormat;
			ratingLabel.embedFonts = true;
			ratingLabel.text = "средний бал";
			ratingLabel.x = 38;
			ratingLabel.y = 395;
			ratingLabel.width = line.width;
			ratingLabel.autoSize = TextFieldAutoSize.CENTER;
			ratingLabel.selectable = false;
			addChild(ratingLabel);
			
			var commonLabelFormat:TextFormat = new TextFormat();
			commonLabelFormat.font = opiumBold.fontName;
			commonLabelFormat.size = 12;
			commonLabelFormat.color = 0x86a4a8;
			
			var commonLabel:TextField = new TextField();
			commonLabel.defaultTextFormat = commonLabelFormat;
			commonLabel.embedFonts = true;
			commonLabel.text = "голосовало:";
			commonLabel.x = 38;
			commonLabel.y = 424;
			commonLabel.width = line.width;
			commonLabel.autoSize = TextFieldAutoSize.CENTER;
			commonLabel.selectable = false;
			addChild(commonLabel);
			
			var votesFormat:TextFormat = new TextFormat();
			votesFormat.font = "Tahoma";
			votesFormat.size = 20;
			votesFormat.color = 0xb0dee6;
			
			_votes = new TextField();
			_votes.defaultTextFormat = votesFormat;
			_votes.text = "10345";
			_votes.x = 38;
			_votes.y = 442;
			_votes.width = line.width;
			_votes.autoSize = TextFieldAutoSize.CENTER;
			_votes.selectable = false;
			addChild(_votes);
			
			var filterBackgruond:Bitmap = Util.multiLoader.get(Images.FILTER_BACKGROUND);
			filterBackgruond.x = 452;
			filterBackgruond.y = 313;
			addChild(filterBackgruond);
			
			var nameFormat:TextFormat = new TextFormat();
			nameFormat.font = opiumBold.fontName;
			nameFormat.size = 16;
			nameFormat.color = 0xffe6be;
			
			_name = new TextField();
			_name.defaultTextFormat = nameFormat;
			_name.embedFonts = true;
			_name.text = "DETKA_1990";
			_name.x = _bigPhoto.x;
			_name.y = _bigPhoto.y + _bigPhoto.bitmap.height + 4;
			_name.width = _bigPhoto.width;
			_name.autoSize = TextFieldAutoSize.CENTER;
			_name.selectable = false;
			addChild(_name);
			
			var commentFormat:TextFormat = new TextFormat();
			commentFormat.font = "Tahoma";
			commentFormat.size = 12;
			commentFormat.color = 0xa7b3b4;
			
			_comment = new TextField();
			_comment.defaultTextFormat = commentFormat;
			_comment.text = "Сдесь я очень хорошо выгляжу не правда ли?.. Сдесь я первый раз одела свое нижнее белье чтобы прыгнуть с парашутом)";
			_comment.y = _name.y + 28;
			_comment.x = _comment.y < 495 ? _bigPhoto.x : 180;
			_comment.width = _comment.y < 495 ? _bigPhoto.width : 300;
			_comment.multiline = true;
			_comment.wordWrap = true;
			_comment.selectable = false;
			addChild(_comment);
		}
		
		public override function destroy():void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
			super.destroy();
		}
		
		public function set bigPhoto(image:Bitmap):void {
			_bigPhoto.photo = image;
			if (_name != null) {
				_name.y = _bigPhoto.y + _bigPhoto.bitmap.height + 4;
			}
			if (_comment != null) {
				_comment.y = _name.y + 28;
				_comment.x = _comment.y < 495 ? _bigPhoto.x : 180;
				_comment.width = _comment.y < 495 ? _bigPhoto.width : 300;
			}
		}
		
		public function set rating(value:String):void {
			_rating.text = value;
		}
		
		public function set votes(value:String):void {
			_votes.text = value;
		}
	}
}