title = document.title.split(' | ')

switch title[1]
  when undefined then $('#home').addClass('active')
  when 'Archive' then $('#archive').addClass('active')
  when 'Team' then $('#team').addClass('active')
