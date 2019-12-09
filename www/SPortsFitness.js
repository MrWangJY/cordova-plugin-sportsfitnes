var exec = require('cordova/exec');

exports.sportsMethod = function (arg0, success, error) {
    exec(success, error, 'SPortsFitness', 'sportsMethod', [arg0]);
};
