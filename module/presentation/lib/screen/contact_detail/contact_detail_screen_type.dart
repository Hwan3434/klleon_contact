sealed class ContactDetailScreenType {
  final String appTitle;
  final String submitButtonText;
  const ContactDetailScreenType({
    required this.appTitle,
    required this.submitButtonText,
  });

  static const loading = Loading();
  static const create = Create();
  static const update = Editor();
}

class Loading extends ContactDetailScreenType {
  const Loading() : super(appTitle: "로딩 중", submitButtonText: "");
}

class Create extends ContactDetailScreenType {
  const Create() : super(appTitle: "생성", submitButtonText: "추가하기");
}

class Editor extends ContactDetailScreenType {
  const Editor() : super(appTitle: "수정", submitButtonText: "수정하기");
}
