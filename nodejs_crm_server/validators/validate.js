const jwt = require('jsonwebtoken');
var resultsNotFound = {
    "num_rows": 0,
    "error": true,
    "message": "Operation Failed.",
    "data": ""
};

module.exports = {
    checkInputDataNULL: function(req, res) {
        // VALIDATE sql INJECTIONS HERE
        resultsNotFound["message"] = "There is no data submitted from Client.";
        if (!req.body) return res.send(resultsNotFound);
    },
    checkInputDataQuality: function(req, res) {
        // VALIDATE sql INJECTIONS HERE
        resultsNotFound["message"] = "There is no data submitted from Client.";
        if (req.body.email == "") return res.send(resultsNotFound);
      },
    checkJWTToken: function(req, res) {
        resultsNotFound["message"] = "Your token in not valid, please logoff and login again.";
        resultsNotFound["data"] = [];
        const token = req.headers.token;
        if (!token) return res.send(resultsNotFound);
        var decoded = jwt.verify(token, process.env.JWT_SECRET, function(err,result){
          if(err) return resultsNotFound;
          return result.email;
        });
        return decoded;
    }
  };