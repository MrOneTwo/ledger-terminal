interface Placeable {
  public var x:Float;
  public var y:Float;
}

class Button implements Placeable {
  public var x:Float;
  public var y:Float;
  public var width:Float;
  public var height:Float;
  public var text_string:String;

  public var interactiveObj:h2d.Interactive;
  public var textObj:h2d.Text;

  public function new(x:Float, y:Float, width:Int, height:Int, text:String, font:h2d.Font, scene:h2d.Scene) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.text_string = text;

    this.interactiveObj = new h2d.Interactive(width, height, scene);
    this.interactiveObj.x = x;
    this.interactiveObj.y = y;
    this.textObj = new h2d.Text(font, this.interactiveObj);
    this.textObj.text = text_string;
    this.textObj.x = (width / 2) - (this.textObj.textWidth / 2);
    this.textObj.y = (height / 2) - (this.textObj.textHeight / 2);
    this.textObj.textColor = 0x000000;
    this.interactiveObj.backgroundColor = 0xEEEEEEEE;
    this.interactiveObj.onOver = function(_) textObj.alpha = 0.5;
    this.interactiveObj.onOut = function(_) textObj.alpha = 1;
    //this.interactiveObj.onClick = this.onClick;
  }
}