package com.facecontrol.gui
{
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
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
		private static const RECT_ELIPSE_HEIGHT: int	= 15;
		
		private static const COLOR_GREEN:int			= 0x92fa3e;
		private static const COLOR_GREEN_RIGHT:int		= 0x2a5f00;
		private static const COLOR_YELLOW:int			= 0xf5e240;
		private static const COLOR_YELLOW_RIGHT:int		= 0xd7c000;
		private static const COLOR_ORANGE:int			= 0xf8a728;
		private static const COLOR_ORANGE_RIGHT:int		= 0x985d00;
		private static const COLOR_RED:int				= 0xfb452d;
		private static const COLOR_RED_RIGHT:int		= 0xaa1400;
		private static const COLOR_BLUE:int				= 0xcf58f6;
		private static const COLOR_BLUE_RIGHT:int		= 0x310041;
		
		private var _ratingLabel:TextField;
		
		public function RatingStatusBar(value:GameScene)
		{
			super(value);
			
			_ratingLabel = Util.createLabel('123000', RECT_X, RECT_Y);
			_ratingLabel.setTextFormat(new TextFormat(Util.tahomaBold.fontName, 13, 0xffffff));
			_ratingLabel.embedFonts = true;
			_ratingLabel.antiAliasType = AntiAliasType.ADVANCED;
			_ratingLabel.autoSize = TextFieldAutoSize.LEFT;
			_ratingLabel.x = RECT_X + (RECT_WIDTH - _ratingLabel.width) / 2;
			addChild(_ratingLabel);
			
			rating = 0;
		}
		
		public function set rating(value:int): void {
			var percent:Number = 1;
			var backgoundFillColor:int = 0x00;
			var backgoundFillColorGradient:int = 0x00;
			var fillColor:int = 0x00;
			var fillColorGradient:int = 0x00;
			
			if (value >= 0 && value <= 100) {
				backgoundFillColor = 0xee59a2;
				backgoundFillColorGradient = 0x590931;
				fillColor = COLOR_GREEN;
				fillColorGradient = COLOR_GREEN_RIGHT;
				
				percent = value/100;
			}
			else if (value <= 500) {
				backgoundFillColor = COLOR_GREEN;
				backgoundFillColorGradient = COLOR_GREEN_RIGHT;
				fillColor = COLOR_YELLOW;
				fillColorGradient = COLOR_YELLOW_RIGHT;
				percent = value/500;
			}
			else if (value <= 2000) {
				backgoundFillColor = COLOR_YELLOW;
				backgoundFillColorGradient = COLOR_YELLOW_RIGHT;
				fillColor = COLOR_ORANGE;
				fillColorGradient = COLOR_ORANGE_RIGHT;
				
				percent = value/2000;
			}
			else if (value <= 5000) {
				backgoundFillColor = COLOR_ORANGE;
				backgoundFillColorGradient = COLOR_ORANGE_RIGHT;
				fillColor = COLOR_RED;
				fillColorGradient = COLOR_RED_RIGHT;
				
				percent = value/5000;
			}
			else {
				backgoundFillColor = COLOR_RED;
				backgoundFillColorGradient = COLOR_RED_RIGHT;
				fillColor = COLOR_BLUE;
				fillColorGradient = COLOR_BLUE_RIGHT;
				
				percent = value/5000;
			}
			
			if (percent > 1) percent = 1;
			else if (percent < 0) percent = 0;
			
			graphics.clear();
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [backgoundFillColor, backgoundFillColorGradient];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, 20, Math.PI / 2, RECT_X, RECT_Y);
			var spreadMethod:String = SpreadMethod.PAD;
			
			graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			graphics.drawRect(RECT_X, RECT_Y, RECT_WIDTH, RECT_HEIGHT);
			graphics.endFill();
			
			colors = [fillColor, fillColorGradient];
			alphas = [1, 1];
			ratios = [0x00, 0xFF];
			graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			graphics.drawRect(RECT_X, RECT_Y, RECT_WIDTH * percent, RECT_HEIGHT);
			graphics.endFill();
			
			graphics.lineStyle(1.0, 0x00, 1, true, LineScaleMode.NORMAL, null, JointStyle.ROUND);
			graphics.drawRect(RECT_X, RECT_Y, RECT_WIDTH, RECT_HEIGHT);
			
			_ratingLabel.defaultTextFormat = _ratingLabel.getTextFormat();
			_ratingLabel.text = '' + value;
			_ratingLabel.x = RECT_X + (RECT_WIDTH - _ratingLabel.width) / 2;
		}
	}
}