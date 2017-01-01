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
  Navigator,
  ActivityIndicator
} from 'react-native';

import LogIn from './screens/log_in.js';
import Home from './screens/home.js';
import {validateAuthToken} from './app/common.js';

export default class FleetoMobile extends Component {
  constructor(props){
    super(props);
    this.state = {
      loading: true
    }
  }

  componentDidMount(){
    validateAuthToken().then((success) => {
      if(success){
        this.initialRoute = {id: Home};
      }else{
        this.initialRoute = {id: LogIn};
      }
      this.setState({
        loading: false
      });
    });
  }

  render() {
    if(this.state.loading){
      return <ActivityIndicator size="large" stlye={[styles.centering, {height: 80}]}/>
    }else{
      return(
        <Navigator
          initialRoute={this.initialRoute}
          renderScene={(route, navigator) => {
            return <route.id navigator={navigator}/>
          }}
        />
      );
    }
  }
}

AppRegistry.registerComponent('fleeto_mobile', () => FleetoMobile);

const styles = StyleSheet.create({
  centering: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 8,
  },
});