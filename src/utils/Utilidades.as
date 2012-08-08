package utils
{

	public class Utilidades
	{
		//metodo que convierte una cadena de caracteres provenientes del servidor en un arreglo
		public static function chainToArray(text:String):Array{
			
			trace("total datos: "+text.length);
			
			var finalArray:Array = new Array();
			
			var arrayobjets:Array = text.split("@#")
			for each(var item:Object in arrayobjets){
				var itemArray:Array = item.toString().split("|");
				finalArray.push(itemArray);
			}
			
			//si la longitud de la cadena es mayor que 3990 posiblemente estara icompleta
			if(text.length > 19000){
				//se elimina el ultimo registro y se agrega marca de error
				finalArray.pop();
				finalArray.push(["$$INCOMPLETEDATA"]);
				writeLog("longitud Recibida: "+text.length);
			}
			writeLog("longDataR: "+text.length);
			
			return finalArray;
		}
		
		//funcion que permite validar una respuesta del servidor
		public static function validateAnswer(chain:String):Boolean{
			if(chain == "''"){
				return false;
			}else{
				return true;
			}
		}
		
		//funcion que convierte un dato tipo date en una cadena de caracteres que lo representa
		public static function dateToChain(sdate:Date):String{
			var day:String;
			var month:String;
			
			if(sdate.date < 10){
				day = "0"+sdate.date.toString();
			}else{
				day = sdate.date.toString();
			}
			if(sdate.month<10){
				month = "0"+ sdate.month.toString();
			}else{
				month = (sdate.month+1).toString();
			}
			
			return day+month+sdate.fullYear.toString();
		}
		
		//funcion que escribe en el log de la aplicacion
		public static function writeLog(str:String):void{
			var fecha:Date = new Date;
			Parametros.listLog.addItem({date:fecha.toString(),detail:str});
		}
	}
}