# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('body').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).toggle()
    