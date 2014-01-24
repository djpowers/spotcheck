// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

//= require pickadate/picker
//= require pickadate/picker.date
//= require pickadate/picker.time

$(function(){

  $(document).foundation();
    $('.datepicker').pickadate();
    $('.timepicker').pickatime()

    var video = document.getElementsByTagName("video")[0];
    var pop = Popcorn(video);
    $('.start_link').on('click', function(e) {
      console.log('click');
      e.preventDefault();
      var target = $(e.target);
      var time = target.data('start-time')
      var endTime = target.data('end-time')
      console.log(time);
      pop.currentTime(time).play();
      pop.cue(endTime, function(){
        this.pause();
      })
    });

});

