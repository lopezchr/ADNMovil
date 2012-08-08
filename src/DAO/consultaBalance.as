package DAO
{
	import utils.Parametros;
	import com.adobe.crypto.HMAC;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	
	import utils.Utilidades;
	import flash.events.Event;
	
	public class consultaBalance extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var inputFilter:String;
		private var dateChain:String;
		
		public function consultaBalance()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String,date:String):void
		{
			dateChain = date;
			inputFilter = str;
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failBalance",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			
			//se genera hash de seguridad
			var hash:String = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+inputFilter+Parametros.IdSistema+dateChain);
			ws.getBalance(Parametros.IdEmpresa, inputFilter, Parametros.IdSistema,dateChain, hash);	
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT, onresult);
			
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failBalance", "La consulta no fue efectiva."));
			}else{
				Parametros.ListaBalance = res;
				dispatchEvent(new Event("readyBalance"));
			}
			
			
		}
	}
}