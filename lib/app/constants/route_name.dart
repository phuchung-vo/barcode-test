enum RouteName {
  initial('/'),
  unsupported('/unsupported'),
  login('/login'),
  home('/home'),
  error('/error'),
  profile('/profile'),
  barcode('/barcode'),
  postDetails(':postId');

  const RouteName(this.path);
  final String path;
}
