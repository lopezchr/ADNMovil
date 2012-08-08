package DAO
{
	import com.adobe.crypto.HMAC;
	
	import utils.Parametros;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.mxml.WebService;
	
	import utils.MadreEvent;
	
	import utils.Utilidades;


	public class consultaCartera extends EventDispatcher
	{
		
		private var inputFilter:String;
		
		private var ws:WebService = new WebService;
		private var hash:String;
		
		public function consultaCartera()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String):void
		{	
			inputFilter = str;
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failCartera",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			//se genera hash de seguridad
			hash = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+Parametros.IdSistema);
			
			ws.cosultaCartera(Parametros.IdEmpresa, inputFilter, Parametros.IdSistema, hash);
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresult);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failCartera", "La consulta no fue efectiva."));
			}else{
				//se regitran los datos de la consulta
				Parametros.ListaCartera = res;
				
				ws.addEventListener(ResultEvent.RESULT , onresultcount);;
				
				ws.cosultaTotalCartera(Parametros.IdEmpresa, inputFilter, Parametros.IdSistema, hash);		
			}	
		}
		
		protected function onresultcount(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresultcount);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failCartera", "La consulta no fue efectiva.t"));
			}else{
				
				dispatchEvent(new MadreEvent("readyCartera",res));
			}
		}
	}
}