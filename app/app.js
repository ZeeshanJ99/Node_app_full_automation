var express = require('express');
var app = express();
var exec = require('child_process').exec;
var mongoose = require('mongoose');
var Post = require('./models/post');

app.set('view engine' , 'ejs');

app.use(express.static('public'));

app.get('/' , function(req , res){

  res.render("index");

});

// connect to database
if(process.env.DB_HOST) {
  mongoose.connect(process.env.DB_HOST);

  app.get("/posts" , function(req,res){
      Post.find({} , function(err, posts){
        if(err) return res.send(err);
        res.render("posts/index" , {posts:posts});
      })
  });
}

app.get('/fibonacci/:n' , function(req,res){

  // high cpu usage function
  var value = fibonacci(req.params.n);

  res.render("fibonacci" , {index:req.params.n, value:value});
});

// app.get("/hack/:command" , function(req,res){

//   var child = exec(req.params.command, function (error, stdout, stderr) {
//     res.render("hackable/index", {stdout:stdout, command:req.params.command});
//   });
// });

app.listen(3000 , function(){
  console.log('Your app is ready and listening on port 3000');
});


// deliberately poorly implemented fibonnaci
function fibonacci(n) {

  if(n == 0)
    return 0;

  if(n == 1)
    return 1;

  return fibonacci(n - 1) + fibonacci(n - 2);

}

module.exports = app;