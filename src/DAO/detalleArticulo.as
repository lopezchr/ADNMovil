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

	public class detalleArticulo extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var codigo:String;
		
		public function detalleArticulo()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		public function start(str:String):void
		{	
			codigo = str;
			ws.loadWSDL();
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failDetalleArticulo",event.fault.toString()));
		}
		
		protected function wsload(event:LoadEvent):void
		{
			ws.removeEventListener(LoadEvent.LOAD ,wsload);
			
			ws.addEventListener(ResultEvent.RESULT , onresult);
			ws.addEventListener(FaultEvent.FAULT ,wsfault);
			//se genera hash de seguridad
			var hash:String = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,Parametros.IdEmpresa+codigo);
			ws.getDetalleArticulo(Parametros.IdEmpresa, codigo,hash);	
		}
		
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresult);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failDetalleArticulo", res[0][0]));
			}else{
				dispatchEvent(new MadreEvent("readyDetalleArticulo", res));	
			}
		}
	}
}