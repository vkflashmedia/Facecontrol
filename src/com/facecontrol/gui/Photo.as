package com.facecontrol.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Photo extends GameObject
	{
		public static const BORDER_TYPE_ROUND_RECT:uint = 0;
		public static const BORDER_TYPE_RECT:uint = 1;
		
		public static const ALIGN_LEFT:uint = 0;
		public static const ALIGN_CENTER:uint = 1;
		
		private var _align:uint = ALIGN_LEFT;
		
		private var _photoBorder:uint;
		private var _photoBorderColor:int;
		private var _borderType:uint = BORDER_TYPE_ROUND_RECT;
		
		private var _photo:Bitmap;
		private var _thumbnail:Bitmap;
		private var _transparentSquare:Sprite;
		private var _squareMask:Sprite;
		
		public function Photo(value:GameScene, image:Bitmap, x:int, y:int, width:int, height:int, type:uint=0)
		{
			super(value);
			
			_photoBorderColor = 0x000000;
			_borderType = type;
			_photoBorder = 2;
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			autoSize = false;
			photo = image;
		}
		
		public function set photoBorder(value:uint):void {
			_photoBorder = value;
			update();
		}
		
		public function set photoBorderColor(value:int):void {
			_photoBorderColor = value;
			update();
		}
		
		public function set borderType(value:uint):void {
			_borderType = value;
			update();
		}
		
		public function set align(value:uint):void {
			_align = value;
			update();
		}
		
		private function update():void {
//			graphics.beginFill(0x00ff00, 1);
//			graphics.drawRect(0, 0, width, height);
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
				
			if (_photo) {
				_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
				if (_thumbnail.width > (width - _photoBorder*2)) {
					var s:Number = (width - _photoBorder*2) / _thumbnail.width;
					if (s < 1) {
						var matrix:Matrix = new Matrix();
						matrix.scale(s, s);
						_thumbnail.transform.matrix = matrix;
					}
					else matrix = null;
				}
				
				if (_thumbnail.height < (height - _photoBorder*2)) {
					_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
					s = (height - _photoBorder*2) / _thumbnail.height;
					if (s < 1) {
						matrix = new Matrix();
						matrix.scale(s, s);
						_thumbnail.transform.matrix = matrix;
					}
					else matrix = null;
				}
				
				var photoWidth:Number = width;
				var photoHeight:Number = height;
				var xIndent:int = 0;
				var yIndent:int = 0;
				
				if (matrix == null) {
					photoWidth = _thumbnail.width + _photoBorder * 2;
					photoHeight = _thumbnail.height + _photoBorder * 2;
					
					if (_align == ALIGN_CENTER) {
						xIndent = (width - photoWidth) / 2;
						yIndent = (height - photoHeight) / 2;
					}
				}
				
				var squareWidth:Number = photoWidth - _photoBorder * 2;
				var squareHeight:Number = photoHeight - _photoBorder * 2;
				
				_squareMask = new Sprite();
				_squareMask.graphics.beginFill(_photoBorderColor);

				switch (_borderType) {
					case BORDER_TYPE_ROUND_RECT:
						_squareMask.graphics.drawRoundRect(xIndent + _photoBorder, yIndent + _photoBorder, squareWidth, squareHeight, 15, 15);
					break;
					case BORDER_TYPE_RECT:
						_squareMask.graphics.drawRect(xIndent + _photoBorder, yIndent + _photoBorder, squareWidth, squareHeight);
					break;
				}
				
				var transparentWidth:Number = squareWidth + _photoBorder*2;
				var transparentHeight:Number = squareHeight + _photoBorder*2;
				
				_transparentSquare = new Sprite();
				_transparentSquare.graphics.beginFill(_photoBorderColor, 0.5);

				switch (_borderType) {
					case BORDER_TYPE_ROUND_RECT:
						_transparentSquare.graphics.drawRoundRect(xIndent, yIndent, transparentWidth, transparentHeight, 15, 15);
					break;
					case BORDER_TYPE_RECT:
						_transparentSquare.graphics.drawRect(xIndent, yIndent, transparentWidth, transparentHeight);
					break;
				}
				
				addChild(_transparentSquare);
				addChild(_thumbnail);
				addChild(_squareMask);
				
				_thumbnail.x = xIndent + (photoWidth - _thumbnail.width) / 2;
				_thumbnail.y = yIndent + (photoHeight - _thumbnail.height) / 2;
				if (_thumbnail.x > xIndent + _photoBorder) _thumbnail.x = xIndent + _photoBorder;
				if (_thumbnail.y > yIndent + _photoBorder) _thumbnail.y = yIndent + _photoBorder;
				
				_thumbnail.mask = _squareMask;
			}
		}
		
//		private function update():void {
//			while (numChildren > 0) {
//				removeChildAt(0);
//			}
//				
//			if (_photo) {
//				_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
//				var s:Number = (width - _photoBorder*2) / _thumbnail.width;
//				if (s < 1) {
//					var matrix:Matrix = new Matrix();
//					matrix.scale(s, s);
//					_thumbnail.transform.matrix = matrix;
//				}
//				
//				if (_thumbnail.height < (height - _photoBorder*2)) {
//					_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
//					s = (height - _photoBorder*2) / _thumbnail.height;
//					if (s < 1) {
//						matrix = new Matrix();
//						matrix.scale(s, s);
//						_thumbnail.transform.matrix = matrix;
//					}
//				}
//				
//				var photoWidth:Number = _thumbnail.width;
//				var photoHeight:Number = _thumbnail.height;
//				var transparentWidth:Number = (photoWidth > width) ? width : photoWidth + _photoBorder*2;
//				var transparentHeight:Number = (photoHeight > height) ? height : photoHeight + _photoBorder*2;
//					
//				_transparentSquare = new Sprite();
//				_transparentSquare.graphics.beginFill(_photoBorderColor, 0.5);
//
//				switch (_borderType) {
//					case BORDER_TYPE_ROUND_RECT:
//						_transparentSquare.graphics.drawRoundRect(0, 0, transparentWidth, transparentHeight, 15, 15);
//					break;
//					case BORDER_TYPE_RECT:
//						_transparentSquare.graphics.drawRect(0, 0, transparentWidth, transparentHeight);
//					break;
//				}
//				
//				addChild(_transparentSquare);
//				addChild(_thumbnail);
//				
//				_squareMask = new Sprite();
//				_squareMask.graphics.beginFill(_photoBorderColor);
//
//				var squareWidth:Number = transparentWidth - _photoBorder * 2;
//				var squareHeight:Number = transparentHeight - _photoBorder * 2;
//				
//				switch (_borderType) {
//					case BORDER_TYPE_ROUND_RECT:
//						_squareMask.graphics.drawRoundRect(_photoBorder, _photoBorder, squareWidth, squareHeight, 15, 15);
//					break;
//					case BORDER_TYPE_RECT:
//						_squareMask.graphics.drawRect(_photoBorder, _photoBorder, squareWidth, squareHeight);
//					break;
//				}
//				
//				addChild(_squareMask);
//				
//				switch (_align) {
//					case ALIGN_LEFT:
//						_thumbnail.x = _photoBorder + (transparentWidth - _thumbnail.width) / 2;
//						_thumbnail.y = _photoBorder + (transparentHeight - _thumbnail.height) / 2;
//					break;
//					case ALIGN_CENTER:
//						_thumbnail.x = (width - _thumbnail.width) / 2;
//						_thumbnail.y = (height - _thumbnail.height) / 2;
//					break;
//				}
//				_thumbnail.mask = _squareMask;
//			}
//		}
		
		public function get photoWidth():int {
			return (_thumbnail) ? _thumbnail.width + _photoBorder*2 : width;
		}
		
		public function get photoHeight():int {
			return (_thumbnail) ? _thumbnail.height + _photoBorder*2 : height;
		}
		
		public function set photo(value:Bitmap):void {
			_photo = (value) ? BitmapUtil.cloneBitmap(value) : null;
			update();
		}
		
		public function get photo():Bitmap {
			return _photo;
		}
		
		public override function get bitmap():Bitmap {
			return _thumbnail;
		}
	}
}