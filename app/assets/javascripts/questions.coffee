# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $('#votable-' + votable.votable_type + '-total-' + votable.votable_id).html( votable.total )

  if votable.user_voted
    $('#votable-already-links-' + votable.votable_id).removeClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).addClass('hidden')
  else
    $('#votable-already-links-' + votable.votable_id).addClass('hidden')
    $('#votable-not-yet-links-' + votable.votable_id).removeClass('hidden')

createQuestion = (question) ->
  $('.questions').append('<h4><a href="/questions/'+question.id+'">' + question.title + '</a></h4>')
  $('.questions').append('<p>'+ question.content + '</p>')

$(document).ready ->
  $(document).on('ajax:success', '.voting', voting)

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    createQuestion(question)
