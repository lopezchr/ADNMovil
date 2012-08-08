package DAO
{
	import com.adobe.crypto.HMAC;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	import utils.MadreEvent;
	import utils.Parametros;
	import utils.Utilidades;

	public class factTotales extends EventDispatcher
	{
		private var ws:WebService = new WebService;
		private var hash:String;
		
		public function factTotales()
		{
			ws.wsdl = Parametros.WsdlDoc;
			ws.addEventListener(LoadEvent.LOAD ,wsload);
			ws.addEventListener(FaultEvent.FAULT , wsfault);
		}
		
		protected function wsfault(event:FaultEvent):void
		{
			dispatchEvent(new MadreEvent("failTotales",event.fault.toString()));
		}
		
		public function start():void
		{
			ws.loadWSDL();
		}
		
		protected function wsload(event:LoadEvent):void{
			ws.addEventListener(ResultEvent.RESULT , onresult);
			
			var d:Date = new Date;
			var strdate:String = Utilidades.dateToChain(d) + d.hours + d.minutes;
			
			var params:Object = Parametros.paramsFact;
			
			var Cadena:String = "<doc:"+Parametros.mobileid+"><enc>";
			Cadena += "<tdc:"+ params.tdoc.id +">";
			Cadena += "<sis:"+ Parametros.IdSistema +">";
			Cadena += "<usr:"+ Parametros.UserId +">";
			Cadena += "<cli:"+ params.cliente.id +">";
			Cadena += "<fch:"+ strdate +">";
			Cadena += "<pre:"+ params.lprecios.id +">";
			Cadena += "<cso:"+ params.ccosto.id +">";
			Cadena += "<enc/>";
			
			var cont:Number = 0;
			for each(var item:Object in Parametros.listaItemsFactura){
				Cadena += "<itm:"+cont+">";
				
				Cadena += "<id:"+item.id +">";
				Cadena += "<can:"+item.cantidad+">";
				Cadena += "<vun:"+item.valoru+">";
				Cadena += "<dst:"+item.descuento+">";
				//Cadena += "<"+item.idgrav+"$&"+item.bodega.id+"|";
				
				Cadena += "<itm:"+cont+"/>"
				cont ++;
			}
			Cadena += "<doc:"+Parametros.mobileid+"/>";
						
			var p:String = Parametros.Login+Parametros.Pass+Parametros.Empresa+Parametros.mobileid+Cadena;
			
			//ws.addEventListener(FaultEvent.FAULT ,wsfault);
			//se genera hash de seguridad
			hash = com.adobe.crypto.HMAC.hash("docRegisterKey" , p);
			
			ws.setDocument(Parametros.Login, Parametros.Pass, Parametros.Empresa, Parametros.mobileid, Cadena,hash);
		}
		protected function onresult(event:ResultEvent):void
		{
			ws.removeEventListener(ResultEvent.RESULT ,onresult);
			var res:Array = Utilidades.chainToArray(event.result.toString().substr(0,-2));
			
			if(res[0][0].toString().indexOf("Error")>=0){
				dispatchEvent(new MadreEvent("failTotales", "El proceso no fue efectivo."));
			}else{
				
				dispatchEvent(new MadreEvent("readyTotales",res));
			}
		}
	}
}