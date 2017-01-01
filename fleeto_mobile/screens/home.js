import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  View,
  Image,
  Button,
  AsyncStorage,
  ActivityIndicator,
  StatusBar
} from 'react-native';

import constants from '../app/config/constants.js';
import MapView from 'react-native-maps';
import LogIn from './log_in.js';
import {logout} from '../app/common.js';
import TimerMixin from 'react-timer-mixin';

var reactMixin = require('react-mixin');
var qs = require('qs');

export default class Home extends React.Component{

  constructor(props){
    super(props);
    this._logout = this._logout.bind(this);
    this.state = {
      loading: true,
      longitude: null,
      latitude: null,
      latitudeDelta: 0.015,
      longitudeDelta: 0.0121,
      drivers: [],
      minDuration: null
    }
  }


  _logout(){
    var self = this;
    logout().then((result) => {
      self.props.navigator.resetTo({id: LogIn})
    })
  }

  saveCurrentLocation(position){
    return AsyncStorage.getItem(constants.AUTH_KEY).then(result => {
      var authHeaders = JSON.parse(result);
      var headers = authHeaders;
      headers['Accept'] = 'application/json';
      headers['Content-Type'] = 'application/json';
      return fetch(`${constants.BASE_URL}customer/v1/locations/set_location`, {
        method: "post",
        headers: headers,
        body: JSON.stringify({
          latitude: position.latitude,
          longitude: position.longitude
        })
      });
    });
  }

  locateNearDrivers(){
    AsyncStorage.getItem(constants.AUTH_KEY).then(result => {
      var authHeaders = JSON.parse(result);
      var headers = authHeaders;
      headers['Accept'] = 'application/json';
      headers['Content-Type'] = 'application/json';
      return fetch(`${constants.BASE_URL}customer/v1/locations/locate_near_drivers`, {
        method: "get",
        headers: headers
      }).then((response) => {
        return response.json();
      }).then((responseJSON) => {
        var drivers = responseJSON.drivers_locations;
        var minDuration = responseJSON.min_duration.text
        this.setState({
          drivers: drivers,
          minDuration: minDuration
        })
      });
    });
  }

  setupWebsocket(){
    var self = this;
    AsyncStorage.getItem(constants.AUTH_KEY).then(result => {
      var authHeaders = JSON.parse(result);
      for(var key in authHeaders){
        if(authHeaders.hasOwnProperty(key)){
          authHeaders[key] = authHeaders[key][0];
        }
      }

      var authHeadersQs = qs.stringify(authHeaders);
      self.ws = new WebSocket(`${constants.WEBSOCKET_URL}?${authHeadersQs}`);

      self.ws.onopen = () => {
        // connection opened
        var subscribeMessage = {
          command: "subscribe",
          identifier: JSON.stringify({
            channel: "CustomersChannel"
          }),
          headers: authHeaders
        };
        self.ws.send(JSON.stringify(subscribeMessage)); // send a message
      };

      self.ws.onmessage = (e) => {
        var data = JSON.parse(e.data);
        if(typeof(data.message) == "object" && data.message.action == "drivers_locations_updated"){
          self.locateNearDrivers();
        }
        // a message was received
        console.log(data);
      };

      self.ws.onerror = (e) => {
        // an error occurred
        console.log(e.data);
      };

      self.ws.onclose = (e) => {
        // connection closed
        console.log(e.code, e.reason);
      };
    });

  }

  componentDidMount(){
    navigator.geolocation.getCurrentPosition((positionInfo) => {
      this.saveCurrentLocation(positionInfo.coords).then(() => {
        this.setState({
          loading: false,
          latitude: positionInfo.coords.latitude,
          longitude: positionInfo.coords.longitude
        });
        this.setInterval(
          () => {this.locateNearDrivers();},
          5000
        );
      });

    }, (error) => {
      alert(JSON.stringify(error));
    },
    {
      // enableHighAccuracy: false,
      timeout: 20000,
      maximumAge: 1000
    }
    );
  }

  render(){
    if(this.state.loading){
      return <ActivityIndicator size="large" color="blue" stlye={[styles.centering, {height: 80}]}/>
    }
    const markers = this.state.drivers.map((driver, index) => (
      <MapView.Marker
        key={index}
        coordinate={driver}
        title="Driver title"
        description="Driver description"
      />));
    return (
      <View style={styles.container}>
        <MapView
          style={styles.map}
          region={{
            latitude: this.state.latitude,
            longitude: this.state.longitude,
            latitudeDelta: this.state.latitudeDelta,
            longitudeDelta: this.state.longitudeDelta,
          }}
          loadingEnabled={true}
          showsMyLocationButton={true}
          onRegionChange={(region) => {
            this.setState({
              latitude: region.latitude,
              longitude: region.longitude,
              latitudeDelta: region.latitudeDelta,
              longitudeDelta: region.longitudeDelta 
            })
          }}
        >
        {markers}
        </MapView>
        <Text style={styles.minDuration}>
          Nearest driver: {this.state.minDuration || "N/A"}
        </Text>
        <Button
          style={styles.logout}
          title="Logout"
          onPress={this._logout}
        />
      </View>
    );
  }
}

reactMixin(Home.prototype, TimerMixin);

const styles = StyleSheet.create({
  container: {
    // position: 'absolute',
    // top: 0,
    // left: 0,
    // right: 0,
    // bottom: 0,
    // justifyContent: 'flex-end',
    // alignItems: 'center',
    flex: 1
  },
  minDuration: {
    flex: 1
  },
  map: {
    // position: 'absolute',
    // top: 0,
    // left: 0,
    flex: 5
  },
  logout:{
    flex: 1,
    color: "gray",
  },
  centering: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 8,
  },
});