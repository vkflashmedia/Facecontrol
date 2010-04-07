package com.flashmedia.gui
{
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class LinkButton extends GameObject
	{
//		private var _textField:TextField = new TextField();
		
		protected var _baseTextFormat:TextFormat = new TextFormat();
		protected var _overTextFormat:TextFormat = new TextFormat();
		protected var _downTextFormat:TextFormat = new TextFormat();
		
		private var _textFormat:TextFormat;
		protected var _enabled:Boolean = true;
		
		public function LinkButton(scene:GameScene, text:String=null, x:uint=0, y:uint=0, width:uint=0)
		{
			super(scene);
			setTextStyle();
			setOverTextStyle();
			setDownTextStyle();
			_textFormat = _baseTextFormat;
			
			var tf: TextField = new TextField();
			tf.defaultTextFormat = _textFormat;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			tf.mouseEnabled = false;
			setTextField(tf);
//			_textField.defaultTextFormat = _textFormat;
//			_textField.autoSize = TextFieldAutoSize.LEFT;
//			_textField.selectable = false;
//			_textField.mouseEnabled = false;
//			addChild(_textField);
			
			this.setSelect(true);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = _textField.height;
			this.label = text;
			
			buttonMode = true;
			useHandCursor = true;
		}
		
		private function update():void {
			if (_textField.wordWrap) {
				_textField.width = width;
			}
			else {
				width = _textField.width;
			}
			height = _textField.height;
		}
		
		public function set enabled(enable:Boolean):void {
			_enabled = enable;
			buttonMode = _enabled;
			useHandCursor = _enabled;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public override function set width(value: Number):void {
			super.width = value;
			if (textField && textField.wordWrap) update();
		}
		
		public override function destroy(): void {
			super.destroy();
			//removeChild(_textField);
		}
		
		public function set wordWrap(wrap:Boolean): void {
			//_textField.wordWrap = wrap;
			textField.wordWrap = wrap;
			update();
		}
		
		public function get label():String {
			//return _textField.text;
			return textField.text;
		}
		
		public function set label(text:String):void {
//			var format:TextFormat = _textField.getTextFormat();
//			_textField.text = text;
//			_textField.setTextFormat(format);
//			update();
			var format:TextFormat = textField.getTextFormat();
			textField.text = text;
			textField.setTextFormat(format);
			update();
		}
		
		public function setTextStyle(color:uint=0, size:uint=12, font:String="Arial", bold:Boolean=false, italic:Boolean=false, underline:Boolean=true):void {
			_baseTextFormat.color = color;
			_baseTextFormat.size = size;
			_baseTextFormat.font = font;
			_baseTextFormat.bold = bold;
			_baseTextFormat.italic = italic;
			_baseTextFormat.underline = underline;
		}
		
		public function setOverTextStyle(color:uint=0x0000ff, size:uint=12, font:String="Arial", bold:Boolean=false, italic:Boolean=false, underline:Boolean=true):void {
			_overTextFormat.color = color;
			_overTextFormat.size = size;
			_overTextFormat.font = font;
			_overTextFormat.bold = bold;
			_overTextFormat.italic = italic;
			_overTextFormat.underline = underline;
		}
		
		public function setDownTextStyle(color:uint=0, size:uint=12, font:String="Arial", bold:Boolean=false, italic:Boolean=false, underline:Boolean=true):void {
			_downTextFormat.color = color;
			_downTextFormat.size = size;
			_downTextFormat.font = font;
			_downTextFormat.bold = bold;
			_downTextFormat.italic = italic;
			_downTextFormat.underline = underline;
		}
		
		public function setUnderline(underline:Boolean):void {
//			var format:TextFormat = _textField.getTextFormat();
//			format.underline = _baseTextFormat.underline = _overTextFormat.underline = _downTextFormat.underline = underline;
//			_textField.setTextFormat(format);
			var format:TextFormat = textField.getTextFormat();
			format.underline = _baseTextFormat.underline = _overTextFormat.underline = _downTextFormat.underline = underline;
			textField.setTextFormat(format);
		}
		
		public function setBold(bold:Boolean):void {
			_baseTextFormat.bold = _overTextFormat.bold = _downTextFormat.bold = bold;
		}
		
		protected override function mouseOverListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			if (_enabled) {
				//_textField.setTextFormat(_overTextFormat);
				textField.setTextFormat(_overTextFormat);
				update();
			}
		}
		
		protected override function mouseOutListener(event: MouseEvent): void {
			super.mouseOutListener(event);
			if (_enabled) {
				//_textField.setTextFormat(_textFormat);
				textField.setTextFormat(_textFormat);
				update();
			}
		}
		
		protected override function mouseClickListener(event: MouseEvent): void {
			super.mouseClickListener(event);
			if (_enabled) {
				_textFormat = _downTextFormat;
				update();
			}
		}
		
		public function get intVal():int // Used in Pagination, for example
	    {
			if (label == "«") return 1;
			if (label == "»") return -1;
			return parseInt(label);
	    }
	}
}