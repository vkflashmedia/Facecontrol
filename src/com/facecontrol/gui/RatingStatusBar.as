package com.facecontrol.gui
{
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class RatingStatusBar extends GameObject
	{
		private static const RECT_X: int				= 405;
		private static const RECT_Y: int				= 98;
		private static const RECT_WIDTH: int			= 130;
		private static const RECT_HEIGHT: int			= 20;
		private static const RECT_ELIPSE_WIDTH: int		= 10;
		private static const RECT_ELIPSE_HEIGHT: int	= 10;
		
		private var _ratingLabel:TextField;
		
		public function RatingStatusBar(value:GameScene)
		{
			super(value);
			
			_ratingLabel = Util.createLabel('123000', RECT_X, RECT_Y);
			_ratingLabel.setTextFormat(new TextFormat(Util.tahomaBold.fontName, 15, 0xffffff));
			_ratingLabel.embedFonts = true;
			_ratingLabel.antiAliasType = AntiAliasType.ADVANCED;
			_ratingLabel.autoSize = TextFieldAutoSize.LEFT;
			_ratingLabel.x = RECT_X + (RECT_WIDTH - _ratingLabel.width) / 2;
			addChild(_ratingLabel);
			
			rating = 0;
		}
		
		public function set rating(value:int): void {
			var backgoundFillColor:int = 0x00;
			var fillColor:int = 0x00;
			if (value >= 0 && value <= 100) {
				backgoundFillColor = 0xffffff;
				fillColor = 0x00ff00;
			}
			else if (value <= 500) {
				backgoundFillColor = 0x00ff00;
				fillColor = 0xe9f708;
			}
			else if (value <= 2000) {
				backgoundFillColor = 0xe9f708;
				fillColor = 0xff9c00;
			}
			else if (value <= 5000) {
				backgoundFillColor = 0xff9c00;
				fillColor = 0xff0000;
			}
			else {
				backgoundFillColor = 0xff0000;
				fillColor = 0xae00ff;
			}
			
			graphics.clear();
			
			graphics.beginFill(backgoundFillColor);
			graphics.drawRoundRect(RECT_X, RECT_Y, RECT_WIDTH, RECT_HEIGHT, RECT_ELIPSE_WIDTH, RECT_ELIPSE_HEIGHT);
			graphics.endFill();
			
			graphics.beginFill(fillColor);
			graphics.drawRoundRect(RECT_X, RECT_Y, RECT_WIDTH - 50, RECT_HEIGHT, RECT_ELIPSE_WIDTH, RECT_ELIPSE_HEIGHT);
			graphics.endFill();
			
			graphics.lineStyle(1.0, 0x00);
			graphics.drawRoundRect(RECT_X, RECT_Y, RECT_WIDTH, RECT_HEIGHT, RECT_ELIPSE_WIDTH, RECT_ELIPSE_HEIGHT);
			
			_ratingLabel.defaultTextFormat = _ratingLabel.getTextFormat();
			_ratingLabel.text = "" + value;
			_ratingLabel.x = RECT_X + (RECT_WIDTH - _ratingLabel.width) / 2;
		}
	}
}