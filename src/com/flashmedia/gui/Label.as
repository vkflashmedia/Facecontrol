package com.flashmedia.gui
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;

	public class Label extends GameObject
	{
		private var _text: String;
		
		public function Label(value: GameScene, text: String = '')
		{
			super(value);
			this.text = text;
		}
		
		public function set text(value: String): void {
			_text = value;
			var tf: TextField = new TextField();
			tf.text = _text;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			textField = tf;
			width = tf.width;
			height = tf.height;
		}
		
		public function get text(): String {
			return _text;
		}
		
		public function set textFormat(value: TextFormat): void {
			_textField.setTextFormat(value);
		}
	}
}