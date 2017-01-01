import {AsyncStorage} from 'react-native';
import constants from './config/constants.js';

var saveAuthHeaders = function (headers){
  var authKeys = {
    "access-token": headers.map["access-token"],
    "token-type": headers.map["token-type"],
    "expiry": headers.map["expiry"],
    "uid": headers.map.uid,
    "client": headers.map.client

  }
  AsyncStorage.setItem(constants.AUTH_KEY, JSON.stringify(authKeys));
  AsyncStorage.setItem("loggedIn", JSON.stringify(true));
}

var validateAuthToken = function(){
  return AsyncStorage.getItem(constants.AUTH_KEY).then(result => {
    if(result){
      var resultJSON = JSON.parse(result);
      return fetch(`${constants.BASE_URL}customer/v1/auth/validate_token`, {
        method: "get",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'uid': resultJSON["uid"],
          'client': resultJSON["client"],
          'access-token': resultJSON["access-token"]
        }
      }).then((response) => {
        return response.status == 200;
      });
    }else{
      return false;
    }
  });
}

var logout = function(){
  return AsyncStorage.getItem(constants.AUTH_KEY).then(result => {
    var resultJSON = JSON.parse(result);
    return fetch(`${constants.BASE_URL}customer/v1/auth/sign_out`, {
      method: "delete",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'uid': resultJSON["uid"],
        'client': resultJSON["client"],
        'access-token': resultJSON["access-token"]
      }
    }).then((response) => {
      return response.status == 200;
    });
  });
}

module.exports = {
  saveAuthHeaders: saveAuthHeaders,
  validateAuthToken: validateAuthToken,
  logout: logout
}
