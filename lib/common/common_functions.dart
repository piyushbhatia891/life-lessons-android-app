class CommonFunctions{
  static String getSubjectValueInCamelCase(String val){
    if(!val.contains(" "))
      return val[0].toUpperCase()+val.substring(1);
    var varList=val.split("");
    String result="";
    for(var item in varList){
      result=result+item[0].toUpperCase()+item.substring(1);
    }
    return result;

  }

}