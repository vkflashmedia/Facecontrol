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
		
		public static const VERTICAL_ALIGN_TOP:uint = 0;
		public static const VERTICAL_ALIGN_CENTER:uint = 1;
		
		public static const HORIZONTAL_ALIGN_LEFT:uint = 0;
		public static const HORIZONTAL_ALIGN_CENTER:uint = 1;
		
		public static const VERTICAL_SCALE_AUTO:uint = 0;
		public static const VERTICAL_SCALE_ALWAYS:uint = 1;
		
		public static const HORIZONTAL_SCALE_AUTO:uint = 0;
		public static const HORIZONTAL_SCALE_ALWAYS:uint = 1;
		
		public var index:int = 0;
		
		private var _align:uint = ALIGN_LEFT;
		
		private var _photoBorder:uint;
		private var _photoBorderColor:int;
		private var _borderType:uint = BORDER_TYPE_ROUND_RECT;
		
		private var _photo:Bitmap;
		private var _thumbnail:Bitmap;
		private var _transparentSquare:Sprite;
		private var _squareMask:Sprite;
		
		private var _valign:uint;
		private var _halign:uint;
		
		private var _vscale:uint;
		private var _hscale:uint;
		
		private var _photoWidth:int;
		private var _photoHeight:int;
		
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
		
		public function set verticalScale(value:uint):void {
			_vscale = value;
			update();
		}
		
		public function set horizontalScale(value:uint):void {
			_hscale = value;
			update();
		}
		
		public function set verticalAlign(value:uint):void {
			_valign = value;
			update();
		}
		
		public function set horizontalAlign(value:uint):void {
			_halign = value;
			update();
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
				
				if (_hscale == HORIZONTAL_SCALE_ALWAYS && _vscale == VERTICAL_SCALE_ALWAYS) {
					var s:Number = (width - _photoBorder*2) / _thumbnail.width;
					var matrix:Matrix = new Matrix();
					matrix.scale(s, s);
					_thumbnail.transform.matrix = matrix;
					
					if (_thumbnail.height < (height - _photoBorder*2)) {
						_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
						s = (height - _photoBorder*2) / _thumbnail.height;
						matrix = new Matrix();
						matrix.scale(s, s);
						_thumbnail.transform.matrix = matrix;
					}
				}
				else if (_hscale == HORIZONTAL_SCALE_ALWAYS && _vscale == VERTICAL_SCALE_AUTO) {
					_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
					s = (width - _photoBorder*2) / _thumbnail.width;
					matrix = new Matrix();
					matrix.scale(s, s);
					_thumbnail.transform.matrix = matrix;
				}
				else if (_hscale == HORIZONTAL_SCALE_AUTO && _vscale == VERTICAL_SCALE_ALWAYS) {
					_thumbnail = new Bitmap(_photo.bitmapData, 'auto', true);
					s = (height - _photoBorder*2) / _thumbnail.height;
					matrix = new Matrix();
					matrix.scale(s, s);
					_thumbnail.transform.matrix = matrix;
				}
				else if (_hscale == HORIZONTAL_SCALE_AUTO && _vscale == VERTICAL_SCALE_AUTO) {
					if (_thumbnail.width > (width - _photoBorder*2)) {
						s = (width - _photoBorder*2) / _thumbnail.width;
						if (s < 1) {
							matrix = new Matrix();
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
				}
				
				_photoWidth = width;
				_photoHeight = height;
				var xIndent:int = 0;
				var yIndent:int = 0;
				
				_photoWidth = (_thumbnail.width < width) ? _thumbnail.width : width;
				_photoHeight = (_thumbnail.height < height) ? _thumbnail.height : height;
				
				if (!matrix) {
					if (_align == ALIGN_CENTER) {
						xIndent = (width - _photoWidth) / 2;
						yIndent = (height - _photoHeight) / 2;
					}
				}
				
				var squareWidth:Number = _photoWidth - _photoBorder * 2;
				var squareHeight:Number = _photoHeight - _photoBorder * 2;
				
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
				
				switch (_valign) {
					case VERTICAL_ALIGN_TOP:
						_thumbnail.y = yIndent;
					break;
					case VERTICAL_ALIGN_CENTER:
						_thumbnail.y = yIndent + (_photoHeight - _thumbnail.height) / 2;
						break;
				}
				
				switch (_halign) {
					case HORIZONTAL_ALIGN_LEFT:
						_thumbnail.x = xIndent;
					break;
					case HORIZONTAL_ALIGN_CENTER:
						_thumbnail.x = xIndent + (_photoWidth - _thumbnail.width) / 2;
//						_thumbnail.x = xIndent + (width - _photoBorder*2 - _thumbnail.width) / 2;
						break;
				}
				
				if (_thumbnail.x > xIndent + _photoBorder) _thumbnail.x = xIndent + _photoBorder;
				if (_thumbnail.y > yIndent + _photoBorder) _thumbnail.y = yIndent + _photoBorder;
				
				_thumbnail.mask = _squareMask;
			}
		}
		
		public function get photoWidth():int {
			return (_photoWidth > 0) ? _photoWidth + _photoBorder*2 : width;
		}
		
		public function get photoHeight():int {
			return (_photoHeight > 0) ? _photoHeight + _photoBorder*2 : height;
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