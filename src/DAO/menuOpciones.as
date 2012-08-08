package DAO
{
	import com.adobe.crypto.HMAC;
	
	import utils.Parametros;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	
	import utils.Utilidades;


	public class menuOpciones extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		
		public function menuOpciones()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start():void
		{	
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("FAIL_OPCIONES",event.fault.toString()));
			
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT, onResult);
			ws.addEventListener(FaultEvent.FAULT, wsfault);
			//se genera hash de seguridad
			var hash:String = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey,Parametros.UserId+Parametros.IdEmpresa);
			ws.cargarOpciones(Parametros.UserId,Parametros.IdEmpresa,hash);
		}
		
		protected function onResult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT, onResult);
			
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("FAIL_OPCIONES", res[0][0]));
			}else{
				Parametros.Opciones = res;
				dispatchEvent(new Event("SUCCESS_OPCIONES"));	
			}
			
		}
	}
}