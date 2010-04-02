package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends GameObject
	{
		private var _icon: Bitmap;
		private var _tf: TextField;
		private var _text: String;
		
		public function Label(value: GameScene, text: String = '')
		{
			super(value);
			debug = true;
			this.text = text;
		}
		
		public function set icon(value: Bitmap): void {
			if (!value && _icon) {
				removeChild(_icon);
			}
			_icon = value;
			update();
		}
		
		public function set text(value: String): void {
			if (!value && _tf) {
				removeChild(_tf);
			}
			_text = value;
			update();
		}
		
		public function get text(): String {
			return _text;
		}
		
		public function set textFormat(value: TextFormat): void {
			_tf.setTextFormat(value);
		}
		
		private function update(): void {
			var xx: uint = 0;
			var w: uint = 0;
			var h: uint = 0;
			if (_icon) {
				if (!contains(_icon)) {
					addChild(_icon);
				}
				xx += _icon.width;
				w += _icon.width;
				h = _icon.height;
			}
			if (_text) {
				if (!_tf) {
					_tf = new TextField();
				}
				if (!contains(_tf)) {
					addChild(_tf);
				}
				_tf.text = _text;
				_tf.x = xx;
				if (h < _tf.textHeight) {
					h = _tf.textHeight;
				}
				_tf.y = (h - _tf.textHeight) / 2;
				_tf.selectable = false;
				_tf.autoSize = TextFieldAutoSize.LEFT;
				w += _tf.textWidth;
			}
			width = w;
			height = h;
		}
	}
}