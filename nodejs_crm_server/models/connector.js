const pool = require('./dbconnection');
var password = require('password-hash-and-salt');
const jwt = require('jsonwebtoken');

var enc_pswd = [];
var jwttoken = [];
var resultsNotFound = {
  "num_rows": 0,
  "error": true,
  "message": "Operation Failed.",
  "data": []
};
var resultsFound = {
  "num_rows": 1,
  "error": false,
  "message": "Operation Successful.",
  "data": []
};

module.exports = {
  getUser: function (userEmail, req, res) {
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!
      var sql = 'SELECT * FROM `tmp_user` WHERE `userid` = ?';
      // Use the connection
      connection.query(sql, userEmail, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "Something went wrong with Server.";
          resultsNotFound["data"] = [];
          return res.send(resultsNotFound);
        }
        if (results == "") {
          resultsNotFound["message"] = "User Id and Password didn't match.";
          resultsNotFound["data"] = [];
          return res.send(resultsNotFound);
        }
        resultsFound["data"] = results;
        res.send(resultsFound);
        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },

  createUser: function (req, res) {
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!
      password(req.body.enc_password).hash(function (error, hash) {
        if (error)
          throw new Error('Something went wrong!');
        enc_pswd.hash = hash;
      });
      var sql = 'INSERT INTO tmp_user SET ?';
      // jwttoken is fake fieldname for password, which will store encrypted password
      var values = {
        'userid': req.body.email,
        'name': req.body.name,
        'role': 'Guest',
        'jwttoken': enc_pswd.hash,
        'createdAt': new Date(),
        'updatedAt': new Date()
      }
      // Use the connection
      connection.query(sql, values, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "emailID already exists.";
          return res.send(resultsNotFound);
        } else return res.send(resultsFound);
        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
  loginUser: function (req, res) {
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!
      var sql = 'SELECT * FROM `tmp_user` WHERE `userid` = ?';
      // Use the connection
      connection.query(sql, req.body.email, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "Something went wrong with Server.";
          return res.send(resultsNotFound);
        }
        if (results == "") {
          resultsNotFound["message"] = "User Id not found.";
          return res.send(resultsNotFound);
        }
        // Verifying a hash
        password(req.body.enc_password).verifyAgainst(results[0].jwttoken, function (error, verified) {
          if (error) {
            throw new Error('Something went wrong!');
            resultsNotFound["message"] = "Something went wrong!";
            return res.send(resultsNotFound);
          }
          if (!verified) {
            resultsNotFound["message"] = "Incorrect Password.";
            return res.send(resultsNotFound);
          } else {
            resultsFound["data"] = results;
            resultsFound["data"][0]["jwttoken"] = jwt.sign({
                email: req.body.email
              },
              process.env.JWT_SECRET, {
                expiresIn: '30d'
              }
            );
            res.send(resultsFound);
          }
        });
        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
  setUser: function (userEmail, req, res) {
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!
      password(req.body.jwttoken).hash(function (error, hash) {
        if (error)
          throw new Error('Something went wrong!');
        jwttoken.hash = hash;
      });
      var sql = 'UPDATE tmp_user SET ? WHERE `userid` = ?';
      var values = {
        'userid': req.body.userid,
        'name': req.body.name,
        'role': 'Guest',
        'jwttoken': jwttoken.hash,
        'updatedAt': new Date()
      }
      // Use the connection
      connection.query(sql, [values, userEmail], function (error, results, fields) {
        if (error) {
          return res.send(resultsNotFound);
        } else return res.send(resultsFound);
        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
  setData: function (req, res) {
    pool.getConnection(function (err, connection) {
      var sql = "";
      var values = {};
      if (err) throw err; // not connected!
      // check if req data is for which table ie table_name
      if (req.body.table_name == "addressbook") {
        if (req.body.addressid !== undefined) {
          sql = 'UPDATE tmp_addressbook SET ';
          sql = sql + "first_name = '" + req.body.first_name +"'";
          sql = sql + ", middle_name = '" + req.body.middle_name +"'";
          sql = sql + ", last_name = '" + req.body.last_name +"'";
          sql = sql + ", address = '" + req.body.address +"'";
          sql = sql + ", city = '" + req.body.city +"'";
          sql = sql + ", country = '" + req.body.country +"'";
          sql = sql + ", zip_code = '" + req.body.zip_code +"'";
          sql = sql + ", emailid1 = '" + req.body.emailid1 +"'";
          sql = sql + ", emailid2 = '" + req.body.emailid2 +"'";
          sql = sql + ", phone1 = '" + req.body.phone1 +"'";
          sql = sql + ", phone2 = '" + req.body.phone2 +"'";
          sql = sql + ", updatedAt = '" + new Date() +"'";
          sql = sql + ", deleted = 'N'";
          sql = sql + " WHERE addressid = " + req.body.addressid;
          value = {
            "first_name": req.body.first_name,
            "middle_name": req.body.middle_name,
            "last_name": req.body.last_name,
            "address": req.body.address,
            "city": req.body.city,
            "country": req.body.country,
            "zip_code": req.body.zip_code,
            "emailid1": req.body.emailid1,
            "emailid2": req.body.emailid2,
            "phone1": req.body.phone1,
            "phone2": req.body.phone2,
            'updatedAt': new Date(),
            'deleted': "N"
          };
        } else {
          sql = 'INSERT INTO tmp_addressbook SET ?';
          values = {
            "first_name": req.body.first_name,
            "middle_name": req.body.middle_name,
            "last_name": req.body.last_name,
            "address": req.body.address,
            "city": req.body.city,
            "country": req.body.country,
            "zip_code": req.body.zip_code,
            "emailid1": req.body.emailid1,
            "emailid2": req.body.emailid2,
            "phone1": req.body.phone1,
            "phone2": req.body.phone2,
            'createdAt': new Date(),
            'updatedAt': new Date(),
            'deleted': 'N'
          }
        }
      }
      // Use the connection
      connection.query(sql, values, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "Data is NOT updated.";
          return res.send(resultsNotFound);
        } else return res.send(resultsFound);

        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
  getData: function (req, res) {
    var sql = "";
    var values;
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!
      if (req.body._id !== "") {
        sql = 'SELECT * FROM `tmp_addressbook` WHERE deleted = \'N\' AND `addressid` LIKE ?';
        values = req.body._id;
      } else {
        sql = 'SELECT * FROM `tmp_addressbook` WHERE deleted = \'N\' AND `addressid` LIKE ?';
        values = "%";
      }
      if (req.body.srchTxt !== "") {
        sql = 'SELECT * FROM `tmp_addressbook` WHERE deleted = \'N\' AND `first_name` LIKE \''+req.body.srchTxt +'\' OR `last_name` LIKE \''+req.body.srchTxt +'\' OR `phone1` LIKE \''+req.body.srchTxt +'\'';
        values = req.body.srchTxt;
      }
      console.log(sql)
      // Use the connection
      connection.query(sql, values, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "Something went wrong with Server.";
          resultsNotFound["data"] = [];
          return res.send(resultsNotFound);
        }
        if (results == "") {
          resultsNotFound["message"] = "No matching data is found.";
          resultsNotFound["data"] = [];
          return res.send(resultsNotFound);
        }
        resultsFound["data"] = results;
        res.send(resultsFound);
        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
  setLocation: function (userEmail, req, res) {
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!

      var sql = 'INSERT INTO usergps SET ?';
      var values = {
        'lat': req.body.lat,
        'long': req.body.long,
        'email': userEmail,
        'createdAt': new Date()
      }
      // Use the connection
      connection.query(sql, values, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "Data is NOT updated.";
          return res.send(resultsNotFound);
        } else return res.send(resultsFound);

        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
  getLocation: function (input, res) {
    pool.getConnection(function (err, connection) {
      if (err) throw err; // not connected!

      var sql = 'SELECT * FROM `usergps` WHERE `email` = ?';
      var values = [input]
      // Use the connection
      connection.query(sql, values, function (error, results, fields) {
        if (error) {
          resultsNotFound["message"] = "Something went wrong with Server.";
          return res.send(resultsNotFound);
        }
        if (results == "") {
          resultsNotFound["message"] = "User Id not found.";
          return res.send(resultsNotFound);
        }
        resultsFound["data"] = results;
        res.send(resultsFound);
        // When done with the connection, release it.
        connection.release(); // Handle error after the release.
        if (error) throw error; // Don't use the connection here, it has been returned to the pool.
      });
    });
  },
};