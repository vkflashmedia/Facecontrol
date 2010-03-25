package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Button extends GameObject
	{
		public static const STATE_NORMAL:uint = 0;
		public static const STATE_HIGHLIGHTED:uint = 1;
		
		private static const HORIZONTAL_INDENT:uint = 10;
		private static const VERTICAL_INDENT:uint = 5;
		
		protected var _state:uint = STATE_NORMAL;
		
		protected var _normalStateBackgroundColor:uint;
		protected var _highlightedStateBackgroundColor:uint;
		protected var _useHighlightedStateBackgroundColor:Boolean = false;
		
		protected var _normalStateTitle:String = "";
		protected var _highlightedStateTitle:String;
		protected var _useHighlightedStateTitle:Boolean = false;
		
		protected var _normalStateTextFormat:TextFormat;
		protected var _highlightedStateTextFormat:TextFormat;
		protected var _useHighlightedStateTextFormat:Boolean = false;
		
		protected var _normalStateBackgroundImage:Bitmap;
		protected var _useHighlightedStateBackgroundImage:Boolean = true;
		protected var _highlightedStateBackgroundImage:Bitmap;
		
		public function Button(value:GameScene, aX:uint=0, aY:uint=0, aWidth:uint=50, aHeight:uint=20)
		{
			super(value);
			
			this.selectable = true;
			
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			
			this.x = aX;
			this.y = aY;
			this.width = aWidth;
			this.height = aHeight;
			
			setTextFormatForState(new TextFormat("Times New Roman", 12), STATE_NORMAL);
			setBackgroundColorForState(0xa0a0a0, STATE_NORMAL);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
		}
		
		public function setBackgroundImageForState(image:Bitmap, state:uint):void {
			switch (state) {
				case STATE_NORMAL:
					_normalStateBackgroundImage = image;
				break;
				case STATE_HIGHLIGHTED:
					_useHighlightedStateBackgroundImage = true;
					_highlightedStateBackgroundImage = image;
				break;
			}
			update();
		}
		
		public function backgroundImageForState(state:uint):Bitmap {
			switch (state) {
				case STATE_HIGHLIGHTED:
					return _highlightedStateBackgroundImage;
				case STATE_NORMAL:
				default:
					return _normalStateBackgroundImage;
			}
		}
		
		public function setBackgroundColorForState(color:uint, state:uint):void {
			switch (state) {
				case STATE_NORMAL:
					_normalStateBackgroundColor = color;
				break;
				case STATE_HIGHLIGHTED:
					_useHighlightedStateBackgroundColor = true;
					_highlightedStateBackgroundColor = color;
				break;
			}
			update();
		}
		
		public function backgroundColorForState(state:uint):uint {
			switch (state) {
				case STATE_HIGHLIGHTED:
					return _highlightedStateBackgroundColor;
				case STATE_NORMAL:
				default:
					return _normalStateBackgroundColor;
			}
		}
		
		public function setTitleForState(title:String, state:uint):void {
			if (title) {
				var field:TextField = new TextField();
				field.autoSize = TextFieldAutoSize.LEFT;
				var textWidth:uint;
				var textHeight:uint;
						
				switch (state) {
					case STATE_NORMAL:
						_normalStateTitle = title;
						
						field.text = _normalStateTitle;
						field.setTextFormat(_normalStateTextFormat);
					break;
					case STATE_HIGHLIGHTED:
						_useHighlightedStateTitle = true;
						_highlightedStateTitle = title;
						
						field.text = _highlightedStateTitle;
						field.setTextFormat(_highlightedStateTextFormat);
					break;
				}
				
				textWidth = field.width + HORIZONTAL_INDENT*2;
				textHeight = field.height + VERTICAL_INDENT*2;
				
				if (width < textWidth) width = textWidth;
				if (height < textHeight) height = textHeight;
				field = null;
				
				update();
			}
		}
		
		public function titleForState(state:uint):String {
			switch (state) {
				case STATE_HIGHLIGHTED:
					return _highlightedStateTitle;
				case STATE_NORMAL:
				default:
					return _normalStateTitle;
			}
		}
		
		public function setTextFormatForState(format:TextFormat, state:uint):void {
			switch (state) {
				case STATE_NORMAL:
					autoSize = true;
					_normalStateTextFormat = format;
				break;
				case STATE_HIGHLIGHTED:
					_useHighlightedStateTextFormat = true;
					_highlightedStateTextFormat = format;
				break;
			}
			update();
		}
		
		public function textFormatForState(state:uint):TextFormat {
			switch (state) {
				case STATE_HIGHLIGHTED:
					return _highlightedStateTextFormat;
				case STATE_NORMAL:
				default:
					return _normalStateTextFormat;
			}
		}
		
		private function update():void {
			switch (_state) {
				case STATE_NORMAL:
//					if (_normalStateBackgroundImage) {
						bitmap = _normalStateBackgroundImage;
//					}
//					else {
//						fillBackground(_normalStateBackgroundColor, 1.0);
//					}
					
					textField.text = _normalStateTitle;
					textField.setTextFormat(_normalStateTextFormat);
				break;
				case STATE_HIGHLIGHTED:
					if (_highlightedStateBackgroundImage || _normalStateBackgroundImage) {
						if (_useHighlightedStateBackgroundImage) {
							bitmap = _highlightedStateBackgroundImage;
						}
						else {
							bitmap = _normalStateBackgroundImage;
						}
					}
					else {
						if (_useHighlightedStateBackgroundColor) {
							fillBackground(_highlightedStateBackgroundColor, 1.0);
						}
						else {
							fillBackground(_normalStateBackgroundColor, 1.0);
						}
					}
					
					textField.text = (_useHighlightedStateTitle) ? _highlightedStateTitle : _normalStateTitle;
					textField.setTextFormat((_useHighlightedStateTextFormat) ? _highlightedStateTextFormat : _normalStateTextFormat);
				break;
			}
			
			textHorizontalAlign = HORIZONTAL_ALIGN_CENTER;
			textVerticalAlign = VERTICAL_ALIGN_CENTER;
		}
		
		protected function mouseDownListener(event: MouseEvent): void {
			_state = STATE_HIGHLIGHTED;
			update();
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			_state = STATE_NORMAL;
			update();
		}
		
		protected function mouseUpListener(event: MouseEvent): void {
			_state = STATE_NORMAL;
			update();
		}

		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			_state = STATE_NORMAL;
			update();
		}
	}
}