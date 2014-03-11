var title;

title = document.title.split(' | ');

switch (title[1]) {
  case void 0:
    $('#home').addClass('active');
    break;
  case 'Archive':
    $('#archive').addClass('active');
    break;
  case 'Team':
    $('#team').addClass('active');
}
