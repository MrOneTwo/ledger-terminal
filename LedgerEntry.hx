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
    var day = date.getDay();
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
