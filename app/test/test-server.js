var chai = require('chai');
var chaiHttp = require('chai-http');
var chaiJquery = require('chai-jquery');
var server = require('../app');
var should = chai.should();

chai.use(chaiHttp);

describe('Homepage', function() {
  it('should display the homepage at / GET', function(done) {
    chai.request(server)
      .get('/')
      .end(function(err, res){
        res.should.have.status(200);
        done();
      });
  });
  it('should contain the word Sparta at / GET', function(done) {
    chai.request(server)
      .get('/')
      .end(function(err, res){
        res.text.should.contain('Sparta')
        done();
      });
  });
});

// describe('Blog', function() {
//   it('should display the list of posts at /posts GET', function(done) {
//     chai.request(server)
//       .get('/posts')
//       .end(function(err, res){
//         res.should.have.status(200);
//         done();
//       });
//   });
// });

describe('Fibonacci', function() {
  it('should display the correct fibonacci value at /fibonacci/10 GET', function(done) {
    chai.request(server)
      .get('/fibonacci/10')
      .end(function(err, res){
        res.should.have.status(200);
        res.text.should.contain('55');
        done();
      });
  });
});
