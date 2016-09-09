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
  NativeModules,
  Dimensions,
  ListView,
  Image,
  Animated,
  TouchableOpacity,
  View
} from 'react-native';

const { height,width } = Dimensions.get('window');
export default class MainScreen extends Component {

   constructor(){
     super();
     this.ds = new ListView.DataSource({rowHasChanged: (row1,row2) => row1 !== row2});
     this.showImage = this.showImage.bind(this);
     this.handleImageSelectionInList = this.handleImageSelectionInList.bind(this);
     this. renderRowData = this. renderRowData.bind(this);

     this.state = {
      dataSource : this.ds.cloneWithRows([]),
      selectedImage : '',
      bounceValue: new Animated.Value(0)
    };

   }

   handleImageSelectionInList(){
      if (this.state.selectedImage){
       return(
         <Animated.Image
           style={[styles.preview , {transform: [                        // `transform` is an ordered array
            {scale: this.state.bounceValue},  // Map `bounceValue` to `scale`
          ]}]}
           source={{uri: this.state.selectedImage}}
         />
       )
     }else{
       <View style = {styles.preview} />
     }
   }

   componentDidUpdate(){
     if (this.state.selectedImage){
       this.AnimateImage();
     }
   }

   AnimateImage(){
     this.state.bounceValue.setValue(.95);
     Animated.spring(                          // Base: spring, decay, timing
         this.state.bounceValue,                 // Animate `bounceValue`
         {
           toValue: 1,                         // Animate to smaller size
           friction: 1,                          // Bouncier spring
         }
     ).start();
    }
 showImage(base64Icon,rowID){
this.setState({selectedImage:base64Icon,selectedRow : rowID});
 }
renderRowData(rowData,rowID){
    let base64Icon = 'data:image/png;base64,'+rowData.data ;
    return (
      <TouchableOpacity style = {styles.item} onPress = {() => this.showImage(base64Icon,rowID)}>
          <Image
            style={styles.item}
            source={{uri: base64Icon}}
          />
      </TouchableOpacity>
    )
}
  showImageGallery(){
  let imagePicker = NativeModules.RNImagePicker ;
  imagePicker.launchImageGalleryWithcallback((response) => {
    console.log("response"+response);
    if (response.didCancel){
      //cancelled by user
    }else{
      let firstImage = response[0];
      console.log("extension = "+firstImage.ext);
      this.setState({dataSource : this.ds.cloneWithRows(response),selectedImage : ''});
    }
  });
  }
  render() {
    return (
      <View style={styles.container}>

      {this.handleImageSelectionInList()}

      <ListView contentContainerStyle={styles.rowContainer}
            dataSource={this.state.dataSource}
            enableEmptySections = {true}
            renderRow={(rowData,rowID) =>this. renderRowData(rowData,rowID)}
            />

      <TouchableOpacity onPress = {()=> this.showImageGallery()}>
      <View style = {styles.button}>
        <Text style={styles.welcome}>
          Launch!
        </Text>
      </View>
      </TouchableOpacity>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF',
  },
  preview : {
   width : width ,
   height : height * 0.50 ,
   backgroundColor : 'purple'
 },
  welcome: {
    fontSize: 16,
    textAlign: 'center',
    margin: 10,
    color : 'white'
  },
  rowContainer : {
    flexDirection: 'row',
    flexWrap: 'wrap',
    height : width * 0.75 - 8 ,
    width : width * .98 ,
    left : width * 0.01,
    top :  width * 0.01,
    backgroundColor : 'rgba(4,4,4,0.5)',
    borderRadius : 4
  },
  button : {
    width : 100 ,
    height : 40 ,
    flexDirection : 'column',
    backgroundColor : 'rgba(22,150,136,0.9)',
    borderRadius : 5,
    alignItems : 'center',
    left : width * 0.50 - 50,
    top : -(height - (height * 0.50+width * 0.75 + 54))

  },
  item: {
        margin: 2,
        left : 2  ,
        width: width * 0.25 - 8,
        height : width * 0.25 - 8 ,
        alignItems :'center',

    },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
