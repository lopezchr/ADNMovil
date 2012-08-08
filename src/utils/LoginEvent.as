package utils
{
	import flash.events.Event;

	public class LoginEvent extends Event
	{
		public var obj:String;
		public function LoginEvent(type:String, objeto:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			obj = objeto;
			super(type);
		}
		
	}
}