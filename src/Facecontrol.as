package {
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.Pagination;
	
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
			
			var b:Button = new Button(this, "Button", 50, 50);
			addChild(b);
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
