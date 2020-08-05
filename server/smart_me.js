const express = require('express');
const bodyParser = require('body-parser');
const protobuf = require('protobufjs');
const fs = require('fs');
const Long = require("long");

(async () => {

  let startTimestamp;
  let status = '';
  let fd; // file pointer

  const app = express();

  app.use(bodyParser.raw());

  app.post('/', function (req, res) {
    // main method to parse smart-meter data
    protobuf.load("smart-me.proto")
    .then(function(root) {
      var DeviceData = root.lookupType("smartMe.DeviceData");
      var data = DeviceData.decode(req.body.slice(3)); // byte 0: type, byte 1+2: length
      // console.log(data);
      // parse only Obis code corresponding to total power (see http://wiki.smart-me.com/index.php/Obis_codes)
      const deviceValues = data.DeviceValues;
      const energy = deviceValues.find( (value) => { 
        return value.Obis.toString('hex') === '0100010700ff';
      });
      const datetime = new Long(data.DateTime.value.low, data.DateTime.value.high)/10000;
      try {
        if (!startTimestamp) {
          startTimestamp = datetime;
        }
        if (fd) {
          fs.appendFileSync(fd, `${datetime}, ${new Date(datetime).toString()}, ${Math.ceil((datetime-startTimestamp))}, ${energy.Value}, ${status}\n`);
        }
        console.log(`${Math.ceil((datetime-startTimestamp))/1000} (${energy.Value}W)`);
      } catch (err) {
        console.log(err);
      }
      res.send('ok');
    }).catch(error => {
      console.log(error);
      res.send('error');
    });
  })
  
  app.use('/status', bodyParser.json()); 
  app.post('/status', function (req, res) {
    console.log(`STATUS: ${req.body.status}`);
    status = req.body.status;
    res.send('ok');
  })

  app.use('/startRecording', bodyParser.json()); 
  app.post('/startRecording', function (req, res) {
    console.log('START RECORD');
    console.log(req.body);
    const filename = req.body.file;
    if (!filename) {
      console.log('NO FILE SPECIFIED');
      res.send('NO FILE SPECIFIED');
      return;
    }
    if (req.body.status) {
      status = req.body.status;
    }
  
    fd = fs.openSync(filename, 'w');
    fs.appendFileSync(fd, `timestamp, date, elapsed time (milliseconds), power (W), status\n`);
    startTimestamp = undefined;
    res.send('ok');

  })

  app.use('/endRecording', bodyParser.json()); 
  app.post('/endRecording', function (req, res) {
    console.log('END RECORD');
    fd.close();
    fd = undefined;
    status = undefined;
    res.send('ok');

  })

  app.listen(3000);
})()
