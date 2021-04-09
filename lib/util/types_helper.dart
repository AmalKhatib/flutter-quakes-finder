/*
* in case we get null values from the API,
* or when an integer value is supposed to be into double or vice versa
* */
class TypeHelper{
  static int toInt(num val){
    try{
      if(val == null){
        return 0;
      }else if(val is int){
        return val;
      }else{
        return val.toInt();
      }
    }catch(error){
      print(error);
      return 0;
    }
  }

  static double toDouble(num val){
    try{
      if(val == null){
        return 0;
      }else if(val is double){
        return val;
      }else{
        return val.toDouble();
      }
    }catch(error){
      print(error);
      return 0;
    }
  }
}