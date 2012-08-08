package DAO
{
	import com.adobe.crypto.HMAC;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	import utils.Parametros;
	import utils.Utilidades;

	public class reciboParams extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var hash:String;
		
		
		public function reciboParams()
		{
			ws.wsdl = Parametros.Wsdl;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failFactParams",event.fault.toString()));
		}
		
		public function validateData():void
		{
			
			ws.loadWSDL();
		}
		
		protected function wsload(event:LoadEvent):void{
			ws.addEventListener(ResultEvent.RESULT , onresultTdoc);
			
			var params:Object = Parametros.paramsFact;
			
			var codtdoc:String = params.tdoc.cod;
			var codclient:String = params.cliente.cod;
			var codccosto:String = params.ccosto.cod;
			var idbodega:String = params.bodega.id;
			var idvendedor:String = params.vendedor.id;
			var idlprecios:String = params.lprecios.id;
			
			var phash:String = Parametros.IdEmpresa+Parametros.IdSistema+codtdoc+codclient+codccosto+idbodega+idvendedor+idlprecios;
			//se genera hash de seguridad
			hash = com.adobe.crypto.HMAC.hash(Parametros.SecurutyKey ,phash);
			
			ws.factValidateData(Parametros.IdEmpresa,Parametros.IdSistema,codtdoc,codclient,codccosto,idbodega,idvendedor,idlprecios,hash);
		}
		
		protected function onresultTdoc(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresultTdoc);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failFactParams", "La consulta no fue efectiva.t"));
			}else{
				
				dispatchEvent(new MadreEvent("readyFactParams",res));
			}
		}
	}
}