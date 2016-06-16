$(document).ready(function() {
    // console.log("ready!");
    // console.log(all_camps);
    // $.each(camps, function(key, val){
    //   console.log(key + ": " + val);
    // });
    var base_url = window.location.hostname+":"+window.location.port;
    var url;
    var route1 = "/api/v1/campaigns/";
    var route2 = "/trackers/";

    // var route = "/api/v1/campaigns/"+obj.id+"/trackers/:id/";
    // console.log(String(url));
    var arr = new Array();
    camps.tracker_set.forEach(function (item) {
      arr.push(item);
    })
    console.log(visit_set);

    // arr.forEach(function (item){
    //   url = base_url + route1 + camps.id + route2 + item.id;
    //   console.log(url);
    //   simpleHttpRequest(url, print);
    // });



    // simpleHttpRequest(url+)

});

function simpleHttpRequest(url, success, failure) {
  var request = makeHttpObject();
  request.open("GET", url, true);
  request.send(null);
  request.onreadystatechange = function() {
    if (request.readyState == 4) {
      if (request.status == 200)
        success(request.responseText);
      else if (failure)
        failure(request.status, request.statusText);
    }
  };
}

function makeHttpObject() {
  try {return new XMLHttpRequest();}
  catch (error) {}
  try {return new ActiveXObject("Msxml2.XMLHTTP");}
  catch (error) {}
  try {return new ActiveXObject("Microsoft.XMLHTTP");}
  catch (error) {}

  throw new Error("Could not create HTTP request object.");
}
