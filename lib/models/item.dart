class Item {
  final String key;
  bool checked;
  final String title;
  final String subTitle;

  Item({
    this.key,
    this.checked,
    this.title,
    this.subTitle,
  });

  String toString() => key;
}
