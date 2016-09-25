# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('body').on 'click', 'a.edit-comment-link', (e) ->
    e.preventDefault();
    comment_id = $(this).data('commentId')
    $('form#edit-comment-' + comment_id).toggle()

$ ->
  $('body').on 'click', 'a.new-comment-link', (e) ->
    e.preventDefault();
    commentable_type = $(this).data('commentableType')
    commentable_id = $(this).data('commentableId')
    $('form#add-comment-' + commentable_type + '-' +commentable_id).toggle()