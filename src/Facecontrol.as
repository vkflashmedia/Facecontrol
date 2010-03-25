package {
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.MessageBox;
	import com.flashmedia.gui.Pagination;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.text.TextField;

	public class Facecontrol extends GameScene {
		private var textField: TextField = new TextField();
		private var p:Pagination;
		private var linkButton:LinkButton;
		
		public function Facecontrol() {
			linkButton = new LinkButton(this, "My link button", 0, 0, 50);
			addChild(linkButton);
			linkButton.wordWrap = true;
			linkButton.label = "This is my first label";
			
			p = new Pagination(this, 100, 0, 10, 1);
			addChild(p);
			
			p.addEventListener(Event.CHANGE, changeListener);
			
//			var ldr:Loader = new Loader();
////			ldr.mask = rect;
//			var url:String = "02.png";
//			var urlReq:URLRequest = new URLRequest(url);
//			ldr.load(urlReq);
//			var bitmap:Bitmap = Bitmap(ldr.content);

			var myBitmapDataObject:BitmapData = new BitmapData(150, 150, false, 0x80FF3300); 
			var bitmap:Bitmap = new Bitmap(myBitmapDataObject); 
//			addChild(bitmap);
			
			var b:Button = new Button(this, 50, 50);
			b.setTitleForState("Button", Button.STATE_NORMAL);
			addChild(b);
			b.setBackgroundImageForState(bitmap, Button.STATE_NORMAL);
			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClicked);
		}
		
		private function onButtonClicked(e: GameObjectEvent): void {
			var cancelButton:Button = new Button(this);
			cancelButton.x = 40;
			cancelButton.y = 50;
			cancelButton.width = 50;
			cancelButton.setTitleForState("Ok", Button.STATE_NORMAL);
			
			var otherButton:Button = new Button(this);
			otherButton.x = 110;
			otherButton.y = 50;
			otherButton.width = 50;
			otherButton.setTitleForState("Other", Button.STATE_NORMAL);
			var msg: MessageBox = new MessageBox(this, "Message", cancelButton, otherButton);
			msg.show();
		}
		
		private function changeListener(e:Event):void {
			p.clear();
			p.update();
//			linkButton.label = "change";
		}
		
		private function request():void {
			this.addChild(textField);
			var api:Api = new Api(textField);
			api.addEventListener(ApiEvent.ERROR, onError);
			api.addEventListener(ApiEvent.COMPLETED, onCompleted);
			
			api.registerUser(1, "test1", "test3", null, 0, null, 1);
		}
		
		public function onError(e:ApiEvent):void {
			textField.text = "error";
		}
		
		public function onCompleted(e:ApiEvent):void {
			var response:Object = e.response;
			try {
				textField.text = response["method"];
			}
			catch (e:Error) {
				textField.text = e.message;
			}
		}
	}
}
