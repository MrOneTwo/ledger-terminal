import h2d.Bitmap;
import h2d.Sprite;
import h2d.Text;
import h2d.Tile;
import h2d.Scene;
import hxd.Res;
import hxd.Event;
import hxd.res.Font;

import hxd.App;

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

class TextField {
  public var label:h2d.Text;
  public var interactiveObj:h2d.Interactive;
  public var x:Float;
  public var y:Float;
  private var horizontalBackgroundPadding:Int;
  private var verticalBackgroundPadding:Int;
  private var hot:Bool;

  public function new(x:Float, y:Float, scene:h2d.Scene, font:h2d.Font) {
    this.x = x;
    this.y = y;
    this.horizontalBackgroundPadding = 30;
    this.verticalBackgroundPadding = 10;
    this.hot = false;

    // TODO(michalc): probably shouldn't pass the scene as the parent
    this.label = new h2d.Text(font, scene);
    this.interactiveObj = new h2d.Interactive(this.label.textWidth, this.label.textHeight, scene);

    this.label.x = this.x;
    this.label.y = this.y;

    this.interactiveObj.backgroundColor = 0x77777777;

    this.interactiveObj.width = this.label.textWidth;
    this.interactiveObj.height = this.label.textHeight;
    this.interactiveObj.x = this.x;
    this.interactiveObj.y = this.y;

    // Padding.
    /*
    this.interactiveObj.width += 2 * this.horizontalBackgroundPadding;
    this.interactiveObj.height += 2 * this.verticalBackgroundPadding;
    this.interactiveObj.x -= this.horizontalBackgroundPadding;
    this.interactiveObj.y -= this.verticalBackgroundPadding;
    */
  }

  public function updateTransform() {
    var previousInteractiveWidth = this.interactiveObj.width;

    // Match the interactive size around the text.
    this.interactiveObj.width = this.label.textWidth;
    this.interactiveObj.height = this.label.textHeight;

    // Expand the text field to the left.
    this.interactiveObj.x -= (this.interactiveObj.width - previousInteractiveWidth);
    this.label.x -= (this.interactiveObj.width - previousInteractiveWidth);

    // Padding.
    /*
    this.interactiveObj.width += 2 * this.horizontalBackgroundPadding;
    this.interactiveObj.height += 2 * this.verticalBackgroundPadding;
    this.interactiveObj.x -= this.horizontalBackgroundPadding;
    this.interactiveObj.y -= this.verticalBackgroundPadding;
    */
  }

  public function setHot() {
    if (this.hot == false)
    {
      this.interactiveObj.backgroundColor += 0x22222222;
      this.hot = true;
    }
  }

  public function setCold() {
    if (this.hot == true)
    {
      this.interactiveObj.backgroundColor -= 0x22222222;
      this.hot = false;
    }
  }
}

class MonetaryTextField extends TextField {
  public var whole:Int;
  public var wrapLimit:Int;

  public function new(x:Float, y:Float, scene:h2d.Scene, font:h2d.Font) {
    // TODO(michalc): probably shouldn't pass the scene as the parent
    super(x, y, scene, font);
    wrapLimit = 0;
  }

  public function setValue(value:Int) {
    this.whole = value;
    if (value == 0) {
      this.label.text = "00";
    }
    else {
      this.label.text = '${this.whole}';
    }
    this.updateTransform();
  }

  public function addValue(value:Int) {
    this.whole = this.whole * 10;
    this.whole += value;

    if (wrapLimit > 0) {
      if (this.whole > wrapLimit) {
        this.whole = this.whole % wrapLimit;
      }
    }

    this.label.text = '${this.whole}';
    this.updateTransform();
  }
}

class Keypad {
  public var x:Float;
  public var y:Float;
  public var keypad_gaps:Int;
  public var btn_keypad_0:Main.Button;
  public var btn_keypad_1:Main.Button;
  public var btn_keypad_2:Main.Button;
  public var btn_keypad_3:Main.Button;
  public var btn_keypad_4:Main.Button;
  public var btn_keypad_5:Main.Button;
  public var btn_keypad_6:Main.Button;
  public var btn_keypad_7:Main.Button;
  public var btn_keypad_8:Main.Button;
  public var btn_keypad_9:Main.Button;
  public var btn_keypad_C:Main.Button;
  public var btn_keypad_D:Main.Button;
  public var btn_size:Int;
  var buttons = new haxe.ds.Vector<Main.Button>(10);

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

class LedgerEntry {
  var content:String;
  var moneyValue:Float;
  var date:Date;
  var title:String;
  var sourceAccount:String;
  var destinationAccount:String;
  var currency:String;

  public function new() {
    date = Date.now();
    title = "Title of the entry...";
    moneyValue = 0.0;
    currency = "SEK";
    sourceAccount = "Assets:SEK";
    destinationAccount = "Expenses:Food:Work";
    updateContent();
  }

  function updateContent() {
    var contentLine0 = '${date.getFullYear()}/${date.getMonth()}/${date.getDay()} * ${title}\n';
    var contentLine1 = StringTools.rpad('${sourceAccount}', " ", 43) + '-${moneyValue} ${currency}' + "\n";
    var contentLine2 = StringTools.rpad('${destinationAccount}', " ", 44) + '${moneyValue} ${currency}' + "\n";
    content =  contentLine0 + contentLine1 + contentLine2;
  }

  public function setMoneyValue (value: Float) {
    moneyValue = value;
    updateContent();
  }

  public function setDate (value: Date) {
    date = value;
    updateContent();
  }

  public function setTitle (value: String) {
    title = value;
    updateContent();
  }

  public function setSourceAccount (value: String) {
    sourceAccount = value;
    updateContent();
  }

  public function setDestinationAccount (value: String) {
    destinationAccount = value;
    updateContent();
  }

  public function getContent() {
    return content;
  }
}


class Main extends hxd.App {

  var moneyTFWhole:Main.MonetaryTextField;
  var moneyTFParts:Main.MonetaryTextField;
  var activeTF:Main.MonetaryTextField;
  var keypad:Main.Keypad;
  var ledgerEntry:LedgerEntry;
  var ledgerEntryText:h2d.Text;

  override function init() {
    Res.initEmbed();

    var font42 = Res.instruction.build(42);
    var font56 = Res.instruction.build(56);

    moneyTFWhole = new MonetaryTextField(400.0, 300.0, s2d, font56);
    moneyTFWhole.setValue(1);
    moneyTFParts = new MonetaryTextField(520.0, 300.0, s2d, font56);
    moneyTFParts.setValue(0);
    moneyTFWhole.interactiveObj.onClick = onClickTFWhole;
    moneyTFParts.interactiveObj.onClick = onClickTFParts;
    moneyTFParts.wrapLimit = 100;

    keypad = new Keypad(1400, 160, s2d, font42);

    activeTF = moneyTFWhole;
    activeTF.setHot();

    ledgerEntry = new LedgerEntry();
    ledgerEntryText = new h2d.Text(font42, s2d);
    ledgerEntryText.x = 100;
    ledgerEntryText.y = 700;
    ledgerEntryText.text = ledgerEntry.getContent();

    keypad.btn_keypad_0.interactiveObj.onClick = onClickCallback0;
    keypad.btn_keypad_1.interactiveObj.onClick = onClickCallback1;
    keypad.btn_keypad_2.interactiveObj.onClick = onClickCallback2;
    keypad.btn_keypad_3.interactiveObj.onClick = onClickCallback3;
    keypad.btn_keypad_4.interactiveObj.onClick = onClickCallback4;
    keypad.btn_keypad_5.interactiveObj.onClick = onClickCallback5;
    keypad.btn_keypad_6.interactiveObj.onClick = onClickCallback6;
    keypad.btn_keypad_7.interactiveObj.onClick = onClickCallback7;
    keypad.btn_keypad_8.interactiveObj.onClick = onClickCallback8;
    keypad.btn_keypad_D.interactiveObj.onClick = onClickCallbackD;
    keypad.btn_keypad_9.interactiveObj.onClick = onClickCallback9;
    keypad.btn_keypad_C.interactiveObj.onClick = onClickCallbackC;
  }

  function onClickTFWhole(e:hxd.Event):Void {
    moneyTFParts.setCold();
    moneyTFWhole.setHot();
    activeTF = moneyTFWhole;
  }

  function onClickTFParts(e:hxd.Event):Void {
    moneyTFWhole.setCold();
    moneyTFParts.setHot();
    activeTF = moneyTFParts;
  }

  function onClickCallback0(e:hxd.Event):Void {
    activeTF.addValue(0);
  }

  function onClickCallback1(e:hxd.Event):Void {
    activeTF.addValue(1);
  }

  function onClickCallback2(e:hxd.Event):Void {
    activeTF.addValue(2);
  }

  function onClickCallback3(e:hxd.Event):Void {
    activeTF.addValue(3);
  }

  function onClickCallback4(e:hxd.Event):Void {
    activeTF.addValue(4);
  }

  function onClickCallback5(e:hxd.Event):Void {
    activeTF.addValue(5);
  }

  function onClickCallback6(e:hxd.Event):Void {
    activeTF.addValue(6);
  }

  function onClickCallback7(e:hxd.Event):Void {
    activeTF.addValue(7);
  }

  function onClickCallback8(e:hxd.Event):Void {
    activeTF.addValue(8);
  }

  function onClickCallback9(e:hxd.Event):Void {
    activeTF.addValue(9);
  }

  function onClickCallbackC(e:hxd.Event):Void {
    activeTF.setValue(0);
  }

  function onClickCallbackD(e:hxd.Event):Void {
    var whole:Float = moneyTFWhole.whole;
    var parts:Float = moneyTFParts.whole / 100.0;
    ledgerEntry.setMoneyValue(whole + parts);
    ledgerEntry.setDate(Date.now());
    ledgerEntry.setTitle("Hangingout with chumps...");
    ledgerEntry.setSourceAccount("Assets:SEK");
    ledgerEntry.setDestinationAccount("Expenses:Pleasures");
    ledgerEntryText.text = ledgerEntry.getContent();
  }

  // if we the window has been resized
  override function onResize() {
    // center our object
    //obj.x = Std.int(s2d.width / 2);
    //obj.y = Std.int(s2d.height / 2);

    // move our text up/down accordingly
    //if( tf != null ) tf.y = s2d.height - 80;
  }

  override function update(dt:Float) {

  }

  static function main() {
    new Main();
  }
}