import Button;

class Keypad {
  public var x:Float;
  public var y:Float;
  public var keypad_gaps:Int;
  public var btn_keypad_0:Button;
  public var btn_keypad_1:Button;
  public var btn_keypad_2:Button;
  public var btn_keypad_3:Button;
  public var btn_keypad_4:Button;
  public var btn_keypad_5:Button;
  public var btn_keypad_6:Button;
  public var btn_keypad_7:Button;
  public var btn_keypad_8:Button;
  public var btn_keypad_9:Button;
  public var btn_keypad_C:Button;
  public var btn_keypad_D:Button;
  public var btn_size:Int;
  var buttons = new haxe.ds.Vector<Button>(10);

  function computeButtonPos(index:Int, buttonWidth:Int, spacing:Int):Int {
    return index * buttonWidth + index * spacing;
  }

  public function new(x:Float, y:Float, scene:h2d.Scene, font:h2d.Font) {
    var buttonsMap = [0 => "0",
                      1 => "1",
                      2 => "2",
                      3 => "3",
                      4 => "4",
                      5 => "5",
                      6 => "6",
                      7 => "7",
                      8 => "8",
                      9 => "9",
                      10 => "C",
                      11 => "D"];
    keypad_gaps = 10;
    var keypad_x = x;
    var keypad_y = y;
    btn_size = 120;

    // TODO(michalc): map doesn't seem correct for this.
    var i = 0;
    for (btn in buttonsMap) {
      buttons[i] = new Button(keypad_x + computeButtonPos(0, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(0, btn_size, keypad_gaps), btn_size, btn_size, btn, font, scene);
      i++;
    }

    btn_keypad_0 = new Button(keypad_x + computeButtonPos(0, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(0, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[0], font, scene);
    btn_keypad_1 = new Button(keypad_x + computeButtonPos(1, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(0, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[1], font, scene);
    btn_keypad_2 = new Button(keypad_x + computeButtonPos(2, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(0, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[2], font, scene);

    btn_keypad_3 = new Button(keypad_x + computeButtonPos(0, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(1, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[3], font, scene);
    btn_keypad_4 = new Button(keypad_x + computeButtonPos(1, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(1, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[4], font, scene);
    btn_keypad_5 = new Button(keypad_x + computeButtonPos(2, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(1, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[5], font, scene);

    btn_keypad_6 = new Button(keypad_x + computeButtonPos(0, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(2, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[6], font, scene);
    btn_keypad_7 = new Button(keypad_x + computeButtonPos(1, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(2, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[7], font, scene);
    btn_keypad_8 = new Button(keypad_x + computeButtonPos(2, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(2, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[8], font, scene);

    btn_keypad_D = new Button(keypad_x + computeButtonPos(0, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(3, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[11], font, scene);
    btn_keypad_9 = new Button(keypad_x + computeButtonPos(1, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(3, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[9], font, scene);
    btn_keypad_C = new Button(keypad_x + computeButtonPos(2, btn_size, keypad_gaps),
                              keypad_y + computeButtonPos(3, btn_size, keypad_gaps), btn_size, btn_size, buttonsMap[10], font, scene);
  }
}