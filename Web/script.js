/*jslint browser: true*/
/*global $, jQuery, alert*/


$(document).ready(function() {
    "use strict";


    var myFirebaseRef = new Firebase("https://lazyapp.firebaseio.com/");

    myFirebaseRef.child("workTime").child("totalTime").on("value", function(snapshot) {
        $(".work").html(snapshot.val().toFixed(2));
    });
    
    myFirebaseRef.child("wasteTime").child("totalTime").on("value", function(snapshot) {
        $(".waste").html(snapshot.val().toFixed(2));
    });
});