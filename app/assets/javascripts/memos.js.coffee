$ ->
  $('#memos')
    .on 'click', '.edit, .cancel', (event) ->
      toggleEditor $(this).closest('.memo')

toggleEditor = ($container) ->
  $container.find('.viewer, .editor').toggle()
  $bodyField = $container.find('.editor .body')
  if $bodyField.is(':visible')
    $bodyField
      .val($container.find('.viewer .body').text())
      .select()