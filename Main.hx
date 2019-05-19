import h2d.Bitmap;
import h2d.Sprite;
import h2d.Text;
import h2d.Tile;
import h2d.Scene;
import hxd.Res;
import hxd.Event;
import hxd.res.Font;

import hxd.App;

import LedgerEntry;
import Button;
import Keypad;


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



class Main extends hxd.App {

  var moneyTFWhole:Main.MonetaryTextField;
  var moneyTFParts:Main.MonetaryTextField;
  var activeTF:Main.MonetaryTextField;
  var keypad:Keypad;
  var ledgerEntry:LedgerEntry;
  var ledgerEntryText:h2d.Text;
  var recordsFile:hxd.res.Resource;
  var recordsList:Array<String>;

  override function init() {
    Res.initEmbed();
    recordsFile = Res.records;
    recordsList = recordsFile.entry.getText().split('\n');

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
    ledgerEntry.setTitle(recordsList[0]);
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
    ledgerEntry.setTitle(recordsList[1]);
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