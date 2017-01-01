/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  View,
  Image,
  Button,
  AsyncStorage
} from 'react-native';

import {saveAuthHeaders} from '../app/common.js';
import constants from '../app/config/constants.js';
import Home from './home.js';

export default class LogIn extends Component {
  constructor(props){
    super(props);
    this.login = this.login.bind(this);
    this.state = {
      username: "",
      password: "",
      error: false
    }
  }

  login(){
    var params = {
      email: this.state.email,
      password: this.state.password
    }

    fetch(`${constants.BASE_URL}customer/v1/auth/sign_in`, {
      method: "post",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(params)
    })
      .then((response) => {
        if(response.status == 200){
          saveAuthHeaders(response.headers);
          this.props.navigator.push({id: Home})
        }else{
          this.setState({
            error: true
          })
        };
      })
      .catch((error) => {
        console.error(error);
      });
  }

  render() {
    return (
        <View>
          <TextInput placeholder="Email" onChangeText={(email) => this.setState({email: email})}/>
          <TextInput placeholder="Password" onChangeText={(password) => this.setState({password: password})} secureTextEntry ={true}/>
          {this.state.error && <Text style={styles.error}>Invalid email or password</Text>}
          <Button
            onPress={this.login}
            title="Login"
            color="green"
          />

        </View>
    );
  }
}

var styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    marginTop: 50,
    padding: 20,
    backgroundColor: '#ffffff',
    flex: 1
  },
  title: {
    fontSize: 30,
    alignSelf: 'center',
    marginBottom: 30,
  },
  buttonText: {
    fontSize: 18,
    alignSelf: 'stretch',
    flex: 1
  },
  button: {
    height: 36,
    backgroundColor: '#48BBEC',
    borderColor: '#48BBEC',
    borderWidth: 1,
    borderRadius: 8,
    marginBottom: 10,
    alignSelf: 'stretch',
    justifyContent: 'center'
  },
  error: {
    backgroundColor: "red",
    fontSize: 20
  }
});



// AppRegistry.registerComponent('AwesomeProject', () => AwesomeProject);

