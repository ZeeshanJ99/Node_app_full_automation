var mongoose = require('mongoose');

var PostSchema = new mongoose.Schema({
  title: String,
  body: String
});

module.exports = mongoose.model('Post', PostSchema);