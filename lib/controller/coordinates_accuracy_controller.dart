class CoordinatesController{
  String removeLastCharacter(String str) {
    String result='';
    if ((str != null) && (str.isNotEmpty)) {
      return result = str.substring(0, str.length- 4);
    }
    return result;
  }
  longLatFirstThreeDigitsAfterDecimal(coordinates){
    String strCoordinate=coordinates.toString();
     var myDouble = double.parse(removeLastCharacter(strCoordinate));
    assert(myDouble is double);
    return myDouble;
  } //to control accurate
}
